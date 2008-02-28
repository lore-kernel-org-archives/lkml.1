Return-Path: <linux-kernel-owner+w=401wt.eu-S932185AbYB1BsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932185AbYB1BsZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 20:48:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754791AbYB1BsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 20:48:12 -0500
Received: from mummy.ncsc.mil ([144.51.88.129]:55431 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754326AbYB1BsD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 20:48:03 -0500
Subject: Re: RFC Labeled NFS Initial Code Review
From: Dave Quigley <dpquigl@tycho.nsa.gov>
To: hch@infradead.org
Cc: viro@ftp.linux.org.uk, trond.myklebust@fys.uio.no, bfields@fieldses.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <1204150294-4678-1-git-send-email-dpquigl@tycho.nsa.gov>
References: <1204150294-4678-1-git-send-email-dpquigl@tycho.nsa.gov>
Content-Type: multipart/mixed; boundary="=-/a3RibfIJHEr1gDn6VW6"
Date: Wed, 27 Feb 2008 20:23:23 -0500
Message-Id: <1204161803.24345.34.camel@moss-terrapins.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-/a3RibfIJHEr1gDn6VW6
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

The attached patch is a roll-up of the patch set and applies on top of
2.6.25-rc3.

Dave

--=-/a3RibfIJHEr1gDn6VW6
Content-Disposition: attachment; filename=labeled-nfs-02272008.patch
Content-Type: text/x-patch; name=labeled-nfs-02272008.patch; charset=utf-8
Content-Transfer-Encoding: 7bit

diff --git a/fs/Kconfig b/fs/Kconfig
index d731282..d762375 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -1637,6 +1637,14 @@ config NFS_V4
 
 	  If unsure, say N.
 
+config NFS_V4_SECURITY_LABEL
+	bool "Provide Security Label support for NFSv4 client"
+	depends on NFS_V4 && SECURITY && EXPERIMENTAL
+	help
+	  Say Y here if you want label attribute support for NFS version 4.
+
+	  If unsure, say N.
+
 config NFS_DIRECTIO
 	bool "Allow direct I/O on NFS files"
 	depends on NFS_FS
@@ -1728,6 +1736,15 @@ config NFSD_V4
 	  should only be used if you are interested in helping to test NFSv4.
 	  If unsure, say N.
 
+config NFSD_V4_SECURITY_LABEL
+	bool "Provide Security Label support for NFSv4 server"
+	depends on NFSD_V4 && SECURITY && EXPERIMENTAL
+	help
+	  If you would like to include support for label file attributes
+	  over NFSv4, say Y here.
+
+	  If unsure, say N.
+
 config NFSD_TCP
 	bool "Provide NFS server over TCP support"
 	depends on NFSD
diff --git a/fs/attr.c b/fs/attr.c
index 966b73e..1df6603 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -5,6 +5,7 @@
  *  changes by Thomas Schoebel-Theuer
  */
 
+#include <linux/fs.h>
 #include <linux/module.h>
 #include <linux/time.h>
 #include <linux/mm.h>
@@ -14,9 +15,35 @@
 #include <linux/fcntl.h>
 #include <linux/quotaops.h>
 #include <linux/security.h>
+#include <linux/xattr.h>
 
 /* Taken over from the old code... */
 
+#ifdef CONFIG_SECURITY
+/*
+ * Update the in core label.
+ */
+int inode_setsecurity(struct inode *inode, struct iattr *attr)
+{
+	const char *suffix = security_maclabel_getname() 
+				+ XATTR_SECURITY_PREFIX_LEN;
+	int error;
+
+	if (!attr->ia_valid & ATTR_SECURITY_LABEL)
+		return -EINVAL;
+
+	error = security_inode_setsecurity(inode, suffix, attr->ia_label,
+					   attr->ia_label_len, 0);
+	if (error)
+		printk(KERN_ERR "%s() %s %d security_inode_setsecurity() %d\n"
+			, __func__, (char *)attr->ia_label, attr->ia_label_len
+			, error);
+
+	return error;
+}
+EXPORT_SYMBOL(inode_setsecurity);
+#endif
+
 /* POSIX UID/GID verification for setting inode attributes. */
 int inode_change_ok(struct inode *inode, struct iattr *attr)
 {
@@ -94,6 +121,10 @@ int inode_setattr(struct inode * inode, struct iattr * attr)
 			mode &= ~S_ISGID;
 		inode->i_mode = mode;
 	}
+#ifdef CONFIG_SECURITY
+	if (ia_valid & ATTR_SECURITY_LABEL)
+		inode_setsecurity(inode, attr);
+#endif
 	mark_inode_dirty(inode);
 
 	return 0;
@@ -157,6 +188,18 @@ int notify_change(struct dentry * dentry, struct iattr * attr)
 	if (ia_valid & ATTR_SIZE)
 		down_write(&dentry->d_inode->i_alloc_sem);
 
+#ifdef CONFIG_SECURITY
+	if (ia_valid & ATTR_SECURITY_LABEL) {
+		char *key = (char *)security_maclabel_getname();
+		vfs_setxattr_locked(dentry, key,
+			attr->ia_label, attr->ia_label_len, 0);
+		/* Avoid calling inode_setsecurity()
+		 * via inode_setattr() below
+		 */
+		attr->ia_valid &= ~ATTR_SECURITY_LABEL;
+	}
+#endif
+
 	if (inode->i_op && inode->i_op->setattr) {
 		error = security_inode_setattr(dentry, attr);
 		if (!error)
diff --git a/fs/nfs/client.c b/fs/nfs/client.c
index c5c0175..aa93f9d 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -878,6 +878,8 @@ struct nfs_server *nfs_create_server(const struct nfs_parsed_mount_data *data,
 	struct nfs_fattr fattr;
 	int error;
 
+	memset(&fattr, 0, sizeof(struct nfs_fattr));
+
 	server = nfs_alloc_server();
 	if (!server)
 		return ERR_PTR(-ENOMEM);
@@ -928,10 +930,12 @@ struct nfs_server *nfs_create_server(const struct nfs_parsed_mount_data *data,
 	spin_unlock(&nfs_client_lock);
 
 	server->mount_time = jiffies;
+	nfs_fattr_fini(&fattr);
 	return server;
 
 error:
 	nfs_free_server(server);
+	nfs_fattr_fini(&fattr);
 	return ERR_PTR(error);
 }
 
@@ -1083,6 +1087,8 @@ struct nfs_server *nfs4_create_server(const struct nfs_parsed_mount_data *data,
 
 	dprintk("--> nfs4_create_server()\n");
 
+	memset(&fattr, 0, sizeof(struct nfs_fattr));
+
 	server = nfs_alloc_server();
 	if (!server)
 		return ERR_PTR(-ENOMEM);
@@ -1123,11 +1129,13 @@ struct nfs_server *nfs4_create_server(const struct nfs_parsed_mount_data *data,
 	spin_unlock(&nfs_client_lock);
 
 	server->mount_time = jiffies;
+	nfs_fattr_fini(&fattr);
 	dprintk("<-- nfs4_create_server() = %p\n", server);
 	return server;
 
 error:
 	nfs_free_server(server);
+	nfs_fattr_fini(&fattr);
 	dprintk("<-- nfs4_create_server() = error %d\n", error);
 	return ERR_PTR(error);
 }
@@ -1145,6 +1153,8 @@ struct nfs_server *nfs4_create_referral_server(struct nfs_clone_mount *data,
 
 	dprintk("--> nfs4_create_referral_server()\n");
 
+	memset(&fattr, 0, sizeof(struct nfs_fattr));
+
 	server = nfs_alloc_server();
 	if (!server)
 		return ERR_PTR(-ENOMEM);
@@ -1200,11 +1210,13 @@ struct nfs_server *nfs4_create_referral_server(struct nfs_clone_mount *data,
 
 	server->mount_time = jiffies;
 
+	nfs_fattr_fini(&fattr);
 	dprintk("<-- nfs_create_referral_server() = %p\n", server);
 	return server;
 
 error:
 	nfs_free_server(server);
+	nfs_fattr_fini(&fattr);
 	dprintk("<-- nfs4_create_referral_server() = error %d\n", error);
 	return ERR_PTR(error);
 }
@@ -1226,6 +1238,8 @@ struct nfs_server *nfs_clone_server(struct nfs_server *source,
 		(unsigned long long) fattr->fsid.major,
 		(unsigned long long) fattr->fsid.minor);
 
+	memset(&fattr_fsinfo, 0, sizeof(struct nfs_fattr));
+
 	server = nfs_alloc_server();
 	if (!server)
 		return ERR_PTR(-ENOMEM);
@@ -1268,11 +1282,13 @@ struct nfs_server *nfs_clone_server(struct nfs_server *source,
 
 	server->mount_time = jiffies;
 
+	nfs_fattr_fini(&fattr_fsinfo);
 	dprintk("<-- nfs_clone_server() = %p\n", server);
 	return server;
 
 out_free_server:
 	nfs_free_server(server);
+	nfs_fattr_fini(&fattr_fsinfo);
 	dprintk("<-- nfs_clone_server() = error %d\n", error);
 	return ERR_PTR(error);
 }
diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index ae04892..bcb9e52 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -40,6 +40,10 @@
 #include "iostat.h"
 #include "internal.h"
 
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+#include <linux/security.h>
+#endif
+
 /* #define NFS_DEBUG_VERBOSE 1 */
 
 static int nfs_opendir(struct inode *, struct file *);
@@ -533,6 +537,8 @@ static int nfs_readdir(struct file *filp, void *dirent, filldir_t filldir)
 			(long long)filp->f_pos);
 	nfs_inc_stats(inode, NFSIOS_VFSGETDENTS);
 
+	memset(&fattr, 0, sizeof(struct nfs_fattr));
+
 	lock_kernel();
 
 	/*
@@ -589,6 +595,7 @@ static int nfs_readdir(struct file *filp, void *dirent, filldir_t filldir)
 			res = 0;
 			break;
 		}
+		nfs_fattr_fini(&fattr);
 	}
 out:
 	nfs_unblock_sillyrename(dentry);
@@ -764,6 +771,8 @@ static int nfs_lookup_revalidate(struct dentry * dentry, struct nameidata *nd)
 	struct nfs_fh fhandle;
 	struct nfs_fattr fattr;
 
+	memset(&fattr, 0, sizeof(struct nfs_fattr));
+
 	parent = dget_parent(dentry);
 	lock_kernel();
 	dir = parent->d_inode;
@@ -793,6 +802,11 @@ static int nfs_lookup_revalidate(struct dentry * dentry, struct nameidata *nd)
 	if (NFS_STALE(inode))
 		goto out_bad;
 
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (nfs_server_capable(dir, NFS_CAP_SECURITY_LABEL))
+		nfs_fattr_alloc(&fattr, GFP_NOWAIT);
+#endif
+
 	error = NFS_PROTO(dir)->lookup(dir, &dentry->d_name, &fhandle, &fattr);
 	if (error)
 		goto out_bad;
@@ -805,6 +819,7 @@ static int nfs_lookup_revalidate(struct dentry * dentry, struct nameidata *nd)
  out_valid:
 	unlock_kernel();
 	dput(parent);
+	nfs_fattr_fini(&fattr);
 	dfprintk(LOOKUPCACHE, "NFS: %s(%s/%s) is valid\n",
 			__FUNCTION__, dentry->d_parent->d_name.name,
 			dentry->d_name.name);
@@ -824,6 +839,7 @@ out_zap_parent:
 	d_drop(dentry);
 	unlock_kernel();
 	dput(parent);
+	nfs_fattr_fini(&fattr);
 	dfprintk(LOOKUPCACHE, "NFS: %s(%s/%s) is invalid\n",
 			__FUNCTION__, dentry->d_parent->d_name.name,
 			dentry->d_name.name);
@@ -894,6 +910,8 @@ static struct dentry *nfs_lookup(struct inode *dir, struct dentry * dentry, stru
 		dentry->d_parent->d_name.name, dentry->d_name.name);
 	nfs_inc_stats(dir, NFSIOS_VFSLOOKUP);
 
+	memset(&fattr, 0, sizeof(struct nfs_fattr));
+
 	res = ERR_PTR(-ENAMETOOLONG);
 	if (dentry->d_name.len > NFS_SERVER(dir)->namelen)
 		goto out;
@@ -915,6 +933,11 @@ static struct dentry *nfs_lookup(struct inode *dir, struct dentry * dentry, stru
 
 	parent = dentry->d_parent;
 	/* Protect against concurrent sillydeletes */
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (nfs_server_capable(dir, NFS_CAP_SECURITY_LABEL))
+		nfs_fattr_alloc(&fattr, GFP_NOWAIT);
+#endif
+
 	nfs_block_sillyrename(parent);
 	error = NFS_PROTO(dir)->lookup(dir, &dentry->d_name, &fhandle, &fattr);
 	if (error == -ENOENT)
@@ -941,6 +964,8 @@ out_unblock_sillyrename:
 out_unlock:
 	unlock_kernel();
 out:
+	/* Label will give 'unused' warning on 'no_entry' case. */
+	nfs_fattr_fini(&fattr);
 	return res;
 }
 
@@ -1209,21 +1234,40 @@ static int nfs_create(struct inode *dir, struct dentry *dentry, int mode,
 	dfprintk(VFS, "NFS: create(%s/%ld), %s\n",
 			dir->i_sb->s_id, dir->i_ino, dentry->d_name.name);
 
+	memset(&attr, 0, sizeof(struct iattr));
 	attr.ia_mode = mode;
 	attr.ia_valid = ATTR_MODE;
 
-	if ((nd->flags & LOOKUP_CREATE) != 0)
+	if ((nd->flags & LOOKUP_CREATE) != 0) {
 		open_flags = nd->intent.open.flags;
 
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+		if (nfs_server_capable(dir, NFS_CAP_SECURITY_LABEL)) {
+			error = security_dentry_init_security(dentry,
+					attr.ia_mode,
+					&attr.ia_label, &attr.ia_label_len);
+			if (error == 0)
+				attr.ia_valid |= ATTR_SECURITY_LABEL;
+		}
+#endif
+	}
 	lock_kernel();
 	error = NFS_PROTO(dir)->create(dir, dentry, &attr, open_flags, nd);
 	if (error != 0)
 		goto out_err;
 	unlock_kernel();
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (attr.ia_label != NULL)
+		security_release_secctx(attr.ia_label, attr.ia_label_len);
+#endif
 	return 0;
 out_err:
 	unlock_kernel();
 	d_drop(dentry);
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (attr.ia_label != NULL)
+		security_release_secctx(attr.ia_label, attr.ia_label_len);
+#endif
 	return error;
 }
 
@@ -1242,11 +1286,26 @@ nfs_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t rdev)
 	if (!new_valid_dev(rdev))
 		return -EINVAL;
 
+	memset(&attr, 0, sizeof(struct iattr));
 	attr.ia_mode = mode;
 	attr.ia_valid = ATTR_MODE;
 
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (nfs_server_capable(dir, NFS_CAP_SECURITY_LABEL)) {
+		status = security_dentry_init_security(dentry,
+				attr.ia_mode,
+				&attr.ia_label, &attr.ia_label_len);
+		if (status == 0)
+			attr.ia_valid |= ATTR_SECURITY_LABEL;
+	}
+#endif
+
 	lock_kernel();
 	status = NFS_PROTO(dir)->mknod(dir, dentry, &attr, rdev);
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (attr.ia_label != NULL)
+		security_release_secctx(attr.ia_label, attr.ia_label_len);
+#endif
 	if (status != 0)
 		goto out_err;
 	unlock_kernel();
@@ -1254,6 +1313,10 @@ nfs_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t rdev)
 out_err:
 	unlock_kernel();
 	d_drop(dentry);
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (attr.ia_label != NULL)
+		security_release_secctx(attr.ia_label, attr.ia_label_len);
+#endif
 	return status;
 }
 
