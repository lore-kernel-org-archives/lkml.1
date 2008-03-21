Return-Path: <linux-kernel-owner+w=401wt.eu-S1756342AbYCUTtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756342AbYCUTtq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 15:49:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753882AbYCUTtg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 15:49:36 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47389 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848AbYCUTtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 15:49:35 -0400
Date: Fri, 21 Mar 2008 19:49:31 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: haveblue@us.ibm.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, neilb@suse.de, akpm@linux-foundation.org,
       hch@infradead.org, linux-security-module@vger.kernel.org,
       jmorris@namei.org
Subject: Re: r-o bind in nfsd
Message-ID: <20080321194931.GX10722@ZenIV.linux.org.uk>
References: <E1Jciie-0001E6-Dx@pomaz-ex.szeredi.hu> <20080321155451.GU10722@ZenIV.linux.org.uk> <E1Jck2N-0001Q3-7W@pomaz-ex.szeredi.hu> <20080321163520.GV10722@ZenIV.linux.org.uk> <E1JckW9-0001Ub-Rs@pomaz-ex.szeredi.hu> <E1Jckjd-0001X8-IM@pomaz-ex.szeredi.hu> <20080321181105.GW10722@ZenIV.linux.org.uk> <E1JcmLz-0001n1-RC@pomaz-ex.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1JcmLz-0001n1-RC@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2008 at 07:52:35PM +0100, Miklos Szeredi wrote:
> > > > And having the vfsmount available within vfs_...() functions means,
> > > > that the mnt_want_write() check can be moved inside, which means that
> > > > callers get simpler and less likely to be buggy.  Those are all
> > > > advantages IMO, regardless of any security module issues.
> > > 
> > > Or we can introduce another set of exported functions (path_mkdir(),
> > > ...), and leave vfs_...() alone.  And then the only question is if
> > > LSM's can live with ordering change.
> > 
> > I really don't see the point of new helpers; especially since one doesn't
> > have to _have_ vfsmount to use the old ones and since we don't have a lot
> > of users of each of those to start with.
> 
> Traditionally we have syscalls, and nfsd.  Both of them want the
> security checks, and I think nfsd wants the read-only mount checking
> as well, but I'm not entirely sure.  Maybe we can handle that by just
> making nfsd acquire a write-ref on the mount and keep it while it's
> exported.
> 
> Then there's ecryptfs and unionfs, which probably need neither, but it
> wouldn't hurt to do them anyway.
> 
> Still, even if there are only two callers, then moving stuff to up
> doesn't make any sense.  Passing down a struct path is free for the
> syscall case, it doesn't consume any stack space or extra CPU.  Do
> please tell, why would that be such a bad thing?

Because we'd been that way before; see the shitpiles around ->lookup()
getting nameidata, etc.  You'll end up with some callers passing NULL
as ->mnt since they don't have anything better to pass, some stuff
called *from* the damn thing caring to check for ->mnt being NULL,
some stuff not caring about what ->mnt is at all and some assuming
that it's not NULL.  Which will lead to exploding combinations that
won't be noticed until somebody steps into such config.

As for the vfsmount-dependent checks (and any kind of MAC, while we are
at it)...  They belong to callers, exactly because different callers may
want different (amount of) checks.
