Return-Path: <linux-kernel-owner+w=401wt.eu-S1764285AbXIUUuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764285AbXIUUuT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 16:50:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758228AbXIUUpD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 16:45:03 -0400
Received: from mail.suse.de ([195.135.220.2]:50031 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763223AbXIUUo6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 16:44:58 -0400
From: Andi Kleen <ak@suse.de>
References: <200709211044.901175000@suse.de>
In-Reply-To: <200709211044.901175000@suse.de>
To: eranian@hpl.hp.com, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [16/45] i386: do not BUG_ON() when MSR is unknown
Message-Id: <20070921204457.E09FE14EFF@wotan.suse.de>
Date: Fri, 21 Sep 2007 22:44:57 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Stephane Eranian <eranian@hpl.hp.com>

Here is a small patch to change the behavior of the PMU msr allocator
to avoid BUG_ON() when the MSR is unknwon. Instead, it now returns
ok, which means "I do not manage". The current allocator is not
yet managing the full set of PMU registers (e.g., GLOBAL_* on Core 2).

[watchdog] do not BUG_ON() in the MSR allocator if MSR is unknown, return ok 
instead
    
Signed-off-by: Stephane Eranian <eranian@hpl.hp.com>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/kernel/cpu/perfctr-watchdog.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

Index: linux/arch/i386/kernel/cpu/perfctr-watchdog.c
===================================================================
--- linux.orig/arch/i386/kernel/cpu/perfctr-watchdog.c
+++ linux/arch/i386/kernel/cpu/perfctr-watchdog.c
@@ -120,7 +120,9 @@ int reserve_perfctr_nmi(unsigned int msr
 	unsigned int counter;
 
 	counter = nmi_perfctr_msr_to_bit(msr);
-	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
+	/* register not managed by the allocator? */
+	if (counter > NMI_MAX_COUNTER_BITS)
+		return 1;
 
 	if (!test_and_set_bit(counter, perfctr_nmi_owner))
 		return 1;
@@ -132,7 +134,9 @@ void release_perfctr_nmi(unsigned int ms
 	unsigned int counter;
 
 	counter = nmi_perfctr_msr_to_bit(msr);
-	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
+	/* register not managed by the allocator? */
+	if (counter > NMI_MAX_COUNTER_BITS)
+		return;
 
 	clear_bit(counter, perfctr_nmi_owner);
 }
@@ -142,7 +146,9 @@ int reserve_evntsel_nmi(unsigned int msr
 	unsigned int counter;
 
 	counter = nmi_evntsel_msr_to_bit(msr);
-	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
+	/* register not managed by the allocator? */
+	if (counter > NMI_MAX_COUNTER_BITS)
+		return 1;
 
 	if (!test_and_set_bit(counter, evntsel_nmi_owner))
 		return 1;
@@ -154,7 +160,9 @@ void release_evntsel_nmi(unsigned int ms
 	unsigned int counter;
 
 	counter = nmi_evntsel_msr_to_bit(msr);
-	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
+	/* register not managed by the allocator? */
+	if (counter > NMI_MAX_COUNTER_BITS)
+		return;
 
 	clear_bit(counter, evntsel_nmi_owner);
 }
