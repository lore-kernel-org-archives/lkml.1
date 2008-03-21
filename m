Return-Path: <linux-kernel-owner+w=401wt.eu-S1759755AbYCUQ4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759755AbYCUQ4U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 12:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758902AbYCUQzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 12:55:55 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:41392 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758116AbYCUQzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 12:55:53 -0400
To: viro@ZenIV.linux.org.uk
CC: miklos@szeredi.hu, haveblue@us.ibm.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, neilb@suse.de, akpm@linux-foundation.org,
       hch@infradead.org, linux-security-module@vger.kernel.org,
       jmorris@namei.org
In-reply-to: <20080321163520.GV10722@ZenIV.linux.org.uk> (message from Al Viro
	on Fri, 21 Mar 2008 16:35:20 +0000)
Subject: Re: r-o bind in nfsd
References: <E1Jciie-0001E6-Dx@pomaz-ex.szeredi.hu> <20080321155451.GU10722@ZenIV.linux.org.uk> <E1Jck2N-0001Q3-7W@pomaz-ex.szeredi.hu> <20080321163520.GV10722@ZenIV.linux.org.uk>
Message-Id: <E1JckW9-0001Ub-Rs@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 21 Mar 2008 17:54:57 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > I know there are a few cases, where filesystems call vfs_foo()
> > > > internally, where the vfsmount isn't available, but I think the proper
> > > > solution is just to fix those places, and not recurse back into the
> > > > VFS (which is AFAICS in all those cases totally unnecessary anyway).
> > > > This would make everybody happy, no?
> > > 
> > > Apparmor can go play with itself.  The proper fix is to lift the LSM nonsense
> > > into callers and leave vfs_...() alone;
> > 
> > Maybe.  I know precious little about this security thing, so I won't
> > argue about it's merits or faults.  But:
> > 
> >  a) I have a hunch that the security guys wouldn't like to see the
> >  order between permission() and security_foo() changed.
> 
> It's their problem.  Adjusting LSM methods, if needed, is up to LSM
> maintainers, whenever moving the hooks or code around those become
> convenient for kernel proper.  According to Linus, IIRC.
> 
> Especially since in this case they want to change prototypes anyway, so the
> churn is not an issue and having the hook called earlier is very unlikely to
> cause any problems.

CC-d linux-security-module, James Morris.

> 
> >  b) I fail to see how moving functionality to callers would improve
> >  things
> > 
> > > vfsmounts should *not* be passed there at all, with the exception of
> > > vfs_follow_link() which gets the full nameidata.
> > 
> > Why?
> 
> Because filesystem shouldn't _care_ where it is mounted.  Anything
> vfsmount-dependent belongs to upper layers.  The same goes for passing
> nameidata to fs methods, BTW - again, ->follow_link() is an obvious
> legitimate exception.

Nobody wants to send vfsmounts to the filesystem.  But vfs_...() are
still part of the "upper layer", not the filesystem, so I'm not
convinced yet.  For example:

-extern int vfs_mkdir(struct inode *, struct dentry *, int);
+extern int vfs_mkdir(const struct path *, struct dentry *, int);

There's one caller of vfs_mkdir that can't do this: cgroup_clone().
But that can call cgroup_mkdir() instead.

And having the vfsmount available within vfs_...() functions means,
that the mnt_want_write() check can be moved inside, which means that
callers get simpler and less likely to be buggy.  Those are all
advantages IMO, regardless of any security module issues.

Miklos
