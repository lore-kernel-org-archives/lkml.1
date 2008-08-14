Return-Path: <linux-kernel-owner+w=401wt.eu-S1758061AbYHNUcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758061AbYHNUcd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 16:32:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbYHNUcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 16:32:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53966 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213AbYHNUcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 16:32:24 -0400
Date: Thu, 14 Aug 2008 16:32:15 -0400
From: Aristeu Rozanski <arozansk@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, jvillalovos@redhat.com
Subject: [PATCH] perfctr: don't use CCCR_OVF_PMI1 on Pentium 4Ds
Message-ID: <20080814203133.GS7154@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, setup_p4_watchdog() use CCCR_OVF_PMI1 to enable the counter
overflow interrupts to the second logical core. But this bit doesn't work
on Pentium 4 Ds (model 4, stepping 4) and this patch avoids its use on
these processors. Tested on 4 different machines that have this
specific model with success.

Signed-off-by: Aristeu Rozanski <aris@redhat.com>

---
 arch/x86/kernel/cpu/perfctr-watchdog.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- linus-2.6.orig/arch/x86/kernel/cpu/perfctr-watchdog.c	2008-08-12 11:13:35.000000000 -0400
+++ linus-2.6/arch/x86/kernel/cpu/perfctr-watchdog.c	2008-08-12 11:21:09.000000000 -0400
@@ -478,7 +478,13 @@ static int setup_p4_watchdog(unsigned nm
 		perfctr_msr = MSR_P4_IQ_PERFCTR1;
 		evntsel_msr = MSR_P4_CRU_ESCR0;
 		cccr_msr = MSR_P4_IQ_CCCR1;
-		cccr_val = P4_CCCR_OVF_PMI1 | P4_CCCR_ESCR_SELECT(4);
+
+		/* Pentium 4 D processors don't support P4_CCCR_OVF_PMI1 */
+		if (boot_cpu_data.x86_model == 4 && boot_cpu_data.x86_mask == 4)
+			cccr_val = P4_CCCR_OVF_PMI0;
+		else
+			cccr_val = P4_CCCR_OVF_PMI1;
+		cccr_val |= P4_CCCR_ESCR_SELECT(4);
 	}
 
 	evntsel = P4_ESCR_EVENT_SELECT(0x3F)
