Return-Path: <linux-kernel-owner+w=401wt.eu-S1751857AbZEYUFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857AbZEYUFX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 16:05:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751547AbZEYUFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 16:05:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45175 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbZEYUFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 16:05:11 -0400
Date: Mon, 25 May 2009 13:03:54 -0700
Message-Id: <200905252003.n4PK3sFi014919@voreg.hos.anvin.org>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86 fixes for 2.6.30-rc8
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Thomas Gleixner <tglx@linutronix.de> Suresh Siddha" 
	<suresh.siddha@intel.com>,
       Tejun Heo <tj@kernel.org>,
       Venkatesh Pallapadi <venkatesh.pallapadi@intel.com>,
       Zhang Rui <rui.zhang@intel.com>, "H. Peter Anvin" <hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

A small batch of x86 fixes.

The following changes since commit 59a3759d0fe8d969888c741bb33f4946e4d3750d:
  Linus Torvalds (1):
        Linux 2.6.30-rc7

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

H. Peter Anvin (1):
      x86, setup: revert ACPI 3 E820 extended attributes support

Suresh Siddha (1):
      x86: introduce noxsave boot parameter

Tejun Heo (1):
      x86: Remove remap percpu allocator for the time being

Zhang Rui (1):
      x86: DMI match for the Sony VGN-Z540N as it needs BIOS reboot

venkatesh.pallipadi@intel.com (2):
      x86: bugfix wbinvd() model check instead of family check
      x86: cpa_flush_array wbinvd should be done on all CPUs

 Documentation/kernel-parameters.txt |    4 ++++
 arch/x86/boot/memory.c              |   29 +++++++++++++----------------
 arch/x86/kernel/cpu/common.c        |    7 +++++++
 arch/x86/kernel/reboot.c            |    8 ++++++++
 arch/x86/kernel/setup_percpu.c      |    4 +++-
 arch/x86/mm/pageattr.c              |   12 +++++++++---
 6 files changed, 44 insertions(+), 20 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index e87bdbf..fd5cac0 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1535,6 +1535,10 @@ and is between 256 and 4096 characters. It is defined in the file
 			register save and restore. The kernel will only save
 			legacy floating-point registers on task switch.
 
+	noxsave		[BUGS=X86] Disables x86 extended register state save
+			and restore using xsave. The kernel will fallback to
+			enabling legacy floating-point and sse state.
+
 	nohlt		[BUGS=ARM,SH] Tells the kernel that the sleep(SH) or
 			wfi(ARM) instruction doesn't work correctly and not to
 			use it. This is also useful when using JTAG debugger.
diff --git a/arch/x86/boot/memory.c b/arch/x86/boot/memory.c
index 5054c2d..74b3d2b 100644
--- a/arch/x86/boot/memory.c
+++ b/arch/x86/boot/memory.c
@@ -17,11 +17,6 @@
 
 #define SMAP	0x534d4150	/* ASCII "SMAP" */
 
-struct e820_ext_entry {
-	struct e820entry std;
-	u32 ext_flags;
-} __attribute__((packed));
-
 static int detect_memory_e820(void)
 {
 	int count = 0;
@@ -29,13 +24,21 @@ static int detect_memory_e820(void)
 	u32 size, id, edi;
 	u8 err;
 	struct e820entry *desc = boot_params.e820_map;
-	static struct e820_ext_entry buf; /* static so it is zeroed */
+	static struct e820entry buf; /* static so it is zeroed */
 
 	/*
-	 * Set this here so that if the BIOS doesn't change this field
-	 * but still doesn't change %ecx, we're still okay...
+	 * Note: at least one BIOS is known which assumes that the
+	 * buffer pointed to by one e820 call is the same one as
+	 * the previous call, and only changes modified fields.  Therefore,
+	 * we use a temporary buffer and copy the results entry by entry.
+	 *
+	 * This routine deliberately does not try to account for
+	 * ACPI 3+ extended attributes.  This is because there are
+	 * BIOSes in the field which report zero for the valid bit for
+	 * all ranges, and we don't currently make any use of the
+	 * other attribute bits.  Revisit this if we see the extended
+	 * attribute bits deployed in a meaningful way in the future.
 	 */
-	buf.ext_flags = 1;
 
 	do {
 		size = sizeof buf;
@@ -66,13 +69,7 @@ static int detect_memory_e820(void)
 			break;
 		}
 
-		/* ACPI 3.0 added the extended flags support.  If bit 0
-		   in the extended flags is zero, we're supposed to simply
-		   ignore the entry -- a backwards incompatible change! */
-		if (size > 20 && !(buf.ext_flags & 1))
-			continue;
-
-		*desc++ = buf.std;
+		*desc++ = buf;
 		count++;
 	} while (next && count < ARRAY_SIZE(boot_params.e820_map));
 
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index c1caefc..77848d9 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -114,6 +114,13 @@ DEFINE_PER_CPU_PAGE_ALIGNED(struct gdt_page, gdt_page) = { .gdt = {
 } };
 EXPORT_PER_CPU_SYMBOL_GPL(gdt_page);
 
+static int __init x86_xsave_setup(char *s)
+{
+	setup_clear_cpu_cap(X86_FEATURE_XSAVE);
+	return 1;
+}
+__setup("noxsave", x86_xsave_setup);
+
 #ifdef CONFIG_X86_32
 static int cachesize_override __cpuinitdata = -1;
 static int disable_x86_serial_nr __cpuinitdata = 1;
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 1340dad..667188e 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -232,6 +232,14 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Dell DXP061"),
 		},
 	},
+	{	/* Handle problems with rebooting on Sony VGN-Z540N */
+		.callback = set_bios_reboot,
+		.ident = "Sony VGN-Z540N",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "VGN-Z540N"),
+		},
+	},
 	{ }
 };
 
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 3a97a4c..8f0e13b 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -160,8 +160,10 @@ static ssize_t __init setup_pcpu_remap(size_t static_size)
 	/*
 	 * If large page isn't supported, there's no benefit in doing
 	 * this.  Also, on non-NUMA, embedding is better.
+	 *
+	 * NOTE: disabled for now.
 	 */
-	if (!cpu_has_pse || !pcpu_need_numa())
+	if (true || !cpu_has_pse || !pcpu_need_numa())
 		return -EINVAL;
 
 	/*
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 797f9f1..0f9052b 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -153,7 +153,7 @@ static void __cpa_flush_all(void *arg)
 	 */
 	__flush_tlb_all();
 
-	if (cache && boot_cpu_data.x86_model >= 4)
+	if (cache && boot_cpu_data.x86 >= 4)
 		wbinvd();
 }
 
@@ -204,6 +204,11 @@ static void cpa_flush_range(unsigned long start, int numpages, int cache)
 	}
 }
 
+static void wbinvd_local(void *unused)
+{
+	wbinvd();
+}
+
 static void cpa_flush_array(unsigned long *start, int numpages, int cache,
 			    int in_flags, struct page **pages)
 {
@@ -218,8 +223,9 @@ static void cpa_flush_array(unsigned long *start, int numpages, int cache,
 
 	/* 4M threshold */
 	if (numpages >= 1024) {
-		if (boot_cpu_data.x86_model >= 4)
-			wbinvd();
+		if (boot_cpu_data.x86 >= 4)
+			on_each_cpu(wbinvd_local, NULL, 1);
+
 		return;
 	}
 	/*
