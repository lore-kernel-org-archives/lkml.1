Return-Path: <linux-kernel-owner+w=401wt.eu-S1756774AbXKVAop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774AbXKVAop (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 19:44:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751871AbXKVAoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 19:44:37 -0500
Received: from relay1.sgi.com ([192.48.171.29]:59686 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751342AbXKVAoh (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 19:44:37 -0500
Date: Thu, 22 Nov 2007 11:44:22 +1100
From: David Chinner <dgc@sgi.com>
To: xfs-oss <xfs@oss.sgi.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 9/9] Clean up open coded inode dirty checks
Message-ID: <20071122004422.GO114266761@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use xfs_inode_clean() in more places.

Signed-off-by: Dave Chinner <dgc@sgi.com>
---
 fs/xfs/xfs_inode.c      |   27 +++++----------------------
 fs/xfs/xfs_inode_item.h |    8 ++++++++
 fs/xfs/xfs_vnodeops.c   |    4 +---
 3 files changed, 14 insertions(+), 25 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_inode.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_inode.c	2007-11-22 10:33:57.728849000 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_inode.c	2007-11-22 10:33:59.692597965 +1100
@@ -2158,13 +2158,6 @@ xfs_iunlink_remove(
 	return 0;
 }
 
-STATIC_INLINE int xfs_inode_clean(xfs_inode_t *ip)
-{
-	return (((ip->i_itemp == NULL) ||
-		!(ip->i_itemp->ili_format.ilf_fields & XFS_ILOG_ALL)) &&
-		(ip->i_update_core == 0));
-}
-
 /* lookup all the inodes in the cluster */
 STATIC int
 xfs_icluster_lookup(
@@ -3067,7 +3060,6 @@ xfs_iflush_cluster(
 	int			ilist_size;
 	xfs_inode_t		**ilist;
 	xfs_inode_t		*iq;
-	xfs_inode_log_item_t	*iip;
 	int			nr_found;
 	int			clcount = 0;
 	int			bufwasdelwri;
@@ -3094,13 +3086,8 @@ xfs_iflush_cluster(
 		 * is a candidate for flushing.  These checks will be repeated
 		 * later after the appropriate locks are acquired.
 		 */
-		iip = iq->i_itemp;
-		if ((iq->i_update_core == 0) &&
-		    ((iip == NULL) ||
-		     !(iip->ili_format.ilf_fields & XFS_ILOG_ALL)) &&
-		      xfs_ipincount(iq) == 0) {
+		if (xfs_inode_clean(iq) && xfs_ipincount(iq) == 0)
 			continue;
-		}
 
 		/*
 		 * Try to get locks.  If any are unavailable or it is pinned,
@@ -3123,10 +3110,8 @@ xfs_iflush_cluster(
 		 * arriving here means that this inode can be flushed.  First
 		 * re-check that it's dirty before flushing.
 		 */
-		iip = iq->i_itemp;
-		if ((iq->i_update_core != 0) || ((iip != NULL) &&
-		     (iip->ili_format.ilf_fields & XFS_ILOG_ALL))) {
-			int error;
+		if (!xfs_inode_clean(iq)) {
+			int	error;
 			error = xfs_iflush_int(iq, bp);
 			if (error) {
 				xfs_iunlock(iq, XFS_ILOCK_SHARED);
@@ -3230,8 +3215,7 @@ xfs_iflush(
 	 * If the inode isn't dirty, then just release the inode
 	 * flush lock and do nothing.
 	 */
-	if ((ip->i_update_core == 0) &&
-	    ((iip == NULL) || !(iip->ili_format.ilf_fields & XFS_ILOG_ALL))) {
+	if (xfs_inode_clean(ip)) {
 		ASSERT((iip != NULL) ?
 			 !(iip->ili_item.li_flags & XFS_LI_IN_AIL) : 1);
 		xfs_ifunlock(ip);
@@ -3398,8 +3382,7 @@ xfs_iflush_int(
 	 * If the inode isn't dirty, then just release the inode
 	 * flush lock and do nothing.
 	 */
-	if ((ip->i_update_core == 0) &&
-	    ((iip == NULL) || !(iip->ili_format.ilf_fields & XFS_ILOG_ALL))) {
+	if (xfs_inode_clean(ip)) {
 		xfs_ifunlock(ip);
 		return 0;
 	}
Index: 2.6.x-xfs-new/fs/xfs/xfs_vnodeops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_vnodeops.c	2007-11-22 10:33:57.732848488 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_vnodeops.c	2007-11-22 10:33:59.696597454 +1100
@@ -3532,7 +3532,6 @@ xfs_inode_flush(
 	int		flags)
 {
 	xfs_mount_t	*mp = ip->i_mount;
-	xfs_inode_log_item_t *iip = ip->i_itemp;
 	int		error = 0;
 
 	if (XFS_FORCED_SHUTDOWN(mp))
@@ -3542,8 +3541,7 @@ xfs_inode_flush(
 	 * Bypass inodes which have already been cleaned by
 	 * the inode flush clustering code inside xfs_iflush
 	 */
-	if ((ip->i_update_core == 0) &&
-	    ((iip == NULL) || !(iip->ili_format.ilf_fields & XFS_ILOG_ALL)))
+	if (xfs_inode_clean(ip))
 		return 0;
 
 	/*
Index: 2.6.x-xfs-new/fs/xfs/xfs_inode_item.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_inode_item.h	2007-11-22 10:25:23.286572511 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_inode_item.h	2007-11-22 10:33:59.696597454 +1100
@@ -168,6 +168,14 @@ static inline int xfs_ilog_fext(int w)
 	return (w == XFS_DATA_FORK ? XFS_ILOG_DEXT : XFS_ILOG_AEXT);
 }
 
+STATIC_INLINE int xfs_inode_clean(xfs_inode_t *ip)
+{
+	return (((ip->i_itemp == NULL) ||
+		!(ip->i_itemp->ili_format.ilf_fields & XFS_ILOG_ALL)) &&
+		(ip->i_update_core == 0));
+}
+
+
 #ifdef __KERNEL__
 
 extern void xfs_inode_item_init(struct xfs_inode *, struct xfs_mount *);
