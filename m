Return-Path: <linux-kernel-owner+w=401wt.eu-S967801AbYD1Wvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967801AbYD1Wvt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 18:51:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966250AbYD1Whc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 18:37:32 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:31901 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966191AbYD1WhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 18:37:07 -0400
Message-Id: <20080428223623.894626191@ldl.fc.hp.com>
References: <20080428223347.233593713@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Mon, 28 Apr 2008 16:34:23 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, Rene Herman <rene.herman@gmail.com>
Cc: linux-kernel@vger.kernel.org
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Adam M Belay <abelay@mit.edu>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Matthieu Castet <castet.matthieu@free.fr>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Rene Herman <rene.herman@keyaccess.nl>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 36/55] PNP: convert resource checks to use pnp_get_resource(), not pnp_resource_table
Content-Disposition: inline; filename=pnp-convert-checks-to-pnp_get_resource
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes more direct references to pnp_resource_table.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Acked-By: Rene Herman <rene.herman@gmail.com>

---
 drivers/pnp/resource.c |   96 +++++++++++++++++++++++++++++--------------------
 1 file changed, 58 insertions(+), 38 deletions(-)

Index: work10/drivers/pnp/resource.c
===================================================================
--- work10.orig/drivers/pnp/resource.c	2008-04-28 16:09:34.000000000 -0600
+++ work10/drivers/pnp/resource.c	2008-04-28 16:09:34.000000000 -0600
@@ -270,8 +270,8 @@
 
 	/* check for internal conflicts */
 	for (i = 0; i < PNP_MAX_PORT; i++) {
-		tres = &dev->res.port_resource[i];
-		if (tres != res && tres->flags & IORESOURCE_IO) {
+		tres = pnp_get_resource(dev, IORESOURCE_IO, i);
+		if (tres && tres != res && tres->flags & IORESOURCE_IO) {
 			tport = &tres->start;
 			tend = &tres->end;
 			if (ranged_conflict(port, end, tport, tend))
@@ -284,8 +284,8 @@
 		if (tdev == dev)
 			continue;
 		for (i = 0; i < PNP_MAX_PORT; i++) {
-			tres = &tdev->res.port_resource[i];
-			if (tres->flags & IORESOURCE_IO) {
+			tres = pnp_get_resource(tdev, IORESOURCE_IO, i);
+			if (tres && tres->flags & IORESOURCE_IO) {
 				if (cannot_compare(tres->flags))
 					continue;
 				tport = &tres->start;
@@ -330,8 +330,8 @@
 
 	/* check for internal conflicts */
 	for (i = 0; i < PNP_MAX_MEM; i++) {
-		tres = &dev->res.mem_resource[i];
-		if (tres != res && tres->flags & IORESOURCE_MEM) {
+		tres = pnp_get_resource(dev, IORESOURCE_MEM, i);
+		if (tres && tres != res && tres->flags & IORESOURCE_MEM) {
 			taddr = &tres->start;
 			tend = &tres->end;
 			if (ranged_conflict(addr, end, taddr, tend))
@@ -344,8 +344,8 @@
 		if (tdev == dev)
 			continue;
 		for (i = 0; i < PNP_MAX_MEM; i++) {
-			tres = &tdev->res.mem_resource[i];
-			if (tres->flags & IORESOURCE_MEM) {
+			tres = pnp_get_resource(tdev, IORESOURCE_MEM, i);
+			if (tres && tres->flags & IORESOURCE_MEM) {
 				if (cannot_compare(tres->flags))
 					continue;
 				taddr = &tres->start;
@@ -389,8 +389,8 @@
 
 	/* check for internal conflicts */
 	for (i = 0; i < PNP_MAX_IRQ; i++) {
-		tres = &dev->res.irq_resource[i];
-		if (tres != res && tres->flags & IORESOURCE_IRQ) {
+		tres = pnp_get_resource(dev, IORESOURCE_IRQ, i);
+		if (tres && tres != res && tres->flags & IORESOURCE_IRQ) {
 			if (tres->start == *irq)
 				return 0;
 		}
@@ -423,8 +423,8 @@
 		if (tdev == dev)
 			continue;
 		for (i = 0; i < PNP_MAX_IRQ; i++) {
-			tres = &tdev->res.irq_resource[i];
-			if (tres->flags & IORESOURCE_IRQ) {
+			tres = pnp_get_resource(tdev, IORESOURCE_IRQ, i);
+			if (tres && tres->flags & IORESOURCE_IRQ) {
 				if (cannot_compare(tres->flags))
 					continue;
 				if (tres->start == *irq)
@@ -462,8 +462,8 @@
 
 	/* check for internal conflicts */
 	for (i = 0; i < PNP_MAX_DMA; i++) {
-		tres = &dev->res.dma_resource[i];
-		if (tres != res && tres->flags & IORESOURCE_DMA) {
+		tres = pnp_get_resource(dev, IORESOURCE_DMA, i);
+		if (tres && tres != res && tres->flags & IORESOURCE_DMA) {
 			if (tres->start == *dma)
 				return 0;
 		}
@@ -482,8 +482,8 @@
 		if (tdev == dev)
 			continue;
 		for (i = 0; i < PNP_MAX_DMA; i++) {
-			tres = &tdev->res.dma_resource[i];
-			if (tres->flags & IORESOURCE_DMA) {
+			tres = pnp_get_resource(tdev, IORESOURCE_DMA, i);
+			if (tres && tres->flags & IORESOURCE_DMA) {
 				if (cannot_compare(tres->flags))
 					continue;
 				if (tres->start == *dma)

-- 
