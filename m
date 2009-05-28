Return-Path: <linux-kernel-owner+w=401wt.eu-S1761688AbZE1MTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761688AbZE1MTT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 08:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757354AbZE1MTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 08:19:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:59254 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755545AbZE1MTC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 08:19:02 -0400
Date: Thu, 28 May 2009 12:18:35 GMT
From: tip-bot for Petr Tesarik <ptesarik@suse.cz>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       stable@kernel.org, ptesarik@suse.cz, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       stable@kernel.org, tglx@linutronix.de, ptesarik@suse.cz
In-Reply-To: <9d0ea9ea0f866bdc1f4d76831221ae117f11ea67.1243241859.git.ptesarik@suse.cz>
References: <9d0ea9ea0f866bdc1f4d76831221ae117f11ea67.1243241859.git.ptesarik@suse.cz>
Subject: [tip:x86/vdso] x86: move rdtsc_barrier() into the TSC vread method
Message-ID: <tip-7d96fd41cadc55f4e00231c8c71b8e25c779f122@git.kernel.org>
Git-Commit-ID: 7d96fd41cadc55f4e00231c8c71b8e25c779f122
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 28 May 2009 12:18:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7d96fd41cadc55f4e00231c8c71b8e25c779f122
Gitweb:     http://git.kernel.org/tip/7d96fd41cadc55f4e00231c8c71b8e25c779f122
Author:     Petr Tesarik <ptesarik@suse.cz>
AuthorDate: Mon, 25 May 2009 11:02:02 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 28 May 2009 14:15:54 +0200

x86: move rdtsc_barrier() into the TSC vread method

The *fence instructions were moved to vsyscall_64.c by commit
cb9e35dce94a1b9c59d46224e8a94377d673e204.  But this breaks the
vDSO, because vread methods are also called from there.

Besides, the synchronization might be unnecessary for other
time sources than TSC.

[ Impact: fix potential time warp in VDSO ]

Signed-off-by: Petr Tesarik <ptesarik@suse.cz>
LKML-Reference: <9d0ea9ea0f866bdc1f4d76831221ae117f11ea67.1243241859.git.ptesarik@suse.cz>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
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
