Return-Path: <linux-kernel-owner+w=401wt.eu-S935665AbXHHAxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935665AbXHHAxq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 20:53:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761602AbXHHAxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 20:53:33 -0400
Received: from livid.absolutedigital.net ([66.92.46.173]:48982 "EHLO
	mx2.absolutedigital.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761114AbXHHAxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 20:53:32 -0400
Date: Tue, 7 Aug 2007 20:53:21 -0400 (EDT)
From: Cal Peake <cp@absolutedigital.net>
To: Andi Kleen <andi@firstfloor.org>
cc: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] drop unneeded variable in amd_apic_timer_broken
In-Reply-To: <20070808000631.GB7353@one.firstfloor.org>
Message-ID: <Pine.LNX.4.64.0708072030440.28681@lancer.cnet.absolutedigital.net>
References: <Pine.LNX.4.64.0707301048460.5693@lancer.cnet.absolutedigital.net>
 <Pine.LNX.4.64.0708021335060.28012@lancer.cnet.absolutedigital.net>
 <46B22BDA.8090604@redhat.com> <Pine.LNX.4.64.0708021512530.28012@lancer.cnet.absolutedigital.net>
 <46B23E08.4070106@redhat.com> <Pine.LNX.4.64.0708021627590.28012@lancer.cnet.absolutedigital.net>
 <alpine.LFD.0.999.0708021353320.8184@woody.linux-foundation.org>
 <Pine.LNX.4.64.0708021723160.28012@lancer.cnet.absolutedigital.net>
 <alpine.LFD.0.999.0708031447420.8184@woody.linux-foundation.org>
 <Pine.LNX.4.64.0708071803570.28199@lancer.cnet.absolutedigital.net>
 <20070808000631.GB7353@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Aug 2007, Andi Kleen wrote:

> Not sure why the MSR varies between cores though.

Yeah that boggled me too.

> It's better to just make it a global instead.

Haven't gotten to figuring out how to do *that* yet... but here's a 
cleanup for the detection function:

From: Cal Peake <cp@absolutedigital.net>

We only care about the lower 32-bits when reading the Interrupt Pending 
Message Register so drop the 'hi' variable and use rdmsrl() instead.

Signed-off-by: Cal Peake <cp@absolutedigital.net>

--- ./arch/i386/kernel/cpu/amd.c~orig	2007-08-07 20:22:26.000000000 -0400
+++ ./arch/i386/kernel/cpu/amd.c	2007-08-07 20:23:22.000000000 -0400
@@ -34,7 +34,7 @@ __asm__(".align 4\nvide: ret");
 /* AMD systems with C1E don't have a working lAPIC timer. Check for that. */
 static __cpuinit int amd_apic_timer_broken(void)
 {
-	u32 lo, hi;
+	u32 msr;
 	u32 eax = cpuid_eax(CPUID_PROCESSOR_SIGNATURE);
 	switch (eax & CPUID_XFAM) {
 	case CPUID_XFAM_K8:
@@ -42,8 +42,8 @@ static __cpuinit int amd_apic_timer_brok
 			break;
 	case CPUID_XFAM_10H:
 	case CPUID_XFAM_11H:
-		rdmsr(MSR_K8_ENABLE_C1E, lo, hi);
-		if (lo & ENABLE_C1E_MASK)
+		rdmsrl(MSR_K8_ENABLE_C1E, msr);
+		if (msr & ENABLE_C1E_MASK)
 			return 1;
                 break;
         default:
