Return-Path: <linux-kernel-owner+w=401wt.eu-S1752829AbZKWNsJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829AbZKWNsJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 08:48:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751738AbZKWNsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 08:48:08 -0500
Received: from casper.infradead.org ([85.118.1.10]:50141 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbZKWNsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 08:48:07 -0500
Subject: [PATCH] jffs2: Fix memory corruption in jffs2_read_inode_range()
From: David Woodhouse <dwmw2@infradead.org>
To: torvalds@linux-foundation.org, Anton Vorontsov <avorontsov@ru.mvista.com>,
       stable@kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Neil Brown <neilb@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
In-Reply-To: <20091120194532.GA9455@oksana.dev.rtsoft.ru>
References: <20091120194532.GA9455@oksana.dev.rtsoft.ru>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 Nov 2009 13:47:53 +0000
Message-ID: <1258984073.29729.256.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 (2.28.1-2.fc12) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In 2.6.23 kernel, commit a32ea1e1f925399e0d81ca3f7394a44a6dafa12c
("Fix read/truncate race") fixed a race in the generic code, and as a
side effect, now do_generic_file_read() can ask us to readpage() past
the i_size. This seems to be correctly handled by the block routines
(e.g. block_read_full_page() fills the page with zeroes in case if
somebody is trying to read past the last inode's block).

JFFS2 doesn't handle this; it assumes that it won't be asked to read
pages which don't exist -- and thus that there will be at least _one_
valid 'frag' on the page it's being asked to read. It will fill any
holes with the following memset:

  memset(buf, 0, min(end, frag->ofs + frag->size) - offset);

When the 'closest smaller match' returned by jffs2_lookup_node_frag() is
actually on a previous page and ends before 'offset', that results in:

  memset(buf, 0, <huge unsigned negative>);

Hopefully, in most cases the corruption is fatal, and quickly causing
random oopses, like this:

  root@10.0.0.4:~/ltp-fs-20090531# ./testcases/kernel/fs/ftest/ftest01
  Unable to handle kernel paging request for data at address 0x00000008
  Faulting instruction address: 0xc01cd980
  Oops: Kernel access of bad area, sig: 11 [#1]
  [...]
  NIP [c01cd980] rb_insert_color+0x38/0x184
  LR [c0043978] enqueue_hrtimer+0x88/0xc4
  Call Trace:
  [c6c63b60] [c004f9a8] tick_sched_timer+0xa0/0xe4 (unreliable)
  [c6c63b80] [c0043978] enqueue_hrtimer+0x88/0xc4
  [c6c63b90] [c0043a48] __run_hrtimer+0x94/0xbc
  [c6c63bb0] [c0044628] hrtimer_interrupt+0x140/0x2b8
  [c6c63c10] [c000f8e8] timer_interrupt+0x13c/0x254
  [c6c63c30] [c001352c] ret_from_except+0x0/0x14
  --- Exception: 901 at memset+0x38/0x5c
      LR = jffs2_read_inode_range+0x144/0x17c
  [c6c63cf0] [00000000] (null) (unreliable)

This patch fixes the issue, plus fixes all LTP tests on NAND/UBI with
JFFS2 filesystem that were failing since 2.6.23 (seems like the bug
above also broke the truncation).

Reported-By: Anton Vorontsov <avorontsov@ru.mvista.com>
Tested-By: Anton Vorontsov <avorontsov@ru.mvista.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Cc: stable@kernel.org

diff --git a/fs/jffs2/read.c b/fs/jffs2/read.c
index cfe05c1..3f39be1 100644
--- a/fs/jffs2/read.c
+++ b/fs/jffs2/read.c
@@ -164,12 +164,15 @@ int jffs2_read_inode_range(struct jffs2_sb_info *c, struct jffs2_inode_info *f,
 
 	/* XXX FIXME: Where a single physical node actually shows up in two
 	   frags, we read it twice. Don't do that. */
-	/* Now we're pointing at the first frag which overlaps our page */
+	/* Now we're pointing at the first frag which overlaps our page
+	 * (or perhaps is before it, if we've been asked to read off the
+	 * end of the file). */
 	while(offset < end) {
 		D2(printk(KERN_DEBUG "jffs2_read_inode_range: offset %d, end %d\n", offset, end));
-		if (unlikely(!frag || frag->ofs > offset)) {
+		if (unlikely(!frag || frag->ofs > offset ||
+			     frag->ofs + frag->size <= offset)) {
 			uint32_t holesize = end - offset;
-			if (frag) {
+			if (frag && frag->ofs > offset) {
 				D1(printk(KERN_NOTICE "Eep. Hole in ino #%u fraglist. frag->ofs = 0x%08x, offset = 0x%08x\n", f->inocache->ino, frag->ofs, offset));
 				holesize = min(holesize, frag->ofs - offset);
 			}


-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

