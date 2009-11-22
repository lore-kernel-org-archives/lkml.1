Return-Path: <linux-kernel-owner+w=401wt.eu-S1751549AbZKVKVM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549AbZKVKVM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 05:21:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751399AbZKVKVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 05:21:11 -0500
Received: from casper.infradead.org ([85.118.1.10]:49262 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbZKVKVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 05:21:10 -0500
Subject: Re: [PATCH] jffs2: Fix memory corruption in
 jffs2_read_inode_range()
From: David Woodhouse <dwmw2@infradead.org>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Neil Brown <neilb@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
In-Reply-To: <20091120194532.GA9455@oksana.dev.rtsoft.ru>
References: <20091120194532.GA9455@oksana.dev.rtsoft.ru>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 22 Nov 2009 10:20:59 +0000
Message-ID: <1258885259.1127.80.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 (2.28.1-2.fc12) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-11-20 at 12:45 -0700, Anton Vorontsov wrote:
> +       if (pg->index > ((i_size_read(inode) - 1) >> PAGE_CACHE_SHIFT)) {
> +               ret = 0;
> +               memset(pg_buf, 0, PAGE_CACHE_SIZE);
> +       } else {
> +               ret = jffs2_read_inode_range(c, f, pg_buf,
> +                       pg->index << PAGE_CACHE_SHIFT, PAGE_CACHE_SIZE);
> +       } 

Thank you for the excellent diagnosis and the patch. 

I think I'd prefer to fix it a little differently though -- I would be
happier to make jffs2_read_inode_range() cope with out-of-file reads,
rather than adding this special case where we don't call it.

That way we aren't at all susceptible to potential races between the
VFS-maintained i_size and our own internal fragtree handling. And
jffs2_read_inode_range() already handles the memset to zero for various
other reasons anyway.

Does this patch look OK to you? It seems to work on the test cases I've
tried.

diff --git a/fs/jffs2/read.c b/fs/jffs2/read.c
index cfe05c1..9640175 100644
--- a/fs/jffs2/read.c
+++ b/fs/jffs2/read.c
@@ -164,12 +164,14 @@ int jffs2_read_inode_range(struct jffs2_sb_info *c, struct jffs2_inode_info *f,
 
 	/* XXX FIXME: Where a single physical node actually shows up in two
 	   frags, we read it twice. Don't do that. */
-	/* Now we're pointing at the first frag which overlaps our page */
+	/* Now we're pointing at the first frag which overlaps our page
+	 * (or perhaps is before it, if we've been asked to read off the
+	 * end of the file). */
 	while(offset < end) {
 		D2(printk(KERN_DEBUG "jffs2_read_inode_range: offset %d, end %d\n", offset, end));
-		if (unlikely(!frag || frag->ofs > offset)) {
+		if (unlikely(!frag || frag->ofs > offset || frag->ofs + frag->size <= offset)) {
 			uint32_t holesize = end - offset;
-			if (frag) {
+			if (frag && frag->ofs > offset) {
 				D1(printk(KERN_NOTICE "Eep. Hole in ino #%u fraglist. frag->ofs = 0x%08x, offset = 0x%08x\n", f->inocache->ino, frag->ofs, offset));
 				holesize = min(holesize, frag->ofs - offset);
 			}


-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

