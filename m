Return-Path: <linux-kernel-owner+w=401wt.eu-S1759823AbXH1BTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759823AbXH1BTk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 21:19:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752908AbXH1BTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 21:19:32 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:38089 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777AbXH1BTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 21:19:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iWGQIndcbRIK3A5ucFi6VmGvAmbQFwop3hH6qdIoHW7+JPIvpz0660Kh0KgsrJIUKsaGWqDIcBwkdaSfFxd4kbaXIalNyscLq9HP7XxBaHwp4tedWK4ZjXjYogIg3+NtgFuSUTWf2ivl7wkYxxriTmM+dzjCp5AuSzG11gYMDcw=
Message-ID: <dda83e780708271819x247ac49dx981c49a80ed6a999@mail.gmail.com>
Date: Mon, 27 Aug 2007 18:19:29 -0700
From: "Bret Towe" <magnade@gmail.com>
To: "Trond Myklebust" <trond.myklebust@fys.uio.no>
Subject: Re: NFS woes again Was: [linux-usb-devel] USB-related oops in sysfs with linux v2.6.23-rc3-50-g28e8351
Cc: "Florin Iucha" <florin@iucha.net>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
In-Reply-To: <1188220651.6701.32.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0708151656070.2460@twin.jikos.cz>
	 <Pine.LNX.4.64.0708211502330.2460@twin.jikos.cz>
	 <20070821131759.GI10422@iucha.net> <20070821132704.GJ10422@iucha.net>
	 <Pine.LNX.4.64.0708211536560.2460@twin.jikos.cz>
	 <20070822132200.GO10422@iucha.net> <20070823125210.GQ10422@iucha.net>
	 <dda83e780708231014x66093dafj83263a2a1c8203bb@mail.gmail.com>
	 <20070823173637.GS10422@iucha.net>
	 <1188220651.6701.32.camel@heimdal.trondhjem.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/27/07, Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
> On Thu, 2007-08-23 at 12:36 -0500, Florin Iucha wrote:
> > On Thu, Aug 23, 2007 at 10:14:38AM -0700, Bret Towe wrote:
> > > this sounds alot like the post i did yesterday titled 'nfs4 hang regression'
> > > i tracked it down to commit 3d39c691ff486142dd9aaeac12f553f4476b7a6
> >
> > Yes, it certainly does -- all the symptoms match!
> >
> > I'm not [alone in] seeing dead keyboards!
> >
> > Now, if only somebody could clarify to me the connection between
> > the bad NFS4 shooting the keyboard but not the mouse, that would
> > be wonderful.
> >
> > florin
>
> Could you and Bret please check if the attached patch fixes the hang?

no good for me still hangs after ~30minutes

> Cheers
>   Trond
>
>
>
>
> ---------- Forwarded message ----------
> From: Trond Myklebust <Trond.Myklebust@netapp.com>
> To:
> Date: Mon, 27 Aug 2007 09:14:56 -0400
> Subject: No Subject
> We need to ensure that nobody adds anything to nfs_automount_list while we
> are killing off the work queue entry, or else nfs_expire_automounts will
> simply rearm it, and we hang.
>
> Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
> ---
>
>  fs/nfs/namespace.c |   14 +++++++++++++-
>  1 files changed, 13 insertions(+), 1 deletions(-)
>
> diff --git a/fs/nfs/namespace.c b/fs/nfs/namespace.c
> index aea76d0..bcd0777 100644
> --- a/fs/nfs/namespace.c
> +++ b/fs/nfs/namespace.c
> @@ -22,6 +22,11 @@ static void nfs_expire_automounts(struct work_struct *work);
>
>  LIST_HEAD(nfs_automount_list);
>  static DECLARE_DELAYED_WORK(nfs_automount_task, nfs_expire_automounts);
> +/*
> + * The following mutex prevents nfs_follow_mountpoint from adding new
> + * entries to nfs_automount_list
> + */
> +static DEFINE_MUTEX(nfs_automount_mutex);
>  int nfs_mountpoint_expiry_timeout = 500 * HZ;
>
>  static struct vfsmount *nfs_do_submount(const struct vfsmount *mnt_parent,
> @@ -128,18 +133,21 @@ static void * nfs_follow_mountpoint(struct dentry *dentry, struct nameidata *nd)
>                 goto out_err;
>
>         mntget(mnt);
> +       mutex_lock(&nfs_automount_mutex);
>         err = do_add_mount(mnt, nd, nd->mnt->mnt_flags|MNT_SHRINKABLE, &nfs_automount_list);
>         if (err < 0) {
> +               mutex_unlock(&nfs_automount_mutex);
>                 mntput(mnt);
>                 if (err == -EBUSY)
>                         goto out_follow;
>                 goto out_err;
>         }
> +       schedule_delayed_work(&nfs_automount_task, nfs_mountpoint_expiry_timeout);
> +       mutex_unlock(&nfs_automount_mutex);
>         mntput(nd->mnt);
>         dput(nd->dentry);
>         nd->mnt = mnt;
>         nd->dentry = dget(mnt->mnt_root);
> -       schedule_delayed_work(&nfs_automount_task, nfs_mountpoint_expiry_timeout);
>  out:
>         dprintk("%s: done, returned %d\n", __FUNCTION__, err);
>
> @@ -175,8 +183,12 @@ static void nfs_expire_automounts(struct work_struct *work)
>
>  void nfs_release_automount_timer(void)
>  {
> +       if (!list_empty(&nfs_automount_list))
> +               return;
> +       mutex_lock(&nfs_automount_mutex);
>         if (list_empty(&nfs_automount_list))
>                 cancel_delayed_work_sync(&nfs_automount_task);
> +       mutex_unlock(&nfs_automount_mutex);
>  }
>
>  /*
>
>
