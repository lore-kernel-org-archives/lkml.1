Return-Path: <linux-kernel-owner+w=401wt.eu-S1765953AbXLUAqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765953AbXLUAqx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 19:46:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755473AbXLUAqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 19:46:45 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49910 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755035AbXLUAqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 19:46:45 -0500
Date: Fri, 21 Dec 2007 01:46:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] x86 fixes
Message-ID: <20071221004625.GA14220@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull the latest x86 git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git

it includes a late-breaking regression fix for die() - caught by Andrew. 
Thanks!

	Ingo

------------------>
Ingo Molnar (1):
      x86: fix die() to not be preemptible

Jason Gaston (1):
      x86: intel_cacheinfo.c: cpu cache info entry for Intel Tolapai

 cpu/intel_cacheinfo.c |    1 +
 traps_32.c            |    7 +++----
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 606fe4d..9f530ff 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -49,6 +49,7 @@ static struct _cache_table cache_table[] __cpuinitdata =
 	{ 0x3c, LVL_2,      256 },	/* 4-way set assoc, sectored cache, 64 byte line size */
 	{ 0x3d, LVL_2,      384 },	/* 6-way set assoc, sectored cache, 64 byte line size */
 	{ 0x3e, LVL_2,      512 },	/* 4-way set assoc, sectored cache, 64 byte line size */
+	{ 0x3f, LVL_2,      256 },	/* 2-way set assoc, 64 byte line size */
 	{ 0x41, LVL_2,      128 },	/* 4-way set assoc, 32 byte line size */
 	{ 0x42, LVL_2,      256 },	/* 4-way set assoc, 32 byte line size */
 	{ 0x43, LVL_2,      512 },	/* 4-way set assoc, 32 byte line size */
diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
index ef60102..c88bbff 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -373,14 +373,13 @@ void die(const char * str, struct pt_regs * regs, long err)
 
 	if (die.lock_owner != raw_smp_processor_id()) {
 		console_verbose();
+		raw_local_irq_save(flags);
 		__raw_spin_lock(&die.lock);
-		raw_local_save_flags(flags);
 		die.lock_owner = smp_processor_id();
 		die.lock_owner_depth = 0;
 		bust_spinlocks(1);
-	}
-	else
-		raw_local_save_flags(flags);
+	} else
+		raw_local_irq_save(flags);
 
 	if (++die.lock_owner_depth < 3) {
 		unsigned long esp;
