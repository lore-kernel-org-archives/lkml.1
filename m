Return-Path: <linux-kernel-owner+w=401wt.eu-S1763957AbZBNBZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763957AbZBNBZ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 20:25:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763649AbZBNBNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 20:13:06 -0500
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:49173
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762893AbZBNBNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 20:13:04 -0500
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yinghai@kernel.org>, Ian Campbell <Ian.Campbell@citrix.com>,
       Jeremy Fitzhardinge <jeremy@f9-builder (none)>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 6/9] xen/apic: identity map gsi->irqs
Date: Fri, 13 Feb 2009 17:12:04 -0800
Message-Id: <4e896f722e4175f96f3846896c3a7b627e634e7e.1234573847.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <5b0148b366eaa87072ab261f71c4c545be8e607f.1234573847.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1234573847.git.jeremy.fitzhardinge@citrix.com>
 <cover.1234573847.git.jeremy.fitzhardinge@citrix.com>
 <3c7db30686056c9b86cc61ef50dd5572de868512.1234573847.git.jeremy.fitzhardinge@citrix.com>
 <3e46dae897fd5620f50b4cca9272969f5546aa88.1234573847.git.jeremy.fitzhardinge@citrix.com>
 <79724b71f4b8ef1fb65ea246dde2e3e1344b2a43.1234573847.git.jeremy.fitzhardinge@citrix.com>
 <cbcff9ab54a2189156077c81c706fc30ba84344c.1234573847.git.jeremy.fitzhardinge@citrix.com>
 <5b0148b366eaa87072ab261f71c4c545be8e607f.1234573847.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1234573847.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1234573847.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy@f9-builder.(none)>

Reserve the lower irq range for use for hardware interrupts so we
can identity-map them.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/xen/events.c |   23 +++++++++++++++++------
 1 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 81726e8..3477998 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -31,6 +31,7 @@
 #include <asm/ptrace.h>
 #include <asm/irq.h>
 #include <asm/idle.h>
+#include <asm/io_apic.h>
 #include <asm/sync_bitops.h>
 #include <asm/xen/hypercall.h>
 #include <asm/xen/hypervisor.h>
@@ -40,9 +41,6 @@
 #include <xen/interface/xen.h>
 #include <xen/interface/event_channel.h>
 
-/* Leave low irqs free for identity mapping */
-#define LEGACY_IRQS	16
-
 /*
  * This lock protects updates to the following mapping and reference-count
  * arrays. The lock does not need to be acquired to read the mapping tables.
@@ -338,12 +336,24 @@ static void unmask_evtchn(int port)
 	put_cpu();
 }
 
+static int get_nr_hw_irqs(void)
+{
+	int ret = 1;
+
+#ifdef CONFIG_X86_IO_APIC
+	ret = get_nr_irqs_gsi();
+#endif
+
+	return ret;
+}
+
 static int find_unbound_irq(void)
 {
 	int irq;
 	struct irq_desc *desc;
+	int start = get_nr_hw_irqs();
 
-	for (irq = LEGACY_IRQS; irq < nr_irqs; irq++)
+	for (irq = start; irq < nr_irqs; irq++)
 		if (irq_info[irq].type == IRQT_UNBOUND)
 			break;
 
@@ -361,8 +371,8 @@ static int find_unbound_irq(void)
 
 static bool identity_mapped_irq(unsigned irq)
 {
-	/* only identity map legacy irqs */
-	return irq < LEGACY_IRQS;
+	/* identity map all the hardware irqs */
+	return irq < get_nr_hw_irqs();
 }
 
 static void pirq_unmask_notify(int irq)
@@ -531,6 +541,7 @@ int xen_allocate_pirq(unsigned gsi)
 
 	if (identity_mapped_irq(gsi)) {
 		irq = gsi;
+		irq_to_desc_alloc_cpu(irq, 0);
 		dynamic_irq_init(irq);
 	} else
 		irq = find_unbound_irq();
-- 
1.6.0.6

