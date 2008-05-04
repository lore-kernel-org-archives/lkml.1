Return-Path: <linux-kernel-owner+w=401wt.eu-S1758233AbYEDTh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758233AbYEDTh4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 15:37:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757500AbYEDThf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 15:37:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38250 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756811AbYEDThc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 15:37:32 -0400
Date: Sun, 4 May 2008 21:35:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] x86 fixes
Message-ID: <20080504193113.GA24358@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull the latest x86 git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86-fixes.git for-linus

x86 fixes plus the UML Makefile fix for the inlining related bug that 
got triggered by OPTIMIZE_INLINING.

	Ingo

------------------>
Adrian Bunk (3):
      x86: make start_secondary() static
      x86: make additional_cpus static
      x86: video/fbdev.c: add MODULE_LICENSE

Ben (1):
      x86: remove dell reboot dmi quirk board name match

Cyrill Gorcunov (2):
      x86: vdso ELF handling - use SELFMAG instead of numeric constant
      x86: relocs ELF handling - use SELFMAG instead of numeric constant

Ingo Molnar (2):
      uml: fix gcc problem
      x86: es7000 build fix

Randy Dunlap (1):
      x86: fix setup printk format warning

Rusty Russell (1):
      x86: fix up bootparam.h for userspace inclusion

Sam Ravnborg (1):
      kbuild, suspend, x86: fix rebuild of wakeup.bin

Thomas Gleixner (2):
      x86: undo visws/numaq build changes
      x86: olpc build fix

 arch/um/Makefile                       |    5 ++++-
 arch/x86/Kconfig                       |    1 +
 arch/x86/boot/compressed/relocs.c      |    2 +-
 arch/x86/kernel/acpi/Makefile          |    2 +-
 arch/x86/kernel/acpi/realmode/Makefile |    5 +++--
 arch/x86/kernel/mpparse.c              |    7 +++++--
 arch/x86/kernel/reboot.c               |    1 -
 arch/x86/kernel/setup.c                |    2 +-
 arch/x86/kernel/smpboot.c              |    4 ++--
 arch/x86/mm/discontig_32.c             |   26 --------------------------
 arch/x86/pci/Makefile_32               |   12 ++++++++++--
 arch/x86/vdso/vdso32-setup.c           |    2 +-
 arch/x86/video/fbdev.c                 |    2 +-
 include/asm-x86/bootparam.h            |    8 ++++----
 14 files changed, 34 insertions(+), 45 deletions(-)

diff --git a/arch/um/Makefile b/arch/um/Makefile
index dbeab15..01b97c1 100644
--- a/arch/um/Makefile
+++ b/arch/um/Makefile
@@ -77,7 +77,10 @@ include $(srctree)/$(ARCH_DIR)/Makefile-os-$(OS)
 KERNEL_DEFINES = $(strip -Derrno=kernel_errno -Dsigprocmask=kernel_sigprocmask \
 			 -Dmktime=kernel_mktime $(ARCH_KERNEL_DEFINES))
 KBUILD_CFLAGS += $(KERNEL_DEFINES)
-KBUILD_CFLAGS += $(call cc-option,-fno-unit-at-a-time,)
+# Disable unit-at-a-time mode on pre-gcc-4.0 compilers, it makes gcc use
+# a lot more stack due to the lack of sharing of stacklots:
+KBUILD_CFLAGS += $(shell if [ $(call cc-version) -lt 0400 ] ; then \
+			echo $(call cc-option,-fno-unit-at-a-time); fi ;)
 
 PHONY += linux
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index c3f8809..845ea2b 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1661,6 +1661,7 @@ config GEODE_MFGPT_TIMER
 
 config OLPC
 	bool "One Laptop Per Child support"
+	depends on MGEODE_LX
 	default n
 	help
 	  Add support for detecting the unique features of the OLPC
diff --git a/arch/x86/boot/compressed/relocs.c b/arch/x86/boot/compressed/relocs.c
index d01ea42..edaadea 100644
--- a/arch/x86/boot/compressed/relocs.c
+++ b/arch/x86/boot/compressed/relocs.c
@@ -191,7 +191,7 @@ static void read_ehdr(FILE *fp)
 		die("Cannot read ELF header: %s\n",
 			strerror(errno));
 	}
