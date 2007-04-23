Return-Path: <linux-kernel-owner+w=401wt.eu-S1754302AbXDWV6O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302AbXDWV6O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 17:58:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754301AbXDWV6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 17:58:14 -0400
Received: from twin.jikos.cz ([213.151.79.26]:47355 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754302AbXDWV6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 17:58:13 -0400
Date: Mon, 23 Apr 2007 23:56:39 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Greg KH <gregkh@suse.de>, Marcel Holtmann <marcel@holtmann.org>,
       maxk@qualcomm.com, bluez-devel@lists.sourceforge.net,
       Cedric Le Goater <clg@fr.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc7: BUG: sleeping function called from invalid context
 at net/core/sock.c:1523
In-Reply-To: <462D1B09.9050005@goop.org>
Message-ID: <Pine.LNX.4.64.0704232257090.20657@twin.jikos.cz>
References: <462D1B09.9050005@goop.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Apr 2007, Jeremy Fitzhardinge wrote:

> I got this on resume; it looks like a Bluetooth and/or USB problem.
> PM: Removing info for No Bus:hci0
> BUG: sleeping function called from invalid context at net/core/sock.c:1523
> in_atomic():1, irqs_disabled():0
> 1 lock held by khubd/180:
>  #0:  (old_style_rw_init#2){-.-?}, at: [<f88c5816>] hci_sock_dev_event+0x42/0xc5 [bluetooth]
>  [<c01091b5>] show_trace_log_lvl+0x1a/0x30
>  [<c010980c>] show_trace+0x12/0x14
>  [<c01098cb>] dump_stack+0x16/0x18
>  [<c0124191>] __might_sleep+0xe5/0xeb
>  [<c0309ece>] lock_sock_nested+0x1d/0xc4
>  [<f88c587b>] hci_sock_dev_event+0xa7/0xc5 [bluetooth]
>  [<c037c8d2>] notifier_call_chain+0x20/0x3c
>  [<c037c915>] atomic_notifier_call_chain+0x27/0x50
>  [<f88c1a55>] hci_notify+0x12/0x14 [bluetooth]
>  [<f88c2626>] hci_unregister_dev+0x4c/0x65 [bluetooth]
>  [<f89f5d38>] hci_usb_disconnect+0x42/0x6f [hci_usb]
>  [<c02d7e49>] usb_unbind_interface+0x33/0x69
>  [<c028f3fa>] __device_release_driver+0x74/0x90
>  [<c028f870>] device_release_driver+0x33/0x4b
>  [<c028ee0f>] bus_remove_device+0x73/0x82
>  [<c028d412>] device_del+0x169/0x1cf
>  [<c02d5c00>] usb_disable_device+0x62/0xc2
>  [<c02d2807>] usb_disconnect+0x95/0x114
>  [<c02d34d8>] hub_thread+0x2e2/0x99b
>  [<c013c8f7>] kthread+0xb5/0xe2
>  [<c0108d97>] kernel_thread_helper+0x7/0x10
>  =======================
> PM: Removing info for usb:4-1:1.0

OK, this probably started happening since b40df5743. Before that commit, 
hci_sock_dev_event() used bh_lock_sock() to lock the corresponding struct 
sock. This was obviously buggy - not deadlock safe against 
l2cap_connect_cfm() from softirq context.

This however introduced another problem - hci_sock_dev_event() is now 
obviously being triggered (for HCI_DEV_UNREG event, when suspending) in 
atomic context with preemption disabled. This is what lock_sock_nested() 
complains about, as it is allowed to sleep inside __lock_sock(), waiting 
for the lock owner.

Hmm, *sigh*. I guess the patch below fixes the problem, but it is a 
masterpiece in the field of ugliness. And I am not sure whether it is 
completely correct either. Are there any immediate ideas for better 
solution with respect to how struct sock locking works?

diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
index 71f5cfb..c5c93cd 100644
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -656,7 +656,10 @@ static int hci_sock_dev_event(struct notifier_block *this, unsigned long event,
 		/* Detach sockets from device */
 		read_lock(&hci_sk_list.lock);
 		sk_for_each(sk, node, &hci_sk_list.head) {
-			lock_sock(sk);
+			if (in_atomic())
+				bh_lock_sock(sk);
+			else
+				lock_sock(sk);
 			if (hci_pi(sk)->hdev == hdev) {
 				hci_pi(sk)->hdev = NULL;
 				sk->sk_err = EPIPE;
@@ -665,7 +668,10 @@ static int hci_sock_dev_event(struct notifier_block *this, unsigned long event,
 
 				hci_dev_put(hdev);
 			}
-			release_sock(sk);
+			if (in_atomic())
+				bh_unlock_sock(sk);
+			else
+				release_sock(sk);
 		}
 		read_unlock(&hci_sk_list.lock);
 	}
