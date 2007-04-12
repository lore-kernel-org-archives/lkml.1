Return-Path: <linux-kernel-owner+w=401wt.eu-S1161516AbXDLC5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161516AbXDLC5n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 22:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161549AbXDLC5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 22:57:04 -0400
Received: from qb-out-0506.google.com ([72.14.204.239]:54681 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161517AbXDLCwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 22:52:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:date:message-id:in-reply-to:subject;
        b=dIyr7z51C6LP2MbyPKe2wKWyQbDQZkhxiKdtmQK72ZfBA8wnPT5PinTNc9Ke4L+DtWDdbFMjDd5YW5O1m7m3kW/Wd1fkNP15vQy6T85UM3qXe6JibbN/qrfgnAKjEjf3w13ZGReYt8Wf+nSunfzb7dejM4Pm3Ie0huIE4OLO+MA=
From: Nate Diller <nate.diller@gmail.com>
To: Andrew Morton <akpm@osdl.org>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
       David Woodhouse <dwmw2@infradead.org>,
       Dave Kleikamp <shaggy@austin.ibm.com>,
       Anton Altaparmakov <aia21@cantab.net>,
       Evgeniy Dushistov <dushistov@mail.ru>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       reiserfs-dev@namesys.com
Date: Wed, 11 Apr 2007 19:49:38 -0700
Message-Id: <20070412024938.27380.13619.patchbomb.py@localhost>
In-Reply-To: <20070412024938.27380.54538.patchbomb.py@localhost>
Subject: [PATCH 7/17] jffs2: convert jffs2_gc_fetch_page to read_cache_page
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Replace jffs2_gc_fetch_page() and jffs2_gc_release_page() using the
read_cache_page() and put_kmapped_page() calls, and update the call site
accordingly.  Explicit calls to kmap()/kunmap() make the code more clear.

Signed-off-by: Nate Diller <nate.diller@gmail.com>

---

diff -urpN -X dontdiff linux-2.6.21-rc5-mm4/fs/jffs2/fs.c linux-2.6.21-rc5-mm4-test/fs/jffs2/fs.c
--- linux-2.6.21-rc5-mm4/fs/jffs2/fs.c	2007-04-05 17:14:25.000000000 -0700
+++ linux-2.6.21-rc5-mm4-test/fs/jffs2/fs.c	2007-04-06 01:59:19.000000000 -0700
@@ -621,33 +621,6 @@ struct jffs2_inode_info *jffs2_gc_fetch_
 	return JFFS2_INODE_INFO(inode);
 }
 
-unsigned char *jffs2_gc_fetch_page(struct jffs2_sb_info *c,
-				   struct jffs2_inode_info *f,
-				   unsigned long offset,
-				   unsigned long *priv)
-{
-	struct inode *inode = OFNI_EDONI_2SFFJ(f);
-	struct page *pg;
-
-	pg = read_cache_page(inode->i_mapping, offset >> PAGE_CACHE_SHIFT,
-			     (void *)jffs2_do_readpage_unlock, inode);
-	if (IS_ERR(pg))
-		return (void *)pg;
-
-	*priv = (unsigned long)pg;
-	return kmap(pg);
-}
-
-void jffs2_gc_release_page(struct jffs2_sb_info *c,
-			   unsigned char *ptr,
-			   unsigned long *priv)
-{
-	struct page *pg = (void *)*priv;
-
-	kunmap(pg);
-	page_cache_release(pg);
-}
-
 static int jffs2_flash_setup(struct jffs2_sb_info *c) {
 	int ret = 0;
 
diff -urpN -X dontdiff linux-2.6.21-rc5-mm4/fs/jffs2/gc.c linux-2.6.21-rc5-mm4-test/fs/jffs2/gc.c
--- linux-2.6.21-rc5-mm4/fs/jffs2/gc.c	2007-04-05 17:13:10.000000000 -0700
+++ linux-2.6.21-rc5-mm4-test/fs/jffs2/gc.c	2007-04-06 01:59:19.000000000 -0700
@@ -1078,7 +1078,7 @@ static int jffs2_garbage_collect_dnode(s
 	uint32_t alloclen, offset, orig_end, orig_start;
 	int ret = 0;
 	unsigned char *comprbuf = NULL, *writebuf;
-	unsigned long pg;
+	struct page *page;
 	unsigned char *pg_ptr;
 
 	memset(&ri, 0, sizeof(ri));
@@ -1219,12 +1219,16 @@ static int jffs2_garbage_collect_dnode(s
 	 *    page OK. We'll actually write it out again in commit_write, which is a little
 	 *    suboptimal, but at least we're correct.
 	 */
-	pg_ptr = jffs2_gc_fetch_page(c, f, start, &pg);
+	page = read_cache_page(OFNI_EDONI_2SFFJ(f)->i_mapping,
+				start >> PAGE_CACHE_SHIFT,
+				(void *)jffs2_do_readpage_unlock,
+				OFNI_EDONI_2SFFJ(f));
 
-	if (IS_ERR(pg_ptr)) {
+	if (IS_ERR(page)) {
 		printk(KERN_WARNING "read_cache_page() returned error: %ld\n", PTR_ERR(pg_ptr));
-		return PTR_ERR(pg_ptr);
+		return PTR_ERR(page);
 	}
+	pg_ptr = kmap(page);
 
 	offset = start;
 	while(offset < orig_end) {
@@ -1287,6 +1291,7 @@ static int jffs2_garbage_collect_dnode(s
 		}
 	}
 
-	jffs2_gc_release_page(c, pg_ptr, &pg);
+	kunmap(page);
+	page_cache_release(page);
 	return ret;
 }
