Return-Path: <linux-kernel-owner+w=401wt.eu-S1757554AbYIOVKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757554AbYIOVKl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 17:10:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756646AbYIOVGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 17:06:51 -0400
Received: from mummy.ncsc.mil ([144.51.88.129]:64423 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755142AbYIOVG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 17:06:28 -0400
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: hch@infradead.org, viro@zeniv.linux.org.uk, casey@schaufler-ca.com,
       sds@tycho.nsa.gov, matthew.dodd@sparta.com, trond.myklebust@fys.uio.no,
       bfields@fieldses.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       "David P. Quigley" <dpquigl@tycho.nsa.gov>,
       "Matthew N. Dodd" <Matthew.Dodd@sparta.com>
Subject: [PATCH 09/14] NFS: Introduce lifecycle management for label attribute.
Date: Mon, 15 Sep 2008 16:41:13 -0400
Message-Id: <1221511278-28051-10-git-send-email-dpquigl@tycho.nsa.gov>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1221511278-28051-1-git-send-email-dpquigl@tycho.nsa.gov>
References: <1221511278-28051-1-git-send-email-dpquigl@tycho.nsa.gov>
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
 fs/nfs/client.c        |   18 +++++++++-
 fs/nfs/dir.c           |   24 +++++++++++++
 fs/nfs/getroot.c       |   35 ++++++++++++++++++-
 fs/nfs/inode.c         |   16 +++++++++
 fs/nfs/namespace.c     |    3 ++
 fs/nfs/nfs3proc.c      |    7 ++++
 fs/nfs/nfs4proc.c      |   88 ++++++++++++++++++++++++++++++++++++++++++++++-
 fs/nfs/proc.c          |   12 ++++++-
 fs/nfs/super.c         |    4 ++
 include/linux/nfs_fs.h |   46 +++++++++++++++++++++++++
 10 files changed, 248 insertions(+), 5 deletions(-)

diff --git a/fs/nfs/client.c b/fs/nfs/client.c
index 5ee23e7..756d554 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -902,6 +902,8 @@ struct nfs_server *nfs_create_server(const struct nfs_parsed_mount_data *data,
 	struct nfs_fattr fattr;
 	int error;
 
+	memset(&fattr, 0, sizeof(struct nfs_fattr));
+
 	server = nfs_alloc_server();
 	if (!server)
 		return ERR_PTR(-ENOMEM);
@@ -952,10 +954,12 @@ struct nfs_server *nfs_create_server(const struct nfs_parsed_mount_data *data,
 	spin_unlock(&nfs_client_lock);
 
 	server->mount_time = jiffies;
+	nfs_fattr_fini(&fattr);
 	return server;
 
 error:
 	nfs_free_server(server);
+	nfs_fattr_fini(&fattr);
 	return ERR_PTR(error);
 }
 
@@ -1073,7 +1077,7 @@ static int nfs4_init_server(struct nfs_server *server,
 		goto error;
 
 	/* Initialise the client representation from the mount data */
-	server->flags = data->flags & NFS_MOUNT_FLAGMASK;
+	server->flags = data->flags & NFS4_MOUNT_FLAGMASK;
 	server->caps |= NFS_CAP_ATOMIC_OPEN;
 
 	if (data->rsize)
@@ -1109,6 +1113,8 @@ struct nfs_server *nfs4_create_server(const struct nfs_parsed_mount_data *data,
 
 	dprintk("--> nfs4_create_server()\n");
 
+	memset(&fattr, 0, sizeof(struct nfs_fattr));
+
 	server = nfs_alloc_server();
 	if (!server)
 		return ERR_PTR(-ENOMEM);
@@ -1149,11 +1155,13 @@ struct nfs_server *nfs4_create_server(const struct nfs_parsed_mount_data *data,
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
@@ -1171,6 +1179,8 @@ struct nfs_server *nfs4_create_referral_server(struct nfs_clone_mount *data,
 
 	dprintk("--> nfs4_create_referral_server()\n");
 
+	memset(&fattr, 0, sizeof(struct nfs_fattr));
+
 	server = nfs_alloc_server();
 	if (!server)
 		return ERR_PTR(-ENOMEM);
@@ -1227,10 +1237,12 @@ struct nfs_server *nfs4_create_referral_server(struct nfs_clone_mount *data,
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
@@ -1252,6 +1264,8 @@ struct nfs_server *nfs_clone_server(struct nfs_server *source,
 		(unsigned long long) fattr->fsid.major,
 		(unsigned long long) fattr->fsid.minor);
 
+	memset(&fattr_fsinfo, 0, sizeof(struct nfs_fattr));
+
 	server = nfs_alloc_server();
 	if (!server)
 		return ERR_PTR(-ENOMEM);
@@ -1294,11 +1308,13 @@ struct nfs_server *nfs_clone_server(struct nfs_server *source,
 
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
index 74f92b7..db43b69 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -551,6 +551,7 @@ static int nfs_readdir(struct file *filp, void *dirent, filldir_t filldir)
 	my_entry.eof = 0;
 	my_entry.fh = &fh;
 	my_entry.fattr = &fattr;
+	memset(&fattr, 0, sizeof(struct nfs_fattr));
 	nfs_fattr_init(&fattr);
 	desc->entry = &my_entry;
 
@@ -588,6 +589,7 @@ static int nfs_readdir(struct file *filp, void *dirent, filldir_t filldir)
 			res = 0;
 			break;
 		}
+		nfs_fattr_fini(&fattr);
 	}
 out:
 	nfs_unblock_sillyrename(dentry);
@@ -773,6 +775,8 @@ static int nfs_lookup_revalidate(struct dentry * dentry, struct nameidata *nd)
 	struct nfs_fh fhandle;
 	struct nfs_fattr fattr;
 
+	memset(&fattr, 0, sizeof(struct nfs_fattr));
+
 	parent = dget_parent(dentry);
 	dir = parent->d_inode;
 	nfs_inc_stats(dir, NFSIOS_DENTRYREVALIDATE);
@@ -801,6 +805,11 @@ static int nfs_lookup_revalidate(struct dentry * dentry, struct nameidata *nd)
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
@@ -812,6 +821,7 @@ static int nfs_lookup_revalidate(struct dentry * dentry, struct nameidata *nd)
 	nfs_set_verifier(dentry, nfs_save_change_attribute(dir));
  out_valid:
 	dput(parent);
+	nfs_fattr_fini(&fattr);
 	dfprintk(LOOKUPCACHE, "NFS: %s(%s/%s) is valid\n",
 			__func__, dentry->d_parent->d_name.name,
 			dentry->d_name.name);
@@ -830,6 +840,7 @@ out_zap_parent:
 	}
 	d_drop(dentry);
 	dput(parent);
+	nfs_fattr_fini(&fattr);
 	dfprintk(LOOKUPCACHE, "NFS: %s(%s/%s) is invalid\n",
 			__func__, dentry->d_parent->d_name.name,
 			dentry->d_name.name);
@@ -906,6 +917,8 @@ static struct dentry *nfs_lookup(struct inode *dir, struct dentry * dentry, stru
 		dentry->d_parent->d_name.name, dentry->d_name.name);
 	nfs_inc_stats(dir, NFSIOS_VFSLOOKUP);
 
+	memset(&fattr, 0, sizeof(struct nfs_fattr));
+
 	res = ERR_PTR(-ENAMETOOLONG);
 	if (dentry->d_name.len > NFS_SERVER(dir)->namelen)
 		goto out;
@@ -923,6 +936,11 @@ static struct dentry *nfs_lookup(struct inode *dir, struct dentry * dentry, stru
 		goto out;
 	}
 
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (nfs_server_capable(dir, NFS_CAP_SECURITY_LABEL))
+		nfs_fattr_alloc(&fattr, GFP_NOWAIT);
+#endif
+
 	parent = dentry->d_parent;
 	/* Protect against concurrent sillydeletes */
 	nfs_block_sillyrename(parent);
@@ -949,6 +967,8 @@ no_entry:
 out_unblock_sillyrename:
 	nfs_unblock_sillyrename(parent);
 out:
+	/* Label will give 'unused' warning on 'no_entry' case. */
+	nfs_fattr_fini(&fattr);
 	return res;
 }
 
@@ -1214,6 +1234,7 @@ static int nfs_create(struct inode *dir, struct dentry *dentry, int mode,
 	dfprintk(VFS, "NFS: create(%s/%ld), %s\n",
 			dir->i_sb->s_id, dir->i_ino, dentry->d_name.name);
 
+	memset(&attr, 0, sizeof(struct iattr));
 	attr.ia_mode = mode;
 	attr.ia_valid = ATTR_MODE;
 
@@ -1244,6 +1265,7 @@ nfs_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t rdev)
 	if (!new_valid_dev(rdev))
 		return -EINVAL;
 
+	memset(&attr, 0, sizeof(struct iattr));
 	attr.ia_mode = mode;
 	attr.ia_valid = ATTR_MODE;
 
@@ -1267,6 +1289,7 @@ static int nfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 	dfprintk(VFS, "NFS: mkdir(%s/%ld), %s\n",
 			dir->i_sb->s_id, dir->i_ino, dentry->d_name.name);
 
+	memset(&attr, 0, sizeof(struct iattr));
 	attr.ia_valid = ATTR_MODE;
 	attr.ia_mode = mode | S_IFDIR;
 
@@ -1476,6 +1499,7 @@ static int nfs_symlink(struct inode *dir, struct dentry *dentry, const char *sym
 	if (pathlen > PAGE_SIZE)
 		return -ENAMETOOLONG;
 
+	memset(&attr, 0, sizeof(struct iattr));
 	attr.ia_mode = S_IFLNK | S_IRWXUGO;
 	attr.ia_valid = ATTR_MODE;
 
diff --git a/fs/nfs/getroot.c b/fs/nfs/getroot.c
index fae9719..bc23077 100644
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
 
@@ -119,6 +120,7 @@ struct dentry *nfs_get_root(struct super_block *sb, struct nfs_fh *mntfh)
 	if (!mntroot->d_op)
 		mntroot->d_op = server->nfs_client->rpc_ops->dentry_ops;
 
+	nfs_fattr_fini(&fattr);
 	return mntroot;
 }
 
@@ -143,6 +145,12 @@ int nfs4_path_walk(struct nfs_server *server,
 
 	dprintk("--> nfs4_path_walk(,,%s)\n", path);
 
+	memset(&fattr, 0, sizeof(struct nfs_fattr));
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	/* Unconditional, no server caps yet. */
+	nfs_fattr_alloc(&fattr, GFP_KERNEL);
+#endif
+
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
@@ -256,19 +279,29 @@ struct dentry *nfs4_get_root(struct super_block *sb, struct nfs_fh *mntfh)
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
index 52daefa..40d7142 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -360,6 +360,12 @@ nfs_setattr(struct dentry *dentry, struct iattr *attr)
 	if (attr->ia_valid & (ATTR_KILL_SUID | ATTR_KILL_SGID))
 		attr->ia_valid &= ~ATTR_MODE;
 
+	memset(&fattr, 0, sizeof(struct nfs_fattr));
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (nfs_server_capable(inode, NFS_CAP_SECURITY_LABEL))
+		nfs_fattr_alloc(&fattr, GFP_KERNEL);
+#endif
+
 	if (attr->ia_valid & ATTR_SIZE) {
 		if (!S_ISREG(inode->i_mode) || attr->ia_size == i_size_read(inode))
 			attr->ia_valid &= ~ATTR_SIZE;
@@ -383,6 +389,7 @@ nfs_setattr(struct dentry *dentry, struct iattr *attr)
 	error = NFS_PROTO(inode)->setattr(dentry, &fattr, attr);
 	if (error == 0)
 		nfs_refresh_inode(inode, &fattr);
+	nfs_fattr_fini(&fattr);
 	return error;
 }
 
@@ -698,6 +705,9 @@ __nfs_revalidate_inode(struct nfs_server *server, struct inode *inode)
 		inode->i_sb->s_id, (long long)NFS_FILEID(inode));
 
 	nfs_inc_stats(inode, NFSIOS_INODEREVALIDATE);
+	
+	memset(&fattr, 0, sizeof(struct nfs_fattr));
+	
 	if (is_bad_inode(inode))
  		goto out_nowait;
 	if (NFS_STALE(inode))
@@ -711,6 +721,11 @@ __nfs_revalidate_inode(struct nfs_server *server, struct inode *inode)
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
@@ -746,6 +761,7 @@ __nfs_revalidate_inode(struct nfs_server *server, struct inode *inode)
 	nfs_wake_up_inode(inode);
 
  out_nowait:
+	nfs_fattr_fini(&fattr);
 	return status;
 }
 
diff --git a/fs/nfs/namespace.c b/fs/nfs/namespace.c
index 66df08d..a20b428 100644
--- a/fs/nfs/namespace.c
+++ b/fs/nfs/namespace.c
@@ -105,6 +105,8 @@ static void * nfs_follow_mountpoint(struct dentry *dentry, struct nameidata *nd)
 
 	dprintk("--> nfs_follow_mountpoint()\n");
 
+	memset(&fattr, 0, sizeof(struct nfs_fattr));
+
 	BUG_ON(IS_ROOT(dentry));
 	dprintk("%s: enter\n", __func__);
 	dput(nd->path.dentry);
@@ -142,6 +144,7 @@ static void * nfs_follow_mountpoint(struct dentry *dentry, struct nameidata *nd)
 	nd->path.dentry = dget(mnt->mnt_root);
 	schedule_delayed_work(&nfs_automount_task, nfs_mountpoint_expiry_timeout);
 out:
+	nfs_fattr_fini(&fattr);
 	dprintk("%s: done, returned %d\n", __func__, err);
 
 	dprintk("<-- nfs_follow_mountpoint() = %d\n", err);
diff --git a/fs/nfs/nfs3proc.c b/fs/nfs/nfs3proc.c
index 1e750e4..c49a2aa 100644
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
index c910413..c4a4271 100644
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
@@ -288,6 +290,13 @@ static struct nfs4_opendata *nfs4_opendata_alloc(struct path *path,
 	p->c_arg.seqid = p->o_arg.seqid;
 	nfs4_init_opendata_res(p);
 	kref_init(&p->kref);
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (server->caps & NFS_CAP_SECURITY_LABEL) {
+		nfs_fattr_alloc(&p->f_attr, GFP_KERNEL);
+		nfs_fattr_alloc(&p->dir_attr, GFP_KERNEL);
+	}
+#endif
+
 	return p;
 err_free:
 	kfree(p);
@@ -304,6 +313,8 @@ static void nfs4_opendata_free(struct kref *kref)
 	nfs_free_seqid(p->o_arg.seqid);
 	if (p->state != NULL)
 		nfs4_put_open_state(p->state);
+	nfs_fattr_fini(&p->f_attr);
+	nfs_fattr_fini(&p->dir_attr);
 	nfs4_put_state_owner(p->owner);
 	dput(p->dir);
 	path_put(&p->path);
@@ -1210,6 +1221,7 @@ static void nfs4_free_closedata(void *data)
 	nfs_free_seqid(calldata->arg.seqid);
 	nfs4_put_state_owner(sp);
 	path_put(&calldata->path);
+	nfs_fattr_fini(&calldata->fattr);
 	kfree(calldata);
 }
 
@@ -1317,7 +1329,7 @@ int nfs4_do_close(struct path *path, struct nfs4_state *state, int wait)
 	};
 	int status = -ENOMEM;
 
-	calldata = kmalloc(sizeof(*calldata), GFP_KERNEL);
+	calldata = kzalloc(sizeof(*calldata), GFP_KERNEL);
 	if (calldata == NULL)
 		goto out;
 	calldata->inode = state->inode;
@@ -1335,6 +1347,10 @@ int nfs4_do_close(struct path *path, struct nfs4_state *state, int wait)
 	calldata->path.mnt = mntget(path->mnt);
 	calldata->path.dentry = dget(path->dentry);
 
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (server->caps & NFS_CAP_SECURITY_LABEL)
+		nfs_fattr_alloc(&calldata->fattr, GFP_KERNEL);
+#endif
 	msg.rpc_argp = &calldata->arg,
 	msg.rpc_resp = &calldata->res,
 	task_setup_data.callback_data = calldata;
@@ -1347,6 +1363,7 @@ int nfs4_do_close(struct path *path, struct nfs4_state *state, int wait)
 	rpc_put_task(task);
 	return status;
 out_free_calldata:
+	nfs_fattr_fini(&calldata->fattr);
 	kfree(calldata);
 out:
 	nfs4_put_open_state(state);
@@ -1762,6 +1779,8 @@ static int _nfs4_proc_access(struct inode *inode, struct nfs_access_entry *entry
 	int mode = entry->mask;
 	int status;
 
+	memset(&fattr, 0, sizeof(struct nfs_fattr));
+
 	/*
 	 * Determine which access bits we want to ask for...
 	 */
@@ -1778,6 +1797,10 @@ static int _nfs4_proc_access(struct inode *inode, struct nfs_access_entry *entry
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
@@ -1790,6 +1813,7 @@ static int _nfs4_proc_access(struct inode *inode, struct nfs_access_entry *entry
 			entry->mask |= MAY_EXEC;
 		nfs_refresh_inode(inode, &fattr);
 	}
+	nfs_fattr_fini(&fattr);
 	return status;
 }
 
@@ -1902,10 +1926,16 @@ nfs4_proc_create(struct inode *dir, struct dentry *dentry, struct iattr *sattr,
 	nfs_set_verifier(dentry, nfs_save_change_attribute(dir));
 	if (flags & O_EXCL) {
 		struct nfs_fattr fattr;
+		memset(&fattr, 0, sizeof(struct nfs_fattr));
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+		if (nfs_server_capable(state->inode, NFS_CAP_SECURITY_LABEL))
+			nfs_fattr_alloc(&fattr, GFP_KERNEL);
+#endif
 		status = nfs4_do_setattr(state->inode, cred, &fattr, sattr, state);
 		if (status == 0)
 			nfs_setattr_update_inode(state->inode, sattr);
 		nfs_post_op_update_inode(state->inode, &fattr);
+		nfs_fattr_fini(&fattr);
 	}
 	if (status == 0 && (nd->flags & LOOKUP_OPEN) != 0)
 		status = nfs4_intent_set_file(nd, &path, state);
@@ -1936,12 +1966,18 @@ static int _nfs4_proc_remove(struct inode *dir, struct qstr *name)
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
 
@@ -1966,6 +2002,13 @@ static void nfs4_proc_unlink_setup(struct rpc_message *msg, struct inode *dir)
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
@@ -1976,6 +2019,7 @@ static int nfs4_proc_unlink_done(struct rpc_task *task, struct inode *dir)
 		return 0;
 	update_changeattr(dir, &res->cinfo);
 	nfs_post_op_update_inode(dir, &res->dir_attr);
+	nfs_fattr_fini(&res->dir_attr);
 	return 1;
 }
 
@@ -2003,6 +2047,15 @@ static int _nfs4_proc_rename(struct inode *old_dir, struct qstr *old_name,
 	};
 	int			status;
 	
+	memset(&old_fattr, 0, sizeof(struct nfs_fattr));
+	memset(&new_fattr, 0, sizeof(struct nfs_fattr));
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (server->caps & NFS_CAP_SECURITY_LABEL) {
+		nfs_fattr_alloc(&old_fattr, GFP_KERNEL);
+		nfs_fattr_alloc(&new_fattr, GFP_KERNEL);
+	}
+#endif
+
 	nfs_fattr_init(res.old_fattr);
 	nfs_fattr_init(res.new_fattr);
 	status = rpc_call_sync(server->client, &msg, 0);
@@ -2013,6 +2066,8 @@ static int _nfs4_proc_rename(struct inode *old_dir, struct qstr *old_name,
 		update_changeattr(new_dir, &res.new_cinfo);
 		nfs_post_op_update_inode(new_dir, res.new_fattr);
 	}
+	nfs_fattr_fini(&old_fattr);
+	nfs_fattr_fini(&new_fattr);
 	return status;
 }
 
@@ -2052,6 +2107,15 @@ static int _nfs4_proc_link(struct inode *inode, struct inode *dir, struct qstr *
 	};
 	int			status;
 
+	memset(&fattr, 0, sizeof(struct nfs_fattr));
+	memset(&dir_attr, 0, sizeof(struct nfs_fattr));
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
@@ -2061,6 +2125,8 @@ static int _nfs4_proc_link(struct inode *inode, struct inode *dir, struct qstr *
 		nfs_post_op_update_inode(inode, res.fattr);
 	}
 
+	nfs_fattr_fini(&fattr);
+	nfs_fattr_fini(&dir_attr);
 	return status;
 }
 
@@ -2107,6 +2173,14 @@ static struct nfs4_createdata *nfs4_alloc_createdata(struct inode *dir,
 		data->res.fh = &data->fh;
 		data->res.fattr = &data->fattr;
 		data->res.dir_fattr = &data->dir_fattr;
+		memset(&data->fattr, 0, sizeof(struct nfs_fattr));
+		memset(&data->dir_fattr, 0, sizeof(struct nfs_fattr));
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+		if (server->caps & NFS_CAP_SECURITY_LABEL) {
+			nfs_fattr_alloc(&data->fattr, GFP_KERNEL);
+			nfs_fattr_alloc(&data->dir_fattr, GFP_KERNEL);
+		}
+#endif
 		nfs_fattr_init(data->res.fattr);
 		nfs_fattr_init(data->res.dir_fattr);
 	}
@@ -2126,6 +2200,8 @@ static int nfs4_do_create(struct inode *dir, struct dentry *dentry, struct nfs4_
 
 static void nfs4_free_createdata(struct nfs4_createdata *data)
 {
+	nfs_fattr_fini(&data->fattr);
+	nfs_fattr_fini(&data->dir_fattr);
 	kfree(data);
 }
 
@@ -2958,6 +3034,9 @@ static void nfs4_delegreturn_done(struct rpc_task *task, void *calldata)
 
 static void nfs4_delegreturn_release(void *calldata)
 {
+	struct nfs4_delegreturndata *data = calldata;
+
+	nfs_fattr_fini(data->res.fattr);
 	kfree(calldata);
 }
 
@@ -2983,7 +3062,7 @@ static int _nfs4_proc_delegreturn(struct inode *inode, struct rpc_cred *cred, co
 	};
 	int status = 0;
 
-	data = kmalloc(sizeof(*data), GFP_KERNEL);
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (data == NULL)
 		return -ENOMEM;
 	data->args.fhandle = &data->fh;
@@ -2997,6 +3076,11 @@ static int _nfs4_proc_delegreturn(struct inode *inode, struct rpc_cred *cred, co
 	data->timestamp = jiffies;
 	data->rpc_status = 0;
 
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (server->caps & NFS_CAP_SECURITY_LABEL)
+		nfs_fattr_alloc(&data->fattr, GFP_KERNEL);
+#endif
+
 	task_setup_data.callback_data = data;
 	msg.rpc_argp = &data->args,
 	msg.rpc_resp = &data->res,
diff --git a/fs/nfs/proc.c b/fs/nfs/proc.c
index 4dbb84d..3ff1bdf 100644
--- a/fs/nfs/proc.c
+++ b/fs/nfs/proc.c
@@ -210,12 +210,14 @@ nfs_proc_create(struct inode *dir, struct dentry *dentry, struct iattr *sattr,
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
@@ -257,6 +259,7 @@ nfs_proc_mknod(struct inode *dir, struct dentry *dentry, struct iattr *sattr,
 		sattr->ia_size = new_encode_dev(rdev);/* get out your barf bag */
 	}
 
+	memset(&fattr, 0, sizeof(struct nfs_fattr));
 	nfs_fattr_init(&fattr);
 	status = rpc_call_sync(NFS_CLIENT(dir), &msg, 0);
 	nfs_mark_for_revalidate(dir);
@@ -268,6 +271,7 @@ nfs_proc_mknod(struct inode *dir, struct dentry *dentry, struct iattr *sattr,
 	}
 	if (status == 0)
 		status = nfs_instantiate(dentry, &fhandle, &fattr);
+	nfs_fattr_fini(&fattr);
 	dprintk("NFS reply mknod: %d\n", status);
 	return status;
 }
@@ -380,6 +384,8 @@ nfs_proc_symlink(struct inode *dir, struct dentry *dentry, struct page *page,
 
 	dprintk("NFS call  symlink %s\n", dentry->d_name.name);
 
+	memset(&fattr, 0, sizeof(struct nfs_fattr));
+
 	status = rpc_call_sync(NFS_CLIENT(dir), &msg, 0);
 	nfs_mark_for_revalidate(dir);
 
@@ -394,6 +400,7 @@ nfs_proc_symlink(struct inode *dir, struct dentry *dentry, struct page *page,
 		status = nfs_instantiate(dentry, &fhandle, &fattr);
 	}
 
+	nfs_fattr_fini(&fattr);
 	dprintk("NFS reply symlink: %d\n", status);
 	return status;
 }
@@ -421,11 +428,14 @@ nfs_proc_mkdir(struct inode *dir, struct dentry *dentry, struct iattr *sattr)
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
index 256ce27..81cf6c5 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -377,6 +377,8 @@ static int nfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	};
 	int error;
 
+	memset(&fattr, 0, sizeof(struct nfs_fattr));
+
 	error = server->nfs_client->rpc_ops->statfs(server, fh, &res);
 	if (error < 0)
 		goto out_err;
@@ -408,10 +410,12 @@ static int nfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 
 	buf->f_namelen = server->namelen;
 
+	nfs_fattr_fini(&fattr);
 	return 0;
 
  out_err:
 	dprintk("%s: statfs error = %d\n", __func__, -error);
+	nfs_fattr_fini(&fattr);
 	return error;
 }
 
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index 78a5922..192c056 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -355,6 +355,52 @@ static inline void nfs_fattr_init(struct nfs_fattr *fattr)
 	fattr->time_start = jiffies;
 }
 
