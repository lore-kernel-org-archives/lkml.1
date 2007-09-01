Return-Path: <linux-kernel-owner+w=401wt.eu-S1755675AbXIATG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675AbXIATG2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 15:06:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756641AbXIATGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 15:06:19 -0400
Received: from li6-103.members.linode.com ([66.160.141.103]:1071 "EHLO
	smtp.falooley.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684AbXIATGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 15:06:18 -0400
Date: Sat, 1 Sep 2007 12:06:03 -0700
From: Jason Lunz <lunz@falooley.org>
To: David Woodhouse <dwmw2@infradead.org>, Nick Piggin <npiggin@suse.de>
Cc: lkml <linux-kernel@vger.kernel.org>, jffs-dev@axis.com,
       Hugh Dickins <hugh@veritas.com>
Subject: [jffs2] [rfc] fix write deadlock regression
Message-ID: <20070901190602.GA5926@falooley.org>
References: <20070830182354.GA25077@falooley.org> <20070831212636.GB12868@falooley.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070831212636.GB12868@falooley.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I've bisected the deadlock when many small appends are done on jffs2 down to
this commit:

commit 6fe6900e1e5b6fa9e5c59aa5061f244fe3f467e2
Author: Nick Piggin <npiggin@suse.de>
Date:   Sun May 6 14:49:04 2007 -0700

    mm: make read_cache_page synchronous

    Ensure pages are uptodate after returning from read_cache_page, which allows
    us to cut out most of the filesystem-internal PageUptodate calls.

    I didn't have a great look down the call chains, but this appears to fixes 7
    possible use-before uptodate in hfs, 2 in hfsplus, 1 in jfs, a few in
    ecryptfs, 1 in jffs2, and a possible cleared data overwritten with readpage in
    block2mtd.  All depending on whether the filler is async and/or can return
    with a !uptodate page.

It introduced a wait to read_cache_page, as well as a
read_cache_page_async function equivalent to the old read_cache_page
without any callers.

Switching jffs2_gc_fetch_page to read_cache_page_async for the old
behavior makes the deadlocks go away, but maybe reintroduces the
use-before-uptodate problem? I don't understand the mm/fs interaction
well enough to say.

Someone more knowledgable should see if similar deadlock issues may have
been introduced for other read_cache_page callers, including the other
two in jffs2.

    Signed-off-by: Jason Lunz <lunz@falooley.org>

---
 fs/jffs2/fs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/jffs2/fs.c b/fs/jffs2/fs.c
index 1d3b7a9..8bc727b 100644
--- a/fs/jffs2/fs.c
+++ b/fs/jffs2/fs.c
@@ -627,7 +627,7 @@ unsigned char *jffs2_gc_fetch_page(struct jffs2_sb_info *c,
 	struct inode *inode = OFNI_EDONI_2SFFJ(f);
 	struct page *pg;
 
-	pg = read_cache_page(inode->i_mapping, offset >> PAGE_CACHE_SHIFT,
+	pg = read_cache_page_async(inode->i_mapping, offset >> PAGE_CACHE_SHIFT,
 			     (void *)jffs2_do_readpage_unlock, inode);
 	if (IS_ERR(pg))
 		return (void *)pg;
