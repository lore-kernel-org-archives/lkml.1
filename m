Return-Path: <linux-kernel-owner+w=401wt.eu-S1757455AbZB1CR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757455AbZB1CR2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 21:17:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756835AbZB1COS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 21:14:18 -0500
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:46162
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754876AbZB1CON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 21:14:13 -0500
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 10/10] xen/apic: program the apic triggering and polarity properly
Date: Fri, 27 Feb 2009 18:14:08 -0800
Message-Id: <1235787248-18184-11-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1235787248-18184-1-git-send-email-jeremy@goop.org>
References: <1235787248-18184-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

We were passing the ACPI triggering and polarity levels directly into
the apic - but they have reversed values.  The result was that
all the level-triggered interrupts were edge, and vice-versa.
It's surprising that anything worked at all, but now AHCI works
for me.

Thanks for Gerd Hoffmann for noticing this.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/pci.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/pci.c b/arch/x86/xen/pci.c
index d661c74..fb408ce 100644
--- a/arch/x86/xen/pci.c
+++ b/arch/x86/xen/pci.c
@@ -53,7 +53,9 @@ int xen_register_gsi(u32 gsi, int triggering, int polarity)
 	printk(KERN_DEBUG "xen: --> irq=%d\n", irq);
 
 	if (irq > 0)
-		xen_set_io_apic_routing(irq, triggering, polarity);
+		xen_set_io_apic_routing(irq,
+					triggering == ACPI_EDGE_SENSITIVE ? 0 : 1,
+					polarity == ACPI_ACTIVE_HIGH ? 0 : 1);
 
 	return irq;
 }
-- 
1.6.0.6

