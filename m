Return-Path: <linux-kernel-owner+w=401wt.eu-S1758797AbXERCSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758797AbXERCSV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 22:18:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756385AbXERCSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 22:18:14 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:4100 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755456AbXERCSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 22:18:14 -0400
X-AuthUser: davidel@xmailserver.org
Date: Thu, 17 May 2007 19:18:09 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Benjamin LaHaise <bcrl@redhat.com>, Andi Kleen <ak@suse.de>
Subject: [patch] fix oprofile SMP ...
Message-ID: <Pine.LNX.4.64.0705171911290.5172@alien.or.mcafeemobile.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This fixed oprofile being broken on x86-64 SMP. The current reservation 
runs on all CPUs, but the ones following the first, will fail since the 
reservation bitmap has an 1 in the MSR entry.
The reservation code should really run once, and their addresses used on 
other CPUs. There are other solutions to this, but this is the simplest 
and shorter one that came in my mind. Tested in my dual Opteron 252, and 
working fine here.
Andi, if you don't like both Ben and my patch, would you mind fixing 
oprofile yourself in some way?



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>



- Davide



Index: linux-2.6.22-rc1-git6.oprof/arch/i386/oprofile/nmi_int.c
===================================================================
--- linux-2.6.22-rc1-git6.oprof.orig/arch/i386/oprofile/nmi_int.c	2007-05-17 18:32:48.000000000 -0700
+++ linux-2.6.22-rc1-git6.oprof/arch/i386/oprofile/nmi_int.c	2007-05-17 18:51:28.000000000 -0700
@@ -130,8 +130,19 @@
 static void nmi_save_registers(void * dummy)
 {
 	int cpu = smp_processor_id();
-	struct op_msrs * msrs = &cpu_msrs[cpu];
-	model->fill_in_addresses(msrs);
+	struct op_msrs *msrs = &cpu_msrs[cpu];
+
+	/*
+	 * Use the CPU#0 already allocated addresses as reference.
+	 */
+	if (cpu != 0) {
+		const struct op_msrs *rmsrs = &cpu_msrs[0];
+
+		memcpy(msrs->counters, rmsrs->counters,
+		       model->num_counters * sizeof(msrs->counters[0]));
+		memcpy(msrs->controls, rmsrs->controls,
+		       model->num_controls * sizeof(msrs->controls[0]));
+	}
 	nmi_cpu_save_registers(msrs);
 }
 
@@ -195,6 +206,7 @@
 static int nmi_setup(void)
 {
 	int err=0;
+	struct op_msrs *msrs;
 
 	if (!allocate_msrs())
 		return -ENOMEM;
@@ -203,6 +215,14 @@
 		free_msrs();
 		return err;
 	}
+	/*
+	 * MSR reservation should happen only once with the current API,
+	 * otherwise CPU other then the first would fail to allocate.
+	 * We do it here, and then we propagate the CPU#0 addresses to
+	 * other CPUs.
+	 */
+	msrs = &cpu_msrs[0];
+	model->fill_in_addresses(msrs);
 
 	/* We need to serialize save and setup for HT because the subset
 	 * of msrs are distinct for save and setup operations
