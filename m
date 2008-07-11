Return-Path: <linux-kernel-owner+w=401wt.eu-S1755653AbYGKShv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653AbYGKShv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 14:37:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753851AbYGKShm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 14:37:42 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:64598 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753844AbYGKShm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 14:37:42 -0400
Date: Fri, 11 Jul 2008 19:34:36 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ingo Molnar <mingo@elte.hu>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] x86: L-APIC: Set IRQ0 as edge-triggered
Message-ID: <Pine.LNX.4.55.0807111838530.31940@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 IRQ0 is edge-triggered, but the "8259A Virtual Wire" through the local
APIC configuration in the 32-bit version uses the "fasteoi" handler
suitable for level-triggered APIC interrupt.  Rewrite code so that the 
"edge" handler is used.  The 64-bit version uses different code and is 
unaffected.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>
---

 Note this is against linux-next.

patch-next-2.6.26-rc9-20080711-timer-lapic-edge-7
diff -up --recursive --new-file linux-next-2.6.26-rc9-20080711.macro/arch/x86/kernel/io_apic_32.c linux-next-2.6.26-rc9-20080711/arch/x86/kernel/io_apic_32.c
--- linux-next-2.6.26-rc9-20080711.macro/arch/x86/kernel/io_apic_32.c	2008-07-11 17:10:33.000000000 +0000
+++ linux-next-2.6.26-rc9-20080711/arch/x86/kernel/io_apic_32.c	2008-07-11 17:51:05.000000000 +0000
@@ -2052,7 +2052,7 @@ static struct irq_chip lapic_chip __read
 	.name		= "local-APIC",
 	.mask		= mask_lapic_irq,
 	.unmask		= unmask_lapic_irq,
-	.eoi		= ack_apic,
+	.ack		= ack_apic,
 };
 
 static void __init setup_nmi(void)
@@ -2257,8 +2257,8 @@ static inline void __init check_timer(vo
 
 	printk(KERN_INFO "...trying to set up timer as Virtual Wire IRQ...");
 
-	set_irq_chip_and_handler_name(0, &lapic_chip, handle_fasteoi_irq,
-				      "fasteoi");
+	set_irq_chip_and_handler_name(0, &lapic_chip, handle_edge_irq,
+				      "edge");
 	apic_write_around(APIC_LVT0, APIC_DM_FIXED | vector);	/* Fixed mode */
 	enable_8259A_irq(0);
 
