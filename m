Return-Path: <linux-kernel-owner+w=401wt.eu-S1761919AbYDYTBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761919AbYDYTBy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 15:01:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765136AbYDYSlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 14:41:23 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:40225 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762709AbYDYSkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 14:40:13 -0400
Message-Id: <20080425183931.225811634@ldl.fc.hp.com>
References: <20080425183807.366134771@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Fri, 25 Apr 2008 12:38:42 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Adam M Belay <abelay@mit.edu>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Matthieu Castet <castet.matthieu@free.fr>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Rene Herman <rene.herman@keyaccess.nl>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 35/54] PNP: pass resources, not indexes, to pnp_check_port(), et al
Content-Disposition: inline; filename=pnp-pass-resource-to-check-functions
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The caller already has the struct resource pointer, so no need for
pnp_check_port(), pnp_check_mem(), etc., to look it up again.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: work10/drivers/pnp/base.h
===================================================================
--- work10.orig/drivers/pnp/base.h	2008-04-25 11:15:00.000000000 -0600
+++ work10/drivers/pnp/base.h	2008-04-25 11:15:05.000000000 -0600
@@ -12,10 +12,10 @@
 int __pnp_add_device(struct pnp_dev *dev);
 void __pnp_remove_device(struct pnp_dev *dev);
 
-int pnp_check_port(struct pnp_dev * dev, int idx);
-int pnp_check_mem(struct pnp_dev * dev, int idx);
-int pnp_check_irq(struct pnp_dev * dev, int idx);
-int pnp_check_dma(struct pnp_dev * dev, int idx);
+int pnp_check_port(struct pnp_dev *dev, struct resource *res);
+int pnp_check_mem(struct pnp_dev *dev, struct resource *res);
+int pnp_check_irq(struct pnp_dev *dev, struct resource *res);
+int pnp_check_dma(struct pnp_dev *dev, struct resource *res);
 
 void dbg_pnp_show_resources(struct pnp_dev *dev, char *desc);
 
Index: work10/drivers/pnp/manager.c
===================================================================
--- work10.orig/drivers/pnp/manager.c	2008-04-25 11:15:03.000000000 -0600
+++ work10/drivers/pnp/manager.c	2008-04-25 11:15:05.000000000 -0600
@@ -51,7 +51,7 @@
 	res->end = res->start + rule->size - 1;
 
 	/* run through until pnp_check_port is happy */
-	while (!pnp_check_port(dev, idx)) {
+	while (!pnp_check_port(dev, res)) {
 		res->start += rule->align;
 		res->end = res->start + rule->size - 1;
 		if (res->start > rule->max || !rule->align) {
@@ -108,7 +108,7 @@
 	res->end = res->start + rule->size - 1;
 
 	/* run through until pnp_check_mem is happy */
-	while (!pnp_check_mem(dev, idx)) {
+	while (!pnp_check_mem(dev, res)) {
 		res->start += rule->align;
 		res->end = res->start + rule->size - 1;
 		if (res->start > rule->max || !rule->align) {
@@ -167,7 +167,7 @@
 	for (i = 0; i < 16; i++) {
 		if (test_bit(xtab[i], rule->map)) {
 			res->start = res->end = xtab[i];
-			if (pnp_check_irq(dev, idx)) {
+			if (pnp_check_irq(dev, res)) {
 				dev_dbg(&dev->dev, "  assign irq %d %d\n", idx,
 					(int) res->start);
 				return 1;
@@ -209,7 +209,7 @@
 	for (i = 0; i < 8; i++) {
 		if (rule->map & (1 << xtab[i])) {
 			res->start = res->end = xtab[i];
-			if (pnp_check_dma(dev, idx)) {
+			if (pnp_check_dma(dev, res)) {
 				dev_dbg(&dev->dev, "  assign dma %d %d\n", idx,
 					(int) res->start);
 				return;
Index: work10/drivers/pnp/resource.c
===================================================================
--- work10.orig/drivers/pnp/resource.c	2008-04-25 11:15:05.000000000 -0600
+++ work10/drivers/pnp/resource.c	2008-04-25 11:15:05.000000000 -0600
@@ -239,14 +239,13 @@
 #define cannot_compare(flags) \
 ((flags) & (IORESOURCE_UNSET | IORESOURCE_DISABLED))
 
-int pnp_check_port(struct pnp_dev *dev, int idx)
+int pnp_check_port(struct pnp_dev *dev, struct resource *res)
 {
 	int i;
 	struct pnp_dev *tdev;
-	struct resource *res, *tres;
+	struct resource *tres;
 	resource_size_t *port, *end, *tport, *tend;
 
-	res = &dev->res.port_resource[idx];
 	port = &res->start;
 	end = &res->end;
 
@@ -300,14 +299,13 @@
 	return 1;
 }
 
-int pnp_check_mem(struct pnp_dev *dev, int idx)
+int pnp_check_mem(struct pnp_dev *dev, struct resource *res)
 {
 	int i;
 	struct pnp_dev *tdev;
-	struct resource *res, *tres;
+	struct resource *tres;
 	resource_size_t *addr, *end, *taddr, *tend;
 
-	res = &dev->res.mem_resource[idx];
 	addr = &res->start;
 	end = &res->end;
 
@@ -366,14 +364,13 @@
 	return IRQ_HANDLED;
 }
 
-int pnp_check_irq(struct pnp_dev *dev, int idx)
+int pnp_check_irq(struct pnp_dev *dev, struct resource *res)
 {
 	int i;
 	struct pnp_dev *tdev;
-	struct resource *res, *tres;
+	struct resource *tres;
 	resource_size_t *irq;
 
-	res = &dev->res.irq_resource[idx];
 	irq = &res->start;
 
 	/* if the resource doesn't exist, don't complain about it */
@@ -439,15 +436,14 @@
 	return 1;
 }
 
-int pnp_check_dma(struct pnp_dev *dev, int idx)
+int pnp_check_dma(struct pnp_dev *dev, struct resource *res)
 {
 #ifndef CONFIG_IA64
 	int i;
 	struct pnp_dev *tdev;
-	struct resource *res, *tres;
+	struct resource *tres;
 	resource_size_t *dma;
 
-	res = &dev->res.dma_resource[idx];
 	dma = &res->start;
 
 	/* if the resource doesn't exist, don't complain about it */

-- 
