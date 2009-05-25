Return-Path: <linux-kernel-owner+w=401wt.eu-S1757422AbZEYJCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422AbZEYJCZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 05:02:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754207AbZEYJCD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 05:02:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60064 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755508AbZEYJCC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 05:02:02 -0400
From: Petr Tesarik <ptesarik@suse.cz>
To: linux-kernel@vger.kernel.org, tglx@linutronix.de, andi@firstfloor.org
Cc: Petr Tesarik <ptesarik@suse.cz>, Ingo Molnar <mingo@elte.hu>,
       <stable@kernel.org>
Subject: [PATCH 1/1] Move rdtsc_barrier() into the TSC vread method
Date: Mon, 25 May 2009 11:02:02 +0200
Message-Id: <9d0ea9ea0f866bdc1f4d76831221ae117f11ea67.1243241859.git.ptesarik@suse.cz>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The *fence instructions were moved to vsyscall_64.c by commit
cb9e35dce94a1b9c59d46224e8a94377d673e204.  But this breaks the
vDSO, because vread methods are also called from there.

Besides, the synchronization might be unnecessary for other
time sources than TSC.

Signed-off-by: Petr Tesarik <ptesarik@suse.cz>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: <stable@kernel.org>
---
 arch/x86/kernel/tsc.c         |   11 ++++++++++-
 arch/x86/kernel/vsyscall_64.c |    8 --------
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index d57de05..cf8611d 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -710,7 +710,16 @@ static cycle_t read_tsc(struct clocksource *cs)
 #ifdef CONFIG_X86_64
 static cycle_t __vsyscall_fn vread_tsc(void)
 {
-	cycle_t ret = (cycle_t)vget_cycles();
+	cycle_t ret;
+
+	/*
+	 * Surround the RDTSC by barriers, to make sure it's not
+	 * speculated to outside the seqlock critical section and
+	 * does not cause time warps:
+	 */
+	rdtsc_barrier();
+	ret = (cycle_t)vget_cycles();
+	rdtsc_barrier();
 
 	return ret >= __vsyscall_gtod_data.clock.cycle_last ?
 		ret : __vsyscall_gtod_data.clock.cycle_last;
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 44153af..25ee06a 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -132,15 +132,7 @@ static __always_inline void do_vgettimeofday(struct timeval * tv)
 			return;
 		}
 
-		/*
-		 * Surround the RDTSC by barriers, to make sure it's not
-		 * speculated to outside the seqlock critical section and
-		 * does not cause time warps:
-		 */
-		rdtsc_barrier();
 		now = vread();
-		rdtsc_barrier();
-
 		base = __vsyscall_gtod_data.clock.cycle_last;
 		mask = __vsyscall_gtod_data.clock.mask;
 		mult = __vsyscall_gtod_data.clock.mult;
-- 
1.6.0.2

