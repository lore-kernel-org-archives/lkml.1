Return-Path: <linux-kernel-owner+w=401wt.eu-S1758856AbYKIUJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758856AbYKIUJV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 15:09:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756645AbYKIUCs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 15:02:48 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39042 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757057AbYKIUCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 15:02:47 -0500
Date: Sun, 9 Nov 2008 21:02:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
Subject: Re: [git pull] scheduler warning fix
Message-ID: <20081109200233.GA20152@elte.hu>
References: <20081109071915.GA15556@elte.hu> <alpine.LFD.2.00.0811091118590.3468@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.00.0811091118590.3468@nehalem.linux-foundation.org>
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

> 
> 
> On Sun, 9 Nov 2008, Ingo Molnar wrote:
> > 
> > Please pull the latest sched-fixes-for-linus git tree from:
> > 
> >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus
> > 
> > Fixes a silly build warning that slipped through yesterday, sorry 
> > about that.
> 
> Whaa?
> 
>   In file included from /home/torvalds/v2.6/linux/arch/x86/include/asm/timex.h:6,
>                    from include/linux/timex.h:202,
>                    from include/linux/jiffies.h:8,
>                    from include/linux/ktime.h:25,
>                    from include/linux/timer.h:5,
>                    from include/linux/workqueue.h:8,
>                    from include/linux/slub_def.h:11,
>                    from include/linux/slab.h:124,
>                    from include/linux/percpu.h:5,
>                    from include/linux/rcupdate.h:39,
>                    from include/linux/tracepoint.h:18,
>                    from include/linux/module.h:19,
>                    from include/linux/crypto.h:21,
>                    from arch/x86/kernel/asm-offsets_64.c:7,
>                    from arch/x86/kernel/asm-offsets.c:4:
>   /home/torvalds/v2.6/linux/arch/x86/include/asm/tsc.h: In function ‘vget_cycles’:
>   /home/torvalds/v2.6/linux/arch/x86/include/asm/tsc.h:46: error: ‘cycles’ undeclared (first use in this function)
>   /home/torvalds/v2.6/linux/arch/x86/include/asm/tsc.h:46: error: (Each undeclared identifier is reported only once
>   /home/torvalds/v2.6/linux/arch/x86/include/asm/tsc.h:46: error: for each function it appears in.)
>   make[1]: *** [arch/x86/kernel/asm-offsets.s] Error 1
>   make: *** [prepare0] Error 2
> 
> That makes no sense. You've apparently done some idiotic rebasing of 
> a patch that needs to be applied on top of an earlier patch into a 
> tree that does _not_ need it, and then send it as a pull request.
>
> What _are_ you doing?

Sigh, sorry - please disregard the pull request.

What happened is that the cleanup patch below introduced that warning 
- and this morning i noticed that warning and i thought i introduced 
an ugly warning upstream and did a quick fix in that branch - but it 
didnt actually need any fixing (and in fact it broke the build).

So upstream is fine and doesnt need any fix.

	Ingo

------------------------>
>From cb9e35dce94a1b9c59d46224e8a94377d673e204 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Sat, 8 Nov 2008 20:27:00 +0100
Subject: [PATCH] x86: clean up rdtsc_barrier() use

Impact: cleanup

Move rdtsc_barrier() use to vsyscall_64.c where it's relied on,
and point out its role in the context of its use.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/tsc.h    |    6 +-----
 arch/x86/kernel/vsyscall_64.c |    9 +++++++++
 2 files changed, 10 insertions(+), 5 deletions(-)

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
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 0b8b669..ebf2f12 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -128,7 +128,16 @@ static __always_inline void do_vgettimeofday(struct timeval * tv)
 			gettimeofday(tv,NULL);
 			return;
 		}
+
+		/*
+		 * Surround the RDTSC by barriers, to make sure it's not
+		 * speculated to outside the seqlock critical section and
+		 * does not cause time warps:
+		 */
+		rdtsc_barrier();
 		now = vread();
+		rdtsc_barrier();
+
 		base = __vsyscall_gtod_data.clock.cycle_last;
 		mask = __vsyscall_gtod_data.clock.mask;
 		mult = __vsyscall_gtod_data.clock.mult;