@@ -1268,18 +1331,35 @@ static int nfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 	dfprintk(VFS, "NFS: mkdir(%s/%ld), %s\n",
 			dir->i_sb->s_id, dir->i_ino, dentry->d_name.name);
 
+	memset(&attr, 0, sizeof(struct iattr));
 	attr.ia_valid = ATTR_MODE;
 	attr.ia_mode = mode | S_IFDIR;
 
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (nfs_server_capable(dir, NFS_CAP_SECURITY_LABEL)) {
+		error = security_dentry_init_security(dentry, attr.ia_mode,
+				&attr.ia_label, &attr.ia_label_len);
+		if (error == 0)
+			attr.ia_valid |= ATTR_SECURITY_LABEL;
+	}
+#endif
 	lock_kernel();
 	error = NFS_PROTO(dir)->mkdir(dir, dentry, &attr);
 	if (error != 0)
 		goto out_err;
 	unlock_kernel();
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (attr.ia_label != NULL)
+		security_release_secctx(attr.ia_label, attr.ia_label_len);
+#endif
 	return 0;
 out_err:
 	d_drop(dentry);
 	unlock_kernel();
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (attr.ia_label != NULL)
+		security_release_secctx(attr.ia_label, attr.ia_label_len);
+#endif
 	return error;
 }
 
@@ -1485,9 +1565,20 @@ static int nfs_symlink(struct inode *dir, struct dentry *dentry, const char *sym
 	if (pathlen > PAGE_SIZE)
 		return -ENAMETOOLONG;
 
+	memset(&attr, 0, sizeof(struct iattr));
 	attr.ia_mode = S_IFLNK | S_IRWXUGO;
 	attr.ia_valid = ATTR_MODE;
 
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (nfs_server_capable(dir, NFS_CAP_SECURITY_LABEL)) {
+		error = security_dentry_init_security(dentry,
+				attr.ia_mode,
+				&attr.ia_label, &attr.ia_label_len);
+		if (error == 0)
+			attr.ia_valid |= ATTR_SECURITY_LABEL;
+	}
+#endif
+
 	lock_kernel();
 
 	page = alloc_page(GFP_HIGHUSER);
@@ -1510,6 +1601,10 @@ static int nfs_symlink(struct inode *dir, struct dentry *dentry, const char *sym
 		d_drop(dentry);
 		__free_page(page);
 		unlock_kernel();
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+		if (attr.ia_label != NULL)
+			security_release_secctx(attr.ia_label, attr.ia_label_len);
+#endif
 		return error;
 	}
 
@@ -1528,6 +1623,10 @@ static int nfs_symlink(struct inode *dir, struct dentry *dentry, const char *sym
 		__free_page(page);
 
 	unlock_kernel();
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (attr.ia_label != NULL)
+		security_release_secctx(attr.ia_label, attr.ia_label_len);
+#endif
 	return 0;
 }
 
diff --git a/fs/nfs/getroot.c b/fs/nfs/getroot.c
index fae9719..d0ed440 100644
--- a/fs/nfs/getroot.c
+++ b/fs/nfs/getroot.c
@@ -84,6 +84,8 @@ struct dentry *nfs_get_root(struct super_block *sb, struct nfs_fh *mntfh)
 	struct inode *inode;
 	int error;
 
+	memset(&fattr, 0, sizeof(struct nfs_fattr));
+
 	/* get the actual root for this mount */
 	fsinfo.fattr = &fattr;
 
@@ -119,6 +121,7 @@ struct dentry *nfs_get_root(struct super_block *sb, struct nfs_fh *mntfh)
 	if (!mntroot->d_op)
 		mntroot->d_op = server->nfs_client->rpc_ops->dentry_ops;
 
+	nfs_fattr_fini(&fattr);
 	return mntroot;
 }
 
@@ -143,6 +146,11 @@ int nfs4_path_walk(struct nfs_server *server,
 
 	dprintk("--> nfs4_path_walk(,,%s)\n", path);
 
+	memset(&fattr, 0, sizeof(struct nfs_fattr));
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (server->caps & NFS_CAP_SECURITY_LABEL)
+		nfs_fattr_alloc(&fattr, GFP_KERNEL);
+#endif
 	fsinfo.fattr = &fattr;
 	nfs_fattr_init(&fattr);
 
@@ -154,12 +162,14 @@ int nfs4_path_walk(struct nfs_server *server,
 	ret = server->nfs_client->rpc_ops->getroot(server, mntfh, &fsinfo);
 	if (ret < 0) {
 		dprintk("nfs4_get_root: getroot error = %d\n", -ret);
+		nfs_fattr_fini(&fattr);
 		return ret;
 	}
 
 	if (fattr.type != NFDIR) {
 		printk(KERN_ERR "nfs4_get_root:"
 		       " getroot encountered non-directory\n");
+		nfs_fattr_fini(&fattr);
 		return -ENOTDIR;
 	}
 
@@ -167,6 +177,7 @@ int nfs4_path_walk(struct nfs_server *server,
 	if (fattr.valid & NFS_ATTR_FATTR_V4_REFERRAL) {
 		printk(KERN_ERR "nfs4_get_root:"
 		       " getroot obtained referral\n");
+		nfs_fattr_fini(&fattr);
 		return -EREMOTE;
 	}
 
@@ -199,6 +210,7 @@ eat_dot_dir:
 	    ) {
 		printk(KERN_ERR "nfs4_get_root:"
 		       " Mount path contains reference to \"..\"\n");
+		nfs_fattr_fini(&fattr);
 		return -EINVAL;
 	}
 
@@ -207,16 +219,25 @@ eat_dot_dir:
 
 	dprintk("LookupFH: %*.*s [%s]\n", name.len, name.len, name.name, path);
 
+	nfs_fattr_fini(&fattr);
+	memset(&fattr, 0, sizeof(struct nfs_fattr));
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (server->caps & NFS_CAP_SECURITY_LABEL)
+		nfs_fattr_alloc(&fattr, GFP_KERNEL);
+#endif
+
 	ret = server->nfs_client->rpc_ops->lookupfh(server, &lastfh, &name,
 						    mntfh, &fattr);
 	if (ret < 0) {
 		dprintk("nfs4_get_root: getroot error = %d\n", -ret);
+		nfs_fattr_fini(&fattr);
 		return ret;
 	}
 
 	if (fattr.type != NFDIR) {
 		printk(KERN_ERR "nfs4_get_root:"
 		       " lookupfh encountered non-directory\n");
+		nfs_fattr_fini(&fattr);
 		return -ENOTDIR;
 	}
 
@@ -224,6 +245,7 @@ eat_dot_dir:
 	if (fattr.valid & NFS_ATTR_FATTR_V4_REFERRAL) {
 		printk(KERN_ERR "nfs4_get_root:"
 		       " lookupfh obtained referral\n");
+		nfs_fattr_fini(&fattr);
 		return -EREMOTE;
 	}
 
@@ -231,6 +253,7 @@ eat_dot_dir:
 
 path_walk_complete:
 	memcpy(&server->fsid, &fattr.fsid, sizeof(server->fsid));
+	nfs_fattr_fini(&fattr);
 	dprintk("<-- nfs4_path_walk() = 0\n");
 	return 0;
 }
@@ -256,18 +279,28 @@ struct dentry *nfs4_get_root(struct super_block *sb, struct nfs_fh *mntfh)
 		return ERR_PTR(error);
 	}
 
+	memset(&fattr, 0, sizeof(struct nfs_fattr));
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (server->caps & NFS_CAP_SECURITY_LABEL)
+		nfs_fattr_alloc(&fattr, GFP_KERNEL);
+#endif
+
 	/* get the actual root for this mount */
 	error = server->nfs_client->rpc_ops->getattr(server, mntfh, &fattr);
 	if (error < 0) {
 		dprintk("nfs_get_root: getattr error = %d\n", -error);
+		nfs_fattr_fini(&fattr);
 		return ERR_PTR(error);
 	}
 
 	inode = nfs_fhget(sb, mntfh, &fattr);
 	if (IS_ERR(inode)) {
 		dprintk("nfs_get_root: get root inode failed\n");
+		nfs_fattr_fini(&fattr);
 		return ERR_CAST(inode);
 	}
+	
+	nfs_fattr_fini(&fattr);
 
 	error = nfs_superblock_set_dummy_root(sb, inode);
 	if (error != 0)
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 966a885..229b0e8 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -37,6 +37,7 @@
 #include <linux/vfs.h>
 #include <linux/inet.h>
 #include <linux/nfs_xdr.h>
+#include <linux/xattr.h>
 
 #include <asm/system.h>
 #include <asm/uaccess.h>
@@ -47,6 +48,10 @@
 #include "iostat.h"
 #include "internal.h"
 
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+#include <linux/security.h>
+#endif
+
 #define NFSDBG_FACILITY		NFSDBG_VFS
 
 #define NFS_64_BIT_INODE_NUMBERS_ENABLED	1
@@ -237,6 +242,27 @@ nfs_init_locked(struct inode *inode, void *opaque)
 /* Don't use READDIRPLUS on directories that we believe are too large */
 #define NFS_LIMIT_READDIRPLUS (8*PAGE_SIZE)
 
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+static inline void nfs_setsecurity(struct inode *inode, struct nfs_fattr *fattr)
+{
+	int error;
+
+	if ((fattr->valid & NFS_ATTR_FATTR_V4) &&
+	    (fattr->bitmap[1] & FATTR4_WORD1_SECURITY_LABEL) &&
+	    (fattr->label != NULL) &&
+	    (inode->i_security != NULL)) {
+		const char *key = security_maclabel_getname() +
+					XATTR_SECURITY_PREFIX_LEN;
+		error = security_inode_setsecurity(inode, key, fattr->label,
+						   fattr->label_len, 0);
+		if (error)
+			printk(KERN_ERR
+				"%s() %s %d security_inode_setsecurity() %d\n",
+			       __func__, fattr->label, fattr->label_len,
+			       error);
+	}
+}
+#endif
 /*
  * This is our front-end to iget that looks up inodes by file handle
  * instead of inode number.
@@ -317,6 +343,11 @@ nfs_fhget(struct super_block *sb, struct nfs_fh *fh, struct nfs_fattr *fattr)
 		inode->i_nlink = fattr->nlink;
 		inode->i_uid = fattr->uid;
 		inode->i_gid = fattr->gid;
+
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+		nfs_setsecurity(inode, fattr);
+#endif /* CONFIG_NFS_V4_SECURITY_LABEL  */
+
 		if (fattr->valid & (NFS_ATTR_FATTR_V3 | NFS_ATTR_FATTR_V4)) {
 			/*
 			 * report the blocks in 512byte units
@@ -346,7 +377,7 @@ out_no_inode:
 	goto out;
 }
 
-#define NFS_VALID_ATTRS (ATTR_MODE|ATTR_UID|ATTR_GID|ATTR_SIZE|ATTR_ATIME|ATTR_ATIME_SET|ATTR_MTIME|ATTR_MTIME_SET)
+#define NFS_VALID_ATTRS (ATTR_MODE|ATTR_UID|ATTR_GID|ATTR_SIZE|ATTR_ATIME|ATTR_ATIME_SET|ATTR_MTIME|ATTR_MTIME_SET|ATTR_SECURITY_LABEL)
 
 int
 nfs_setattr(struct dentry *dentry, struct iattr *attr)
@@ -357,6 +388,12 @@ nfs_setattr(struct dentry *dentry, struct iattr *attr)
 
 	nfs_inc_stats(inode, NFSIOS_VFSSETATTR);
 
+	memset(&fattr, 0, sizeof(struct nfs_fattr));
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (nfs_server_capable(inode, NFS_CAP_SECURITY_LABEL))
+		nfs_fattr_alloc(&fattr, GFP_KERNEL);
+#endif
+
 	/* skip mode change if it's just for clearing setuid/setgid */
 	if (attr->ia_valid & (ATTR_KILL_SUID | ATTR_KILL_SGID))
 		attr->ia_valid &= ~ATTR_MODE;
@@ -386,6 +423,7 @@ nfs_setattr(struct dentry *dentry, struct iattr *attr)
 	if (error == 0)
 		nfs_refresh_inode(inode, &fattr);
 	unlock_kernel();
+	nfs_fattr_fini(&fattr);
 	return error;
 }
 
@@ -418,6 +456,11 @@ void nfs_setattr_update_inode(struct inode *inode, struct iattr *attr)
 		inode->i_size = attr->ia_size;
 		vmtruncate(inode, attr->ia_size);
 	}
