Return-Path: <linux-kernel-owner+w=401wt.eu-S1754231AbYAWFee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231AbYAWFee (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 00:34:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752289AbYAWFe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 00:34:26 -0500
Received: from relay2.sgi.com ([192.48.171.30]:39230 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752210AbYAWFeZ (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 00:34:25 -0500
Date: Wed, 23 Jan 2008 16:34:12 +1100
From: David Chinner <dgc@sgi.com>
To: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Cc: linux-kernel@vger.kernel.org
Subject: do_remount_sb(RDONLY) race? (was: XFS oops under 2.6.23.9)
Message-ID: <20080123053412.GN155259@sgi.com>
References: <200801230430.m0N4UmpU029430@turbo.physics.adelaide.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801230430.m0N4UmpU029430@turbo.physics.adelaide.edu.au>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2008 at 03:00:48PM +1030, Jonathan Woithe wrote:
> Last night my laptop suffered an oops during closedown.  The full oops
> reports can be downloaded from
> 
>   http://www.atrad.com.au/~jwoithe/xfs_oops/

Assertion failed: atomic_read(&mp->m_active_trans) == 0, file:
fs/xfs/xfs_vfsops.c, line 689.

The remount read-only of the root drive supposedly completed
while there was still active modification of the filesystem
taking place.

> Kernel version was kernel.org 2.6.23.9 compiled as a low latency desktop. 

The patch in 2.6.23 that introduced this check was:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=516b2e7c2661615ba5d5ad9fb584f068363502d3

Basically, the remount-readonly path was not flushing things
properly, so we changed it to flushing things properly and ensure we
got bug reports if it wasn't. Yours is the second report of not
shutting down correctly since this change went in (we've seen it
once in ~8 months in a QA environment).

I've had suspicions of a race in the remount-ro code in
do_remount_sb() w.r.t to the fs_may_remount_ro() check.  That is, we
do an unlocked check to see if we can remount readonly and then fail
to check again once we've locked the superblock out and start the
remount.

The read only flag only gets set *after* we've made the filesystem
readonly, which means before we are truly read only, we can race
with other threads opening files read/write or filesystem
modifcations can take place.

The result of that race (if it is really unsafe) will be assert you
see. The patch I wrote a couple of months ago to fix the problem
is attached below....

Cheers,

Dave.

---

Set the MS_RDONLY before we check to see if we can remount
read only so that we close a race between checking remount
is ok and setting the superblock flag that allows other
processes to start modifying the filesystem while it is
being remounted.

Signed-off-by: Dave Chinner <dgc@sgi.com>
---
 fs/xfs/linux-2.6/xfs_super.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_super.c	2008-01-22 14:57:07.753782292 +1100
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_super.c	2008-01-23 16:22:16.940279351 +1100
@@ -1222,6 +1222,22 @@ xfs_fs_remount(
 	struct xfs_mount_args	*args = xfs_args_allocate(sb, 0);
 	int			error;
 
+	/*
+	 * We need to have the MS_RDONLY flag set on the filesystem before we
+	 * try to quiesce it down to a sane state. If we don't set the
+	 * MS_RDONLY before we check the fs_may_remount_ro(sb) state, we have a
+	 * race where write operations can start after we've checked it is OK
+	 * to remount read only. This results in assert failures due to being
+	 * unable to quiesce the transaction subsystem correctly.
+	 */
+	if (!(sb->s_flags & MS_RDONLY) && (*flags & MS_RDONLY)) {
+		sb->s_flags |= MS_RDONLY;
+		if (!fs_may_remount_ro(sb)) {
+			sb->s_flags &= ~MS_RDONLY;
+			return -EBUSY;
+		}
+	}
+
 	error = xfs_parseargs(mp, options, args, 1);
 	if (!error)
 		error = xfs_mntupdate(mp, flags, args);
