Return-Path: <linux-kernel-owner+w=401wt.eu-S1756711AbXFZMvD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711AbXFZMvD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 08:51:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752193AbXFZMuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 08:50:54 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:46739 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752046AbXFZMux (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 08:50:53 -0400
Date: Tue, 26 Jun 2007 22:50:06 +1000
From: David Chinner <dgc@sgi.com>
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: David Chinner <dgc@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Satyam Sharma <satyam.sharma@gmail.com>,
       Johannes Weiner <hannes-kernel@saeurebad.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       xfs-masters@oss.sgi.com
Subject: Re: [BUG] Lockdep warning with XFS on 2.6.22-rc6
Message-ID: <20070626125006.GG31489@sgi.com>
References: <20070626021617.GK989688@sgi.com> <20070626093520.GB2691@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070626093520.GB2691@ff.dom.local>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2007 at 11:35:20AM +0200, Jarek Poplawski wrote:
> On 26-06-2007 04:16, David Chinner wrote:
> > It does both - parent-first/child-second and ascending inode # order,
> > which is where the problem is. standing alone, these seem fine, but
> > they don't appear to work when the child has a lower inode number
> > than the parent.
> ...
> 
> >From xfs_inode.h:
> 
> /*
>  * Flags for lockdep annotations.
>  *
>  * XFS_I[O]LOCK_PARENT - for operations that require locking two inodes
>  * (ie directory operations that require locking a directory inode and
>  * an entry inode).  The first inode gets locked with this flag so it
>  * gets a lockdep subclass of 1 and the second lock will have a lockdep
>  * subclass of 0.
>  *
>  * XFS_I[O]LOCK_INUMORDER - for locking several inodes at the some time
>  * with xfs_lock_inodes().  This flag is used as the starting subclass
>  * and each subsequent lock acquired will increment the subclass by one.
>  * So the first lock acquired will have a lockdep subclass of 2, the
>  * second lock will have a lockdep subclass of 3, and so on.
>  */
> 
> I don't know xfs code, and probably miss something, but it seems
> there could be some inconsistency: lockdep warning shows mr_lock/1
> taken both before and after mr_lock (i.e. /0). According to the
> above comment there should be always 1 before 0...

That just fired some rusty neurons.

#define XFS_IOLOCK_SHIFT        16
#define XFS_IOLOCK_PARENT       (1 << XFS_IOLOCK_SHIFT)
#define XFS_IOLOCK_INUMORDER    (2 << XFS_IOLOCK_SHIFT)

#define XFS_ILOCK_SHIFT         24
#define XFS_ILOCK_PARENT        (1 << XFS_ILOCK_SHIFT)
#define XFS_ILOCK_INUMORDER     (2 << XFS_ILOCK_SHIFT)

So, in a lock_mode parameter, the upper 8 bits are for the ILOCK lockdep
subclass, and the 16..23 bits are for the IOLOCK lockdep subclass.

Where do we add them?

static inline int
xfs_lock_inumorder(int lock_mode, int subclass)
{
        if (lock_mode & (XFS_IOLOCK_SHARED|XFS_IOLOCK_EXCL))
                lock_mode |= (subclass + XFS_IOLOCK_INUMORDER) << XFS_IOLOCK_SHIFT;
        if (lock_mode & (XFS_ILOCK_SHARED|XFS_ILOCK_EXCL))
                lock_mode |= (subclass + XFS_ILOCK_INUMORDER) << XFS_ILOCK_SHIFT;

        return lock_mode;
}


OH, look at those nice overflow bugs in that in that code. We shift
the XFS_IOLOCK_INUMORDER and XFS_ILOCK_INUMORDER bits out the far
side of the lock_mode variable result in lock subclasses of 0-3 instead
of 2-5....

Bugger, eh?

Patch below should fix this (untested).

Jarek - thanks for pointing what I should have seen earlier.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

---
 fs/xfs/xfs_inode.h    |   15 +++++++++------
 fs/xfs/xfs_vnodeops.c |    4 ++--
 2 files changed, 11 insertions(+), 8 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_vnodeops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_vnodeops.c	2007-06-25 13:56:20.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_vnodeops.c	2007-06-26 22:46:55.412060598 +1000
@@ -2256,9 +2256,9 @@ static inline int
 xfs_lock_inumorder(int lock_mode, int subclass)
 {
 	if (lock_mode & (XFS_IOLOCK_SHARED|XFS_IOLOCK_EXCL))
-		lock_mode |= (subclass + XFS_IOLOCK_INUMORDER) << XFS_IOLOCK_SHIFT;
+		lock_mode |= (subclass + XFS_LOCK_INUMORDER) << XFS_IOLOCK_SHIFT;
 	if (lock_mode & (XFS_ILOCK_SHARED|XFS_ILOCK_EXCL))
-		lock_mode |= (subclass + XFS_ILOCK_INUMORDER) << XFS_ILOCK_SHIFT;
+		lock_mode |= (subclass + XFS_LOCK_INUMORDER) << XFS_ILOCK_SHIFT;
 
 	return lock_mode;
 }
Index: 2.6.x-xfs-new/fs/xfs/xfs_inode.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_inode.h	2007-06-20 17:59:35.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_inode.h	2007-06-26 22:46:50.104749916 +1000
@@ -386,19 +386,22 @@ xfs_iflags_test(xfs_inode_t *ip, unsigne
  * gets a lockdep subclass of 1 and the second lock will have a lockdep
  * subclass of 0.
  *
- * XFS_I[O]LOCK_INUMORDER - for locking several inodes at the some time
+ * XFS_LOCK_INUMORDER - for locking several inodes at the some time
  * with xfs_lock_inodes().  This flag is used as the starting subclass
  * and each subsequent lock acquired will increment the subclass by one.
  * So the first lock acquired will have a lockdep subclass of 2, the
- * second lock will have a lockdep subclass of 3, and so on.
+ * second lock will have a lockdep subclass of 3, and so on. It is
+ * the responsibility of the class builder to shift this to the correct
+ * portion of the lock_mode lockdep mask.
  */
+#define XFS_LOCK_PARENT		1
+#define XFS_LOCK_INUMORDER	2
+
 #define XFS_IOLOCK_SHIFT	16
-#define	XFS_IOLOCK_PARENT	(1 << XFS_IOLOCK_SHIFT)
-#define	XFS_IOLOCK_INUMORDER	(2 << XFS_IOLOCK_SHIFT)
+#define	XFS_IOLOCK_PARENT	(XFS_LOCK_PARENT << XFS_IOLOCK_SHIFT)
 
 #define XFS_ILOCK_SHIFT		24
-#define	XFS_ILOCK_PARENT	(1 << XFS_ILOCK_SHIFT)
-#define	XFS_ILOCK_INUMORDER	(2 << XFS_ILOCK_SHIFT)
+#define	XFS_ILOCK_PARENT	(XFS_LOCK_PARENT << XFS_ILOCK_SHIFT)
 
 #define XFS_IOLOCK_DEP_MASK	0x00ff0000
 #define XFS_ILOCK_DEP_MASK	0xff000000
