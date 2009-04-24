Return-Path: <linux-kernel-owner+w=401wt.eu-S1755552AbZDXDxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552AbZDXDxT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 23:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751665AbZDXDxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 23:53:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:35543 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751271AbZDXDxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 23:53:06 -0400
Message-ID: <49F13717.4010106@kernel.org>
Date: Thu, 23 Apr 2009 20:50:47 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, yannick.roehlly@free.fr
Subject: [PATCH 4/4] x86/pci: make pci_mem_start to be aligned only -v5
References: <20090420223305.GA15340@jurassic.park.msu.ru> <49ED0EBC.4070901@kernel.org> <20090421105629.GB17904@jurassic.park.msu.ru> <49EF9C10.6090107@kernel.org> <20090422154900.08f8f366@hobbes> <49EFBB0E.3030401@kernel.org> <20090422180505.2518e837@hobbes> <49EFCE15.3030605@kernel.org> <20090423132202.GB13984@jurassic.park.msu.ru> <49F08580.9050407@kernel.org> <20090423221936.GA24171@jurassic.park.msu.ru> <49F13690.3080902@kernel.org>
In-Reply-To: <49F13690.3080902@kernel.org>
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
