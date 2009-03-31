Return-Path: <linux-kernel-owner+w=401wt.eu-S1757391AbZCaNTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391AbZCaNTs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 09:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754699AbZCaNTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 09:19:39 -0400
Received: from mga11.intel.com ([192.55.52.93]:29445 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754573AbZCaNTi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 09:19:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,453,1233561600"; 
   d="scan'208";a="677478351"
Date: Tue, 31 Mar 2009 15:19:25 +0200
From: Markus Metzger <markus.t.metzger@intel.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com, roland@redhat.com,
       eranian@googlemail.com, oleg@redhat.com, juan.villacis@intel.com,
       ak@linux.jf.intel.com
Subject: [patch 8/21] x86, debugctlmsr: add _on_cpu variants to debugctlmsr functions
Message-ID: <20090331151925.A12985@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add functions to get and set the debugctlmsr on different cpus.


Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: git-tip/arch/x86/include/asm/processor.h
===================================================================
--- git-tip.orig/arch/x86/include/asm/processor.h	2009-03-28 13:04:30.000000000 +0100
+++ git-tip/arch/x86/include/asm/processor.h	2009-03-29 10:58:10.000000000 +0200
@@ -785,6 +785,21 @@
     return debugctlmsr;
 }
 
+static inline unsigned long get_debugctlmsr_on_cpu(int cpu)
+{
+	u64 debugctlmsr = 0;
+	u32 val1, val2;
+
+#ifndef CONFIG_X86_DEBUGCTLMSR
+	if (boot_cpu_data.x86 < 6)
+		return 0;
+#endif
+	rdmsr_on_cpu(cpu, MSR_IA32_DEBUGCTLMSR, &val1, &val2);
+	debugctlmsr = val1 | ((u64)val2 << 32);
+
+	return debugctlmsr;
+}
+
 static inline void update_debugctlmsr(unsigned long debugctlmsr)
 {
 #ifndef CONFIG_X86_DEBUGCTLMSR
@@ -794,6 +809,18 @@
 	wrmsrl(MSR_IA32_DEBUGCTLMSR, debugctlmsr);
 }
 
+static inline void update_debugctlmsr_on_cpu(int cpu,
+					     unsigned long debugctlmsr)
+{
+#ifndef CONFIG_X86_DEBUGCTLMSR
+	if (boot_cpu_data.x86 < 6)
+		return;
+#endif
+	wrmsr_on_cpu(cpu, MSR_IA32_DEBUGCTLMSR,
+		     (u32)((u64)debugctlmsr),
+		     (u32)((u64)debugctlmsr >> 32));
+}
+
 /*
  * from system description table in BIOS. Mostly for MCA use, but
  * others may find it useful:
---------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen Germany
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 Ust.-IdNr.
VAT Registration No.: DE129385895
Citibank Frankfurt (BLZ 502 109 00) 600119052

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

