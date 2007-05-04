Return-Path: <linux-kernel-owner+w=401wt.eu-S932950AbXEDLbF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932950AbXEDLbF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 07:31:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933046AbXEDLbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 07:31:05 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:47122 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932950AbXEDLbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 07:31:01 -0400
Subject: [PATCH 3/5] jffs2: Add a "favourlzo" compression mode to jffs2
From: Richard Purdie <rpurdie@openedhand.com>
To: LKML <linux-kernel@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd <linux-mtd@lists.infradead.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Satyam Sharma <satyam.sharma@gmail.com>
Content-Type: text/plain
Date: Fri, 04 May 2007 12:30:48 +0100
Message-Id: <1178278248.5839.45.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add a "favourlzo" compression mode to jffs2 which tries to
optimise by size but gives lzo an advantage when comparing sizes.
This means the faster lzo algorithm can be preferred when there
isn't much difference in compressed size (the exact threshold can
be changed).

Signed-off-by: Richard Purdie <rpurdie@openedhand.com>
---
 fs/Kconfig       |    7 ++++++
 fs/jffs2/compr.c |   56 ++++++++++++++++++++++++++++++++++++++++++++---------
 fs/jffs2/compr.h |    3 ++
 3 files changed, 56 insertions(+), 10 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index 421c821..b8d2c58 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -1360,6 +1360,13 @@ config JFFS2_CMODE_SIZE
           Tries all compressors and chooses the one which has the smallest
           result.
 
+config JFFS2_CMODE_FAVOURLZO
+	bool "Favour LZO"
+	help
+	  Tries all compressors and chooses the one which has the smallest
+	  result but gives some preference to LZO (which has faster
+	  decompression) at the expense of size.
+
 endchoice
 
 config CRAMFS
diff --git a/fs/jffs2/compr.c b/fs/jffs2/compr.c
index 6a23408..477ec97 100644
--- a/fs/jffs2/compr.c
+++ b/fs/jffs2/compr.c
@@ -24,6 +24,34 @@ static int jffs2_compression_mode = JFFS2_COMPR_MODE_PRIORITY;
 /* Statistics for blocks stored without compression */
 static uint32_t none_stat_compr_blocks=0,none_stat_decompr_blocks=0,none_stat_compr_size=0;
 
+
+/*
+ * Return 1 to use this compression
+ */
+static int jffs2_is_best_compression(struct jffs2_compressor *this,
+		struct jffs2_compressor *best, uint32_t size, uint32_t bestsize)
+{
+	switch (jffs2_compression_mode) {
+	case JFFS2_COMPR_MODE_SIZE:
+		if (bestsize > size)
+			return 1;
+		return 0;
+	case JFFS2_COMPR_MODE_FAVOURLZO:
+		if ((this->compr == JFFS2_COMPR_LZO) && (bestsize > size))
+			return 1;
+		if ((best->compr != JFFS2_COMPR_LZO) && (bestsize > size))
+			return 1;
+		if ((this->compr == JFFS2_COMPR_LZO) && 
+				(bestsize > (size * FAVOUR_LZO_PERCENT / 100)))
+			return 1;
+		if ((bestsize * FAVOUR_LZO_PERCENT / 100) > size)
+			return 1;
+		return 0;
+	}
+	/* Shouldn't happen */
+	return 0;
+}
+
 /* jffs2_compress:
  * @data: Pointer to uncompressed data
  * @cdata: Pointer to returned pointer to buffer for compressed data
@@ -89,6 +117,7 @@ uint16_t jffs2_compress(struct jffs2_sb_info *c, struct jffs2_inode_info *f,
                 if (ret == JFFS2_COMPR_NONE) kfree(output_buf);
                 break;
         case JFFS2_COMPR_MODE_SIZE:
+        case JFFS2_COMPR_MODE_FAVOURLZO:
                 orig_slen = *datalen;
                 orig_dlen = *cdatalen;
                 spin_lock(&jffs2_compressor_list_lock);
@@ -97,7 +126,7 @@ uint16_t jffs2_compress(struct jffs2_sb_info *c, struct jffs2_inode_info *f,
                         if ((!this->compress)||(this->disabled))
                                 continue;
                         /* Allocating memory for output buffer if necessary */
