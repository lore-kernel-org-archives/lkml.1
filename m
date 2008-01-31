Return-Path: <linux-kernel-owner+w=401wt.eu-S934215AbYAaVqI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934215AbYAaVqI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 16:46:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763036AbYAaVpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 16:45:46 -0500
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:56235 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761974AbYAaVpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 16:45:44 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: linux-kernel@vger.kernel.org
Cc: Ian Campbell <ijc@hellion.org.uk>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       virtualization@lists.linux-foundation.org
Date: Thu, 31 Jan 2008 21:45:18 +0000
Message-Id: <1201815920-24669-2-git-send-email-ijc@hellion.org.uk>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <1201815920-24669-1-git-send-email-ijc@hellion.org.uk>
References: <1201815920-24669-1-git-send-email-ijc@hellion.org.uk>
X-SA-Exim-Connect-IP: 192.168.1.223
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: [PATCH] x86: use ELF format in compressed images.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows other boot loaders such as the Xen domain builder the
opportunity to extract the ELF file.

Signed-off-by: Ian Campbell <ijc@hellion.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: virtualization@lists.linux-foundation.org
---
 Documentation/i386/boot.txt       |   18 +++++++++++++
 arch/x86/boot/Makefile            |   14 ++++++++++
 arch/x86/boot/compressed/Makefile |    2 +-
 arch/x86/boot/compressed/misc.c   |   49 +++++++++++++++++++++++++++++++++++++
 arch/x86/boot/header.S            |    6 ++++
 5 files changed, 88 insertions(+), 1 deletions(-)

diff --git a/Documentation/i386/boot.txt b/Documentation/i386/boot.txt
index fc49b79..b5f5ba1 100644
--- a/Documentation/i386/boot.txt
+++ b/Documentation/i386/boot.txt
@@ -170,6 +170,8 @@ Offset	Proto	Name		Meaning
 0238/4	2.06+	cmdline_size	Maximum size of the kernel command line
 023C/4	2.07+	hardware_subarch Hardware subarchitecture
 0240/8	2.07+	hardware_subarch_data Subarchitecture-specific data
+0248/4	2.08+	compressed_payload_offset
+024C/4	2.08+	compressed_payload_length
 
 (1) For backwards compatibility, if the setup_sects field contains 0, the
     real value is 4.
@@ -512,6 +514,22 @@ Protocol:	2.07+
 
   A pointer to data that is specific to hardware subarch
 
+Field name:	compressed_payload_offset
+Type:		read
+Offset/size:	0x248/4
+Protocol:	2.08+
+
+  If non-zero then this field contains the offset from the end of the
+  real-mode code to the compressed payload. The compression format
+  should be determined using the standard magic number, currently only
+  gzip is used.
+  
+Field name:	compressed_payload_length
+Type:		read
+Offset/size:	0x24c/4
+Protocol:	2.08+
+
+  The length of the compressed payload.
 
 **** THE KERNEL COMMAND LINE
 
diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
index 254a583..0c629dc 100644
--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -86,6 +86,20 @@ $(obj)/vmlinux.bin: $(obj)/compressed/vmlinux FORCE
 
 SETUP_OBJS = $(addprefix $(obj)/,$(setup-y))
 
+sed-offsets := -e 's/^00*/0/' \
+        -e 's/^\([0-9a-fA-F]*\) . \(input_data\|input_data_end\)$$/\#define \2 0x\1/p'
+
+quiet_cmd_offsets = OFFSETS $@
+      cmd_offsets = $(NM) $< | sed -n $(sed-offsets) > $@
+
+$(obj)/offsets.h: $(obj)/compressed/vmlinux FORCE
+	$(call if_changed,offsets)
+
+targets += offsets.h
+
+AFLAGS_header.o += -I$(obj)
+$(obj)/header.o: $(obj)/offsets.h
+
 LDFLAGS_setup.elf	:= -T
 $(obj)/setup.elf: $(src)/setup.ld $(SETUP_OBJS) FORCE
 	$(call if_changed,ld)
diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index d2b9f3b..92fdd35 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -22,7 +22,7 @@ $(obj)/vmlinux: $(src)/vmlinux_$(BITS).lds $(obj)/head_$(BITS).o $(obj)/misc.o $
 	$(call if_changed,ld)
 	@:
 
-OBJCOPYFLAGS_vmlinux.bin := -O binary -R .note -R .comment -S
+OBJCOPYFLAGS_vmlinux.bin :=  -R .comment -S
 $(obj)/vmlinux.bin: vmlinux FORCE
 	$(call if_changed,objcopy)
 
diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 8182e32..8a5daf5 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -15,6 +15,10 @@
  * we just keep it from happening
  */
 #undef CONFIG_PARAVIRT
+#ifdef CONFIG_X86_32
+#define _ASM_DESC_H_ 1
+#endif
+
 #ifdef CONFIG_X86_64
 #define _LINUX_STRING_H_ 1
 #define __LINUX_BITMAP_H 1
@@ -22,6 +26,7 @@
 
 #include <linux/linkage.h>
 #include <linux/screen_info.h>
+#include <linux/elf.h>
 #include <asm/io.h>
 #include <asm/page.h>
 #include <asm/boot.h>
@@ -365,6 +370,49 @@ static void error(char *x)
 		asm("hlt");
 }
 
+static void parse_elf(void *output)
+{
+#ifdef CONFIG_X86_64
+	Elf64_Ehdr ehdr;
+	Elf64_Phdr *phdrs, *phdr;
+#else
+	Elf32_Ehdr ehdr;
+	Elf32_Phdr *phdrs, *phdr;
+#endif
+	int i;
+
+	memcpy(&ehdr, output, sizeof(ehdr));
+	if(ehdr.e_ident[EI_MAG0] != ELFMAG0 ||
+	   ehdr.e_ident[EI_MAG1] != ELFMAG1 ||
+	   ehdr.e_ident[EI_MAG2] != ELFMAG2 ||
+	   ehdr.e_ident[EI_MAG3] != ELFMAG3)
+	{
+		error("Kernel is not a valid ELF file");
+		return;
+	}
+
+	putstr("Parsing ELF... ");
+
+	phdrs = malloc(sizeof(*phdrs) * ehdr.e_phnum);
+	if (!phdrs)
+		error("Failed to allocate space for phdrs");
+
+	memcpy(phdrs, output + ehdr.e_phoff, sizeof(*phdrs) * ehdr.e_phnum);
+
+	for (i=0; i<ehdr.e_phnum; i++) {
+		phdr = &phdrs[i];
+
+		switch (phdr->p_type) {
+		case PT_LOAD:
+			memcpy((void*)phdr->p_paddr,
+			       output + phdr->p_offset,
+			       phdr->p_filesz);
+			break;
+		default: /* Ignore other PT_* */ break;
+		}
+	}
+}
+
 asmlinkage void decompress_kernel(void *rmode, memptr heap,
 				  uch *input_data, unsigned long input_len,
 				  uch *output)
@@ -408,6 +456,7 @@ asmlinkage void decompress_kernel(void *rmode, memptr heap,
 	makecrc();
 	putstr("\nDecompressing Linux... ");
 	gunzip();
+	parse_elf(output);
 	putstr("done.\nBooting the kernel.\n");
 	return;
 }
diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
index 64ad901..8471658 100644
--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -22,6 +22,7 @@
 #include <asm/page.h>
 #include <asm/setup.h>
 #include "boot.h"
+#include "offsets.h"
 
 SETUPSECTS	= 4			/* default nr of setup-sectors */
 BOOTSEG		= 0x07C0		/* original address of boot-sector */
@@ -223,6 +224,11 @@ hardware_subarch:	.long 0			# subarchitecture, added with 2.07
 
 hardware_subarch_data:	.quad 0
 
+compressed_payload_offset:
+			.long input_data
+compressed_payload_length:
+			.long input_data_end-input_data
+
 # End of setup header #####################################################
 
 	.section ".inittext", "ax"
-- 
1.5.3.8

