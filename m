Return-Path: <linux-kernel-owner+w=401wt.eu-S1422904AbXBAO0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422904AbXBAO0Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 09:26:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422913AbXBAO0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 09:26:25 -0500
Received: from styx.suse.cz ([82.119.242.94]:60415 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1422904AbXBAO0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 09:26:24 -0500
Date: Thu, 1 Feb 2007 15:29:31 +0100
From: Jiri Bohac <jbohac@suse.cz>
To: Andi Kleen <ak@suse.de>
Cc: jbohac@suse.cz, linux-kernel@vger.kernel.org,
       Vojtech Pavlik <vojtech@suse.cz>, ssouhlal@freebsd.org,
       arjan@infradead.org, tglx@linutronix.de, johnstul@us.ibm.com,
       zippel@linux-m68k.org, andrea@suse.de
Subject: Re: [patch 9/9] Make use of the Master Timer
Message-ID: <20070201142927.GR21755@dwarf.suse.cz>
References: <20070201095952.589234000@jet.suse.cz> <20070201103754.281474000@jet.suse.cz> <200702011236.05429.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702011236.05429.ak@suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 01, 2007 at 12:36:05PM +0100, Andi Kleen wrote:
> On Thursday 01 February 2007 11:00, jbohac@suse.cz wrote:
> 
> > +		case VXTIME_TSC:
> > +			rdtscll(tsc);
> 
> Where is the CPU synchronization? 
> 
> > +	cpu = smp_processor_id();
> > +	rdtscll(t);
> 
> Also no synchronization. It's slower, but needed.

Hmm, I wasn't sure. Why is it needed? How outdated can the
result of RDTSC / RDTSCP be?

If I do:
	rdtscll(a)
	...
	rdtscll(b)
is it guaranteed that (b > a) ?

>
> >  unsigned long long sched_clock(void)
> >  {
> > -	unsigned long a = 0;
> > -
> > -	rdtscll(a);
> > -	return cycles_2_ns(a);
> > +	return monotonic_clock();
> >  }
> 
> This is overkill because sched_clock() doesn't need a globally monotonic
> clock, per CPU monotonic is enough. The old version was fine.

OK, thanks for spotting this. I'll change it to use __guess_mt().
(more or less equal to cycles_2_ns(), no need to maintain yet another
tsc->ns ratio just for cycles_2_ns().


> > +static __always_inline void do_vgettimeofday(struct timeval * tv, u64 tsc, int cpu)
> > +{
> > +	unsigned int sec;
> > +	s64 nsec;
> >  
> > -	do {
> > -		sequence = read_seqbegin(&__xtime_lock);
> > -		
> > -		sec = __xtime.tv_sec;
> > -		usec = __xtime.tv_nsec / 1000;
> > -
> > -			usec += ((readl((void __iomem *)
> > -				   fix_to_virt(VSYSCALL_HPET) + 0xf0) -
> > -				  __vxtime.last) * __vxtime.quot) >> 32;
> > -	} while (read_seqretry(&__xtime_lock, sequence));
> > +	sec = __xtime.tv_sec;
> > +	nsec = __xtime.tv_nsec;
> > +	nsec +=	max(__do_gettimeoffset(tsc, cpu), __vxtime.drift);
> >  
> > -	tv->tv_sec = sec + usec / 1000000;
> > -	tv->tv_usec = usec % 1000000;
> > +	sec += nsec / NSEC_PER_SEC;
> > +	nsec %= NSEC_PER_SEC;
> 
> Using while() here is probably faster (done in vdso patchkit where
> gtod got mysteriously faster). Modulo and divisions are slow, even 
> for constants when they are large.

OK, will do that

> 
> >  }
> >  
> >  /* RED-PEN may want to readd seq locking, but then the variable should be write-once. */
> > @@ -107,10 +118,39 @@ static __always_inline long time_syscall
> >  
> >  int __vsyscall(0) vgettimeofday(struct timeval * tv, struct timezone * tz)
> >  {
> > -	if (!__sysctl_vsyscall)
> > +	int cpu = 0;
> > +	u64 tsc;
> > +	unsigned long seq;
> > +	int do_syscall = !__sysctl_vsyscall;
> > +
> > +	if (tv && !do_syscall)
> > +		switch (__vxtime.mode) {
> > +			case VXTIME_TSC:
> > +			case VXTIME_TSCP:
> > +				do {
> > +					seq = read_seqbegin(&__xtime_lock);
> > +
> > +					if (__vxtime.mode == VXTIME_TSC)
> > +						rdtscll(tsc);
> > +					else {
> > +						rdtscpll(tsc, cpu);
> > +						cpu &= 0xfff;
> > +					}
> > +
> > +					if (unlikely(__vxtime.cpu[cpu].tsc_invalid))
> > +						do_syscall = 1;
> > +					else
> > +						do_vgettimeofday(tv, tsc, cpu);
> > +
> > +				} while (read_seqretry(&__xtime_lock, seq));
> > +				break;
> > +			default:
> > +				do_syscall = 1;
> 
> Why do you not set __sysctl_vsyscall correctly for the mode at initialization?

Because of the __vxtime.cpu[cpu].tsc_invalid flag. We may be
using the vsyscall, but when we get the cpufreq PRE- notification, we
know that TSC cannot be trusted from that point on, until the
frequency stabilises. We set the flag and until TSC becomes
reliable again, vsyscall w/ HW Master Timer read will be used.

So this is something that changes in runtime, and cannot be set
permanently on initialization...


-- 
Jiri Bohac <jbohac@suse.cz>
SUSE Labs, SUSE CZ

