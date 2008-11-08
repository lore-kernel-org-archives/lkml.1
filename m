Return-Path: <linux-kernel-owner+w=401wt.eu-S1753375AbYKHSwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375AbYKHSwn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 13:52:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbYKHSwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 13:52:34 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53559 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981AbYKHSwd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 13:52:33 -0500
Date: Sat, 8 Nov 2008 19:52:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] scheduler updates
Message-ID: <20081108185219.GA23413@elte.hu>
References: <20081108170224.GA553@elte.hu> <alpine.LFD.2.00.0811081026280.3468@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0811081026280.3468@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Sat, 8 Nov 2008, Ingo Molnar wrote:
> >
> > Ingo Molnar (2):
> >       sched: improve sched_clock() performance
> >       sched: optimize sched_clock() a bit
> 
> Btw, why do we do that _idiotic_ rdtsc_barrier() AT ALL?
> 
> No sane user can possibly want it. If you do 'rdtsc', there's 
> nothing you can do about a few cycles difference due to OoO 
> _anyway_. Adding barriers is entirely meaningless - it's not going 
> to make the return value mean anything else.
> 
> Can we please just remove that idiocy? Or can somebody give a _sane_ 
> argument for it?

yeah, i had the same thinking, so i zapped it for everything but the 
vdso driven vgettimeofday GTOD method.

For that one, i chickened out, because we have this use in 
arch/x86/kernel/vsyscall_64.c:

                now = vread();
                base = __vsyscall_gtod_data.clock.cycle_last;
                mask = __vsyscall_gtod_data.clock.mask;
                mult = __vsyscall_gtod_data.clock.mult;
                shift = __vsyscall_gtod_data.clock.shift;

which can be triggered by gettimeofday() on certain systems.

And i couldnt convince myself that this sequence couldnt result in 
userspace-observable GTOD time warps there, so i went for the obvious 
fix first.

If the "now = vread()"'s RDTSC instruction is speculated to after it 
reads cycle_last, and another vdso call shortly after this does 
another RDTSC in this same sequence, the two RDTSC's could be mixed up 
in theory, resulting in negative time?

I _think_ i heard some noises in the past that this could indeed 
happen (and have vague memories that this was the justification for 
the barrier's introduction), but have to check the old emails to 
figure out what exactly the issue was and on what CPUs.

It's not completely impossible for this to happen, as the vdso calls 
are really just simple function calls, so not nearly as strongly 
serialized as say a real syscall based gettimeofday() call.

In any case, it failed my "it must be obvious within 1 minute for it 
to be eligible for sched/urgent" threshold and i didnt want to 
introduce a time warp.

But you are right, and i've queued up the full fix below as well, as a 
reminder.

	Ingo

----------------->
>From 2efe2c42e008a80ebe1992db63749386778f7df8 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Sat, 8 Nov 2008 19:46:48 +0100
Subject: [PATCH] x86, time: remove rdtsc_barrier()

Linus pointed out that even for vread() rdtsc_barrier() is pointless
overhead - as due to speculative instructions there's no such thing
as reliable cycle count anyway.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/system.h |   13 -------------
 arch/x86/include/asm/tsc.h    |    6 +-----
 2 files changed, 1 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/system.h b/arch/x86/include/asm/system.h
index 2ed3f0f..1a1d45e 100644
--- a/arch/x86/include/asm/system.h
+++ b/arch/x86/include/asm/system.h
@@ -409,17 +409,4 @@ void default_idle(void);
 #define set_mb(var, value) do { var = value; barrier(); } while (0)
 #endif
 
-/*
- * Stop RDTSC speculation. This is needed when you need to use RDTSC
- * (or get_cycles or vread that possibly accesses the TSC) in a defined
- * code region.
- *
- * (Could use an alternative three way for this if there was one.)
- */
-static inline void rdtsc_barrier(void)
-{
-	alternative(ASM_NOP3, "mfence", X86_FEATURE_MFENCE_RDTSC);
-	alternative(ASM_NOP3, "lfence", X86_FEATURE_LFENCE_RDTSC);
-}
-
 #endif /* _ASM_X86_SYSTEM_H */
diff --git a/arch/x86/include/asm/tsc.h b/arch/x86/include/asm/tsc.h
index 9cd83a8..700aeb8 100644
--- a/arch/x86/include/asm/tsc.h
+++ b/arch/x86/include/asm/tsc.h
@@ -44,11 +44,7 @@ static __always_inline cycles_t vget_cycles(void)
 	if (!cpu_has_tsc)
 		return 0;
 #endif
-	rdtsc_barrier();
-	cycles = (cycles_t)__native_read_tsc();
-	rdtsc_barrier();
-
-	return cycles;
+	return (cycles_t)__native_read_tsc();
 }
 
 extern void tsc_init(void);
