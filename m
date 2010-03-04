Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532Ab0CDLM4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 06:12:56 -0500
Received: from smtprelay-h21.telenor.se ([195.54.99.196]:57797 "EHLO
	smtprelay-h21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755410Ab0CDLMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 06:12:54 -0500
X-Greylist: delayed 1359 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Mar 2010 06:12:54 EST
X-SMTPAUTH-B2: 
X-SENDER-IP: 83.227.31.74
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao03AJ8fj0tT4x9KPGdsb2JhbACDCZgMDAEBAQE3LacIkC+EEmoE
X-IronPort-AV: E=Sophos;i="4.49,580,1262559600"; 
   d="scan'208";a="45653253"
From: Jon Severinsson <jon@severinsson.net>
To: linux-cifs-client@lists.samba.org
Subject: [RFC PATCH] CIFS posix acl permission checking
Date: Thu, 4 Mar 2010 11:50:04 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.32-gentoo-r7; KDE/4.3.5; x86_64; ; )
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_gB5jLILOsQkISA0"
Message-Id: <201003041150.08341.jon@severinsson.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_gB5jLILOsQkISA0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hello

Early this weak I sent a patch implementing posix acl permission checking in 
the linux cifs filesystem module. Unfortunately I only sent it to linux-fsdev 
as I was unaware of the linux-cifs-client list. I later tried to submit it to 
linux-cifs-client as well, but my message seems to have been lost in the 
moderation queue, so I subscribed and am trying again.

I don't believe my patch is perfect, but I think it's a good start, and would 
like some comments from more experienced cifs developers to be able to get it 
into shape for inclusion in the kernel. 

I did get some comments from Matthew Wilcox at linux-fsdev, but unfortunately 
he never followed up on my response, so I'm including some unresolved 
questions I still have, as well as attaching the patch for further comments.

Best Regards
Jon Severinsson

On Monday 01 March 2010 19:33:41, Jon Severinsson wrote:
> On Monday 01 March 2010 18:03:49, Matthew Wilcox wrote:
>> You've included ifdefs around the check_acl entry in inode_operations,
>> *and* inside the definition of cifs_check_acl.  You only need to do
>> one or the other, and opinion is divided on which is better.
> 
> While I did recognize the redundancy, I decided to follow the same
> convention the other functions in xattr.c did, and include ifdefs at both
> locations.
> 
> I also considered the possible reasons for the existing functions to do
> both, and and came up with two reasons. The first simply being the paradigm
> of defensive programming, always check before doing a call, but never assume
> that the check has been done before being called. The second one is that of
> performance. The ifdefs has to be in cifs_check_acl to protect against other
> callers (while this patch doesn't introduce any, it doesn't prevent further
> patches from adding them), and not including the ifdefs in inode_operations
> would mean a completely useless function call when a feature was turned off
> at compile time. The second one is a micro-optimization I don't really care
> fore, but defensive programming I do respect.
> 
> With this in mind, what do you recommend, double protection, breaking
> convention or changing the existing code?
>
>>> +int cifs_check_acl(struct inode *inode, int mask)
>>> +{
>>> +	int rc = -EOPNOTSUPP;
>>> +#ifdef CONFIG_CIFS_XATTR
>>> +#ifdef CONFIG_CIFS_POSIX
>>> +	struct dentry *dentry;
>>> +	size_t buf_size;
>>> +	void *ea_value = NULL;
>>> +	ssize_t ea_size;
>>> +	struct posix_acl *acl = NULL;
>>
>> I don't think you need to initialise ea_value, do you?
> 
> While currently correct, I find it a good idea to immediately null any
> pointer that is freed in the exit section. Otherwise it is very easy to
> forget to do that the day someone adds a goto prior to the first
> assignment, and not nulling then can have unintended consequences in
> unrelated code. That being said, if you say that the kernel community
> frowns upon that kind of defensive programming I will definitely remove
> it.


--Boundary-00=_gB5jLILOsQkISA0
Content-Type: text/x-patch;
  charset="UTF-8";
  name="cifs-acl-permission-check-v2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="cifs-acl-permission-check-v2.patch"

commit fa0b9415cda17b31966542101bc4ceb0c97c87cb
Author: Jon Severinsson <jon@severinsson.net>
Date:   Mon Mar 1 19:24:30 2010 +0100

    [CIFS] Adds support for permision checking vs. posix acl.
    
    CIFS already supports getting and setting acls through getfacl and setfacl, but
    prior to this patch, any acls was ignored when doing permission checking.

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 29f1da7..0605e11 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -284,7 +284,7 @@ static int cifs_permission(struct inode *inode, int mask)
 		on the client (above and beyond ACL on servers) for
 		servers which do not support setting and viewing mode bits,
 		so allowing client to check permissions is useful */
-		return generic_permission(inode, mask, NULL);
+		return generic_permission(inode, mask, inode->i_op->check_acl);
 }
 
 static struct kmem_cache *cifs_inode_cachep;
@@ -702,6 +702,9 @@ const struct inode_operations cifs_dir_inode_ops = {
 	.getxattr = cifs_getxattr,
 	.listxattr = cifs_listxattr,
 	.removexattr = cifs_removexattr,
+#ifdef CONFIG_CIFS_POSIX
+	.check_acl = cifs_check_acl,
+#endif
 #endif
 };
 
