Return-Path: <linux-kernel-owner+w=401wt.eu-S1752197AbZDCOs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197AbZDCOs6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 10:48:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932636AbZDCOqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 10:46:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:17348 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932610AbZDCOqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 10:46:00 -0400
Content-Type: multipart/mixed; boundary="===============0225869921=="
MIME-Version: 1.0
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,319,1235980800"; 
   d="scan'208";a="503328322"
Message-Id: <20090403144554.738772000@intel.com>
References: <20090403144332.799740000@intel.com>
User-Agent: quilt/0.46-1
Date: Fri, 03 Apr 2009 16:43:39 +0200
From: markus.t.metzger@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: markus.t.metzger@gmail.com, roland@redhat.com, eranian@googlemail.com,
       oleg@redhat.com, juan.villacis@intel.com, ak@linux.jf.intel.com,
       linux-kernel@vger.kernel.org,
       Markus Metzger <markus.t.metzger@intel.com>
Subject: [patch 07/20] x86, debugctlmsr: add _on_cpu variants to debugctlmsr functions
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--===============0225869921==
MIME-Version: 1.0
Content-Disposition: inline; filename=tip.master.update_debugctlmsr_on_cpu.patch

Add functions to get and set the debugctlmsr on different cpus.


Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---
 arch/x86/include/asm/processor.h |   27 	27 +	0 -	0 !
 1 file changed, 27 insertions(+)

Index: b/arch/x86/include/asm/processor.h
===================================================================
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -781,6 +781,21 @@ static inline unsigned long get_debugctl
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
@@ -790,6 +805,18 @@ static inline void update_debugctlmsr(un
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

-- 

--===============0225869921==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

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

--===============0225869921==--
