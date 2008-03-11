Return-Path: <linux-kernel-owner+w=401wt.eu-S1757593AbYCKVZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757593AbYCKVZj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 17:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754261AbYCKVY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 17:24:58 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:17854 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbYCKVY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 17:24:56 -0400
Message-Id: <20080311212740.422339886@ldl.fc.hp.com>
References: <20080311212439.293001409@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Tue, 11 Mar 2008 15:24:40 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Cc: alsa-devel@alsa-project.org
Cc: linux-acpi@vger.kernel.org
Cc: Len Brown <lenb@kernel.org>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Matthew Hall <mhall@mhcomputing.net>
Cc: Willem Riede <wriede@riede.org>
Cc: Robert Hancock <hancockr@shaw.ca>
Cc: Karl Bellve <karl.bellve@umassmed.edu>
Cc: Avuton Olrich <avuton@gmail.com>
Subject: [patch 1/2] PNP: revert Supermicro H8DCE motherboard quirk
Content-Disposition: inline; filename=pnp-remove-supermicro-quirk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are other systems with similar problems
(http://lkml.org/lkml/2008/1/27/168), so we need a more
generic quirk.  Remove the Supermicro-specific one first.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: work7/drivers/pnp/quirks.c
===================================================================
--- work7.orig/drivers/pnp/quirks.c	2008-02-27 10:17:19.000000000 -0700
+++ work7/drivers/pnp/quirks.c	2008-02-27 10:17:40.000000000 -0700
@@ -17,7 +17,6 @@
 #include <linux/slab.h>
 #include <linux/pnp.h>
 #include <linux/io.h>
-#include <linux/dmi.h>
 #include <linux/kallsyms.h>
 #include "base.h"
 
@@ -109,46 +108,6 @@
 		       "pnp: SB audio device quirk - increasing port range\n");
 }
 
-static void quirk_supermicro_h8dce_system(struct pnp_dev *dev)
-{
-	int i;
-	static struct dmi_system_id supermicro_h8dce[] = {
-		{
-			.ident = "Supermicro H8DCE",
-			.matches = {
-				DMI_MATCH(DMI_SYS_VENDOR, "Supermicro"),
-				DMI_MATCH(DMI_PRODUCT_NAME, "H8DCE"),
-			},
-		},
-		{ }
-	};
-
-	if (!dmi_check_system(supermicro_h8dce))
-		return;
-
-	/*
-	 * On the Supermicro H8DCE, there's a system device with resources
-	 * that overlap BAR 6 of the built-in SATA PCI adapter.  If the PNP
-	 * system device claims them, the sata_nv driver won't be able to.
-	 * More details at:
-	 *     https://bugzilla.redhat.com/show_bug.cgi?id=280641
-	 *     https://bugzilla.redhat.com/show_bug.cgi?id=313491
-	 *     http://lkml.org/lkml/2008/1/9/449
-	 *     http://thread.gmane.org/gmane.linux.acpi.devel/27312
-	 */
-	for (i = 0; i < PNP_MAX_MEM; i++) {
-		if (pnp_mem_valid(dev, i) && pnp_mem_len(dev, i) &&
-		    (pnp_mem_start(dev, i) & 0xdfef0000) == 0xdfef0000) {
-			dev_warn(&dev->dev, "disabling 0x%llx-0x%llx to prevent"
-				" conflict with sata_nv PCI device\n",
-				(unsigned long long) pnp_mem_start(dev, i),
-				(unsigned long long) (pnp_mem_start(dev, i) +
-					pnp_mem_len(dev, i) - 1));
-			pnp_mem_flags(dev, i) = 0;
-		}
-	}
-}
-
 /*
  *  PnP Quirks
  *  Cards or devices that need some tweaking due to incomplete resource info
@@ -169,8 +128,6 @@
 	{"CTL0043", quirk_sb16audio_resources},
 	{"CTL0044", quirk_sb16audio_resources},
 	{"CTL0045", quirk_sb16audio_resources},
-	{"PNP0c01", quirk_supermicro_h8dce_system},
-	{"PNP0c02", quirk_supermicro_h8dce_system},
 	{""}
 };
 

-- 
