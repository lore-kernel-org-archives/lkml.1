Return-Path: <linux-kernel-owner+w=401wt.eu-S1757375AbYAHTWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375AbYAHTWv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 14:22:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757217AbYAHTWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 14:22:41 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:55144 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407AbYAHTWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 14:22:39 -0500
To: haveblue@us.ibm.com
CC: miklos@szeredi.hu, akpm@linux-foundation.org, hch@infradead.org,
       serue@us.ibm.com, viro@ftp.linux.org.uk, ebiederm@xmission.com,
       kzak@redhat.com, linux-fsdevel@vger.kernel.org,
       containers@lists.osdl.org, util-linux-ng@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-reply-to: <1199816786.9834.70.camel@localhost> (message from Dave Hansen on
	Tue, 08 Jan 2008 10:26:26 -0800)
Subject: Re: [patch 5/9] unprivileged mounts: allow unprivileged bind mounts
References: <20080108113502.184459371@szeredi.hu>
	 <20080108113626.895583537@szeredi.hu> <1199816786.9834.70.camel@localhost>
Message-Id: <E1JCK11-0003ik-4f@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 08 Jan 2008 20:21:35 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > @@ -510,10 +533,16 @@ static struct vfsmount *clone_mnt(struct
> >                                         int flag)
> >  {
> >         struct super_block *sb = old->mnt_sb;
> > -       struct vfsmount *mnt = alloc_vfsmnt(old->mnt_devname);
> > +       struct vfsmount *mnt;
> > 
> > +       if (flag & CL_SETUSER) {
> > +               int err = reserve_user_mount();
> > +               if (err)
> > +                       return ERR_PTR(err);
> > +       }
> > +       mnt = alloc_vfsmnt(old->mnt_devname);
> >         if (!mnt)
> > -               return ERR_PTR(-ENOMEM);
> > +               goto alloc_failed;
> > 
> >         mnt->mnt_flags = old->mnt_flags;
> >         atomic_inc(&sb->s_active); 
> 
> I think there's a little race here.  We could have several users racing
> to get to this point when nr_user_mounts==max_user_mounts-1.  One user
> wins the race and gets their mount reserved.  The others get the error
> out of reserve_user_mount(), and return.
> 
> But, the winner goes on to error out on some condition further down in
> clone_mnt() and never actually instantiates the mount.
> 
> Do you think this is a problem?

For similar reasons as stated in the previous mail, I don't think this
matters.  If nr_user_mounts is getting remotely close to
max_user_mounts, then something is wrong (or the max needs to be
raised anyway).

Thanks for the review, Dave!

Miklos