+
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if ((attr->ia_valid & ATTR_SECURITY_LABEL) != 0)
+		inode_setsecurity(inode, attr);
+#endif
 }
 
 static int nfs_wait_schedule(void *word)
@@ -642,6 +685,9 @@ __nfs_revalidate_inode(struct nfs_server *server, struct inode *inode)
 		inode->i_sb->s_id, (long long)NFS_FILEID(inode));
 
 	nfs_inc_stats(inode, NFSIOS_INODEREVALIDATE);
+
+	memset(&fattr, 0, sizeof(struct nfs_fattr));
+
 	lock_kernel();
 	if (is_bad_inode(inode))
  		goto out_nowait;
@@ -656,6 +702,11 @@ __nfs_revalidate_inode(struct nfs_server *server, struct inode *inode)
 	if (NFS_STALE(inode))
 		goto out;
 
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (nfs_server_capable(inode, NFS_CAP_SECURITY_LABEL))
+		nfs_fattr_alloc(&fattr, GFP_KERNEL);
+#endif
+
 	status = NFS_PROTO(inode)->getattr(server, NFS_FH(inode), &fattr);
 	if (status != 0) {
 		dfprintk(PAGECACHE, "nfs_revalidate_inode: (%s/%Ld) getattr failed, error=%d\n",
@@ -692,6 +743,7 @@ __nfs_revalidate_inode(struct nfs_server *server, struct inode *inode)
 
  out_nowait:
 	unlock_kernel();
+	nfs_fattr_fini(&fattr);
 	return status;
 }
 
@@ -1069,6 +1121,10 @@ static int nfs_update_inode(struct inode *inode, struct nfs_fattr *fattr)
 	inode->i_uid = fattr->uid;
 	inode->i_gid = fattr->gid;
 
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	nfs_setsecurity(inode, fattr);
+#endif /* CONFIG_NFS_V4_SECURITY_LABEL */
+
 	if (fattr->valid & (NFS_ATTR_FATTR_V3 | NFS_ATTR_FATTR_V4)) {
 		/*
 		 * report the blocks in 512byte units
diff --git a/fs/nfs/namespace.c b/fs/nfs/namespace.c
index 607f6eb..b0a9791 100644
--- a/fs/nfs/namespace.c
+++ b/fs/nfs/namespace.c
@@ -105,6 +105,8 @@ static void * nfs_follow_mountpoint(struct dentry *dentry, struct nameidata *nd)
 
 	dprintk("--> nfs_follow_mountpoint()\n");
 
+	memset(&fattr, 0, sizeof(struct nfs_fattr));
+
 	BUG_ON(IS_ROOT(dentry));
 	dprintk("%s: enter\n", __FUNCTION__);
 	dput(nd->path.dentry);
@@ -143,6 +145,7 @@ static void * nfs_follow_mountpoint(struct dentry *dentry, struct nameidata *nd)
 	nd->path.dentry = dget(mnt->mnt_root);
 	schedule_delayed_work(&nfs_automount_task, nfs_mountpoint_expiry_timeout);
 out:
+	nfs_fattr_fini(&fattr);
 	dprintk("%s: done, returned %d\n", __FUNCTION__, err);
 
 	dprintk("<-- nfs_follow_mountpoint() = %d\n", err);
diff --git a/fs/nfs/nfs3proc.c b/fs/nfs/nfs3proc.c
index 549dbce..2204507 100644
--- a/fs/nfs/nfs3proc.c
+++ b/fs/nfs/nfs3proc.c
@@ -380,6 +380,7 @@ nfs3_proc_unlink_done(struct rpc_task *task, struct inode *dir)
 		return 0;
 	res = task->tk_msg.rpc_resp;
 	nfs_post_op_update_inode(dir, &res->dir_attr);
+	nfs_fattr_fini(&res->dir_attr);
 	return 1;
 }
 
@@ -479,6 +480,9 @@ nfs3_proc_symlink(struct inode *dir, struct dentry *dentry, struct page *page,
 
 	dprintk("NFS call  symlink %s\n", dentry->d_name.name);
 
+	memset(&fattr, 0, sizeof(struct nfs_fattr));
+	memset(&dir_attr, 0, sizeof(struct nfs_fattr));
+
 	nfs_fattr_init(&dir_attr);
 	nfs_fattr_init(&fattr);
 	status = rpc_call_sync(NFS_CLIENT(dir), &msg, 0);
@@ -487,6 +491,8 @@ nfs3_proc_symlink(struct inode *dir, struct dentry *dentry, struct page *page,
 		goto out;
 	status = nfs_instantiate(dentry, &fhandle, &fattr);
 out:
+	nfs_fattr_fini(&fattr);
+	nfs_fattr_fini(&dir_attr);
 	dprintk("NFS reply symlink: %d\n", status);
 	return status;
 }
@@ -519,6 +525,8 @@ nfs3_proc_mkdir(struct inode *dir, struct dentry *dentry, struct iattr *sattr)
 
 	sattr->ia_mode &= ~current->fs->umask;
 
+	memset(&fattr, 0, sizeof(struct nfs_fattr));
+	memset(&dir_attr, 0, sizeof(struct nfs_fattr));
 	nfs_fattr_init(&dir_attr);
 	nfs_fattr_init(&fattr);
 	status = rpc_call_sync(NFS_CLIENT(dir), &msg, 0);
@@ -530,6 +538,8 @@ nfs3_proc_mkdir(struct inode *dir, struct dentry *dentry, struct iattr *sattr)
 		goto out;
 	status = nfs3_proc_set_default_acl(dir, dentry->d_inode, mode);
 out:
+	nfs_fattr_fini(&fattr);
+	nfs_fattr_fini(&dir_attr);
 	dprintk("NFS reply mkdir: %d\n", status);
 	return status;
 }
@@ -637,6 +647,9 @@ nfs3_proc_mknod(struct inode *dir, struct dentry *dentry, struct iattr *sattr,
 	mode_t mode = sattr->ia_mode;
 	int status;
 
+	memset(&fattr, 0, sizeof(struct nfs_fattr));
+	memset(&dir_attr, 0, sizeof(struct nfs_fattr));
+
 	switch (sattr->ia_mode & S_IFMT) {
 	case S_IFBLK:	arg.type = NF3BLK;  break;
 	case S_IFCHR:	arg.type = NF3CHR;  break;
@@ -661,6 +674,8 @@ nfs3_proc_mknod(struct inode *dir, struct dentry *dentry, struct iattr *sattr,
 		goto out;
 	status = nfs3_proc_set_default_acl(dir, dentry->d_inode, mode);
 out:
+	nfs_fattr_fini(&fattr);
+	nfs_fattr_fini(&dir_attr);
 	dprintk("NFS reply mknod: %d\n", status);
 	return status;
 }
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 7ce0786..d7193df 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -48,11 +48,18 @@
 #include <linux/smp_lock.h>
 #include <linux/namei.h>
 #include <linux/mount.h>
+#include <linux/xattr.h>
+#include <linux/nfs4_mount.h>
+#include <linux/fsnotify.h>
 
 #include "nfs4_fs.h"
 #include "delegation.h"
 #include "iostat.h"
 
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+#include <linux/security.h>
+#endif
+
 #define NFSDBG_FACILITY		NFSDBG_PROC
 
 #define NFS4_POLL_RETRY_MIN	(HZ/10)
@@ -96,6 +103,9 @@ const u32 nfs4_fattr_bitmap[2] = {
 	| FATTR4_WORD1_TIME_ACCESS
 	| FATTR4_WORD1_TIME_METADATA
 	| FATTR4_WORD1_TIME_MODIFY
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	| FATTR4_WORD1_SECURITY_LABEL
+#endif
 };
 
 const u32 nfs4_statfs_bitmap[2] = {
@@ -240,6 +250,8 @@ static void nfs4_init_opendata_res(struct nfs4_opendata *p)
 	p->o_res.f_attr = &p->f_attr;
 	p->o_res.dir_attr = &p->dir_attr;
 	p->o_res.server = p->o_arg.server;
+	memset(&p->f_attr, 0, sizeof(struct nfs_fattr));
+	memset(&p->dir_attr, 0, sizeof(struct nfs_fattr));
 	nfs_fattr_init(&p->f_attr);
 	nfs_fattr_init(&p->dir_attr);
 }
@@ -272,6 +284,7 @@ static struct nfs4_opendata *nfs4_opendata_alloc(struct path *path,
 	p->o_arg.server = server;
 	p->o_arg.bitmask = server->attr_bitmask;
 	p->o_arg.claim = NFS4_OPEN_CLAIM_NULL;
+	memset(&p->attrs, 0, sizeof(struct iattr));
 	if (flags & O_EXCL) {
 		u32 *s = (u32 *) p->o_arg.u.verifier.data;
 		s[0] = jiffies;
@@ -279,12 +292,22 @@ static struct nfs4_opendata *nfs4_opendata_alloc(struct path *path,
 	} else if (flags & O_CREAT) {
 		p->o_arg.u.attrs = &p->attrs;
 		memcpy(&p->attrs, attrs, sizeof(p->attrs));
+		/* The above creates an additional reference to ia_label.
+		 * The CALLER must free this, not nfs4_opendata_free()
+		 */
 	}
 	p->c_arg.fh = &p->o_res.fh;
 	p->c_arg.stateid = &p->o_res.stateid;
 	p->c_arg.seqid = p->o_arg.seqid;
 	nfs4_init_opendata_res(p);
 	kref_init(&p->kref);
+
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (server->caps & NFS_CAP_SECURITY_LABEL) {
+		nfs_fattr_alloc(&p->f_attr, GFP_KERNEL);
+		nfs_fattr_alloc(&p->dir_attr, GFP_KERNEL);
+	}
+#endif
 	return p;
 err_free:
 	kfree(p);
@@ -301,6 +324,8 @@ static void nfs4_opendata_free(struct kref *kref)
 	nfs_free_seqid(p->o_arg.seqid);
 	if (p->state != NULL)
 		nfs4_put_open_state(p->state);
+	nfs_fattr_fini(&p->f_attr);
+	nfs_fattr_fini(&p->dir_attr);
 	nfs4_put_state_owner(p->owner);
 	dput(p->dir);
 	dput(p->path.dentry);
@@ -1212,6 +1237,7 @@ static void nfs4_free_closedata(void *data)
 	nfs4_put_state_owner(sp);
 	dput(calldata->path.dentry);
 	mntput(calldata->path.mnt);
+	nfs_fattr_fini(&calldata->fattr);
 	kfree(calldata);
 }
 
@@ -1319,7 +1345,7 @@ int nfs4_do_close(struct path *path, struct nfs4_state *state, int wait)
 	};
 	int status = -ENOMEM;
 
-	calldata = kmalloc(sizeof(*calldata), GFP_KERNEL);
+	calldata = kzalloc(sizeof(*calldata), GFP_KERNEL);
 	if (calldata == NULL)
 		goto out;
 	calldata->inode = state->inode;
@@ -1336,6 +1362,11 @@ int nfs4_do_close(struct path *path, struct nfs4_state *state, int wait)
 	calldata->path.mnt = mntget(path->mnt);
 	calldata->path.dentry = dget(path->dentry);
 
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (server->caps & NFS_CAP_SECURITY_LABEL)
+		nfs_fattr_alloc(&calldata->fattr, GFP_KERNEL);
+#endif
+
 	msg.rpc_argp = &calldata->arg,
 	msg.rpc_resp = &calldata->res,
 	task_setup_data.callback_data = calldata;
@@ -1348,6 +1379,7 @@ int nfs4_do_close(struct path *path, struct nfs4_state *state, int wait)
 	rpc_put_task(task);
 	return status;
 out_free_calldata:
+	nfs_fattr_fini(&calldata->fattr);
 	kfree(calldata);
 out:
 	nfs4_put_open_state(state);
@@ -1394,24 +1426,40 @@ nfs4_atomic_open(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
 	struct nfs4_state *state;
 	struct dentry *res;
 
+	cred = rpcauth_lookupcred(NFS_CLIENT(dir)->cl_auth, 0);
+	if (IS_ERR(cred))
+		return (struct dentry *)cred;
+
+	memset(&attr, 0, sizeof(struct iattr));
 	if (nd->flags & LOOKUP_CREATE) {
 		attr.ia_mode = nd->intent.open.create_mode;
 		attr.ia_valid = ATTR_MODE;
 		if (!IS_POSIXACL(dir))
 			attr.ia_mode &= ~current->fs->umask;
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+		if (nfs_server_capable(dir, NFS_CAP_SECURITY_LABEL)) {
+			int error;
+			error = security_dentry_init_security(dentry,
+					attr.ia_mode,
+					&attr.ia_label, &attr.ia_label_len);
+			if (error == 0)
+				attr.ia_valid |= ATTR_SECURITY_LABEL;
+		}
+#endif
 	} else {
 		attr.ia_valid = 0;
 		BUG_ON(nd->intent.open.flags & O_CREAT);
 	}
 
-	cred = rpcauth_lookupcred(NFS_CLIENT(dir)->cl_auth, 0);
-	if (IS_ERR(cred))
-		return (struct dentry *)cred;
 	parent = dentry->d_parent;
 	/* Protect against concurrent sillydeletes */
 	nfs_block_sillyrename(parent);
 	state = nfs4_do_open(dir, &path, nd->intent.open.flags, &attr, cred);
 	put_rpccred(cred);
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (attr.ia_label != NULL)
+		security_release_secctx(attr.ia_label, attr.ia_label_len);
+#endif
 	if (IS_ERR(state)) {
 		if (PTR_ERR(state) == -ENOENT) {
 			d_add(dentry, NULL);
@@ -1484,6 +1532,13 @@ static int _nfs4_server_capabilities(struct nfs_server *server, struct nfs_fh *f
 		memcpy(server->attr_bitmask, res.attr_bitmask, sizeof(server->attr_bitmask));
 		if (res.attr_bitmask[0] & FATTR4_WORD0_ACL)
 			server->caps |= NFS_CAP_ACLS;
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+		if (server->flags & NFS4_MOUNT_SECURITY_LABEL &&
+			res.attr_bitmask[1] & FATTR4_WORD1_SECURITY_LABEL) {
+			server->caps |= NFS_CAP_SECURITY_LABEL;
+		} else
+#endif
+		server->attr_bitmask[1] &= ~FATTR4_WORD1_SECURITY_LABEL;
 		if (res.has_links != 0)
 			server->caps |= NFS_CAP_HARDLINKS;
 		if (res.has_symlinks != 0)
@@ -1767,6 +1822,8 @@ static int _nfs4_proc_access(struct inode *inode, struct nfs_access_entry *entry
 	int mode = entry->mask;
 	int status;
 
+	memset(&fattr, 0, sizeof(struct nfs_fattr));
+
 	/*
 	 * Determine which access bits we want to ask for...
 	 */
@@ -1783,6 +1840,10 @@ static int _nfs4_proc_access(struct inode *inode, struct nfs_access_entry *entry
 		if (mode & MAY_EXEC)
 			args.access |= NFS4_ACCESS_EXECUTE;
 	}
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (server->caps & NFS_CAP_SECURITY_LABEL)
+		nfs_fattr_alloc(&fattr, GFP_KERNEL);
+#endif
 	nfs_fattr_init(&fattr);
 	status = rpc_call_sync(NFS_CLIENT(inode), &msg, 0);
 	if (!status) {
@@ -1795,6 +1856,7 @@ static int _nfs4_proc_access(struct inode *inode, struct nfs_access_entry *entry
 			entry->mask |= MAY_EXEC;
 		nfs_refresh_inode(inode, &fattr);
 	}
+	nfs_fattr_fini(&fattr);
 	return status;
 }
 
@@ -1908,10 +1970,17 @@ nfs4_proc_create(struct inode *dir, struct dentry *dentry, struct iattr *sattr,
 	nfs_set_verifier(dentry, nfs_save_change_attribute(dir));
 	if (flags & O_EXCL) {
 		struct nfs_fattr fattr;
+		memset(&fattr, 0, sizeof(struct nfs_fattr));
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+		if (nfs_server_capable(state->inode, NFS_CAP_SECURITY_LABEL))
+			nfs_fattr_alloc(&fattr, GFP_KERNEL);
+#endif
 		status = nfs4_do_setattr(state->inode, &fattr, sattr, state);
 		if (status == 0)
 			nfs_setattr_update_inode(state->inode, sattr);
 		nfs_post_op_update_inode(state->inode, &fattr);
+
+		nfs_fattr_fini(&fattr);
 	}
 	if (status == 0 && (nd->flags & LOOKUP_OPEN) != 0)
 		status = nfs4_intent_set_file(nd, &path, state);
@@ -1940,12 +2009,18 @@ static int _nfs4_proc_remove(struct inode *dir, struct qstr *name)
 	};
 	int			status;
 
+	memset(&res.dir_attr, 0, sizeof(struct nfs_fattr));
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (server->caps & NFS_CAP_SECURITY_LABEL)
+		nfs_fattr_alloc(&res.dir_attr, GFP_KERNEL);
+#endif
 	nfs_fattr_init(&res.dir_attr);
 	status = rpc_call_sync(server->client, &msg, 0);
 	if (status == 0) {
 		update_changeattr(dir, &res.cinfo);
 		nfs_post_op_update_inode(dir, &res.dir_attr);
 	}
+	nfs_fattr_fini(&res.dir_attr);
 	return status;
 }
 
@@ -1970,6 +2045,13 @@ static void nfs4_proc_unlink_setup(struct rpc_message *msg, struct inode *dir)
 	args->bitmask = server->attr_bitmask;
 	res->server = server;
 	msg->rpc_proc = &nfs4_procedures[NFSPROC4_CLNT_REMOVE];
+
+	memset(&res->dir_attr, 0, sizeof(struct nfs_fattr));
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (server->caps & NFS_CAP_SECURITY_LABEL)
+		nfs_fattr_alloc(&res->dir_attr, GFP_KERNEL);
+#endif
+	nfs_fattr_init(&res->dir_attr);
 }
 
 static int nfs4_proc_unlink_done(struct rpc_task *task, struct inode *dir)
@@ -1980,6 +2062,7 @@ static int nfs4_proc_unlink_done(struct rpc_task *task, struct inode *dir)
 		return 0;
 	update_changeattr(dir, &res->cinfo);
 	nfs_post_op_update_inode(dir, &res->dir_attr);
+	nfs_fattr_fini(&res->dir_attr);
 	return 1;
 }
 
@@ -2007,6 +2090,15 @@ static int _nfs4_proc_rename(struct inode *old_dir, struct qstr *old_name,
 	};
 	int			status;
 	
+
+	memset(&old_fattr, 0, sizeof(struct nfs_fattr));
+	memset(&new_fattr, 0, sizeof(struct nfs_fattr));
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (server->caps & NFS_CAP_SECURITY_LABEL) {
+		nfs_fattr_alloc(&old_fattr, GFP_KERNEL);
+		nfs_fattr_alloc(&new_fattr, GFP_KERNEL);
+	}
+#endif
 	nfs_fattr_init(res.old_fattr);
 	nfs_fattr_init(res.new_fattr);
 	status = rpc_call_sync(server->client, &msg, 0);
@@ -2017,6 +2109,8 @@ static int _nfs4_proc_rename(struct inode *old_dir, struct qstr *old_name,
 		update_changeattr(new_dir, &res.new_cinfo);
 		nfs_post_op_update_inode(new_dir, res.new_fattr);
 	}
+	nfs_fattr_fini(&old_fattr);
+	nfs_fattr_fini(&new_fattr);
 	return status;
 }
 
@@ -2056,6 +2150,16 @@ static int _nfs4_proc_link(struct inode *inode, struct inode *dir, struct qstr *
 	};
 	int			status;
 
+	memset(&fattr, 0, sizeof(struct nfs_fattr));
+	memset(&dir_attr, 0, sizeof(struct nfs_fattr));
+
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (server->caps & NFS_CAP_SECURITY_LABEL) {
+		nfs_fattr_alloc(&fattr, GFP_KERNEL);
+		nfs_fattr_alloc(&dir_attr, GFP_KERNEL);
+	}
+#endif
+
 	nfs_fattr_init(res.fattr);
 	nfs_fattr_init(res.dir_attr);
 	status = rpc_call_sync(server->client, &msg, 0);
@@ -2065,6 +2169,8 @@ static int _nfs4_proc_link(struct inode *inode, struct inode *dir, struct qstr *
 		nfs_post_op_update_inode(inode, res.fattr);
 	}
 
+	nfs_fattr_fini(&fattr);
+	nfs_fattr_fini(&dir_attr);
 	return status;
 }
 
@@ -2110,6 +2216,16 @@ static int _nfs4_proc_symlink(struct inode *dir, struct dentry *dentry,
 	if (len > NFS4_MAXPATHLEN)
 		return -ENAMETOOLONG;
 
+	memset(&fattr, 0, sizeof(struct nfs_fattr));
+	memset(&dir_fattr, 0, sizeof(struct nfs_fattr));
+
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (server->caps & NFS_CAP_SECURITY_LABEL) {
+		nfs_fattr_alloc(&fattr, GFP_KERNEL);
+		nfs_fattr_alloc(&dir_fattr, GFP_KERNEL);
+	}
+#endif
+
 	arg.u.symlink.pages = &page;
 	arg.u.symlink.len = len;
 	nfs_fattr_init(&fattr);
@@ -2121,6 +2237,8 @@ static int _nfs4_proc_symlink(struct inode *dir, struct dentry *dentry,
 		nfs_post_op_update_inode(dir, res.dir_fattr);
 		status = nfs_instantiate(dentry, &fhandle, &fattr);
 	}
+	nfs_fattr_fini(&fattr);
+	nfs_fattr_fini(&dir_fattr);
 	return status;
 }
 
@@ -2165,6 +2283,16 @@ static int _nfs4_proc_mkdir(struct inode *dir, struct dentry *dentry,
 	};
 	int			status;
 
+	memset(&fattr, 0, sizeof(struct nfs_fattr));
+	memset(&dir_fattr, 0, sizeof(struct nfs_fattr));
+
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (server->caps & NFS_CAP_SECURITY_LABEL) {
+		nfs_fattr_alloc(&fattr, GFP_KERNEL);
+		nfs_fattr_alloc(&dir_fattr, GFP_KERNEL);
+	}
+#endif
+
 	nfs_fattr_init(&fattr);
 	nfs_fattr_init(&dir_fattr);
 	
@@ -2174,6 +2302,8 @@ static int _nfs4_proc_mkdir(struct inode *dir, struct dentry *dentry,
 		nfs_post_op_update_inode(dir, res.dir_fattr);
 		status = nfs_instantiate(dentry, &fhandle, &fattr);
 	}
+	nfs_fattr_fini(&fattr);
+	nfs_fattr_fini(&dir_fattr);
 	return status;
 }
 
@@ -2267,6 +2397,15 @@ static int _nfs4_proc_mknod(struct inode *dir, struct dentry *dentry,
 	int			status;
 	int                     mode = sattr->ia_mode;
 
+	memset(&fattr, 0, sizeof(struct nfs_fattr));
+	memset(&dir_fattr, 0, sizeof(struct nfs_fattr));
+
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (server->caps & NFS_CAP_SECURITY_LABEL) {
+		nfs_fattr_alloc(&fattr, GFP_KERNEL);
+		nfs_fattr_alloc(&dir_fattr, GFP_KERNEL);
+	}
+#endif
 	nfs_fattr_init(&fattr);
 	nfs_fattr_init(&dir_fattr);
 
@@ -2293,6 +2432,8 @@ static int _nfs4_proc_mknod(struct inode *dir, struct dentry *dentry,
 		nfs_post_op_update_inode(dir, res.dir_fattr);
 		status = nfs_instantiate(dentry, &fh, &fattr);
 	}
+	nfs_fattr_fini(&fattr);
+	nfs_fattr_fini(&dir_fattr);
 	return status;
 }
 
@@ -2750,6 +2891,162 @@ static int nfs4_proc_set_acl(struct inode *inode, const void *buf, size_t buflen
 	return err;
 }
 
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+static int _nfs4_get_security_label(struct inode *inode, void *buf, size_t buflen)
+{
+	struct nfs_server *server = NFS_SERVER(inode);
+	struct nfs_fattr fattr;
+	u32 bitmask[2] = { 0, FATTR4_WORD1_SECURITY_LABEL };
+	struct nfs4_getattr_arg args = {
+		.fh		= NFS_FH(inode),
+		.bitmask	= bitmask,
+	};
+	struct nfs4_getattr_res res = {
+		.fattr		= &fattr,
+		.server		= server,
+	};
+	struct rpc_message msg = {
+		.rpc_proc	= &nfs4_procedures[NFSPROC4_CLNT_GETATTR],
+		.rpc_argp	= &args,
+		.rpc_resp	= &res,
+	};
+	int ret;
+
+	memset(&fattr, 0, sizeof(struct nfs_fattr));
+	nfs_fattr_alloc(&fattr, GFP_KERNEL);
+	nfs_fattr_init(&fattr);
+
+	ret = rpc_call_sync(server->client, &msg, 0);
+	if (ret)
+		goto out;
+	if (!(fattr.bitmap[1] & FATTR4_WORD1_SECURITY_LABEL))
+		return -ENOENT;
+	if (buflen < fattr.label_len) {
+		ret = -ERANGE;
+		goto out;
+	}
+	memcpy(buf, fattr.label, fattr.label_len);
+out:
+	nfs_fattr_fini(&fattr);
+	return ret;
+}
+
+static int nfs4_get_security_label(struct inode *inode, void *buf, size_t buflen)
+{
+	struct nfs4_exception exception = { };
+	int err;
+
+	if (!nfs_server_capable(inode, NFS_CAP_SECURITY_LABEL))
+		return -EOPNOTSUPP;
+
+	do {
+		err = nfs4_handle_exception(NFS_SERVER(inode),
+				_nfs4_get_security_label(inode, buf, buflen),
+				&exception);
+	} while (exception.retry);
+	return err;
+}
+
+static int _nfs4_do_set_security_label(struct inode *inode,
+				      struct iattr *sattr,
+				      struct nfs_fattr *fattr,
+				      struct nfs4_state *state)
+{
+	struct nfs_server *server = NFS_SERVER(inode);
+	const u32 bitmask[2] = { 0, FATTR4_WORD1_SECURITY_LABEL };
+	struct nfs_setattrargs args = {
+		.fh             = NFS_FH(inode),
+		.iap            = sattr,
+		.server		= server,
+		.bitmask	= bitmask,
+	};
+	struct nfs_setattrres res = {
+		.fattr		= fattr,
+		.server		= server,
+	};
+	struct rpc_message msg = {
+		.rpc_proc       = &nfs4_procedures[NFSPROC4_CLNT_SETATTR],
+		.rpc_argp       = &args,
+		.rpc_resp       = &res,
+	};
+	unsigned long timestamp = jiffies;
+	int status;
+
+	if (nfs4_copy_delegation_stateid(&args.stateid, inode)) {
+		/* Use that stateid */
+	} else if (state != NULL) {
+		msg.rpc_cred = state->owner->so_cred;
+		nfs4_copy_stateid(&args.stateid, state, current->files);
+	} else
+		memcpy(&args.stateid, &zero_stateid, sizeof(args.stateid));
+
+	status = rpc_call_sync(server->client, &msg, 0);
+	if (status == 0 && state != NULL)
+		renew_lease(server, timestamp);
+	return status;
+}
+
+static int nfs4_do_set_security_label(struct inode *inode,
+				     struct iattr *sattr,
+				     struct nfs_fattr *fattr,
+				     struct nfs4_state *state)
+{
+	struct nfs4_exception exception = { };
+	int err;
+
+	do {
+		err = nfs4_handle_exception(NFS_SERVER(inode),
+			_nfs4_do_set_security_label(inode, sattr, fattr, state),
+			&exception);
+	} while (exception.retry);
+	return err;
+}
+
+static int
+nfs4_set_security_label(struct dentry *dentry, const void *buf, size_t buflen)
+{
+	struct nfs_fattr fattr;
+	struct iattr sattr;
+	struct rpc_cred *cred;
+	struct nfs_open_context *ctx;
+	struct nfs4_state *state = NULL;
+	struct inode *inode = dentry->d_inode;
+	int status;
+
+	if (!nfs_server_capable(inode, NFS_CAP_SECURITY_LABEL))
+		return -EOPNOTSUPP;
+
+	memset(&fattr, 0, sizeof(struct nfs_fattr));
+	nfs_fattr_alloc(&fattr, GFP_KERNEL);
+	nfs_fattr_init(&fattr);
+
+	memset(&sattr, 0, sizeof(struct iattr));
+	sattr.ia_valid = ATTR_SECURITY_LABEL;
+	sattr.ia_label = (char *)buf;
+	sattr.ia_label_len = buflen;
+
+	cred = rpcauth_lookupcred(NFS_CLIENT(inode)->cl_auth, 0);
+	if (IS_ERR(cred))
+		return PTR_ERR(cred);
+
+	/* Search for an existing open(O_WRITE) file */
+	ctx = nfs_find_open_context(inode, cred, FMODE_WRITE);
+	if (ctx != NULL)
+		state = ctx->state;
+
+	status = nfs4_do_set_security_label(inode, &sattr, &fattr, state);
+	if (status == 0) {
+		nfs_setattr_update_inode(inode, &sattr);
+		fsnotify_change(dentry, sattr.ia_valid);
+	}
+	if (ctx != NULL)
+		put_nfs_open_context(ctx);
+	put_rpccred(cred);
+	nfs_fattr_fini(&fattr);
+	return status;
+}
+#endif	/* CONFIG_NFS_V4_SECURITY_LABEL */
+
 static int
 nfs4_async_handle_error(struct rpc_task *task, const struct nfs_server *server)
 {
@@ -2970,6 +3267,9 @@ static void nfs4_delegreturn_done(struct rpc_task *task, void *calldata)
 
 static void nfs4_delegreturn_release(void *calldata)
 {
+	struct nfs4_delegreturndata *data = calldata;
+
+	nfs_fattr_fini(data->res.fattr);
 	kfree(calldata);
 }
 
@@ -3005,6 +3305,11 @@ static int _nfs4_proc_delegreturn(struct inode *inode, struct rpc_cred *cred, co
 	memcpy(&data->stateid, stateid, sizeof(data->stateid));
 	data->res.fattr = &data->fattr;
 	data->res.server = server;
+	memset(data->res.fattr, 0, sizeof(struct nfs_fattr));
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (data->res.server->caps & NFS_CAP_SECURITY_LABEL)
+		nfs_fattr_alloc(data->res.fattr, GFP_KERNEL);
+#endif
 	nfs_fattr_init(data->res.fattr);
 	data->timestamp = jiffies;
 	data->rpc_status = 0;
@@ -3605,10 +3910,13 @@ int nfs4_setxattr(struct dentry *dentry, const char *key, const void *buf,
 {
 	struct inode *inode = dentry->d_inode;
 
-	if (strcmp(key, XATTR_NAME_NFSV4_ACL) != 0)
-		return -EOPNOTSUPP;
-
-	return nfs4_proc_set_acl(inode, buf, buflen);
+	if (strcmp(key, XATTR_NAME_NFSV4_ACL) == 0)
+		return nfs4_proc_set_acl(inode, buf, buflen);
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (strcmp(key, security_maclabel_getname()) == 0)
+		return nfs4_set_security_label(dentry, buf, buflen);
+#endif
+	return -EOPNOTSUPP;
 }
 
 /* The getxattr man page suggests returning -ENODATA for unknown attributes,
@@ -3620,22 +3928,49 @@ ssize_t nfs4_getxattr(struct dentry *dentry, const char *key, void *buf,
 {
 	struct inode *inode = dentry->d_inode;
 
-	if (strcmp(key, XATTR_NAME_NFSV4_ACL) != 0)
-		return -EOPNOTSUPP;
-
-	return nfs4_proc_get_acl(inode, buf, buflen);
+	if (strcmp(key, XATTR_NAME_NFSV4_ACL) == 0)
+		return nfs4_proc_get_acl(inode, buf, buflen);
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (strcmp(key, security_maclabel_getname()) == 0)
+		return nfs4_get_security_label(inode, buf, buflen);
+#endif
+	return -EOPNOTSUPP;
 }
 
 ssize_t nfs4_listxattr(struct dentry *dentry, char *buf, size_t buflen)
 {
-	size_t len = strlen(XATTR_NAME_NFSV4_ACL) + 1;
-
-	if (!nfs4_server_supports_acls(NFS_SERVER(dentry->d_inode)))
+	size_t len = 0, l;
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	const char *key = security_maclabel_getname();
+#endif
+	char *p;
+
+	if (nfs4_server_supports_acls(NFS_SERVER(dentry->d_inode)))
+		len += strlen(XATTR_NAME_NFSV4_ACL) + 1;
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (nfs_server_capable(dentry->d_inode, NFS_CAP_SECURITY_LABEL))
+		len += strlen(key) + 1;
+#endif
+	if (!len)
 		return 0;
 	if (buf && buflen < len)
 		return -ERANGE;
-	if (buf)
-		memcpy(buf, XATTR_NAME_NFSV4_ACL, len);
+	if (!buf)
+		return len;
+
+	p = buf;
+	if (nfs4_server_supports_acls(NFS_SERVER(dentry->d_inode))) {
+		l = strlen(XATTR_NAME_NFSV4_ACL) + 1;
+		memcpy(p, XATTR_NAME_NFSV4_ACL, l);
+		p += l;
+	}
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (nfs_server_capable(dentry->d_inode, NFS_CAP_SECURITY_LABEL)) {
+		l = strlen(key) + 1;
+		memcpy(p, key, l);
+		p += l;
+	}
+#endif
 	return len;
 }
 
diff --git a/fs/nfs/nfs4xdr.c b/fs/nfs/nfs4xdr.c
index db1ed9c..ed7ec8b 100644
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -651,6 +651,10 @@ static int encode_attrs(struct xdr_stream *xdr, const struct iattr *iap, const s
 		}
 		len += 4 + (XDR_QUADLEN(owner_grouplen) << 2);
 	}
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (iap->ia_valid & ATTR_SECURITY_LABEL)
+		len += 4 + (XDR_QUADLEN(iap->ia_label_len) << 2);
+#endif
 	if (iap->ia_valid & ATTR_ATIME_SET)
 		len += 16;
 	else if (iap->ia_valid & ATTR_ATIME)
@@ -709,6 +713,13 @@ static int encode_attrs(struct xdr_stream *xdr, const struct iattr *iap, const s
 		bmval1 |= FATTR4_WORD1_TIME_MODIFY_SET;
 		WRITE32(NFS4_SET_TO_SERVER_TIME);
 	}
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (iap->ia_valid & ATTR_SECURITY_LABEL) {
+		bmval1 |= FATTR4_WORD1_SECURITY_LABEL;
+		WRITE32(iap->ia_label_len);
+		WRITEMEM(iap->ia_label, iap->ia_label_len);
+	}
+#endif /* CONFIG_NFS_V4_SECURITY_LABEL */
 	
 	/*
 	 * Now we backfill the bitmap and the attribute buffer length.
@@ -2954,6 +2965,40 @@ static int decode_attr_time_modify(struct xdr_stream *xdr, uint32_t *bitmap, str
 	return status;
 }
 
+static int decode_attr_security_label(struct xdr_stream *xdr, uint32_t *bitmap, char **ctx, u32 *ctxlen)
+{
+	uint32_t len;
+	__be32 *p;
+	int rc = 0;
+
+	if (unlikely(bitmap[1] & (FATTR4_WORD1_SECURITY_LABEL - 1U)))
+		return -EIO;
+	if (likely(bitmap[1] & FATTR4_WORD1_SECURITY_LABEL)) {
+		READ_BUF(4);
+		READ32(len);
+		READ_BUF(len);
+		if (len < XDR_MAX_NETOBJ) {
+			if (*ctx != NULL) {
+				if (*ctxlen < len) {
+					printk(KERN_ERR
+					    "%s(): ctxlen (%d) < len (%d)\n",
+						__func__, *ctxlen, len);
+					/* rc = -ENOMEM; */
+					*ctx = NULL;	/* leak */
+				} else {
+					memcpy(*ctx, (char *)p, len);
+					(*ctx)[len + 1] = '\0';
+				}
+			}
+			*ctxlen = len;
+		} else
+			printk(KERN_WARNING "%s: label too long (%u)!\n",
+					__FUNCTION__, len);
+		bitmap[1] &= ~FATTR4_WORD1_SECURITY_LABEL;
+	}
+	return rc;
+}
+
 static int verify_attr_len(struct xdr_stream *xdr, __be32 *savep, uint32_t attrlen)
 {
 	unsigned int attrwords = XDR_QUADLEN(attrlen);
@@ -3186,6 +3231,10 @@ static int decode_getfattr(struct xdr_stream *xdr, struct nfs_fattr *fattr, cons
 		goto xdr_error;
 	if ((status = decode_attr_mounted_on_fileid(xdr, bitmap, &fileid)) != 0)
 		goto xdr_error;
+	if ((status = decode_attr_security_label(xdr, bitmap,
+						 &fattr->label,
+						 &fattr->label_len)) != 0)
+		goto xdr_error;
 	if (fattr->fileid == 0 && fileid != 0)
 		fattr->fileid = fileid;
 	if ((status = verify_attr_len(xdr, savep, attrlen)) == 0)
diff --git a/fs/nfs/proc.c b/fs/nfs/proc.c
index 5ccf7fa..d7435f6 100644
--- a/fs/nfs/proc.c
+++ b/fs/nfs/proc.c
@@ -208,12 +208,15 @@ nfs_proc_create(struct inode *dir, struct dentry *dentry, struct iattr *sattr,
 	};
 	int			status;
 
-	nfs_fattr_init(&fattr);
 	dprintk("NFS call  create %s\n", dentry->d_name.name);
+
+	memset(&fattr, 0, sizeof(struct nfs_fattr));
+	nfs_fattr_init(&fattr);
 	status = rpc_call_sync(NFS_CLIENT(dir), &msg, 0);
 	nfs_mark_for_revalidate(dir);
 	if (status == 0)
 		status = nfs_instantiate(dentry, &fhandle, &fattr);
+	nfs_fattr_fini(&fattr);
 	dprintk("NFS reply create: %d\n", status);
 	return status;
 }
@@ -255,6 +258,7 @@ nfs_proc_mknod(struct inode *dir, struct dentry *dentry, struct iattr *sattr,
 		sattr->ia_size = new_encode_dev(rdev);/* get out your barf bag */
 	}
 
+	memset(&fattr, 0, sizeof(struct nfs_fattr));
 	nfs_fattr_init(&fattr);
 	status = rpc_call_sync(NFS_CLIENT(dir), &msg, 0);
 	nfs_mark_for_revalidate(dir);
@@ -266,6 +270,7 @@ nfs_proc_mknod(struct inode *dir, struct dentry *dentry, struct iattr *sattr,
 	}
 	if (status == 0)
 		status = nfs_instantiate(dentry, &fhandle, &fattr);
+	nfs_fattr_fini(&fattr);
 	dprintk("NFS reply mknod: %d\n", status);
 	return status;
 }
@@ -378,6 +383,8 @@ nfs_proc_symlink(struct inode *dir, struct dentry *dentry, struct page *page,
 
 	dprintk("NFS call  symlink %s\n", dentry->d_name.name);
 
+	memset(&fattr, 0, sizeof(struct nfs_fattr));
+
 	status = rpc_call_sync(NFS_CLIENT(dir), &msg, 0);
 	nfs_mark_for_revalidate(dir);
 
@@ -392,6 +399,7 @@ nfs_proc_symlink(struct inode *dir, struct dentry *dentry, struct page *page,
 		status = nfs_instantiate(dentry, &fhandle, &fattr);
 	}
 
+	nfs_fattr_fini(&fattr);
 	dprintk("NFS reply symlink: %d\n", status);
 	return status;
 }
@@ -419,11 +427,14 @@ nfs_proc_mkdir(struct inode *dir, struct dentry *dentry, struct iattr *sattr)
 	int			status;
 
 	dprintk("NFS call  mkdir %s\n", dentry->d_name.name);
+
+	memset(&fattr, 0, sizeof(struct nfs_fattr));
 	nfs_fattr_init(&fattr);
 	status = rpc_call_sync(NFS_CLIENT(dir), &msg, 0);
 	nfs_mark_for_revalidate(dir);
 	if (status == 0)
 		status = nfs_instantiate(dentry, &fhandle, &fattr);
+	nfs_fattr_fini(&fattr);
 	dprintk("NFS reply mkdir: %d\n", status);
 	return status;
 }
diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index 1fb3818..815ca3c 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -75,6 +75,7 @@ enum {
 	Opt_acl, Opt_noacl,
 	Opt_rdirplus, Opt_nordirplus,
 	Opt_sharecache, Opt_nosharecache,
+	Opt_seclabel, Opt_noseclabel,
 
 	/* Mount options that take integer arguments */
 	Opt_port,
@@ -124,6 +125,8 @@ static match_table_t nfs_mount_option_tokens = {
 	{ Opt_nordirplus, "nordirplus" },
 	{ Opt_sharecache, "sharecache" },
 	{ Opt_nosharecache, "nosharecache" },
+	{ Opt_seclabel, "security_label" },
+	{ Opt_noseclabel, "nosecurity_label" },
 
 	{ Opt_port, "port=%u" },
 	{ Opt_rsize, "rsize=%u" },
@@ -368,6 +371,8 @@ static int nfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	};
 	int error;
 
+	memset(&fattr, 0, sizeof(struct nfs_fattr));
+
 	lock_kernel();
 
 	error = server->nfs_client->rpc_ops->statfs(server, fh, &res);
@@ -402,11 +407,13 @@ static int nfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	buf->f_namelen = server->namelen;
 
 	unlock_kernel();
+	nfs_fattr_fini(&fattr);
 	return 0;
 
  out_err:
 	dprintk("%s: statfs error = %d\n", __FUNCTION__, -error);
 	unlock_kernel();
+	nfs_fattr_fini(&fattr);
 	return error;
 }
 
