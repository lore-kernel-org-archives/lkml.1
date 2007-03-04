Return-Path: <linux-kernel-owner+w=401wt.eu-S1751800AbXCDPMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800AbXCDPMa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 10:12:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751784AbXCDPMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 10:12:30 -0500
Received: from rtr.ca ([64.26.128.89]:2909 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751769AbXCDPMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 10:12:21 -0500
Message-ID: <45EAE1D6.10900@rtr.ca>
Date: Sun, 04 Mar 2007 10:12:22 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Mark Lord <lkml@rtr.ca>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       bluez-devel@lists.sourceforge.net, marcel@holtmann.org,
       Andrew Morton <akpm@osdl.org>,
       "David S. Miller" <davem@sunset.davemloft.net>
Subject: Re: [Regression] Bluetooth RFComm:  using it locks up the machine
References: <45EADD78.1030300@rtr.ca>
In-Reply-To: <45EADD78.1030300@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Any attempt to open/use a bluetooth rfcomm device locks up
> scheduling completely on my machine.
> 
> Interrupts (ping, alt-sysrq) seem to be alive, but nothing else.
> 
> This was working fine in 2.6.20, broken now in 2.6.21-rc2-git*

Further info:  Reverting this change (below) fixes it:

| author	Marcel Holtmann <marcel@holtmann.org>
| 	 Sat, 17 Feb 2007 22:58:57 +0000 (23:58 +0100)
| committer	David S. Miller <davem@sunset.davemloft.net>
| 	 Mon, 26 Feb 2007 19:42:41 +0000 (11:42 -0800)
| commit	c1a3313698895d8ad4760f98642007bf236af2e8
| tree	337a876f727061362b6a169f8759849c105b8f7a	tree | snapshot
| parent	f5ffd4620aba9e55656483ae1ef5c79ba81f5403	commit | diff
| 
| [Bluetooth] Make use of device_move() for RFCOMM TTY devices
| 
| In the case of bound RFCOMM TTY devices the parent is not available
| before its usage. So when opening a RFCOMM TTY device, move it to
| the corresponding ACL device as a child. When closing the device,
| move it back to the virtual device tree.
| Signed-off-by: Marcel Holtmann <marcel@holtmann.org>

Specifically, I reverted these changes, below, to fix it:

--- 2.6.20/net/bluetooth/rfcomm/tty.c	2007-02-04 13:44:54.000000000 -0500
+++ 2.6.21/net/bluetooth/rfcomm/tty.c	2007-03-02 15:06:32.000000000 -0500
@@ -74,6 +74,8 @@
 	wait_queue_head_t       wait;
 	struct tasklet_struct   wakeup_task;
 
+	struct device		*tty_dev;
+
 	atomic_t 		wmem_alloc;
 };
 
@@ -261,7 +263,7 @@
 		return err;
 	}
 
-	tty_register_device(rfcomm_tty_driver, dev->id, rfcomm_get_device(dev));
+	dev->tty_dev = tty_register_device(rfcomm_tty_driver, dev->id, NULL);
 
 	return dev->id;
 }
@@ -630,6 +632,9 @@
 	set_current_state(TASK_RUNNING);
 	remove_wait_queue(&dev->wait, &wait);
 
+	if (err == 0)
+		device_move(dev->tty_dev, rfcomm_get_device(dev));
+
 	return err;
 }
 
@@ -642,6 +647,8 @@
 	BT_DBG("tty %p dev %p dlc %p opened %d", tty, dev, dev->dlc, dev->opened);
 
 	if (--dev->opened == 0) {
+		device_move(dev->tty_dev, NULL);
+
 		/* Close DLC and dettach TTY */
 		rfcomm_dlc_close(dev->dlc, 0);
 
