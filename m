Return-Path: <linux-kernel-owner+w=401wt.eu-S1758925AbYA1Wyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758925AbYA1Wyk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 17:54:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752989AbYA1Wyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 17:54:31 -0500
Received: from gw.goop.org ([64.81.55.164]:59588 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752793AbYA1Wya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 17:54:30 -0500
Message-ID: <479E5D22.1070109@goop.org>
Date: Mon, 28 Jan 2008 14:54:26 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ian Campbell <ijc@hellion.org.uk>
CC: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: PATCH/RFC: bzImage payload as compressed ELF file.
References: <1201560133.17053.36.camel@cthulhu.hellion.org.uk>
In-Reply-To: <1201560133.17053.36.camel@cthulhu.hellion.org.uk>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/mixed;
 boundary="------------080103030202090005010400"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080103030202090005010400
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Ian Campbell wrote:
> I'm mainly interested in something along these lines to allow the Xen
> bootloader to load a bzImage so that distros don't have to maintain two
> kernel packages with the same basic bits in different file formats, I
> think it would probably be of use to the kexec and/or lguest folks too.
>
> The patch boots on native 32 and 64 bit x86. I haven't done the matching
> Xen domain builder work but the attached bzexplode.c is a trivial/ugly
> (don't judge me based on it ;-)) test app which extracts the payload,
> which I have been able to boot as a 32 bit Xen domU, as you'd expect.
>   

I've got a bzImage-loading domain builder patch somewhere.  It's based 
on my version of what you've done here, which isn't very different.

> The payload is simply the stripped and compressed toplevel vmlinux file.
> I assume that ELF program headers will be ordered by physical address
> within the ELF file since this (and the general simplicity of the kernel
> ELF layout) makes the ELF "parser" pretty trivial. I think the
> assumption is safe because for the kernel paddr=vaddr-offset and the ELF
> spec says (in book I chapter 2 "Program Header"):
>         Loadable segment entries in the program header table appear in
>         ascending order, sorted on the p_vaddr member.
> Slightly less obvious is if the data within the ELF file is in the same
> order as the program headers. I think the kernel is constrained enough
> that we can guarantee this.
>   

The problem I ran into is that 32-bit boot loaders expect to be able to 
load the payload portion of the bzImage and simply jmp 0x100000, which 
would start executing the ELF header.  Someone (Vivek Goyal?) did a 
neat/bizarre/awful hack which made the ELF header itself executable, 
which wasn't something I felt should live.

> What would be the preferred way of allowing bootloaders/domain builders
> to find the compressed payload? Tacking the offset from the end onto the
> end as I have done for the moment seems pretty skanky...
>   

The header format is extensible, so you just up the bootloader revision 
and put the appropriate extra members.

    J

> Ian.
>
> x86: switch compressed payload to ELF format.
>
> This allows other boot loaders such as the Xen domain builder the
> opportunity to extract the ELF file.
>
> diff --git a/arch/x86/Makefile b/arch/x86/Makefile
> index b7541a4..69d740b 100644
> --- a/arch/x86/Makefile
> +++ b/arch/x86/Makefile
> @@ -90,7 +90,6 @@ KBUILD_AFLAGS += $(cfi) $(cfi-sigframe)
>  KBUILD_CFLAGS += $(cfi) $(cfi-sigframe)
>  
>  LDFLAGS := -m elf_$(UTS_MACHINE)
> -OBJCOPYFLAGS := -O binary -R .note -R .comment -S
>  
>  # Speed up the build
>  KBUILD_CFLAGS += -pipe
> diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
> index 349b81a..23fddca 100644
> --- a/arch/x86/boot/Makefile
> +++ b/arch/x86/boot/Makefile
> @@ -80,6 +80,7 @@ $(obj)/zImage $(obj)/bzImage: $(obj)/setup.bin \
>  	$(call if_changed,image)
>  	@echo 'Kernel: $@ is ready' ' (#'`cat .version`')'
>  
> +$(obj)/vmlinux.bin: OBJCOPYFLAGS := -O binary -R .note -R .comment -S
>  $(obj)/vmlinux.bin: $(obj)/compressed/vmlinux FORCE
>  	$(call if_changed,objcopy)
>  
> diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
> index fe24cea..aedea1c 100644
> --- a/arch/x86/boot/compressed/Makefile
> +++ b/arch/x86/boot/compressed/Makefile
> @@ -22,6 +22,7 @@ $(obj)/vmlinux: $(src)/vmlinux_$(BITS).lds $(obj)/head_$(BITS).o $(obj)/misc.o $
>  	$(call if_changed,ld)
>  	@:
>  
> +$(obj)/vmlinux.bin: OBJCOPYFLAGS := -R .comment --strip-all
>  $(obj)/vmlinux.bin: vmlinux FORCE
>  	$(call if_changed,objcopy)
>  
> diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
> index 8182e32..2eb8a8b 100644
> --- a/arch/x86/boot/compressed/misc.c
> +++ b/arch/x86/boot/compressed/misc.c
> @@ -15,6 +15,10 @@
>   * we just keep it from happening
>   */
>  #undef CONFIG_PARAVIRT
> +#ifdef CONFIG_X86_32
> +#define _ASM_DESC_H_ 1
> +#endif
> +
>  #ifdef CONFIG_X86_64
>  #define _LINUX_STRING_H_ 1
>  #define __LINUX_BITMAP_H 1
> @@ -22,6 +26,7 @@
>  
>  #include <linux/linkage.h>
>  #include <linux/screen_info.h>
> +#include <linux/elf.h>
>  #include <asm/io.h>
>  #include <asm/page.h>
>  #include <asm/boot.h>
> @@ -365,6 +370,71 @@ static void error(char *x)
>  		asm("hlt");
>  }
>  
> +static void parse_elf(void *output)
> +{
> +#ifdef CONFIG_X86_64
> +	Elf64_Ehdr ehdr;
> +	Elf64_Phdr *phdrs, *phdr;
> +#else
> +	Elf32_Ehdr ehdr;
> +	Elf32_Phdr *phdrs, *phdr;
> +#endif
> +	int i;
> +
> +	memcpy(&ehdr, output, sizeof(ehdr));
> +	if(ehdr.e_ident[EI_MAG0] != ELFMAG0 ||
> +	   ehdr.e_ident[EI_MAG1] != ELFMAG1 ||
> +	   ehdr.e_ident[EI_MAG2] != ELFMAG2 ||
> +	   ehdr.e_ident[EI_MAG3] != ELFMAG3)
> +	{
> +		putstr("Not ELF... ");
> +		return;
> +	}
> +
> +	putstr("Parsing ELF... ");
> +
> +	phdrs = malloc(sizeof(*phdrs) * ehdr.e_phnum);
> +	if (!phdrs)
> +		error("Failed to allocate space for phdrs");
> +
> +	memcpy(phdrs, output + ehdr.e_phoff, sizeof(*phdrs) * ehdr.e_phnum);
> +
> +	for (i=0; i<ehdr.e_phnum; i++) {
> +		phdr = &phdrs[i];
> +		switch (phdr->p_type) {
> +		case PT_NULL:
> +			putstr("\nIgnoring PT_NULL PHDR... ");
> +			break;
> +		case PT_LOAD:
> +			putstr("\nProcessing PT_LOAD PHDR... ");
> +			memcpy((void*)phdr->p_paddr,
> +			       output + phdr->p_offset,
> +			       phdr->p_filesz);
> +			break;
> +		case PT_DYNAMIC:
> +			putstr("\nIgnoring PT_DYNAMIC PHDR... ");
> +			break;
> +		case PT_INTERP:
> +			putstr("\nIgnoring PT_INTERP PHDR... ");
> +			break;
> +		case PT_NOTE:
> +			putstr("\nIgnoring PT_NOTE PHDR... ");
> +			break;
> +		case PT_SHLIB:
> +			putstr("\nIgnoring PT_SHLIB PHDR... ");
> +			break;
> +		case PT_PHDR:
> +			putstr("\nIgnoring PT_PHDR PHDR... ");
> +			break;
> +		case PT_TLS:
> +			putstr("\nIgnoring PT_TLS PHDR... ");
> +			break;
> +		default:
> +			putstr("\nIgnoring unknown PHDR... ");
> +		}
> +	}
> +}
> +
>  asmlinkage void decompress_kernel(void *rmode, memptr heap,
>  				  uch *input_data, unsigned long input_len,
>  				  uch *output)
> @@ -408,6 +478,7 @@ asmlinkage void decompress_kernel(void *rmode, memptr heap,
>  	makecrc();
>  	putstr("\nDecompressing Linux... ");
>  	gunzip();
> +	parse_elf(output);
>  	putstr("done.\nBooting the kernel.\n");
>  	return;
>  }
> diff --git a/arch/x86/boot/compressed/vmlinux_32.lds b/arch/x86/boot/compressed/vmlinux_32.lds
> index bb3c483..1eb2a02 100644
> --- a/arch/x86/boot/compressed/vmlinux_32.lds
> +++ b/arch/x86/boot/compressed/vmlinux_32.lds
> @@ -40,4 +40,8 @@ SECTIONS
>  		*(COMMON)
>  		_end = . ;
>  	}
> +	.data.trailer : {
> +		LONG(. - input_data + 8) payload_offset = .;
> +		LONG(input_data_end - input_data) payload_length = .;
> +	}
>  }
> diff --git a/arch/x86/boot/compressed/vmlinux_64.lds b/arch/x86/boot/compressed/vmlinux_64.lds
> index f6e5b44..dcb9773 100644
> --- a/arch/x86/boot/compressed/vmlinux_64.lds
> +++ b/arch/x86/boot/compressed/vmlinux_64.lds
> @@ -45,4 +45,8 @@ SECTIONS
>  		. = . + 4096 * 6;
>  		_heap = .;
>  	}
> +	.data.trailer : {
> +		LONG(. - input_data + 8) payload_offset = .;
> +		LONG(input_data_end - input_data) payload_length = .;
> +	}
>  }
>
>   


