Return-Path: <linux-kernel-owner+w=401wt.eu-S1765131AbXFETK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765131AbXFETK0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 15:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759965AbXFETKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 15:10:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52970 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755368AbXFETKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 15:10:18 -0400
Message-ID: <4665B50A.5020801@redhat.com>
Date: Tue, 05 Jun 2007 15:10:02 -0400
From: Peter Staubach <staubach@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070529)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: [PATCH] allow file system to configure for no leases
Content-Type: multipart/mixed;
 boundary="------------020801040403060602020104"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020801040403060602020104
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi.

Attached is a small patch to allow file systems to inform the file
system independent layers that they don't support file leases.

The problem is that some file system such as NFSv2 and NFSv3 do
not have sufficient support to be able to support leases correctly.
In particular for these two file systems, there is no over the wire
protocol support.

Currently, these two file systems fail the fcntl(F_SETLEASE) call
accidently, due to a reference counting difference.  These file systems
should fail more consciously, with a proper error to indicate that
the call is invalid for them.

    Thanx...

       ps

--------------020801040403060602020104
Content-Type: text/plain;
 name="devel.tototoday"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="devel.tototoday"

--- linux-2.6.21.i686/fs/nfs/super.c.org
+++ linux-2.6.21.i686/fs/nfs/super.c
@@ -522,6 +522,9 @@ static inline void nfs_initialise_sb(str
 
 	sb->s_magic = NFS_SUPER_MAGIC;
 
+	if (server->nfs_client->cl_nfsversion < 4)
+		sb->s_flags |= MS_NO_LEASES;
+
 	/* We probably want something more informative here */
 	snprintf(sb->s_id, sizeof(sb->s_id),
 		 "%x:%x", MAJOR(sb->s_dev), MINOR(sb->s_dev));
--- linux-2.6.21.i686/fs/locks.c.org
+++ linux-2.6.21.i686/fs/locks.c
@@ -1493,6 +1493,8 @@ int fcntl_setlease(unsigned int fd, stru
 	error = security_file_lock(filp, arg);
 	if (error)
 		return error;
+	if (IS_NO_LEASES(inode))
+		return -EINVAL;
 
 	locks_init_lock(&fl);
 	error = lease_init(filp, arg, &fl);
--- linux-2.6.21.i686/include/linux/fs.h.org
+++ linux-2.6.21.i686/include/linux/fs.h
@@ -121,6 +121,7 @@ extern int dir_notify_enable;
 #define MS_SLAVE	(1<<19)	/* change to slave */
 #define MS_SHARED	(1<<20)	/* change to shared */
 #define MS_RELATIME	(1<<21)	/* Update atime relative to mtime/ctime. */
+#define MS_NO_LEASES	(1<<22)	/* fs does not support leases */
 #define MS_ACTIVE	(1<<30)
 #define MS_NOUSER	(1<<31)
 
@@ -180,6 +181,7 @@ extern int dir_notify_enable;
 #define IS_NOCMTIME(inode)	((inode)->i_flags & S_NOCMTIME)
 #define IS_SWAPFILE(inode)	((inode)->i_flags & S_SWAPFILE)
 #define IS_PRIVATE(inode)	((inode)->i_flags & S_PRIVATE)
+#define IS_NO_LEASES(inode)	__IS_FLG(inode, MS_NO_LEASES)
 
 /* the read-only stuff doesn't really belong here, but any other place is
    probably as bad and I don't want to create yet another include file. */

--------------020801040403060602020104--
