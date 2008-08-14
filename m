Return-Path: <linux-kernel-owner+w=401wt.eu-S1758960AbYHNNh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758960AbYHNNh0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 09:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbYHNNhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 09:37:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47276 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751443AbYHNNhP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 09:37:15 -0400
Date: Thu, 14 Aug 2008 15:36:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] irq: sparse irqs, fix #2
Message-ID: <20080814133652.GA10972@elte.hu>
References: <1218705441-21838-1-git-send-email-yhlu.kernel@gmail.com> <20080814132638.GA18743@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080814132638.GA18743@elte.hu>
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


>From 28f153577fc82ff93cd63472134b40f0634bff70 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Thu, 14 Aug 2008 15:38:50 +0200
Subject: [PATCH] irq: sparse irqs, fix #2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

fix:

 In file included from arch/x86/kernel/setup.c:99:
 include/asm-x86/mach-default/mach_apic.h:142: error: expected ‘)’ before ‘->’ token

That hunk got mis-merged.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/asm-x86/mach-default/mach_apic.h |   27 ++++++++++++++-------------
 1 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/include/asm-x86/mach-default/mach_apic.h b/include/asm-x86/mach-default/mach_apic.h
index a4a8f92..ea04182 100644
--- a/include/asm-x86/mach-default/mach_apic.h
+++ b/include/asm-x86/mach-default/mach_apic.h
@@ -85,6 +85,20 @@ static inline int apicid_to_node(int logical_apicid)
 	return 0;
 #endif
 }
+
+static inline cpumask_t vector_allocation_domain(int cpu)
+{
+        /* Careful. Some cpus do not strictly honor the set of cpus
+         * specified in the interrupt destination when using lowest
+         * priority interrupt delivery mode.
+         *
+         * In particular there was a hyperthreading cpu observed to
+         * deliver interrupts to the wrong hyperthread when only one
+         * hyperthread was specified in the interrupt desitination.
+         */
+        cpumask_t domain = { { [0] = APIC_ALL_CPUS, } };
+        return domain;
+}
 #endif
 
 static inline unsigned long check_apicid_used(physid_mask_t bitmap, int apicid)
@@ -139,18 +153,5 @@ static inline void enable_apic_mode(void)
 {
 }
 
-static inline cpumask_t vector_allocation_domain(int cpu)
-{
-        /* Careful. Some cpus do not strictly honor the set of cpus
-         * specified in the interrupt destination when using lowest
-         * priority interrupt delivery mode.
-         *
-         * In particular there was a hyperthreading cpu observed to
-         * deliver interrupts to the wrong hyperthread when only one
-         * hyperthread was specified in the interrupt desitination.
-         */
-        cpumask_t domain = { { [0] = APIC_ALL_CPUS, } };
-        return domain;
-}
 #endif /* CONFIG_X86_LOCAL_APIC */
 #endif /* ASM_X86__MACH_DEFAULT__MACH_APIC_H */
