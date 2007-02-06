Return-Path: <linux-kernel-owner+w=401wt.eu-S965158AbXBFBDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965158AbXBFBDf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 20:03:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965224AbXBFBDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 20:03:35 -0500
Received: from tomts5.bellnexxia.net ([209.226.175.25]:49831 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965158AbXBFBDe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 20:03:34 -0500
Date: Mon, 5 Feb 2007 20:03:31 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       linuxppc-dev@ozlabs.org
Subject: [PATCH] Powerpc move of_irq_to_resource from prom.h to prom_parse.c
Message-ID: <20070206010331.GA22667@Krystal>
References: <20070205142905.GA31392@Krystal> <1170706469.2620.124.camel@localhost.localdomain> <20070205205636.GA14589@Krystal> <17863.52596.791276.129355@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <17863.52596.791276.129355@cargo.ozlabs.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 19:55:47 up 3 days, 15:03,  5 users,  load average: 2.74, 1.71, 1.43
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Powerpc move of_irq_to_resource from prom.h to prom_parse.c

Sorry for the lack of information, it got cut in the previous messages.
Let's start all over again :

In the powerpc architecture, of_irq_to_resource, currently sitting in
prom.h, needs irq_of_parse_and_map and NO_IRQ from asm-powerpc/irq.h.
The solution suggested by Benjamin Herrenschmidt is to move it to
arch/powerpc/kernel/prom_parse.c.

It applies on 2.6.20.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

--- a/arch/powerpc/kernel/prom_parse.c
+++ b/arch/powerpc/kernel/prom_parse.c
@@ -1003,3 +1003,18 @@ int of_irq_map_one(struct device_node *device, int index, struct of_irq *out_irq
 	return res;
 }
 EXPORT_SYMBOL_GPL(of_irq_map_one);
+
+int of_irq_to_resource(struct device_node *dev, int index, struct resource *r)
+{
+	int irq = irq_of_parse_and_map(dev, index);
+
+	/* Only dereference the resource if both the
+	 * resource and the irq are valid. */
+	if (r && irq != NO_IRQ) {
+		r->start = r->end = irq;
+		r->flags = IORESOURCE_IRQ;
+	}
+
+	return irq;
+}
+EXPORT_SYMBOL_GPL(of_irq_to_resource);
--- a/include/asm-powerpc/prom.h
+++ b/include/asm-powerpc/prom.h
@@ -19,6 +19,7 @@
 #include <linux/proc_fs.h>
 #include <linux/platform_device.h>
 #include <asm/atomic.h>
+#include <asm/irq.h>
 
 /* Definitions used by the flattened device tree */
 #define OF_DT_HEADER		0xd00dfeed	/* marker */
@@ -334,20 +335,8 @@ extern int of_irq_map_one(struct device_node *device, int index,
 struct pci_dev;
 extern int of_irq_map_pci(struct pci_dev *pdev, struct of_irq *out_irq);
 
-static inline int of_irq_to_resource(struct device_node *dev, int index, struct resource *r)
-{
-	int irq = irq_of_parse_and_map(dev, index);
-
-	/* Only dereference the resource if both the
-	 * resource and the irq are valid. */
-	if (r && irq != NO_IRQ) {
-		r->start = r->end = irq;
-		r->flags = IORESOURCE_IRQ;
-	}
-
-	return irq;
-}
-
+extern int of_irq_to_resource(struct device_node *dev, int index,
+			struct resource *r);
 
 #endif /* __KERNEL__ */
 #endif /* _POWERPC_PROM_H */
-- 
Mathieu Desnoyers
Computer Engineering Graduate Student, École Polytechnique de Montréal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
