Return-Path: <linux-kernel-owner+w=401wt.eu-S1760185AbYIDSu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760185AbYIDSu5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 14:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759943AbYIDStV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 14:49:21 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:56337 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759941AbYIDStT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 14:49:19 -0400
Date: Thu, 4 Sep 2008 13:49:16 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: ebiederm@xmission.com, akpm@linux-foundation.org, hch@infradead.org,
       viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: unprivileged mounts git tree
Message-ID: <20080904184916.GA19328@us.ibm.com>
References: <E1Kb0ml-0006qL-5M@pomaz-ex.szeredi.hu> <20080903224334.GA726@us.ibm.com> <E1Kb8Y0-0008Gh-FP@pomaz-ex.szeredi.hu> <20080904132804.GA14709@us.ibm.com> <E1KbFU3-0002Ne-Oe@pomaz-ex.szeredi.hu> <E1KbGwb-0002rl-49@pomaz-ex.szeredi.hu> <20080904161729.GA26579@us.ibm.com> <E1KbIqL-0003QO-34@pomaz-ex.szeredi.hu> <20080904174851.GA13693@hallyn.com> <E1KbJBO-0003Xz-0G@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1KbJBO-0003Xz-0G@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Miklos Szeredi (miklos@szeredi.hu):
> On Thu, 4 Sep 2008, Serge E. Hallyn wrote:
> > Quoting Miklos Szeredi (miklos@szeredi.hu):
> > > On Thu, 4 Sep 2008, Serge E. Hallyn wrote:
> > > > but you're still doing
> > > > 
> > > > 	if (IS_MNT_SHARED(old_nd.path.mnt) && !capable(CAP_SYS_ADMIN))
> > > > 		goto out;
> > > > 
> > > > shouldn't it be something like
> > > > 
> > > > 	if (IS_MNT_SHARED(old_nd.path.mnt) && (old_nd.path.mnt & MNT_USER))
> > > > 		goto out;
> > > > 
> > > > ?
> > > 
> > > Why would that be an error?  There's no real security gain to be had
> > > from restricting a privileged user, but could cause a lot of
> > > annoyance.  If we think this is dangerous, then protection should be
> > > built into mount(8) with an option to override.  But not into the
> > > kernel, IMO.
> > 
> > We disagree on that.  But can we agree that the check you added is wrong?
> 
> No :)
> 
> > There is no reason why a user mount should not be able to do shared
> > mounts, is there?
> 
> I don't know.  It's something to think about in the future, but not
> essential.  We know that without the above check the user can do bad
> things: propagate mounts back into the source, and we don't want that.

When is propagating mounts back into the source bad?  Because you are
not preventing it.

You are preventing future propagation back into the user's own mounts,
but not into mounts not owned by the user.

It's not right.

> We could allow binding a shared mount if
> 
>   a) the owners of the source and destination match
>   b) the destination is made a slave of the source

Well that's what I've been saying...

> But the current patchset doesn't allow _any_ changes to propagation
> without CAP_SYS_ADMIN, so why should bind be an exception?

Because it's not a change in propagation among existing mounts, instead
it's defining propagation for the new user mounts.  And since user
mounts don't currently exist, we're in no position to talk about
exceptions to existing behavior.

> And yes, this is something to think about, but I think it's a rather
> uncommon corner case, and so the patchset very much makes sense
> without having to deal with unprivileged mount propagation changes.

I'm willing to accept that if we simply leave the patchset as it was
before, but your new check just adds inconsistencies for absolutely zero
security gain.

> >  So should the check above just go away then?
> 
> No, we'd be back with the original problem.

We still have the original problem.

When root does

	mount -bind /mnt /mnt
	mount --make-rshared /mnt
	mount --bind -o user=hallyn /mnt /home/hallyn/mnt

and hallyn does

	mount --bind /usr /home/hallyn/mnt/usr

then the kernel happily propagates the mount to /mnt/usr.
Now if hallyn does

	mount --bind /home/hallyn/mnt/usr /home/hallyn/mnt/usr2

THAT gives him a -EPERM.

To what end?

-serge
