Return-Path: <linux-kernel-owner+w=401wt.eu-S1758656AbXIQToi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758656AbXIQToi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 15:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755553AbXIQToU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 15:44:20 -0400
Received: from 1wt.eu ([62.212.114.60]:2523 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755158AbXIQToT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 15:44:19 -0400
Date: Mon, 17 Sep 2007 21:43:42 +0200
From: Willy Tarreau <w@1wt.eu>
To: Oleg Verych <olecom@flower.upol.cz>
Cc: Roman Zippel <zippel@linux-m68k.org>, Ingo Molnar <mingo@elte.hu>,
       Rob Hussey <robjhussey@gmail.com>, efault@gmx.de,
       a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       ck@vds.kolivas.org
Subject: Re: Scheduler benchmarks - a follow-up
Message-ID: <20070917194342.GB20271@1wt.eu>
References: <6b8cef970709170221s4301e896x2ee123a149c05c3a@mail.gmail.com> <20070917112707.GA24583@elte.hu> <E1IXMXf-0000uG-ID@flower>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1IXMXf-0000uG-ID@flower>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, Sep 17, 2007 at 09:45:59PM +0200, Oleg Verych wrote:
> The copy list, removed by Ingo is restored. Playing fair game, Willy!

Sorry Oleg, I don't understand why you added me to this thread. And I
don't understand at all what your intent was :-/

I've left others Cc too since they wonder like me.

Regards,
Willy

> Roman, please, find whole thread here:
> http://thread.gmane.org/gmane.linux.kernel/580665
> 
> > From: Ingo Molnar <mingo@elte.hu>
> > Newsgroups: gmane.linux.kernel,gmane.linux.kernel.ck
> > Subject: Re: Scheduler benchmarks - a follow-up
> > Date: Mon, 17 Sep 2007 13:27:07 +0200
> []
> > In-Reply-To: <6b8cef970709170221s4301e896x2ee123a149c05c3a@mail.gmail.com>
> > User-Agent: Mutt/1.5.14 (2007-02-12)
> > Received-SPF: softfail (mx2: transitioning domain of elte.hu does not designate 157.181.1.14 as permitted sender) client-ip=157.181.1.14; envelope-from=mingo@elte.hu; helo=elvis.elte.hu;
> []
> > Archived-At: <http://permalink.gmane.org/gmane.linux.kernel/580689>
> 
> >
> > * Rob Hussey <robjhussey@gmail.com> wrote:
> >
> >> Hi all,
> >> 
> >> After posting some benchmarks involving cfs 
> >> (http://lkml.org/lkml/2007/9/13/385), I got some feedback, so I 
> >> decided to do a follow-up that'll hopefully fill in the gaps many 
> >> people wanted to see filled.
> >
> > thanks for the update!
> >
> >> I'll start with some selected numbers, which are preceded by the 
> >> command used for the benchmark.
> >> 
> >> for((i=2; i < 201; i++)); do lat_ctx -s 0 $i; done:
> >> (the left most column is the number of processes ($i))
> >> 
> >> 	2.6.21		2.6.22-ck1	2.6.23-rc6-cfs-devel
> >> 
> >> 15	5.88		4.85		5.14
> >> 16	5.80		4.77		4.76
> >
> > the unbound results are harder to compare because CFS changed SMP 
> > balancing to saturate multiple cores better - but this can result in a 
> > micro-benchmark slowdown if the other core is idle (and one of the 
> > benchmark tasks runs on one core and the other runs on the first core). 
> > This affects lat_ctx and pipe-test. (I'll have a look at the hackbench 
> > behavior.)
> >
> >> Bound to Single core:
> >
> > these are the more comparable (apples to apples) tests. Usually the most 
> > stable of them is pipe-test:
> >
> >> pipe-test:
> >> 
> >> 	2.6.21	2.6.22-ck1	2.6.23-rc6-cfs-devel
> >> 
> >> 1  	9.27	8.50 		8.55
> >> 2  	9.27	8.47 		8.55
> >> 3  	9.28	8.47 		8.54
> >> 4  	9.28	8.48 		8.54
> >> 5  	9.28	8.48 		8.54
> >
> > so -ck1 is 0.8% faster in this particular test. (but still, there can be 
> > caching effects in either direction - so i usually run the test on both 
> > cores/CPUs to see whether there's any systematic spread in the results. 
> > The cache-layout related random spread can be as high as 10% on some 
> > systems!)
> >
> > many things happened between 2.6.22-ck1 and 2.6.23-cfs-devel that could 
> > affect performance of this test. My initial guess would be sched_clock() 
> > overhead. Could you send me your system's 'dmesg' output when running a 
> > 2.6.22 (or -ck1) kernel? Chances are that your TSC got marked unstable, 
> > this turns on a much less precise but also faster sched_clock() 
> > implementation. CFS uses the TSC even if the time-of-day code marked it 
> > as unstable - going for the more precise but slightly slower variant.
> >
> > To test this theory, could you apply the patch below to cfs-devel (if 
> > you are interested in further testing this) - this changes the cfs-devel 
> > version of sched_clock() to have a low-resolution fallback like v2.6.22 
> > does. Does this result in any measurable increase in performance? 
> >
> > (there's also a new sched-devel.git tree out there - if you update to it 
> > you'll need to re-pull it against a pristine Linus git head.)
> >
> > 	Ingo
> >
> > ---
> >  arch/i386/kernel/tsc.c |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > Index: linux/arch/i386/kernel/tsc.c
> >===================================================================
> > --- linux.orig/arch/i386/kernel/tsc.c
> > +++ linux/arch/i386/kernel/tsc.c
> > @@ -110,9 +110,9 @@ unsigned long long native_sched_clock(vo
> >  	 *   very important for it to be as fast as the platform
> >  	 *   can achive it. )
> >  	 */
> > -	if (unlikely(!tsc_enabled && !tsc_unstable))
> > +	if (1 || unlikely(!tsc_enabled && !tsc_unstable))
> >  		/* No locking but a rare wrong value is not a big deal: */
> > -		return (jiffies_64 - INITIAL_JIFFIES) * (1000000000 / HZ);
> > +		return jiffies_64 * (1000000000 / HZ);
> >  
> >  	/* read the Time Stamp Counter: */
> >  	rdtscll(this_offset);
