Return-Path: <linux-kernel-owner+w=401wt.eu-S1752939AbYKQXEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939AbYKQXEP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 18:04:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751823AbYKQXEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 18:04:05 -0500
Received: from mga01.intel.com ([192.55.52.88]:43407 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751714AbYKQXEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 18:04:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,620,1220252400"; 
   d="scan'208";a="404757719"
Date: Mon, 17 Nov 2008 15:04:03 -0800
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
Subject: Re: [git pull] scheduler updates
Message-ID: <20081117230403.GA30861@linux-os.sc.intel.com>
References: <20081108170224.GA553@elte.hu> <alpine.LFD.2.00.0811081026280.3468@nehalem.linux-foundation.org> <20081108104116.48bd26e6@infradead.org> <alpine.LFD.2.00.0811081051190.3468@nehalem.linux-foundation.org> <20081108190517.GA9806@elte.hu> <alpine.LFD.2.00.0811081115290.3468@nehalem.linux-foundation.org> <20081108192957.GA22219@elte.hu> <20081117224358.GA27249@linux-os.sc.intel.com> <20081117225018.GA25619@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081117225018.GA25619@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2008 at 02:50:18PM -0800, Ingo Molnar wrote:
> 
> * Venki Pallipadi <venkatesh.pallipadi@intel.com> wrote:
> 
> > Patch being discussed on this thread (commit 0d12cdd) has a
> > regression on one of the test systems here.
> >
> > With the patch, I see
> >
> > checking TSC synchronization [CPU#0 -> CPU#1]:
> > Measured 28 cycles TSC warp between CPUs, turning off TSC clock.
> > Marking TSC unstable due to check_tsc_sync_source failed
> >
> > Whereas, without the patch syncs pass fine on all CPUs
> >
> > checking TSC synchronization [CPU#0 -> CPU#1]: passed.
> >
> > Due to this, TSC is marke unstable, when it is not actually unstable.
> > This is because syncs in check_tsc_wrap() goes away due to this commit.
> >
> > As per the discussion on this thread, correct way to fix this is to add
> > explicit syncs as below?
> 
> ah. Yes.
> 
> Could you please check whether:
> 
> > +     rdtsc_barrier();
> >       start = get_cycles();
> > +     rdtsc_barrier();
> >       /*
> >        * The measurement runs for 20 msecs:
> >        */
> > @@ -61,7 +63,9 @@ static __cpuinit void check_tsc_warp(voi
> >                */
> >               __raw_spin_lock(&sync_lock);
> >               prev = last_tsc;
> > +             rdtsc_barrier();
> >               now = get_cycles();
> > +             rdtsc_barrier();
> 
> adding the barrier just _after_ the get_cycles() call (but not before
> it) does the trick too? That should be enough in this case.
>

With barrier only after get_cycles, I do see syncs across first few CPUs
passing. But later I see:

checking TSC synchronization [CPU#0 -> CPU#13]:
Measured 4 cycles TSC warp between CPUs, turning off TSC clock.
Marking TSC unstable due to check_tsc_sync_source failed


Thanks,
Venki
