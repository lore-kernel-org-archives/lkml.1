Return-Path: <linux-kernel-owner+w=401wt.eu-S1755725AbZEGUg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725AbZEGUg0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 16:36:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763195AbZEGUfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 16:35:51 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:8774 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762013AbZEGUft convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 16:35:49 -0400
MIME-Version: 1.0
In-Reply-To: <20090307181232.GF30072@us.ibm.com>
References: <20090307180816.GA30072@us.ibm.com>
	 <20090307181232.GF30072@us.ibm.com>
Date: Thu, 7 May 2009 16:35:49 -0400
Message-ID: <7e0fb38c0905071335g7ebe972xa82faa1161f7ff0b@mail.gmail.com>
Subject: Re: [v3][PATCH 5/5] Merge code for single and multiple-instance 
	mounts
From: Eric Paris <eparis@parisplace.org>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@osdl.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, serue@us.ibm.com, hpa@zytor.com,
       sukadev@us.ibm.com, linux-kernel@vger.kernel.org, eparis@redhat.com,
       jbacik@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 7, 2009 at 2:12 PM, Sukadev Bhattiprolu
<sukadev@linux.vnet.ibm.com> wrote:
>
> From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> Subject: [v3][PATCH 5/5] Merge code for single and multiple-instance mounts

I just tried to load the linux-next kernel on F11 and ran into a
problem.  X started, I could log in, I could start programs like
firefox and evolution, but not gnome-terminal.  It would just flash
and disappear.  Running xterm resulted in a window, that I could type
in, but it wasn't a shell.  It didn't do anything.

I switched to vt2 set the display to my X session and tried to run
xterm.  It said something about a permission being denied, so I
decided to strace it.  I saw EACCESS returning from calls dealing with
/dev/pts/0.  This lead me to git bisect start fs/devpts from the
latest in linux-next as bad and 2.6.29 as good.  Couple interations
later and I find that this commit (1bd7903560f1f7) breaks
gnome-terminal xterm!

So I have no idea why and haven't tried to figure it out (I'll try to
poke it more tonight), but this is the commit that git bisect blames!


