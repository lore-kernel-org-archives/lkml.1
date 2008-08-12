Return-Path: <linux-kernel-owner+w=401wt.eu-S1753269AbYHLSLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269AbYHLSLw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 14:11:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751594AbYHLSLo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 14:11:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:54887 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459AbYHLSLn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 14:11:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,197,1217833200"; 
   d="scan'208";a="606182109"
Date: Tue, 12 Aug 2008 11:11:27 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Pavel Machek <pavel@suse.cz>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       David Woodhouse <dwmw2@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "arjan@infradead.org" <arjan@infradead.org>
Subject: Re: [RFC] Imprecise timers.
Message-ID: <20080812181126.GA30061@linux-os.sc.intel.com>
References: <1216695757.18980.16.camel@shinybook.infradead.org> <7E82351C108FA840AB1866AC776AEC4608E23BE7@orsmsx505.amr.corp.intel.com> <20080809125447.GA13169@ucw.cz> <20080811173526.GA28661@linux-os.sc.intel.com> <20080812120031.GD8806@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080812120031.GD8806@elf.ucw.cz>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2008 at 05:00:31AM -0700, Pavel Machek wrote:
> Hi!
> 
> > > > >which will run some time later when the CPU happens to be awake. And a
> > > > >non-deferrable timer at the hard deadline, to ensure it really does
> > > > >happen by then.
> > > > >
> > > >
> > > > One concern I have is drivers using range_timers thinking that they need
> > > > some upper bound, while all they need is a simple deferrable timer. With that
> > > > we will have multiple timers waking up the CPU all the time (say, on
> > > > different CPUs) problem again. Even without the timers waking up all
> > >
> > > I don't get it. Who has timers that can be deferred forever? At that
> > > point they may simply not set the timer at all, right?
> > >
> >
> > I don't think I said drivers have or need timers that can be deferred forever.
> >
> > My point is, is it worth the overhead of setting and deleting additional timer,
> > just because drivers think that they need to use this new interface,
> > need to set a upper bound and come up with random upper bounds.
> > Apart from the overhead of setup and teardown we will somewhat negate the
> > benefits of deferrable timers as the upper bound hard timers can fire at
> > different times waking up the CPUs frequently.
> 
> > I understand that some drivers need this kind of upper limit. I am not sure
> > whether all drivers need it and if not, how can we restrict drivers from using
> > this when they don't really need it.
> 
> Do you have example of driver that does NOT need upper limit?
> 
> Like... lets take ATA.
> 
> submit_command()
> if command is not back in ~5 seconds, it probably timed out.
> 
> So you set soft limit to 5 seconds, and hard limit to 10. You
> definitely want user to know something is wrong after 10 seconds,
> right?
> 

I would say this will be the wrong usage of deadline, atleast with the
two timer and no round off implementation.

For this example, it will probably be better to use round_jiffies to round the
timer to second level and make it go in sync with all other round timers on
this CPU, rather than setting two timers with hard timer not in sync with
other timers on the CPU.

- if there are other timers (rounded or otherwise) on this CPU that goes off
between 5-10 seconds, we are paying penalty for setting up and removing one
extra timer with no obvious benefit.
- if there are no other timers on this CPU, that goes off between 5-10 seconds,
timer after 10 seconds will not be in sync with other potential round timers
on this CPU that may go off between 10-11 seconds, causing one extra wakeup
and again the overhead of setting up and removing one extra timer.

Instead a rounded timer after 5 seconds still ensures atleast 1s idle time on
the CPU without the overhead.

There can be many users who really don't care about the deadline or can happliy
use rounded timers or deferrable timers. Say garbage collectors, cache_reap
and friends, ondemand governor, vga cursor blinking comes to my mind.

Thanks,
Venki


