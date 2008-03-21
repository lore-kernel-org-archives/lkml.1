Return-Path: <linux-kernel-owner+w=401wt.eu-S1760858AbYCUUYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760858AbYCUUYV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 16:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755296AbYCUUYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 16:24:06 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:55057 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755259AbYCUUYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 16:24:04 -0400
To: viro@ZenIV.linux.org.uk
CC: miklos@szeredi.hu, haveblue@us.ibm.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, neilb@suse.de, akpm@linux-foundation.org,
       hch@infradead.org, linux-security-module@vger.kernel.org,
       jmorris@namei.org
In-reply-to: <20080321194931.GX10722@ZenIV.linux.org.uk> (message from Al Viro
	on Fri, 21 Mar 2008 19:49:31 +0000)
Subject: Re: r-o bind in nfsd
References: <E1Jciie-0001E6-Dx@pomaz-ex.szeredi.hu> <20080321155451.GU10722@ZenIV.linux.org.uk> <E1Jck2N-0001Q3-7W@pomaz-ex.szeredi.hu> <20080321163520.GV10722@ZenIV.linux.org.uk> <E1JckW9-0001Ub-Rs@pomaz-ex.szeredi.hu> <E1Jckjd-0001X8-IM@pomaz-ex.szeredi.hu> <20080321181105.GW10722@ZenIV.linux.org.uk> <E1JcmLz-0001n1-RC@pomaz-ex.szeredi.hu> <20080321194931.GX10722@ZenIV.linux.org.uk>
Message-Id: <E1Jcnm7-00020F-7o@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 21 Mar 2008 21:23:39 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > > And having the vfsmount available within vfs_...() functions means,
> > > > > that the mnt_want_write() check can be moved inside, which means that
> > > > > callers get simpler and less likely to be buggy.  Those are all
> > > > > advantages IMO, regardless of any security module issues.
> > > > 
> > > > Or we can introduce another set of exported functions (path_mkdir(),
> > > > ...), and leave vfs_...() alone.  And then the only question is if
> > > > LSM's can live with ordering change.
> > > 
> > > I really don't see the point of new helpers; especially since one doesn't
> > > have to _have_ vfsmount to use the old ones and since we don't have a lot
> > > of users of each of those to start with.
> > 
> > Traditionally we have syscalls, and nfsd.  Both of them want the
> > security checks, and I think nfsd wants the read-only mount checking
> > as well, but I'm not entirely sure.  Maybe we can handle that by just
> > making nfsd acquire a write-ref on the mount and keep it while it's
> > exported.
> > 
> > Then there's ecryptfs and unionfs, which probably need neither, but it
> > wouldn't hurt to do them anyway.
> > 
> > Still, even if there are only two callers, then moving stuff to up
> > doesn't make any sense.  Passing down a struct path is free for the
> > syscall case, it doesn't consume any stack space or extra CPU.  Do
> > please tell, why would that be such a bad thing?
> 
> Because we'd been that way before; see the shitpiles around ->lookup()
> getting nameidata, etc.  You'll end up with some callers passing NULL
> as ->mnt since they don't have anything better to pass, some stuff
> called *from* the damn thing caring to check for ->mnt being NULL,
> some stuff not caring about what ->mnt is at all and some assuming
> that it's not NULL.  Which will lead to exploding combinations that
> won't be noticed until somebody steps into such config.

Right, we do want to prevent that happening.

And for example moving read-only mount checks inside vfs_...() would
ensure that.

> As for the vfsmount-dependent checks (and any kind of MAC, while we are
> at it)...  They belong to callers, exactly because different callers may
> want different (amount of) checks.

And we end up random callers forgetting some of the checks, like we
have now with nfsd.  Not good at all.

I think it's still a lot better all the checks are always done, even
if not strictly necessary for a certain caller, than if the caller has
to make sure the necessary ones do get done.

Assuming of course, that all valid users _do_ have the vfsmount
available, which I think is true.  If you have a counterexample,
please let us know.

If not all (but most) callers have the vfsmount available, then a new
helper makes sense.

If there was only one caller which needed a certain check, then moving
that into the caller would be the right thing of course.  But that's
not the case here.

Miklos