--------------080103030202090005010400
Content-Type: text/x-patch;
 name="bzimage-loader.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="bzimage-loader.patch"

diff -r cbb2280c9959 tools/libxc/Makefile
--- a/tools/libxc/Makefile	Mon Jun 18 18:02:30 2007 -0700
+++ b/tools/libxc/Makefile	Tue Jun 19 02:03:13 2007 -0700
@@ -47,6 +47,7 @@ GUEST_SRCS-y += $(LIBELF_SRCS)
 # new domain builder
 GUEST_SRCS-y += xc_dom_core.c xc_dom_boot.c
 GUEST_SRCS-y += xc_dom_elfloader.c
+GUEST_SRCS-y += xc_dom_bzimageloader.c
 GUEST_SRCS-y += xc_dom_binloader.c
 GUEST_SRCS-y += xc_dom_compat_linux.c
 
diff -r cbb2280c9959 tools/libxc/bootparam.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/tools/libxc/bootparam.h	Tue Jun 19 02:03:13 2007 -0700
@@ -0,0 +1,53 @@
+#ifndef _ASM_BOOTPARAM_H
+#define _ASM_BOOTPARAM_H
+
+#include <stdint.h>
+
+#define HDR_MAGIC "HdrS"
+#define HDR_MAGIC_SZ 4
+
+struct setup_header {
+	uint8_t		setup_sects;
+	uint16_t	root_flags;
+	uint32_t	syssize;
+	uint16_t	ram_size;
+	uint16_t	vid_mode;
+	uint16_t	root_dev;
+	uint16_t	boot_flag;
+	uint16_t	jump;
+	uint32_t	header;
+	uint16_t	version;
+#define VERSION(h,l)	(((h)<<8) | (l))
+	uint32_t	realmode_swtch;
+	uint16_t	start_sys;
+	uint16_t	kernel_version;
+	uint8_t		type_of_loader;
+	uint8_t		loadflags;
+#define LOADED_HIGH	(1<<0)
+#define KEEP_SEGMENTS	(1<<6)
+#define CAN_USE_HEAP	(1<<7)
+	uint16_t	setup_move_size;
+	uint32_t	code32_start;
+	uint32_t	ramdisk_image;
+	uint32_t	ramdisk_size;
+	uint32_t	bootsect_kludge;
+	uint16_t	heap_end_ptr;
+	uint16_t	_pad1;
+	uint32_t	cmd_line_ptr;
+	uint32_t	initrd_addr_max;
+	uint32_t	kernel_alignment;
+	uint8_t		relocatable_kernel;
+	uint8_t		_pad2[3];
+	uint32_t	cmdline_size;
+	uint32_t	hardware_subarch;
+	uint64_t	hardware_subarch_data;
+} __attribute__((packed));
+
+/* The so-called "zeropage" */
+struct boot_params {
+	uint8_t	_pad0[0x1f1];		/* skip uninteresting stuff */
+	struct setup_header hdr;/* setup header */	/* 0x1f1 */
+	uint8_t  _pad7[0x1000-0x1f1-sizeof(struct setup_header)];
+} __attribute__((packed));
+
+#endif /* _ASM_BOOTPARAM_H */
diff -r cbb2280c9959 tools/libxc/xc_dom.h
--- a/tools/libxc/xc_dom.h	Mon Jun 18 18:02:30 2007 -0700
+++ b/tools/libxc/xc_dom.h	Tue Jun 19 02:03:13 2007 -0700
@@ -55,6 +55,7 @@ struct xc_dom_image {
     xen_pfn_t xenstore_pfn;
     xen_pfn_t shared_info_pfn;
     xen_pfn_t bootstack_pfn;
+    xen_pfn_t bootparams_pfn;
     xen_vaddr_t virt_alloc_end;
     xen_vaddr_t bsd_symtab_start;
 
@@ -254,6 +255,8 @@ static inline xen_pfn_t xc_dom_p2m_guest
     return dom->p2m_host[pfn];
 }
 
