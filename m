Return-Path: <linux-kernel-owner+w=401wt.eu-S1754039AbZESIJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039AbZESIJ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 04:09:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752417AbZESIJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 04:09:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:47639 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752393AbZESIJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 04:09:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,214,1241420400"; 
   d="scan'208";a="516830628"
Date: Tue, 19 May 2009 16:09:42 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Cc: lenb@kernel.org, thisistempbox@yahoo.com, mingo@redhat.com
Subject: [PATCH 1/2]cpuidle: makes AMD C1E works in acpi_idle
Message-ID: <20090519080942.GA12117@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When AMD C1E is enabled, local APIC timer will stop even in C1. This patch uses
broadcast ipi to replace local APIC timer in C1.

http://bugzilla.kernel.org/show_bug.cgi?id=13233

[ impact: avoid boot hang in AMD CPU with C1E enabled ]

Tested-by: Dmitry Lyzhyn <thisistempbox@yahoo.com>
Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 drivers/acpi/processor_idle.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux/drivers/acpi/processor_idle.c
===================================================================
--- linux.orig/drivers/acpi/processor_idle.c	2009-05-19 09:45:23.000000000 +0800
+++ linux/drivers/acpi/processor_idle.c	2009-05-19 09:56:59.000000000 +0800
@@ -148,6 +148,9 @@ static void acpi_timer_check_state(int s
 	if (cpu_has(&cpu_data(pr->id), X86_FEATURE_ARAT))
 		return;
 
+	if (boot_cpu_has(X86_FEATURE_AMDC1E))
+		type = ACPI_STATE_C1;
+
 	/*
 	 * Check, if one of the previous states already marked the lapic
 	 * unstable
@@ -611,6 +614,7 @@ static int acpi_processor_power_verify(s
 		switch (cx->type) {
 		case ACPI_STATE_C1:
 			cx->valid = 1;
+			acpi_timer_check_state(i, pr, cx);
 			break;
 
 		case ACPI_STATE_C2:
@@ -835,6 +839,7 @@ static int acpi_idle_enter_c1(struct cpu
 		return 0;
 	}
 
+	acpi_state_timer_broadcast(pr, cx, 1);
 	kt1 = ktime_get_real();
 	acpi_idle_do_entry(cx);
 	kt2 = ktime_get_real();
@@ -842,6 +847,7 @@ static int acpi_idle_enter_c1(struct cpu
 
 	local_irq_enable();
 	cx->usage++;
+	acpi_state_timer_broadcast(pr, cx, 0);
 
 	return idle_time;
 }
