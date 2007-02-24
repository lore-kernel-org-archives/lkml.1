Return-Path: <linux-kernel-owner+w=401wt.eu-S933587AbXBXXZE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933587AbXBXXZE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 18:25:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933591AbXBXXZD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 18:25:03 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:42359 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933587AbXBXXZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 18:25:00 -0500
Date: Sun, 25 Feb 2007 00:25:27 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Detecting section mismatches in vmlinux
Message-ID: <20070224232527.GA10768@uranus.ravnborg.org>
References: <20070222.005728.126762028.anemo@mba.ocn.ne.jp> <20070225.035315.25909736.anemo@mba.ocn.ne.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070225.035315.25909736.anemo@mba.ocn.ne.jp>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Atsushi-san

On Sun, Feb 25, 2007 at 03:53:15AM +0900, Atsushi Nemoto wrote:
> On Thu, 22 Feb 2007 00:57:28 +0900 (JST), Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:
> > $ ../build-i386/scripts/mod/modpost ../build-i386/mm/built-in.o
> > WARNING: ../build-i386/mm/built-in.o - Section mismatch: reference to .init.data:initkmem_list3 from .text between 'set_up_list3s' (at offset 0x18382) and '__kmem_cache_destroy'
> > 
> > set_up_list3s() in slab.c is not marked as __init and it references
> > initkmem_list3[] which is marked as __initdata.  So it is not false
> > positive.  But "modpost vmlinux" does not report it.

Correct- modpost vmlinux lacks relocation infomration info in vmlinux so it will
not report these errors.

> Maybe checking at each $(LD) invocation should detect all mismatches,
> but I'm not familer with kbuild to do it by myself.  Could someone
> make perfect solution?

Attached patch does:
1) Do not check vmlinux but check all .o files that is used to create vmlinux
2) Teach modpost to skip non-elf files (.a files and empty .o files etc)

With this change we get proper check of vmlinux (or files used to create vmlinux)

This gives following errors in a x86_64 defconfig build:

WARNING: init/built-in.o - Section mismatch: reference to .init.text:init from .text between 'rest_init' (at offset 0xe) and 'run_init_process'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.text:mtrr_bp_init from .text between 'identify_cpu' (at offset 0x65eb) and 'IRQ0x20_interrupt'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.data: from .text between 'finish_e820_parsing' (at offset 0x7dc2) and 'early_panic'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.text:e820_print_map from .text between 'finish_e820_parsing' (at offset 0x7de1) and 'early_panic'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.data:num_processors from .text between 'acpi_unmap_lsapic' (at offset 0xc88f) and 'acpi_register_ioapic'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.text:stop_timer_interrupt from .text between 'setup_APIC_timer' (at offset 0xfcbc) and 'setup_secondary_APIC_clock'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.data:disabled_cpus from .text between 'MP_processor_info' (at offset 0x11f35) and 'mp_register_lapic'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.data:num_processors from .text between 'MP_processor_info' (at offset 0x11f6e) and 'mp_register_lapic'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.data:num_processors from .text between 'MP_processor_info' (at offset 0x11f93) and 'mp_register_lapic'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.data:fix_aperture from .text between 'gart_parse_options' (at offset 0x15517) and 'iommu_full'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.data:fix_aperture from .text between 'gart_parse_options' (at offset 0x1552c) and 'iommu_full'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.data:iommu_aperture_allowed from .text between 'gart_parse_options' (at offset 0x1553d) and 'iommu_full'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.data:iommu_aperture_allowed from .text between 'gart_parse_options' (at offset 0x15552) and 'iommu_full'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.data:iommu_aperture_allowed from .text between 'gart_parse_options' (at offset 0x15561) and 'iommu_full'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.data:iommu_aperture_allowed from .text between 'gart_parse_options' (at offset 0x15577) and 'iommu_full'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.data:fallback_aper_force from .text between 'gart_parse_options' (at offset 0x1558a) and 'iommu_full'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.data:fallback_aper_order from .text between 'gart_parse_options' (at offset 0x155bf) and 'iommu_full'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.data:timer_over_8254 from .text between 'ati_bugs' (at offset 0x16344) and 'via_bugs'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.data:timer_over_8254 from .text between 'ati_bugs' (at offset 0x16356) and 'via_bugs'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.data:iommu_aperture_allowed from .text between 'via_bugs' (at offset 0x16380) and 'nvidia_bugs'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.data:iommu_aperture_disabled from .text between 'via_bugs' (at offset 0x16397) and 'nvidia_bugs'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.data:acpi_use_timer_override from .text between 'nvidia_bugs' (at offset 0x163a7) and 'arch_unregister_cpu'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.text:nvidia_hpet_check from .text between 'nvidia_bugs' (at offset 0x163b1) and 'arch_unregister_cpu'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.data: from .text between 'nvidia_bugs' (at offset 0x163be) and 'arch_unregister_cpu'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.data: from .text between 'nvidia_bugs' (at offset 0x163d1) and 'arch_unregister_cpu'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.data:acpi_skip_timer_override from .text between 'nvidia_bugs' (at offset 0x163e1) and 'arch_unregister_cpu'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.text:quirk_intel_irqbalance from .text between 'intel_bugs' (at offset 0x1633c) and 'ati_bugs'
WARNING: mm/built-in.o - Section mismatch: reference to .init.data:initkmem_list3 from .text between 'set_up_list3s' (at offset 0x1e6fb) and 'slab_get_obj'
WARNING: mm/built-in.o - Section mismatch: reference to .init.data:initkmem_list3 from .text between 'set_up_list3s' (at offset 0x1e71c) and 'slab_get_obj'
WARNING: lib/built-in.o - Section mismatch: reference to .init.text:swiotlb_init from __ksymtab between '__ksymtab_swiotlb_init' (at offset 0x3a0) and '__ksymtab_swiotlb_map_single'
WARNING: drivers/built-in.o - Section mismatch: reference to .init.text:quirk_ide_samemode from .pci_fixup_early between '__pci_fixup_PCI_VENDOR_ID_INTELPCI_DEVICE_ID_INTEL_82801CA_10quirk_ide_samemode' (at offset 0x18) and '__pci_fixup_PCI_VENDOR_ID_JMICRONPCI_ANY_IDquirk_jmicron_dualfn'


