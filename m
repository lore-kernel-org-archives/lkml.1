Return-Path: <linux-kernel-owner+w=401wt.eu-S1758649AbZBTOTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758649AbZBTOTV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 09:19:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752895AbZBTOTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 09:19:09 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34501 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059AbZBTOTH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 09:19:07 -0500
Date: Fri, 20 Feb 2009 15:18:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [git pull] x86 fixes
Message-ID: <20090220141855.GA15718@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
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

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

this includes the fix for the PMD permission bug that Steve 
found, and a VMI fix.

 Thanks,

	Ingo

------------------>
Alok N Kataria (1):
      x86, vmi: TSC going backwards check in vmi clocksource

Ingo Molnar (1):
      x86: use the right protections for split-up pagetables


 arch/x86/kernel/vmiclock_32.c |    5 ++++-
 arch/x86/mm/pageattr.c        |   15 +++++----------
 2 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/vmiclock_32.c b/arch/x86/kernel/vmiclock_32.c
index c4c1f9e..bde106c 100644
--- a/arch/x86/kernel/vmiclock_32.c
+++ b/arch/x86/kernel/vmiclock_32.c
@@ -283,10 +283,13 @@ void __devinit vmi_time_ap_init(void)
 #endif
 
 /** vmi clocksource */
+static struct clocksource clocksource_vmi;
 
 static cycle_t read_real_cycles(void)
 {
-	return vmi_timer_ops.get_cycle_counter(VMI_CYCLES_REAL);
+	cycle_t ret = (cycle_t)vmi_timer_ops.get_cycle_counter(VMI_CYCLES_REAL);
+	return ret >= clocksource_vmi.cycle_last ?
+		ret : clocksource_vmi.cycle_last;
 }
 
 static struct clocksource clocksource_vmi = {
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 8ca0d85..7be47d1 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -508,18 +508,13 @@ static int split_large_page(pte_t *kpte, unsigned long address)
 #endif
 
 	/*
-	 * Install the new, split up pagetable. Important details here:
+	 * Install the new, split up pagetable.
 	 *
-	 * On Intel the NX bit of all levels must be cleared to make a
-	 * page executable. See section 4.13.2 of Intel 64 and IA-32
-	 * Architectures Software Developer's Manual).
-	 *
-	 * Mark the entry present. The current mapping might be
-	 * set to not present, which we preserved above.
+	 * We use the standard kernel pagetable protections for the new
+	 * pagetable protections, the actual ptes set above control the
+	 * primary protection behavior:
 	 */
-	ref_prot = pte_pgprot(pte_mkexec(pte_clrhuge(*kpte)));
-	pgprot_val(ref_prot) |= _PAGE_PRESENT;
-	__set_pmd_pte(kpte, address, mk_pte(base, ref_prot));
+	__set_pmd_pte(kpte, address, mk_pte(base, __pgprot(_KERNPG_TABLE)));
 	base = NULL;
 
 out_unlock:
