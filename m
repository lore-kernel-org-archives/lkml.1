Return-Path: <linux-kernel-owner+w=401wt.eu-S1161164AbXBAPXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161164AbXBAPXv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 10:23:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030599AbXBAPXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 10:23:51 -0500
Received: from styx.suse.cz ([82.119.242.94]:33904 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030598AbXBAPXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 10:23:50 -0500
Date: Thu, 1 Feb 2007 16:23:40 +0100
From: Vojtech Pavlik <vojtech@suse.cz>
To: Jiri Bohac <jbohac@suse.cz>
Cc: Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org,
       ssouhlal@freebsd.org, arjan@infradead.org, tglx@linutronix.de,
       johnstul@us.ibm.com, zippel@linux-m68k.org, andrea@suse.de
Subject: Re: [patch 9/9] Make use of the Master Timer
Message-ID: <20070201152340.GA20792@suse.cz>
References: <20070201095952.589234000@jet.suse.cz> <20070201103754.281474000@jet.suse.cz> <200702011236.05429.ak@suse.de> <20070201142927.GR21755@dwarf.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070201142927.GR21755@dwarf.suse.cz>
X-Bounce-Cookie: It's a lemon tree, dear Watson!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 01, 2007 at 03:29:31PM +0100, Jiri Bohac wrote:
> On Thu, Feb 01, 2007 at 12:36:05PM +0100, Andi Kleen wrote:
> > On Thursday 01 February 2007 11:00, jbohac@suse.cz wrote:
> > 
> > > +		case VXTIME_TSC:
> > > +			rdtscll(tsc);
> > 
> > Where is the CPU synchronization? 
> > 
> > > +	cpu = smp_processor_id();
> > > +	rdtscll(t);
> > 
> > Also no synchronization. It's slower, but needed.
> 
> Hmm, I wasn't sure. Why is it needed? How outdated can the
> result of RDTSC / RDTSCP be?
> 
> If I do:
> 	rdtscll(a)
> 	...
> 	rdtscll(b)
> is it guaranteed that (b > a) ?

On a single CPU this is always guaranteed. Even on AMD.

> > >  unsigned long long sched_clock(void)
> > >  {
> > > -	unsigned long a = 0;
> > > -
> > > -	rdtscll(a);
> > > -	return cycles_2_ns(a);
> > > +	return monotonic_clock();
> > >  }
> > 
> > This is overkill because sched_clock() doesn't need a globally monotonic
> > clock, per CPU monotonic is enough. The old version was fine.
> 
> OK, thanks for spotting this. I'll change it to use __guess_mt().
> (more or less equal to cycles_2_ns(), no need to maintain yet another
> tsc->ns ratio just for cycles_2_ns().

Will this also work correctly during CPU frequency changes?

> > > -	tv->tv_sec = sec + usec / 1000000;
> > > -	tv->tv_usec = usec % 1000000;
> > > +	sec += nsec / NSEC_PER_SEC;
> > > +	nsec %= NSEC_PER_SEC;
> > 
> > Using while() here is probably faster (done in vdso patchkit where
> > gtod got mysteriously faster). Modulo and divisions are slow, even 
> > for constants when they are large.
> 
> OK, will do that

I'd suggest benchmarking the difference.

-- 
Vojtech Pavlik
Director SuSE Labs
