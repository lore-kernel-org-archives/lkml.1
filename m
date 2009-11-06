Return-Path: <linux-kernel-owner+w=401wt.eu-S932797AbZKFWXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932797AbZKFWXw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:23:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932778AbZKFWXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:23:50 -0500
Received: from kroah.org ([198.145.64.141]:57230 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932743AbZKFWXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:23:46 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:52 2009
Message-Id: <20091106221552.296543736@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:15:34 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Andre Detsch <adetsch@br.ibm.com>,
       Michael Ellerman <michael@ellerman.id.au>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [96/99] powerpc/pci: Fix regression in powerpc MSI-X
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=powerpc-pci-fix-regression-in-powerpc-msi-x.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Andre Detsch <adetsch@br.ibm.com>

commit 8435b027b87a78145992c37b0b8ed0f1b7761bf0 upstream.

Patch f598282f5145036312d90875d0ed5c14b49fd8a7 exposed a problem in
powerpc MSI-X functionality, making network interfaces such as ixgbe
and cxgb3 stop to work when MSI-X is enabled. RX interrupts were not
being generated.

The problem was caused because MSI irq was not being effectively
unmasked after device initialization.

Signed-off-by: Andre Detsch <adetsch@br.ibm.com>
Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/platforms/pseries/msi.c  |    2 --
 arch/powerpc/platforms/pseries/xics.c |    9 +++++++++
 2 files changed, 9 insertions(+), 2 deletions(-)

--- a/arch/powerpc/platforms/pseries/msi.c
+++ b/arch/powerpc/platforms/pseries/msi.c
@@ -432,8 +432,6 @@ static int rtas_setup_msi_irqs(struct pc
 		/* Read config space back so we can restore after reset */
 		read_msi_msg(virq, &msg);
 		entry->msg = msg;
-
-		unmask_msi_irq(virq);
 	}
 
 	return 0;
--- a/arch/powerpc/platforms/pseries/xics.c
+++ b/arch/powerpc/platforms/pseries/xics.c
@@ -18,6 +18,7 @@
 #include <linux/init.h>
 #include <linux/radix-tree.h>
 #include <linux/cpu.h>
+#include <linux/msi.h>
 #include <linux/of.h>
 
 #include <asm/firmware.h>
@@ -219,6 +220,14 @@ static void xics_unmask_irq(unsigned int
 
 static unsigned int xics_startup(unsigned int virq)
 {
+	/*
+	 * The generic MSI code returns with the interrupt disabled on the
+	 * card, using the MSI mask bits. Firmware doesn't appear to unmask
+	 * at that level, so we do it here by hand.
+	 */
+	if (irq_to_desc(virq)->msi_desc)
+		unmask_msi_irq(virq);
+
 	/* unmask it */
 	xics_unmask_irq(virq);
 	return 0;


