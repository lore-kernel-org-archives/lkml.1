Return-Path: <linux-kernel-owner+w=401wt.eu-S1758785AbZFJVvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758785AbZFJVvv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 17:51:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756189AbZFJVvn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 17:51:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40691 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755731AbZFJVvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 17:51:43 -0400
Date: Wed, 10 Jun 2009 23:51:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/vdso for v2.6.31
Message-ID: <20090610215135.GA26565@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-vdso-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-vdso-for-linus

 Thanks,

	Ingo

------------------>
Petr Tesarik (1):
      x86: move rdtsc_barrier() into the TSC vread method


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
