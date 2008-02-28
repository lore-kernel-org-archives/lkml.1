Return-Path: <linux-kernel-owner+w=401wt.eu-S1760588AbYB1RLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760588AbYB1RLc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 12:11:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753248AbYB1RLU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 12:11:20 -0500
Received: from mummy.ncsc.mil ([144.51.88.129]:60590 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752360AbYB1RLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 12:11:17 -0500
Subject: Re: [PATCH 08/11] NFS: Introduce lifecycle management for label
	attribute.
From: Dave Quigley <dpquigl@tycho.nsa.gov>
To: hch@infradead.org
Cc: viro@ftp.linux.org.uk, trond.myklebust@fys.uio.no, bfields@fieldses.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <1204150294-4678-9-git-send-email-dpquigl@tycho.nsa.gov>
References: <1204150294-4678-1-git-send-email-dpquigl@tycho.nsa.gov>
	 <1204150294-4678-9-git-send-email-dpquigl@tycho.nsa.gov>
Content-Type: text/plain
Date: Thu, 28 Feb 2008 11:46:32 -0500
Message-Id: <1204217192.24345.70.camel@moss-terrapins.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am wondering. Since the NFSv<4 code will never touch these two new
fields is it necessary to put the initialization code into their code
paths? It seems that we could only do the initializations in the NFSv4
code since it will be the only ones using it.

Dave

On Wed, 2008-02-27 at 17:11 -0500, David P. Quigley wrote:
> Two fields have been added to the nfs_fattr structure to carry the security
> label and its length. This has raised the need to provide lifecycle management
> for these values. This patch introduces two macros nfs_fattr_alloc and
> nfs_fattr_fini which are used to allocate and destroy these fields inside the
> nfs_fattr structure. These macros do not modify any other components of the
> structure so nfs_fattr_init still has to be used on these structures. In the
> event that CONFIG_SECURITY is not set these calls should compile away.
> 
> Signed-off-by: David P. Quigley <dpquigl@tycho.nsa.gov>
> ---
>  fs/nfs/client.c        |   16 ++++++
>  fs/nfs/dir.c           |   25 ++++++++++
>  fs/nfs/getroot.c       |   33 +++++++++++++
>  fs/nfs/inode.c         |   16 ++++++
>  fs/nfs/namespace.c     |    3 +
>  fs/nfs/nfs3proc.c      |   15 ++++++
>  fs/nfs/nfs4proc.c      |  119 +++++++++++++++++++++++++++++++++++++++++++++++-
>  fs/nfs/proc.c          |   13 +++++-
>  fs/nfs/super.c         |    4 ++
>  include/linux/nfs_fs.h |   41 ++++++++++++++++
>  10 files changed, 283 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/nfs/client.c b/fs/nfs/client.c
> index c5c0175..aa93f9d 100644
> --- a/fs/nfs/client.c
> +++ b/fs/nfs/client.c
> @@ -878,6 +878,8 @@ struct nfs_server *nfs_create_server(const struct nfs_parsed_mount_data *data,
>  	struct nfs_fattr fattr;
>  	int error;
>  
> +	memset(&fattr, 0, sizeof(struct nfs_fattr));
> +
>  	server = nfs_alloc_server();
>  	if (!server)
>  		return ERR_PTR(-ENOMEM);
> @@ -928,10 +930,12 @@ struct nfs_server *nfs_create_server(const struct nfs_parsed_mount_data *data,
>  	spin_unlock(&nfs_client_lock);
>  
>  	server->mount_time = jiffies;
> +	nfs_fattr_fini(&fattr);
>  	return server;
>  
>  error:
>  	nfs_free_server(server);
> +	nfs_fattr_fini(&fattr);
>  	return ERR_PTR(error);
>  }
>  
> @@ -1083,6 +1087,8 @@ struct nfs_server *nfs4_create_server(const struct nfs_parsed_mount_data *data,
>  
>  	dprintk("--> nfs4_create_server()\n");
>  
> +	memset(&fattr, 0, sizeof(struct nfs_fattr));
> +
>  	server = nfs_alloc_server();
>  	if (!server)
>  		return ERR_PTR(-ENOMEM);
> @@ -1123,11 +1129,13 @@ struct nfs_server *nfs4_create_server(const struct nfs_parsed_mount_data *data,
>  	spin_unlock(&nfs_client_lock);
>  
>  	server->mount_time = jiffies;
> +	nfs_fattr_fini(&fattr);
>  	dprintk("<-- nfs4_create_server() = %p\n", server);
>  	return server;
>  
>  error:
>  	nfs_free_server(server);
> +	nfs_fattr_fini(&fattr);
>  	dprintk("<-- nfs4_create_server() = error %d\n", error);
>  	return ERR_PTR(error);
>  }
> @@ -1145,6 +1153,8 @@ struct nfs_server *nfs4_create_referral_server(struct nfs_clone_mount *data,
>  
>  	dprintk("--> nfs4_create_referral_server()\n");
>  
> +	memset(&fattr, 0, sizeof(struct nfs_fattr));
> +
>  	server = nfs_alloc_server();
>  	if (!server)
>  		return ERR_PTR(-ENOMEM);
> @@ -1200,11 +1210,13 @@ struct nfs_server *nfs4_create_referral_server(struct nfs_clone_mount *data,
>  
>  	server->mount_time = jiffies;
>  
> +	nfs_fattr_fini(&fattr);
>  	dprintk("<-- nfs_create_referral_server() = %p\n", server);
>  	return server;
>  
>  error:
>  	nfs_free_server(server);
> +	nfs_fattr_fini(&fattr);
>  	dprintk("<-- nfs4_create_referral_server() = error %d\n", error);
>  	return ERR_PTR(error);
>  }
> @@ -1226,6 +1238,8 @@ struct nfs_server *nfs_clone_server(struct nfs_server *source,
>  		(unsigned long long) fattr->fsid.major,
>  		(unsigned long long) fattr->fsid.minor);
>  
> +	memset(&fattr_fsinfo, 0, sizeof(struct nfs_fattr));
> +
>  	server = nfs_alloc_server();
>  	if (!server)
>  		return ERR_PTR(-ENOMEM);
> @@ -1268,11 +1282,13 @@ struct nfs_server *nfs_clone_server(struct nfs_server *source,
>  
>  	server->mount_time = jiffies;
>  
> +	nfs_fattr_fini(&fattr_fsinfo);
>  	dprintk("<-- nfs_clone_server() = %p\n", server);
>  	return server;
>  
>  out_free_server:
>  	nfs_free_server(server);
> +	nfs_fattr_fini(&fattr_fsinfo);
>  	dprintk("<-- nfs_clone_server() = error %d\n", error);
>  	return ERR_PTR(error);
>  }
> diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
> index ae04892..19808be 100644
> --- a/fs/nfs/dir.c
> +++ b/fs/nfs/dir.c
> @@ -533,6 +533,8 @@ static int nfs_readdir(struct file *filp, void *dirent, filldir_t filldir)
>  			(long long)filp->f_pos);
>  	nfs_inc_stats(inode, NFSIOS_VFSGETDENTS);
>  
> +	memset(&fattr, 0, sizeof(struct nfs_fattr));
> +
>  	lock_kernel();
>  
>  	/*
> @@ -589,6 +591,7 @@ static int nfs_readdir(struct file *filp, void *dirent, filldir_t filldir)
>  			res = 0;
>  			break;
>  		}
> +		nfs_fattr_fini(&fattr);
>  	}
>  out:
>  	nfs_unblock_sillyrename(dentry);
> @@ -764,6 +767,8 @@ static int nfs_lookup_revalidate(struct dentry * dentry, struct nameidata *nd)
>  	struct nfs_fh fhandle;
>  	struct nfs_fattr fattr;
>  
> +	memset(&fattr, 0, sizeof(struct nfs_fattr));
> +
>  	parent = dget_parent(dentry);
>  	lock_kernel();
>  	dir = parent->d_inode;
> @@ -793,6 +798,11 @@ static int nfs_lookup_revalidate(struct dentry * dentry, struct nameidata *nd)
>  	if (NFS_STALE(inode))
>  		goto out_bad;
>  
> +#ifdef CONFIG_NFS_V4_SECURITY_LABEL
> +	if (nfs_server_capable(dir, NFS_CAP_SECURITY_LABEL))
> +		nfs_fattr_alloc(&fattr, GFP_NOWAIT);
> +#endif
> +
>  	error = NFS_PROTO(dir)->lookup(dir, &dentry->d_name, &fhandle, &fattr);
>  	if (error)
>  		goto out_bad;
> @@ -805,6 +815,7 @@ static int nfs_lookup_revalidate(struct dentry * dentry, struct nameidata *nd)
>   out_valid:
>  	unlock_kernel();
>  	dput(parent);
> +	nfs_fattr_fini(&fattr);
>  	dfprintk(LOOKUPCACHE, "NFS: %s(%s/%s) is valid\n",
>  			__FUNCTION__, dentry->d_parent->d_name.name,
>  			dentry->d_name.name);
> @@ -824,6 +835,7 @@ out_zap_parent:
>  	d_drop(dentry);
>  	unlock_kernel();
>  	dput(parent);
> +	nfs_fattr_fini(&fattr);
>  	dfprintk(LOOKUPCACHE, "NFS: %s(%s/%s) is invalid\n",
>  			__FUNCTION__, dentry->d_parent->d_name.name,
>  			dentry->d_name.name);
> @@ -894,6 +906,8 @@ static struct dentry *nfs_lookup(struct inode *dir, struct dentry * dentry, stru
>  		dentry->d_parent->d_name.name, dentry->d_name.name);
>  	nfs_inc_stats(dir, NFSIOS_VFSLOOKUP);
>  
> +	memset(&fattr, 0, sizeof(struct nfs_fattr));
> +
>  	res = ERR_PTR(-ENAMETOOLONG);
>  	if (dentry->d_name.len > NFS_SERVER(dir)->namelen)
>  		goto out;
> @@ -915,6 +929,11 @@ static struct dentry *nfs_lookup(struct inode *dir, struct dentry * dentry, stru
>  
>  	parent = dentry->d_parent;
>  	/* Protect against concurrent sillydeletes */
> +#ifdef CONFIG_NFS_V4_SECURITY_LABEL
> +	if (nfs_server_capable(dir, NFS_CAP_SECURITY_LABEL))
> +		nfs_fattr_alloc(&fattr, GFP_NOWAIT);
> +#endif
> +
>  	nfs_block_sillyrename(parent);
>  	error = NFS_PROTO(dir)->lookup(dir, &dentry->d_name, &fhandle, &fattr);
>  	if (error == -ENOENT)
> @@ -941,6 +960,8 @@ out_unblock_sillyrename:
>  out_unlock:
>  	unlock_kernel();
>  out:
> +	/* Label will give 'unused' warning on 'no_entry' case. */
> +	nfs_fattr_fini(&fattr);
>  	return res;
>  }
>  
> @@ -1209,6 +1230,7 @@ static int nfs_create(struct inode *dir, struct dentry *dentry, int mode,
>  	dfprintk(VFS, "NFS: create(%s/%ld), %s\n",
>  			dir->i_sb->s_id, dir->i_ino, dentry->d_name.name);
>  
> +	memset(&attr, 0, sizeof(struct iattr));
>  	attr.ia_mode = mode;
>  	attr.ia_valid = ATTR_MODE;
>  
> @@ -1242,6 +1264,7 @@ nfs_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t rdev)
>  	if (!new_valid_dev(rdev))
>  		return -EINVAL;
>  
> +	memset(&attr, 0, sizeof(struct iattr));
>  	attr.ia_mode = mode;
>  	attr.ia_valid = ATTR_MODE;
>  
> @@ -1268,6 +1291,7 @@ static int nfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
>  	dfprintk(VFS, "NFS: mkdir(%s/%ld), %s\n",
>  			dir->i_sb->s_id, dir->i_ino, dentry->d_name.name);
>  
> +	memset(&attr, 0, sizeof(struct iattr));
>  	attr.ia_valid = ATTR_MODE;
>  	attr.ia_mode = mode | S_IFDIR;
>  
> @@ -1485,6 +1509,7 @@ static int nfs_symlink(struct inode *dir, struct dentry *dentry, const char *sym
>  	if (pathlen > PAGE_SIZE)
>  		return -ENAMETOOLONG;
>  
> +	memset(&attr, 0, sizeof(struct iattr));
>  	attr.ia_mode = S_IFLNK | S_IRWXUGO;
>  	attr.ia_valid = ATTR_MODE;
>  
> diff --git a/fs/nfs/getroot.c b/fs/nfs/getroot.c
> index fae9719..d0ed440 100644
> --- a/fs/nfs/getroot.c
> +++ b/fs/nfs/getroot.c
> @@ -84,6 +84,8 @@ struct dentry *nfs_get_root(struct super_block *sb, struct nfs_fh *mntfh)
>  	struct inode *inode;
>  	int error;
>  
> +	memset(&fattr, 0, sizeof(struct nfs_fattr));
> +
>  	/* get the actual root for this mount */
>  	fsinfo.fattr = &fattr;
>  
> @@ -119,6 +121,7 @@ struct dentry *nfs_get_root(struct super_block *sb, struct nfs_fh *mntfh)
>  	if (!mntroot->d_op)
>  		mntroot->d_op = server->nfs_client->rpc_ops->dentry_ops;
>  
> +	nfs_fattr_fini(&fattr);
>  	return mntroot;
>  }
>  
> @@ -143,6 +146,11 @@ int nfs4_path_walk(struct nfs_server *server,
>  
>  	dprintk("--> nfs4_path_walk(,,%s)\n", path);
>  
> +	memset(&fattr, 0, sizeof(struct nfs_fattr));
> +#ifdef CONFIG_NFS_V4_SECURITY_LABEL
> +	if (server->caps & NFS_CAP_SECURITY_LABEL)
> +		nfs_fattr_alloc(&fattr, GFP_KERNEL);
> +#endif
>  	fsinfo.fattr = &fattr;
>  	nfs_fattr_init(&fattr);
>  
> @@ -154,12 +162,14 @@ int nfs4_path_walk(struct nfs_server *server,
>  	ret = server->nfs_client->rpc_ops->getroot(server, mntfh, &fsinfo);
>  	if (ret < 0) {
>  		dprintk("nfs4_get_root: getroot error = %d\n", -ret);
> +		nfs_fattr_fini(&fattr);
>  		return ret;
>  	}
>  
>  	if (fattr.type != NFDIR) {
>  		printk(KERN_ERR "nfs4_get_root:"
>  		       " getroot encountered non-directory\n");
> +		nfs_fattr_fini(&fattr);
>  		return -ENOTDIR;
>  	}
>  
> @@ -167,6 +177,7 @@ int nfs4_path_walk(struct nfs_server *server,
>  	if (fattr.valid & NFS_ATTR_FATTR_V4_REFERRAL) {
>  		printk(KERN_ERR "nfs4_get_root:"
>  		       " getroot obtained referral\n");
> +		nfs_fattr_fini(&fattr);
>  		return -EREMOTE;
>  	}
>  
> @@ -199,6 +210,7 @@ eat_dot_dir:
>  	    ) {
>  		printk(KERN_ERR "nfs4_get_root:"
>  		       " Mount path contains reference to \"..\"\n");
> +		nfs_fattr_fini(&fattr);
>  		return -EINVAL;
>  	}
>  
> @@ -207,16 +219,25 @@ eat_dot_dir:
>  
>  	dprintk("LookupFH: %*.*s [%s]\n", name.len, name.len, name.name, path);
>  
> +	nfs_fattr_fini(&fattr);
> +	memset(&fattr, 0, sizeof(struct nfs_fattr));
> +#ifdef CONFIG_NFS_V4_SECURITY_LABEL
> +	if (server->caps & NFS_CAP_SECURITY_LABEL)
> +		nfs_fattr_alloc(&fattr, GFP_KERNEL);
> +#endif
> +
>  	ret = server->nfs_client->rpc_ops->lookupfh(server, &lastfh, &name,
>  						    mntfh, &fattr);
>  	if (ret < 0) {
>  		dprintk("nfs4_get_root: getroot error = %d\n", -ret);
> +		nfs_fattr_fini(&fattr);
>  		return ret;
>  	}
>  
>  	if (fattr.type != NFDIR) {
>  		printk(KERN_ERR "nfs4_get_root:"
>  		       " lookupfh encountered non-directory\n");
> +		nfs_fattr_fini(&fattr);
>  		return -ENOTDIR;
>  	}
>  
> @@ -224,6 +245,7 @@ eat_dot_dir:
>  	if (fattr.valid & NFS_ATTR_FATTR_V4_REFERRAL) {
>  		printk(KERN_ERR "nfs4_get_root:"
>  		       " lookupfh obtained referral\n");
> +		nfs_fattr_fini(&fattr);
>  		return -EREMOTE;
>  	}
>  
> @@ -231,6 +253,7 @@ eat_dot_dir:
>  
>  path_walk_complete:
>  	memcpy(&server->fsid, &fattr.fsid, sizeof(server->fsid));
> +	nfs_fattr_fini(&fattr);
>  	dprintk("<-- nfs4_path_walk() = 0\n");
>  	return 0;
>  }
> @@ -256,18 +279,28 @@ struct dentry *nfs4_get_root(struct super_block *sb, struct nfs_fh *mntfh)
>  		return ERR_PTR(error);
>  	}
>  
> +	memset(&fattr, 0, sizeof(struct nfs_fattr));
> +#ifdef CONFIG_NFS_V4_SECURITY_LABEL
> +	if (server->caps & NFS_CAP_SECURITY_LABEL)
> +		nfs_fattr_alloc(&fattr, GFP_KERNEL);
> +#endif
> +
>  	/* get the actual root for this mount */
>  	error = server->nfs_client->rpc_ops->getattr(server, mntfh, &fattr);
>  	if (error < 0) {
>  		dprintk("nfs_get_root: getattr error = %d\n", -error);
> +		nfs_fattr_fini(&fattr);
>  		return ERR_PTR(error);
>  	}
>  
>  	inode = nfs_fhget(sb, mntfh, &fattr);
>  	if (IS_ERR(inode)) {
>  		dprintk("nfs_get_root: get root inode failed\n");
> +		nfs_fattr_fini(&fattr);
>  		return ERR_CAST(inode);
>  	}
> +	
> +	nfs_fattr_fini(&fattr);
>  
>  	error = nfs_superblock_set_dummy_root(sb, inode);
>  	if (error != 0)
> diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
> index 966a885..c34fb7c 100644
> --- a/fs/nfs/inode.c
> +++ b/fs/nfs/inode.c
> @@ -357,6 +357,12 @@ nfs_setattr(struct dentry *dentry, struct iattr *attr)
>  
>  	nfs_inc_stats(inode, NFSIOS_VFSSETATTR);
>  
> +	memset(&fattr, 0, sizeof(struct nfs_fattr));
> +#ifdef CONFIG_NFS_V4_SECURITY_LABEL
> +	if (nfs_server_capable(inode, NFS_CAP_SECURITY_LABEL))
> +		nfs_fattr_alloc(&fattr, GFP_KERNEL);
> +#endif
> +
>  	/* skip mode change if it's just for clearing setuid/setgid */
>  	if (attr->ia_valid & (ATTR_KILL_SUID | ATTR_KILL_SGID))
>  		attr->ia_valid &= ~ATTR_MODE;
> @@ -386,6 +392,7 @@ nfs_setattr(struct dentry *dentry, struct iattr *attr)
>  	if (error == 0)
>  		nfs_refresh_inode(inode, &fattr);
>  	unlock_kernel();
> +	nfs_fattr_fini(&fattr);
>  	return error;
>  }
>  
> @@ -642,6 +649,9 @@ __nfs_revalidate_inode(struct nfs_server *server, struct inode *inode)
>  		inode->i_sb->s_id, (long long)NFS_FILEID(inode));
>  
>  	nfs_inc_stats(inode, NFSIOS_INODEREVALIDATE);
> +
> +	memset(&fattr, 0, sizeof(struct nfs_fattr));
> +
>  	lock_kernel();
>  	if (is_bad_inode(inode))
>   		goto out_nowait;
> @@ -656,6 +666,11 @@ __nfs_revalidate_inode(struct nfs_server *server, struct inode *inode)
>  	if (NFS_STALE(inode))
>  		goto out;
>  
> +#ifdef CONFIG_NFS_V4_SECURITY_LABEL
> +	if (nfs_server_capable(inode, NFS_CAP_SECURITY_LABEL))
> +		nfs_fattr_alloc(&fattr, GFP_KERNEL);
> +#endif
> +
>  	status = NFS_PROTO(inode)->getattr(server, NFS_FH(inode), &fattr);
>  	if (status != 0) {
>  		dfprintk(PAGECACHE, "nfs_revalidate_inode: (%s/%Ld) getattr failed, error=%d\n",
> @@ -692,6 +707,7 @@ __nfs_revalidate_inode(struct nfs_server *server, struct inode *inode)
>  
>   out_nowait:
>  	unlock_kernel();
> +	nfs_fattr_fini(&fattr);
>  	return status;
>  }
>  
> diff --git a/fs/nfs/namespace.c b/fs/nfs/namespace.c
> index 607f6eb..b0a9791 100644
> --- a/fs/nfs/namespace.c
> +++ b/fs/nfs/namespace.c
> @@ -105,6 +105,8 @@ static void * nfs_follow_mountpoint(struct dentry *dentry, struct nameidata *nd)
>  
>  	dprintk("--> nfs_follow_mountpoint()\n");
>  
> +	memset(&fattr, 0, sizeof(struct nfs_fattr));
> +
>  	BUG_ON(IS_ROOT(dentry));
>  	dprintk("%s: enter\n", __FUNCTION__);
>  	dput(nd->path.dentry);
> @@ -143,6 +145,7 @@ static void * nfs_follow_mountpoint(struct dentry *dentry, struct nameidata *nd)
>  	nd->path.dentry = dget(mnt->mnt_root);
>  	schedule_delayed_work(&nfs_automount_task, nfs_mountpoint_expiry_timeout);
>  out:
> +	nfs_fattr_fini(&fattr);
>  	dprintk("%s: done, returned %d\n", __FUNCTION__, err);
>  
>  	dprintk("<-- nfs_follow_mountpoint() = %d\n", err);
> diff --git a/fs/nfs/nfs3proc.c b/fs/nfs/nfs3proc.c
> index 549dbce..2204507 100644
> --- a/fs/nfs/nfs3proc.c
> +++ b/fs/nfs/nfs3proc.c
> @@ -380,6 +380,7 @@ nfs3_proc_unlink_done(struct rpc_task *task, struct inode *dir)
>  		return 0;
>  	res = task->tk_msg.rpc_resp;
>  	nfs_post_op_update_inode(dir, &res->dir_attr);
> +	nfs_fattr_fini(&res->dir_attr);
>  	return 1;
>  }
>  
> @@ -479,6 +480,9 @@ nfs3_proc_symlink(struct inode *dir, struct dentry *dentry, struct page *page,
>  
>  	dprintk("NFS call  symlink %s\n", dentry->d_name.name);
>  
> +	memset(&fattr, 0, sizeof(struct nfs_fattr));
> +	memset(&dir_attr, 0, sizeof(struct nfs_fattr));
> +
>  	nfs_fattr_init(&dir_attr);
>  	nfs_fattr_init(&fattr);
>  	status = rpc_call_sync(NFS_CLIENT(dir), &msg, 0);
> @@ -487,6 +491,8 @@ nfs3_proc_symlink(struct inode *dir, struct dentry *dentry, struct page *page,
>  		goto out;
>  	status = nfs_instantiate(dentry, &fhandle, &fattr);
>  out:
> +	nfs_fattr_fini(&fattr);
> +	nfs_fattr_fini(&dir_attr);
>  	dprintk("NFS reply symlink: %d\n", status);
>  	return status;
>  }
> @@ -519,6 +525,8 @@ nfs3_proc_mkdir(struct inode *dir, struct dentry *dentry, struct iattr *sattr)
>  
>  	sattr->ia_mode &= ~current->fs->umask;
>  
> +	memset(&fattr, 0, sizeof(struct nfs_fattr));
> +	memset(&dir_attr, 0, sizeof(struct nfs_fattr));
>  	nfs_fattr_init(&dir_attr);
>  	nfs_fattr_init(&fattr);
>  	status = rpc_call_sync(NFS_CLIENT(dir), &msg, 0);
> @@ -530,6 +538,8 @@ nfs3_proc_mkdir(struct inode *dir, struct dentry *dentry, struct iattr *sattr)
>  		goto out;
>  	status = nfs3_proc_set_default_acl(dir, dentry->d_inode, mode);
>  out:
> +	nfs_fattr_fini(&fattr);
> +	nfs_fattr_fini(&dir_attr);
>  	dprintk("NFS reply mkdir: %d\n", status);
>  	return status;
>  }
> @@ -637,6 +647,9 @@ nfs3_proc_mknod(struct inode *dir, struct dentry *dentry, struct iattr *sattr,
>  	mode_t mode = sattr->ia_mode;
>  	int status;
>  
> +	memset(&fattr, 0, sizeof(struct nfs_fattr));
> +	memset(&dir_attr, 0, sizeof(struct nfs_fattr));
> +
>  	switch (sattr->ia_mode & S_IFMT) {
>  	case S_IFBLK:	arg.type = NF3BLK;  break;
>  	case S_IFCHR:	arg.type = NF3CHR;  break;
> @@ -661,6 +674,8 @@ nfs3_proc_mknod(struct inode *dir, struct dentry *dentry, struct iattr *sattr,
>  		goto out;
>  	status = nfs3_proc_set_default_acl(dir, dentry->d_inode, mode);
>  out:
> +	nfs_fattr_fini(&fattr);
> +	nfs_fattr_fini(&dir_attr);
>  	dprintk("NFS reply mknod: %d\n", status);
>  	return status;
>  }
> diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
> index 42e5cf7..b278f7c 100644
> --- a/fs/nfs/nfs4proc.c
> +++ b/fs/nfs/nfs4proc.c
> @@ -243,6 +243,8 @@ static void nfs4_init_opendata_res(struct nfs4_opendata *p)
>  	p->o_res.f_attr = &p->f_attr;
>  	p->o_res.dir_attr = &p->dir_attr;
>  	p->o_res.server = p->o_arg.server;
> +	memset(&p->f_attr, 0, sizeof(struct nfs_fattr));
> +	memset(&p->dir_attr, 0, sizeof(struct nfs_fattr));
>  	nfs_fattr_init(&p->f_attr);
>  	nfs_fattr_init(&p->dir_attr);
>  }
> @@ -275,6 +277,7 @@ static struct nfs4_opendata *nfs4_opendata_alloc(struct path *path,
>  	p->o_arg.server = server;
>  	p->o_arg.bitmask = server->attr_bitmask;
>  	p->o_arg.claim = NFS4_OPEN_CLAIM_NULL;
> +	memset(&p->attrs, 0, sizeof(struct iattr));
>  	if (flags & O_EXCL) {
>  		u32 *s = (u32 *) p->o_arg.u.verifier.data;
>  		s[0] = jiffies;
> @@ -282,12 +285,22 @@ static struct nfs4_opendata *nfs4_opendata_alloc(struct path *path,
>  	} else if (flags & O_CREAT) {
>  		p->o_arg.u.attrs = &p->attrs;
>  		memcpy(&p->attrs, attrs, sizeof(p->attrs));
> +		/* The above creates an additional reference to ia_label.
> +		 * The CALLER must free this, not nfs4_opendata_free()
> +		 */
>  	}
>  	p->c_arg.fh = &p->o_res.fh;
>  	p->c_arg.stateid = &p->o_res.stateid;
>  	p->c_arg.seqid = p->o_arg.seqid;
>  	nfs4_init_opendata_res(p);
>  	kref_init(&p->kref);
> +
> +#ifdef CONFIG_NFS_V4_SECURITY_LABEL
> +	if (server->caps & NFS_CAP_SECURITY_LABEL) {
> +		nfs_fattr_alloc(&p->f_attr, GFP_KERNEL);
> +		nfs_fattr_alloc(&p->dir_attr, GFP_KERNEL);
> +	}
> +#endif
>  	return p;
>  err_free:
>  	kfree(p);
> @@ -304,6 +317,8 @@ static void nfs4_opendata_free(struct kref *kref)
>  	nfs_free_seqid(p->o_arg.seqid);
>  	if (p->state != NULL)
>  		nfs4_put_open_state(p->state);
> +	nfs_fattr_fini(&p->f_attr);
> +	nfs_fattr_fini(&p->dir_attr);
>  	nfs4_put_state_owner(p->owner);
>  	dput(p->dir);
>  	dput(p->path.dentry);
> @@ -1215,6 +1230,7 @@ static void nfs4_free_closedata(void *data)
>  	nfs4_put_state_owner(sp);
>  	dput(calldata->path.dentry);
>  	mntput(calldata->path.mnt);
> +	nfs_fattr_fini(&calldata->fattr);
>  	kfree(calldata);
>  }
>  
> @@ -1322,7 +1338,7 @@ int nfs4_do_close(struct path *path, struct nfs4_state *state, int wait)
>  	};
>  	int status = -ENOMEM;
>  
> -	calldata = kmalloc(sizeof(*calldata), GFP_KERNEL);
> +	calldata = kzalloc(sizeof(*calldata), GFP_KERNEL);
>  	if (calldata == NULL)
>  		goto out;
>  	calldata->inode = state->inode;
> @@ -1339,6 +1355,11 @@ int nfs4_do_close(struct path *path, struct nfs4_state *state, int wait)
>  	calldata->path.mnt = mntget(path->mnt);
>  	calldata->path.dentry = dget(path->dentry);
>  
> +#ifdef CONFIG_NFS_V4_SECURITY_LABEL
> +	if (server->caps & NFS_CAP_SECURITY_LABEL)
> +		nfs_fattr_alloc(&calldata->fattr, GFP_KERNEL);
> +#endif
> +
>  	msg.rpc_argp = &calldata->arg,
>  	msg.rpc_resp = &calldata->res,
>  	task_setup_data.callback_data = calldata;
> @@ -1351,6 +1372,7 @@ int nfs4_do_close(struct path *path, struct nfs4_state *state, int wait)
>  	rpc_put_task(task);
>  	return status;
>  out_free_calldata:
> +	nfs_fattr_fini(&calldata->fattr);
>  	kfree(calldata);
>  out:
>  	nfs4_put_open_state(state);
> @@ -1397,6 +1419,7 @@ nfs4_atomic_open(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
>  	struct nfs4_state *state;
>  	struct dentry *res;
>  
> +	memset(&attr, 0, sizeof(struct iattr));
>  	if (nd->flags & LOOKUP_CREATE) {
>  		attr.ia_mode = nd->intent.open.create_mode;
>  		attr.ia_valid = ATTR_MODE;
> @@ -1770,6 +1793,8 @@ static int _nfs4_proc_access(struct inode *inode, struct nfs_access_entry *entry
>  	int mode = entry->mask;
>  	int status;
>  
> +	memset(&fattr, 0, sizeof(struct nfs_fattr));
> +
>  	/*
>  	 * Determine which access bits we want to ask for...
>  	 */
> @@ -1786,6 +1811,10 @@ static int _nfs4_proc_access(struct inode *inode, struct nfs_access_entry *entry
>  		if (mode & MAY_EXEC)
>  			args.access |= NFS4_ACCESS_EXECUTE;
>  	}
> +#ifdef CONFIG_NFS_V4_SECURITY_LABEL
> +	if (server->caps & NFS_CAP_SECURITY_LABEL)
> +		nfs_fattr_alloc(&fattr, GFP_KERNEL);
> +#endif
>  	nfs_fattr_init(&fattr);
>  	status = rpc_call_sync(NFS_CLIENT(inode), &msg, 0);
>  	if (!status) {
> @@ -1798,6 +1827,7 @@ static int _nfs4_proc_access(struct inode *inode, struct nfs_access_entry *entry
>  			entry->mask |= MAY_EXEC;
>  		nfs_refresh_inode(inode, &fattr);
>  	}
> +	nfs_fattr_fini(&fattr);
>  	return status;
>  }
>  
> @@ -1911,10 +1941,17 @@ nfs4_proc_create(struct inode *dir, struct dentry *dentry, struct iattr *sattr,
>  	nfs_set_verifier(dentry, nfs_save_change_attribute(dir));
>  	if (flags & O_EXCL) {
>  		struct nfs_fattr fattr;
> +		memset(&fattr, 0, sizeof(struct nfs_fattr));
> +#ifdef CONFIG_NFS_V4_SECURITY_LABEL
> +		if (nfs_server_capable(state->inode, NFS_CAP_SECURITY_LABEL))
> +			nfs_fattr_alloc(&fattr, GFP_KERNEL);
> +#endif
>  		status = nfs4_do_setattr(state->inode, &fattr, sattr, state);
>  		if (status == 0)
>  			nfs_setattr_update_inode(state->inode, sattr);
>  		nfs_post_op_update_inode(state->inode, &fattr);
> +
> +		nfs_fattr_fini(&fattr);
>  	}
>  	if (status == 0 && (nd->flags & LOOKUP_OPEN) != 0)
>  		status = nfs4_intent_set_file(nd, &path, state);
> @@ -1943,12 +1980,18 @@ static int _nfs4_proc_remove(struct inode *dir, struct qstr *name)
>  	};
>  	int			status;
>  
> +	memset(&res.dir_attr, 0, sizeof(struct nfs_fattr));
> +#ifdef CONFIG_NFS_V4_SECURITY_LABEL
> +	if (server->caps & NFS_CAP_SECURITY_LABEL)
> +		nfs_fattr_alloc(&res.dir_attr, GFP_KERNEL);
> +#endif
>  	nfs_fattr_init(&res.dir_attr);
>  	status = rpc_call_sync(server->client, &msg, 0);
>  	if (status == 0) {
>  		update_changeattr(dir, &res.cinfo);
>  		nfs_post_op_update_inode(dir, &res.dir_attr);
>  	}
> +	nfs_fattr_fini(&res.dir_attr);
>  	return status;
>  }
>  
> @@ -1973,6 +2016,13 @@ static void nfs4_proc_unlink_setup(struct rpc_message *msg, struct inode *dir)
>  	args->bitmask = server->attr_bitmask;
>  	res->server = server;
>  	msg->rpc_proc = &nfs4_procedures[NFSPROC4_CLNT_REMOVE];
> +
> +	memset(&res->dir_attr, 0, sizeof(struct nfs_fattr));
> +#ifdef CONFIG_NFS_V4_SECURITY_LABEL
> +	if (server->caps & NFS_CAP_SECURITY_LABEL)
> +		nfs_fattr_alloc(&res->dir_attr, GFP_KERNEL);
> +#endif
> +	nfs_fattr_init(&res->dir_attr);
>  }
>  
>  static int nfs4_proc_unlink_done(struct rpc_task *task, struct inode *dir)
> @@ -1983,6 +2033,7 @@ static int nfs4_proc_unlink_done(struct rpc_task *task, struct inode *dir)
>  		return 0;
>  	update_changeattr(dir, &res->cinfo);
>  	nfs_post_op_update_inode(dir, &res->dir_attr);
> +	nfs_fattr_fini(&res->dir_attr);
>  	return 1;
>  }
>  
> @@ -2010,6 +2061,15 @@ static int _nfs4_proc_rename(struct inode *old_dir, struct qstr *old_name,
>  	};
>  	int			status;
>  	
> +
> +	memset(&old_fattr, 0, sizeof(struct nfs_fattr));
> +	memset(&new_fattr, 0, sizeof(struct nfs_fattr));
> +#ifdef CONFIG_NFS_V4_SECURITY_LABEL
> +	if (server->caps & NFS_CAP_SECURITY_LABEL) {
> +		nfs_fattr_alloc(&old_fattr, GFP_KERNEL);
> +		nfs_fattr_alloc(&new_fattr, GFP_KERNEL);
> +	}
> +#endif
>  	nfs_fattr_init(res.old_fattr);
>  	nfs_fattr_init(res.new_fattr);
>  	status = rpc_call_sync(server->client, &msg, 0);
> @@ -2020,6 +2080,8 @@ static int _nfs4_proc_rename(struct inode *old_dir, struct qstr *old_name,
>  		update_changeattr(new_dir, &res.new_cinfo);
>  		nfs_post_op_update_inode(new_dir, res.new_fattr);
>  	}
> +	nfs_fattr_fini(&old_fattr);
> +	nfs_fattr_fini(&new_fattr);
>  	return status;
>  }
>  
> @@ -2059,6 +2121,16 @@ static int _nfs4_proc_link(struct inode *inode, struct inode *dir, struct qstr *
>  	};
>  	int			status;
>  
> +	memset(&fattr, 0, sizeof(struct nfs_fattr));
> +	memset(&dir_attr, 0, sizeof(struct nfs_fattr));
> +
> +#ifdef CONFIG_NFS_V4_SECURITY_LABEL
> +	if (server->caps & NFS_CAP_SECURITY_LABEL) {
> +		nfs_fattr_alloc(&fattr, GFP_KERNEL);
> +		nfs_fattr_alloc(&dir_attr, GFP_KERNEL);
> +	}
> +#endif
> +
>  	nfs_fattr_init(res.fattr);
>  	nfs_fattr_init(res.dir_attr);
>  	status = rpc_call_sync(server->client, &msg, 0);
> @@ -2068,6 +2140,8 @@ static int _nfs4_proc_link(struct inode *inode, struct inode *dir, struct qstr *
>  		nfs_post_op_update_inode(inode, res.fattr);
>  	}
>  
> +	nfs_fattr_fini(&fattr);
> +	nfs_fattr_fini(&dir_attr);
>  	return status;
>  }
>  
> @@ -2113,6 +2187,16 @@ static int _nfs4_proc_symlink(struct inode *dir, struct dentry *dentry,
>  	if (len > NFS4_MAXPATHLEN)
>  		return -ENAMETOOLONG;
>  
> +	memset(&fattr, 0, sizeof(struct nfs_fattr));
> +	memset(&dir_fattr, 0, sizeof(struct nfs_fattr));
> +
> +#ifdef CONFIG_NFS_V4_SECURITY_LABEL
> +	if (server->caps & NFS_CAP_SECURITY_LABEL) {
> +		nfs_fattr_alloc(&fattr, GFP_KERNEL);
> +		nfs_fattr_alloc(&dir_fattr, GFP_KERNEL);
> +	}
> +#endif
> +
>  	arg.u.symlink.pages = &page;
>  	arg.u.symlink.len = len;
>  	nfs_fattr_init(&fattr);
> @@ -2124,6 +2208,8 @@ static int _nfs4_proc_symlink(struct inode *dir, struct dentry *dentry,
>  		nfs_post_op_update_inode(dir, res.dir_fattr);
>  		status = nfs_instantiate(dentry, &fhandle, &fattr);
>  	}
> +	nfs_fattr_fini(&fattr);
> +	nfs_fattr_fini(&dir_fattr);
>  	return status;
>  }
>  
> @@ -2168,6 +2254,16 @@ static int _nfs4_proc_mkdir(struct inode *dir, struct dentry *dentry,
>  	};
>  	int			status;
>  
> +	memset(&fattr, 0, sizeof(struct nfs_fattr));
> +	memset(&dir_fattr, 0, sizeof(struct nfs_fattr));
> +
> +#ifdef CONFIG_NFS_V4_SECURITY_LABEL
> +	if (server->caps & NFS_CAP_SECURITY_LABEL) {
> +		nfs_fattr_alloc(&fattr, GFP_KERNEL);
> +		nfs_fattr_alloc(&dir_fattr, GFP_KERNEL);
> +	}
> +#endif
> +
>  	nfs_fattr_init(&fattr);
>  	nfs_fattr_init(&dir_fattr);
>  	
> @@ -2177,6 +2273,8 @@ static int _nfs4_proc_mkdir(struct inode *dir, struct dentry *dentry,
>  		nfs_post_op_update_inode(dir, res.dir_fattr);
>  		status = nfs_instantiate(dentry, &fhandle, &fattr);
>  	}
> +	nfs_fattr_fini(&fattr);
> +	nfs_fattr_fini(&dir_fattr);
>  	return status;
>  }
>  
> @@ -2270,6 +2368,15 @@ static int _nfs4_proc_mknod(struct inode *dir, struct dentry *dentry,
>  	int			status;
>  	int                     mode = sattr->ia_mode;
>  
> +	memset(&fattr, 0, sizeof(struct nfs_fattr));
> +	memset(&dir_fattr, 0, sizeof(struct nfs_fattr));
> +
> +#ifdef CONFIG_NFS_V4_SECURITY_LABEL
> +	if (server->caps & NFS_CAP_SECURITY_LABEL) {
> +		nfs_fattr_alloc(&fattr, GFP_KERNEL);
> +		nfs_fattr_alloc(&dir_fattr, GFP_KERNEL);
> +	}
> +#endif
>  	nfs_fattr_init(&fattr);
>  	nfs_fattr_init(&dir_fattr);
>  
> @@ -2296,6 +2403,8 @@ static int _nfs4_proc_mknod(struct inode *dir, struct dentry *dentry,
>  		nfs_post_op_update_inode(dir, res.dir_fattr);
>  		status = nfs_instantiate(dentry, &fh, &fattr);
>  	}
> +	nfs_fattr_fini(&fattr);
> +	nfs_fattr_fini(&dir_fattr);
>  	return status;
>  }
>  
> @@ -2973,6 +3082,9 @@ static void nfs4_delegreturn_done(struct rpc_task *task, void *calldata)
>  
>  static void nfs4_delegreturn_release(void *calldata)
>  {
> +	struct nfs4_delegreturndata *data = calldata;
> +
> +	nfs_fattr_fini(data->res.fattr);
>  	kfree(calldata);
>  }
>  
> @@ -3008,6 +3120,11 @@ static int _nfs4_proc_delegreturn(struct inode *inode, struct rpc_cred *cred, co
>  	memcpy(&data->stateid, stateid, sizeof(data->stateid));
>  	data->res.fattr = &data->fattr;
>  	data->res.server = server;
> +	memset(data->res.fattr, 0, sizeof(struct nfs_fattr));
> +#ifdef CONFIG_NFS_V4_SECURITY_LABEL
> +	if (data->res.server->caps & NFS_CAP_SECURITY_LABEL)
> +		nfs_fattr_alloc(data->res.fattr, GFP_KERNEL);
> +#endif
>  	nfs_fattr_init(data->res.fattr);
>  	data->timestamp = jiffies;
>  	data->rpc_status = 0;
> diff --git a/fs/nfs/proc.c b/fs/nfs/proc.c
> index 5ccf7fa..d7435f6 100644
> --- a/fs/nfs/proc.c
> +++ b/fs/nfs/proc.c
> @@ -208,12 +208,15 @@ nfs_proc_create(struct inode *dir, struct dentry *dentry, struct iattr *sattr,
>  	};
>  	int			status;
>  
> -	nfs_fattr_init(&fattr);
>  	dprintk("NFS call  create %s\n", dentry->d_name.name);
> +
> +	memset(&fattr, 0, sizeof(struct nfs_fattr));
> +	nfs_fattr_init(&fattr);
>  	status = rpc_call_sync(NFS_CLIENT(dir), &msg, 0);
>  	nfs_mark_for_revalidate(dir);
>  	if (status == 0)
>  		status = nfs_instantiate(dentry, &fhandle, &fattr);
> +	nfs_fattr_fini(&fattr);
>  	dprintk("NFS reply create: %d\n", status);
>  	return status;
>  }
> @@ -255,6 +258,7 @@ nfs_proc_mknod(struct inode *dir, struct dentry *dentry, struct iattr *sattr,
>  		sattr->ia_size = new_encode_dev(rdev);/* get out your barf bag */
>  	}
>  
> +	memset(&fattr, 0, sizeof(struct nfs_fattr));
>  	nfs_fattr_init(&fattr);
>  	status = rpc_call_sync(NFS_CLIENT(dir), &msg, 0);
>  	nfs_mark_for_revalidate(dir);
> @@ -266,6 +270,7 @@ nfs_proc_mknod(struct inode *dir, struct dentry *dentry, struct iattr *sattr,
>  	}
>  	if (status == 0)
>  		status = nfs_instantiate(dentry, &fhandle, &fattr);
> +	nfs_fattr_fini(&fattr);
>  	dprintk("NFS reply mknod: %d\n", status);
>  	return status;
>  }
> @@ -378,6 +383,8 @@ nfs_proc_symlink(struct inode *dir, struct dentry *dentry, struct page *page,
>  
>  	dprintk("NFS call  symlink %s\n", dentry->d_name.name);
>  
> +	memset(&fattr, 0, sizeof(struct nfs_fattr));
> +
>  	status = rpc_call_sync(NFS_CLIENT(dir), &msg, 0);
>  	nfs_mark_for_revalidate(dir);
>  
> @@ -392,6 +399,7 @@ nfs_proc_symlink(struct inode *dir, struct dentry *dentry, struct page *page,
>  		status = nfs_instantiate(dentry, &fhandle, &fattr);
>  	}
>  
> +	nfs_fattr_fini(&fattr);
>  	dprintk("NFS reply symlink: %d\n", status);
>  	return status;
>  }
> @@ -419,11 +427,14 @@ nfs_proc_mkdir(struct inode *dir, struct dentry *dentry, struct iattr *sattr)
>  	int			status;
>  
>  	dprintk("NFS call  mkdir %s\n", dentry->d_name.name);
> +
> +	memset(&fattr, 0, sizeof(struct nfs_fattr));
>  	nfs_fattr_init(&fattr);
>  	status = rpc_call_sync(NFS_CLIENT(dir), &msg, 0);
>  	nfs_mark_for_revalidate(dir);
>  	if (status == 0)
>  		status = nfs_instantiate(dentry, &fhandle, &fattr);
> +	nfs_fattr_fini(&fattr);
>  	dprintk("NFS reply mkdir: %d\n", status);
>  	return status;
>  }
> diff --git a/fs/nfs/super.c b/fs/nfs/super.c
> index f3e327e..95f2fad 100644
> --- a/fs/nfs/super.c
> +++ b/fs/nfs/super.c
> @@ -371,6 +371,8 @@ static int nfs_statfs(struct dentry *dentry, struct kstatfs *buf)
>  	};
>  	int error;
>  
> +	memset(&fattr, 0, sizeof(struct nfs_fattr));
> +
>  	lock_kernel();
>  
>  	error = server->nfs_client->rpc_ops->statfs(server, fh, &res);
> @@ -405,11 +407,13 @@ static int nfs_statfs(struct dentry *dentry, struct kstatfs *buf)
>  	buf->f_namelen = server->namelen;
>  
>  	unlock_kernel();
> +	nfs_fattr_fini(&fattr);
>  	return 0;
>  
>   out_err:
>  	dprintk("%s: statfs error = %d\n", __FUNCTION__, -error);
>  	unlock_kernel();
> +	nfs_fattr_fini(&fattr);
>  	return error;
>  }
>  
> diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
> index a69ba80..991d56f 100644
> --- a/include/linux/nfs_fs.h
> +++ b/include/linux/nfs_fs.h
> @@ -345,6 +345,47 @@ static inline void nfs_fattr_init(struct nfs_fattr *fattr)
>  	fattr->time_start = jiffies;
>  }
>  
> +#ifdef CONFIG_SECURITY
> +static inline void nfs_fattr_alloc(struct nfs_fattr *fattr, gfp_t flags)
> +{
> +	fattr->label = kzalloc(NFS4_MAXLABELLEN, flags);
> +	if (fattr->label == NULL)
> +		panic("Can't allocate security label.");
> +	fattr->label_len = NFS4_MAXLABELLEN;
> +}
> +
> +#define	nfs_fattr_fini(fattr)	_nfs_fattr_fini(fattr, __FILE__, __LINE__, __func__)
> +static inline void _nfs_fattr_fini(struct nfs_fattr *fattr,
> +		const char *file, int line, const char *func)
> +{
> +	if ((fattr)->label == NULL) {
> +		if (fattr->label_len != 0) {
> +			printk(KERN_WARNING
> +					"%s:%d %s() nfs_fattr label available (%d)\n",
> +					file, line, func,
> +					fattr->label_len);
> +		}
> +	} else {
> +		if (fattr->label_len == NFS4_MAXLABELLEN)
> +			printk(KERN_WARNING
> +					"%s:%d %s() nfs_fattr label unused\n",
> +					file, line, func);
> +		else if (fattr->label_len != (strlen(fattr->label) + 1))
> +			printk(KERN_WARNING
> +				"%s:%d %s() nfs_fattr label size mismatch (label_len %d, strlen %d)\n",
> +				file, line, func,
> +				fattr->label_len, strlen(fattr->label) + 1);
> +
> +		kfree(fattr->label);
> +		fattr->label = NULL;
> +		fattr->label_len = 0;
> +	}
> +}
> +#else
> +#define	nfs_fattr_alloc(fattr, flags)
> +#define	nfs_fattr_fini(fattr)
> +#endif
> +
>  /*
>   * linux/fs/nfs/file.c
>   */

