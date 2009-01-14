Return-Path: <linux-kernel-owner+w=401wt.eu-S1760907AbZANVpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760907AbZANVpx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 16:45:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757291AbZANVpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 16:45:42 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59800 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756837AbZANVpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 16:45:41 -0500
Date: Wed, 14 Jan 2009 13:44:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: chris.mason@oracle.com, handygewinnspiel@gmx.de, matthew@wil.cx,
       rjw@sisk.pl, HWerner4@gmx.de, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       mchehab@infradead.org, stable@kernel.org,
       Christoph Hellwig <hch@lst.de>, Lachlan McIlroy <lachlan@sgi.com>,
       Timothy Shimmin <tes@sgi.com>
Subject: Re: [linux-dvb] compiling on 2.6.28 broken?
Message-Id: <20090114134417.e6b29b52.akpm@linux-foundation.org>
In-Reply-To: <496E5AB2.7040507@sandeen.net>
References: <20090112190420.51f75853@pedra.chehab.org>
	<20090112132130.6c932b85.akpm@linux-foundation.org>
	<20090112220624.4fbfee34@pedra.chehab.org>
	<20090112162337.318dd61d.akpm@linux-foundation.org>
	<20090113184755.87720@gmx.net>
	<20090113105947.9e774b69.akpm@linux-foundation.org>
	<20090113191757.74290@gmx.net>
	<20090113113700.776a94b5.akpm@linux-foundation.org>
	<20090113203843.GJ29283@parisc-linux.org>
	<1231957750.8269.28.camel@think.oraclecorp.com>
	<496E56EB.2030301@gmx.de>
	<1231968240.8269.48.camel@think.oraclecorp.com>
	<496E5AB2.7040507@sandeen.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jan 2009 15:35:46 -0600
Eric Sandeen <sandeen@sandeen.net> wrote:

> Chris Mason wrote:
> > On Wed, 2009-01-14 at 22:19 +0100, wk wrote:
> ...
> >> I cannot fully understand what strace -v outputs (see attachment), but 
> >> what i see is that 'find' stops after finding a file with d_off = 4294967295
> >> 4294967295  =  0xFFFFFFFF, adding any number greater that zero will be 
> >> greater that 32bits, so this could be the reason for the message "value 
> >> too large".
> >>
> >>
> >>
> >> I also noticed that i cannot access these files through samba if i boot 
> >> from 2.6.28 - really strange.
> >> If i reboot older kernels these are visible in samba again and fully 
> >> accessible.
> >>
> >> Attached the log from stracing the command which was ivoked by the 
> >> Makefile from v4l-dvb.
> >> I guess this is all i could contribute to that problem. Thats stuff for 
> >> xfs filesystem experts now..
> > 
> > Seems suspect indeed.  Could you please attach the strace for the run
> > that works on the older kernel?
> 
> Chris got my attention on this one; you probably want this fix from hch:
> 
> http://oss.sgi.com/archives/xfs/2009-01/msg00158.html
> 

Looks likely.  It is below, for anyone who would like to test it.


It is in linux-next.  Guys, do we plan to merge this into 2.6.29?

