Return-Path: <linux-kernel-owner+w=401wt.eu-S1756647AbZBDXkL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647AbZBDXkL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 18:40:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753962AbZBDXj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 18:39:56 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:49167 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478AbZBDXjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 18:39:54 -0500
Date: Wed, 4 Feb 2009 17:39:52 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: viro@ZenIV.linux.org.uk, hch@lst.de, alan@lxorguk.ukuu.org.uk,
       hpa@zytor.com, "David C. Hansen" <haveblue@us.ibm.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] simple_set_mnt() should return void
Message-ID: <20090204233952.GA17354@us.ibm.com>
References: <20090204043006.GA25963@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090204043006.GA25963@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Sukadev Bhattiprolu (sukadev@linux.vnet.ibm.com):
> Tested this with devpts and by compiling kernel with 'allmodconfig'.
> ---
> 
> From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> Date: Wed, 28 Jan 2009 17:11:13 -0800
> Subject: [PATCH] simple_set_mnt() should return void
> 
> simple_set_mnt() is defined as returning 'int' but always returns 0.
> Callers assume simple_set_mnt() never fails and don't properly cleanup
> if it were to _ever_ fail. For instance, get_sb_single()
> and get_sb_nodev() should:
> 
>         up_write(sb->s_unmount);
>         deactivate_super(sb);
> 
> if simple_set_mnt() fails.
> 
> Since simple_set_mnt() never fails, would be cleaner if it did not
> return anything.
> 
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>

A bit of grepping also found no other cases.

Acked-by: Serge Hallyn <serue@us.ibm.com>

