Return-Path: <linux-kernel-owner+w=401wt.eu-S1760758AbXF0MwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760758AbXF0MwS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 08:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758094AbXF0MwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 08:52:07 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:24759 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757678AbXF0MwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 08:52:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=U4iCjPRC2FzxH+y62+l+3+8Yh7iAn+7Dvy7p1Qm+IKYni6x6NKoA+rV4szYiqRH9WRHGXhUJiONmwWjP+lGTGXO4mmaX8CDxEOL3ZiJisQg5dxyJ8gDph7VdZHDpEjuNvgwwtONdmRlFGjkNXCd6J313/L68sPwhiQUrjlFk5hU=
Message-ID: <46825D77.4050608@gmail.com>
Date: Wed, 27 Jun 2007 20:52:07 +0800
From: Hawk Xu <hxunix@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: linux-security-module@vger.kernel.org
CC: linux-kernel@vger.kernel.org, jmorris@namei.org, serue@us.ibm.com,
       chrisw@sous-sol.org, sds@tycho.nsa.gov, greg@kroah.com,
       eparis@redhat.com
Subject: [PATCH] [RFC] security: add hook inode_post_removexattr
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add hook inode_post_removexattr for updating inode security field after successful removexattr operation.

Signed-off-by: Hawk Xu <hxunix@gmail.com>
---


  fs/xattr.c               |    7 +++++--
  include/linux/security.h |   19 +++++++++++++++++++
  security/dummy.c         |    6 ++++++
  3 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/fs/xattr.c b/fs/xattr.c
index 4523aca..22c2438 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -180,10 +180,13 @@ vfs_removexattr(struct dentry *dentry, char *name)

  	mutex_lock(&inode->i_mutex);
  	error = inode->i_op->removexattr(dentry, name);
+	if (!error) {
+		fsnotify_xattr(dentry);
+		security_inode_post_removexattr(dentry, name, value,
+						size, flags);
+	}
  	mutex_unlock(&inode->i_mutex);

-	if (!error)
-		fsnotify_xattr(dentry);
  	return error;
  }
  EXPORT_SYMBOL_GPL(vfs_removexattr);
diff --git a/include/linux/security.h b/include/linux/security.h
index 1a362c8..5100b23 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -393,6 +393,9 @@ struct request_sock;
   * 	Check permission before removing the extended attribute
   * 	identified by @name for @dentry.
   * 	Return 0 if permission is granted.
+ * @inode_post_removexattr:
+ * 	Update inode security field after successful removexattr operation.
+ * 	@value identified by @name for @dentry.
   * @inode_getsecurity:
   *	Copy the extended attribute representation of the security label
   *	associated with @name for @inode into @buffer.  @buffer may be
@@ -1234,6 +1237,8 @@ struct security_operations {
  	int (*inode_getxattr) (struct dentry *dentry, char *name);
  	int (*inode_listxattr) (struct dentry *dentry);
  	int (*inode_removexattr) (struct dentry *dentry, char *name);
+	void (*inode_post_removexattr) (struct dentry *dentry, char *name,
+					void *value, size_t size, int flags);
  	const char *(*inode_xattr_getsuffix) (void);
    	int (*inode_getsecurity)(const struct inode *inode, const char *name, void *buffer, size_t size, int err);
    	int (*inode_setsecurity)(struct inode *inode, const char *name, const void *value, size_t size, int flags);
@@ -1769,6 +1774,15 @@ static inline int security_inode_removexattr (struct dentry *dentry, char *name)
  	return security_ops->inode_removexattr (dentry, name);
  }

+static inline void security_inode_post_removexattr (struct dentry *dentry,
+						char *name, void *value,
+						size_t size, int flags)
+{
+	if (unlikely (IS_PRIVATE (dentry->d_inode)))
+		return;
+	security_ops->inode_post_removexattr (dentry, name, value, size, flags);
+}
+
  static inline const char *security_inode_xattr_getsuffix(void)
  {
  	return security_ops->inode_xattr_getsuffix();
@@ -2452,6 +2466,11 @@ static inline int security_inode_removexattr (struct dentry *dentry, char *name)
  	return cap_inode_removexattr(dentry, name);
  }

+static inline void security_inode_post_removexattr (struct dentry *dentry,
+						char *name, void *value,
+						size_t size, int flags)
+{ }
+
  static inline const char *security_inode_xattr_getsuffix (void)
  {
  	return NULL ;
diff --git a/security/dummy.c b/security/dummy.c
index bdd0d70..4953f06 100644
--- a/security/dummy.c
+++ b/security/dummy.c
@@ -377,6 +377,11 @@ static int dummy_inode_removexattr (struct dentry *dentry, char *name)
  	return 0;
  }

+static void dummy_inode_post_removexattr (struct dentry *dentry, char *name,
+					void *value, size_t size, int flags)
+{
+}
+
  static int dummy_inode_getsecurity(const struct inode *inode, const char *name, void *buffer, size_t size, int err)
  {
  	return -EOPNOTSUPP;
@@ -1014,6 +1019,7 @@ void security_fixup_ops (struct security_operations *ops)
  	set_to_dummy_if_null(ops, inode_getxattr);
  	set_to_dummy_if_null(ops, inode_listxattr);
  	set_to_dummy_if_null(ops, inode_removexattr);
+	set_to_dummy_if_null(ops, inode_post_removexattr);
  	set_to_dummy_if_null(ops, inode_xattr_getsuffix);
  	set_to_dummy_if_null(ops, inode_getsecurity);
  	set_to_dummy_if_null(ops, inode_setsecurity);
