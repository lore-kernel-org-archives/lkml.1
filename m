Return-Path: <linux-kernel-owner+w=401wt.eu-S1751822AbZL0MRK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822AbZL0MRK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 07:17:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751683AbZL0MRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 07:17:08 -0500
Received: from www84.your-server.de ([213.133.104.84]:38359 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbZL0MRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 07:17:07 -0500
Subject: [patch] ported drivers/video/omap2/dss/rfbi.c to new kfifo API
From: Stefani Seibold <stefani@seibold.net>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Greg KH <greg@kroah.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Sun, 27 Dec 2009 13:16:58 +0100
Message-ID: <1261916218.21787.4.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch ported the drivers/video/omap2/dss/rfbi.c to the new kfifo API.
This should be the last one ;-)

The patch-set is against mm tree from 11-Dec-2009

Greetings,
Stefani

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 rfbi.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

--- mmotm.orig/drivers/video/omap2/dss/rfbi.c	2009-12-27 13:04:16.495740629 +0100
+++ mmotm.new/drivers/video/omap2/dss/rfbi.c	2009-12-27 13:08:50.188701965 +0100
@@ -120,7 +120,7 @@ static struct {
 
 	struct omap_dss_device *dssdev[2];
 
-	struct kfifo      *cmd_fifo;
+	struct kfifo      cmd_fifo;
 	spinlock_t        cmd_lock;
 	struct completion cmd_done;
 	atomic_t          cmd_fifo_full;
@@ -1013,8 +1013,9 @@ static void process_cmd_fifo(void)
 	while (true) {
 		spin_lock_irqsave(rfbi.cmd_fifo->lock, flags);
 
-		len = __kfifo_get(rfbi.cmd_fifo, (unsigned char *)&p,
-				  sizeof(struct update_param));
+		len = kfifo_out_locked(&rfbi.cmd_fifo, (unsigned char *)&p,
+				  sizeof(struct update_param),
+				  &rfbi.cmd_lock);
 		if (len == 0) {
 			DSSDBG("nothing more in fifo\n");
 			atomic_set(&rfbi.cmd_pending, 0);
@@ -1053,8 +1054,7 @@ static void rfbi_push_cmd(struct update_
 		int available;
 
 		spin_lock_irqsave(rfbi.cmd_fifo->lock, flags);
-		available = RFBI_CMD_FIFO_LEN_BYTES -
-			__kfifo_len(rfbi.cmd_fifo);
+		available = kfifo_avail(&rfbi.cmd_fifo);
 
 /*		DSSDBG("%d bytes left in fifo\n", available); */
 		if (available < sizeof(struct update_param)) {
@@ -1066,8 +1066,9 @@ static void rfbi_push_cmd(struct update_
 			continue;
 		}
 
-		ret = __kfifo_put(rfbi.cmd_fifo, (unsigned char *)p,
-				  sizeof(struct update_param));
+		ret = kfifo_in_locked(&rfbi.cmd_fifo, (unsigned char *)p,
+				  sizeof(struct update_param),
+				  &rfbi.cmd_lock);
 /*		DSSDBG("pushed %d bytes\n", ret);*/
 
 		spin_unlock_irqrestore(rfbi.cmd_fifo->lock, flags);
@@ -1157,9 +1158,7 @@ int rfbi_init(void)
 	u32 l;
 
 	spin_lock_init(&rfbi.cmd_lock);
-	rfbi.cmd_fifo = kfifo_alloc(RFBI_CMD_FIFO_LEN_BYTES, GFP_KERNEL,
-				    &rfbi.cmd_lock);
-	if (IS_ERR(rfbi.cmd_fifo))
+	if (kfifo_alloc(&rfbi.cmd_fifo, RFBI_CMD_FIFO_LEN_BYTES, GFP_KERNEL))
 		return -ENOMEM;
 
 	init_completion(&rfbi.cmd_done);
@@ -1196,7 +1195,7 @@ void rfbi_exit(void)
 {
 	DSSDBG("rfbi_exit\n");
 
-	kfifo_free(rfbi.cmd_fifo);
+	kfifo_free(&rfbi.cmd_fifo);
 
 	iounmap(rfbi.base);
 }


