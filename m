Return-Path: <linux-kernel-owner+w=401wt.eu-S1755096AbXE0AgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096AbXE0AgP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 20:36:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751278AbXE0AgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 20:36:00 -0400
Received: from gw.goop.org ([64.81.55.164]:34066 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995AbXE0Af7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 20:35:59 -0400
Message-ID: <4658D26C.9010803@goop.org>
Date: Sun, 27 May 2007 01:35:56 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, xfs-masters@oss.sgi.com,
       David Chinner <dgc@sgi.com>, Christoph Lameter <clameter@sgi.com>
Subject: Re: 2.6.22-rc2: known regressions with patches
References: <46559B62.5040903@googlemail.com>
In-Reply-To: <46559B62.5040903@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Piotrowski wrote:
> File systems
>
> Subject    : 2.6.21-git10/11: files getting truncated on xfs
> References : http://lkml.org/lkml/2007/5/9/410
> Submitter  : Jeremy Fitzhardinge <jeremy@goop.org>
> Handled-By : David Chinner <dgc@sgi.com>
> Patch      : http://lkml.org/lkml/2007/5/12/93
> Status     : patch available
>   

I'm satisfied the patch fixes the problem for me.  Can we have some
movement to get it into at least -mm?  This is a real, serious
data-corrupting bug.  Ideally we should get it into -rc asap.

I've put the version I'm using below, but I haven't seen a properly
changelogged and signed-off version.

Thanks,
    J

From: David Chinner <dgc@sgi.com>

On Sat, May 12, 2007 at 01:23:27PM +0200, Jan Engelhardt wrote:
> 
> On May 10 2007 14:54, Jeremy Fitzhardinge wrote:
> >>>> What CPU architecture is this happening on? Not i686 with PAE by
> >>>> any chance?
> >>>>       
> >>> Yes.  Why?
> >>
> >> I have a bug report where NFS files are corrupted only with PAE clients.
> >> Corruption is at the end of the (newly untarred) files. Doesn't happen
> >> without PAE.
> >
> >Hm, suggestive, but I'm not convinced.  Two differences to this situation:
> >
> >   1. Immediately after the clone ("untar"), the contents are completely
> >      OK; it's only after a umount/mount cycle to problems appear
> 
> And if you do a "sync" rather than umount/mount?

I doubt it will matter - I don't think we are marking the inode dirty at
the right point.

The change that was at fault modifies the way we update the file
size on the inode. We added an in-memory copy of the file size to
the in-memory copy of the disk inode's file size that we already
keep. We now only update the disk inode's (in memory copy) file size
on I/O completion. Because the generic code writes the inode out
before waiting for I/O to complete, the old file size gets written
out instead of the new one.

If the write was to extending the file into an existing block there
would be no delalloc transaction to redirty the inode (happens on
log I/O completion). Hence when the I/O completes and the file size
gets updated to the in-core disk inode (which is marked dirty), the
linux inode remains clean. As a result, a sync will never flush the
inode to get the updated file size to disk.

What I don't understand is that on unmount dirty xfs inodes get
written out. Clearly this is not happening - either there's a hole
in the writeback logic (unlikely - it was unchanged) or we've missed
some case where we need to update the filesize and mark the inode
dirty.

Hmmmm - if the write was just a short append to the file, then the
block that was written to should already be mapped. Then we'll just
look up the extent by doing a BMAPI_READ lookup, set the type to
IOMAP_READ and add the block to ioend we are building.

The type IOMAP_READ determines the I/O completion behaviour - in this case
it is xfs_end_bio_read(), which fails to update the file size....

Bingo.

A patch for you to try, Jeremy. I've just started a test run on it...

Cheers,

Dave.
---
 fs/xfs/linux-2.6/xfs_aops.c |   23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_aops.c
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_aops.c
@@ -973,8 +973,9 @@ xfs_page_state_convert(
 
 	bh = head = page_buffers(page);
 	offset = page_offset(page);
-	flags = -1;
-	type = IOMAP_READ;
+	iomap_valid = 0;
+	flags = BMAPI_READ;
+	type = IOMAP_NEW;
 
 	/* TODO: cleanup count and page_dirty */
 
@@ -1004,14 +1005,14 @@ xfs_page_state_convert(
 		 *
 		 * Third case, an unmapped buffer was found, and we are
 		 * in a path where we need to write the whole page out.
- 		 */
+		 */
 		if (buffer_unwritten(bh) || buffer_delay(bh) ||
 		    ((buffer_uptodate(bh) || PageUptodate(page)) &&
 		     !buffer_mapped(bh) && (unmapped || startio))) {
-		     	/*
+			/*
 			 * Make sure we don't use a read-only iomap
 			 */
-		     	if (flags == BMAPI_READ)
+			if (flags == BMAPI_READ)
 				iomap_valid = 0;
 
 			if (buffer_unwritten(bh)) {
@@ -1060,7 +1061,7 @@ xfs_page_state_convert(
 			 * That means it must already have extents allocated
 			 * underneath it. Map the extent by reading it.
 			 */
-			if (!iomap_valid || type != IOMAP_READ) {
+			if (!iomap_valid || flags != BMAPI_READ) {
 				flags = BMAPI_READ;
 				size = xfs_probe_cluster(inode, page, bh,
 								head, 1);
@@ -1071,7 +1072,15 @@ xfs_page_state_convert(
 				iomap_valid = xfs_iomap_valid(&iomap, offset);
 			}
 
-			type = IOMAP_READ;
+			/*
+			 * We set the type to IOMAP_NEW in case we are doing a
+			 * small write at EOF that is extending the file but
+			 * without needing an allocation. We need to update the
+			 * file size on I/O completion in this case so it is
+			 * the same case as having just allocated a new extent
+			 * that we are writing into for the first time.
+			 */
+			type = IOMAP_NEW;
 			if (!test_and_set_bit(BH_Lock, &bh->b_state)) {
 				ASSERT(buffer_mapped(bh));
 				if (iomap_valid)


