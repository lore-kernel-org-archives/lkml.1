Return-Path: <linux-kernel-owner+w=401wt.eu-S1765572AbXG0Mt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765572AbXG0Mt4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 08:49:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758209AbXG0Mtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 08:49:49 -0400
Received: from madara.hpl.hp.com ([192.6.19.124]:59940 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758478AbXG0Mts (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 08:49:48 -0400
Date: Fri, 27 Jul 2007 05:49:34 -0700
From: Stephane Eranian <eranian@hpl.hp.com>
To: linux-kernel@vger.kernel.org
Cc: ak@suse.de, akpm@linux-foundation.org,
       Stephane Eranian <eranian@hpl.hp.com>, B.Steinbrink@gmx.de
Subject: [PATCH] perfctr_watchdog: do not BUG_ON() when MSR is unknown
Message-ID: <20070727124934.GD9828@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is a small patch to change the behavior of the PMU msr allocator
to avoid BUG_ON() when the MSR is unknwon. Instead, it now returns
ok, which means "I do not manage". The current allocator is not
yet managing the full set of PMU registers (e.g., GLOBAL_* on Core 2).


    [watchdog] do not BUG_ON() in the MSR allocator if MSR is unknown, return ok instead
    
    signed-off-by: Stephane Eranian <eranian@hpl.hp.com>

diff --git a/arch/i386/kernel/cpu/perfctr-watchdog.c b/arch/i386/kernel/cpu/perfctr-watchdog.c
index 4be488e..9b5d6af 100644
--- a/arch/i386/kernel/cpu/perfctr-watchdog.c
+++ b/arch/i386/kernel/cpu/perfctr-watchdog.c
@@ -120,7 +120,9 @@ int reserve_perfctr_nmi(unsigned int msr)
 	unsigned int counter;
 
 	counter = nmi_perfctr_msr_to_bit(msr);
-	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
+	/* register not managed by the allocator? */
+	if (counter > NMI_MAX_COUNTER_BITS)
+		return 1;
 
 	if (!test_and_set_bit(counter, perfctr_nmi_owner))
 		return 1;
@@ -132,7 +134,9 @@ void release_perfctr_nmi(unsigned int msr)
 	unsigned int counter;
 
 	counter = nmi_perfctr_msr_to_bit(msr);
-	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
+	/* register not managed by the allocator? */
+	if (counter > NMI_MAX_COUNTER_BITS)
+		return;
 
 	clear_bit(counter, perfctr_nmi_owner);
 }
@@ -142,7 +146,9 @@ int reserve_evntsel_nmi(unsigned int msr)
 	unsigned int counter;
 
 	counter = nmi_evntsel_msr_to_bit(msr);
-	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
+	/* register not managed by the allocator? */
+	if (counter > NMI_MAX_COUNTER_BITS)
+		return 1;
 
 	if (!test_and_set_bit(counter, evntsel_nmi_owner))
 		return 1;
@@ -154,7 +160,9 @@ void release_evntsel_nmi(unsigned int msr)
 	unsigned int counter;
 
 	counter = nmi_evntsel_msr_to_bit(msr);
-	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
+	/* register not managed by the allocator? */
+	if (counter > NMI_MAX_COUNTER_BITS)
+		return;
 
 	clear_bit(counter, evntsel_nmi_owner);
 }
