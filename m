Return-Path: <linux-kernel-owner+w=401wt.eu-S1758370AbXGMGvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758370AbXGMGvO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 02:51:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752041AbXGMGu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 02:50:58 -0400
Received: from byss.tchmachines.com ([208.76.80.75]:56981 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973AbXGMGu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 02:50:58 -0400
Date: Thu, 12 Jul 2007 23:50:53 -0700
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org,
       "Shai Fultheim (Shai@scalex86.org)" <shai@scalex86.org>
Subject: Re: [patch] x86_64: Avoid too many remote cpu references due to /proc/stat
Message-ID: <20070713065053.GA7177@localdomain>
References: <20070713000615.GA11942@localdomain> <20070712191317.41217c7a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070712191317.41217c7a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2007 at 07:13:17PM -0700, Andrew Morton wrote:
> On Thu, 12 Jul 2007 17:06:16 -0700 Ravikiran G Thirumalai <kiran@scalex86.org> wrote:
>
> > Too many remote cpu references due to /proc/stat.
> >
> > On x86_64, with newer kernel versions, kstat_irqs is a bit of a problem.
> > On every call to kstat_irqs, the process brings in per-cpu data from all
> > online cpus.  Doing this for NR_IRQS, which is now 256 + 32 * NR_CPUS
> > results in (256+32*63) * 63 remote cpu references on a 64 cpu config.
> > /proc/stat is parsed by common commands like top, who etc, causing
> > lots of cacheline transfers
>
> (256+32*63) * 63 = 143136
>
> Do you have any actual numbers for how much this hurts?

Under certain load conditions with 2.6.21/22, this hurts a *lot* infact,
I have noticed delays in seconds when /proc/stat is read (48P box).
However, the reason for this is not the transfer of per-cpu kstat, but
dereferencing of the percpu data offset from a remote cpu pda!  Since the
cpu pda is kmalloced, with 2.6.21, the zone pcp structures happen to
share the same page  (and in some cases the internode cacheline as well)
with the cpu_pda.  Excessive page allocation activities on the remote
node causes reads to the cpu pda of the remote cpus to result in cache misses.

>
> > This statistic seems useless. Other 'big iron' arches disable this.
> > Can we disable computing/reporting this statistic?  This piece of
> > statistic is not human readable on x86_64 anymore,
>
> Did you consider using percpu_counters (or such) at interrupt-time? 
> (warning: percpu_counters aren't presently interrupt safe).

No, but given that alloc_percpu of a counter wastes so much memory, an array
of NR_IRQS percpu_counters will only cause more bloat no?


>
> > If not, can we optimize computing this statistic so as to avoid
> > too many remote references (patch to follow)
>
> You other patch is a straightforward optimisation and should just be merged.
>

Sure!  But I still don't see this statistic _really_ being useful anywhere;
/proc/stat output with NR_CPUS of 64 or 96 is ugly, but I might be missing
something

> But afaict it will only provide a 2x speedup which I doubt is sufficient?

No, it provides much more than 2x speedup with the 'hurting' workload.
This is because the optimized patch goes like this:

for_each_possible_cpu(i) {
	...
	for (j = 0 ; j < NR_IRQS ; j++) {
		unsigned int temp = kstat_cpu(i).irqs[j];
	...
	}
}

But the existing code with kstat_irqs goes as:

for (j = 0 ; j < NR_IRQS ; j++) {
	for_each_possible_cpu(cpu) {
		sum += kstat_cpu(cpu).irqs[irq]
	...
}

Former case causes less cache misses to the pda per-cpu dataoffset than
the latter by a huge margin.

Cache miss itself is not so bad per miss, but the number of misses
in the latter case adds up!

Yes, the cpu pda needs to be on an internode boundary by itself,  I will be
submitting a patch for the same soon.  I am thinking of page aligning cpu
pda and using the 12 lower bits in %gs to store the cpu processor id maybe :)

>
>
>
> Another thought is: how many of the NR_IRQS counters are actually non-zero?
> Because a pretty obvious optimisation would be to have a global
> bitmap[NR_IRQS] and do
>
> 	if (!bitmap[irq])
> 		bitmap[irq] = 1;
>
> at interrupt-time, then just print a "0" for the interrupts which have
> never occurred within show_stats().

Yep.  That would work too.

