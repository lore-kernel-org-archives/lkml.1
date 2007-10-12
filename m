Return-Path: <linux-kernel-owner+w=401wt.eu-S1760169AbXJLQG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760169AbXJLQG7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:06:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760069AbXJLQFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:05:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43711 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757667AbXJLQFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:05:50 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 04/52] CRED: Pass credentials down to ext3 inode allocator
To: viro@ftp.linux.org.uk
Cc: kwc@citi.umich.edu, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Fri, 12 Oct 2007 17:05:39 +0100
Message-ID: <20071012160539.15119.25313.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
References: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pass credentials down to the ext3 inode allocator.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/ext3/ialloc.c         |    6 +++---
 fs/ext3/xattr.h          |    4 ++--
 fs/ext3/xattr_security.c |    4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/ext3/ialloc.c b/fs/ext3/ialloc.c
index 596d8ca..7335461 100644
--- a/fs/ext3/ialloc.c
+++ b/fs/ext3/ialloc.c
@@ -547,7 +547,7 @@ got:
 		percpu_counter_inc(&sbi->s_dirs_counter);
 	sb->s_dirt = 1;
 
-	inode->i_uid = current->cred->uid;
+	inode->i_uid = cred->uid;
 	if (test_opt (sb, GRPID))
 		inode->i_gid = dir->i_gid;
 	else if (dir->i_mode & S_ISGID) {
@@ -555,7 +555,7 @@ got:
 		if (S_ISDIR(mode))
 			mode |= S_ISGID;
 	} else
-		inode->i_gid = current->cred->gid;
+		inode->i_gid = cred->gid;
 	inode->i_mode = mode;
 
 	inode->i_ino = ino;
@@ -607,7 +607,7 @@ got:
 	if (err)
 		goto fail_free_drop;
 
-	err = ext3_init_security(handle,inode, dir);
+	err = ext3_init_security(handle,inode, dir, cred);
 	if (err)
 		goto fail_free_drop;
 
diff --git a/fs/ext3/xattr.h b/fs/ext3/xattr.h
index 761772a..8d00a18 100644
--- a/fs/ext3/xattr.h
+++ b/fs/ext3/xattr.h
@@ -137,10 +137,10 @@ exit_ext3_xattr(void)
 
 #ifdef CONFIG_EXT3_FS_SECURITY
 extern int ext3_init_security(handle_t *handle, struct inode *inode,
-				struct inode *dir);
+				struct inode *dir, struct cred *cred);
 #else
 static inline int ext3_init_security(handle_t *handle, struct inode *inode,
-				struct inode *dir)
+				struct inode *dir, struct cred *cred)
 {
 	return 0;
 }
diff --git a/fs/ext3/xattr_security.c b/fs/ext3/xattr_security.c
index 76ccead..9a949e3 100644
--- a/fs/ext3/xattr_security.c
+++ b/fs/ext3/xattr_security.c
@@ -50,9 +50,9 @@ ext3_xattr_security_set(struct inode *inode, const char *name,
 }
 
 int
-ext3_init_security(handle_t *handle, struct inode *inode, struct inode *dir)
+ext3_init_security(handle_t *handle, struct inode *inode, struct inode *dir,
+		   struct cred *cred)
 {
-	struct cred *cred = current->cred;
 	int err;
 	size_t len;
 	void *value;

