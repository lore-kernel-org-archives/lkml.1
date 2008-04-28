Return-Path: <linux-kernel-owner+w=401wt.eu-S936058AbYD1Wu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936058AbYD1Wu3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 18:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966695AbYD1WhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 18:37:00 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:30561 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965169AbYD1Wgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 18:36:49 -0400
Message-Id: <20080428223621.155256735@ldl.fc.hp.com>
References: <20080428223347.233593713@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Mon, 28 Apr 2008 16:34:10 -0600
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
Subject: [patch 23/55] PNP: remove pnp_resource_table from internal pnp_clean_resource_table interface
Content-Disposition: inline; filename=pnp-remove-pnp_resource_table-from-clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This changes pnp_clean_resource_table() to take a pnp_dev pointer
rather than a pnp_resource_table pointer.  This reduces the visibility
of pnp_resource_table and removes an opportunity for error in the
caller.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Acked-By: Rene Herman <rene.herman@gmail.com>

Index: work10/drivers/pnp/manager.c
===================================================================
--- work10.orig/drivers/pnp/manager.c	2008-04-28 16:09:22.000000000 -0600
+++ work10/drivers/pnp/manager.c	2008-04-28 16:09:23.000000000 -0600
@@ -281,8 +281,9 @@
  * pnp_clean_resources - clears resources that were not manually set
  * @res: the resources to clean
  */
-static void pnp_clean_resource_table(struct pnp_resource_table *res)
+static void pnp_clean_resource_table(struct pnp_dev *dev)
 {
+	struct pnp_resource_table *res = &dev->res;
 	int idx;
 
 	for (idx = 0; idx < PNP_MAX_IRQ; idx++) {
@@ -339,7 +340,7 @@
 
 	dbg_pnp_show_resources(dev, "before pnp_assign_resources");
 	mutex_lock(&pnp_res_mutex);
-	pnp_clean_resource_table(&dev->res);	/* start with a fresh slate */
+	pnp_clean_resource_table(dev);
 	if (dev->independent) {
 		dev_dbg(&dev->dev, "assigning independent options\n");
 		port = dev->independent->port;
@@ -415,7 +416,7 @@
 	return 1;
 
 fail:
-	pnp_clean_resource_table(&dev->res);
+	pnp_clean_resource_table(dev);
 	mutex_unlock(&pnp_res_mutex);
 	dbg_pnp_show_resources(dev, "after pnp_assign_resources (failed)");
 	return 0;
@@ -595,7 +596,7 @@
 
 	/* release the resources so that other devices can use them */
 	mutex_lock(&pnp_res_mutex);
-	pnp_clean_resource_table(&dev->res);
+	pnp_clean_resource_table(dev);
 	mutex_unlock(&pnp_res_mutex);
 
 	return 0;

-- 
