Return-Path: <linux-kernel-owner+w=401wt.eu-S1760208AbYDTUZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760208AbYDTUZn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 16:25:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756157AbYDTUZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 16:25:36 -0400
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:48485 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755946AbYDTUZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 16:25:35 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AswEANdDC0hMROPA/2dsb2JhbACBUKc9
Date: Sun, 20 Apr 2008 16:25:33 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Pekka Paalanen <pq@iki.fi>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] Check for breakpoint in text_poke to eliminate bug_on
Message-ID: <20080420202533.GA16538@Krystal>
References: <20080419184137.79957a07@daedalus.pq.iki.fi> <20080419161956.GA24685@Krystal> <20080420000657.20ba6b4b@daedalus.pq.iki.fi> <20080420005208.12ad32fd@daedalus.pq.iki.fi> <20080419215826.GC2831@Krystal> <20080420014206.5cd61d4a@daedalus.pq.iki.fi> <20080420000509.GA7496@Krystal> <20080420101408.518b21b4@daedalus.pq.iki.fi> <20080420194440.GA15319@Krystal> <20080420231838.21eaf426@daedalus.pq.iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080420231838.21eaf426@daedalus.pq.iki.fi>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:23:16 up 51 days, 16:34,  3 users,  load average: 0.68, 0.35,
	0.26
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pekka Paalanen (pq@iki.fi) wrote:
> On Sun, 20 Apr 2008 15:44:40 -0400
> Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > Can you test this new version ? The check was buggy when it fell on a
> > code boundary : the addr - 1 wan't always a valid address.
> > 
> 
> Sorry, still the same. Btw. I had to apply your patch by hand on top of
> your previous patch, and it ended up as just
> 
> --- a/arch/x86/kernel/alternative.c
> +++ b/arch/x86/kernel/alternative.c
> @@ -520,11 +520,6 @@ void *__kprobes text_poke(void *addr, const void *opcode, size_t len)
>         struct page *pages[2];
>         int i;
>  
> -       if (*((uint8_t *)addr - 1) != BREAKPOINT_INSTRUCTION) {
> -               BUG_ON(len > sizeof(long));
> -               BUG_ON((((long)addr + len - 1) & ~(sizeof(long) - 1))
> -                       - ((long)addr & ~(sizeof(long) - 1)));
> -       }
>         if (!core_kernel_text((unsigned long)addr)) {
> 
> Now I took a log of echo 0, echo 1 cycle with 2.6.24-gentoo-r1-trace
> kernel:
> [  203.448534] CPU 1 is now offline
> [  203.448975] SMP alternatives: switching to UP code
> [  217.888298] SMP alternatives: switching to SMP code
> [  217.889285] Booting processor 1/2 APIC 0x1
> [  217.901404] Initializing CPU#1
> [  217.982081] Calibrating delay using timer specific routine.. 3991.35 BogoMIPS (lpj=6650167)
> [  217.982088] CPU: L1 I cache: 32K, L1 D cache: 32K
> [  217.982089] CPU: L2 cache: 4096K
> [  217.982091] CPU: Physical Processor ID: 0
> [  217.982092] CPU: Processor Core ID: 1
> [  217.982593] Intel(R) Core(TM)2 Duo CPU     T7300  @ 2.00GHz stepping 0a
> [  217.982644] Switched to high resolution mode on CPU 1
> 
> And the failing log from the latest try is:
> 
> [   87.064970] CPU 1 is now offline
> [   87.065311] lockdep: fixing up alternatives.
> [   87.065694] SMP alternatives: switching to UP code
> [   97.192213] lockdep: fixing up alternatives.
> [   97.192532] SMP alternatives: switching to SMP code
> [   97.203495] Booting processor 1/1 ip 6000
> and it hangs and reboots.
> 
> Does it make sense to bisect on sched-devel/latest?
> I think I could try that after a sleep&work cycle.
> Luckily this bug is easy to reproduce.
> 

Yup. I was able to successfully cycle cpu hotplug with 2.6.25 mainline
with the equivalent of the text_poke patches I sent to you, therefore I
guess it rules out text_poke as a cause of your crash. A bisection of
sched-devel/latest seems appropriate.

Mathieu

> 
> Thanks.
> 
> -- 
> Pekka Paalanen
> http://www.iki.fi/pq/

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
