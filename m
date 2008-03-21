Return-Path: <linux-kernel-owner+w=401wt.eu-S1760935AbYCUSxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760935AbYCUSxl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 14:53:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755850AbYCUSx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 14:53:29 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:51295 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756709AbYCUSx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 14:53:28 -0400
To: viro@ZenIV.linux.org.uk
CC: miklos@szeredi.hu, haveblue@us.ibm.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, neilb@suse.de, akpm@linux-foundation.org,
       hch@infradead.org, linux-security-module@vger.kernel.org,
       jmorris@namei.org
In-reply-to: <20080321181105.GW10722@ZenIV.linux.org.uk> (message from Al Viro
	on Fri, 21 Mar 2008 18:11:05 +0000)
Subject: Re: r-o bind in nfsd
References: <E1Jciie-0001E6-Dx@pomaz-ex.szeredi.hu> <20080321155451.GU10722@ZenIV.linux.org.uk> <E1Jck2N-0001Q3-7W@pomaz-ex.szeredi.hu> <20080321163520.GV10722@ZenIV.linux.org.uk> <E1JckW9-0001Ub-Rs@pomaz-ex.szeredi.hu> <E1Jckjd-0001X8-IM@pomaz-ex.szeredi.hu> <20080321181105.GW10722@ZenIV.linux.org.uk>
Message-Id: <E1JcmLz-0001n1-RC@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 21 Mar 2008 19:52:35 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > And having the vfsmount available within vfs_...() functions means,
> > > that the mnt_want_write() check can be moved inside, which means that
> > > callers get simpler and less likely to be buggy.  Those are all
> > > advantages IMO, regardless of any security module issues.
> > 
> > Or we can introduce another set of exported functions (path_mkdir(),
> > ...), and leave vfs_...() alone.  And then the only question is if
> > LSM's can live with ordering change.
> 
> I really don't see the point of new helpers; especially since one doesn't
> have to _have_ vfsmount to use the old ones and since we don't have a lot
> of users of each of those to start with.

Traditionally we have syscalls, and nfsd.  Both of them want the
security checks, and I think nfsd wants the read-only mount checking
as well, but I'm not entirely sure.  Maybe we can handle that by just
making nfsd acquire a write-ref on the mount and keep it while it's
exported.

Then there's ecryptfs and unionfs, which probably need neither, but it
wouldn't hurt to do them anyway.

Still, even if there are only two callers, then moving stuff to up
doesn't make any sense.  Passing down a struct path is free for the
syscall case, it doesn't consume any stack space or extra CPU.  Do
please tell, why would that be such a bad thing?

Miklos
