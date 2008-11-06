Return-Path: <linux-kernel-owner+w=401wt.eu-S1752567AbYKFTTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567AbYKFTTm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 14:19:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751306AbYKFTTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 14:19:33 -0500
Received: from rv-out-0506.google.com ([209.85.198.231]:25406 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbYKFTTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 14:19:32 -0500
Date: Thu, 6 Nov 2008 11:19:11 -0800
From: Brandon Philips <brandon@ifup.org>
To: oliver@neukum.org, stern@rowland.harvard.edu
Cc: dave@awk.cz, linux-usb@vger.kernel.org, stable@kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] cdc-acm.c: fix recursive lock in acm_start_wb error path
Message-ID: <20081106191911.GC10726@plankton.ifup.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes an obvious bug in cdc-acm by avoiding a recursive lock on
acm_start_wb()'s error path. Should apply towards 2.6.27 stable and
2.6.28.

=============================================
[ INFO: possible recursive locking detected ]
2.6.27-2-pae #109
---------------------------------------------
python/31449 is trying to acquire lock:
 (&acm->write_lock){++..}, at: [<f89a0348>] acm_start_wb+0x5c/0x7b [cdc_acm]

but task is already holding lock:
 (&acm->write_lock){++..}, at: [<f89a04fb>] acm_tty_write+0xe1/0x167 [cdc_acm]

other info that might help us debug this:
2 locks held by python/31449:
 #0:  (&tty->atomic_write_lock){--..}, at: [<c0260fae>] tty_write_lock+0x14/0x3b
 #1:  (&acm->write_lock){++..}, at: [<f89a04fb>] acm_tty_write+0xe1/0x167 [cdc_acm]

stack backtrace:
Pid: 31449, comm: python Not tainted 2.6.27-2-pae #109
 [<c030f42f>] ? printk+0xf/0x18
 [<c0149f33>] __lock_acquire+0xc7b/0x1316
 [<c014a63e>] lock_acquire+0x70/0x97
 [<f89a0348>] ? acm_start_wb+0x5c/0x7b [cdc_acm]
 [<c0312109>] _spin_lock_irqsave+0x37/0x47
 [<f89a0348>] ? acm_start_wb+0x5c/0x7b [cdc_acm]
 [<f89a0348>] acm_start_wb+0x5c/0x7b [cdc_acm]
 [<f89a055d>] acm_tty_write+0x143/0x167 [cdc_acm]
 [<c0262a98>] write_chan+0x1cd/0x297
 [<c012527e>] ? default_wake_function+0x0/0xd
 [<c026111e>] tty_write+0x149/0x1b9
 [<c02628cb>] ? write_chan+0x0/0x297
 [<c01912c5>] ? rw_verify_area+0x76/0x98
 [<c0260fd5>] ? tty_write+0x0/0x1b9
 [<c01919ba>] vfs_write+0x8c/0x136
 [<c0191afd>] sys_write+0x3b/0x60
 [<c0103beb>] sysenter_do_call+0x12/0x3f
 =======================

Signed-off-by: Brandon Philips <bphilips@suse.de>

---
 drivers/usb/class/cdc-acm.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

Index: linux-2.6/drivers/usb/class/cdc-acm.c
===================================================================
--- linux-2.6.orig/drivers/usb/class/cdc-acm.c
+++ linux-2.6/drivers/usb/class/cdc-acm.c
@@ -158,16 +158,12 @@ static int acm_wb_is_avail(struct acm *a
 }
 
 /*
- * Finish write.
+ * Finish write. Caller must hold acm->write_lock
  */
 static void acm_write_done(struct acm *acm, struct acm_wb *wb)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&acm->write_lock, flags);
 	wb->use = 0;
 	acm->transmitting--;
-	spin_unlock_irqrestore(&acm->write_lock, flags);
 }
 
 /*
@@ -482,6 +478,7 @@ static void acm_write_bulk(struct urb *u
 {
 	struct acm_wb *wb = urb->context;
 	struct acm *acm = wb->instance;
+	unsigned long flags;
 
 	if (verbose || urb->status
 			|| (urb->actual_length != urb->transfer_buffer_length))
@@ -490,7 +487,9 @@ static void acm_write_bulk(struct urb *u
 			urb->transfer_buffer_length,
 			urb->status);
 
+	spin_lock_irqsave(&acm->write_lock, flags);
 	acm_write_done(acm, wb);
+	spin_unlock_irqrestore(&acm->write_lock, flags);
 	if (ACM_READY(acm))
 		schedule_work(&acm->work);
 	else
