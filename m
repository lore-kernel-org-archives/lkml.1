Return-Path: <linux-kernel-owner+w=401wt.eu-S1766014AbXH0Vic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766014AbXH0Vic (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765448AbXH0V25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:28:57 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:58854 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765435AbXH0V24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:28:56 -0400
Date: Mon, 27 Aug 2007 23:28:53 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] n_hdlc.c: fix check-after-use
Message-ID: <20070827212853.GB26410@stusta.de>
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

This patch has been sent on:
- 14 Aug 2007

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
