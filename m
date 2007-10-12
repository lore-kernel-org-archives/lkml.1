Return-Path: <linux-kernel-owner+w=401wt.eu-S932421AbXJLQSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932421AbXJLQSc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758063AbXJLQHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:07:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43878 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932433AbXJLQHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:07:34 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 24/52] CRED: Pass credentials through inode_setattr()
To: viro@ftp.linux.org.uk
Cc: kwc@citi.umich.edu, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Fri, 12 Oct 2007 17:07:22 +0100
Message-ID: <20071012160722.15119.69745.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
References: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pass credentials through the inode_setattr() function.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/attr.c             |    5 ++---
 fs/ext3/inode.c       |    2 +-
 fs/fat/file.c         |    2 +-
 fs/proc/base.c        |    2 +-
 fs/proc/generic.c     |    2 +-
 fs/proc/proc_sysctl.c |    2 +-
 fs/sysfs/inode.c      |    2 +-
 include/linux/fs.h    |    3 ++-
 mm/shmem.c            |    2 +-
 9 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/attr.c b/fs/attr.c
index 1b2908c..f70bffc 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -66,9 +66,8 @@ error:
 
 EXPORT_SYMBOL(inode_change_ok);
 
-int inode_setattr(struct inode * inode, struct iattr * attr)
+int inode_setattr(struct inode * inode, struct iattr * attr, struct cred *cred)
 {
-	struct cred *cred = current->cred;
 	unsigned int ia_valid = attr->ia_valid;
 
 	if (ia_valid & ATTR_SIZE &&
@@ -161,7 +160,7 @@ int notify_change(struct dentry * dentry, struct iattr * attr)
 			    (ia_valid & ATTR_GID && attr->ia_gid != inode->i_gid))
 				error = DQUOT_TRANSFER(inode, attr) ? -EDQUOT : 0;
 			if (!error)
-				error = inode_setattr(inode, attr);
+				error = inode_setattr(inode, attr, cred);
 		}
 	}
 
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index deb0d56..8635acc 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -2996,7 +2996,7 @@ int ext3_setattr(struct dentry *dentry, struct iattr *attr, struct cred *cred)
 		ext3_journal_stop(handle);
 	}
 
-	rc = inode_setattr(inode, attr);
+	rc = inode_setattr(inode, attr, cred);
 
 	/* If inode_setattr's call to ext3_truncate failed to get a
 	 * transaction handle at all, we need to clean up the in-core
diff --git a/fs/fat/file.c b/fs/fat/file.c
index 4c856c5..f0b3faa 100644
--- a/fs/fat/file.c
+++ b/fs/fat/file.c
@@ -197,7 +197,7 @@ int fat_notify_change(struct dentry *dentry, struct iattr *attr,
 			error = 0;
 		goto out;
 	}
-	error = inode_setattr(inode, attr);
+	error = inode_setattr(inode, attr, cred);
 	if (error)
 		goto out;
 
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 0612ea4..c7f9940 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -354,7 +354,7 @@ static int proc_setattr(struct dentry *dentry, struct iattr *attr,
 
 	error = inode_change_ok(inode, attr);
 	if (!error)
-		error = inode_setattr(inode, attr);
+		error = inode_setattr(inode, attr, cred);
 	return error;
 }
 
diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index 706d373..00a2192 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -244,7 +244,7 @@ static int proc_notify_change(struct dentry *dentry, struct iattr *iattr,
 	if (error)
 		goto out;
 
-	error = inode_setattr(inode, iattr);
+	error = inode_setattr(inode, iattr, cred);
 	if (error)
 		goto out;
 	
diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index a939a09..4db895c 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -431,7 +431,7 @@ static int proc_sys_setattr(struct dentry *dentry, struct iattr *attr,
 
 	error = inode_change_ok(inode, attr);
 	if (!error)
-		error = inode_setattr(inode, attr);
+		error = inode_setattr(inode, attr, cred);
 
 	return error;
 }
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index 6b4fac5..04fc15f 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -62,7 +62,7 @@ int sysfs_setattr(struct dentry * dentry, struct iattr * iattr,
 	if (error)
 		return error;
 
-	error = inode_setattr(inode, iattr);
+	error = inode_setattr(inode, iattr, cred);
 	if (error)
 		return error;
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index ec9ed45..10245c6 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1825,7 +1825,8 @@ extern int buffer_migrate_page(struct address_space *,
 #endif
 
 extern int inode_change_ok(struct inode *, struct iattr *);
-extern int __must_check inode_setattr(struct inode *, struct iattr *);
+extern int __must_check inode_setattr(struct inode *, struct iattr *,
+				      struct cred *);
 
 extern void file_update_time(struct file *file);
 
diff --git a/mm/shmem.c b/mm/shmem.c
index f6054e0..ccab183 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -752,7 +752,7 @@ static int shmem_notify_change(struct dentry *dentry, struct iattr *attr,
 
 	error = inode_change_ok(inode, attr);
 	if (!error)
-		error = inode_setattr(inode, attr);
+		error = inode_setattr(inode, attr, cred);
 #ifdef CONFIG_TMPFS_POSIX_ACL
 	if (!error && (attr->ia_valid & ATTR_MODE))
 		error = generic_acl_chmod(inode, &shmem_acl_ops);

