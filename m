Return-Path: <linux-kernel-owner+w=401wt.eu-S932192AbYETNGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932192AbYETNGy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 09:06:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762350AbYETNGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 09:06:43 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:50008 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754421AbYETNGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 09:06:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=n0Q1VGwxdxsQA6jK8QQvboEbdY6PPD7xnYIblTF6PEaTGTroc3htfZ/cqv6tfu11QLKEH5Bkim92rV2anuK7y1cKN9hZuZ9OFJG4qg+0Y6BNSB4W92udVc5dCP0gidbuB92NHQiRTqMgRvDLJYF48eCYbgDXEpGYRbCbBmXsr0A=
Message-ID: <7b9198260805200606u6ebc2681o8af7a8eebc1cb96@mail.gmail.com>
Date: Tue, 20 May 2008 14:06:42 +0100
From: "Tom Spink" <tspink@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] Introduce filesystem type tracking
Cc: linux-fsdevel@vger.kernel.org, "Alexander Viro" <viro@zeniv.linux.org.uk>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <1211196126-7442-1-git-send-email-tspink@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <> <1211196126-7442-1-git-send-email-tspink@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/5/19 Tom Spink <tspink@gmail.com>:
> Hi,
>
> This email contains an RFC patch that introduces init and exit routines to
> the file_system_type structure.  These routines were mentioned in
> an email I saw about XFS starting threads that aren't needed when no
> XFS filesystems are mounted.
>
> So I decided to try and implement the infrastructure to do this.
>
> Please let me know what you think, I'm pretty sure I'll be missing
> something I won't know about (like a lock, or a refcount), but feedback
> would be appreciated.
>
> --
>
> This patch adds tracking to filesystem types, whereby the number of mounts
> of a particular filesystem type can be determined.  This has the added
> benefit of introducing init and exit routines for filesystem types, which
> are called on the first mount and last unmount of the filesystem type,
> respectively.
>
> This is useful for filesystems which share global resources between all
> mounts, but only need these resources when at least one filesystem is
> mounted.  For example, XFS creates a number of kernel threads which aren't
> required when there are no XFS filesystems mounted.  This patch will allow
> XFS to start those threads just before the first filesystem is mounted, and
> to shut them down when the last filesystem has been unmounted.
>
> Signed-off-by: Tom Spink <tspink@gmail.com>
> ---
>  fs/namespace.c     |    9 +++++++++
>  fs/super.c         |   25 +++++++++++++++++++++++++
>  include/linux/fs.h |    3 +++
>  3 files changed, 37 insertions(+), 0 deletions(-)
>
> diff --git a/fs/namespace.c b/fs/namespace.c
> index 4fc302c..bfa2f39 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -1025,6 +1025,7 @@ static void shrink_submounts(struct vfsmount *mnt, struct list_head *umounts);
>  static int do_umount(struct vfsmount *mnt, int flags)
>  {
>        struct super_block *sb = mnt->mnt_sb;
> +       struct file_system_type *type = sb->s_type;
>        int retval;
>        LIST_HEAD(umount_list);
>
> @@ -1108,6 +1109,14 @@ static int do_umount(struct vfsmount *mnt, int flags)
>                security_sb_umount_busy(mnt);
>        up_write(&namespace_sem);
>        release_mounts(&umount_list);
> +
> +       /* Check to see if the unmount is successful, and we're unmounting the
> +        * last filesystem of this type.  If we are, run the exit routine of
> +        * the filesystem type.
> +        */
> +       if (retval == 0 && ((--type->nr_mounts == 0) && type->exit))
> +               type->exit();
> +
>        return retval;
>  }
>
> diff --git a/fs/super.c b/fs/super.c
> index 453877c..e1dba4b 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -961,14 +961,39 @@ static struct vfsmount *fs_set_subtype(struct vfsmount *mnt, const char *fstype)
>  struct vfsmount *
>  do_kern_mount(const char *fstype, int flags, const char *name, void *data)
>  {
> +       int rc;
>        struct file_system_type *type = get_fs_type(fstype);
>        struct vfsmount *mnt;
>        if (!type)
>                return ERR_PTR(-ENODEV);
> +
> +       /* If this is the first mount, then initialise the filesystem type. */
> +       if (type->nr_mounts == 0 && type->init) {
> +               rc = type->init();
> +
> +               /* If initialisation failed, pass the error back down the chain. */
> +               if (rc) {
> +                       put_filesystem(type);
> +                       return ERR_PTR(rc);
> +               }
> +       }
> +
>        mnt = vfs_kern_mount(type, flags, name, data);
>        if (!IS_ERR(mnt) && (type->fs_flags & FS_HAS_SUBTYPE) &&
>            !mnt->mnt_sb->s_subtype)
>                mnt = fs_set_subtype(mnt, fstype);
> +
> +       /* Check to see if the mount was successful, and if so, increment
> +        * the mount counter.  Otherwise, if we initialised the filesystem
> +        * type already (and the mount just failed), we need to shut it
> +        * back down.
> +        */
> +       if (!IS_ERR(mnt)) {
> +               type->nr_mounts++;
> +       } else if (type->nr_mounts == 0 && type->exit) {
> +               type->exit();
> +       }
> +
>        put_filesystem(type);
>        return mnt;
>  }
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index f413085..ba92056 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1474,9 +1474,12 @@ int sync_inode(struct inode *inode, struct writeback_control *wbc);
>  struct file_system_type {
>        const char *name;
>        int fs_flags;
> +       int nr_mounts;
>        int (*get_sb) (struct file_system_type *, int,
>                       const char *, void *, struct vfsmount *);
>        void (*kill_sb) (struct super_block *);
> +       int (*init) (void);
> +       void (*exit) (void);
>        struct module *owner;
>        struct file_system_type * next;
>        struct list_head fs_supers;
> --
> 1.5.4.3
>
>

Hi,

I'm just adding people to CC here, but also I had a couple of thoughts
after reviewing my own code.

I see that do_kern_mount is encapsulated with the BKL, but would it be
wise to introduce a lock (e.g. a mutex) now for reading and updating
nr_mounts (and hence calling ->init), rather than wait for the BKL
removal to come round here?

Also, have I got all the cases where a filesystem is unmounted,
because I now see umount_tree, and am wondering if decrementing the
nr_mounts field should be done in here, in the loop of vfsmounts... or
is it sufficient to leave it at the end of do_umount?

-- 
Regards,
Tom Spink
