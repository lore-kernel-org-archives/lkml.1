Return-Path: <linux-kernel-owner+w=401wt.eu-S1756325AbZCCU7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325AbZCCU7u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 15:59:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754202AbZCCU7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 15:59:40 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47804 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754178AbZCCU7k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 15:59:40 -0500
Date: Tue, 3 Mar 2009 21:59:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [git pull] x86 fixes
Message-ID: <20090303205922.GA27473@elte.hu>
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

 Thanks,

	Ingo

------------------>
Tim Blechmann (1):
      x86: oprofile: don't set counter width from cpuid on Core2

Yinghai Lu (1):
      x86: fix init_memory_mapping() to handle small ranges


 arch/x86/mm/init_64.c             |    2 ++
 arch/x86/oprofile/op_model_ppro.c |   14 ++++++++++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index e6d36b4..b135225 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -714,6 +714,8 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	pos = start_pfn << PAGE_SHIFT;
 	end_pfn = ((pos + (PMD_SIZE - 1)) >> PMD_SHIFT)
 			<< (PMD_SHIFT - PAGE_SHIFT);
+	if (end_pfn > (end >> PAGE_SHIFT))
+		end_pfn = end >> PAGE_SHIFT;
 	if (start_pfn < end_pfn) {
 		nr_range = save_mr(mr, nr_range, start_pfn, end_pfn, 0);
 		pos = end_pfn << PAGE_SHIFT;
diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
index e9f80c7..10131fb 100644
--- a/arch/x86/oprofile/op_model_ppro.c
+++ b/arch/x86/oprofile/op_model_ppro.c
@@ -78,8 +78,18 @@ static void ppro_setup_ctrs(struct op_msrs const * const msrs)
 	if (cpu_has_arch_perfmon) {
 		union cpuid10_eax eax;
 		eax.full = cpuid_eax(0xa);
-		if (counter_width < eax.split.bit_width)
-			counter_width = eax.split.bit_width;
+
+		/*
+		 * For Core2 (family 6, model 15), don't reset the
+		 * counter width:
+		 */
+		if (!(eax.split.version_id == 0 &&
+			current_cpu_data.x86 == 6 &&
+				current_cpu_data.x86_model == 15)) {
+
+			if (counter_width < eax.split.bit_width)
+				counter_width = eax.split.bit_width;
+		}
 	}
 
 	/* clear all counters */
