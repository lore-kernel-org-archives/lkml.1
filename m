Return-Path: <linux-kernel-owner+w=401wt.eu-S1754730AbYLAQpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730AbYLAQpm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 11:45:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753358AbYLAQko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 11:40:44 -0500
Received: from mummy.ncsc.mil ([144.51.88.129]:34917 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752240AbYLAQj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 11:39:57 -0500
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: hch@infradead.org, viro@zeniv.linux.org.uk, casey@schaufler-ca.com,
       sds@tycho.nsa.gov, matthew.dodd@sparta.com, trond.myklebust@fys.uio.no,
       bfields@fieldses.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov,
       labeled-nfs@linux-nfs.org, "David P. Quigley" <dpquigl@tycho.nsa.gov>,
       "Matthew N. Dodd" <Matthew.Dodd@sparta.com>
Subject: [PATCH 10/14] NFS: Introduce lifecycle management for label attribute.
Date: Wed, 26 Nov 2008 16:03:10 -0500
Message-Id: <1227733394-1114-11-git-send-email-dpquigl@tycho.nsa.gov>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1227733394-1114-1-git-send-email-dpquigl@tycho.nsa.gov>
References: <1227733394-1114-1-git-send-email-dpquigl@tycho.nsa.gov>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two fields have been added to the nfs_fattr structure to carry the security
label and its length. This has raised the need to provide lifecycle management
for these values. This patch introduces two macros nfs_fattr_alloc and
nfs_fattr_fini which are used to allocate and destroy these fields inside the
nfs_fattr structure. These macros do not modify any other components of the
structure so nfs_fattr_init still has to be used on these structures. In the
event that CONFIG_SECURITY is not set these calls should compile away.

Signed-off-by: Matthew N. Dodd <Matthew.Dodd@sparta.com>
Signed-off-by: David P. Quigley <dpquigl@tycho.nsa.gov>
---
 fs/nfs/client.c        |   16 ++++++
 fs/nfs/dir.c           |   32 ++++++++++-
 fs/nfs/getroot.c       |   44 +++++++++++++++-
 fs/nfs/inode.c         |   20 +++++++-
 fs/nfs/namespace.c     |    3 +
 fs/nfs/nfs3proc.c      |    7 +++
 fs/nfs/nfs4proc.c      |  138 +++++++++++++++++++++++++++++++++++++++++++++---
 fs/nfs/proc.c          |   12 ++++-
 fs/nfs/super.c         |    4 ++
 fs/nfs/unlink.c        |   12 +++-
 include/linux/nfs_fs.h |   24 ++++++++
 11 files changed, 296 insertions(+), 16 deletions(-)

diff --git a/fs/nfs/client.c b/fs/nfs/client.c
index 7547600..3c4a4cc 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -901,6 +901,8 @@ struct nfs_server *nfs_create_server(const struct nfs_parsed_mount_data *data,
 	struct nfs_fattr fattr;
 	int error;
 
+	memset(&fattr, 0, sizeof(struct nfs_fattr));
+
 	server = nfs_alloc_server();
 	if (!server)
 		return ERR_PTR(-ENOMEM);
@@ -951,10 +953,12 @@ struct nfs_server *nfs_create_server(const struct nfs_parsed_mount_data *data,
 	spin_unlock(&nfs_client_lock);
 
 	server->mount_time = jiffies;
+	nfs_fattr_fini(&fattr);
 	return server;
 
 error:
 	nfs_free_server(server);
+	nfs_fattr_fini(&fattr);
 	return ERR_PTR(error);
 }
 
@@ -1108,6 +1112,8 @@ struct nfs_server *nfs4_create_server(const struct nfs_parsed_mount_data *data,
 
 	dprintk("--> nfs4_create_server()\n");
 
+	memset(&fattr, 0, sizeof(struct nfs_fattr));
+
 	server = nfs_alloc_server();
 	if (!server)
 		return ERR_PTR(-ENOMEM);
@@ -1148,11 +1154,13 @@ struct nfs_server *nfs4_create_server(const struct nfs_parsed_mount_data *data,
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
@@ -1170,6 +1178,8 @@ struct nfs_server *nfs4_create_referral_server(struct nfs_clone_mount *data,
 
 	dprintk("--> nfs4_create_referral_server()\n");
 
+	memset(&fattr, 0, sizeof(struct nfs_fattr));
+
 	server = nfs_alloc_server();
 	if (!server)
 		return ERR_PTR(-ENOMEM);
@@ -1226,10 +1236,12 @@ struct nfs_server *nfs4_create_referral_server(struct nfs_clone_mount *data,
 	server->mount_time = jiffies;
 
 	dprintk("<-- nfs_create_referral_server() = %p\n", server);
+	nfs_fattr_fini(&fattr);
 	return server;
 
 error:
 	nfs_free_server(server);
+	nfs_fattr_fini(&fattr);
 	dprintk("<-- nfs4_create_referral_server() = error %d\n", error);
 	return ERR_PTR(error);
 }
@@ -1251,6 +1263,8 @@ struct nfs_server *nfs_clone_server(struct nfs_server *source,
 		(unsigned long long) fattr->fsid.major,
 		(unsigned long long) fattr->fsid.minor);
 
+	memset(&fattr_fsinfo, 0, sizeof(struct nfs_fattr));
+
 	server = nfs_alloc_server();
 	if (!server)
 		return ERR_PTR(-ENOMEM);
@@ -1293,11 +1307,13 @@ struct nfs_server *nfs_clone_server(struct nfs_server *source,
 
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
index 3e64b98..8855b01 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -557,6 +557,7 @@ static int nfs_readdir(struct file *filp, void *dirent, filldir_t filldir)
 	my_entry.eof = 0;
 	my_entry.fh = &fh;
 	my_entry.fattr = &fattr;
+	memset(&fattr, 0, sizeof(struct nfs_fattr));
 	nfs_fattr_init(&fattr);
 	desc->entry = &my_entry;
 
@@ -594,6 +595,7 @@ static int nfs_readdir(struct file *filp, void *dirent, filldir_t filldir)
 			res = 0;
 			break;
 		}
+		nfs_fattr_fini(&fattr);
 	}
 out:
 	nfs_unblock_sillyrename(dentry);
@@ -777,10 +779,12 @@ static int nfs_lookup_revalidate(struct dentry * dentry, struct nameidata *nd)
 	struct inode *dir;
 	struct inode *inode;
 	struct dentry *parent;
-	int error;
+	int error = 0;
 	struct nfs_fh fhandle;
 	struct nfs_fattr fattr;
 
+	memset(&fattr, 0, sizeof(struct nfs_fattr));
+
 	parent = dget_parent(dentry);
 	dir = parent->d_inode;
 	nfs_inc_stats(dir, NFSIOS_DENTRYREVALIDATE);
@@ -809,6 +813,13 @@ static int nfs_lookup_revalidate(struct dentry * dentry, struct nameidata *nd)
 	if (NFS_STALE(inode))
 		goto out_bad;
 
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (nfs_server_capable(dir, NFS_CAP_SECURITY_LABEL))
+		error = nfs_fattr_alloc(&fattr, GFP_NOWAIT);
+	if (error < 0)
+		goto out_bad;
+#endif
+
 	error = NFS_PROTO(dir)->lookup(dir, &dentry->d_name, &fhandle, &fattr);
 	if (error)
 		goto out_bad;
@@ -820,6 +831,7 @@ static int nfs_lookup_revalidate(struct dentry * dentry, struct nameidata *nd)
 	nfs_set_verifier(dentry, nfs_save_change_attribute(dir));
  out_valid:
 	dput(parent);
+	nfs_fattr_fini(&fattr);
 	dfprintk(LOOKUPCACHE, "NFS: %s(%s/%s) is valid\n",
 			__func__, dentry->d_parent->d_name.name,
 			dentry->d_name.name);
@@ -838,6 +850,7 @@ out_zap_parent:
 	}
 	d_drop(dentry);
 	dput(parent);
+	nfs_fattr_fini(&fattr);
 	dfprintk(LOOKUPCACHE, "NFS: %s(%s/%s) is invalid\n",
 			__func__, dentry->d_parent->d_name.name,
 			dentry->d_name.name);
@@ -906,7 +919,7 @@ static struct dentry *nfs_lookup(struct inode *dir, struct dentry * dentry, stru
 	struct dentry *res;
 	struct dentry *parent;
 	struct inode *inode = NULL;
-	int error;
+	int error = 0;
 	struct nfs_fh fhandle;
 	struct nfs_fattr fattr;
 
@@ -914,6 +927,8 @@ static struct dentry *nfs_lookup(struct inode *dir, struct dentry * dentry, stru
 		dentry->d_parent->d_name.name, dentry->d_name.name);
 	nfs_inc_stats(dir, NFSIOS_VFSLOOKUP);
 
+	memset(&fattr, 0, sizeof(struct nfs_fattr));
+
 	res = ERR_PTR(-ENAMETOOLONG);
 	if (dentry->d_name.len > NFS_SERVER(dir)->namelen)
 		goto out;
@@ -931,6 +946,13 @@ static struct dentry *nfs_lookup(struct inode *dir, struct dentry * dentry, stru
 		goto out;
 	}
 
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (nfs_server_capable(dir, NFS_CAP_SECURITY_LABEL))
+		error = nfs_fattr_alloc(&fattr, GFP_NOWAIT);
+	if (error < 0)
+		goto out;
+#endif
+
 	parent = dentry->d_parent;
 	/* Protect against concurrent sillydeletes */
 	nfs_block_sillyrename(parent);
@@ -957,6 +979,8 @@ no_entry:
 out_unblock_sillyrename:
 	nfs_unblock_sillyrename(parent);
 out:
+	/* Label will give 'unused' warning on 'no_entry' case. */
+	nfs_fattr_fini(&fattr);
 	return res;
 }
 
@@ -1222,6 +1246,7 @@ static int nfs_create(struct inode *dir, struct dentry *dentry, int mode,
 	dfprintk(VFS, "NFS: create(%s/%ld), %s\n",
 			dir->i_sb->s_id, dir->i_ino, dentry->d_name.name);
 
+	memset(&attr, 0, sizeof(struct iattr));
 	attr.ia_mode = mode;
 	attr.ia_valid = ATTR_MODE;
 
@@ -1252,6 +1277,7 @@ nfs_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t rdev)
 	if (!new_valid_dev(rdev))
 		return -EINVAL;
 
+	memset(&attr, 0, sizeof(struct iattr));
 	attr.ia_mode = mode;
 	attr.ia_valid = ATTR_MODE;
 
@@ -1275,6 +1301,7 @@ static int nfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 	dfprintk(VFS, "NFS: mkdir(%s/%ld), %s\n",
 			dir->i_sb->s_id, dir->i_ino, dentry->d_name.name);
 
+	memset(&attr, 0, sizeof(struct iattr));
 	attr.ia_valid = ATTR_MODE;
 	attr.ia_mode = mode | S_IFDIR;
 
@@ -1484,6 +1511,7 @@ static int nfs_symlink(struct inode *dir, struct dentry *dentry, const char *sym
 	if (pathlen > PAGE_SIZE)
 		return -ENAMETOOLONG;
 
+	memset(&attr, 0, sizeof(struct iattr));
 	attr.ia_mode = S_IFLNK | S_IRWXUGO;
 	attr.ia_valid = ATTR_MODE;
 
diff --git a/fs/nfs/getroot.c b/fs/nfs/getroot.c
index b7c9b2d..a8a922d 100644
--- a/fs/nfs/getroot.c
+++ b/fs/nfs/getroot.c
@@ -31,7 +31,6 @@
 #include <linux/vfs.h>
 #include <linux/namei.h>
 #include <linux/mnt_namespace.h>
-#include <linux/security.h>
 
 #include <asm/system.h>
 #include <asm/uaccess.h>
@@ -84,6 +83,8 @@ struct dentry *nfs_get_root(struct super_block *sb, struct nfs_fh *mntfh)
 	struct inode *inode;
 	int error;
 
+	memset(&fattr, 0, sizeof(struct nfs_fattr));
+
 	/* get the actual root for this mount */
 	fsinfo.fattr = &fattr;
 
@@ -118,6 +119,7 @@ struct dentry *nfs_get_root(struct super_block *sb, struct nfs_fh *mntfh)
 	if (!mntroot->d_op)
 		mntroot->d_op = server->nfs_client->rpc_ops->dentry_ops;
 
+	nfs_fattr_fini(&fattr);
 	return mntroot;
 }
 
@@ -142,6 +144,14 @@ int nfs4_path_walk(struct nfs_server *server,
 
 	dprintk("--> nfs4_path_walk(,,%s)\n", path);
 
+	memset(&fattr, 0, sizeof(struct nfs_fattr));
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	/* Unconditional, no server caps yet. */
+	ret = nfs_fattr_alloc(&fattr, GFP_KERNEL);
+	if (ret < 0)
+		return ret;
+#endif
+
 	fsinfo.fattr = &fattr;
 	nfs_fattr_init(&fattr);
 
@@ -153,12 +163,14 @@ int nfs4_path_walk(struct nfs_server *server,
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
 
@@ -166,6 +178,7 @@ int nfs4_path_walk(struct nfs_server *server,
 	if (fattr.valid & NFS_ATTR_FATTR_V4_REFERRAL) {
 		printk(KERN_ERR "nfs4_get_root:"
 		       " getroot obtained referral\n");
+		nfs_fattr_fini(&fattr);
 		return -EREMOTE;
 	}
 
@@ -198,6 +211,7 @@ eat_dot_dir:
 	    ) {
 		printk(KERN_ERR "nfs4_get_root:"
 		       " Mount path contains reference to \"..\"\n");
+		nfs_fattr_fini(&fattr);
 		return -EINVAL;
 	}
 
@@ -206,16 +220,27 @@ eat_dot_dir:
 
 	dprintk("LookupFH: %*.*s [%s]\n", name.len, name.len, name.name, path);
 
+	nfs_fattr_fini(&fattr);
+	memset(&fattr, 0, sizeof(struct nfs_fattr));
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (server->caps & NFS_CAP_SECURITY_LABEL)
+		ret = nfs_fattr_alloc(&fattr, GFP_KERNEL);
+	if (ret < 0)
+		return ret;
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
 
@@ -223,6 +248,7 @@ eat_dot_dir:
 	if (fattr.valid & NFS_ATTR_FATTR_V4_REFERRAL) {
 		printk(KERN_ERR "nfs4_get_root:"
 		       " lookupfh obtained referral\n");
+		nfs_fattr_fini(&fattr);
 		return -EREMOTE;
 	}
 
@@ -230,6 +256,7 @@ eat_dot_dir:
 
 path_walk_complete:
 	memcpy(&server->fsid, &fattr.fsid, sizeof(server->fsid));
+	nfs_fattr_fini(&fattr);
 	dprintk("<-- nfs4_path_walk() = 0\n");
 	return 0;
 }
@@ -255,19 +282,34 @@ struct dentry *nfs4_get_root(struct super_block *sb, struct nfs_fh *mntfh)
 		return ERR_PTR(error);
 	}
 
+	memset(&fattr, 0, sizeof(struct nfs_fattr));
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (server->caps & NFS_CAP_SECURITY_LABEL)
+		error = nfs_fattr_alloc(&fattr, GFP_KERNEL);
+	if (error < 0) {
+		dprintk("nfs_get_root: nfs_fattr_alloc error = %d\n",
+			error);
+		return ERR_PTR(error);
+	}
+#endif
+
 	/* get the actual root for this mount */
 	error = server->nfs_client->rpc_ops->getattr(server, mntfh, &fattr);
 	if (error < 0) {
+		nfs_fattr_fini(&fattr);
 		dprintk("nfs_get_root: getattr error = %d\n", -error);
 		return ERR_PTR(error);
 	}
 
 	inode = nfs_fhget(sb, mntfh, &fattr);
 	if (IS_ERR(inode)) {
+		nfs_fattr_fini(&fattr);
 		dprintk("nfs_get_root: get root inode failed\n");
 		return ERR_CAST(inode);
 	}
 
+	nfs_fattr_fini(&fattr);
+
 	error = nfs_superblock_set_dummy_root(sb, inode);
 	if (error != 0)
 		return ERR_PTR(error);
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index d22eb38..33ae87b 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -351,7 +351,7 @@ nfs_setattr(struct dentry *dentry, struct iattr *attr)
 {
 	struct inode *inode = dentry->d_inode;
 	struct nfs_fattr fattr;
-	int error;
+	int error = 0;
 
 	nfs_inc_stats(inode, NFSIOS_VFSSETATTR);
 
@@ -359,6 +359,14 @@ nfs_setattr(struct dentry *dentry, struct iattr *attr)
 	if (attr->ia_valid & (ATTR_KILL_SUID | ATTR_KILL_SGID))
 		attr->ia_valid &= ~ATTR_MODE;
 
+	memset(&fattr, 0, sizeof(struct nfs_fattr));
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (nfs_server_capable(inode, NFS_CAP_SECURITY_LABEL))
+		error = nfs_fattr_alloc(&fattr, GFP_KERNEL);
+	if (error < 0)
+		return error;
+#endif
+
 	if (attr->ia_valid & ATTR_SIZE) {
 		if (!S_ISREG(inode->i_mode) || attr->ia_size == i_size_read(inode))
 			attr->ia_valid &= ~ATTR_SIZE;
@@ -382,6 +390,7 @@ nfs_setattr(struct dentry *dentry, struct iattr *attr)
 	error = NFS_PROTO(inode)->setattr(dentry, &fattr, attr);
 	if (error == 0)
 		nfs_refresh_inode(inode, &fattr);
+	nfs_fattr_fini(&fattr);
 	return error;
 }
 
@@ -674,6 +683,14 @@ __nfs_revalidate_inode(struct nfs_server *server, struct inode *inode)
 		goto out;
 
 	nfs_inc_stats(inode, NFSIOS_INODEREVALIDATE);
+
+	memset(&fattr, 0, sizeof(struct nfs_fattr));
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (nfs_server_capable(inode, NFS_CAP_SECURITY_LABEL))
+		status = nfs_fattr_alloc(&fattr, GFP_KERNEL);
+	if (status < 0)
+		goto out;
+#endif
 	status = NFS_PROTO(inode)->getattr(server, NFS_FH(inode), &fattr);
 	if (status != 0) {
 		dfprintk(PAGECACHE, "nfs_revalidate_inode: (%s/%Ld) getattr failed, error=%d\n",
@@ -703,6 +720,7 @@ __nfs_revalidate_inode(struct nfs_server *server, struct inode *inode)
 		(long long)NFS_FILEID(inode));
 
  out:
+	nfs_fattr_fini(&fattr);
 	return status;
 }
 
diff --git a/fs/nfs/namespace.c b/fs/nfs/namespace.c
index 64a288e..6ca294a 100644
--- a/fs/nfs/namespace.c
+++ b/fs/nfs/namespace.c
@@ -109,6 +109,8 @@ static void * nfs_follow_mountpoint(struct dentry *dentry, struct nameidata *nd)
 	if (IS_ROOT(dentry))
 		goto out_err;
 
+	memset(&fattr, 0, sizeof(struct nfs_fattr));
+
 	dprintk("%s: enter\n", __func__);
 	dput(nd->path.dentry);
 	nd->path.dentry = dget(dentry);
@@ -145,6 +147,7 @@ static void * nfs_follow_mountpoint(struct dentry *dentry, struct nameidata *nd)
 	nd->path.dentry = dget(mnt->mnt_root);
 	schedule_delayed_work(&nfs_automount_task, nfs_mountpoint_expiry_timeout);
 out:
+	nfs_fattr_fini(&fattr);
 	dprintk("%s: done, returned %d\n", __func__, err);
 
 	dprintk("<-- nfs_follow_mountpoint() = %d\n", err);
diff --git a/fs/nfs/nfs3proc.c b/fs/nfs/nfs3proc.c
index c55be7a..fd86215 100644
--- a/fs/nfs/nfs3proc.c
+++ b/fs/nfs/nfs3proc.c
@@ -294,6 +294,9 @@ static int nfs3_do_create(struct inode *dir, struct dentry *dentry, struct nfs3_
 
 static void nfs3_free_createdata(struct nfs3_createdata *data)
 {
+
+	nfs_fattr_fini(data->res.fattr);
+	nfs_fattr_fini(data->res.dir_attr);
 	kfree(data);
 }
 
@@ -420,6 +423,7 @@ nfs3_proc_unlink_done(struct rpc_task *task, struct inode *dir)
 		return 0;
 	res = task->tk_msg.rpc_resp;
 	nfs_post_op_update_inode(dir, &res->dir_attr);
+	nfs_fattr_fini(&res->dir_attr);
 	return 1;
 }
 
@@ -618,6 +622,9 @@ nfs3_proc_readdir(struct dentry *dentry, struct rpc_cred *cred,
 	dprintk("NFS call  readdir%s %d\n",
 			plus? "plus" : "", (unsigned int) cookie);
 
+
+	memset(&dir_attr, 0, sizeof(struct nfs_fattr));
+
 	nfs_fattr_init(&dir_attr);
 	status = rpc_call_sync(NFS_CLIENT(dir), &msg, 0);
 
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 83e700a..3a0d25f 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -243,6 +243,8 @@ static void nfs4_init_opendata_res(struct nfs4_opendata *p)
 	p->o_res.seqid = p->o_arg.seqid;
 	p->c_res.seqid = p->c_arg.seqid;
 	p->o_res.server = p->o_arg.server;
+	memset(&p->f_attr, 0, sizeof(struct nfs_fattr));
+	memset(&p->dir_attr, 0, sizeof(struct nfs_fattr));
 	nfs_fattr_init(&p->f_attr);
 	nfs_fattr_init(&p->dir_attr);
 }
@@ -288,6 +290,17 @@ static struct nfs4_opendata *nfs4_opendata_alloc(struct path *path,
 	p->c_arg.seqid = p->o_arg.seqid;
 	nfs4_init_opendata_res(p);
 	kref_init(&p->kref);
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (server->caps & NFS_CAP_SECURITY_LABEL) {
+		if (nfs_fattr_alloc(&p->f_attr, GFP_KERNEL) < 0)
+			goto err_free;
+		if (nfs_fattr_alloc(&p->dir_attr, GFP_KERNEL) < 0) {
+			nfs_fattr_fini(&p->f_attr);
+			goto err_free;
+		}
+	}
+#endif
+
 	return p;
 err_free:
 	kfree(p);
@@ -304,6 +317,8 @@ static void nfs4_opendata_free(struct kref *kref)
 	nfs_free_seqid(p->o_arg.seqid);
 	if (p->state != NULL)
 		nfs4_put_open_state(p->state);
+	nfs_fattr_fini(&p->f_attr);
+	nfs_fattr_fini(&p->dir_attr);
 	nfs4_put_state_owner(p->owner);
 	dput(p->dir);
 	path_put(&p->path);
@@ -1210,6 +1225,7 @@ static void nfs4_free_closedata(void *data)
 	nfs_free_seqid(calldata->arg.seqid);
 	nfs4_put_state_owner(sp);
 	path_put(&calldata->path);
+	nfs_fattr_fini(&calldata->fattr);
 	kfree(calldata);
 }
 
@@ -1317,9 +1333,15 @@ int nfs4_do_close(struct path *path, struct nfs4_state *state, int wait)
 	};
 	int status = -ENOMEM;
 
-	calldata = kmalloc(sizeof(*calldata), GFP_KERNEL);
+	calldata = kzalloc(sizeof(*calldata), GFP_KERNEL);
 	if (calldata == NULL)
 		goto out;
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (server->caps & NFS_CAP_SECURITY_LABEL)
+		status = nfs_fattr_alloc(&calldata->fattr, GFP_KERNEL);
+	if (status < 0)
+		goto out;
+#endif
 	calldata->inode = state->inode;
 	calldata->state = state;
 	calldata->arg.fh = NFS_FH(state->inode);
@@ -1347,6 +1369,7 @@ int nfs4_do_close(struct path *path, struct nfs4_state *state, int wait)
 	rpc_put_task(task);
 	return status;
 out_free_calldata:
+	nfs_fattr_fini(&calldata->fattr);
 	kfree(calldata);
 out:
 	nfs4_put_open_state(state);
@@ -1762,7 +1785,9 @@ static int _nfs4_proc_access(struct inode *inode, struct nfs_access_entry *entry
 		.rpc_cred = entry->cred,
 	};
 	int mode = entry->mask;
-	int status;
+	int status = 0;
+
+	memset(&fattr, 0, sizeof(struct nfs_fattr));
 
 	/*
 	 * Determine which access bits we want to ask for...
@@ -1780,6 +1805,12 @@ static int _nfs4_proc_access(struct inode *inode, struct nfs_access_entry *entry
 		if (mode & MAY_EXEC)
 			args.access |= NFS4_ACCESS_EXECUTE;
 	}
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (server->caps & NFS_CAP_SECURITY_LABEL)
+		status = nfs_fattr_alloc(&fattr, GFP_KERNEL);
+	if (status < 0)
+		return status;
+#endif
 	nfs_fattr_init(&fattr);
 	status = rpc_call_sync(NFS_CLIENT(inode), &msg, 0);
 	if (!status) {
@@ -1792,6 +1823,7 @@ static int _nfs4_proc_access(struct inode *inode, struct nfs_access_entry *entry
 			entry->mask |= MAY_EXEC;
 		nfs_refresh_inode(inode, &fattr);
 	}
+	nfs_fattr_fini(&fattr);
 	return status;
 }
 
@@ -1904,10 +1936,20 @@ nfs4_proc_create(struct inode *dir, struct dentry *dentry, struct iattr *sattr,
 	nfs_set_verifier(dentry, nfs_save_change_attribute(dir));
 	if (flags & O_EXCL) {
 		struct nfs_fattr fattr;
+		memset(&fattr, 0, sizeof(struct nfs_fattr));
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+		//XXX: Should we d_drop the dentry?
+		memset(&fattr, 0, sizeof(struct nfs_fattr));
+		if (nfs_server_capable(state->inode, NFS_CAP_SECURITY_LABEL))
+			status = nfs_fattr_alloc(&fattr, GFP_KERNEL);
+		if (status < 0)
+			goto out;
+#endif
 		status = nfs4_do_setattr(state->inode, cred, &fattr, sattr, state);
 		if (status == 0)
 			nfs_setattr_update_inode(state->inode, sattr);
 		nfs_post_op_update_inode(state->inode, &fattr);
+		nfs_fattr_fini(&fattr);
 	}
 	if (status == 0 && (nd->flags & LOOKUP_OPEN) != 0)
 		status = nfs4_intent_set_file(nd, &path, state);
@@ -1936,14 +1978,22 @@ static int _nfs4_proc_remove(struct inode *dir, struct qstr *name)
 		.rpc_argp = &args,
 		.rpc_resp = &res,
 	};
-	int			status;
+	int status = 0;
 
+	memset(&res.dir_attr, 0, sizeof(struct nfs_fattr));
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (server->caps & NFS_CAP_SECURITY_LABEL)
+		status = nfs_fattr_alloc(&res.dir_attr, GFP_KERNEL);
+	if (status < 0)
+		return status;
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
 
@@ -1968,6 +2018,13 @@ static void nfs4_proc_unlink_setup(struct rpc_message *msg, struct inode *dir)
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
@@ -1978,6 +2035,7 @@ static int nfs4_proc_unlink_done(struct rpc_task *task, struct inode *dir)
 		return 0;
 	update_changeattr(dir, &res->cinfo);
 	nfs_post_op_update_inode(dir, &res->dir_attr);
+	nfs_fattr_fini(&res->dir_attr);
 	return 1;
 }
 
@@ -2003,8 +2061,21 @@ static int _nfs4_proc_rename(struct inode *old_dir, struct qstr *old_name,
 		.rpc_argp = &arg,
 		.rpc_resp = &res,
 	};
-	int			status;
-	
+	int status = 0;
+
+	memset(&old_fattr, 0, sizeof(struct nfs_fattr));
+	memset(&new_fattr, 0, sizeof(struct nfs_fattr));
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (server->caps & NFS_CAP_SECURITY_LABEL) {
+		status = nfs_fattr_alloc(&old_fattr, GFP_KERNEL);
+		if (status < 0)
+			goto out;
+		status = nfs_fattr_alloc(&new_fattr, GFP_KERNEL);
+		if (status < 0)
+			goto out;
+	}
+#endif
+
 	nfs_fattr_init(res.old_fattr);
 	nfs_fattr_init(res.new_fattr);
 	status = rpc_call_sync(server->client, &msg, 0);
@@ -2015,6 +2086,9 @@ static int _nfs4_proc_rename(struct inode *old_dir, struct qstr *old_name,
 		update_changeattr(new_dir, &res.new_cinfo);
 		nfs_post_op_update_inode(new_dir, res.new_fattr);
 	}
+out:
+	nfs_fattr_fini(&old_fattr);
+	nfs_fattr_fini(&new_fattr);
 	return status;
 }
 
@@ -2052,7 +2126,20 @@ static int _nfs4_proc_link(struct inode *inode, struct inode *dir, struct qstr *
 		.rpc_argp = &arg,
 		.rpc_resp = &res,
 	};
-	int			status;
+	int status = 0;
+
+	memset(&fattr, 0, sizeof(struct nfs_fattr));
+	memset(&dir_attr, 0, sizeof(struct nfs_fattr));
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (server->caps & NFS_CAP_SECURITY_LABEL) {
+		status = nfs_fattr_alloc(&fattr, GFP_KERNEL);
+		if (status < 0)
+			goto out;
+		status = nfs_fattr_alloc(&dir_attr, GFP_KERNEL);
+		if (status < 0)
+			goto out;
+	}
+#endif
 
 	nfs_fattr_init(res.fattr);
 	nfs_fattr_init(res.dir_attr);
@@ -2062,7 +2149,9 @@ static int _nfs4_proc_link(struct inode *inode, struct inode *dir, struct qstr *
 		nfs_post_op_update_inode(dir, res.dir_attr);
 		nfs_post_op_update_inode(inode, res.fattr);
 	}
-
+out:
+	nfs_fattr_fini(&fattr);
+	nfs_fattr_fini(&dir_attr);
 	return status;
 }
 
@@ -2091,6 +2180,7 @@ static struct nfs4_createdata *nfs4_alloc_createdata(struct inode *dir,
 		struct qstr *name, struct iattr *sattr, u32 ftype)
 {
 	struct nfs4_createdata *data;
+	int status;
 
 	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (data != NULL) {
@@ -2109,10 +2199,27 @@ static struct nfs4_createdata *nfs4_alloc_createdata(struct inode *dir,
 		data->res.fh = &data->fh;
 		data->res.fattr = &data->fattr;
 		data->res.dir_fattr = &data->dir_fattr;
+		memset(&data->fattr, 0, sizeof(struct nfs_fattr));
+		memset(&data->dir_fattr, 0, sizeof(struct nfs_fattr));
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+		if (server->caps & NFS_CAP_SECURITY_LABEL) {
+			status = nfs_fattr_alloc(&data->fattr, GFP_KERNEL);
+			if (status < 0)
+				goto out_free;
+			status = nfs_fattr_alloc(&data->dir_fattr, GFP_KERNEL);
+			if (status < 0) {
+				nfs_fattr_fini(&data->fattr);
+				goto out_free;
+			}
+		}
+#endif
 		nfs_fattr_init(data->res.fattr);
 		nfs_fattr_init(data->res.dir_fattr);
 	}
 	return data;
+out_free:
+	kfree(data);
+	return NULL;
 }
 
 static int nfs4_do_create(struct inode *dir, struct dentry *dentry, struct nfs4_createdata *data)
@@ -2128,6 +2235,8 @@ static int nfs4_do_create(struct inode *dir, struct dentry *dentry, struct nfs4_
 
 static void nfs4_free_createdata(struct nfs4_createdata *data)
 {
+	nfs_fattr_fini(&data->fattr);
+	nfs_fattr_fini(&data->dir_fattr);
 	kfree(data);
 }
 
@@ -2960,6 +3069,9 @@ static void nfs4_delegreturn_done(struct rpc_task *task, void *calldata)
 
 static void nfs4_delegreturn_release(void *calldata)
 {
+	struct nfs4_delegreturndata *data = calldata;
+
+	nfs_fattr_fini(data->res.fattr);
 	kfree(calldata);
 }
 
@@ -2985,7 +3097,7 @@ static int _nfs4_proc_delegreturn(struct inode *inode, struct rpc_cred *cred, co
 	};
 	int status = 0;
 
-	data = kmalloc(sizeof(*data), GFP_KERNEL);
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (data == NULL)
 		return -ENOMEM;
 	data->args.fhandle = &data->fh;
@@ -2999,6 +3111,13 @@ static int _nfs4_proc_delegreturn(struct inode *inode, struct rpc_cred *cred, co
 	data->timestamp = jiffies;
 	data->rpc_status = 0;
 
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (server->caps & NFS_CAP_SECURITY_LABEL)
+		status = nfs_fattr_alloc(&data->fattr, GFP_KERNEL);
+	if (status < 0)
+		goto out_free;
+#endif
+
 	task_setup_data.callback_data = data;
 	msg.rpc_argp = &data->args,
 	msg.rpc_resp = &data->res,
@@ -3017,6 +3136,9 @@ static int _nfs4_proc_delegreturn(struct inode *inode, struct rpc_cred *cred, co
 out:
 	rpc_put_task(task);
 	return status;
+out_free:
+	kfree(data);
+	return status;
 }
 
 int nfs4_proc_delegreturn(struct inode *inode, struct rpc_cred *cred, const nfs4_stateid *stateid, int issync)
diff --git a/fs/nfs/proc.c b/fs/nfs/proc.c
index 1934652..9b0e36e 100644
--- a/fs/nfs/proc.c
+++ b/fs/nfs/proc.c
@@ -216,12 +216,14 @@ nfs_proc_create(struct inode *dir, struct dentry *dentry, struct iattr *sattr,
 	};
 	int			status;
 
-	nfs_fattr_init(&fattr);
 	dprintk("NFS call  create %s\n", dentry->d_name.name);
 	status = rpc_call_sync(NFS_CLIENT(dir), &msg, 0);
+	memset(&fattr, 0, sizeof(struct nfs_fattr));
+	nfs_fattr_init(&fattr);
 	nfs_mark_for_revalidate(dir);
 	if (status == 0)
 		status = nfs_instantiate(dentry, &fhandle, &fattr);
+	nfs_fattr_fini(&fattr);
 	dprintk("NFS reply create: %d\n", status);
 	return status;
 }
@@ -263,6 +265,7 @@ nfs_proc_mknod(struct inode *dir, struct dentry *dentry, struct iattr *sattr,
 		sattr->ia_size = new_encode_dev(rdev);/* get out your barf bag */
 	}
 
+	memset(&fattr, 0, sizeof(struct nfs_fattr));
 	nfs_fattr_init(&fattr);
 	status = rpc_call_sync(NFS_CLIENT(dir), &msg, 0);
 	nfs_mark_for_revalidate(dir);
@@ -274,6 +277,7 @@ nfs_proc_mknod(struct inode *dir, struct dentry *dentry, struct iattr *sattr,
 	}
 	if (status == 0)
 		status = nfs_instantiate(dentry, &fhandle, &fattr);
+	nfs_fattr_fini(&fattr);
 	dprintk("NFS reply mknod: %d\n", status);
 	return status;
 }
@@ -386,6 +390,8 @@ nfs_proc_symlink(struct inode *dir, struct dentry *dentry, struct page *page,
 
 	dprintk("NFS call  symlink %s\n", dentry->d_name.name);
 
+	memset(&fattr, 0, sizeof(struct nfs_fattr));
+
 	status = rpc_call_sync(NFS_CLIENT(dir), &msg, 0);
 	nfs_mark_for_revalidate(dir);
 
@@ -400,6 +406,7 @@ nfs_proc_symlink(struct inode *dir, struct dentry *dentry, struct page *page,
 		status = nfs_instantiate(dentry, &fhandle, &fattr);
 	}
 
+	nfs_fattr_fini(&fattr);
 	dprintk("NFS reply symlink: %d\n", status);
 	return status;
 }
@@ -427,11 +434,14 @@ nfs_proc_mkdir(struct inode *dir, struct dentry *dentry, struct iattr *sattr)
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
index 9b89a4b..ab071e1 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -388,6 +388,8 @@ static int nfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	};
 	int error;
 
