Return-Path: <linux-kernel-owner+w=401wt.eu-S1755212AbZLCVYL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212AbZLCVYL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 16:24:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753854AbZLCVYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 16:24:10 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58805 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753426AbZLCVYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 16:24:09 -0500
Date: Thu, 3 Dec 2009 22:24:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes for v2.6.33
Message-ID: <20091203212405.GA14916@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

These are the fixes that got rolled over from the last .32-rc cycle.

 Thanks,

	Ingo

------------------>
Dave Jones (2):
      x86: Add new Intel CPU cache size descriptors
      x86: Fix typo in Intel CPU cache size descriptor

Hidetoshi Seto (1):
      x86, mce: don't restart timer if disabled

Prarit Bhargava (1):
      x86: AMD Northbridge: Verify NB's node is online

Randy Dunlap (1):
      x86 VSDO: Fix Kconfig help

Thomas Gleixner (2):
      x86: Prevent GCC 4.4.x (pentium-mmx et al) function prologue wreckage
      x86: Use -maccumulate-outgoing-args for sane mcount prologues


 arch/x86/Kconfig                      |    2 +-
 arch/x86/Makefile_32.cpu              |    7 +++++++
 arch/x86/kernel/cpu/intel_cacheinfo.c |    5 ++++-
 arch/x86/kernel/cpu/mcheck/mce.c      |    6 ++++--
 arch/x86/kernel/quirks.c              |    9 ++++++++-
 5 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 72ace95..618dede 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1602,7 +1602,7 @@ config COMPAT_VDSO
 	depends on X86_32 || IA32_EMULATION
 	---help---
 	  Map the 32-bit VDSO to the predictable old-style address too.
-	---help---
+
 	  Say N here if you are running a sufficiently recent glibc
 	  version (2.3.3 or later), to remove the high-mapped
 	  VDSO mapping and to exclusively use the randomized VDSO.
diff --git a/arch/x86/Makefile_32.cpu b/arch/x86/Makefile_32.cpu
index 30e9a26..1937226 100644
--- a/arch/x86/Makefile_32.cpu
+++ b/arch/x86/Makefile_32.cpu
@@ -46,6 +46,13 @@ cflags-$(CONFIG_MGEODEGX1)	+= -march=pentium-mmx
 # cpu entries
 cflags-$(CONFIG_X86_GENERIC) 	+= $(call tune,generic,$(call tune,i686))
 
+# Work around the pentium-mmx code generator madness of gcc4.4.x which
+# does stack alignment by generating horrible code _before_ the mcount
+# prologue (push %ebp, mov %esp, %ebp) which breaks the function graph
+# tracer assumptions. For i686, generic, core2 this is set by the
+# compiler anyway
+cflags-$(CONFIG_FUNCTION_GRAPH_TRACER) += $(call cc-option,-maccumulate-outgoing-args)
+
 # Bug fix for binutils: this option is required in order to keep
 # binutils from generating NOPL instructions against our will.
 ifneq ($(CONFIG_X86_P6_NOP),y)
diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 804c40e..8178d03 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -94,7 +94,7 @@ static const struct _cache_table __cpuinitconst cache_table[] =
 	{ 0xd1, LVL_3,    1024 },	/* 4-way set assoc, 64 byte line size */
 	{ 0xd2, LVL_3,    2048 },	/* 4-way set assoc, 64 byte line size */
 	{ 0xd6, LVL_3,    1024 },	/* 8-way set assoc, 64 byte line size */
-	{ 0xd7, LVL_3,    2038 },	/* 8-way set assoc, 64 byte line size */
+	{ 0xd7, LVL_3,    2048 },	/* 8-way set assoc, 64 byte line size */
 	{ 0xd8, LVL_3,    4096 },	/* 12-way set assoc, 64 byte line size */
 	{ 0xdc, LVL_3,    2048 },	/* 12-way set assoc, 64 byte line size */
 	{ 0xdd, LVL_3,    4096 },	/* 12-way set assoc, 64 byte line size */
@@ -102,6 +102,9 @@ static const struct _cache_table __cpuinitconst cache_table[] =
 	{ 0xe2, LVL_3,    2048 },	/* 16-way set assoc, 64 byte line size */
 	{ 0xe3, LVL_3,    4096 },	/* 16-way set assoc, 64 byte line size */
 	{ 0xe4, LVL_3,    8192 },	/* 16-way set assoc, 64 byte line size */
+	{ 0xea, LVL_3,    12288 },	/* 24-way set assoc, 64 byte line size */
+	{ 0xeb, LVL_3,    18432 },	/* 24-way set assoc, 64 byte line size */
+	{ 0xec, LVL_3,    24576 },	/* 24-way set assoc, 64 byte line size */
 	{ 0x00, 0, 0}
 };
 
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 721a77c..4825a3d 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1991,9 +1991,11 @@ mce_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		break;
 	case CPU_DOWN_FAILED:
 	case CPU_DOWN_FAILED_FROZEN:
-		t->expires = round_jiffies(jiffies +
+		if (!mce_ignore_ce && check_interval) {
+			t->expires = round_jiffies(jiffies +
 					   __get_cpu_var(mce_next_interval));
-		add_timer_on(t, cpu);
+			add_timer_on(t, cpu);
+		}
 		smp_call_function_single(cpu, mce_reenable_cpu, &action, 1);
 		break;
 	case CPU_POST_DEAD:
diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index 6c3b2c6..18093d7 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -499,6 +499,7 @@ static void __init quirk_amd_nb_node(struct pci_dev *dev)
 {
 	struct pci_dev *nb_ht;
 	unsigned int devfn;
+	u32 node;
 	u32 val;
 
 	devfn = PCI_DEVFN(PCI_SLOT(dev->devfn), 0);
@@ -507,7 +508,13 @@ static void __init quirk_amd_nb_node(struct pci_dev *dev)
 		return;
 
 	pci_read_config_dword(nb_ht, 0x60, &val);
-	set_dev_node(&dev->dev, val & 7);
+	node = val & 7;
+	/*
+	 * Some hardware may return an invalid node ID,
+	 * so check it first:
+	 */
+	if (node_online(node))
+		set_dev_node(&dev->dev, node);
 	pci_dev_put(nb_ht);
 }
 
