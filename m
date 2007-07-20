Return-Path: <linux-kernel-owner+w=401wt.eu-S937335AbXGTPgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937335AbXGTPgA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 11:36:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936008AbXGTPdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 11:33:05 -0400
Received: from mx1.suse.de ([195.135.220.2]:50701 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935955AbXGTPdC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 11:33:02 -0400
From: Andi Kleen <ak@suse.de>
References: <20070720532.949522000@suse.de>
In-Reply-To: <20070720532.949522000@suse.de>
To: avi@qumranet.com, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [10/11] i386: Handle P6s without performance counters in nmi watchdog
Message-Id: <20070720153255.CC7BC14E7B@wotan.suse.de>
Date: Fri, 20 Jul 2007 17:32:55 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I got an oops while booting a 32bit kernel on KVM because it doesn't
implement performance counters used by the NMI watchdog. Handle this
case. 

Cc: avi@qumranet.com

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux/arch/i386/kernel/cpu/perfctr-watchdog.c
===================================================================
--- linux.orig/arch/i386/kernel/cpu/perfctr-watchdog.c
+++ linux/arch/i386/kernel/cpu/perfctr-watchdog.c
@@ -346,7 +346,9 @@ static int setup_p6_watchdog(unsigned nm
 	perfctr_msr = MSR_P6_PERFCTR0;
 	evntsel_msr = MSR_P6_EVNTSEL0;
 
-	wrmsrl(perfctr_msr, 0UL);
+	/* KVM doesn't implement this MSR */
+	if (wrmsr_safe(perfctr_msr, 0, 0) < 0) 
+		return 0;
 
 	evntsel = P6_EVNTSEL_INT
 		| P6_EVNTSEL_OS
