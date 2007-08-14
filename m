Return-Path: <linux-kernel-owner+w=401wt.eu-S1758308AbXHNV22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758308AbXHNV22 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 17:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756520AbXHNVW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 17:22:59 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:38406 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752095AbXHNVWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 17:22:48 -0400
Date: Tue, 14 Aug 2007 23:22:39 +0200
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] drivers/char/n_hdlc.c: fix check-after-use
Message-ID: <20070814212239.GZ18945@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The Coverity checker spotted that we'd have already oops'ed if "tty"
was NULL.

Since "tty" can't be NULL when we reach this line of code this patch 
removes the NULL check.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
--- linux-2.6.23-rc1-mm2/drivers/char/n_hdlc.c.old	2007-08-08 06:11:02.000000000 +0200
+++ linux-2.6.23-rc1-mm2/drivers/char/n_hdlc.c	2007-08-08 06:11:15.000000000 +0200
@@ -220,25 +220,25 @@
 static void n_hdlc_release(struct n_hdlc *n_hdlc)
 {
 	struct tty_struct *tty = n_hdlc2tty (n_hdlc);
 	struct n_hdlc_buf *buf;
 	
 	if (debuglevel >= DEBUG_LEVEL_INFO)	
 		printk("%s(%d)n_hdlc_release() called\n",__FILE__,__LINE__);
 		
 	/* Ensure that the n_hdlcd process is not hanging on select()/poll() */
 	wake_up_interruptible (&tty->read_wait);
 	wake_up_interruptible (&tty->write_wait);
 
-	if (tty != NULL && tty->disc_data == n_hdlc)
+	if (tty->disc_data == n_hdlc)
 		tty->disc_data = NULL;	/* Break the tty->n_hdlc link */
 
 	/* Release transmit and receive buffers */
 	for(;;) {
 		buf = n_hdlc_buf_get(&n_hdlc->rx_free_buf_list);
 		if (buf) {
 			kfree(buf);
 		} else
 			break;
 	}
 	for(;;) {
 		buf = n_hdlc_buf_get(&n_hdlc->tx_free_buf_list);
