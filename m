Return-Path: <linux-kernel-owner+w=401wt.eu-S1758857AbZATXDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758857AbZATXDZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 18:03:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755793AbZATXDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 18:03:16 -0500
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:43726 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755517AbZATXDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 18:03:15 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAAjmdUl5LAUp/2dsb2JhbAC7PAiPEoQ7CIEw
X-IronPort-AV: E=Sophos;i="4.37,297,1231075800"; 
   d="scan'208";a="271850713"
Date: Wed, 21 Jan 2009 10:03:06 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>,
       Jacek Luczak <difrost.kernel@gmail.com>,
       Eric Sandeen <sandeen@sandeen.net>, LKML <linux-kernel@vger.kernel.org>,
       xfs mailing list <xfs@oss.sgi.com>
Subject: [PATCH] Re: [XFS] 2.6.29-rc2: XFS internal error
	XFS_WANT_CORRUPTED_GOTO
Message-ID: <20090120230306.GE10158@disturbed>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Jacek Luczak <difrost.kernel@gmail.com>,
	Eric Sandeen <sandeen@sandeen.net>,
	LKML <linux-kernel@vger.kernel.org>,
	xfs mailing list <xfs@oss.sgi.com>
References: <497468C1.3000001@gmail.com> <4974CA20.6050308@sandeen.net> <20090120004611.GA6445@disturbed> <20090120112910.GA6831@infradead.org> <4975B9C4.7030401@gmail.com> <20090120114906.GA12526@infradead.org> <20090120133521.GD10158@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090120133521.GD10158@disturbed>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2009 at 12:35:21AM +1100, Dave Chinner wrote:
> On Tue, Jan 20, 2009 at 06:49:06AM -0500, Christoph Hellwig wrote:
> > On Tue, Jan 20, 2009 at 12:47:16PM +0100, Jacek Luczak wrote:
> > > Christoph Hellwig pisze:
> > > > I'm doing about half of my testing on 32 bit x86, and I couldn't
> > > > reproduce the detailed receipe  in the kernel.org bugzilla yet.
> > > > 
> > > > Just curious:  do you have CONFIG_LBD set?
> > > 
> > > the answer is:
> > > $ grep LBD .config
> > > # CONFIG_LBD is not set
> > 
> > Ok, let me reproduce it without that set..
> 
> Good call, Christoph. I have a reproduce on ia32, CONFIG_LBD=n,
> 1k block size, 16 AGs in 4GB.

Christoph nailed it down to a problem with xf_fsblock_t last night.

> I'll see if this is reproducable, and if it is I'll start
> instrumenting in the morning during the LCA keynote. ;)

And here's the patch to fix it, posted direct from the keynote ;)

Cheers,

Dave.

------

[XFS] Long btree pointers are still 64 bit on disk

On 32 bit machines with CONFIG_LBD=n, XFS reduces the
in memory size of xfs_fsblock_t to 32 bits so that it
will fit within 32 bit addressing. However, the disk format
for long btree pointers are still 64 bits in size.

The recent btree rewrite failed to take this into account
when initialising new btree blocks, setting sibling pointers
to NULL and checking if they are NULL. Hence checking whether
a 64 bit NULL was the same as a 32 bit NULL was failingi
resulting in NULL sibling pointers failing to be detected
correctly. This showed up as WANT_CORRUPTED_GOTO shutdowns
in xfs_btree_delrec.

Fix this by making all the comparisons and setting of long
pointer btree NULL blocks to the disk format, not the
in memory format. i.e. use NULLDFSBNO.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_btree.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_btree.c b/fs/xfs/xfs_btree.c
index 2c3ef20..6bc2136 100644
--- a/fs/xfs/xfs_btree.c
+++ b/fs/xfs/xfs_btree.c
@@ -843,7 +843,7 @@ xfs_btree_ptr_is_null(
 	union xfs_btree_ptr	*ptr)
 {
 	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
-		return be64_to_cpu(ptr->l) == NULLFSBLOCK;
+		return be64_to_cpu(ptr->l) == NULLDFSBNO;
 	else
 		return be32_to_cpu(ptr->s) == NULLAGBLOCK;
 }
@@ -854,7 +854,7 @@ xfs_btree_set_ptr_null(
 	union xfs_btree_ptr	*ptr)
 {
 	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
-		ptr->l = cpu_to_be64(NULLFSBLOCK);
+		ptr->l = cpu_to_be64(NULLDFSBNO);
 	else
 		ptr->s = cpu_to_be32(NULLAGBLOCK);
 }
@@ -918,8 +918,8 @@ xfs_btree_init_block(
 	new->bb_numrecs = cpu_to_be16(numrecs);
 
 	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
-		new->bb_u.l.bb_leftsib = cpu_to_be64(NULLFSBLOCK);
-		new->bb_u.l.bb_rightsib = cpu_to_be64(NULLFSBLOCK);
+		new->bb_u.l.bb_leftsib = cpu_to_be64(NULLDFSBNO);
+		new->bb_u.l.bb_rightsib = cpu_to_be64(NULLDFSBNO);
 	} else {
 		new->bb_u.s.bb_leftsib = cpu_to_be32(NULLAGBLOCK);
 		new->bb_u.s.bb_rightsib = cpu_to_be32(NULLAGBLOCK);
@@ -971,7 +971,7 @@ xfs_btree_ptr_to_daddr(
 	union xfs_btree_ptr	*ptr)
 {
 	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
-		ASSERT(be64_to_cpu(ptr->l) != NULLFSBLOCK);
+		ASSERT(be64_to_cpu(ptr->l) != NULLDFSBNO);
 
 		return XFS_FSB_TO_DADDR(cur->bc_mp, be64_to_cpu(ptr->l));
 	} else {

-- 
Dave Chinner
david@fromorbit.com
