Return-Path: <linux-kernel-owner+w=401wt.eu-S1758522AbXHOKlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758522AbXHOKlh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 06:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753364AbXHOKjB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 06:39:01 -0400
Received: from mx1.suse.de ([195.135.220.2]:45738 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753203AbXHOKi7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 06:38:59 -0400
From: Andi Kleen <ak@suse.de>
References: <200708151238.148026000@suse.de>
In-Reply-To: <200708151238.148026000@suse.de>
To: avi@qumranet.com, patches@x86-64.org, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: [PATCH 2.6.22] [5/5] i386: Handle P6s without performance counters in nmi watchdog
Message-Id: <20070815103858.7FE3914F8E@wotan.suse.de>
Date: Wed, 15 Aug 2007 12:38:58 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I got an oops while booting a 32bit kernel on KVM because it doesn't
implement performance counters used by the NMI watchdog. Handle this
case. 

Cc: avi@qumranet.com

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/kernel/cpu/perfctr-watchdog.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6.22-stable/arch/i386/kernel/cpu/perfctr-watchdog.c
===================================================================
--- linux-2.6.22-stable.orig/arch/i386/kernel/cpu/perfctr-watchdog.c
+++ linux-2.6.22-stable/arch/i386/kernel/cpu/perfctr-watchdog.c
@@ -346,7 +346,9 @@ static int setup_p6_watchdog(unsigned nm
 	perfctr_msr = MSR_P6_PERFCTR0;
 	evntsel_msr = MSR_P6_EVNTSEL0;
 
-	wrmsrl(perfctr_msr, 0UL);
+	/* KVM doesn't implement this MSR */
+	if (wrmsr_safe(perfctr_msr, 0, 0) < 0)
+		return 0;
 
 	evntsel = P6_EVNTSEL_INT
 		| P6_EVNTSEL_OS
