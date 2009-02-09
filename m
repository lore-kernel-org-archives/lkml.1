Return-Path: <linux-kernel-owner+w=401wt.eu-S1755727AbZBJUIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727AbZBJUIn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 15:08:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755355AbZBJUH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 15:07:29 -0500
Received: from gw.goop.org ([64.81.55.164]:50714 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755078AbZBJUH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 15:07:27 -0500
Message-Id: <ca97ab90164c7b978abf9d82dc82d6dc2cbac4a0.1234296039.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1234296039.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1234296039.git.jeremy.fitzhardinge@citrix.com>
From: Jeremy Fitzhardinge <jeremy@goop.org>
Date: Mon, 9 Feb 2009 12:05:47 -0800
Subject: [PATCH] x86: unstatic ioapic entry funcs
Cc: Ingo Molnar <mingo@elte.hu>, x86@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yinghai@kernel.org>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unstatic ioapic_write_entry and setup_ioapic_entry functions so that
the Xen code can do its own ioapic routing setup.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/io_apic.h |    6 ++++++
 arch/x86/kernel/io_apic.c      |   10 +++++-----
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 309d0e2..59cb4a1 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -169,6 +169,12 @@ extern void reinit_intr_remapped_IO_APIC(int);
 
 extern void probe_nr_irqs_gsi(void);
 
+extern int setup_ioapic_entry(int apic, int irq,
+			      struct IO_APIC_route_entry *entry,
+			      unsigned int destination, int trigger,
+			      int polarity, int vector);
+extern void ioapic_write_entry(int apic, int pin,
+			       struct IO_APIC_route_entry e);
 #else  /* !CONFIG_X86_IO_APIC */
 #define io_apic_assign_pci_irqs 0
 static const int timer_through_8259 = 0;
diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
index 56e51eb..7248ca1 100644
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -486,7 +486,7 @@ __ioapic_write_entry(int apic, int pin, struct IO_APIC_route_entry e)
 	io_apic_write(apic, 0x10 + 2*pin, eu.w1);
 }
 
-static void ioapic_write_entry(int apic, int pin, struct IO_APIC_route_entry e)
+void ioapic_write_entry(int apic, int pin, struct IO_APIC_route_entry e)
 {
 	unsigned long flags;
 	spin_lock_irqsave(&ioapic_lock, flags);
@@ -1478,10 +1478,10 @@ static void ioapic_register_intr(int irq, struct irq_desc *desc, unsigned long t
 					      handle_edge_irq, "edge");
 }
 
-static int setup_ioapic_entry(int apic_id, int irq,
-			      struct IO_APIC_route_entry *entry,
-			      unsigned int destination, int trigger,
-			      int polarity, int vector)
+int setup_ioapic_entry(int apic_id, int irq,
+		       struct IO_APIC_route_entry *entry,
+		       unsigned int destination, int trigger,
+		       int polarity, int vector)
 {
 	/*
 	 * add it to the IO-APIC irq-routing table:
-- 
1.6.0.6


