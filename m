Return-Path: <linux-kernel-owner+w=401wt.eu-S1760682AbZF3XTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760682AbZF3XTd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 19:19:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759767AbZF3XRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 19:17:23 -0400
Received: from ozlabs.org ([203.10.76.45]:39650 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759612AbZF3XRT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 19:17:19 -0400
Message-Id: <20090630230141.294083597@samba.org>
References: <20090630230043.464194676@samba.org>
User-Agent: quilt/0.46-1
Date: Wed, 01 Jul 2009 09:00:50 +1000
From: Anton Blanchard <anton@samba.org>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: [patch 7/8] powerpc: Cleanup PCL output by hiding and adding symbols
Content-Disposition: inline; filename=pci_make_symbols_local.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A lot of hits in "setup" doesn't make much sense, so hide this symbol and
allow all the hits to end up in copy_4k_page.

Also add some dummy symbols for the branches at 0xf00, 0xf20 and 0xf40,
otherwise hits end up in trap_0e which is confusing.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: linux-2.6-tip/arch/powerpc/lib/copypage_64.S
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/lib/copypage_64.S	2009-07-01 08:21:12.000000000 +1000
+++ linux-2.6-tip/arch/powerpc/lib/copypage_64.S	2009-07-01 08:21:50.000000000 +1000
@@ -26,11 +26,11 @@
 	srd	r8,r5,r11
 
 	mtctr	r8
-setup:
+.Lsetup:
 	dcbt	r9,r4
 	dcbz	r9,r3
 	add	r9,r9,r12
-	bdnz	setup
+	bdnz	.Lsetup
 END_FTR_SECTION_IFSET(CPU_FTR_CP_USE_DCBTZ)
 	addi	r3,r3,-8
 	srdi    r8,r5,7		/* page is copied in 128 byte strides */
Index: linux-2.6-tip/arch/powerpc/kernel/exceptions-64s.S
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/kernel/exceptions-64s.S	2009-07-01 08:21:12.000000000 +1000
+++ linux-2.6-tip/arch/powerpc/kernel/exceptions-64s.S	2009-07-01 08:21:50.000000000 +1000
@@ -185,12 +185,15 @@
 	 * prolog code of the PerformanceMonitor one. A little
 	 * trickery is thus necessary
 	 */
+performance_monitor_pSeries_1:
 	. = 0xf00
 	b	performance_monitor_pSeries
 
+altivec_unavailable_pSeries_1:
 	. = 0xf20
 	b	altivec_unavailable_pSeries
 
+vsx_unavailable_pSeries_1:
 	. = 0xf40
 	b	vsx_unavailable_pSeries
 

-- 

