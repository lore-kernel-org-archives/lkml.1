Return-Path: <linux-kernel-owner+w=401wt.eu-S1756327AbZKRB2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756327AbZKRB2O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 20:28:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752278AbZKRB2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 20:28:14 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:46774 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331AbZKRB2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 20:28:13 -0500
Subject: Re: -rt dbench scalabiltiy issue
From: john stultz <johnstul@us.ibm.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Darren Hart <dvhltc@us.ibm.com>, Clark Williams <williams@redhat.com>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20091017223902.GA29439@wotan.suse.de>
References: <1255723519.5135.121.camel@localhost.localdomain>
	 <20091017223902.GA29439@wotan.suse.de>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Tue, 17 Nov 2009 17:28:16 -0800
Message-ID: <1258507696.2077.61.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-10-18 at 00:39 +0200, Nick Piggin wrote:
> On Fri, Oct 16, 2009 at 01:05:19PM -0700, john stultz wrote:
> > 2.6.31.2-rt13-nick on ramfs:
> >     46.51%         dbench  [kernel]                  [k] _atomic_spin_lock_irqsave
> >                 |          
> >                 |--86.95%-- rt_spin_lock_slowlock
> >                 |          rt_spin_lock
> >                 |          |          
> >                 |          |--50.08%-- dput
> >                 |          |          |          
> >                 |          |          |--56.92%-- __link_path_walk
> >                 |          |          |          
> >                 |          |           --43.08%-- path_put
> >                 |          |          
> >                 |          |--49.12%-- path_get
> >                 |          |          |          
> >                 |          |          |--63.22%-- path_walk
> >                 |          |          |          
> >                 |          |          |--36.73%-- path_init
> >                 |          
> >                 |--12.59%-- rt_spin_lock_slowunlock
> >                 |          rt_spin_unlock
> >                 |          |          
> >                 |          |--49.86%-- path_get
> >                 |          |          |          
> >                 |          |          |--58.15%-- path_init
> >                 |          |          |          |          
> > ...
> > 
> > 
> > So the net of this is: Nick's patches helped some but not that much in
> > ramfs filesystems, and hurt ext3 performance w/ -rt.
> > 
> > Maybe I just mis-applied the patches? I'll admit I'm unfamiliar with the
> > dcache code, and converting the patches to the -rt tree was not always
> > straight forward.
> 
> The above are dentry->d_lock, and they are rom path walking. It has
> become more pronounced because I use d_lock to protect d_count rather
> than an atomic_t (which saves on atomic ops).
> 
> But the patchset you have converted it missing the store-free path wailk
> patches which will get rid of most of this. The next thing you hit is
> glibc reading /proc/mounts to implement statvfs :( If you turn that call
> into statfs you'll get a little further (but we need to improve statfs
> support for glibc so it doesn't need those hacks).
> 
> And then you run into something else, I'd say d_lock again for creating
> and unlinking things, but I didn't get a chance to profile it yet.
> 
> > Ingo, Nick, Thomas: Any thoughts or comments here? Am I reading perf's
> > results incorrectly? Any idea why with Nick's patch the contention in
> > dput() hurts ext3 so much worse then in the ramfs case?
> 
> ext3 may be doing more dentry refcounting which is hitting the spin
> lock. I _could_ be persuaded to turn it back to an atomic_t, however
> I will want to wait until other things like the path walking is more
> mature which should take a lot of pressure off it.
> 
> Also... dbench throughput in exchange for adding an extra atomic at
> dput-time is... not a good idea. We would need some more important
> workloads I think (even a real samba serving netbench would be
> preferable).


Hey Nick,
	Just an update here, I moved up to your 09102009 patch, and spent
awhile playing with it.

Just as you theorized, moving d_count back to an atomic_t does seem to
greatly improve the performance on -rt. 

Again, very very rough numbers for an 8-way system:

				ext3		ramfs 
2.6.32-rc3:			~1800 MB/sec	~1600 MB/sec
2.6.32-rc3-nick			~1800 MB/sec	~2200 MB/sec
2.6.31.2-rt13:			 ~300 MB/sec	  ~66 MB/sec
2.6.31.2-rt13-nick:		  ~80 MB/sec	 ~126 MB/sec
2.6.31.6-rt19-nick+atomic:	 ~400 MB/sec	~2200 MB/sec

>From the perf report, all of the dcache related overhead has fallen
away, and it all seems to be journal related contention at this point
that's keeping the ext3 numbers down.

So yes, on -rt, the overhead from lock contention is way way worse then
any extra atomic ops. :)

I'm not totally convinced I did the conversion back to atomic_t's
properly, so I'm doing some stress testing, but I'll hopefully have
something to send out for review soon. 

As for your concern about dbench being a poor benchmark here, I'll try
to get some numbers on iozone or another suggested workload and get
those out to you shortly.

thanks
-john

