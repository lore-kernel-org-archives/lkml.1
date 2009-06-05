Return-Path: <linux-kernel-owner+w=401wt.eu-S1756845AbZFEIXF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845AbZFEIXF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 04:23:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755950AbZFEIHB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 04:07:01 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37588 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755767AbZFEIGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 04:06:10 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 51/62] Blackfin: check SIC defines rather than variant names
Date: Fri,  5 Jun 2009 04:05:00 -0400
Message-Id: <1244189111-19639-52-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
References: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than having to maintain a hard coded list of Blackfin variants, use
the SIC defines themselves.  This fixes build problems on BF51x/BF538 under
some configurations as they were missing from one of the lists.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/mach-common/ints-priority.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/arch/blackfin/mach-common/ints-priority.c b/arch/blackfin/mach-common/ints-priority.c
index 6e80861..351afd0 100644
--- a/arch/blackfin/mach-common/ints-priority.c
+++ b/arch/blackfin/mach-common/ints-priority.c
@@ -1152,23 +1152,22 @@ void do_irq(int vec, struct pt_regs *fp)
 	} else {
 		struct ivgx *ivg = ivg7_13[vec - IVG7].ifirst;
 		struct ivgx *ivg_stop = ivg7_13[vec - IVG7].istop;
-#if defined(CONFIG_BF54x) || defined(CONFIG_BF52x) || defined(CONFIG_BF561) \
-	|| defined(BF538_FAMILY) || defined(CONFIG_BF51x)
+#if defined(SIC_ISR0) || defined(SICA_ISR0)
 		unsigned long sic_status[3];
 
 		if (smp_processor_id()) {
-#ifdef CONFIG_SMP
+# ifdef SICB_ISR0
 			/* This will be optimized out in UP mode. */
 			sic_status[0] = bfin_read_SICB_ISR0() & bfin_read_SICB_IMASK0();
 			sic_status[1] = bfin_read_SICB_ISR1() & bfin_read_SICB_IMASK1();
-#endif
+# endif
 		} else {
 			sic_status[0] = bfin_read_SIC_ISR0() & bfin_read_SIC_IMASK0();
 			sic_status[1] = bfin_read_SIC_ISR1() & bfin_read_SIC_IMASK1();
 		}
-#ifdef CONFIG_BF54x
+# ifdef SIC_ISR2
 		sic_status[2] = bfin_read_SIC_ISR2() & bfin_read_SIC_IMASK2();
-#endif
+# endif
 		for (;; ivg++) {
 			if (ivg >= ivg_stop) {
 				atomic_inc(&num_spurious);
@@ -1234,14 +1233,14 @@ asmlinkage int __ipipe_grab_irq(int vec, struct pt_regs *regs)
 		irq = IRQ_CORETMR;
 
 	} else {
-#if defined(CONFIG_BF54x) || defined(CONFIG_BF52x) || defined(CONFIG_BF561)
+#if defined(SIC_ISR0) || defined(SICA_ISR0)
 		unsigned long sic_status[3];
 
 		sic_status[0] = bfin_read_SIC_ISR0() & bfin_read_SIC_IMASK0();
 		sic_status[1] = bfin_read_SIC_ISR1() & bfin_read_SIC_IMASK1();
-#ifdef CONFIG_BF54x
+# ifdef SIC_ISR2
 		sic_status[2] = bfin_read_SIC_ISR2() & bfin_read_SIC_IMASK2();
-#endif
+# endif
 		for (;; ivg++) {
 			if (ivg >= ivg_stop) {
 				atomic_inc(&num_spurious);
-- 
1.6.3.1

