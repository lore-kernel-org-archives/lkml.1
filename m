Return-Path: <linux-kernel-owner+w=401wt.eu-S1758872AbZBLMv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758872AbZBLMv2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 07:51:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758862AbZBLMuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 07:50:37 -0500
Received: from one.firstfloor.org ([213.235.205.2]:54460 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758794AbZBLMug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 07:50:36 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <20090212149.227733077@firstfloor.org>
In-Reply-To: <20090212149.227733077@firstfloor.org>
To: akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: [PATCH] [3/9] x86: CMCI: Avoid potential reentry of threshold interrupt
Message-Id: <20090212124932.495733E666E@basil.firstfloor.org>
Date: Thu, 12 Feb 2009 13:49:32 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: minor bugfix 

The threshold handler on AMD (and soon on Intel) could be theoretically
reentered by the hardware. This could lead to corrupted events
because the machine check poll code assumes it is not reentered.

Move the APIC ACK to the end of the interrupt handler to let
the hardware avoid that.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kernel/cpu/mcheck/threshold.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux/arch/x86/kernel/cpu/mcheck/threshold.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/threshold.c	2009-02-12 11:30:51.000000000 +0100
+++ linux/arch/x86/kernel/cpu/mcheck/threshold.c	2009-02-12 11:30:51.000000000 +0100
@@ -15,10 +15,11 @@
 
 asmlinkage void mce_threshold_interrupt(void)
 {
-	ack_APIC_irq();
 	exit_idle();
 	irq_enter();
 	inc_irq_stat(irq_threshold_count);
 	mce_threshold_vector();
 	irq_exit();
+	/* Ack only at the end to avoid potential reentry */
+	ack_APIC_irq();
 }
