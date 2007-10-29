Return-Path: <linux-kernel-owner+w=401wt.eu-S1757338AbXJ2Gcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757338AbXJ2Gcy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 02:32:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752209AbXJ2Gcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 02:32:42 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:42783 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757253AbXJ2Gcl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 02:32:41 -0400
Message-ID: <47257E6D.30403@sw.ru>
Date: Mon, 29 Oct 2007 09:32:13 +0300
From: Vasily Averin <vvs@sw.ru>
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, devel@openvz.org
CC: Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: i2o: CONFIG_DEBUG_SG compilation fixed
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

i2o crashed when CONFIG_DEBUG_SG is enabled because i2o_block_request structure
includes array of scatterlists that should be initialised

Signed-off-by:	Vasily Averin <vvs@sw.ru>
--- a/drivers/message/i2o/i2o_block.c
+++ b/drivers/message/i2o/i2o_block.c
@@ -1137,6 +1137,18 @@ static struct i2o_driver i2o_block_driver = {
  *
  *	Returns 0 on success or negative error code on failure.
  */
+
+#ifdef CONFIG_DEBUG_SG
+static void i2o_block_req_ctor(struct kmem_cache *cachep, void *objp) {
+	sg_init_table(((struct i2o_block_request *)(objp))->sg_table,
+						 I2O_MAX_PHYS_SEGMENTS);
+}
+
+#define I2O_BLK_CTOR	&i2o_block_req_ctor
+#else
+#define I2O_BLK_CTOR	NULL
+#endif
+
 static int __init i2o_block_init(void)
 {
 	int rc;
@@ -1147,7 +1159,7 @@ static int __init i2o_block_init(void)
 	/* Allocate request mempool and slab */
 	size = sizeof(struct i2o_block_request);
 	i2o_blk_req_pool.slab = kmem_cache_create("i2o_block_req", size, 0,
-						  SLAB_HWCACHE_ALIGN, NULL);
+					  SLAB_HWCACHE_ALIGN, I2O_BLK_CTOR);
 	if (!i2o_blk_req_pool.slab) {
 		osm_err("can't init request slab\n");
 		rc = -ENOMEM;