@@ -485,6 +492,13 @@ static void nfs_show_mount_options(struct seq_file *m, struct nfs_server *nfss,
 	seq_printf(m, ",timeo=%lu", 10U * nfss->client->cl_timeout->to_initval / HZ);
 	seq_printf(m, ",retrans=%u", nfss->client->cl_timeout->to_retries);
 	seq_printf(m, ",sec=%s", nfs_pseudoflavour_to_name(nfss->client->cl_auth->au_flavor));
+
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if ((nfss->nfs_client->rpc_ops->version == 4) &&
+	    (nfss->attr_bitmask[1] & FATTR4_WORD1_SECURITY_LABEL))
+		seq_printf(m, ",security_label");
+#endif /* CONFIG_NFS_V4_SECURITY_LABEL */
+
 }
 
 /*
@@ -540,6 +554,10 @@ static int nfs_show_stats(struct seq_file *m, struct vfsmount *mnt)
 		seq_printf(m, "bm0=0x%x", nfss->attr_bitmask[0]);
 		seq_printf(m, ",bm1=0x%x", nfss->attr_bitmask[1]);
 		seq_printf(m, ",acl=0x%x", nfss->acl_bitmask);
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+		if (nfss->attr_bitmask[1] & FATTR4_WORD1_SECURITY_LABEL)
+			seq_printf(m, ",security_label");
+#endif /* CONFIG_NFS_V4_SECURITY_LABEL */
 	}
 #endif
 
@@ -779,7 +797,12 @@ static int nfs_parse_mount_options(char *raw,
 		case Opt_nosharecache:
 			mnt->flags |= NFS_MOUNT_UNSHARED;
 			break;
-
+		case Opt_seclabel:
+			mnt->flags |= NFS_MOUNT_SECURITY_LABEL;
+			break;
+		case Opt_noseclabel:
+			mnt->flags &= ~NFS_MOUNT_SECURITY_LABEL;
+			break;
 		case Opt_port:
 			if (match_int(args, &option))
 				return 0;
diff --git a/fs/nfsd/export.c b/fs/nfsd/export.c
index 8a6f7c9..d32ae56 100644
--- a/fs/nfsd/export.c
+++ b/fs/nfsd/export.c
@@ -1435,6 +1435,9 @@ static struct flags {
 	{ NFSEXP_ALLSQUASH, {"all_squash", ""}},
 	{ NFSEXP_ASYNC, {"async", "sync"}},
 	{ NFSEXP_GATHERED_WRITES, {"wdelay", "no_wdelay"}},
+#ifdef CONFIG_NFSD_V4_SECURITY_LABEL
+	{ NFSEXP_SECURITY_LABEL, {"security_label", ""}},
+#endif
 	{ NFSEXP_NOHIDE, {"nohide", ""}},
 	{ NFSEXP_CROSSMOUNT, {"crossmnt", ""}},
 	{ NFSEXP_NOSUBTREECHECK, {"no_subtree_check", ""}},
diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 0e6a179..5de2a91 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -50,6 +50,7 @@
 #include <linux/sunrpc/xdr.h>
 #include <linux/sunrpc/svc.h>
 #include <linux/sunrpc/clnt.h>
+#include <linux/nfs_fs.h>
 #include <linux/nfsd/nfsd.h>
 #include <linux/nfsd/state.h>
 #include <linux/nfsd/xdr4.h>
@@ -58,6 +59,8 @@
 #include <linux/nfs4_acl.h>
 #include <linux/sunrpc/gss_api.h>
 #include <linux/sunrpc/svcauth_gss.h>
+#include <linux/security.h>
+#include <linux/xattr.h>
 
 #define NFSDDBG_FACILITY		NFSDDBG_XDR
 
@@ -416,6 +419,22 @@ nfsd4_decode_fattr(struct nfsd4_compoundargs *argp, u32 *bmval, struct iattr *ia
 			goto xdr_error;
 		}
 	}
+#ifdef CONFIG_NFSD_V4_SECURITY_LABEL
+	if (bmval[1] & FATTR4_WORD1_SECURITY_LABEL) {
+		READ_BUF(4);
+		len += 4;
+		READ32(dummy32);
+		READ_BUF(dummy32);
+		len += (XDR_QUADLEN(dummy32) << 2);
+		READMEM(buf, dummy32);
+		iattr->ia_label_len = dummy32;
+		iattr->ia_label = kmalloc(dummy32 + 1, GFP_ATOMIC);
+		memcpy(iattr->ia_label, buf, dummy32);
+		((char *)iattr->ia_label)[dummy32 + 1] = '\0';
+		iattr->ia_valid |= ATTR_SECURITY_LABEL;
+		defer_free(argp, kfree, iattr->ia_label);
+	}
+#endif /* CONFIG_NFSD_V4_SECURITY_LABEL */
 	if (len != expected_len)
 		goto xdr_error;
 
@@ -1423,6 +1442,44 @@ nfsd4_encode_aclname(struct svc_rqst *rqstp, int whotype, uid_t id, int group,
 	return nfsd4_encode_name(rqstp, whotype, id, group, p, buflen);
 }
 
+#ifdef CONFIG_NFSD_V4_SECURITY_LABEL
+static inline __be32
+nfsd4_encode_security_label(struct svc_rqst *rqstp,
+			    struct dentry *dentry,
+			    __be32 **p, int *buflen)
+{
+	void *context;
+	int err = 0, len;
+
+	const char *suffix = security_maclabel_getname()
+				+ XATTR_SECURITY_PREFIX_LEN;
+
+	len = security_inode_getsecurity(dentry->d_inode, suffix, &context, true);
+	if (len < 0) {
+		err = nfserrno(len);
+		goto out;
+	}
+
+	if (len > NFS4_MAXLABELLEN) {
+		err = nfserrno(len);
+		goto out_err;
+	}
+	if (*buflen < ((XDR_QUADLEN(len) << 2) + 4)) {
+		err =  nfserr_resource;
+		goto out_err;
+	}
+
+	*p = xdr_encode_opaque(*p, context, len);
+	*buflen -= (XDR_QUADLEN(len) << 2) + 4;
+	BUG_ON(*buflen < 0);
+
+out_err:
+	security_release_secctx(context, len);
+out:
+	return err;
+}
+#endif /* CONFIG_NFSD_V4_SECURITY_LABEL */
+
 #define WORD0_ABSENT_FS_ATTRS (FATTR4_WORD0_FS_LOCATIONS | FATTR4_WORD0_FSID | \
 			      FATTR4_WORD0_RDATTR_ERROR)
 #define WORD1_ABSENT_FS_ATTRS FATTR4_WORD1_MOUNTED_ON_FILEID
@@ -1518,6 +1575,16 @@ nfsd4_encode_fattr(struct svc_fh *fhp, struct svc_export *exp,
 			bmval0 &= ~FATTR4_WORD0_FS_LOCATIONS;
 		}
 	}
+
+#ifdef CONFIG_NFSD_V4_SECURITY_LABEL
+	if (bmval1 & FATTR4_WORD1_SECURITY_LABEL) {
+		if (/* XXX !selinux_enabled */0)
+			bmval1 &= ~FATTR4_WORD1_SECURITY_LABEL;
+	}
+#else
+	bmval1 &= ~FATTR4_WORD1_SECURITY_LABEL;
+#endif
+
 	if ((buflen -= 16) < 0)
 		goto out_resource;
 
@@ -1528,15 +1595,25 @@ nfsd4_encode_fattr(struct svc_fh *fhp, struct svc_export *exp,
 
 	if (bmval0 & FATTR4_WORD0_SUPPORTED_ATTRS) {
 		u32 word0 = NFSD_SUPPORTED_ATTRS_WORD0;
+		u32 word1 = NFSD_SUPPORTED_ATTRS_WORD1;
 		if ((buflen -= 12) < 0)
 			goto out_resource;
 		if (!aclsupport)
 			word0 &= ~FATTR4_WORD0_ACL;
 		if (!exp->ex_fslocs.locations)
 			word0 &= ~FATTR4_WORD0_FS_LOCATIONS;
+#ifdef CONFIG_NFSD_V4_SECURITY_LABEL
+		if (exp->ex_flags & NFSEXP_SECURITY_LABEL)
+			word1 |= FATTR4_WORD1_SECURITY_LABEL;
+		else
+			word1 &= ~FATTR4_WORD1_SECURITY_LABEL;
+#else
+		word1 &= ~FATTR4_WORD1_SECURITY_LABEL;
+#endif /* CONFIG_NFSD_V4_SECURITY_LABEL */
+
 		WRITE32(2);
 		WRITE32(word0);
-		WRITE32(NFSD_SUPPORTED_ATTRS_WORD1);
+		WRITE32(word1);
 	}
 	if (bmval0 & FATTR4_WORD0_TYPE) {
 		if ((buflen -= 4) < 0)
@@ -1846,6 +1923,17 @@ out_acl:
 		}
 		WRITE64(stat.ino);
 	}
+#ifdef CONFIG_NFSD_V4_SECURITY_LABEL
+	if (bmval1 & FATTR4_WORD1_SECURITY_LABEL) {
+		status = nfsd4_encode_security_label(rqstp, dentry,
+				&p, &buflen);
+		if (status == nfserr_resource)
+			goto out_resource;
+		if (status)
+			goto out;
+	}
+#endif /* CONFIG_NFSD_V4_SECURITY_LABEL */
+
 	*attrlenp = htonl((char *)p - (char *)attrlenp - 4);
 	*countp = p - buffer;
 	status = nfs_ok;
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 46f59d5..45e9340 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1538,6 +1538,13 @@ nfsd_symlink(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	if (!host_err) {
 		if (EX_ISSYNC(fhp->fh_export))
 			host_err = nfsd_sync_dir(dentry);
+#ifdef CONFIG_NFSD_V4_SECURITY_LABEL
+		if (iap && (iap->ia_valid & ATTR_SECURITY_LABEL)) {
+			char *key = (char *)security_maclabel_getname();
+			host_err = vfs_setxattr_locked(dnew, key,
+					iap->ia_label, iap->ia_label_len, 0);
+		}
+#endif
 	}
 	err = nfserrno(host_err);
 	fh_unlock(fhp);
diff --git a/fs/xattr.c b/fs/xattr.c
index 3acab16..b5a91e1 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -67,9 +67,9 @@ xattr_permission(struct inode *inode, const char *name, int mask)
 	return permission(inode, mask, NULL);
 }
 
-int
-vfs_setxattr(struct dentry *dentry, char *name, void *value,
-		size_t size, int flags)
+static int
+_vfs_setxattr(struct dentry *dentry, char *name, void *value,
+		size_t size, int flags, int lock)
 {
 	struct inode *inode = dentry->d_inode;
 	int error;
@@ -78,7 +78,8 @@ vfs_setxattr(struct dentry *dentry, char *name, void *value,
 	if (error)
 		return error;
 
-	mutex_lock(&inode->i_mutex);
+	if (lock)
+		mutex_lock(&inode->i_mutex);
 	error = security_inode_setxattr(dentry, name, value, size, flags);
 	if (error)
 		goto out;
@@ -95,15 +96,35 @@ vfs_setxattr(struct dentry *dentry, char *name, void *value,
 		const char *suffix = name + XATTR_SECURITY_PREFIX_LEN;
 		error = security_inode_setsecurity(inode, suffix, value,
 						   size, flags);
-		if (!error)
+		if (!error) {
+#ifdef CONFIG_SECURITY
+			fsnotify_change(dentry, ATTR_SECURITY_LABEL);
+#endif
 			fsnotify_xattr(dentry);
+		}
 	}
 out:
-	mutex_unlock(&inode->i_mutex);
+	if (lock)
+		mutex_unlock(&inode->i_mutex);
 	return error;
 }
+
+int
+vfs_setxattr(struct dentry *dentry, char *name, void *value,
+		size_t size, int flags)
+{
+	return _vfs_setxattr(dentry, name, value, size, flags, 1);
+}
 EXPORT_SYMBOL_GPL(vfs_setxattr);
 
+int
+vfs_setxattr_locked(struct dentry *dentry, char *name, void *value,
+			size_t size, int flags)
+{
+	return _vfs_setxattr(dentry, name, value, size, flags, 0);
+}
+EXPORT_SYMBOL_GPL(vfs_setxattr_locked);
+
 ssize_t
 xattr_getsecurity(struct inode *inode, const char *name, void *value,
 			size_t size)
diff --git a/include/linux/fcntl.h b/include/linux/fcntl.h
index 8603740..fae1e59 100644
--- a/include/linux/fcntl.h
+++ b/include/linux/fcntl.h
@@ -30,6 +30,7 @@
 #define DN_DELETE	0x00000008	/* File removed */
 #define DN_RENAME	0x00000010	/* File renamed */
 #define DN_ATTRIB	0x00000020	/* File changed attibutes */
+#define DN_LABEL        0x00000040      /* File (re)labeled */
 #define DN_MULTISHOT	0x80000000	/* Don't remove notifier */
 
 #define AT_FDCWD		-100    /* Special value used to indicate
diff --git a/include/linux/fs.h b/include/linux/fs.h
index b84b848..757add6 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -335,6 +335,10 @@ typedef void (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
 #define ATTR_KILL_PRIV	16384
 #define ATTR_OPEN	32768	/* Truncating from open(O_TRUNC) */
 
+#ifdef CONFIG_SECURITY
+#define ATTR_SECURITY_LABEL  65536
+#endif
+
 /*
  * This is the Inode Attributes structure, used for notify_change().  It
  * uses the above definitions as flags, to know which values have changed.
@@ -360,6 +364,10 @@ struct iattr {
 	 * check for (ia_valid & ATTR_FILE), and not for (ia_file != NULL).
 	 */
 	struct file	*ia_file;
+#ifdef CONFIG_SECURITY
+	void		*ia_label;
+	u32		 ia_label_len;
+#endif
 };
 
 /*
@@ -1971,6 +1979,9 @@ extern int buffer_migrate_page(struct address_space *,
 #define buffer_migrate_page NULL
 #endif
 
+#ifdef CONFIG_SECURITY
+extern int inode_setsecurity(struct inode *inode, struct iattr *attr);
+#endif
 extern int inode_change_ok(struct inode *, struct iattr *);
 extern int __must_check inode_setattr(struct inode *, struct iattr *);
 
diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index d4b7c4a..b54a3cb 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -253,6 +253,12 @@ static inline void fsnotify_change(struct dentry *dentry, unsigned int ia_valid)
 		in_mask |= IN_ATTRIB;
 		dn_mask |= DN_ATTRIB;
 	}
+#ifdef CONFIG_SECURITY
+	if (ia_valid & ATTR_SECURITY_LABEL) {
+		in_mask |= IN_LABEL;
+		dn_mask |= DN_LABEL;
+	}
+#endif
 
 	if (dn_mask)
 		dnotify_parent(dentry, dn_mask);
diff --git a/include/linux/inotify.h b/include/linux/inotify.h
index 742b917..10f3ace 100644
--- a/include/linux/inotify.h
+++ b/include/linux/inotify.h
@@ -36,6 +36,7 @@ struct inotify_event {
 #define IN_DELETE		0x00000200	/* Subfile was deleted */
 #define IN_DELETE_SELF		0x00000400	/* Self was deleted */
 #define IN_MOVE_SELF		0x00000800	/* Self was moved */
+#define IN_LABEL		0x00001000	/* Self was (re)labeled */
 
 /* the following are legal events.  they are sent as needed to any watch */
 #define IN_UNMOUNT		0x00002000	/* Backing fs was unmounted */
@@ -61,7 +62,7 @@ struct inotify_event {
 #define IN_ALL_EVENTS	(IN_ACCESS | IN_MODIFY | IN_ATTRIB | IN_CLOSE_WRITE | \
 			 IN_CLOSE_NOWRITE | IN_OPEN | IN_MOVED_FROM | \
 			 IN_MOVED_TO | IN_DELETE | IN_CREATE | IN_DELETE_SELF | \
-			 IN_MOVE_SELF)
+			 IN_MOVE_SELF | IN_LABEL)
 
 #ifdef __KERNEL__
 