+	memset(&fattr, 0, sizeof(struct nfs_fattr));
+
 	error = server->nfs_client->rpc_ops->statfs(server, fh, &res);
 	if (error < 0)
 		goto out_err;
@@ -419,10 +421,12 @@ static int nfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 
 	buf->f_namelen = server->namelen;
 
+	nfs_fattr_fini(&fattr);
 	return 0;
 
  out_err:
 	dprintk("%s: statfs error = %d\n", __func__, -error);
+	nfs_fattr_fini(&fattr);
 	return error;
 }
 
diff --git a/fs/nfs/unlink.c b/fs/nfs/unlink.c
index ecc2953..2bdcc76 100644
--- a/fs/nfs/unlink.c
+++ b/fs/nfs/unlink.c
@@ -123,11 +123,10 @@ static int nfs_do_call_unlink(struct dentry *parent, struct inode *dir, struct n
 	};
 	struct rpc_task *task;
 	struct dentry *alias;
+	int ret = 0;
 
 	alias = d_lookup(parent, &data->args.name);
 	if (alias != NULL) {
-		int ret = 0;
-
 		/*
 		 * Hey, we raced with lookup... See if we need to transfer
 		 * the sillyrename information to the aliased dentry.
@@ -150,9 +149,16 @@ static int nfs_do_call_unlink(struct dentry *parent, struct inode *dir, struct n
 		nfs_dec_sillycount(dir);
 		return 0;
 	}
+	memset(&data->res.dir_attr, 0, sizeof(struct nfs_fattr));
+	nfs_fattr_init(&data->res.dir_attr);
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (NFS_SERVER(dir)->caps & NFS_CAP_SECURITY_LABEL)
+		ret = nfs_fattr_alloc(&data->res.dir_attr, GFP_KERNEL);
+	if (ret < 0)
+		return ret;
+#endif
 	nfs_sb_active(dir->i_sb);
 	data->args.fh = NFS_FH(dir);
-	nfs_fattr_init(&data->res.dir_attr);
 
 	NFS_PROTO(dir)->unlink_setup(&msg, dir);
 
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index 4eaa834..6120a28 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -59,6 +59,7 @@
 #include <linux/nfs_fs_sb.h>
 
 #include <linux/mempool.h>
+#include <linux/security.h>
 
 /*
  * These are the default flags for swap requests
@@ -350,6 +351,29 @@ extern void nfs_fattr_init(struct nfs_fattr *fattr);
 extern __be32 root_nfs_parse_addr(char *name); /*__init*/
 extern unsigned long nfs_inc_attr_generation_counter(void);
 
+#ifdef CONFIG_SECURITY
+
+static inline int nfs_fattr_alloc(struct nfs_fattr *fattr, gfp_t flags)
+{
+	fattr->label = kzalloc(NFS4_MAXLABELLEN, flags);
+	if (fattr->label == NULL)
+		return -ENOMEM;
+	fattr->label_len = NFS4_MAXLABELLEN;
+	return 0;
+}
+
+static inline void nfs_fattr_fini(struct nfs_fattr *fattr)
+{
+	security_release_secctx(fattr->label, fattr->label_len);
+	fattr->label = NULL;
+	fattr->label_len = 0;
+}
+
+#else
+static inline int nfs_fattr_alloc(struct nfs_fattr *fattr, gfp_t flags) {}
+static inline void nfs_fattr_fini(struct nfs_fattr *fattr) {}
+#endif
+
 /*
  * linux/fs/nfs/file.c
  */
-- 
1.5.5.1

