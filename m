Return-Path: <linux-kernel-owner+w=401wt.eu-S1757910AbZEKJyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757910AbZEKJyW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 05:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757446AbZEKJxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 05:53:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:53844 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757886AbZEKJxk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 05:53:40 -0400
Date: Mon, 11 May 2009 09:51:57 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, torvalds@linux-foundation.org,
       jesse.barnes@intel.com, yannick.roehlly@free.fr,
       akpm@linux-foundation.org, ink@jurassic.park.msu.ru, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, torvalds@linux-foundation.org,
       jesse.barnes@intel.com, yannick.roehlly@free.fr,
       akpm@linux-foundation.org, ink@jurassic.park.msu.ru, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <4A01A7C8.5090701@kernel.org>
References: <4A01A7C8.5090701@kernel.org>
Subject: [tip:x86/mm] x86/pci: remove rounding quirk from e820_setup_gap()
Message-ID: <tip-5d423ccd7ba4285f1084e91b26805e1d0ae978ed@git.kernel.org>
Git-Commit-ID: 5d423ccd7ba4285f1084e91b26805e1d0ae978ed
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 11 May 2009 09:51:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5d423ccd7ba4285f1084e91b26805e1d0ae978ed
Gitweb:     http://git.kernel.org/tip/5d423ccd7ba4285f1084e91b26805e1d0ae978ed
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Wed, 6 May 2009 08:07:52 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 11 May 2009 09:45:14 +0200

x86/pci: remove rounding quirk from e820_setup_gap()

Now that the e820 code explicitly reserves 'potentially dangerous'
free physical memory address space to protect ACPI stolen RAM,
there's no need for the rounding quirk in the PCI allocator anymore.

Also, this quirk was open-ended iteration that could end up reserving
a lot of free space and potentially breaking drivers - such as the one
reported by Yannick Roehlly <yannick.roehlly@free.fr> where there's
a PCI device with a large memory resource.

So remove it.

[ Impact: make more of the PCI hole available for assigning pci devices ]

Reported-by: Yannick Roehlly <yannick.roehlly@free.fr>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: Jesse Barnes <jesse.barnes@intel.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <4A01A7C8.5090701@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/e820.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index a2335d9..7271fa3 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -617,7 +617,7 @@ __init int e820_search_gap(unsigned long *gapstart, unsigned long *gapsize,
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