> new_pts_mount() (including the get_sb_nodev()), shares a lot of code
> with init_pts_mount(). The only difference between them is the 'test-super'
> function passed into sget().
>
> Move all common code into devpts_get_sb() and remove the new_pts_mount() and
> init_pts_mount() functions,
>
> Changelog[v3]:
>        [Serge Hallyn]: Remove unnecessary printk()s
> Changelog[v2]:
>        (Christoph Hellwig): Merge code in 'do_pts_mount()' into devpts_get_sb()
>
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> Acked-by: Serge Hallyn <serue@us.ibm.com>
> Tested-by: Serge Hallyn <serue@us.ibm.com>
> ---
>  fs/devpts/inode.c |  115 ++++++++++++++++++----------------------------------
>  1 files changed, 40 insertions(+), 75 deletions(-)
>
> diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
> index c821c9a..c25fb34 100644
> --- a/fs/devpts/inode.c
> +++ b/fs/devpts/inode.c
> @@ -325,87 +325,38 @@ static int compare_init_pts_sb(struct super_block *s, void *p)
>  }
>
>  /*
> - * Mount a new (private) instance of devpts.  PTYs created in this
> - * instance are independent of the PTYs in other devpts instances.
> - */
> -static int new_pts_mount(struct file_system_type *fs_type, int flags,
> -               void *data, struct pts_mount_opts *opts, struct vfsmount *mnt)
> -{
> -       int err;
> -       struct pts_fs_info *fsi;
> -
> -       printk(KERN_NOTICE "devpts: newinstance mount\n");
> -
> -       err = get_sb_nodev(fs_type, flags, data, devpts_fill_super, mnt);
> -       if (err)
> -               return err;
> -
> -       fsi = DEVPTS_SB(mnt->mnt_sb);
> -       memcpy(&fsi->mount_opts, opts, sizeof(opts));
> -
> -       return 0;
> -}
> -
> -/*
> - * init_pts_mount()
> + * devpts_get_sb()
> + *
> + *     If the '-o newinstance' mount option was specified, mount a new
> + *     (private) instance of devpts.  PTYs created in this instance are
> + *     independent of the PTYs in other devpts instances.
>  *
> - *     Mount or remount the initial kernel mount of devpts. This type of
> - *     mount maintains the legacy, single-instance semantics, while the
> - *     kernel still allows multiple-instances.
> + *     If the '-o newinstance' option was not specified, mount/remount the
> + *     initial kernel mount of devpts.  This type of mount gives the
> + *     legacy, single-instance semantics.
>  *
> - *     This interface is needed to support multiple namespace semantics in
> - *     devpts while preserving backward compatibility of the current 'single-
> - *     namespace' semantics. i.e all mounts of devpts without the 'newinstance'
> - *     mount option should bind to the initial kernel mount, like
> - *     get_sb_single().
> + *     The 'newinstance' option is needed to support multiple namespace
> + *     semantics in devpts while preserving backward compatibility of the
> + *     current 'single-namespace' semantics. i.e all mounts of devpts
> + *     without the 'newinstance' mount option should bind to the initial
> + *     kernel mount, like get_sb_single().
>  *
> - *     Mounts with 'newinstance' option create a new private namespace.
> + *     Mounts with 'newinstance' option create a new, private namespace.
>  *
> - *     But for single-mount semantics, devpts cannot use get_sb_single(),
> + *     NOTE:
> + *
> + *     For single-mount semantics, devpts cannot use get_sb_single(),
>  *     because get_sb_single()/sget() find and use the super-block from
>  *     the most recent mount of devpts. But that recent mount may be a
>  *     'newinstance' mount and get_sb_single() would pick the newinstance
>  *     super-block instead of the initial super-block.
> - *
> - *     This interface is identical to get_sb_single() except that it
> - *     consistently selects the 'single-namespace' superblock even in the
> - *     presence of the private namespace (i.e 'newinstance') super-blocks.
>  */
> -static int init_pts_mount(struct file_system_type *fs_type, int flags,
> -               void *data, struct pts_mount_opts *opts, struct vfsmount *mnt)
> -{
> -       struct super_block *s;
> -       struct pts_fs_info *fsi;
> -       int error;
> -
> -       s = sget(fs_type, compare_init_pts_sb, set_anon_super, NULL);
> -       if (IS_ERR(s))
> -               return PTR_ERR(s);
> -
> -       if (!s->s_root) {
> -               s->s_flags = flags;
> -               error = devpts_fill_super(s, data, flags & MS_SILENT ? 1 : 0);
> -               if (error) {
> -                       up_write(&s->s_umount);
> -                       deactivate_super(s);
> -                       return error;
> -               }
> -               s->s_flags |= MS_ACTIVE;
> -       }
> -
> -       simple_set_mnt(mnt, s);
> -
> -       fsi = DEVPTS_SB(mnt->mnt_sb);
> -       memcpy(&fsi->mount_opts, opts, sizeof(opts));
> -
> -       return 0;
> -}
> -
>  static int devpts_get_sb(struct file_system_type *fs_type,
>        int flags, const char *dev_name, void *data, struct vfsmount *mnt)
>  {
>        int error;
>        struct pts_mount_opts opts;
> +       struct super_block *s;
>
>        memset(&opts, 0, sizeof(opts));
>        if (data) {
> @@ -415,23 +366,37 @@ static int devpts_get_sb(struct file_system_type *fs_type,
>        }
>
>        if (opts.newinstance)
> -               error = new_pts_mount(fs_type, flags, data, &opts, mnt);
> +               s = sget(fs_type, NULL, set_anon_super, NULL);
>        else
> -               error = init_pts_mount(fs_type, flags, data, &opts, mnt);
> +               s = sget(fs_type, compare_init_pts_sb, set_anon_super, NULL);
>
> -       if (error)
> -               return error;
> +       if (IS_ERR(s))
> +               return PTR_ERR(s);
>
> -       error = mknod_ptmx(mnt->mnt_sb);
> +       if (!s->s_root) {
> +               s->s_flags = flags;
> +               error = devpts_fill_super(s, data, flags & MS_SILENT ? 1 : 0);
> +               if (error)
> +                       goto out_undo_sget;
> +               s->s_flags |= MS_ACTIVE;
> +       }
> +
> +       simple_set_mnt(mnt, s);
> +
> +       memcpy(&(DEVPTS_SB(s))->mount_opts, &opts, sizeof(opts));
> +
> +       error = mknod_ptmx(s);
>        if (error)
>                goto out_dput;
>
>        return 0;
>
>  out_dput:
> -       dput(mnt->mnt_sb->s_root);
> -       up_write(&mnt->mnt_sb->s_umount);
> -       deactivate_super(mnt->mnt_sb);
> +       dput(s->s_root);
> +
> +out_undo_sget:
> +       up_write(&s->s_umount);
> +       deactivate_super(s);
>        return error;
>  }
>
> --
> 1.5.2.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