+char *xc_dom_guest_type(struct xc_dom_image *dom,
+                        struct elf_binary *elf);
 /* --- arch bits --------------------------------------------------- */
 
 int arch_setup_meminit(struct xc_dom_image *dom);
diff -r cbb2280c9959 tools/libxc/xc_dom_bzimageloader.c
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/tools/libxc/xc_dom_bzimageloader.c	Tue Jun 19 02:03:13 2007 -0700
@@ -0,0 +1,164 @@
+/*
+ * Xen domain builder -- bzImage bits
+ *
+ * Parse and load bzImage kernel images.
+ *
+ * This relies on version 2.07 of the boot protocol, which an ELF file
+ * embedded in the bzImage.  The loader extracts the boot_params from
+ * the bzImage and updates it appropriately, then loads and runs the
+ * self-extracting kernel ELF file.
+ *
+ * This code is licenced under the GPL.
+ * written 2006 by Gerd Hoffmann <kraxel@suse.de>.
+ * written 2007 by Jeremy Fitzhardinge <jeremy@xensource.com>
+ *
+ */
+#include <stdio.h>
+#include <stdlib.h>
+#include <inttypes.h>
+
+#include "xg_private.h"
+#include "xc_dom.h"
+#include "bootparam.h"
+
+#define XEN_VER "xen-3.0"
+
+static unsigned elf_offset(struct boot_params *params)
+{
+    return (params->hdr.setup_sects + 1) * 512;
+}
+
+static int check_bzimage_kernel(struct xc_dom_image *dom, int verbose)
+{
+    struct boot_params *params;
+    const char *elf;
+
+    if ( dom->kernel_blob == NULL || dom->kernel_size < 512*8)
+    {
+        if ( verbose )
+            xc_dom_panic(XC_INTERNAL_ERROR, "%s: no kernel image loaded\n",
+                         __FUNCTION__);
+        return -EINVAL;
+    }
+
+    params = dom->kernel_blob;
+
+    if ( memcmp(&params->hdr.header, HDR_MAGIC, HDR_MAGIC_SZ) != 0 )
+    {
+        if ( verbose )
+            xc_dom_panic(XC_INVALID_KERNEL, "%s: kernel is not a bzImage\n",
+                         __FUNCTION__);
+        return -EINVAL;
+    }
+
+    if ( params->hdr.version < VERSION(2,07) )
+    {
+        if ( verbose )
+            xc_dom_panic(XC_INVALID_KERNEL, "%s: boot protocol too old (%04x)\n",
+                         __FUNCTION__, params->hdr.version);
+        return -EINVAL;
+    }
+
+    elf = dom->kernel_blob + elf_offset(params);
+    if ( !elf_is_elfbinary(elf) )
+    {
+        if ( verbose )
+            xc_dom_panic(XC_INVALID_KERNEL, "%s: bzImage does not contain ELF image\n",
+                         __FUNCTION__);
+        return -EINVAL;
+    }
+
+    return 0;
+}
+
+static int xc_dom_probe_bzimage_kernel(struct xc_dom_image *dom)
+{
+    return check_bzimage_kernel(dom, 0);
+}
+
+static int xc_dom_parse_bzimage_kernel(struct xc_dom_image *dom)
+{
+    int rc;
+    struct boot_params *params;
+    struct elf_binary *elf;
+    unsigned offset;
+
+    rc = check_bzimage_kernel(dom, 1);
+    if ( rc != 0 )
+        return rc;
+
+    params = dom->kernel_blob;
+    offset = elf_offset(params);
+
+    elf = xc_dom_malloc(dom, sizeof(*elf));
+    dom->private_loader = elf;
+
+    rc = elf_init(elf, dom->kernel_blob + offset, dom->kernel_size - offset);
+    if ( xc_dom_logfile )
+        elf_set_logfile(elf, xc_dom_logfile, 1);
+    if ( rc != 0 )
+    {
+        xc_dom_panic(XC_INVALID_KERNEL, "%s: corrupted ELF image\n",
+                     __FUNCTION__);
+        return rc;
+    }
+
+    /* parse binary and get xen meta info */
+    elf_parse_binary(elf);
+    if ( (rc = elf_xen_parse(elf, &dom->parms)) != 0 )
+        return rc;
+
+    /* find kernel segment */
+    dom->kernel_seg.vstart = dom->parms.virt_kstart;
+    dom->kernel_seg.vend   = dom->parms.virt_kend;
+
+    dom->guest_type = xc_dom_guest_type(dom, elf);
+    xc_dom_printf("%s: %s: 0x%" PRIx64 " -> 0x%" PRIx64 "\n",
+                  __FUNCTION__, dom->guest_type,
+                  dom->kernel_seg.vstart, dom->kernel_seg.vend);
+    return 0;
+}
+
+static int xc_dom_load_bzimage_kernel(struct xc_dom_image *dom)
+{
+    struct elf_binary *elf = dom->private_loader;
+    xen_pfn_t bootparams_pfn;
+    struct boot_params *bzparams, *bootparams;
+
+    bzparams = dom->kernel_blob;
+
+    elf->dest = xc_dom_seg_to_ptr(dom, &dom->kernel_seg);
+    elf_load_binary(elf);
+
+    bootparams_pfn = xc_dom_alloc_page(dom, "bootparams");
+    bootparams = xc_dom_pfn_to_ptr(dom, bootparams_pfn, 1);
+    memset(bootparams, 0, sizeof(*bootparams));
+
+    memcpy(&bootparams->hdr, &bzparams->hdr, sizeof(bootparams->hdr));
+
+    dom->bootparams_pfn = bootparams_pfn;
+
+    return 0;
+}
+
+static struct xc_dom_loader bzimage_loader = {
+    .name = "bzImage",
+    .probe = xc_dom_probe_bzimage_kernel,
+    .parser = xc_dom_parse_bzimage_kernel,
+    .loader = xc_dom_load_bzimage_kernel,
+};
+
+static void __init register_loader(void)
+{
+    xc_dom_register_loader(&bzimage_loader);
+}
+
+/*
+ * Local variables:
+ * mode: C
+ * c-set-style: "BSD"
+ * c-basic-offset: 4
+ * tab-width: 4
+ * indent-tabs-mode: nil
+ * End:
+ */
diff -r cbb2280c9959 tools/libxc/xc_dom_elfloader.c
--- a/tools/libxc/xc_dom_elfloader.c	Mon Jun 18 18:02:30 2007 -0700
+++ b/tools/libxc/xc_dom_elfloader.c	Tue Jun 19 02:03:13 2007 -0700
@@ -18,8 +18,8 @@
 
 /* ------------------------------------------------------------------------ */
 
