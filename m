Return-Path: <linux-kernel-owner+w=401wt.eu-S1755385AbYICWp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385AbYICWp3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 18:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752079AbYICWpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 18:45:18 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:45240 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034AbYICWpR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 18:45:17 -0400
Date: Wed, 3 Sep 2008 17:43:34 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: ebiederm@xmission.com, akpm@linux-foundation.org, hch@infradead.org,
       viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: unprivileged mounts git tree
Message-ID: <20080903224334.GA726@us.ibm.com>
References: <20080807222751.GA28412@us.ibm.com> <m1prokgyje.fsf@frodo.ebiederm.org> <20080808002537.GA5364@us.ibm.com> <E1KXZpC-0008Ie-6w@pomaz-ex.szeredi.hu> <20080827153628.GA11242@us.ibm.com> <E1KYNMl-0000TG-Qs@pomaz-ex.szeredi.hu> <20080827184600.GA8069@us.ibm.com> <E1KaxLm-0006OD-K8@pomaz-ex.szeredi.hu> <20080903220215.GA27705@us.ibm.com> <E1Kb0ml-0006qL-5M@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Kb0ml-0006qL-5M@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Miklos Szeredi (miklos@szeredi.hu):
> On Wed, 3 Sep 2008, Serge E. Hallyn wrote:
> > Ooh.
> > 
> > You predicate the turning of shared mount to a slave mount on
> > !capable(CAP_SYS_ADMIN).  But in fact it's the mount by a privileged
> > user, turning the mount into a user mount, which you want to convert.
> > So my series of steps was:
> > 
> > 	as root:
> > 		(1) mount --bind /mnt /mnt
> > 		(2) mount --make-rshared /mnt
> > 		(3) /usr/src/mmount-0.3/mmount --bind -o user=hallyn /mnt \
> > 			/home/hallyn/etc/mnt
> > 	as hallyn:
> > 		(4) mount --bind /usr /home/hallyn/etc/mnt/usr
> > 
> > You are turning mounts from shared->slave at step 4, but in fact we need
> > to do it at step 3, where we do have CAP_SYS_ADMIN.
> 
> Well, that's arguable: I think root should be able to shoot itself in
> the foot by doing step 3.

Maybe I'm not thinking right, but long-term is there any reason why we
should require privilege in order to do step 3, so long as the user has
read access to the source and write access to the destination?

I don't think there is.  Other than this glitch.  That's a powerful
reason to fix the glitch.

The other argument is that, frankly, I think most people are still
either unaware of, or confused by, mounts propagation.  Letting root
shoot himself in the foot is reasonable only to a point.

> Generally we don't restrict what root can
> do.  OTOH I agree that current behavior is ugly in that it provides
> different semantics for privileged/non-privileged callers.
> 
> Perhaps it would be cleaner to simply not allow step 4, instead of
> playing tricks with changing the propagation type.

If the user or admin can simply (I haven't tested)

	mmount --bind --make-rslave -o user=hallyn /mnt \
		/home/hallyn/etc/mnt

then returning -EPERM if --make-rslave was not provided is reasonable
IMO.

-serge