-	if (memcmp(ehdr.e_ident, ELFMAG, 4) != 0) {
+	if (memcmp(ehdr.e_ident, ELFMAG, SELFMAG) != 0) {
 		die("No ELF magic\n");
 	}
 	if (ehdr.e_ident[EI_CLASS] != ELFCLASS32) {
diff --git a/arch/x86/kernel/acpi/Makefile b/arch/x86/kernel/acpi/Makefile
index 7335959..fd5ca97 100644
--- a/arch/x86/kernel/acpi/Makefile
+++ b/arch/x86/kernel/acpi/Makefile
@@ -10,5 +10,5 @@ endif
 $(obj)/wakeup_rm.o:    $(obj)/realmode/wakeup.bin
 
 $(obj)/realmode/wakeup.bin: FORCE
-	$(Q)$(MAKE) $(build)=$(obj)/realmode $@
+	$(Q)$(MAKE) $(build)=$(obj)/realmode
 
diff --git a/arch/x86/kernel/acpi/realmode/Makefile b/arch/x86/kernel/acpi/realmode/Makefile
index 0929008..1c31cc0 100644
--- a/arch/x86/kernel/acpi/realmode/Makefile
+++ b/arch/x86/kernel/acpi/realmode/Makefile
@@ -6,7 +6,8 @@
 # for more details.
 #
 
-targets		:= wakeup.bin wakeup.elf
+always		:= wakeup.bin
+targets		:= wakeup.elf wakeup.lds
 
 wakeup-y	+= wakeup.o wakemain.o video-mode.o copy.o
 
@@ -48,7 +49,7 @@ LDFLAGS_wakeup.elf	:= -T
 
 CPPFLAGS_wakeup.lds += -P -C
 
-$(obj)/wakeup.elf: $(src)/wakeup.lds $(WAKEUP_OBJS) FORCE
+$(obj)/wakeup.elf: $(obj)/wakeup.lds $(WAKEUP_OBJS) FORCE
 	$(call if_changed,ld)
 
 OBJCOPYFLAGS_wakeup.bin	:= -O binary
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 3e2c54d..404683b 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -794,6 +794,11 @@ void __init find_smp_config(void)
                             ACPI-based MP Configuration
    -------------------------------------------------------------------------- */
 
+/*
+ * Keep this outside and initialized to 0, for !CONFIG_ACPI builds:
+ */
+int es7000_plat;
+
 #ifdef CONFIG_ACPI
 
 #ifdef	CONFIG_X86_IO_APIC
@@ -909,8 +914,6 @@ void __init mp_override_legacy_irq(u8 bus_irq, u8 polarity, u8 trigger, u32 gsi)
 	MP_intsrc_info(&intsrc);
 }
 
-int es7000_plat;
-
 void __init mp_config_acpi_legacy_irqs(void)
 {
 	struct mpc_config_intsrc intsrc;
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 07c6d42..f6be7d5 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -149,7 +149,6 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
 			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex 745"),
-			DMI_MATCH(DMI_BOARD_NAME, "0WF810"),
 		},
 	},
 	{       /* Handle problems with rebooting on Dell Optiplex 745's DFF*/
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index c0c68c1..cc6f5eb 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -95,7 +95,7 @@ void __init setup_per_cpu_areas(void)
 
 	/* Copy section for each CPU (we discard the original) */
 	size = PERCPU_ENOUGH_ROOM;
-	printk(KERN_INFO "PERCPU: Allocating %lu bytes of per cpu data\n",
+	printk(KERN_INFO "PERCPU: Allocating %zd bytes of per cpu data\n",
 			  size);
 
 	for_each_possible_cpu(i) {
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 84241a2..6b087ab 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -299,7 +299,7 @@ static void __cpuinit smp_callin(void)
 /*
  * Activate a secondary processor.
  */
-void __cpuinit start_secondary(void *unused)
+static void __cpuinit start_secondary(void *unused)
 {
 	/*
 	 * Don't put *anything* before cpu_init(), SMP booting is too
@@ -1306,7 +1306,7 @@ static void remove_siblinginfo(int cpu)
 	cpu_clear(cpu, cpu_sibling_setup_map);
 }
 
-int additional_cpus __initdata = -1;
+static int additional_cpus __initdata = -1;
 
 static __init int setup_additional_cpus(char *s)
 {
diff --git a/arch/x86/mm/discontig_32.c b/arch/x86/mm/discontig_32.c
index 1837885..914ccf9 100644
--- a/arch/x86/mm/discontig_32.c
+++ b/arch/x86/mm/discontig_32.c
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
diff --git a/arch/x86/pci/Makefile_32 b/arch/x86/pci/Makefile_32
index 7fa5198..89ec35d 100644
--- a/arch/x86/pci/Makefile_32
+++ b/arch/x86/pci/Makefile_32
@@ -6,11 +6,19 @@ obj-$(CONFIG_PCI_DIRECT)	+= direct.o
 obj-$(CONFIG_PCI_OLPC)		+= olpc.o
 
 pci-y				:= fixup.o
+
+# Do not change the ordering here. There is a nasty init function
+# ordering dependency which breaks when you move acpi.o below
+# legacy/irq.o
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
diff --git a/arch/x86/vdso/vdso32-setup.c b/arch/x86/vdso/vdso32-setup.c
index 4dceeb1..cf058fe 100644
--- a/arch/x86/vdso/vdso32-setup.c
+++ b/arch/x86/vdso/vdso32-setup.c
@@ -162,7 +162,7 @@ static __init void relocate_vdso(Elf32_Ehdr *ehdr)
 	Elf32_Shdr *shdr;
 	int i;
 
-	BUG_ON(memcmp(ehdr->e_ident, ELFMAG, 4) != 0 ||
+	BUG_ON(memcmp(ehdr->e_ident, ELFMAG, SELFMAG) != 0 ||
 	       !elf_check_arch_ia32(ehdr) ||
 	       ehdr->e_type != ET_DYN);
 
diff --git a/arch/x86/video/fbdev.c b/arch/x86/video/fbdev.c
index 4db42bf..6952768 100644
--- a/arch/x86/video/fbdev.c
+++ b/arch/x86/video/fbdev.c
@@ -1,5 +1,4 @@
 /*
- *
  * Copyright (C) 2007 Antonino Daplas <adaplas@gmail.com>
  *
  * This file is subject to the terms and conditions of the GNU General Public
@@ -29,3 +28,4 @@ int fb_is_primary_device(struct fb_info *info)
 	return retval;
 }
 EXPORT_SYMBOL(fb_is_primary_device);
+MODULE_LICENSE("GPL");
diff --git a/include/asm-x86/bootparam.h b/include/asm-x86/bootparam.h
index e865990..f62f473 100644
--- a/include/asm-x86/bootparam.h
+++ b/include/asm-x86/bootparam.h
@@ -14,10 +14,10 @@
 
 /* extensible setup data list node */
 struct setup_data {
-	u64 next;
-	u32 type;
-	u32 len;
-	u8 data[0];
+	__u64 next;
+	__u32 type;
+	__u32 len;
+	__u8 data[0];
 };
 
 struct setup_header {
