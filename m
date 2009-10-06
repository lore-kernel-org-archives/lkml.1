Return-Path: <linux-kernel-owner+w=401wt.eu-S1756117AbZJFDSF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117AbZJFDSF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 23:18:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756049AbZJFDSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 23:18:05 -0400
Received: from vms173015pub.verizon.net ([206.46.173.15]:37859 "EHLO
	vms173015pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756005AbZJFDSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 23:18:04 -0400
Date: Mon, 05 Oct 2009 23:17:04 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Ricardo Jorge da Fonseca Marques Ferreira <storm@sys49152.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Yannick Roehlly <yannick.roehlly@free.fr>,
       Yinghai Lu <yinghai@kernel.org>, Jesse Barnes <jesse.barnes@intel.com>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Ingo Molnar <mingo@elte.hu>,
       x86@kernel.org, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Regression in ACPI in 2.6.31-rc5
In-reply-to: <200908160400.03391.storm@sys49152.net>
Message-id: <alpine.LFD.2.00.0910052312140.309@localhost.localdomain>
References: <200908072333.24631.storm@sys49152.net>
 <alpine.LFD.2.00.0908122350560.22946@localhost.localdomain>
 <200908160400.03391.storm@sys49152.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>
Subject: [PATCH] Revert "x86/pci: remove rounding quirk from e820_setup_gap()"

This reverts commit 5d423ccd7ba4285f1084e91b26805e1d0ae978ed.

because it caused multiple regressions in 2.6.31-rc1

http://bugzilla.kernel.org/show_bug.cgi?id=13940

Signed-off-by: Len Brown <len.brown@intel.com>
---

Yinghai,
is there a reason we should not revert the offending patch, per below?

thanks,
-Len

 arch/x86/kernel/e820.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 85419bb..b322e30 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -617,7 +617,7 @@ __init int e820_search_gap(unsigned long *gapstart, unsigned long *gapsize,
  */
 __init void e820_setup_gap(void)
 {
-	unsigned long gapstart, gapsize;
+	unsigned long gapstart, gapsize, round;
 	int found;
 
 	gapstart = 0x10000000;
@@ -634,9 +634,14 @@ __init void e820_setup_gap(void)
 #endif
 
 	/*
-	 * e820_reserve_resources_late protect stolen RAM already
+	 * See how much we want to round up: start off with
+	 * rounding to the next 1MB area.
 	 */
-	pci_mem_start = gapstart;
+	round = 0x100000;
+	while ((gapsize >> 4) > round)
+		round += round;
+	/* Fun with two's complement */
+	pci_mem_start = (gapstart + round) & -round;
 
 	printk(KERN_INFO
 	       "Allocating PCI resources starting at %lx (gap: %lx:%lx)\n",
-- 
1.6.5.rc2.17.gdbc1b

