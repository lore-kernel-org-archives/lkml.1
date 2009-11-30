Return-Path: <linux-kernel-owner+w=401wt.eu-S1753143AbZK3Cof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143AbZK3Cof (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 21:44:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752458AbZK3Coe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 21:44:34 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:50069 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbZK3Cod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 21:44:33 -0500
Date: Sun, 29 Nov 2009 21:44:04 -0500
Message-Id: <200911300244.nAU2i41s007505@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Valerie Aurora <vaurora@redhat.com>
Cc: Jan Blunck <jblunck@suse.de>, Ian Kent <raven@themaw.net>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Andy Whitcroft <apw@canonical.com>,
       Scott James Remnant <scott@canonical.com>,
       Sandu Popa Marius <sandupopamarius@gmail.com>,
       Jan Rekorajski <baggins@sith.mimuw.edu.pl>,
       "J. R. Okajima" <hooanon05@yahoo.co.jp>, Arnd Bergmann <arnd@arndb.de>,
       Vladimir Dronnikov <dronnikov@gmail.com>,
       Felix Fietkau <nbd@openwrt.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jan Blunck <jblunck@infradead.org>
Subject: Re: [PATCH 08/41] Don't replace nameidata path when following links 
In-reply-to: Your message of "Wed, 21 Oct 2009 12:19:06 PDT."
             <1256152779-10054-9-git-send-email-vaurora@redhat.com> 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <1256152779-10054-9-git-send-email-vaurora@redhat.com>, Valerie Aurora writes:
> From: Jan Blunck <jblunck@infradead.org>
> 
> For autofs4 the commit 051d381259eb57d6074d02a6ba6e90e744f1a29f introduced
> some code that is replacing the path embedded in the nameidata with the
> path of the link itself. This was done to have access to the struct
> vfsmount in the autofs4_follow_link function. Instead autofs4 should
> remember the struct vfsmount when it is mounted.

This is an autofs4 patch, mainly: say so in the subject line:

     VFS/Autofs4: don't replace nameidata ...

I'm curious why wasn't Ian Kent CC'ed on this patch originally?  I added him
to the CC list now.

And what does this patch have to do with union mounts?  Can you document why
you needed this change made?

Lastly, if this patch is acceptable to all parties, then it should be pushed
to the autofs4 maintainers and hopefully upstream well before UM.

> ---
>  fs/autofs4/autofs_i.h |    1 +
>  fs/autofs4/init.c     |   11 ++++++++++-
>  fs/autofs4/root.c     |    6 ++++++
>  fs/namei.c            |    7 ++-----
>  4 files changed, 19 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/autofs4/autofs_i.h b/fs/autofs4/autofs_i.h
> index 8f7cdde..db2bfce 100644
> --- a/fs/autofs4/autofs_i.h
> +++ b/fs/autofs4/autofs_i.h
> @@ -130,6 +130,7 @@ struct autofs_sb_info {
>  	int reghost_enabled;
>  	int needs_reghost;
>  	struct super_block *sb;
> +	struct vfsmount *mnt;
>  	struct mutex wq_mutex;
>  	spinlock_t fs_lock;
>  	struct autofs_wait_queue *queues; /* Wait queue pointer */
> diff --git a/fs/autofs4/init.c b/fs/autofs4/init.c
> index 9722e4b..5e0dcd7 100644
> --- a/fs/autofs4/init.c
> +++ b/fs/autofs4/init.c
> @@ -17,7 +17,16 @@
>  static int autofs_get_sb(struct file_system_type *fs_type,
>  	int flags, const char *dev_name, void *data, struct vfsmount *mnt)
>  {
> -	return get_sb_nodev(fs_type, flags, data, autofs4_fill_super, mnt);
> +	struct autofs_sb_info *sbi;
> +	int ret;
> +
> +	ret = get_sb_nodev(fs_type, flags, data, autofs4_fill_super, mnt);
> +	if (ret)
> +		return ret;
> +
> +	sbi = autofs4_sbi(mnt->mnt_sb);
> +	sbi->mnt = mnt;
> +	return 0;
>  }
>  
>  static struct file_system_type autofs_fs_type = {
> diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
> index b96a3c5..cb991b8 100644
> --- a/fs/autofs4/root.c
> +++ b/fs/autofs4/root.c
> @@ -179,6 +179,12 @@ static void *autofs4_follow_link(struct dentry *dentry, struct nameidata *nd)
>  	DPRINTK("dentry=%p %.*s oz_mode=%d nd->flags=%d",
>  		dentry, dentry->d_name.len, dentry->d_name.name, oz_mode,
>  		nd->flags);
> +
> +	dput(nd->path.dentry);
> +	mntput(nd->path.mnt);
> +	nd->path.mnt = mntget(sbi->mnt);
> +	nd->path.dentry = dget(dentry);
> +
>  	/*
>  	 * For an expire of a covered direct or offset mount we need
>  	 * to break out of follow_down() at the autofs mount trigger
> diff --git a/fs/namei.c b/fs/namei.c
> index a338496..46cf1cb 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -636,11 +636,8 @@ static __always_inline int __do_follow_link(struct path *path, struct nameidata
>  	touch_atime(path->mnt, dentry);
>  	nd_set_link(nd, NULL);
>  
> -	if (path->mnt != nd->path.mnt) {
> -		path_to_nameidata(path, nd);
> -		dget(dentry);
> -	}
> -	mntget(path->mnt);
> +	if (path->mnt == nd->path.mnt)
> +		mntget(nd->path.mnt);
>  	cookie = dentry->d_inode->i_op->follow_link(dentry, nd);
>  	error = PTR_ERR(cookie);
>  	if (!IS_ERR(cookie)) {

Just want to mention that the five lines you replace with the two lines, in
the above patch snippet, are not functionally equivalent.  Is this the
intention of "reversing" what commit
051d381259eb57d6074d02a6ba6e90e744f1a29f introduced?  If not, then please
explain the change in __do_follow_link.

Thanks,
Erez.
