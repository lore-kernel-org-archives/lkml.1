Return-Path: <linux-kernel-owner+w=401wt.eu-S1751854AbYKMTjE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854AbYKMTjE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 14:39:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754418AbYKMTeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 14:34:17 -0500
Received: from gw.goop.org ([64.81.55.164]:34384 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752668AbYKMTeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 14:34:07 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 15 of 38] x86: unstatic ioapic entry funcs
X-Mercurial-Node: 0dc01cfeb71c9a657b569f7f75e7ea8ae2601525
Message-Id: <0dc01cfeb71c9a657b56.1226603413@abulafia.goop.org>
In-Reply-To: <patchbomb.1226603398@abulafia.goop.org>
Date: Thu, 13 Nov 2008 11:10:13 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>
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
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -209,6 +209,12 @@
 
 extern int probe_nr_irqs(void);
 
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
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -337,7 +337,7 @@
 	io_apic_write(apic, 0x10 + 2*pin, eu.w1);
 }
 
-static void ioapic_write_entry(int apic, int pin, struct IO_APIC_route_entry e)
+void ioapic_write_entry(int apic, int pin, struct IO_APIC_route_entry e)
 {
 	unsigned long flags;
 	spin_lock_irqsave(&ioapic_lock, flags);
@@ -1275,10 +1275,10 @@
 					      handle_edge_irq, "edge");
 }
 
-static int setup_ioapic_entry(int apic, int irq,
-			      struct IO_APIC_route_entry *entry,
-			      unsigned int destination, int trigger,
-			      int polarity, int vector)
+int setup_ioapic_entry(int apic, int irq,
+		       struct IO_APIC_route_entry *entry,
+		       unsigned int destination, int trigger,
+		       int polarity, int vector)
 {
 	/*
 	 * add it to the IO-APIC irq-routing table:


