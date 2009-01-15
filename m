Return-Path: <linux-kernel-owner+w=401wt.eu-S935068AbZAOVMM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935068AbZAOVMM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 16:12:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764283AbZAOVJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 16:09:40 -0500
Received: from kroah.org ([198.145.64.141]:56297 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934937AbZAOVJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 16:09:37 -0500
Date: Thu, 15 Jan 2009 13:08:28 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       "alan@lxorguk.ukuu.org.uk John Stanley" <jpsinthemix@verizon.net>,
       Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
       Lachlan McIlroy <lachlan@sgi.com>
Subject: [patch 95/94] XFS: truncate readdir offsets to signed 32 bit values
Message-ID: <20090115210828.GA28054@kroah.com>
References: <20090115195520.GA14403@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090115195520.GA14403@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

---------------------

From: Christoph Hellwig <hch@infradead.org>

commit 15440319767942a363f282d6585303d3d75088ba upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/xfs/xfs_dir2_block.c |    7 ++++---
 fs/xfs/xfs_dir2_leaf.c  |    6 +++---
 fs/xfs/xfs_dir2_sf.c    |   15 ++++++++-------
 3 files changed, 15 insertions(+), 13 deletions(-)

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
 
