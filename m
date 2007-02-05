Return-Path: <linux-kernel-owner+w=401wt.eu-S933426AbXBEU4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933426AbXBEU4m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 15:56:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933428AbXBEU4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 15:56:42 -0500
Received: from tomts43.bellnexxia.net ([209.226.175.110]:55405 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933426AbXBEU4l convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 15:56:41 -0500
Date: Mon, 5 Feb 2007 15:56:36 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       paulus@samba.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] Missing include in include/asm-powerpc/prom.h
Message-ID: <20070205205636.GA14589@Krystal>
References: <20070205142905.GA31392@Krystal> <1170706469.2620.124.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1170706469.2620.124.camel@localhost.localdomain>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 15:31:28 up 3 days, 10:39,  3 users,  load average: 3.66, 1.96, 1.36
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Benjamin Herrenschmidt (benh@kernel.crashing.org) wrote:
> On Mon, 2007-02-05 at 09:29 -0500, Mathieu Desnoyers wrote:
> > Missing include in include/asm-powerpc/prom.h
> > 
> > include/asm-powerpc/prom.h needs to include asm/irq.h because it uses
> > irq_of_parse_and_map and NO_IRQ. It applies on 2.6.20.
> 
> I'd rather not do that.... better to move of_irq_to_resource() to
> prom_parse.c 
> 

Thanks, this patch should apply on top of the previous patch in this thread.

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
@@ -335,20 +335,8 @@ extern int of_irq_map_one(struct device_node *device, int index,
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