(cc's stable@kernel.org)

This patch applies OK to 2.6.27 and 2.6.28.  Is it also needed there? 
If so, it should have had "Cc: <stable@kernel.org>" in the changelog so
that it doesn't get lost.





commit 15440319767942a363f282d6585303d3d75088ba
Author:     Christoph Hellwig <hch@infradead.org>
AuthorDate: Thu Jan 8 14:00:00 2009 -0500
Commit:     Lachlan McIlroy <lachlan@redback.melbourne.sgi.com>
CommitDate: Fri Jan 9 16:18:24 2009 +1100

    [XFS] truncate readdir offsets to signed 32 bit values
    
    John Stanley reported EOVERFLOW errors in readdir from his self-build
    glibc.  I traced this down to glibc enabling d_off overflow checks
    in one of the about five million different getdents implementations.
    
    In 2.6.28 Dave Woodhouse moved our readdir double buffering required
    for NFS4 readdirplus into nfsd and at that point we lost the capping
    of the directory offsets to 32 bit signed values.  Johns glibc used
    getdents64 to even implement readdir for normal 32 bit offset dirents,
    and failed with EOVERFLOW only if this happens on the first dirent in
    a getdents call.  I managed to come up with a testcase that uses
    raw getdents and does the EOVERFLOW check manually.  We always hit
    it with our last entry due to the special end of directory marker.
    
    The patch below is a dumb version of just putting back the masking,
    to make sure we have the same behavior as in 2.6.27 and earlier.
    
    I will work on a better and cleaner fix for 2.6.30.
    
    Reported-by: John Stanley <jpsinthemix@verizon.net>
    Tested-by: John Stanley <jpsinthemix@verizon.net>
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Dave Chinner <david@fromorbit.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

diff --git a/fs/xfs/xfs_dir2_block.c b/fs/xfs/xfs_dir2_block.c
index e2fa0a1..e1f0a06 100644
--- a/fs/xfs/xfs_dir2_block.c
+++ b/fs/xfs/xfs_dir2_block.c
@@ -517,9 +517,9 @@ xfs_dir2_block_getdents(
 		/*
 		 * If it didn't fit, set the final offset to here & return.
 		 */
-		if (filldir(dirent, dep->name, dep->namelen, cook,
+		if (filldir(dirent, dep->name, dep->namelen, cook & 0x7fffffff,
 			    ino, DT_UNKNOWN)) {
-			*offset = cook;
+			*offset = cook & 0x7fffffff;
 			xfs_da_brelse(NULL, bp);
 			return 0;
 		}
@@ -529,7 +529,8 @@ xfs_dir2_block_getdents(
 	 * Reached the end of the block.
 	 * Set the offset to a non-existent block 1 and return.
 	 */
-	*offset = xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk + 1, 0);
+	*offset = xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk + 1, 0) &
+			0x7fffffff;
 	xfs_da_brelse(NULL, bp);
 	return 0;
 }
diff --git a/fs/xfs/xfs_dir2_leaf.c b/fs/xfs/xfs_dir2_leaf.c
index 9353599..ef805a3 100644
--- a/fs/xfs/xfs_dir2_leaf.c
+++ b/fs/xfs/xfs_dir2_leaf.c
@@ -1092,7 +1092,7 @@ xfs_dir2_leaf_getdents(
 		 * Won't fit.  Return to caller.
 		 */
 		if (filldir(dirent, dep->name, dep->namelen,
-			    xfs_dir2_byte_to_dataptr(mp, curoff),
+			    xfs_dir2_byte_to_dataptr(mp, curoff) & 0x7fffffff,
 			    ino, DT_UNKNOWN))
 			break;
 
@@ -1108,9 +1108,9 @@ xfs_dir2_leaf_getdents(
 	 * All done.  Set output offset value to current offset.
 	 */
 	if (curoff > xfs_dir2_dataptr_to_byte(mp, XFS_DIR2_MAX_DATAPTR))
-		*offset = XFS_DIR2_MAX_DATAPTR;
+		*offset = XFS_DIR2_MAX_DATAPTR & 0x7fffffff;
 	else
-		*offset = xfs_dir2_byte_to_dataptr(mp, curoff);
+		*offset = xfs_dir2_byte_to_dataptr(mp, curoff) & 0x7fffffff;
 	kmem_free(map);
 	if (bp)
 		xfs_da_brelse(NULL, bp);
diff --git a/fs/xfs/xfs_dir2_sf.c b/fs/xfs/xfs_dir2_sf.c
index b46af00..a8a8a6e 100644
--- a/fs/xfs/xfs_dir2_sf.c
+++ b/fs/xfs/xfs_dir2_sf.c
@@ -752,8 +752,8 @@ xfs_dir2_sf_getdents(
 #if XFS_BIG_INUMS
 		ino += mp->m_inoadd;
 #endif
-		if (filldir(dirent, ".", 1, dot_offset, ino, DT_DIR)) {
-			*offset = dot_offset;
+		if (filldir(dirent, ".", 1, dot_offset & 0x7fffffff, ino, DT_DIR)) {
+			*offset = dot_offset & 0x7fffffff;
 			return 0;
 		}
 	}
@@ -766,8 +766,8 @@ xfs_dir2_sf_getdents(
 #if XFS_BIG_INUMS
 		ino += mp->m_inoadd;
 #endif
-		if (filldir(dirent, "..", 2, dotdot_offset, ino, DT_DIR)) {
-			*offset = dotdot_offset;
+		if (filldir(dirent, "..", 2, dotdot_offset & 0x7fffffff, ino, DT_DIR)) {
+			*offset = dotdot_offset & 0x7fffffff;
 			return 0;
 		}
 	}
@@ -791,14 +791,15 @@ xfs_dir2_sf_getdents(
 #endif
 
 		if (filldir(dirent, sfep->name, sfep->namelen,
-					    off, ino, DT_UNKNOWN)) {
-			*offset = off;
+			    off & 0x7fffffff, ino, DT_UNKNOWN)) {
+			*offset = off & 0x7fffffff;
 			return 0;
 		}
 		sfep = xfs_dir2_sf_nextentry(sfp, sfep);
 	}
 
-	*offset = xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk + 1, 0);
+	*offset = xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk + 1, 0) &
+			0x7fffffff;
 	return 0;
 }
 