@@ -716,6 +719,9 @@ const struct inode_operations cifs_file_inode_ops = {
 	.getxattr = cifs_getxattr,
 	.listxattr = cifs_listxattr,
 	.removexattr = cifs_removexattr,
+#ifdef CONFIG_CIFS_POSIX
+	.check_acl = cifs_check_acl,
+#endif
 #endif
 };
 
@@ -732,6 +738,9 @@ const struct inode_operations cifs_symlink_inode_ops = {
 	.getxattr = cifs_getxattr,
 	.listxattr = cifs_listxattr,
 	.removexattr = cifs_removexattr,
+#ifdef CONFIG_CIFS_POSIX
+	.check_acl = cifs_check_acl,
+#endif
 #endif
 };
 
diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
index ac2b24c..6409a83 100644
--- a/fs/cifs/cifsfs.h
+++ b/fs/cifs/cifsfs.h
@@ -102,11 +102,15 @@ extern int cifs_readlink(struct dentry *direntry, char __user *buffer,
 			 int buflen);
 extern int cifs_symlink(struct inode *inode, struct dentry *direntry,
 			const char *symname);
+
+/* Functions related to extended attributes */
 extern int	cifs_removexattr(struct dentry *, const char *);
 extern int 	cifs_setxattr(struct dentry *, const char *, const void *,
 			size_t, int);
 extern ssize_t	cifs_getxattr(struct dentry *, const char *, void *, size_t);
 extern ssize_t	cifs_listxattr(struct dentry *, char *, size_t);
+extern int cifs_check_acl(struct inode *inode, int mask);
+
 extern long cifs_ioctl(struct file *filep, unsigned int cmd, unsigned long arg);
 
 #ifdef CONFIG_CIFS_EXPERIMENTAL
diff --git a/fs/cifs/xattr.c b/fs/cifs/xattr.c
index a75afa3..a07633b 100644
--- a/fs/cifs/xattr.c
+++ b/fs/cifs/xattr.c
@@ -374,3 +374,71 @@ ssize_t cifs_listxattr(struct dentry *direntry, char *data, size_t buf_size)
 #endif
 	return rc;
 }
+
+int cifs_check_acl(struct inode *inode, int mask)
+{
+	int rc = -EOPNOTSUPP;
+#ifdef CONFIG_CIFS_XATTR
+#ifdef CONFIG_CIFS_POSIX
+	struct dentry *dentry;
+	size_t buf_size;
+	void *ea_value = NULL;
+	ssize_t ea_size;
+	struct posix_acl *acl = NULL;
+
+	/* CIFS gets acl from server by path, and thus needs a dentry rather than
+	   an inode. Note that the path of each dentry will point to the same inode
+	   on the backing fs at the server, so their acls will be the same, and it
+	   doesn't matter which one we pick, so just pick the fist. */
+	if (!list_empty(&inode->i_dentry))
+		dentry = list_first_entry(&inode->i_dentry, struct dentry, d_alias);
+	else
+		return -EINVAL;
+
+	/* Try to fit the extended attribute corresponding to the posix acl in 4k
+	   memory. 4k was chosen because it always fits in a single page, and is
+	   the maximum on a default ext2/3/4 backing fs. */
+	buf_size = 4096;
+	ea_value = kmalloc(buf_size, GFP_KERNEL);
+	if (!ea_value) {
+		rc = -EAGAIN;
+		goto check_acl_exit;
+	}
+	ea_size = cifs_getxattr(dentry, POSIX_ACL_XATTR_ACCESS, ea_value, buf_size);
+
+	/* If 4k wasn't enough, try 64k, the maximum on any current backing fs. */
+	if (ea_size == -ERANGE) {
+		kfree(ea_value);
+		buf_size = 65536;
+		ea_value = kmalloc(buf_size, GFP_KERNEL);
+		if (!ea_value) {
+			rc = -EAGAIN;
+			goto check_acl_exit;
+		}
+		ea_size = cifs_getxattr(dentry, POSIX_ACL_XATTR_ACCESS, ea_value, buf_size);
+	}
+
+	/* If we didn't get any extended attribute, set the error code and exit */
+	if (ea_size <= 0) {
+		rc = -EAGAIN;
+		if (ea_size == -EOPNOTSUPP || ea_size == -EIO || ea_size == -ENOTDIR || ea_size == -ENOENT || ea_size == -EFAULT || ea_size == -EACCES)
+			rc = ea_size;
+		goto check_acl_exit;
+	}
+
+	/* Set the appropriate return value. Adapted from ext4. */
+	acl = posix_acl_from_xattr(ea_value, ea_size);
+	if (IS_ERR(acl))
+		rc = PTR_ERR(acl);
+	else if (acl)
+		rc = posix_acl_permission(inode, acl, mask);
+	else
+		rc = -EAGAIN;
+
+check_acl_exit:
+	posix_acl_release(acl);
+	kfree(ea_value);
+#endif /* CONFIG_CIFS_POSIX */
+#endif /* CONFIG_CIFS_XATTR */
+	return rc;
+}

--Boundary-00=_gB5jLILOsQkISA0--
