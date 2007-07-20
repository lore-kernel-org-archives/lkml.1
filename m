Return-Path: <linux-kernel-owner+w=401wt.eu-S932424AbXGTOjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932424AbXGTOjZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 10:39:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763434AbXGTOjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 10:39:18 -0400
Received: from tomts22.bellnexxia.net ([209.226.175.184]:49252 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757773AbXGTOjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 10:39:17 -0400
Date: Fri, 20 Jul 2007 10:39:07 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Andi Kleen <ak@suse.de>
Cc: patches@x86-64.org, linux-kernel@vger.kernel.org,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: [PATCH] [15/58] i386: Rewrite sched_clock
Message-ID: <20070720143907.GC29979@Krystal>
References: <200707191154.642492000@suse.de> <1184863904.6458.17.camel@dhcp193.mvista.com> <20070720031105.GA8237@Krystal> <200707201027.46532.ak@suse.de> <20070720141210.GA29979@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070720141210.GA29979@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 10:37:21 up 3 days,  9:11,  2 users,  load average: 0.58, 0.54, 0.87
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> * Andi Kleen (ak@suse.de) wrote:
> > 
> > > I noticed the same thing about interrupts off when going through the
> > > code.
> > 
> > That's only on a slow path during cpu frequency changing while the TSC is instable.
> > Shouldn't be that common.
> > 
> > -Andi
> 
> Hrm, I don't see why you can get away without disabling interrupts in
> the fast path:
> 
> +unsigned long long tsc_sched_clock(void)
> +{
> +       unsigned long long r;
> +       struct sc_data *sc = &get_cpu_var(sc_data);
> +       
> +       if (unlikely(sc->unstable)) {
> +               r = (jiffies_64 - sc->sync_base) * (1000000000 / HZ);
> +               r += sc->ns_base;
> +               /*
> +                * last_val is used to avoid non monotonity on a
> +                * stable->unstable transition. Make sure the time
> +                * never goes to before the last value returned by the
> +                * TSC clock.
> +                */
> +               while (r <= sc->last_val) {
> +                       rmb();
> +                       r = sc->last_val + 1;
> +                       rmb();
> +               }
> +               sc->last_val = r;
> 
> Here, slow path, we update last_val (64 bits value). Must be protected.
> 
> +       } else {
> +               rdtscll(r);
> +               r = __cycles_2_ns(sc, r);
> +               sc->last_val = r;
> 
> Here, fast path, we update last_val too so it is ready to be read when
> the tsc will become unstable.
> 
> If we don't disable interrupts around its update, we could have: (LSB vs
> MSB update order is arbitrary)
> 
> update sc->last_val 32MSB
>   interrupt comes
>     update sc->last_val 32MSB
>     update sc->last_val 32LSB
>   iret
> update sc->last_val 32LSB
> 
> So if, after this, we run tsc_sched_clock() with an unstable TSC, we
> read a last_val containing the interrupt's MSB and the last_val LSB. It
> can particularity hurt if we are around a 32 bits overflow, because time
> could "jump" forward of about 1.43 seconds on a 3 GHz system.
> 
> So I guess we need synchronization on the fast path, and therefore using
> cmpxchg_local on x86_64 and cmpxchg64_local on i386 makes sense.
> 

The case above explained the issue for i386. For x86_64, the race goes
like this:

read tsc
  interrupt
  read tsc
  update sc->last_val
  iret
update sc->last_val

Here, last_val is not at its highest value anymore. This is why a
cmpxchg is useful on x86_64.

Mathieu


> Mathieu
> 
> +       }
> + 
> +       put_cpu_var(sc_data);
> +       
> +       return r;
> +}
> 
> 
> 
> -- 
> Mathieu Desnoyers
> Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
