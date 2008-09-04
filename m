Return-Path: <linux-kernel-owner+w=401wt.eu-S1753903AbYIDGnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903AbYIDGnV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 02:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751050AbYIDGnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 02:43:09 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:48989 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbYIDGnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 02:43:08 -0400
To: serue@us.ibm.com
CC: miklos@szeredi.hu, ebiederm@xmission.com, akpm@linux-foundation.org,
       hch@infradead.org, viro@ZenIV.linux.org.uk,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <20080903224334.GA726@us.ibm.com> (serue@us.ibm.com)
Subject: Re: unprivileged mounts git tree
References: <20080807222751.GA28412@us.ibm.com> <m1prokgyje.fsf@frodo.ebiederm.org> <20080808002537.GA5364@us.ibm.com> <E1KXZpC-0008Ie-6w@pomaz-ex.szeredi.hu> <20080827153628.GA11242@us.ibm.com> <E1KYNMl-0000TG-Qs@pomaz-ex.szeredi.hu> <20080827184600.GA8069@us.ibm.com> <E1KaxLm-0006OD-K8@pomaz-ex.szeredi.hu> <20080903220215.GA27705@us.ibm.com> <E1Kb0ml-0006qL-5M@pomaz-ex.szeredi.hu> <20080903224334.GA726@us.ibm.com>
Message-Id: <E1Kb8Y0-0008Gh-FP@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 04 Sep 2008 08:42:28 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Sep 2008, Serge E. Hallyn wrote:
> Quoting Miklos Szeredi (miklos@szeredi.hu):
> > On Wed, 3 Sep 2008, Serge E. Hallyn wrote:
> > > Ooh.
> > > 
> > > You predicate the turning of shared mount to a slave mount on
> > > !capable(CAP_SYS_ADMIN).  But in fact it's the mount by a privileged
> > > user, turning the mount into a user mount, which you want to convert.
> > > So my series of steps was:
> > > 
> > > 	as root:
> > > 		(1) mount --bind /mnt /mnt
> > > 		(2) mount --make-rshared /mnt
> > > 		(3) /usr/src/mmount-0.3/mmount --bind -o user=hallyn /mnt \
> > > 			/home/hallyn/etc/mnt
> > > 	as hallyn:
> > > 		(4) mount --bind /usr /home/hallyn/etc/mnt/usr
> > > 
> > > You are turning mounts from shared->slave at step 4, but in fact we need
> > > to do it at step 3, where we do have CAP_SYS_ADMIN.
> > 
> > Well, that's arguable: I think root should be able to shoot itself in
> > the foot by doing step 3.
> 
> Maybe I'm not thinking right, but long-term is there any reason why we
> should require privilege in order to do step 3, so long as the user has
> read access to the source and write access to the destination?
> 
> I don't think there is.  Other than this glitch.  That's a powerful
> reason to fix the glitch.

Agreed, without privileges it's unacceptable to allow step 3 as is.

> The other argument is that, frankly, I think most people are still
> either unaware of, or confused by, mounts propagation.  Letting root
> shoot himself in the foot is reasonable only to a point.

Hmm, I think there are infinite ways in which root can mess up mount
propagation, and this is not even the worst.  I'm not trying to
belittle this bug: done unprivileged it's unacceptable.  But with
privileges, I really don't know if we should change the propagation
semantics for this corner case, they are complicated enough already.

> > Generally we don't restrict what root can
> > do.  OTOH I agree that current behavior is ugly in that it provides
> > different semantics for privileged/non-privileged callers.
> > 
> > Perhaps it would be cleaner to simply not allow step 4, instead of
> > playing tricks with changing the propagation type.
> 
> If the user or admin can simply (I haven't tested)
> 
> 	mmount --bind --make-rslave -o user=hallyn /mnt \
> 		/home/hallyn/etc/mnt
> 
> then returning -EPERM if --make-rslave was not provided is reasonable
> IMO.

Right, that sounds perfect.  the only problem is, bind mount currently
ignores the propagation flags, for no good reason I can see.

That's a separate patch though.  I'll look into it.

Thanks,
Miklos