+#ifdef CONFIG_SECURITY
+void security_release_secctx(char *secdata, u32 seclen);
+
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
+				  const char *file, int line, const char *func)
+{
+	if ((fattr)->label == NULL) {
+		if (fattr->label_len != 0) {
+			printk(KERN_WARNING
+				"%s:%d %s() nfs_fattr label available (%d)\n",
+				file, line, func,
+				fattr->label_len);
+		}
+	} else {
+		if (fattr->label_len == NFS4_MAXLABELLEN)
+			printk(KERN_WARNING
+				"%s:%d %s() nfs_fattr label unused\n",
+				file, line, func);
+		else
+		if (fattr->label_len != (strlen(fattr->label) + 1))
+			printk(KERN_WARNING
+				"%s:%d %s() nfs_fattr label size mismatch (label_len %d, strlen %d)\n",
+				file, line, func,
+				fattr->label_len, strlen(fattr->label) + 1);
+
+
+		security_release_secctx(fattr->label, fattr->label_len);
+		fattr->label = NULL;
+		fattr->label_len = 0;
+	}
+}
+#else
+#define	nfs_fattr_alloc(fattr, flags)
+#define	nfs_fattr_fini(fattr)
+#endif
+
+
 /*
  * linux/fs/nfs/file.c
  */
-- 
1.5.5.1

