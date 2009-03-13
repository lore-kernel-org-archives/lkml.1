Return-Path: <linux-kernel-owner+w=401wt.eu-S1760446AbZCMQsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760446AbZCMQsi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 12:48:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759841AbZCMQo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 12:44:26 -0400
Received: from gw.goop.org ([64.81.55.164]:57291 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759452AbZCMQoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 12:44:25 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Gerd Hoffmann <kraxel@xeni.home.kraxel.org>
Subject: [PATCH 15/17] xen: set pirq name to something useful.
Date: Fri, 13 Mar 2009 09:42:36 -0700
Message-Id: <1236962558-13748-16-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1236962558-13748-1-git-send-email-jeremy@goop.org>
References: <1236962558-13748-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gerd Hoffmann <kraxel@xeni.home.kraxel.org>

Signed-off-by: Gerd Hoffmann <kraxel@xeni.home.kraxel.org>
---
 arch/x86/xen/pci.c   |    3 ++-
 drivers/xen/events.c |    4 ++--
 include/xen/events.h |    2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/xen/pci.c b/arch/x86/xen/pci.c
index 502ff5f..fb3ada9 100644
--- a/arch/x86/xen/pci.c
+++ b/arch/x86/xen/pci.c
@@ -48,7 +48,8 @@ int xen_register_gsi(u32 gsi, int triggering, int polarity)
 	printk(KERN_DEBUG "xen: registering gsi %u triggering %d polarity %d\n",
 	       gsi, triggering, polarity);
 
-	irq = xen_allocate_pirq(gsi);
+	irq = xen_allocate_pirq(gsi, (triggering == ACPI_EDGE_SENSITIVE)
+				     ? "ioapic-edge" : "ioapic-level");
 
 	printk(KERN_DEBUG "xen: --> irq=%d\n", irq);
 
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index e8f08c0..52e5208 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -526,7 +526,7 @@ static int find_irq_by_gsi(unsigned gsi)
  * event channel until the irq actually started up.  Return an
  * existing irq if we've already got one for the gsi.
  */
-int xen_allocate_pirq(unsigned gsi)
+int xen_allocate_pirq(unsigned gsi, char *name)
 {
 	int irq;
 	struct physdev_irq irq_op;
@@ -548,7 +548,7 @@ int xen_allocate_pirq(unsigned gsi)
 		irq = find_unbound_irq();
 
 	set_irq_chip_and_handler_name(irq, &xen_pirq_chip,
-				      handle_level_irq, "pirq");
+				      handle_level_irq, name);
 
 	irq_op.irq = irq;
 	if (HYPERVISOR_physdev_op(PHYSDEVOP_alloc_irq_vector, &irq_op)) {
diff --git a/include/xen/events.h b/include/xen/events.h
index 6fe4863..4b19b9c 100644
--- a/include/xen/events.h
+++ b/include/xen/events.h
@@ -61,7 +61,7 @@ unsigned irq_from_evtchn(unsigned int evtchn);
 /* Allocate an irq for a physical interrupt, given a gsi.  "Legacy"
    GSIs are identity mapped; others are dynamically allocated as
    usual. */
-int xen_allocate_pirq(unsigned gsi);
+int xen_allocate_pirq(unsigned gsi, char *name);
 
 /* Return vector allocated to pirq */
 int xen_vector_from_irq(unsigned pirq);
-- 
1.6.0.6

