Return-Path: <linux-kernel-owner+w=401wt.eu-S1758446AbZD0Pow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758446AbZD0Pow (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 11:44:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754423AbZD0PoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 11:44:18 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54081 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757930AbZD0PoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 11:44:17 -0400
From: Andi Kleen <andi@firstfloor.org>
Message-Id: <20090427544.130860995@firstfloor.org>
To: oprofile-list@lists.sf.net, robert.richter@amd.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [1/3] oprofile: re-add force_arch_perfmon option
Date: Mon, 27 Apr 2009 17:44:11 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This re-adds the force_arch_perfmon option that was in the original
arch perfmon patchkit. Originally this was rejected in favour 
of a generalized perfmon=name option, but it turned out implementing
the later in a reliable way is hard (and it would have been easy
to crash the kernel if a user gets it wrong) 

But now Atom and Core i7 support being readded a user would
need to update their oprofile userland to beyond 0.9.4 to use oprofile again
on Atom or Core i7.

To avoid this problem readd the force_arch_perfmon option.
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 Documentation/kernel-parameters.txt |    6 ++++++
 arch/x86/oprofile/nmi_int.c         |    6 ++++++
 2 files changed, 12 insertions(+)

Index: linux-2.6.30-rc3-ak/Documentation/kernel-parameters.txt
===================================================================
--- linux-2.6.30-rc3-ak.orig/Documentation/kernel-parameters.txt	2009-04-25 19:11:59.000000000 +0200
+++ linux-2.6.30-rc3-ak/Documentation/kernel-parameters.txt	2009-04-27 13:20:29.000000000 +0200
@@ -1648,6 +1648,12 @@
 	oprofile.timer=	[HW]
 			Use timer interrupt instead of performance counters
 
+	oprofile.force_arch_perfmon=1	[X86]
+			Force use of architectural perfmon instead of
+			the CPU specific event set.
+			This might be useful if you have older oprofile
+			userland or if you want common events over Intel CPUs.
+
 	osst=		[HW,SCSI] SCSI Tape Driver
 			Format: <buffer_size>,<write_threshold>
 			See also Documentation/scsi/st.txt.
Index: linux-2.6.30-rc3-ak/arch/x86/oprofile/nmi_int.c
===================================================================
--- linux-2.6.30-rc3-ak.orig/arch/x86/oprofile/nmi_int.c	2009-02-15 12:09:09.000000000 +0100
+++ linux-2.6.30-rc3-ak/arch/x86/oprofile/nmi_int.c	2009-04-27 13:20:29.000000000 +0200
@@ -389,10 +389,16 @@
 	return 0;
 }
 
+int force_arch_perfmon;
+module_param(force_arch_perfmon, int, 0);
+
 static int __init ppro_init(char **cpu_type)
 {
 	__u8 cpu_model = boot_cpu_data.x86_model;
 
+	if (force_arch_perfmon && cpu_has_arch_perfmon)
+		return 0;
+
 	switch (cpu_model) {
 	case 0 ... 2:
 		*cpu_type = "i386/ppro";
