Return-Path: <linux-kernel-owner+w=401wt.eu-S1754694AbZA1Vpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694AbZA1Vpy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 16:45:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752950AbZA1Vpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 16:45:34 -0500
Received: from www.tglx.de ([62.245.132.106]:45157 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752585AbZA1Vpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 16:45:33 -0500
Message-Id: <20090128212709.228268535@linutronix.de>
References: <20090128211912.300823284@linutronix.de>
User-Agent: quilt/0.46-1
Date: Wed, 28 Jan 2009 21:29:12 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Carsten Emde <carsten.emde@osadl.org>
Subject: [patch-rt 2/4] ftrace: fix erroneous histogram stop WARN_ON() messages
Content-Disposition: inline;
	filename=fix-erroneous-histogram-stop-warn-on-messages.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IRQs are temporarily disabled during histogram calculation in
cycles_2_ns(). This causes a nested irqs_off histogram processing
which emittes an erroneous WARN_ON() message and also confuses the
histogramm output.

Change local_irq to raw_local_irq in cycles_2_ns to prevent irqs_off
histogram processing.

Tested-by: Carsten Emde <C.Emde@osadl.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 include/asm-x86/timer.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.26/include/asm-x86/timer.h
===================================================================
--- linux-2.6.26.orig/include/asm-x86/timer.h
+++ linux-2.6.26/include/asm-x86/timer.h
@@ -53,9 +53,9 @@ static inline notrace unsigned long long
 	unsigned long long ns;
 	unsigned long flags;
 
-	local_irq_save(flags);
+	raw_local_irq_save(flags);
 	ns = __cycles_2_ns(cyc);
-	local_irq_restore(flags);
+	raw_local_irq_restore(flags);
 
 	return ns;
 }

-- 

