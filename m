Return-Path: <linux-kernel-owner+w=401wt.eu-S1757214AbXHNV1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757214AbXHNV1n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 17:27:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752277AbXHNVW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 17:22:57 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:38407 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756367AbXHNVWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 17:22:49 -0400
Date: Tue, 14 Aug 2007 23:22:41 +0200
From: Adrian Bunk <bunk@kernel.org>
To: v4l-dvb-maintainer@linuxtv.org
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] dvb_net_ule(): fix check-after-use
Message-ID: <20070814212241.GA18945@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The Coverity checker spotted that we'd have already oops'ed if "dev"
was NULL.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
--- linux-2.6.23-rc1-mm2/drivers/media/dvb/dvb-core/dvb_net.c.old	2007-08-08 06:17:19.000000000 +0200
+++ linux-2.6.23-rc1-mm2/drivers/media/dvb/dvb-core/dvb_net.c	2007-08-08 06:17:35.000000000 +0200
@@ -346,33 +346,28 @@
 static void dvb_net_ule( struct net_device *dev, const u8 *buf, size_t buf_len )
 {
 	struct dvb_net_priv *priv = dev->priv;
 	unsigned long skipped = 0L;
 	const u8 *ts, *ts_end, *from_where = NULL;
 	u8 ts_remain = 0, how_much = 0, new_ts = 1;
 	struct ethhdr *ethh = NULL;
 
 #ifdef ULE_DEBUG
 	/* The code inside ULE_DEBUG keeps a history of the last 100 TS cells processed. */
 	static unsigned char ule_hist[100*TS_SZ];
 	static unsigned char *ule_where = ule_hist, ule_dump = 0;
 #endif
 
-	if (dev == NULL) {
-		printk( KERN_ERR "NO netdev struct!\n" );
-		return;
-	}
-
 	/* For all TS cells in current buffer.
 	 * Appearently, we are called for every single TS cell.
 	 */
 	for (ts = buf, ts_end = buf + buf_len; ts < ts_end; /* no default incr. */ ) {
 
 		if (new_ts) {
 			/* We are about to process a new TS cell. */
 
 #ifdef ULE_DEBUG
 			if (ule_where >= &ule_hist[100*TS_SZ]) ule_where = ule_hist;
 			memcpy( ule_where, ts, TS_SZ );
 			if (ule_dump) {
 				hexdump( ule_where, TS_SZ );
 				ule_dump = 0;

