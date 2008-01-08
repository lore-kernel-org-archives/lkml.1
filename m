Return-Path: <linux-kernel-owner+w=401wt.eu-S1756765AbYAHTU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756765AbYAHTU0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 14:20:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753738AbYAHTUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 14:20:09 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:45565 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbYAHTUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 14:20:07 -0500
To: haveblue@us.ibm.com
CC: akpm@linux-foundation.org, hch@infradead.org, serue@us.ibm.com,
       viro@ftp.linux.org.uk, ebiederm@xmission.com, kzak@redhat.com,
       linux-fsdevel@vger.kernel.org, containers@lists.osdl.org,
       util-linux-ng@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <1199816327.9834.63.camel@localhost> (message from Dave Hansen on
	Tue, 08 Jan 2008 10:18:47 -0800)
Subject: Re: [patch 3/9] unprivileged mounts: account user mounts
References: <20080108113502.184459371@szeredi.hu>
	 <20080108113623.446872155@szeredi.hu> <1199816327.9834.63.camel@localhost>
Message-Id: <E1JCJyA-0003i9-Vf@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 08 Jan 2008 20:18:38 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 2008-01-08 at 12:35 +0100, Miklos Szeredi wrote:
> > plain text document attachment
> > (unprivileged-mounts-account-user-mounts.patch)
> > From: Miklos Szeredi <mszeredi@suse.cz>
> > 
> > Add sysctl variables for accounting and limiting the number of user
> > mounts.
> ...
> > +int nr_user_mounts;
> > +int max_user_mounts = 1024;
> 
> Just from a containers point of view, I think this is something we'll
> need to fix up in the near future if it stays in the current form.
> 
> Instead of having a global tracking, perhaps we could have a per-user
> limit tracked in 'struct user'.  The plans are to ensure that two
> containers' users "dave" each have a different 'struct user', so that
> seems to be a decent place to track it.

At one time there was a per-user accounting patch, but it was dropped,
because it was deemed an unnecessary additional compexity.

max_user_mounts is analogue to files_stat.max_files (which is a sysctl
tunable also), and it's purpose is really to make sure that a user is
not able to create an insane number of mounts, and not to acurately
limit normal usage.

So I'm not sure a per-container or per-user count is really needed.

> Also, is a read-only sysctl really the best way to get the number of
> user mounts back out of the kernel?  What would you use it for?

Just to check, why I got that (EPERM or whatever) error for the mount
command.

> Do you need any special logic for setting 'max_user_mounts' in the case
> where it gets set _below_ 'nr_user_mounts'?

No, I don't think such corner cases really matter in this case.

> >  /* /sys/fs */
> >  struct kobject *fs_kobj;
> >  EXPORT_SYMBOL_GPL(fs_kobj);
> > @@ -477,11 +480,30 @@ static struct vfsmount *skip_mnt_tree(st
> >  	return p;
> >  }
> > 
> > +static void dec_nr_user_mounts(void)
> > +{
> > +	spin_lock(&vfsmount_lock);
> > +	nr_user_mounts--;
> > +	spin_unlock(&vfsmount_lock);
> > +}
> > +
> >  static void set_mnt_user(struct vfsmount *mnt)
> >  {
> >  	BUG_ON(mnt->mnt_flags & MNT_USER);
> >  	mnt->mnt_uid = current->fsuid;
> >  	mnt->mnt_flags |= MNT_USER;
> > +	spin_lock(&vfsmount_lock);
> > +	nr_user_mounts++;
> > +	spin_unlock(&vfsmount_lock);
> > +}
> 
> One little nitpick on the patch layout:  It's a wee bit difficult to
> audit how the set function is used vs the clear one when its users don't
> come until the later patches.  It might be worth introducing the users
> here, too.

Yeah, maybe some of the patches should be folded together.  If a
resubmit is necessary I'll look into that.

Miklos
