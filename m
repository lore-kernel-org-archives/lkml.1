Return-Path: <linux-kernel-owner+w=401wt.eu-S1756861AbZAARDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861AbZAARDs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 12:03:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756367AbZAARDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 12:03:39 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:56537 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756356AbZAARDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 12:03:39 -0500
Date: Thu, 1 Jan 2009 12:03:29 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Lachlan McIlroy <lachlan@sgi.com>, Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       xfs@oss.sgi.com, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] XFS update for 2.6.29
Message-ID: <20090101170329.GA17892@infradead.org>
References: <20081230030845.A4F0558AE206@chook.melbourne.sgi.com> <Pine.LNX.4.64.0901011048090.14380@anakin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0901011048090.14380@anakin>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 01, 2009 at 10:50:52AM +0100, Geert Uytterhoeven wrote:
> | fs/xfs/xfs_btree.c: In function 'xfs_btree_readahead_lblock':
> | fs/xfs/xfs_btree.c:736: warning: comparison is always true due to limited range of data type
> | fs/xfs/xfs_btree.c:741: warning: comparison is always true due to limited range of data type
> 
> left/right = xfs_fsblock_t (32 or 64 bit), NULLDFSBNO = xfs_dfsbno_t (64 bit)

Hmm, can't reproduce it here with CONFIG_LBD=n on x86, but the following
patch should fix it:

Index: linux-2.6/fs/xfs/xfs_btree.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_btree.c	2009-01-01 15:57:04.606547140 +0100
+++ linux-2.6/fs/xfs/xfs_btree.c	2009-01-01 15:57:24.780673454 +0100
@@ -730,8 +730,8 @@ xfs_btree_readahead_lblock(
 	struct xfs_btree_block	*block)
 {
 	int			rval = 0;
-	xfs_fsblock_t		left = be64_to_cpu(block->bb_u.l.bb_leftsib);
-	xfs_fsblock_t		right = be64_to_cpu(block->bb_u.l.bb_rightsib);
+	xfs_dfsbno_t		left = be64_to_cpu(block->bb_u.l.bb_leftsib);
+	xfs_dfsbno_t		right = be64_to_cpu(block->bb_u.l.bb_rightsib);
 
 	if ((lr & XFS_BTCUR_LEFTRA) && left != NULLDFSBNO) {
 		xfs_btree_reada_bufl(cur->bc_mp, left, 1);
