Return-Path: <linux-kernel-owner+w=401wt.eu-S1764976AbZD3RPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764976AbZD3RPe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:15:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764294AbZD3RHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:07:35 -0400
Received: from kroah.org ([198.145.64.141]:56294 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764174AbZD3RH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:07:28 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Apr 30 09:57:41 2009
Message-Id: <20090430165741.124450316@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 30 Apr 2009 09:56:08 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Andreas Herrmann <andreas.herrmann3@amd.com>,
       trenn@suse.de, Yinghai Lu <yinghai@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Chris Wright <chrisw@sous-sol.org>
Subject: [patch 19/88] x86: mtrr: dont modify RdDram/WrDram bits of fixed MTRRs
References: <20090430165549.117010404@mini.kroah.org>
Content-Disposition: inline; filename=0037-x86-mtrr-don-t-modify-RdDram-WrDram-bits-of-fixed.patch
In-Reply-To: <20090430170122.GA16015@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andreas Herrmann <andreas.herrmann3@amd.com>

upstream commit: 3ff42da5048649503e343a32be37b14a6a4e8aaf

Impact: bug fix + BIOS workaround

BIOS is expected to clear the SYSCFG[MtrrFixDramModEn] on AMD CPUs
after fixed MTRRs are configured.

Some BIOSes do not clear SYSCFG[MtrrFixDramModEn] on BP (and on APs).

This can lead to obfuscation in Linux when this bit is not cleared on
BP but cleared on APs. A consequence of this is that the saved
fixed-MTRR state (from BP) differs from the fixed-MTRRs of APs --
because RdDram/WrDram bits are read as zero when
SYSCFG[MtrrFixDramModEn] is cleared -- and Linux tries to sync
fixed-MTRR state from BP to AP. This implies that Linux sets
SYSCFG[MtrrFixDramEn] and activates those bits.

More important is that (some) systems change these bits in SMM when
ACPI is enabled. Hence it is racy if Linux modifies RdMem/WrMem bits,
too.

(1) The patch modifies an old fix from Bernhard Kaindl to get
    suspend/resume working on some Acer Laptops. Bernhard's patch
    tried to sync RdMem/WrMem bits of fixed MTRR registers and that
    helped on those old Laptops. (Don't ask me why -- can't test it
    myself). But this old problem was not the motivation for the
    patch. (See http://lkml.org/lkml/2007/4/3/110)

(2) The more important effect is to fix issues on some more current systems.

    On those systems Linux panics or just freezes, see

    http://bugzilla.kernel.org/show_bug.cgi?id=11541
    (and also duplicates of this bug:
    http://bugzilla.kernel.org/show_bug.cgi?id=11737
    http://bugzilla.kernel.org/show_bug.cgi?id=11714)

    The affected systems boot only using acpi=ht, acpi=off or
    when the kernel is built with CONFIG_MTRR=n.

    The acpi options prevent full enablement of ACPI.  Obviously when
    ACPI is enabled the BIOS/SMM modfies RdMem/WrMem bits.  When
    CONFIG_MTRR=y Linux also accesses and modifies those bits when it
    needs to sync fixed-MTRRs across cores (Bernhard's fix, see (1)).
    How do you synchronize that? You can't. As a consequence Linux
    shouldn't touch those bits at all (Rationale are AMD's BKDGs which
    recommend to clear the bit that makes RdMem/WrMem accessible).
    This is the purpose of this patch. And (so far) this suffices to
    fix (1) and (2).

I suggest not to touch RdDram/WrDram bits of fixed-MTRRs and
SYSCFG[MtrrFixDramEn] and to clear SYSCFG[MtrrFixDramModEn] as
suggested by AMD K8, and AMD family 10h/11h BKDGs.
BIOS is expected to do this anyway. This should avoid that
Linux and SMM tread on each other's toes ...

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: trenn@suse.de
Cc: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <20090312163937.GH20716@alberich.amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kernel/cpu/mtrr/generic.c |   51 +++++++++++++++++++++----------------
 1 file changed, 30 insertions(+), 21 deletions(-)

--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -45,6 +45,32 @@ u64 mtrr_tom2;
 static int mtrr_show;
 module_param_named(show, mtrr_show, bool, 0);
 
+/**
+ * BIOS is expected to clear MtrrFixDramModEn bit, see for example
+ * "BIOS and Kernel Developer's Guide for the AMD Athlon 64 and AMD
+ * Opteron Processors" (26094 Rev. 3.30 February 2006), section
+ * "13.2.1.2 SYSCFG Register": "The MtrrFixDramModEn bit should be set
+ * to 1 during BIOS initalization of the fixed MTRRs, then cleared to
+ * 0 for operation."
+ */
+static inline void k8_check_syscfg_dram_mod_en(void)
+{
+	u32 lo, hi;
+
+	if (!((boot_cpu_data.x86_vendor == X86_VENDOR_AMD) &&
+	      (boot_cpu_data.x86 >= 0x0f)))
+		return;
+
+	rdmsr(MSR_K8_SYSCFG, lo, hi);
+	if (lo & K8_MTRRFIXRANGE_DRAM_MODIFY) {
+		printk(KERN_ERR FW_WARN "MTRR: CPU %u: SYSCFG[MtrrFixDramModEn]"
+		       " not cleared by BIOS, clearing this bit\n",
+		       smp_processor_id());
+		lo &= ~K8_MTRRFIXRANGE_DRAM_MODIFY;
+		mtrr_wrmsr(MSR_K8_SYSCFG, lo, hi);
+	}
+}
+
 /*
  * Returns the effective MTRR type for the region
  * Error returns:
@@ -178,6 +204,8 @@ get_fixed_ranges(mtrr_type * frs)
 	unsigned int *p = (unsigned int *) frs;
 	int i;
 
+	k8_check_syscfg_dram_mod_en();
+
 	rdmsr(MTRRfix64K_00000_MSR, p[0], p[1]);
 
 	for (i = 0; i < 2; i++)
@@ -312,27 +340,10 @@ void mtrr_wrmsr(unsigned msr, unsigned a
 }
 
 /**
- * Enable and allow read/write of extended fixed-range MTRR bits on K8 CPUs
- * see AMD publication no. 24593, chapter 3.2.1 for more information
- */
-static inline void k8_enable_fixed_iorrs(void)
-{
-	unsigned lo, hi;
-
-	rdmsr(MSR_K8_SYSCFG, lo, hi);
-	mtrr_wrmsr(MSR_K8_SYSCFG, lo
-				| K8_MTRRFIXRANGE_DRAM_ENABLE
-				| K8_MTRRFIXRANGE_DRAM_MODIFY, hi);
-}
-
-/**
  * set_fixed_range - checks & updates a fixed-range MTRR if it differs from the value it should have
  * @msr: MSR address of the MTTR which should be checked and updated
  * @changed: pointer which indicates whether the MTRR needed to be changed
  * @msrwords: pointer to the MSR values which the MSR should have
- *
- * If K8 extentions are wanted, update the K8 SYSCFG MSR also.
- * See AMD publication no. 24593, chapter 7.8.1, page 233 for more information.
  */
 static void set_fixed_range(int msr, bool *changed, unsigned int *msrwords)
 {
@@ -341,10 +352,6 @@ static void set_fixed_range(int msr, boo
 	rdmsr(msr, lo, hi);
 
 	if (lo != msrwords[0] || hi != msrwords[1]) {
-		if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD &&
-		    (boot_cpu_data.x86 >= 0x0f && boot_cpu_data.x86 <= 0x11) &&
-		    ((msrwords[0] | msrwords[1]) & K8_MTRR_RDMEM_WRMEM_MASK))
-			k8_enable_fixed_iorrs();
 		mtrr_wrmsr(msr, msrwords[0], msrwords[1]);
 		*changed = true;
 	}
@@ -423,6 +430,8 @@ static int set_fixed_ranges(mtrr_type * 
 	bool changed = false;
 	int block=-1, range;
 
+	k8_check_syscfg_dram_mod_en();
+
 	while (fixed_range_blocks[++block].ranges)
 	    for (range=0; range < fixed_range_blocks[block].ranges; range++)
 		set_fixed_range(fixed_range_blocks[block].base_msr + range,


