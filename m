Return-Path: <linux-kernel-owner+w=401wt.eu-S1756859AbYAOS0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859AbYAOS0c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 13:26:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753612AbYAOS0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 13:26:11 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:56908 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599AbYAOS0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 13:26:09 -0500
Date: Tue, 15 Jan 2008 10:31:45 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86_64: checking aperture report for node instead
 =?iso-8859-1?q?of=09cpu?= v2
In-reply-to: <20080115132253.GC7025@elte.hu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Lameter <clameter@sgi.com>, ebiederm@xmission.com,
       LKML <linux-kernel@vger.kernel.org>
Message-id: <200801151031.46279.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200801101914.47967.yinghai.lu@sun.com>
 <200801141739.35448.yinghai.lu@sun.com> <20080115132253.GC7025@elte.hu>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86_64: checking aperture report for node instead of cpu v2

currently when gart iommu is enabled by BIOS or previous we got

"
Checking aperture...
CPU 0: aperture @4000000 size 64MB
CPU 1: aperture @4000000 size 64MB
"
we should use use Node instead.

we will get
"
Checking aperture...
Node 0: aperture @4000000 size 64MB
Node 1: aperture @4000000 size 64MB
"

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

Index: linux-2.6/arch/x86/kernel/aperture_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/aperture_64.c
+++ linux-2.6/arch/x86/kernel/aperture_64.c
@@ -312,6 +312,7 @@ void __init gart_iommu_hole_init(void)
 	u32 aper_size, aper_alloc = 0, aper_order = 0, last_aper_order = 0;
 	u64 aper_base, last_aper_base = 0;
 	int fix, num, valid_agp = 0;
+	int node;
 
 	if (gart_iommu_aperture_disabled || !fix_aperture ||
 	    !early_pci_allowed())
@@ -320,6 +321,7 @@ void __init gart_iommu_hole_init(void)
 	printk(KERN_INFO  "Checking aperture...\n");
 
 	fix = 0;
+	node = 0;
 	for (num = 24; num < 32; num++) {
 		if (!early_is_k8_nb(read_pci_config(0, num, 3, 0x00)))
 			continue;
@@ -332,8 +334,9 @@ void __init gart_iommu_hole_init(void)
 		aper_base = read_pci_config(0, num, 3, 0x94) & 0x7fff;
 		aper_base <<= 25;
 
-		printk(KERN_INFO "CPU %d: aperture @ %Lx size %u MB\n",
-				num-24, aper_base, aper_size>>20);
+		printk(KERN_INFO "Node %d: aperture @ %Lx size %u MB\n",
+				node, aper_base, aper_size >> 20);
+		node++;
 
 		if (!aperture_valid(aper_base, aper_size)) {
 			fix = 1;