Before pushing this patch the above list needs to be smaller :-(
I have not yet looked into the list.

	Sam

diff --git a/Makefile b/Makefile
index 30b66e2..fa32fde 100644
--- a/Makefile
+++ b/Makefile
@@ -603,6 +603,7 @@ vmlinux-init := $(head-y) $(init-y)
 vmlinux-main := $(core-y) $(libs-y) $(drivers-y) $(net-y)
 vmlinux-all  := $(vmlinux-init) $(vmlinux-main)
 vmlinux-lds  := arch/$(ARCH)/kernel/vmlinux.lds
+export KBUILD_VMLINUX_OBJS := $(vmlinux-all)
 
 # Rule to link vmlinux - also used during CONFIG_KALLSYMS
 # May be overridden by arch/$(ARCH)/Makefile
diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
index 65e0a79..d7277bb 100644
--- a/scripts/Makefile.modpost
+++ b/scripts/Makefile.modpost
@@ -63,15 +63,14 @@ quiet_cmd_modpost = MODPOST $(words $(fi
 	$(if $(KBUILD_EXTMOD),-i,-o) $(kernelsymfile) \
 	$(if $(KBUILD_EXTMOD),-I $(modulesymfile)) \
 	$(if $(KBUILD_EXTMOD),-o $(modulesymfile)) \
-	$(if $(KBUILD_EXTMOD)$(KBUILD_MODPOST_WARN),-w) \
-	$(wildcard vmlinux) $(filter-out FORCE,$^)
+	$(if $(KBUILD_EXTMOD)$(KBUILD_MODPOST_WARN),-w)
 
 PHONY += __modpost
 __modpost: $(modules:.ko=.o) FORCE
-	$(call cmd,modpost)
+	$(call cmd,modpost) $(wildcard vmlinux) $(filter-out FORCE,$^)
 
 quiet_cmd_kernel-mod = MODPOST $@
-      cmd_kernel-mod = $(cmd_modpost)
+      cmd_kernel-mod = $(cmd_modpost) $(KBUILD_VMLINUX_OBJS)
 
 vmlinux: FORCE
 	$(call cmd,kernel-mod)
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index c4b5398..ec7ad96 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -333,10 +333,10 @@ void release_file(void *file, unsigned l
 	munmap(file, size);
 }
 
-static void parse_elf(struct elf_info *info, const char *filename)
+static int parse_elf(struct elf_info *info, const char *filename)
 {
 	unsigned int i;
-	Elf_Ehdr *hdr = info->hdr;
+	Elf_Ehdr *hdr;
 	Elf_Shdr *sechdrs;
 	Elf_Sym  *sym;
 
@@ -346,8 +346,19 @@ static void parse_elf(struct elf_info *i
 		exit(1);
 	}
 	info->hdr = hdr;
-	if (info->size < sizeof(*hdr))
-		goto truncated;
+	/* Is this a valid ELF file? */
+	if ((hdr->e_ident[EI_MAG0] != ELFMAG0) ||
+	    (hdr->e_ident[EI_MAG1] != ELFMAG1) ||
+	    (hdr->e_ident[EI_MAG2] != ELFMAG2) ||
+	    (hdr->e_ident[EI_MAG3] != ELFMAG3)) {
+		/* Not an ELF file - silently ignore it */
+		return 0;
+	}
+
+	if (info->size < sizeof(*hdr)) {
+		/* file too small, assume this is an empty .o file */
+		return 0;
+	}
 
 	/* Fix endianness in ELF header */
 	hdr->e_shoff    = TO_NATIVE(hdr->e_shoff);
@@ -371,8 +382,10 @@ static void parse_elf(struct elf_info *i
 			= (void *)hdr + sechdrs[hdr->e_shstrndx].sh_offset;
 		const char *secname;
 
-		if (sechdrs[i].sh_offset > info->size)
-			goto truncated;
+		if (sechdrs[i].sh_offset > info->size) {
+			fatal("%s is truncated. sechdrs[i].sh_offset=%u > sizeof(*hrd)=%ul\n", filename, (unsigned int)sechdrs[i].sh_offset, sizeof(*hdr));
+			return 0;
+		}
 		secname = secstrings + sechdrs[i].sh_name;
 		if (strcmp(secname, ".modinfo") == 0) {
 			info->modinfo = (void *)hdr + sechdrs[i].sh_offset;
@@ -407,10 +420,7 @@ static void parse_elf(struct elf_info *i
 		sym->st_value = TO_NATIVE(sym->st_value);
 		sym->st_size  = TO_NATIVE(sym->st_size);
 	}
-	return;
-
- truncated:
-	fatal("%s is truncated.\n", filename);
+	return 1;
 }
 
 static void parse_elf_finish(struct elf_info *info)
@@ -1088,7 +1098,8 @@ static void read_symbols(char *modname)
 	struct elf_info info = { };
 	Elf_Sym *sym;
 
-	parse_elf(&info, modname);
+	if (!parse_elf(&info, modname))
+		return;
 
 	mod = new_module(modname);
 
