Return-Path: <linux-kernel-owner+w=401wt.eu-S1753829AbYHLNmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829AbYHLNmX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 09:42:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbYHLNmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 09:42:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47163 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752029AbYHLNmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 09:42:13 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/2] CRED: Alter XFS so as to avoid namespace collisions with
	upcoming COW creds
To: sfr@canb.auug.org.au, jmorris@namei.org, hch@infradead.org
Cc: dhowells@redhat.com, davem@davemloft.net, sfrench@us.ibm.com,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Date: Tue, 12 Aug 2008 14:28:45 +0100
Message-ID: <20080812132845.5472.30943.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080812132840.5472.25856.stgit@warthog.procyon.org.uk>
References: <20080812132840.5472.25856.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename XFS's current_fsuid() and current_fsgid() to avoid collision with
functions of the same name in upcoming COW creds.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/xfs/linux-2.6/xfs_linux.h |    4 ++--
 fs/xfs/xfs_inode.c           |    4 ++--
 fs/xfs/xfs_vnodeops.c        |    8 ++++----
 3 files changed, 8 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/linux-2.6/xfs_linux.h b/fs/xfs/linux-2.6/xfs_linux.h
index 4d45d93..05a2e7e 100644
--- a/fs/xfs/linux-2.6/xfs_linux.h
+++ b/fs/xfs/linux-2.6/xfs_linux.h
@@ -126,8 +126,8 @@
 
 #define current_cpu()		(raw_smp_processor_id())
 #define current_pid()		(current->pid)
-#define current_fsuid(cred)	(current->fsuid)
-#define current_fsgid(cred)	(current->fsgid)
+#define this_fsuid(cred)	(current->fsuid)
+#define this_fsgid(cred)	(current->fsgid)
 #define current_test_flags(f)	(current->flags & (f))
 #define current_set_flags_nested(sp, f)		\
 		(*(sp) = current->flags, current->flags |= (f))
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index bedc661..5e481ae 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1082,8 +1082,8 @@ xfs_ialloc(
 	ip->i_d.di_onlink = 0;
 	ip->i_d.di_nlink = nlink;
 	ASSERT(ip->i_d.di_nlink == nlink);
-	ip->i_d.di_uid = current_fsuid(cr);
-	ip->i_d.di_gid = current_fsgid(cr);
+	ip->i_d.di_uid = this_fsuid(cr);
+	ip->i_d.di_gid = this_fsgid(cr);
 	ip->i_d.di_projid = prid;
 	memset(&(ip->i_d.di_pad[0]), 0, sizeof(ip->i_d.di_pad));
 
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 76a1166..3dfe8a0 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -182,7 +182,7 @@ xfs_setattr(
 	xfs_ilock(ip, lock_flags);
 
 	/* boolean: are we the file owner? */
-	file_owner = (current_fsuid(credp) == ip->i_d.di_uid);
+	file_owner = (this_fsuid(credp) == ip->i_d.di_uid);
 
 	/*
 	 * Change various properties of a file.
@@ -1536,7 +1536,7 @@ xfs_create(
 	 * Make sure that we have allocated dquot(s) on disk.
 	 */
 	error = XFS_QM_DQVOPALLOC(mp, dp,
-			current_fsuid(credp), current_fsgid(credp), prid,
+			this_fsuid(credp), this_fsgid(credp), prid,
 			XFS_QMOPT_QUOTALL|XFS_QMOPT_INHERIT, &udqp, &gdqp);
 	if (error)
 		goto std_return;
@@ -2352,7 +2352,7 @@ xfs_mkdir(
 	 * Make sure that we have allocated dquot(s) on disk.
 	 */
 	error = XFS_QM_DQVOPALLOC(mp, dp,
-			current_fsuid(credp), current_fsgid(credp), prid,
+			this_fsuid(credp), this_fsgid(credp), prid,
 			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT, &udqp, &gdqp);
 	if (error)
 		goto std_return;
@@ -2578,7 +2578,7 @@ xfs_symlink(
 	 * Make sure that we have allocated dquot(s) on disk.
 	 */
 	error = XFS_QM_DQVOPALLOC(mp, dp,
-			current_fsuid(credp), current_fsgid(credp), prid,
+			this_fsuid(credp), this_fsgid(credp), prid,
 			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT, &udqp, &gdqp);
 	if (error)
 		goto std_return;

