Return-Path: <linux-kernel-owner+w=401wt.eu-S1751722AbZGaXWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751722AbZGaXWN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 19:22:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751460AbZGaXWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 19:22:13 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:15375 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbZGaXWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 19:22:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Gqlg7feVtTeTEwmZ9xmgbbdnt75AtYJ25bNeJDfXUDyeiWVI0Pnd3vLitRZJ0VHR43
         qY29Pp8GhilIFY736PHX4+C2Lbqb3JToj8kqH+VlwEYlhPR8Azu1bxZWFR3AmUb3OiEa
         DIqZCulxktljnBgqp1pS8a41uKuWkHBHlm18o=
Date: Sat, 1 Aug 2009 01:22:07 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       Frank Rowand <frank.rowand@am.sony.com>,
       Robin Gareus <robin@gareus.org>, Gregory Haskins <ghaskins@novell.com>,
       Philippe Reynes <philippe.reynes@isismpp.fr>,
       Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>,
       Will Schmidt <will_schmidt@vnet.ibm.com>,
       Darren Hart <dvhltc@us.ibm.com>, Jan Blunck <jblunck@suse.de>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Jon Masters <jcm@redhat.com>
Subject: Re: [ANNOUNCE] 2.6.31-rc4-rt1
Message-ID: <20090731232205.GA7574@nowhere>
References: <alpine.LFD.2.00.0905012348200.3375@localhost.localdomain> <alpine.LFD.2.00.0905130122250.3561@localhost.localdomain> <alpine.LFD.2.00.0905221459030.3570@localhost.localdomain> <alpine.LFD.2.00.0906101803210.3367@localhost.localdomain> <alpine.LFD.2.00.0906121800590.3369@localhost.localdomain> <alpine.LFD.2.00.0906151117440.2800@localhost.localdomain> <alpine.LFD.2.00.0906170903370.2800@localhost.localdomain> <alpine.LFD.2.00.0906231418500.2767@localhost.localdomain> <alpine.LFD.2.00.0907092020410.2768@localhost.localdomain> <alpine.LFD.2.00.0907300006250.2936@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0907300006250.2936@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 30, 2009 at 02:48:04AM +0200, Thomas Gleixner wrote:
> We are pleased to announce the next update to our new preempt-rt
> series.
>  
>     - update to 2.6.31-rc4
> 
> This is a major rework of the rt patch series. Thanks to Clark
> Williams and John Kacur for providing the merge to 2.6.30 while I was
> stabilizing .29-rt. While the 30-rt series looked quite stable, we
> decided to skip 30-rt entirely to keep track with the ongoing mainline
> development for various reaons. The .31-rt series is planned to be
> stabilized as we have done with .29-rt.
> 
> The main changes in this release are:
> 
> - interrupt threading
> 
>     interrupt threading is now a pure extension of the mainline
>     threaded interrupt infrastructure. This reduced the patch size of
>     the forced irq threading to mere
> 
>       8 files changed, 178 insertions(+), 13 deletions(-)
> 
>     Another interesting detail is that the new forced threaded code
>     uses per device threads instead of per interrupt line threads as
>     we have done in the past. This was just a logical consequence of
>     the per device thread (voluntary threading) infrastructure in
>     mainline and allows us now to share an interrupt line between a
>     hardirq based handler and a threaded handler device. One use case
>     which comes to my mind is AT91 which shares the timer and the
>     serial port interrupt; we now can solve that problem w/o nasty
>     hacks by requesting a threaded handler for the serial port which
>     shuts up the serial device interrupt in the hard interrupt handler
>     part.
> 
> - rework of the locking infrastructure
>    
>    Up to now the -rt patches changed the raw_spinlock_t to
>    __raw_spinlock_t and added another two levels of underscores to
>    many of the locking primitives. A compiler trick was used to chose
>    the implementation for RT=y and RT=n compiles depending on the lock
>    type in the lock definition.
> 
>    This is nasty as there is no destinction in the source code which
>    kind of lock we are dealing with except if one looks up the lock
>    definition/declaration. It definitely was a clever move in the
>    first place to get things going, but aside of the underscore
>    conflicts which were introduced by lockdep it was not longer
>    acceptable to hide the fact that we are treating a lock
>    differently. Same applies for the changes to (rw_)semaphores which
>    used the compat_ trick for those ownerless anonymous semaphores
>    which are taken in one context and released in another.
> 
>    The annotation of the code which uses those special treated locks
>    has been long discussed and one of the proposed solutions was to
>    change all spinlocks which are converted by -rt to sleeping
>    spinlocks from spinlock_t to lock_t and have another set of
>    lock/unlock/trylock functions for those. That is definitely the
>    _preferred_ solution, but it's a massive and horribly intrusive
>    change. Steven was working on it for some time, but it simply does
>    not scale IMNSHO.
> 
>    I went the other way round. In -RT we have identified the locks
>    which can _not_ be converted to sleeping locks and so I went there
>    and converted them to atomic_spinlock_t and created a set of
>    functions for them. I converted the already known locks to that
>    type and fixed up all the functions (s/spin_*/atomic_spin_*/) which
>    annotates the code and makes it clear what we are dealing with.
> 
>    [ I admit "atomic_spinlock_t" is a horrible name, but it's the best
>      I came up with so far. If you have a better idea please feel free
>      to add it to 
> 
>          http://rt.wiki.kernel.org/index.php/Atomic_Spinlock
> 
>      instead of starting a bikeshed painting thread on the mailing
>      lists about that name. Once we have something better it's just a
>      sed script to fix it. ]
> 
>    For !RT the spin_* functions are mapped to atomic_spin_* via inline
>    functions which do the type conversion. That has another nice side
>    effect: some places in the kernel (mostly scheduler) use
>    _raw_spin_* functions on locks to avoid the lockdep invocation in
>    some places. With the type conversion a lock needs to be defined
>    atomic_spinlock_t (or raw_spinlock_t) to have access to that
>    _raw_spin_* functions. Using e.g. _raw_spin_lock() on a lock
>    defined with spinlock_t/DEFINE_SPINLOCK will cause a compiler
>    warning. I think that's a Good Thing.
> 
>    On RT the spin_* functions are mapped to the corresponding rt_lock
>    functions with inlines as well. Very simple and much more
>    understandable than the nifty PICK_OP magic with the underscore
>    convolution. :)
> 
>    I did the same conversion for all (rw_)semaphores which are known
>    from -rt to be ownerless anonymous semaphores; i.e. taken in one
>    context and released in another. We renamed them to
>    compat_(rw_)semaphores up to now and let the compiler pick the
>    right function. Again here I went down the road and annotated the
>    code for those with newly created anon_* and [read|write]_anon_*
>    functions. In !RT the non annotated ones map to the anon_ functions
>    and on RT we map them to the corresponging rt_* ones. This
>    annotation should also be helpful to cover at least the non
>    anonymous (rw_)semaphores via lockdep.
> 
>    Part of that semaphore rework is the RFC patch series I posted
>    recently to get rid of the init_MUTEX[_LOCKED] irritation (minus
>    the ones which turned out to be wrong)
> 
>    The spinlock and semaphore annotation work is separate now and can
>    be found in the rt/atomic-lock and rt/semaphore branches of the
>    -tip git repository, which leads me to the next important point:
> 
> - start of gitification
> 
>    While reworking all of the above I went through the quilt queue and
>    sorted out patches into different rt/ branches. If you clone the
>    -tip git tree you'll find a bunch of branches starting with rt/.
>    They contain various independent changes which are all part of the
>    -rt patch. The combination of those branches can be found in the
>    rt/base branch.
> 
>    I still have a leftover of ~140 patches (roughly 40% of the -rt
>    queue) which I committed into the rt/rt-2.6.31-rc4 branch just as
>    is simply because I ran out of time. My annual summer vacation
>    (helping my wife to run the kitchen in the church community kids
>    summer camp) is starting on friday.
> 
>    While the other rt/ branches are mostly bisectable the final one is
>    not yet there. I restructured the patch queue in a logical way, but
>    there is more work to be done to clean it up. So expect it to be
>    replaced.
> 
> Further plans:
> 
>    1) We seriously want to tackle the elimination of the PREEMPT_RT
>    annoyance #1, aka BKL. The Big Kernel Lock is still used in ~330
>    files all across the kernel. A lot of work has been done already to
>    push down the lock into the code which still thinks it needs to be
>    protected by it. Some work has been done already in the (a little
>    bit stale) kill-the-BKL and core/kill-the-BKL branches of the -tip
>    git tree. If you want to help, please check those branches whether
>    the code has been tackled already or not to avoid redundant
>    work. If you decide to take care of one please note it on:
> 
>        http://rt.wiki.kernel.org/index.php/Big_Kernel_Lock


