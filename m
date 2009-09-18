Return-Path: <linux-kernel-owner+w=401wt.eu-S1755203AbZIRCJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203AbZIRCJp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 22:09:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752918AbZIRCJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 22:09:44 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:45330 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851AbZIRCJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 22:09:42 -0400
Subject: [Patch] AMD64_EDAC: Fix amd64_map_to_dcs_mask
From: Keith Mannthey <kmannth@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: borislav.petkov@amd.com, dougthompson@xmission.com
Content-Type: text/plain
Date: Thu, 17 Sep 2009 19:09:41 -0700
Message-Id: <1253239781.7263.113.camel@keith-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I tested 2.6.31 and the mainline amd64_edac driver.  Once errors were
getting reported I noticed that a good amount of valid looking system
addressed were not being correctly decoded to the csrow level.  I was
only able to correctly decode errors on channel 0 of a given csrow.
Errors on channel 1 were unable to be mapped. 

After some digging I realized that the there was an issue with handling
of Dram Chip Select Masks.  Specifically that amd64_map_to_dcs_mask was
returning incorrect values on my Rev F based system.  See AMD #32559,
4.5.4, starting on pg 90 for a Rev F explanation of the correct mapping
of DRAM CS Base and DRAM CS Mask regs.  This lead to the code below.  I
can provide further explanation if needed. 


I have tested this code on Rev F based system with ecc debug dimms and
fully expect it to work on earlier and later cpus.  I am now able to
correctly decode and map errors to csrows rows on this system. 


Submitted-by:  Keith Mannthey<kmannth@us.ibm.com>
---

diff -urN linux-2.6.31/drivers/edac/amd64_edac.c linux-2.6.31-fixed/drivers/edac/amd64_edac.c
--- linux-2.6.31/drivers/edac/amd64_edac.c	2009-09-09 15:13:59.000000000 -0700
+++ linux-2.6.31-fixed/drivers/edac/amd64_edac.c	2009-09-17 22:32:09.000000000 -0700
@@ -1,6 +1,8 @@
-#include "amd64_edac.h"
+#include <linux/log2.h>
 #include <asm/k8.h>
 
+#include "amd64_edac.h"
+
 static struct edac_pci_ctl_info *amd64_ctl_pci;
 
 static int report_gart_errors;
@@ -132,7 +134,7 @@
 /* Map from a CSROW entry to the mask entry that operates on it */
 static inline u32 amd64_map_to_dcs_mask(struct amd64_pvt *pvt, int csrow)
 {
-	return csrow >> (pvt->num_dcsm >> 3);
+	return csrow >> (8 >> (ilog2(pvt->num_dcsm)+1));
 }
 
 /* return the 'base' address the i'th CS entry of the 'dct' DRAM controller */
diff -urN linux-2.6.31/drivers/edac/amd64_edac.h linux-2.6.31-fixed/drivers/edac/amd64_edac.h
--- linux-2.6.31/drivers/edac/amd64_edac.h	2009-09-17 22:22:18.000000000 -0700
+++ linux-2.6.31-fixed/drivers/edac/amd64_edac.h	2009-09-17 22:48:50.000000000 -0700
@@ -526,7 +526,7 @@
 	/*
 	 * The following fields are set at (load) run time, after CPU revision
 	 * has been determined, since the dct_base and dct_mask registers vary
-	 * based on revision
+	 * based on revision.  num_dcsm is assumed to be a power of 2. 
 	 */
 	u32 dcsb_base;		/* DCSB base bits */
 	u32 dcsm_mask;		/* DCSM mask bits */


