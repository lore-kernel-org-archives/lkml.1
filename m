Return-Path: <linux-kernel-owner+w=401wt.eu-S1755368AbZAUXOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368AbZAUXOp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 18:14:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752433AbZAUXOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 18:14:37 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:32984 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbZAUXOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 18:14:36 -0500
Date: Wed, 21 Jan 2009 18:14:35 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Lars Noschinski <lkml@ml.noschinski.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: XFS error & call trace
Message-ID: <20090121231435.GA6810@infradead.org>
References: <20090121222703.GA5522@aprove.informatik.rwth-aachen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090121222703.GA5522@aprove.informatik.rwth-aachen.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2009 at 11:27:03PM +0100, Lars Noschinski wrote:
> Hello!
> 
> I just had a crash of my XFS file system on 2.6.29-rc1 (syslog output
> follows) After this, the file system on /home returned -EIO on most (all?)
> operations.  After a reboot from cdrom, I found it interesting to see that
> xfs_check found no error on this partition. Instead, the XFS on the /
> partition had a lot of errors.

The patch below from Dave Chinner fixes it:

---

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

Reported-by: Alexander Beregalov <a.beregalov@gmail.com>
Reported-by: Jacek Luczak <difrost.kernel@gmail.com>
Reported-by: Danny ter Haar <dth@dth.net>
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
