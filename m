Return-Path: <linux-kernel-owner+w=401wt.eu-S1754668AbYKHRCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668AbYKHRCr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 12:02:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753604AbYKHRCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 12:02:39 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40743 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753591AbYKHRCi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 12:02:38 -0500
Date: Sat, 8 Nov 2008 18:02:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
Subject: [git pull] scheduler updates
Message-ID: <20081108170224.GA553@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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

Linus,

Please pull the latest scheduler updates git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

 Thanks,

	Ingo

------------------>
Ingo Molnar (2):
      sched: improve sched_clock() performance
      sched: optimize sched_clock() a bit


 arch/x86/include/asm/msr.h |    2 --
 arch/x86/include/asm/tsc.h |    8 +++++++-
 arch/x86/kernel/tsc.c      |    2 +-
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index 46be2fa..c2a812e 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -108,9 +108,7 @@ static __always_inline unsigned long long __native_read_tsc(void)
 {
 	DECLARE_ARGS(val, low, high);
 
-	rdtsc_barrier();
 	asm volatile("rdtsc" : EAX_EDX_RET(val, low, high));
-	rdtsc_barrier();
 
 	return EAX_EDX_VAL(val, low, high);
 }
diff --git a/arch/x86/include/asm/tsc.h b/arch/x86/include/asm/tsc.h
index 38ae163..9cd83a8 100644
--- a/arch/x86/include/asm/tsc.h
+++ b/arch/x86/include/asm/tsc.h
@@ -34,6 +34,8 @@ static inline cycles_t get_cycles(void)
 
 static __always_inline cycles_t vget_cycles(void)
 {
+	cycles_t cycles;
+
 	/*
 	 * We only do VDSOs on TSC capable CPUs, so this shouldnt
 	 * access boot_cpu_data (which is not VDSO-safe):
@@ -42,7 +44,11 @@ static __always_inline cycles_t vget_cycles(void)
 	if (!cpu_has_tsc)
 		return 0;
 #endif
-	return (cycles_t)__native_read_tsc();
+	rdtsc_barrier();
+	cycles = (cycles_t)__native_read_tsc();
+	rdtsc_barrier();
+
+	return cycles;
 }
 
 extern void tsc_init(void);
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 2ef80e3..424093b 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -55,7 +55,7 @@ u64 native_sched_clock(void)
 	rdtscll(this_offset);
 
 	/* return the value in ns */
-	return cycles_2_ns(this_offset);
+	return __cycles_2_ns(this_offset);
 }
 
 /* We need to define a real function for sched_clock, to override the