-static char *xc_dom_guest_type(struct xc_dom_image *dom,
-                               struct elf_binary *elf)
+char *xc_dom_guest_type(struct xc_dom_image *dom,
+                        struct elf_binary *elf)
 {
     uint64_t machine = elf_uval(elf, elf->ehdr, e_machine);
 
diff -r cbb2280c9959 tools/libxc/xc_dom_x86.c
--- a/tools/libxc/xc_dom_x86.c	Mon Jun 18 18:02:30 2007 -0700
+++ b/tools/libxc/xc_dom_x86.c	Tue Jun 19 02:03:13 2007 -0700
@@ -23,6 +23,7 @@
 #include "xg_private.h"
 #include "xc_dom.h"
 #include "xenctrl.h"
+#include "bootparam.h"
 
 /* ------------------------------------------------------------------------ */
 
@@ -407,6 +408,36 @@ static int alloc_magic_pages(struct xc_d
 
 /* ------------------------------------------------------------------------ */
 
+static unsigned long guest_pfn_addr(struct xc_dom_image *dom, xen_pfn_t pfn,
+                                    size_t offset)
+{
+    return dom->parms.virt_base + pfn * PAGE_SIZE_X86 + offset;
+}
+
+static void setup_boot_params(struct xc_dom_image *dom)
+{
+    struct boot_params *params =
+        xc_dom_pfn_to_ptr(dom, dom->bootparams_pfn, 1);
+
+    params->hdr.type_of_loader = (9 << 4) | 0;  /* xen v0 */
+    params->hdr.loadflags |= LOADED_HIGH | KEEP_SEGMENTS;
+
+    params->hdr.hardware_subarch = 2;  /* xen */
+    params->hdr.hardware_subarch_data =
+        (uint64_t)guest_pfn_addr(dom, dom->start_info_pfn, 0);
+
+    if ( dom->ramdisk_blob )
+    {
+        params->hdr.ramdisk_image = (uint32_t)dom->ramdisk_seg.vstart;
+        params->hdr.ramdisk_size = dom->ramdisk_seg.vend - dom->ramdisk_seg.vstart;
+    }
+
+    params->hdr.cmd_line_ptr =
+        guest_pfn_addr(dom, dom->start_info_pfn,
+                       offsetof(start_info_x86_32_t, cmd_line));
+    params->hdr.cmdline_size = MAX_GUEST_CMDLINE;
+}
+
 static int start_info_x86_32(struct xc_dom_image *dom)
 {
     start_info_x86_32_t *start_info =
@@ -440,6 +471,12 @@ static int start_info_x86_32(struct xc_d
     {
         strncpy((char *)start_info->cmd_line, dom->cmdline, MAX_GUEST_CMDLINE);
         start_info->cmd_line[MAX_GUEST_CMDLINE - 1] = '\0';
+    }
+
+    if ( dom->bootparams_pfn != 0 )
+    {
+        setup_boot_params(dom);
+        dom->start_info_pfn = dom->bootparams_pfn;
     }
 
     return 0;
@@ -528,10 +565,8 @@ static int vcpu_x86_32(struct xc_dom_ima
     ctxt->user_regs.ss = FLAT_KERNEL_SS_X86_32;
     ctxt->user_regs.cs = FLAT_KERNEL_CS_X86_32;
     ctxt->user_regs.eip = dom->parms.virt_entry;
-    ctxt->user_regs.esp =
-        dom->parms.virt_base + (dom->bootstack_pfn + 1) * PAGE_SIZE_X86;
-    ctxt->user_regs.esi =
-        dom->parms.virt_base + (dom->start_info_pfn) * PAGE_SIZE_X86;
+    ctxt->user_regs.esp = guest_pfn_addr(dom, dom->bootstack_pfn, PAGE_SIZE_X86);
+    ctxt->user_regs.esi = guest_pfn_addr(dom, dom->start_info_pfn, 0);
     ctxt->user_regs.eflags = 1 << 9; /* Interrupt Enable */
 
     ctxt->kernel_ss = ctxt->user_regs.ss;

--------------080103030202090005010400--