diff --git a/include/linux/nfs4.h b/include/linux/nfs4.h
index 8726491..af90403 100644
--- a/include/linux/nfs4.h
+++ b/include/linux/nfs4.h
@@ -21,6 +21,7 @@
 #define NFS4_FHSIZE		128
 #define NFS4_MAXPATHLEN		PATH_MAX
 #define NFS4_MAXNAMLEN		NAME_MAX
+#define NFS4_MAXLABELLEN	255
 
 #define NFS4_ACCESS_READ        0x0001
 #define NFS4_ACCESS_LOOKUP      0x0002
@@ -348,6 +349,7 @@ enum lock_type4 {
 #define FATTR4_WORD1_TIME_MODIFY        (1UL << 21)
 #define FATTR4_WORD1_TIME_MODIFY_SET    (1UL << 22)
 #define FATTR4_WORD1_MOUNTED_ON_FILEID  (1UL << 23)
+#define FATTR4_WORD1_SECURITY_LABEL	(1UL << 31)
 
 #define NFSPROC4_NULL 0
 #define NFSPROC4_COMPOUND 1
diff --git a/include/linux/nfs4_mount.h b/include/linux/nfs4_mount.h
index a0dcf66..d7abc3b 100644
--- a/include/linux/nfs4_mount.h
+++ b/include/linux/nfs4_mount.h
@@ -66,6 +66,7 @@ struct nfs4_mount_data {
 #define NFS4_MOUNT_NOAC		0x0020	/* 1 */
 #define NFS4_MOUNT_STRICTLOCK	0x1000	/* 1 */
 #define NFS4_MOUNT_UNSHARED	0x8000	/* 1 */
-#define NFS4_MOUNT_FLAGMASK	0x9033
+#define NFS4_MOUNT_SECURITY_LABEL 0x10000 /* Text Only */
+#define NFS4_MOUNT_FLAGMASK	0x19033
 
 #endif
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index a69ba80..991d56f 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -345,6 +345,47 @@ static inline void nfs_fattr_init(struct nfs_fattr *fattr)
 	fattr->time_start = jiffies;
 }
 
+#ifdef CONFIG_SECURITY
+static inline void nfs_fattr_alloc(struct nfs_fattr *fattr, gfp_t flags)
+{
+	fattr->label = kzalloc(NFS4_MAXLABELLEN, flags);
+	if (fattr->label == NULL)
+		panic("Can't allocate security label.");
+	fattr->label_len = NFS4_MAXLABELLEN;
+}
+
+#define	nfs_fattr_fini(fattr)	_nfs_fattr_fini(fattr, __FILE__, __LINE__, __func__)
+static inline void _nfs_fattr_fini(struct nfs_fattr *fattr,
+		const char *file, int line, const char *func)
+{
+	if ((fattr)->label == NULL) {
+		if (fattr->label_len != 0) {
+			printk(KERN_WARNING
+					"%s:%d %s() nfs_fattr label available (%d)\n",
+					file, line, func,
+					fattr->label_len);
+		}
+	} else {
+		if (fattr->label_len == NFS4_MAXLABELLEN)
+			printk(KERN_WARNING
+					"%s:%d %s() nfs_fattr label unused\n",
+					file, line, func);
+		else if (fattr->label_len != (strlen(fattr->label) + 1))
+			printk(KERN_WARNING
+				"%s:%d %s() nfs_fattr label size mismatch (label_len %d, strlen %d)\n",
+				file, line, func,
+				fattr->label_len, strlen(fattr->label) + 1);
+
+		kfree(fattr->label);
+		fattr->label = NULL;
+		fattr->label_len = 0;
+	}
+}
+#else
+#define	nfs_fattr_alloc(fattr, flags)
+#define	nfs_fattr_fini(fattr)
+#endif
+
 /*
  * linux/fs/nfs/file.c
  */
diff --git a/include/linux/nfs_fs_sb.h b/include/linux/nfs_fs_sb.h
index 3423c67..8fdea18 100644
--- a/include/linux/nfs_fs_sb.h
+++ b/include/linux/nfs_fs_sb.h
@@ -125,5 +125,6 @@ struct nfs_server {
 #define NFS_CAP_SYMLINKS	(1U << 2)
 #define NFS_CAP_ACLS		(1U << 3)
 #define NFS_CAP_ATOMIC_OPEN	(1U << 4)
+#define NFS_CAP_SECURITY_LABEL  (1U << 5)
 
 #endif
diff --git a/include/linux/nfs_mount.h b/include/linux/nfs_mount.h
index df7c6b7..1ca5260 100644
--- a/include/linux/nfs_mount.h
+++ b/include/linux/nfs_mount.h
@@ -63,6 +63,7 @@ struct nfs_mount_data {
 #define NFS_MOUNT_SECFLAVOUR	0x2000	/* 5 */
 #define NFS_MOUNT_NORDIRPLUS	0x4000	/* 5 */
 #define NFS_MOUNT_UNSHARED	0x8000	/* 5 */
-#define NFS_MOUNT_FLAGMASK	0xFFFF
+#define NFS_MOUNT_SECURITY_LABEL 0x10000 /* reserved for NFSv4 */
+#define NFS_MOUNT_FLAGMASK	0x1FFFF
 
 #endif
diff --git a/include/linux/nfs_xdr.h b/include/linux/nfs_xdr.h
index f301d0b..d7ce8b9 100644
--- a/include/linux/nfs_xdr.h
+++ b/include/linux/nfs_xdr.h
@@ -56,6 +56,10 @@ struct nfs_fattr {
 	__u64			change_attr;	/* NFSv4 change attribute */
 	__u64			pre_change_attr;/* pre-op NFSv4 change attribute */
 	unsigned long		time_start;
+#ifdef CONFIG_SECURITY
+	void			*label;
+	__u32			 label_len;
+#endif
 };
 
 #define NFS_ATTR_WCC		0x0001		/* pre-op WCC data    */
diff --git a/include/linux/nfsd/export.h b/include/linux/nfsd/export.h
index 5431512..bb831fc 100644
--- a/include/linux/nfsd/export.h
+++ b/include/linux/nfsd/export.h
@@ -32,7 +32,8 @@
 #define NFSEXP_ALLSQUASH	0x0008
 #define NFSEXP_ASYNC		0x0010
 #define NFSEXP_GATHERED_WRITES	0x0020
-/* 40 80 100 currently unused */
+#define NFSEXP_SECURITY_LABEL	0x0040  /* Support security label fattr4 */
+/* 80 100 currently unused */
 #define NFSEXP_NOHIDE		0x0200
 #define NFSEXP_NOSUBTREECHECK	0x0400
 #define	NFSEXP_NOAUTHNLM	0x0800		/* Don't authenticate NLM requests - just trust */
@@ -40,7 +41,7 @@
 #define NFSEXP_FSID		0x2000
 #define	NFSEXP_CROSSMOUNT	0x4000
 #define	NFSEXP_NOACL		0x8000	/* reserved for possible ACL related use */
-#define NFSEXP_ALLFLAGS		0xFE3F
+#define NFSEXP_ALLFLAGS		0xFE7F
 
 /* The flags that may vary depending on security flavor: */
 #define NFSEXP_SECINFO_FLAGS	(NFSEXP_READONLY | NFSEXP_ROOTSQUASH \
diff --git a/include/linux/nfsd/nfsd.h b/include/linux/nfsd/nfsd.h
index 8caf4c4..045963c 100644
--- a/include/linux/nfsd/nfsd.h
+++ b/include/linux/nfsd/nfsd.h
@@ -310,8 +310,8 @@ extern struct timeval	nfssvc_boot;
  | FATTR4_WORD1_OWNER	        | FATTR4_WORD1_OWNER_GROUP  | FATTR4_WORD1_RAWDEV           \
  | FATTR4_WORD1_SPACE_AVAIL     | FATTR4_WORD1_SPACE_FREE   | FATTR4_WORD1_SPACE_TOTAL      \
  | FATTR4_WORD1_SPACE_USED      | FATTR4_WORD1_TIME_ACCESS  | FATTR4_WORD1_TIME_ACCESS_SET  \
- | FATTR4_WORD1_TIME_DELTA   | FATTR4_WORD1_TIME_METADATA    \
- | FATTR4_WORD1_TIME_MODIFY     | FATTR4_WORD1_TIME_MODIFY_SET | FATTR4_WORD1_MOUNTED_ON_FILEID)
+ | FATTR4_WORD1_TIME_DELTA   	| FATTR4_WORD1_TIME_METADATA | FATTR4_WORD1_TIME_MODIFY     \
+ | FATTR4_WORD1_TIME_MODIFY_SET | FATTR4_WORD1_MOUNTED_ON_FILEID | FATTR4_WORD1_SECURITY_LABEL)
 
 /* These will return ERR_INVAL if specified in GETATTR or READDIR. */
 #define NFSD_WRITEONLY_ATTRS_WORD1							    \
@@ -322,7 +322,8 @@ extern struct timeval	nfssvc_boot;
 (FATTR4_WORD0_SIZE              | FATTR4_WORD0_ACL                                         )
 #define NFSD_WRITEABLE_ATTRS_WORD1                                                          \
 (FATTR4_WORD1_MODE              | FATTR4_WORD1_OWNER         | FATTR4_WORD1_OWNER_GROUP     \
- | FATTR4_WORD1_TIME_ACCESS_SET | FATTR4_WORD1_TIME_METADATA | FATTR4_WORD1_TIME_MODIFY_SET)
+ | FATTR4_WORD1_TIME_ACCESS_SET | FATTR4_WORD1_TIME_METADATA | FATTR4_WORD1_TIME_MODIFY_SET \
+ | FATTR4_WORD1_SECURITY_LABEL)
 
 #endif /* CONFIG_NFSD_V4 */
 
