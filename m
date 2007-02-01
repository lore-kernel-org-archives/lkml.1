Return-Path: <linux-kernel-owner+w=401wt.eu-S1422815AbXBALg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422815AbXBALg6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 06:36:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422813AbXBALgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 06:36:35 -0500
Received: from mail.suse.de ([195.135.220.2]:60010 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422814AbXBALgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 06:36:31 -0500
From: Andi Kleen <ak@suse.de>
To: jbohac@suse.cz
Subject: Re: [patch 9/9] Make use of the Master Timer
Date: Thu, 1 Feb 2007 12:36:05 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Vojtech Pavlik <vojtech@suse.cz>,
       ssouhlal@freebsd.org, arjan@infradead.org, tglx@linutronix.de,
       johnstul@us.ibm.com, zippel@linux-m68k.org, andrea@suse.de
References: <20070201095952.589234000@jet.suse.cz> <20070201103754.281474000@jet.suse.cz>
In-Reply-To: <20070201103754.281474000@jet.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702011236.05429.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 February 2007 11:00, jbohac@suse.cz wrote:

> +		case VXTIME_TSC:
> +			rdtscll(tsc);

Where is the CPU synchronization? 

> +	cpu = smp_processor_id();
> +	rdtscll(t);

Also no synchronization. It's slower, but needed.

>  unsigned long long sched_clock(void)
>  {
> -	unsigned long a = 0;
> -
> -	rdtscll(a);
> -	return cycles_2_ns(a);
> +	return monotonic_clock();
>  }

This is overkill because sched_clock() doesn't need a globally monotonic
clock, per CPU monotonic is enough. The old version was fine.


> +static __always_inline void do_vgettimeofday(struct timeval * tv, u64 tsc, int cpu)
> +{
> +	unsigned int sec;
> +	s64 nsec;
>  
> -	do {
> -		sequence = read_seqbegin(&__xtime_lock);
> -		
> -		sec = __xtime.tv_sec;
> -		usec = __xtime.tv_nsec / 1000;
> -
> -			usec += ((readl((void __iomem *)
> -				   fix_to_virt(VSYSCALL_HPET) + 0xf0) -
> -				  __vxtime.last) * __vxtime.quot) >> 32;
> -	} while (read_seqretry(&__xtime_lock, sequence));
> +	sec = __xtime.tv_sec;
> +	nsec = __xtime.tv_nsec;
> +	nsec +=	max(__do_gettimeoffset(tsc, cpu), __vxtime.drift);
>  
> -	tv->tv_sec = sec + usec / 1000000;
> -	tv->tv_usec = usec % 1000000;
> +	sec += nsec / NSEC_PER_SEC;
> +	nsec %= NSEC_PER_SEC;

Using while() here is probably faster (done in vdso patchkit where
gtod got mysteriously faster). Modulo and divisions are slow, even 
for constants when they are large.

You might want to use the algorithm from 
ftp://one.firstfloor.org/pub/ak/x86_64/quilt/patches/vdso

> +	if (nsec < 0) {
> +		--sec;
> +		nsec += NSEC_PER_SEC;
> +	}
> +	tv->tv_sec = sec;
> +	tv->tv_usec = nsec / NSEC_PER_USEC;

Similar. 

>  }
>  
>  /* RED-PEN may want to readd seq locking, but then the variable should be write-once. */
> @@ -107,10 +118,39 @@ static __always_inline long time_syscall
>  
>  int __vsyscall(0) vgettimeofday(struct timeval * tv, struct timezone * tz)
>  {
> -	if (!__sysctl_vsyscall)
> +	int cpu = 0;
> +	u64 tsc;
> +	unsigned long seq;
> +	int do_syscall = !__sysctl_vsyscall;
> +
> +	if (tv && !do_syscall)
> +		switch (__vxtime.mode) {
> +			case VXTIME_TSC:
> +			case VXTIME_TSCP:
> +				do {
> +					seq = read_seqbegin(&__xtime_lock);
> +
> +					if (__vxtime.mode == VXTIME_TSC)
> +						rdtscll(tsc);
> +					else {
> +						rdtscpll(tsc, cpu);
> +						cpu &= 0xfff;
> +					}
> +
> +					if (unlikely(__vxtime.cpu[cpu].tsc_invalid))
> +						do_syscall = 1;
> +					else
> +						do_vgettimeofday(tv, tsc, cpu);
> +
> +				} while (read_seqretry(&__xtime_lock, seq));
> +				break;
> +			default:
> +				do_syscall = 1;

Why do you not set __sysctl_vsyscall correctly for the mode at initialization?


-Andi
