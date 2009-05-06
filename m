Return-Path: <linux-kernel-owner+w=401wt.eu-S1760418AbZEFPKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760418AbZEFPKX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 11:10:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758432AbZEFPKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 11:10:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:57501 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757731AbZEFPKE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 11:10:04 -0400
Message-ID: <4A01A7C8.5090701@kernel.org>
Date: Wed, 06 May 2009 08:07:52 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jesse Barnes <jesse.barnes@intel.com>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, yannick.roehlly@free.fr
Subject: [PATCH 1/2] x86/pci: make pci_mem_start to be aligned only -v5
References: <49EF9C10.6090107@kernel.org> <20090422154900.08f8f366@hobbes> <49EFBB0E.3030401@kernel.org> <20090422180505.2518e837@hobbes> <49EFCE15.3030605@kernel.org> <20090423132202.GB13984@jurassic.park.msu.ru> <49F08580.9050407@kernel.org> <20090423221936.GA24171@jurassic.park.msu.ru> <49F13690.3080902@kernel.org> <20090505115248.63d112f4@hobbes> <20090506123346.GA19541@elte.hu>
In-Reply-To: <20090506123346.GA19541@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


don't need to reserved one round after the gapstart.

because have round up in via reserve stolen ram already.

[Impact: make more big space below 4g for assigning to unassigned pci devices]

Reported-by: Yannick <yannick.roehlly@free.fr>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: Jesse Barnes <jesse.barnes@intel.com>

---
 arch/x86/kernel/e820.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

Index: linux-2.6/arch/x86/kernel/e820.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820.c
+++ linux-2.6/arch/x86/kernel/e820.c
@@ -617,7 +617,7 @@ __init int e820_search_gap(unsigned long
  */
 __init void e820_setup_gap(void)
 {
-	unsigned long gapstart, gapsize, round;
+	unsigned long gapstart, gapsize;
 	int found;
 
 	gapstart = 0x10000000;
@@ -635,14 +635,9 @@ __init void e820_setup_gap(void)
 #endif
 
 	/*
-	 * See how much we want to round up: start off with
-	 * rounding to the next 1MB area.
+	 * e820_reserve_resources_late protect stolen RAM already
 	 */
-	round = 0x100000;
-	while ((gapsize >> 4) > round)
-		round += round;
-	/* Fun with two's complement */
-	pci_mem_start = (gapstart + round) & -round;
+	pci_mem_start = gapstart;
 
 	printk(KERN_INFO
 	       "Allocating PCI resources starting at %lx (gap: %lx:%lx)\n",