> ---
>  drivers/mtd/mtdsuper.c |    7 +++++--
>  fs/9p/vfs_super.c      |    5 +++--
>  fs/cifs/cifsfs.c       |    3 ++-
>  fs/devpts/inode.c      |    3 ++-
>  fs/libfs.c             |    3 ++-
>  fs/namespace.c         |    3 +--
>  fs/proc/root.c         |    3 ++-
>  fs/super.c             |    9 ++++++---
>  fs/ubifs/super.c       |    3 ++-
>  include/linux/fs.h     |    2 +-
>  kernel/cgroup.c        |    3 ++-
>  11 files changed, 28 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/mtd/mtdsuper.c b/drivers/mtd/mtdsuper.c
> index 00d46e1..92285d0 100644
> --- a/drivers/mtd/mtdsuper.c
> +++ b/drivers/mtd/mtdsuper.c
> @@ -81,13 +81,16 @@ static int get_sb_mtd_aux(struct file_system_type *fs_type, int flags,
> 
>  	/* go */
>  	sb->s_flags |= MS_ACTIVE;
> -	return simple_set_mnt(mnt, sb);
> +	simple_set_mnt(mnt, sb);
> +
> +	return 0;
> 
>  	/* new mountpoint for an already mounted superblock */
>  already_mounted:
>  	DEBUG(1, "MTDSB: Device %d (\"%s\") is already mounted\n",
>  	      mtd->index, mtd->name);
> -	ret = simple_set_mnt(mnt, sb);
> +	simple_set_mnt(mnt, sb);
> +	ret = 0;
>  	goto out_put;
> 
>  out_error:
> diff --git a/fs/9p/vfs_super.c b/fs/9p/vfs_super.c
> index 93212e4..5f8ab8a 100644
> --- a/fs/9p/vfs_super.c
> +++ b/fs/9p/vfs_super.c
> @@ -168,8 +168,9 @@ static int v9fs_get_sb(struct file_system_type *fs_type, int flags,
>  	p9stat_free(st);
>  	kfree(st);
> 
> -P9_DPRINTK(P9_DEBUG_VFS, " return simple set mount\n");
> -	return simple_set_mnt(mnt, sb);
> +P9_DPRINTK(P9_DEBUG_VFS, " simple set mount, return 0\n");
> +	simple_set_mnt(mnt, sb);
> +	return 0;
> 
>  release_sb:
>  	if (sb) {
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 13ea532..38491fd 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -606,7 +606,8 @@ cifs_get_sb(struct file_system_type *fs_type,
>  		return rc;
>  	}
>  	sb->s_flags |= MS_ACTIVE;
> -	return simple_set_mnt(mnt, sb);
> +	simple_set_mnt(mnt, sb);
> +	return 0;
>  }
> 
>  static ssize_t cifs_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
> diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
> index 5f3231b..d008105 100644
> --- a/fs/devpts/inode.c
> +++ b/fs/devpts/inode.c
> @@ -458,7 +458,8 @@ static int get_init_pts_sb(struct file_system_type *fs_type, int flags,
>  		s->s_flags |= MS_ACTIVE;
>  	}
>  	do_remount_sb(s, flags, data, 0);
> -	return simple_set_mnt(mnt, s);
> +	simple_set_mnt(mnt, s);
> +	return 0;
>  }
> 
>  /*
> diff --git a/fs/libfs.c b/fs/libfs.c
> index 49b4409..8e77e11 100644
> --- a/fs/libfs.c
> +++ b/fs/libfs.c
> @@ -242,7 +242,8 @@ int get_sb_pseudo(struct file_system_type *fs_type, char *name,
>  	d_instantiate(dentry, root);
>  	s->s_root = dentry;
>  	s->s_flags |= MS_ACTIVE;
> -	return simple_set_mnt(mnt, s);
> +	simple_set_mnt(mnt, s);
> +	return 0;
> 
>  Enomem:
>  	up_write(&s->s_umount);
> diff --git a/fs/namespace.c b/fs/namespace.c
> index 228d8c4..c2594d5 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -397,11 +397,10 @@ static void __mnt_unmake_readonly(struct vfsmount *mnt)
>  	spin_unlock(&vfsmount_lock);
>  }
> 
> -int simple_set_mnt(struct vfsmount *mnt, struct super_block *sb)
> +void simple_set_mnt(struct vfsmount *mnt, struct super_block *sb)
>  {
>  	mnt->mnt_sb = sb;
>  	mnt->mnt_root = dget(sb->s_root);
> -	return 0;
>  }
> 
>  EXPORT_SYMBOL(simple_set_mnt);
> diff --git a/fs/proc/root.c b/fs/proc/root.c
> index f6299a2..1e15a2b 100644
> --- a/fs/proc/root.c
> +++ b/fs/proc/root.c
> @@ -83,7 +83,8 @@ static int proc_get_sb(struct file_system_type *fs_type,
>  		ns->proc_mnt = mnt;
>  	}
> 
> -	return simple_set_mnt(mnt, sb);
> +	simple_set_mnt(mnt, sb);
> +	return 0;
>  }
> 
>  static void proc_kill_sb(struct super_block *sb)
> diff --git a/fs/super.c b/fs/super.c
> index 645e540..17e05f1 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -813,7 +813,8 @@ int get_sb_bdev(struct file_system_type *fs_type,
>  		bdev->bd_super = s;
>  	}
> 
> -	return simple_set_mnt(mnt, s);
> +	simple_set_mnt(mnt, s);
> +	return 0;
> 
>  error_s:
>  	error = PTR_ERR(s);
> @@ -859,7 +860,8 @@ int get_sb_nodev(struct file_system_type *fs_type,
>  		return error;
>  	}
>  	s->s_flags |= MS_ACTIVE;
> -	return simple_set_mnt(mnt, s);
> +	simple_set_mnt(mnt, s);
> +	return 0;
>  }
> 
>  EXPORT_SYMBOL(get_sb_nodev);
> @@ -891,7 +893,8 @@ int get_sb_single(struct file_system_type *fs_type,
>  		s->s_flags |= MS_ACTIVE;
>  	}
>  	do_remount_sb(s, flags, data, 0);
> -	return simple_set_mnt(mnt, s);
> +	simple_set_mnt(mnt, s);
> +	return 0;
>  }
> 
>  EXPORT_SYMBOL(get_sb_single);
> diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
> index 89556ee..cd01c06 100644
> --- a/fs/ubifs/super.c
> +++ b/fs/ubifs/super.c
> @@ -2032,7 +2032,8 @@ static int ubifs_get_sb(struct file_system_type *fs_type, int flags,
>  	/* 'fill_super()' opens ubi again so we must close it here */
>  	ubi_close_volume(ubi);
> 
> -	return simple_set_mnt(mnt, sb);
> +	simple_set_mnt(mnt, sb);
> +	return 0;
> 
>  out_deact:
>  	up_write(&sb->s_umount);
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 6022f44..e60b263 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1600,7 +1600,7 @@ struct super_block *sget(struct file_system_type *type,
>  extern int get_sb_pseudo(struct file_system_type *, char *,
>  	const struct super_operations *ops, unsigned long,
>  	struct vfsmount *mnt);
> -extern int simple_set_mnt(struct vfsmount *mnt, struct super_block *sb);
> +extern void simple_set_mnt(struct vfsmount *mnt, struct super_block *sb);
>  int __put_super_and_need_restart(struct super_block *sb);
> 
>  /* Alas, no aliases. Too much hassle with bringing module.h everywhere */
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 5a54ff4..741f5c6 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -1071,7 +1071,8 @@ static int cgroup_get_sb(struct file_system_type *fs_type,
>  		mutex_unlock(&cgroup_mutex);
>  	}
> 
> -	return simple_set_mnt(mnt, sb);
> +	simple_set_mnt(mnt, sb);
> +	return 0;
> 
>   free_cg_links:
>  	free_cg_links(&tmp_cg_links);
> -- 
> 1.5.2.5
