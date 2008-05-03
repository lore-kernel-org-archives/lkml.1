Return-Path: <linux-kernel-owner+w=401wt.eu-S1761835AbYECJ1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761835AbYECJ1w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 05:27:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758035AbYECJ1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 05:27:42 -0400
Received: from www.tglx.de ([62.245.132.106]:57885 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757125AbYECJ1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 05:27:41 -0400
Date: Sat, 3 May 2008 11:27:12 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Adrian Bunk <bunk@kernel.org>
cc: "H. Peter Anvin" <hpa@zytor.com>,
       Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: x86 git acpi issue?
In-Reply-To: <20080503071332.GF5838@cs181133002.pp.htv.fi>
Message-ID: <alpine.LFD.1.10.0805031123420.6003@apollo.tec.linutronix.de>
References: <481BAC6F.5090509@ct.jp.nec.com> <481BACEC.8080902@zytor.com> <20080503071332.GF5838@cs181133002.pp.htv.fi>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 May 2008, Adrian Bunk wrote:
> Commit afcab879e4044f952b7a031d5fd504e0feb7df41 is the commit where Ingo 
> both _reverts_ his patch you describe in the x86 tree and additionally 
> moves pci-$(CONFIG_ACPI) in exactly the way that causes this breakage.
> 
> In the 4 hours between Ingo doing the += change and Ingo reverting his 
> own patch in the x86 tree it was in a pull request to Linus, so the
> "queued up" patch is in Linus' tree but reverted in the x86 tree.
> 
> I saw neither the patch changing the :='s to += on linux-kernel nor does 
> "do not override the existing pci-y rule when adding visws or numaq 
> rules." in the commit description give any indication what the actual 
> problem was.
> 
> It's also not obvious why the revert with the subject "visws: build fix" 
> also moved the pci-$(CONFIG_ACPI) causing this bug here.

Right. This Makefile is a nasty trap. I looked into it and the fix for
now is below. Long term this Makefile trickery needs to be cleaned up
to avoid trapping into this again.

Thanks,
	tglx

--------->
Subject: x86: undo visws/numaq build changes
From: Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 02 May 2008 21:24:30 +0200

arch/x86/pci/Makefile_32 has a nasty detail. VISWS and NUMAQ builds
override the generic pci-y rules. This needs a proper cleanup, but
that needs more thoughts. Undo

commit 895d30935ebe05f192e844792668bf8d19deaae7
    x86: numaq fix
    do not override the existing pci-y rule when adding visws or
    numaq rules.

and add a comment to the Makefile.

Remove the srat stub code in discontig_32.c to allow a proper NUMAQ
build.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/mm/discontig_32.c |   26 --------------------------
 arch/x86/pci/Makefile_32   |    8 ++++++--
 2 files changed, 6 insertions(+), 28 deletions(-)
Index: linux-2.6/arch/x86/mm/discontig_32.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/discontig_32.c
+++ linux-2.6/arch/x86/mm/discontig_32.c
@@ -476,29 +476,3 @@ int memory_add_physaddr_to_nid(u64 addr)
 
 EXPORT_SYMBOL_GPL(memory_add_physaddr_to_nid);
 #endif
-
-#ifndef CONFIG_HAVE_ARCH_PARSE_SRAT
-/*
- * XXX FIXME: Make SLIT table parsing available to 32-bit NUMA
- *
- * These stub functions are needed to compile 32-bit NUMA when SRAT is
- * not set. There are functions in srat_64.c for parsing this table
- * and it may be possible to make them common functions.
- */
-void acpi_numa_slit_init (struct acpi_table_slit *slit)
-{
-	printk(KERN_INFO "ACPI: No support for parsing SLIT table\n");
-}
-
-void acpi_numa_processor_affinity_init (struct acpi_srat_cpu_affinity *pa)
-{
-}
-
-void acpi_numa_memory_affinity_init (struct acpi_srat_mem_affinity *ma)
-{
-}
-
-void acpi_numa_arch_fixup(void)
-{
-}
-#endif /* CONFIG_HAVE_ARCH_PARSE_SRAT */
Index: linux-2.6/arch/x86/pci/Makefile_32
===================================================================
--- linux-2.6.orig/arch/x86/pci/Makefile_32
+++ linux-2.6/arch/x86/pci/Makefile_32
@@ -9,8 +9,12 @@ pci-y				:= fixup.o
 pci-$(CONFIG_ACPI)		+= acpi.o
 pci-y				+= legacy.o irq.o
 
-pci-$(CONFIG_X86_VISWS)		+= visws.o fixup.o
-pci-$(CONFIG_X86_NUMAQ)		+= numa.o irq.o
+# Careful: VISWS and NUMAQ overrule the pci-y above. The colons are
+# therefor correct. This needs a proper fix by distangling the code.
+pci-$(CONFIG_X86_VISWS)		:= visws.o fixup.o
+pci-$(CONFIG_X86_NUMAQ)		:= numa.o irq.o
+
+# Necessary for NUMAQ as well
 pci-$(CONFIG_NUMA)		+= mp_bus_to_node.o
 
 obj-y				+= $(pci-y) common.o early.o
