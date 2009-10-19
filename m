Return-Path: <linux-kernel-owner+w=401wt.eu-S1754873AbZJSGeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873AbZJSGeQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 02:34:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754649AbZJSGeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 02:34:15 -0400
Received: from mail-pz0-f197.google.com ([209.85.222.197]:64027 "EHLO
	mail-pz0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754615AbZJSGeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 02:34:13 -0400
X-Greylist: delayed 543 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Oct 2009 02:34:13 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=xnJsY3iZLxCfDpId6r4kMdGgladsIh+BRVBHhfbmZSNh1t/4T4FYFHbGYC5PI57qhB
         9IifAJdHn1NAStJz2dNwGDrxaCAEmjIKRjwms0rD7d6KwoDGjJa+WuY08Z0M4ZHHcqcI
         4AvV7lZrds0TsC5P5bV3+EMCzQOZqrcGissXg=
Date: Mon, 19 Oct 2009 14:28:30 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: marcel@holtmann.org
Cc: oliver@hartkopp.net, netdev@vger.kernel.org,
       linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] bluetooth: static lock key fix
Message-ID: <20091019062830.GB4102@darkstar.vlan7>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When shutdown ppp connection, lockdep waring about non-static key
will happen, it is caused by the lock is not initialized properly
at that time.

Fix with tuning the lock/skb_queue_head init order

[   94.339261] INFO: trying to register non-static key.
[   94.342509] the code is fine but needs lockdep annotation.
[   94.342509] turning off the locking correctness validator.
[   94.342509] Pid: 0, comm: swapper Not tainted 2.6.31-mm1 #2
[   94.342509] Call Trace:
[   94.342509]  [<c0248fbe>] register_lock_class+0x58/0x241
[   94.342509]  [<c024b5df>] ? __lock_acquire+0xb57/0xb73
[   94.342509]  [<c024ab34>] __lock_acquire+0xac/0xb73
[   94.342509]  [<c024b7fa>] ? lock_release_non_nested+0x17b/0x1de
[   94.342509]  [<c024b662>] lock_acquire+0x67/0x84
[   94.342509]  [<c04cd1eb>] ? skb_dequeue+0x15/0x41
[   94.342509]  [<c054a857>] _spin_lock_irqsave+0x2f/0x3f
[   94.342509]  [<c04cd1eb>] ? skb_dequeue+0x15/0x41
[   94.342509]  [<c04cd1eb>] skb_dequeue+0x15/0x41
[   94.342509]  [<c054a648>] ? _read_unlock+0x1d/0x20
[   94.342509]  [<c04cd641>] skb_queue_purge+0x14/0x1b
[   94.342509]  [<fab94fdc>] l2cap_recv_frame+0xea1/0x115a [l2cap]
[   94.342509]  [<c024b5df>] ? __lock_acquire+0xb57/0xb73
[   94.342509]  [<c0249c04>] ? mark_lock+0x1e/0x1c7
[   94.342509]  [<f8364963>] ? hci_rx_task+0xd2/0x1bc [bluetooth]
[   94.342509]  [<fab95346>] l2cap_recv_acldata+0xb1/0x1c6 [l2cap]
[   94.342509]  [<f8364997>] hci_rx_task+0x106/0x1bc [bluetooth]
[   94.342509]  [<fab95295>] ? l2cap_recv_acldata+0x0/0x1c6 [l2cap]
[   94.342509]  [<c02302c4>] tasklet_action+0x69/0xc1
[   94.342509]  [<c022fbef>] __do_softirq+0x94/0x11e
[   94.342509]  [<c022fcaf>] do_softirq+0x36/0x5a
[   94.342509]  [<c022fe14>] irq_exit+0x35/0x68
[   94.342509]  [<c0204ced>] do_IRQ+0x72/0x89
[   94.342509]  [<c02038ee>] common_interrupt+0x2e/0x34
[   94.342509]  [<c024007b>] ? pm_qos_add_requirement+0x63/0x9d
[   94.342509]  [<c038e8a5>] ? acpi_idle_enter_bm+0x209/0x238
[   94.342509]  [<c049d238>] cpuidle_idle_call+0x5c/0x94
[   94.342509]  [<c02023f8>] cpu_idle+0x4e/0x6f
[   94.342509]  [<c0534153>] rest_init+0x53/0x55
[   94.342509]  [<c0781894>] start_kernel+0x2f0/0x2f5
[   94.342509]  [<c0781091>] i386_start_kernel+0x91/0x96

Reported-by: Oliver Hartkopp <oliver@hartkopp.net>
Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Tested-by: Oliver Hartkopp <oliver@hartkopp.net>
---
net/bluetooth/l2cap.c |    9 ++++++---
1 file changed, 6 insertions(+), 3 deletions(-)

--- linux-2.6.31.orig/net/bluetooth/l2cap.c	2009-10-09 08:32:46.000000000 +0800
+++ linux-2.6.31/net/bluetooth/l2cap.c	2009-10-09 08:33:57.000000000 +0800
@@ -555,12 +555,12 @@ static struct l2cap_conn *l2cap_conn_add
 
 	conn->feat_mask = 0;
 
-	setup_timer(&conn->info_timer, l2cap_info_timeout,
-						(unsigned long) conn);
-
 	spin_lock_init(&conn->lock);
 	rwlock_init(&conn->chan_list.lock);
 
+	setup_timer(&conn->info_timer, l2cap_info_timeout,
+						(unsigned long) conn);
+
 	conn->disc_reason = 0x13;
 
 	return conn;
@@ -783,6 +783,9 @@ static void l2cap_sock_init(struct sock 
 	/* Default config options */
 	pi->conf_len = 0;
 	pi->flush_to = L2CAP_DEFAULT_FLUSH_TO;
+	skb_queue_head_init(TX_QUEUE(sk));
+	skb_queue_head_init(SREJ_QUEUE(sk));
+	INIT_LIST_HEAD(SREJ_LIST(sk));
 }
 
 static struct proto l2cap_proto = {
