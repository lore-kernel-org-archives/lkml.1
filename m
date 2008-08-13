Return-Path: <linux-kernel-owner+w=401wt.eu-S1755892AbYHMP2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892AbYHMP2N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 11:28:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752973AbYHMP15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 11:27:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53595 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973AbYHMP14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 11:27:56 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] CRED: Introduce credential access wrappers
To: sfr@canb.auug.org.au, jmorris@namei.org, hch@infradead.org
Cc: dhowells@redhat.com, davem@davemloft.net, sfrench@us.ibm.com,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Date: Wed, 13 Aug 2008 16:20:04 +0100
Message-ID: <20080813152004.16561.6403.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patches that are intended to introduce copy-on-write credentials for 2.6.28
require abstraction of access to some fields of the task structure,
particularly for the case of one task accessing another's credentials where RCU
will have to be observed.

Introduced here are trivial no-op versions of the desired accessors for current
and other tasks so that other subsystems can start to be converted over more
easily.

Wrappers are introduced into a new header (linux/cred.h) for UID/GID,
EUID/EGID, SUID/SGID, FSUID/FSGID, cap_effective and current's subscribed
user_struct.  These wrappers are macros because the ordering between header
files mitigates against making them inline functions.

linux/cred.h is #included from linux/sched.h.

Further, XFS is modified such that it no longer defines and uses parameterised
versions of current_fs[ug]id(), thus getting rid of the namespace collision
otherwise incurred.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/xfs/linux-2.6/xfs_linux.h |    2 --
 fs/xfs/xfs_inode.c           |    4 ++-
 fs/xfs/xfs_vnodeops.c        |    8 +++----
 include/linux/cred.h         |   50 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/sched.h        |    1 +
 5 files changed, 57 insertions(+), 8 deletions(-)
 create mode 100644 include/linux/cred.h


diff --git a/fs/xfs/linux-2.6/xfs_linux.h b/fs/xfs/linux-2.6/xfs_linux.h
index 4d45d93..568de2f 100644
--- a/fs/xfs/linux-2.6/xfs_linux.h
+++ b/fs/xfs/linux-2.6/xfs_linux.h
@@ -126,8 +126,6 @@
 
 #define current_cpu()		(raw_smp_processor_id())
 #define current_pid()		(current->pid)
-#define current_fsuid(cred)	(current->fsuid)
-#define current_fsgid(cred)	(current->fsgid)
 #define current_test_flags(f)	(current->flags & (f))
 #define current_set_flags_nested(sp, f)		\
 		(*(sp) = current->flags, current->flags |= (f))
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index bedc661..7bfa2d4 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1082,8 +1082,8 @@ xfs_ialloc(
 	ip->i_d.di_onlink = 0;
 	ip->i_d.di_nlink = nlink;
 	ASSERT(ip->i_d.di_nlink == nlink);
-	ip->i_d.di_uid = current_fsuid(cr);
-	ip->i_d.di_gid = current_fsgid(cr);
+	ip->i_d.di_uid = current_fsuid();
+	ip->i_d.di_gid = current_fsgid();
 	ip->i_d.di_projid = prid;
 	memset(&(ip->i_d.di_pad[0]), 0, sizeof(ip->i_d.di_pad));
 
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 76a1166..3a55cbd 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -182,7 +182,7 @@ xfs_setattr(
 	xfs_ilock(ip, lock_flags);
 
 	/* boolean: are we the file owner? */
-	file_owner = (current_fsuid(credp) == ip->i_d.di_uid);
+	file_owner = (current_fsuid() == ip->i_d.di_uid);
 
 	/*
 	 * Change various properties of a file.
@@ -1536,7 +1536,7 @@ xfs_create(
 	 * Make sure that we have allocated dquot(s) on disk.
 	 */
 	error = XFS_QM_DQVOPALLOC(mp, dp,
-			current_fsuid(credp), current_fsgid(credp), prid,
+			current_fsuid(), current_fsgid(), prid,
 			XFS_QMOPT_QUOTALL|XFS_QMOPT_INHERIT, &udqp, &gdqp);
 	if (error)
 		goto std_return;
@@ -2352,7 +2352,7 @@ xfs_mkdir(
 	 * Make sure that we have allocated dquot(s) on disk.
 	 */
 	error = XFS_QM_DQVOPALLOC(mp, dp,
-			current_fsuid(credp), current_fsgid(credp), prid,
+			current_fsuid(), current_fsgid(), prid,
 			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT, &udqp, &gdqp);
 	if (error)
 		goto std_return;
@@ -2578,7 +2578,7 @@ xfs_symlink(
 	 * Make sure that we have allocated dquot(s) on disk.
 	 */
 	error = XFS_QM_DQVOPALLOC(mp, dp,
-			current_fsuid(credp), current_fsgid(credp), prid,
+			current_fsuid(), current_fsgid(), prid,
 			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT, &udqp, &gdqp);
 	if (error)
 		goto std_return;
diff --git a/include/linux/cred.h b/include/linux/cred.h
new file mode 100644
index 0000000..b69222c
--- /dev/null
+++ b/include/linux/cred.h
@@ -0,0 +1,50 @@
+/* Credentials management
+ *
+ * Copyright (C) 2008 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef _LINUX_CRED_H
+#define _LINUX_CRED_H
+
+#define get_current_user()	(get_uid(current->user))
+
+#define task_uid(task)		((task)->uid)
+#define task_gid(task)		((task)->gid)
+#define task_euid(task)		((task)->euid)
+#define task_egid(task)		((task)->egid)
+
+#define current_uid()		(current->uid)
+#define current_gid()		(current->gid)
+#define current_euid()		(current->euid)
+#define current_egid()		(current->egid)
+#define current_suid()		(current->suid)
+#define current_sgid()		(current->sgid)
+#define current_fsuid()		(current->fsuid)
+#define current_fsgid()		(current->fsgid)
+#define current_cap()		(current->cap_effective)
+
+#define current_uid_gid(_uid, _gid)		\
+do {						\
+	*(_uid) = current->uid;			\
+	*(_gid) = current->gid;			\
+} while(0)
+
+#define current_euid_egid(_uid, _gid)		\
+do {						\
+	*(_uid) = current->euid;		\
+	*(_gid) = current->egid;		\
+} while(0)
+
+#define current_fsuid_fsgid(_uid, _gid)		\
+do {						\
+	*(_uid) = current->fsuid;		\
+	*(_gid) = current->fsgid;		\
+} while(0)
+
+#endif /* _LINUX_CRED_H */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5850bfb..cfb0d87 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -87,6 +87,7 @@ struct sched_param {
 #include <linux/task_io_accounting.h>
 #include <linux/kobject.h>
 #include <linux/latencytop.h>
+#include <linux/cred.h>
 
 #include <asm/processor.h>
 