diff --git a/include/linux/security.h b/include/linux/security.h
index fe52cde..9038f34 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1264,6 +1264,8 @@ struct security_operations {
 	void (*sb_clone_mnt_opts) (const struct super_block *oldsb,
 				   struct super_block *newsb);
 
+	int (*dentry_init_security) (struct dentry *dentry, int mode,
+				     void **ctx, u32 *ctxlen);
 	int (*inode_alloc_security) (struct inode *inode);	
 	void (*inode_free_security) (struct inode *inode);
 	int (*inode_init_security) (struct inode *inode, struct inode *dir,
@@ -1394,6 +1396,7 @@ struct security_operations {
 	int (*secid_to_secctx)(u32 secid, char **secdata, u32 *seclen);
 	int (*secctx_to_secid)(char *secdata, u32 seclen, u32 *secid);
 	void (*release_secctx)(char *secdata, u32 seclen);
+	const char *(*maclabel_getname) (void);
 
 #ifdef CONFIG_SECURITY_NETWORK
 	int (*unix_stream_connect) (struct socket * sock,
@@ -1527,6 +1530,7 @@ int security_sb_set_mnt_opts(struct super_block *sb, char **mount_options,
 void security_sb_clone_mnt_opts(const struct super_block *oldsb,
 				struct super_block *newsb);
 
+int security_dentry_init_security(struct dentry *dentry, int mode, void **ctx, u32 *ctxlen);
 int security_inode_alloc(struct inode *inode);
 void security_inode_free(struct inode *inode);
 int security_inode_init_security(struct inode *inode, struct inode *dir,
@@ -1633,6 +1637,7 @@ int security_netlink_recv(struct sk_buff *skb, int cap);
 int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen);
 int security_secctx_to_secid(char *secdata, u32 seclen, u32 *secid);
 void security_release_secctx(char *secdata, u32 seclen);
+const char *security_maclabel_getname(void);
 
 #else /* CONFIG_SECURITY */
 
@@ -1820,6 +1825,14 @@ static inline void security_sb_post_pivotroot (struct nameidata *old_nd,
 					       struct nameidata *new_nd)
 { }
 
+static inline int security_dentry_init_security(struct dentry *dentry,
+						 int mode,
+						 void **ctx,
+						 u32 *ctxlen)
+{
+	return 0;
+}
+
 static inline int security_inode_alloc (struct inode *inode)
 {
 	return 0;
@@ -2316,6 +2329,12 @@ static inline int security_secctx_to_secid(char *secdata,
 static inline void security_release_secctx(char *secdata, u32 seclen)
 {
 }
+
+static inline const char *security_maclabel_getname(void)
+{
+	return NULL;
+}
+
 #endif	/* CONFIG_SECURITY */
 
 #ifdef CONFIG_SECURITY_NETWORK
diff --git a/include/linux/xattr.h b/include/linux/xattr.h
index df6b95d..1169963 100644
--- a/include/linux/xattr.h
+++ b/include/linux/xattr.h
@@ -50,6 +50,7 @@ ssize_t xattr_getsecurity(struct inode *, const char *, void *, size_t);
 ssize_t vfs_getxattr(struct dentry *, char *, void *, size_t);
 ssize_t vfs_listxattr(struct dentry *d, char *list, size_t size);
 int vfs_setxattr(struct dentry *, char *, void *, size_t, int);
+int vfs_setxattr_locked(struct dentry *, char *, void *, size_t, int);
 int vfs_removexattr(struct dentry *, char *);
 
 ssize_t generic_getxattr(struct dentry *dentry, const char *name, void *buffer, size_t size);
diff --git a/security/dummy.c b/security/dummy.c
index 649326b..d322c73 100644
--- a/security/dummy.c
+++ b/security/dummy.c
@@ -268,6 +268,12 @@ static void dummy_sb_clone_mnt_opts(const struct super_block *oldsb,
 	return;
 }
 
+static int dummy_dentry_init_security(struct dentry *dentry, int mode,
+				       void **ctx, u32 *ctxlen)
+{
+	return -EOPNOTSUPP;
+}
+
 static int dummy_inode_alloc_security (struct inode *inode)
 {
 	return 0;
@@ -960,6 +966,11 @@ static void dummy_release_secctx(char *secdata, u32 seclen)
 {
 }
 
+static const char *dummy_maclabel_getname(void)
+{
+	return NULL;
+}
+
 #ifdef CONFIG_KEYS
 static inline int dummy_key_alloc(struct key *key, struct task_struct *ctx,
 				  unsigned long flags)
@@ -1028,6 +1039,7 @@ void security_fixup_ops (struct security_operations *ops)
 	set_to_dummy_if_null(ops, sb_get_mnt_opts);
 	set_to_dummy_if_null(ops, sb_set_mnt_opts);
 	set_to_dummy_if_null(ops, sb_clone_mnt_opts);
+	set_to_dummy_if_null(ops, dentry_init_security);
 	set_to_dummy_if_null(ops, inode_alloc_security);
 	set_to_dummy_if_null(ops, inode_free_security);
 	set_to_dummy_if_null(ops, inode_init_security);
@@ -1118,6 +1130,7 @@ void security_fixup_ops (struct security_operations *ops)
  	set_to_dummy_if_null(ops, secid_to_secctx);
 	set_to_dummy_if_null(ops, secctx_to_secid);
  	set_to_dummy_if_null(ops, release_secctx);
+	set_to_dummy_if_null(ops, maclabel_getname);
 #ifdef CONFIG_SECURITY_NETWORK
 	set_to_dummy_if_null(ops, unix_stream_connect);
 	set_to_dummy_if_null(ops, unix_may_send);
diff --git a/security/security.c b/security/security.c
index d15e56c..646a411 100644
--- a/security/security.c
+++ b/security/security.c
@@ -325,6 +325,15 @@ void security_sb_clone_mnt_opts(const struct super_block *oldsb,
 	security_ops->sb_clone_mnt_opts(oldsb, newsb);
 }
 
+int security_dentry_init_security(struct dentry *dentry,
+						 int mode,
+						 void **ctx,
+						 u32 *ctxlen)
+{
+	return security_ops->dentry_init_security(dentry, mode, ctx, ctxlen);
+}
+EXPORT_SYMBOL(security_dentry_init_security);
+
 int security_inode_alloc(struct inode *inode)
 {
 	inode->i_security = NULL;
@@ -501,6 +510,7 @@ int security_inode_getsecurity(const struct inode *inode, const char *name, void
 		return 0;
 	return security_ops->inode_getsecurity(inode, name, buffer, alloc);
 }
+EXPORT_SYMBOL(security_inode_getsecurity);
 
 int security_inode_setsecurity(struct inode *inode, const char *name, const void *value, size_t size, int flags)
 {
@@ -508,6 +518,7 @@ int security_inode_setsecurity(struct inode *inode, const char *name, const void
 		return 0;
 	return security_ops->inode_setsecurity(inode, name, value, size, flags);
 }
+EXPORT_SYMBOL(security_inode_setsecurity);
 
 int security_inode_listsecurity(struct inode *inode, char *buffer, size_t buffer_size)
 {
@@ -845,6 +856,12 @@ void security_release_secctx(char *secdata, u32 seclen)
 }
 EXPORT_SYMBOL(security_release_secctx);
 
+const char *security_maclabel_getname(void)
+{
+	return security_ops->maclabel_getname();
+}
+EXPORT_SYMBOL(security_maclabel_getname);
+
 #ifdef CONFIG_SECURITY_NETWORK
 
 int security_unix_stream_connect(struct socket *sock, struct socket *other,
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 75c2e99..1742aaa 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -63,10 +63,12 @@
 #include <linux/udp.h>
 #include <linux/dccp.h>
 #include <linux/quota.h>
+#include <linux/fsnotify.h>
 #include <linux/un.h>		/* for Unix socket types */
 #include <net/af_unix.h>	/* for Unix socket types */
 #include <linux/parser.h>
 #include <linux/nfs_mount.h>
+#include <linux/nfs4_mount.h>
 #include <net/ipv6.h>
 #include <linux/hugetlb.h>
 #include <linux/personality.h>
@@ -299,13 +301,14 @@ extern int ss_initialized;
 
 /* The file system's label must be initialized prior to use. */
 
-static char *labeling_behaviors[6] = {
+static char *labeling_behaviors[7] = {
 	"uses xattr",
 	"uses transition SIDs",
 	"uses task SIDs",
 	"uses genfs_contexts",
 	"not configured for labeling",
 	"uses mountpoint labeling",
+	"uses native labels",
 };
 
 static int inode_doinit_with_dentry(struct inode *inode, struct dentry *opt_dentry);
@@ -659,14 +662,15 @@ static int selinux_set_mnt_opts(struct super_block *sb, char **mount_options,
 	if (strcmp(sb->s_type->name, "proc") == 0)
 		sbsec->proc = 1;
 
-	/* Determine the labeling behavior to use for this filesystem type. */
-	rc = security_fs_use(sb->s_type->name, &sbsec->behavior, &sbsec->sid);
-	if (rc) {
-		printk(KERN_WARNING "%s: security_fs_use(%s) returned %d\n",
-		       __FUNCTION__, sb->s_type->name, rc);
-		goto out;
+	if (!sbsec->behavior) {
+		/* Determine the labeling behavior to use for this filesystem type. */
+		rc = security_fs_use(sb->s_type->name, &sbsec->behavior, &sbsec->sid);
+		if (rc) {
+			printk(KERN_WARNING "%s: security_fs_use(%s) returned %d\n",
+			       __FUNCTION__, sb->s_type->name, rc);
+			goto out;
+		}
 	}
-
 	/* sets the context of the superblock for the fs being mounted. */
 	if (fscontext_sid) {
 
@@ -804,6 +808,7 @@ static int superblock_doinit(struct super_block *sb, void *data)
 	/* selinux only know about a fixed number of mount options */
 	char *mnt_opts[NUM_SEL_MNT_OPTS];
 	int mnt_opts_flags[NUM_SEL_MNT_OPTS], num_mnt_opts = 0;
+	struct superblock_security_struct *sbsec = sb->s_security;
 
 	if (!data)
 		goto out;
@@ -826,6 +831,15 @@ static int superblock_doinit(struct super_block *sb, void *data)
 				}
 			}
 			goto build_flags;
+		} else if (!strcmp(name, "nfs4")) {
+			struct nfs4_mount_data *d = data;
+
+			if (d->version !=  NFS4_MOUNT_VERSION)
+				goto out;
+
+			if (d->flags & NFS4_MOUNT_SECURITY_LABEL)
+				sbsec->behavior = SECURITY_FS_USE_NATIVE;
+			goto build_flags;
 		} else
 			goto out;
 	}
@@ -895,7 +909,7 @@ static int superblock_doinit(struct super_block *sb, void *data)
 
 		default:
 			rc = -EINVAL;
-			printk(KERN_WARNING "SELinux:  unknown mount option\n");
+			printk(KERN_WARNING "SELinux:  unknown mount option \"%s\"\n", p);
 			goto out_err;
 
 		}
@@ -1102,6 +1116,8 @@ static int inode_doinit_with_dentry(struct inode *inode, struct dentry *opt_dent
 	}
 
 	switch (sbsec->behavior) {
+	case SECURITY_FS_USE_NATIVE:
+		break;
 	case SECURITY_FS_USE_XATTR:
 		if (!inode->i_op->getxattr) {
 			isec->sid = sbsec->def_sid;
@@ -2358,6 +2374,42 @@ static int selinux_umount(struct vfsmount *mnt, int flags)
 
 /* inode security operations */
 
+/*
+ * For now, we need a way to compute a SID for
+ * a dentry as the inode is not yet available
+ * (and under NFSv4 has no label backed by an EA anyway.
+ */
+static int selinux_dentry_init_security(struct dentry *dentry, int mode,
+					void **ctx, u32 *ctxlen)
+{
+	struct task_security_struct *tsec;
+	struct inode_security_struct *dsec;
+	struct superblock_security_struct *sbsec;
+	struct inode *dir = dentry->d_parent->d_inode;
+	u32 newsid;
+	int rc;
+
+	tsec = current->security;
+	dsec = dir->i_security;
+	sbsec = dir->i_sb->s_security;
+
+	if (tsec->create_sid && sbsec->behavior != SECURITY_FS_USE_MNTPOINT) {
+		newsid = tsec->create_sid;
+	} else {
+		rc = security_transition_sid(tsec->sid, dsec->sid,
+					     inode_mode_to_security_class(mode),
+					     &newsid);
+		if (rc) {
+			printk(KERN_WARNING "%s:  "
+			       "security_transition_sid failed, rc=%d\n",
+			       __FUNCTION__, -rc);
+			return rc;
+		}
+	}
+
+	return security_sid_to_context(newsid, (char **)ctx, ctxlen);
+}
+
 static int selinux_inode_alloc_security(struct inode *inode)
 {
 	return inode_alloc_security(inode);
@@ -2631,7 +2683,11 @@ static void selinux_inode_post_setxattr(struct dentry *dentry, char *name,
 		return;
 	}
 
+	isec->sclass = inode_mode_to_security_class(inode->i_mode);
 	isec->sid = newsid;
+	isec->initialized = 1;
+
+	fsnotify_change(dentry, ATTR_SECURITY_LABEL);
 	return;
 }
 
@@ -2702,7 +2758,9 @@ static int selinux_inode_setsecurity(struct inode *inode, const char *name,
 	if (rc)
 		return rc;
 
-	isec->sid = newsid;
+	isec->sclass = inode_mode_to_security_class(inode->i_mode);
+ 	isec->sid = newsid;
+	isec->initialized = 1;
 	return 0;
 }
 
@@ -5163,6 +5221,11 @@ static void selinux_release_secctx(char *secdata, u32 seclen)
 	kfree(secdata);
 }
 
+static const char *selinux_maclabel_getname(void)
+{
+      return XATTR_NAME_SELINUX;
+}
+
 #ifdef CONFIG_KEYS
 
 static int selinux_key_alloc(struct key *k, struct task_struct *tsk,
@@ -5252,6 +5315,7 @@ static struct security_operations selinux_ops = {
 	.sb_set_mnt_opts =		selinux_set_mnt_opts,
 	.sb_clone_mnt_opts = 		selinux_sb_clone_mnt_opts,
 
+	.dentry_init_security = 	selinux_dentry_init_security,
 	.inode_alloc_security =		selinux_inode_alloc_security,
 	.inode_free_security =		selinux_inode_free_security,
 	.inode_init_security =		selinux_inode_init_security,
@@ -5351,8 +5415,9 @@ static struct security_operations selinux_ops = {
 	.secid_to_secctx =		selinux_secid_to_secctx,
 	.secctx_to_secid =		selinux_secctx_to_secid,
 	.release_secctx =		selinux_release_secctx,
-
-        .unix_stream_connect =		selinux_socket_unix_stream_connect,
+	.maclabel_getname =  		selinux_maclabel_getname,
+        
+	.unix_stream_connect =		selinux_socket_unix_stream_connect,
 	.unix_may_send =		selinux_socket_unix_may_send,
 
 	.socket_create =		selinux_socket_create,
diff --git a/security/selinux/include/security.h b/security/selinux/include/security.h
index 837ce42..e788c7a 100644
--- a/security/selinux/include/security.h
+++ b/security/selinux/include/security.h
@@ -114,6 +114,8 @@ int security_get_allow_unknown(void);
 #define SECURITY_FS_USE_GENFS		4 /* use the genfs support */
 #define SECURITY_FS_USE_NONE		5 /* no labeling support */
 #define SECURITY_FS_USE_MNTPOINT	6 /* use mountpoint labeling */
+#define SECURITY_FS_USE_NATIVE		7 /* use native label support */
+#define SECURITY_FS_USE_MAX		7 /* Highest SECURITY_FS_USE_XXX */
 
 int security_fs_use(const char *fstype, unsigned int *behavior,
 	u32 *sid);
diff --git a/security/selinux/ss/policydb.c b/security/selinux/ss/policydb.c
index bd7d6a0..3d9e30e 100644
--- a/security/selinux/ss/policydb.c
+++ b/security/selinux/ss/policydb.c
@@ -1756,7 +1756,10 @@ int policydb_read(struct policydb *p, void *fp)
 				if (rc < 0)
 					goto bad;
 				c->v.behavior = le32_to_cpu(buf[0]);
-				if (c->v.behavior > SECURITY_FS_USE_NONE)
+				/* Determined at runtime, not in policy DB. */
+				if (c->v.behavior == SECURITY_FS_USE_MNTPOINT)
+					goto bad;
+				if (c->v.behavior > SECURITY_FS_USE_MAX)
 					goto bad;
 				len = le32_to_cpu(buf[1]);
 				c->u.name = kmalloc(len + 1,GFP_KERNEL);

--=-/a3RibfIJHEr1gDn6VW6--

