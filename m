Return-Path: <linux-kernel-owner+w=401wt.eu-S1756818AbXFKXJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818AbXFKXJB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 19:09:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754184AbXFKXII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 19:08:08 -0400
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:13352 "EHLO
	master.douglaskthompson.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752931AbXFKXIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 19:08:04 -0400
Date: Mon, 11 Jun 2007 17:11:22 -0600
From: dougthompson@xmission.com
To: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: [PATCH 3/5] driver edac mod edac_align_ptr function
Message-ID: <466dd69a.K9Sc1d6jWnbc1hsb%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.1 6/15/06
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From:   Douglas Thompson <dougthompson@xmission.com>

refactor the edac_align_ptr() function to reduce the noise of
casting the aligned pointer to the various types of data objects
and modified its callers to its new signature

Signed-off-by:  Douglas Thompson <dougthompson@xmission.com>
---
 edac_core.h         |   11 -----
 edac_device.c       |  105 ++++++++++++++++++++++++++--------------------------
 edac_device_sysfs.c |   22 +++-------
 3 files changed, 62 insertions(+), 76 deletions(-)

Index: linux-2.6.22-rc4-mm2/drivers/edac/edac_core.h
===================================================================
--- linux-2.6.22-rc4-mm2.orig/drivers/edac/edac_core.h
+++ linux-2.6.22-rc4-mm2/drivers/edac/edac_core.h
@@ -211,8 +211,6 @@ enum scrub_type {
 #define OP_RUNNING_POLL_INTR	0x203
 #define OP_OFFLINE		0x300
 
-extern char *edac_align_ptr(void *ptr, unsigned size);
-
 /*
  * There are several things to be aware of that aren't at all obvious:
  *
Index: linux-2.6.22-rc4-mm2/drivers/edac/edac_device.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/drivers/edac/edac_device.c
+++ linux-2.6.22-rc4-mm2/drivers/edac/edac_device.c
@@ -89,17 +89,14 @@ struct edac_device_ctl_info *edac_device
 	dev_ctl = (struct edac_device_ctl_info *)NULL;
 
 	/* Calc the 'end' offset past the ctl_info structure */
-	dev_inst = (struct edac_device_instance *)
-		edac_align_ptr(&dev_ctl[1], sizeof(*dev_inst));
+	dev_inst = edac_align_ptr(&dev_ctl[1], sizeof(*dev_inst));
 
 	/* Calc the 'end' offset past the instance array */
-	dev_blk = (struct edac_device_block *)
-		edac_align_ptr(&dev_inst[nr_instances], sizeof(*dev_blk));
+	dev_blk = edac_align_ptr(&dev_inst[nr_instances], sizeof(*dev_blk));
 
 	/* Calc the 'end' offset past the dev_blk array */
 	count = nr_instances * nr_blocks;
-	dev_attrib = (struct edac_attrib *)
-		edac_align_ptr(&dev_blk[count], sizeof(*dev_attrib));
+	dev_attrib = edac_align_ptr(&dev_blk[count], sizeof(*dev_attrib));
 
 	/* Check for case of NO attributes specified */
 	if (nr_attribs > 0)
Index: linux-2.6.22-rc4-mm2/drivers/edac/edac_mc.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/drivers/edac/edac_mc.c
+++ linux-2.6.22-rc4-mm2/drivers/edac/edac_mc.c
@@ -85,7 +85,7 @@ static void edac_mc_dump_mci(struct mem_
  * If 'size' is a constant, the compiler will optimize this whole function
  * down to either a no-op or the addition of a constant to the value of 'ptr'.
  */
-char *edac_align_ptr(void *ptr, unsigned size)
+void *edac_align_ptr(void *ptr, unsigned size)
 {
 	unsigned align, r;
 
@@ -109,7 +109,7 @@ char *edac_align_ptr(void *ptr, unsigned
 	if (r == 0)
 		return (char *)ptr;
 
-	return (char *)(((unsigned long)ptr) + align - r);
+	return (void *)(((unsigned long)ptr) + align - r);
 }
 
 /**
@@ -144,9 +144,8 @@ struct mem_ctl_info *edac_mc_alloc(unsig
 	 * hardcode everything into a single struct.
 	 */
 	mci = (struct mem_ctl_info *)0;
-	csi = (struct csrow_info *)edac_align_ptr(&mci[1], sizeof(*csi));
-	chi = (struct channel_info *)
-		edac_align_ptr(&csi[nr_csrows], sizeof(*chi));
+	csi = edac_align_ptr(&mci[1], sizeof(*csi));
+	chi = edac_align_ptr(&csi[nr_csrows], sizeof(*chi));
 	pvt = edac_align_ptr(&chi[nr_chans * nr_csrows], sz_pvt);
 	size = ((unsigned long)pvt) + sz_pvt;
 
Index: linux-2.6.22-rc4-mm2/drivers/edac/edac_module.h
===================================================================
--- linux-2.6.22-rc4-mm2.orig/drivers/edac/edac_module.h
+++ linux-2.6.22-rc4-mm2/drivers/edac/edac_module.h
@@ -44,6 +44,7 @@ extern void edac_device_workq_setup(stru
 extern void edac_device_workq_teardown(struct edac_device_ctl_info *edac_dev);
 extern void edac_device_reset_delay_period(struct edac_device_ctl_info
 					   *edac_dev, unsigned long value);
+extern void *edac_align_ptr(void *ptr, unsigned size);
 
 /*
  * EDAC PCI functions