-                        if ((this->compr_buf_size<orig_dlen)&&(this->compr_buf)) {
+                        if ((this->compr_buf_size<orig_slen)&&(this->compr_buf)) {
                                 spin_unlock(&jffs2_compressor_list_lock);
                                 kfree(this->compr_buf);
                                 spin_lock(&jffs2_compressor_list_lock);
@@ -106,15 +135,17 @@ uint16_t jffs2_compress(struct jffs2_sb_info *c, struct jffs2_inode_info *f,
                         }
                         if (!this->compr_buf) {
                                 spin_unlock(&jffs2_compressor_list_lock);
-                                tmp_buf = kmalloc(orig_dlen,GFP_KERNEL);
+                                tmp_buf = kmalloc(orig_slen, GFP_KERNEL);
                                 spin_lock(&jffs2_compressor_list_lock);
                                 if (!tmp_buf) {
-                                        printk(KERN_WARNING "JFFS2: No memory for compressor allocation. (%d bytes)\n",orig_dlen);
+                                        printk(KERN_WARNING 
+						"JFFS2: No memory for compressor allocation."
+						" (%d bytes)\n", orig_slen);
                                         continue;
                                 }
                                 else {
                                         this->compr_buf = tmp_buf;
-                                        this->compr_buf_size = orig_dlen;
+                                        this->compr_buf_size = orig_slen;
                                 }
                         }
                         this->usecount++;
@@ -124,12 +155,12 @@ uint16_t jffs2_compress(struct jffs2_sb_info *c, struct jffs2_inode_info *f,
                         compr_ret = this->compress(data_in, this->compr_buf, datalen, cdatalen, NULL);
                         spin_lock(&jffs2_compressor_list_lock);
                         this->usecount--;
-                        if (!compr_ret) {
-                                if ((!best_dlen)||(best_dlen>*cdatalen)) {
-                                        best_dlen = *cdatalen;
-                                        best_slen = *datalen;
-                                        best = this;
-                                }
+                        if ((!compr_ret) && (((!best_dlen) 
+					|| jffs2_is_best_compression(this, best, *cdatalen, best_dlen))
+					&& (*cdatalen < *datalen))) {
+				best_dlen = *cdatalen;
+				best_slen = *datalen;
+				best = this;
                         }
                 }
                 if (best_dlen) {
@@ -297,9 +328,14 @@ int __init jffs2_compressors_init(void)
         jffs2_compression_mode = JFFS2_COMPR_MODE_SIZE;
         D1(printk(KERN_INFO "JFFS2: default compression mode: size\n");)
 #else
+#ifdef CONFIG_JFFS2_CMODE_FAVOURLZO
+        jffs2_compression_mode = JFFS2_COMPR_MODE_FAVOURLZO;
+        D1(printk(KERN_INFO "JFFS2: default compression mode: favourlzo\n");)
+#else
         D1(printk(KERN_INFO "JFFS2: default compression mode: priority\n");)
 #endif
 #endif
+#endif
         return 0;
 }
 
diff --git a/fs/jffs2/compr.h b/fs/jffs2/compr.h
index 8c6b2af..2b66941 100644
--- a/fs/jffs2/compr.h
+++ b/fs/jffs2/compr.h
@@ -38,6 +38,9 @@
 #define JFFS2_COMPR_MODE_NONE       0
 #define JFFS2_COMPR_MODE_PRIORITY   1
 #define JFFS2_COMPR_MODE_SIZE       2
+#define JFFS2_COMPR_MODE_FAVOURLZO  3
+
+#define FAVOUR_LZO_PERCENT 80
 
 struct jffs2_compressor {
         struct list_head list;


