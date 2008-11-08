Return-Path: <linux-kernel-owner+w=401wt.eu-S1753271AbYKHTaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271AbYKHTaY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 14:30:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751244AbYKHTaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 14:30:10 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51372 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183AbYKHTaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 14:30:08 -0500
Date: Sat, 8 Nov 2008 20:29:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
Subject: Re: [git pull] scheduler updates
Message-ID: <20081108192957.GA22219@elte.hu>
References: <20081108170224.GA553@elte.hu> <alpine.LFD.2.00.0811081026280.3468@nehalem.linux-foundation.org> <20081108104116.48bd26e6@infradead.org> <alpine.LFD.2.00.0811081051190.3468@nehalem.linux-foundation.org> <20081108190517.GA9806@elte.hu> <alpine.LFD.2.00.0811081115290.3468@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0811081115290.3468@nehalem.linux-foundation.org>
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
> > So that's why my change moves it from the __native_read_tsc() over to 
> > _only_ the vget_cycles().
> 
> Ahh. I was looking at native_read_tscp(). Which has no barriers. But then 
> we don't actually save the actual TSC, we only end up using the "p" part, 
> so we don't care..
> 
> Anyway, even for the vget_cycles(), is there really any reason to 
> have _two_ barriers? Also, I still think it would be a hell of a lot 
> more readable and logical to put the barriers in the _caller_, so 
> that people actually see what the barriers are there for.
> 
> When they are hidden, they make no sense. The helper function just 
> has two insane barriers without explanation, and the caller doesn't 
> know that the code is serialized wrt something random.

ok, fully agreed, i've queued up the cleanup for that, see it below.

sidenote: i still kept the get_cycles() versus vget_cycles() 
distinction, to preserve the explicit marker that vget_cycles() is 
used in user-space mode code. We periodically forgot about that in the 
past. But otherwise, the two inline functions are now identical. 
(except for the assymetry of its inlining, and the comment about the 
boot_cpu_data use of the has_tsc check)

	Ingo

--------------->
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