We (I) can't write to this file :)

However, I'll try to attack the remaining bkl that resides in tty...

Thanks,
Frederic.



> 
>    2) I'm going on vacation for 10 days. Please send patches and
>    bugreports^Wsuccess stories to the mailinglist as usual. There are
>    folks looking out.
> 
> Enough said. Get the code and have fun!
> 
> Download locations:
> 
>     http://rt.et.redhat.com/download/
>     http://www.kernel.org/pub/linux/kernel/projects/rt/
> 
> Git:
> 
>     git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git rt/rt-2.6.31-rc4-rt1
> 
> Gitweb:
>     http://git.kernel.org/?p=linux/kernel/git/tip/linux-2.6-tip.git;a=shortlog;h=rt/rt-2.6.31-rc4
> 
> Information on the RT patch can be found at:
> 
>     http://rt.wiki.kernel.org/index.php/Main_Page
> 
> to build the 2.6.31-rc4-rt1 tree, the following patches should be
> applied:
> 
>     http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.30.tar.bz2
>     http://kernel.org/pub/linux/kernel/v2.6/testing/patch-2.6.31-rc4.bz2
>     http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.31-rc4-rt1.bz2
> 
> Thanks to Carsten Emde, Clark Williams and John Kacur who were testing
> my various steps to get the code into the shape where it is now.
>  
> Enjoy !
> 
>        tglx
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

