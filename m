Return-Path: <linux-kernel-owner+w=401wt.eu-S1753968AbYFRMIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968AbYFRMIa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 08:08:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752917AbYFRMIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 08:08:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44894 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612AbYFRMIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 08:08:19 -0400
Date: Wed, 18 Jun 2008 08:07:50 -0400
From: Jeff Layton <jlayton@redhat.com>
To: "Daniel J Blueman" <daniel.blueman@gmail.com>
Cc: "Trond Myklebust" <trond.myklebust@fys.uio.no>, nfsv4@linux-nfs.org,
       linux-nfs@vger.kernel.org,
       "Linux Kernel" <linux-kernel@vger.kernel.org>, chuck.lever@oracle.com
Subject: Re: [2.6.26-rc4] mount.nfsv4/memory poisoning issues...
Message-ID: <20080618080750.52dd6070@barsoom.rdu.redhat.com>
In-Reply-To: <6278d2220806101327t29baac6ft30919301277d730c@mail.gmail.com>
References: <6278d2220806041633n3bfe3dd2ke9602697697228b@mail.gmail.com>
	<20080604203504.62730951@tleilax.poochiereds.net>
	<1213124088.20459.16.camel@localhost>
	<20080610151357.150b6f69@tleilax.poochiereds.net>
	<20080610151829.3c4d6c1e@tleilax.poochiereds.net>
	<6278d2220806101327t29baac6ft30919301277d730c@mail.gmail.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2008 21:27:07 +0100
"Daniel J Blueman" <daniel.blueman@gmail.com> wrote:

> On Tue, Jun 10, 2008 at 8:18 PM, Jeff Layton <jlayton@redhat.com> wrote:
> > On Tue, 10 Jun 2008 15:13:57 -0400
> > Jeff Layton <jlayton@redhat.com> wrote:
> >
> >> On Tue, 10 Jun 2008 14:54:48 -0400
> >> Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
> >>
> >> > On Wed, 2008-06-04 at 20:35 -0400, Jeff Layton wrote:
> >> > > On Thu, 5 Jun 2008 00:33:54 +0100
> >> > > "Daniel J Blueman" <daniel.blueman@gmail.com> wrote:
> >> > >
> >> > > > Having experienced 'mount.nfs4: internal error' when mounting nfsv4 in
> >> > > > the past, I have a minimal test-case I sometimes run:
> >> > > >
> >> > > > $ while :; do mount -t nfs4 filer:/store /store; umount /store; done
> >> > > >
> >> > > > After ~100 iterations, I saw the 'mount.nfs4: internal error',
> >> > > > followed by symptoms of memory corruption [1], a locking issue with
> >> > > > the reporting [2] and another (related?) memory-corruption issue
> >> > > > (off-by-1?) [3]. A little analysis shows memory being overwritten by
> >> > > > (likely) a poison value, which gets complicated if it's not
> >> > > > use-after-free...
> >> > > >
> >> > > > Anyone dare confirm this issue? NFSv4 server is x86-64 Ubuntu 8.04
> >> > > > 2.6.24-18, client U8.04 2.6.26-rc4; batteries included [4].
> >> > > >
> >> > > > I'm happy to decode addresses, test patches etc.
> >> > > >
> >> > > > Daniel
> >> > > >
> >> > >
> >> > > Looks like it fell down while trying to take down the kthread during a
> >> > > failed mount attempt. I have to wonder if I might have introduced a
> >> > > race when I changed nfs4 callback thread to kthread API. I think we may
> >> > > need the BKL around the last 2 statements in the main callback thread
> >> > > function. If you can easily reproduce this, could you test the
> >> > > following patch and let me know if it helps?
> >> > >
> >> > > Note that this patch is entirely untested, so test it someplace
> >> > > non-critical ;-).
> >> > >
> >> > > Signed-off-by: Jeff Layton <jlayton@redhat.com>
> >> > >
> >> > >
> >> > > diff --git a/fs/nfs/callback.c b/fs/nfs/callback.c
> >> > > index c1e7c83..a3e83f9 100644
> >> > > --- a/fs/nfs/callback.c
> >> > > +++ b/fs/nfs/callback.c
> >> > > @@ -90,9 +90,9 @@ nfs_callback_svc(void *vrqstp)
> >> > >           preverr = err;
> >> > >           svc_process(rqstp);
> >> > >   }
> >> > > - unlock_kernel();
> >> > >   nfs_callback_info.task = NULL;
> >> > >   svc_exit_thread(rqstp);
> >> > > + unlock_kernel();
> >> > >   return 0;
> >> > >  }
> >> >
> >> > We certainly need to protect nfs_callback_info.task (and I believe I
> >> > explained this earlier), but why do we need to protect svc_exit_thread?
> >> >
> >> > Also, looking at the general use of the BKL in that code, I thought we
> >> > agreed that there was no need to hold the BKL while taking the
> >> > nfs_callback_mutex?
> >> >
> >>
> >> Hmm, I don't remember that discussion, but I'll take your word for it...
> >>
> >> I think you're basically correct, but it looks to me like the
> >> nfs_callback_mutex actually protects nfs_callback_info.task as well.
> >>
> >> If we're starting the thread, then we can't call kthread_stop on it
> >> until we release the mutex. So the thread can't exit until we release
> >> the mutex, and we can be guaranteed that this:
> >>
> >>      nfs_callback_info.task = NULL;
> >>
> >> ...can't happen until after kthread_run returns and nfs_callback_up
> >> sets it.
> >>
> >> If that's right, then maybe this (untested, RFC only) patch would make sense?
> >>
> >
> > To clarify for Dan...
> >
> > I don't think that this patch will help the problem you're having. This
> > is essentially a cleanup patch to remove some locking that doesn't
> > appear to be needed.
> >
> > The original patch that Trond commented on above is also probably
> > unnecessary (assuming I'm right about the locking here).
> 
> Thanks for the head-up, Jeff. I took it at face value, so didn't
> harbour the notion it would fix the memory corruption.
> 
> Let's see If I can get time for this git bisect sooner rather than later...

I've tried reproducing this, but haven't had much success (probably some
differences in my kernel config).

I suspect that Trond is correct here and the race has something to
do with the kthread being spawned but nfs_callback_svc() never getting
a chance to run. I posted a patchset to the list late last week with the
intro email:

[PATCH 0/3] fix potential races in lockd and nfs4-callback startup/shutdown

Dan, could you apply that patchset to your kernel and see if it helps
this problem?

Thanks,
-- 
Jeff Layton <jlayton@redhat.com>
