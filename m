Return-Path: <linux-kernel-owner+w=401wt.eu-S1763959AbYBNSaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763959AbYBNSaa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 13:30:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755619AbYBNSaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 13:30:14 -0500
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:47346 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756033AbYBNSaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 13:30:11 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: Mark McLoughlin <markmc@redhat.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1203008490.30818.69.camel@localhost.localdomain>
References: <1202936100-30859-1-git-send-email-ijc@hellion.org.uk>
	 <9d3a007a2bfe774201b6deed5115a0cc8182bbb4.1202935389.git.ijc@hellion.org.uk>
	 <1202988844.26435.4.camel@muff>
	 <1203008490.30818.69.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 14 Feb 2008 18:29:52 +0000
Message-Id: <1203013792.30565.21.camel@cthulhu.hellion.org.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 192.168.1.223
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [PATCHv3 1/3] x86: use ELF format in compressed images.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.0 c=1 a=tnZBaFxVaJwA:10 a=qcrRp5rlbqkS0d6TfuPTVw==:17 a=ru0R4KUFSmLtfqVbv-kA:9 a=ImdWZczNlJKTZg8o6qYA:7 a=O13cPRI5FBPILApDN2rfGGV87V0A:4 a=jEp0ucaQiEUA:10 a=CY6gl2JlH4YA:10 a=KciULlu47koA:10 a=WuK_CZDBSqoA:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-02-14 at 17:01 +0000, Ian Campbell wrote:
> 
> > > +Field name:        compressed_payload_offset
> > > +Type:              read
> > > +Offset/size:       0x248/4
> > > +Protocol:  2.08+
> > > +
> > > +  If non-zero then this field contains the offset from the end of
> the
> > > +  real-mode code to the compressed payload. The compression
> format
> > > +  should be determined using the standard magic number, currently
> only
> > > +  gzip is used.
> > 
> >       Should probably mention that the payload format is expected to
> be ELF.
> 
> Agreed. Probably the same deal as the compression format, i.e. use the
> magic number but only ELF is possible today (even less likely to
> change than the compression format I guess...).

Updated with a note about ELF format payload.

I've also changed the fields to just payload_{offset,length} and
adjusted the description to allow for the possibility of non-compressed
ELF payloads. I don't have a use for it myself but I can see how it
might be useful (embedded systems?) so it seems reasonable not to rule
it out. ELF-in-gzip and plain ELF can both be identified by magic
numbers.

Ian.
--- 
>From 544c003d4067d895556180fc11a951e211202d0d Mon Sep 17 00:00:00 2001
From: Ian Campbell <ijc@hellion.org.uk>
Date: Thu, 14 Feb 2008 18:29:01 +0000
Subject: [PATCH] x86: use ELF format in compressed images.

This allows other boot loaders such as the Xen domain builder the
opportunity to extract the ELF file.

Signed-off-by: Ian Campbell <ijc@hellion.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: virtualization@lists.linux-foundation.org
---
 Documentation/i386/boot.txt       |   20 +++++++++++++
 arch/x86/boot/Makefile            |   14 +++++++++
 arch/x86/boot/compressed/Makefile |    2 +-
 arch/x86/boot/compressed/misc.c   |   56 +++++++++++++++++++++++++++++++++++++
 arch/x86/boot/header.S            |    4 ++
 5 files changed, 95 insertions(+), 1 deletions(-)

diff --git a/Documentation/i386/boot.txt b/Documentation/i386/boot.txt
index fc49b79..f2e54e5 100644
--- a/Documentation/i386/boot.txt
+++ b/Documentation/i386/boot.txt
@@ -170,6 +170,8 @@ Offset	Proto	Name		Meaning
 0238/4	2.06+	cmdline_size	Maximum size of the kernel command line
 023C/4	2.07+	hardware_subarch Hardware subarchitecture
 0240/8	2.07+	hardware_subarch_data Subarchitecture-specific data
+0248/4	2.08+	payload_offset	Offset of kernel payload
+024C/4	2.08+	payload_length	Length of kernel payload
 
 (1) For backwards compatibility, if the setup_sects field contains 0, the
     real value is 4.
@@ -512,6 +514,24 @@ Protocol:	2.07+
 
   A pointer to data that is specific to hardware subarch
 
+Field name:	payload_offset
+Type:		read
+Offset/size:	0x248/4
+Protocol:	2.08+
+
+  If non-zero then this field contains the offset from the end of the
+  real-mode code to the payload.
+
+  The payload may be compressed. The format of both the compressed and
+  uncompressed data should be determined using the standard magic
+  numbers. Currently only gzip compressed ELF is used.
+  
+Field name:	payload_length
+Type:		read
+Offset/size:	0x24c/4
+Protocol:	2.08+
+
+  The length of the payload.
 
 **** THE KERNEL COMMAND LINE
 
diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
index f88458e..9695aff 100644
--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -94,6 +94,20 @@ $(obj)/vmlinux.bin: $(obj)/compressed/vmlinux FORCE
 
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
index 8182e32..69aec2f 100644
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
@@ -365,6 +370,56 @@ static void error(char *x)
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
+	void *dest;
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
+#ifdef CONFIG_RELOCATABLE
+			dest = output;
+			dest += (phdr->p_paddr - LOAD_PHYSICAL_ADDR);
+#else
+			dest = (void*)(phdr->p_paddr);
+#endif
+			memcpy(dest,
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
@@ -408,6 +463,7 @@ asmlinkage void decompress_kernel(void *rmode, memptr heap,
 	makecrc();
 	putstr("\nDecompressing Linux... ");
 	gunzip();
+	parse_elf(output);
 	putstr("done.\nBooting the kernel.\n");
 	return;
 }
diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
index 64ad901..4085616 100644
--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -22,6 +22,7 @@
 #include <asm/page.h>
 #include <asm/setup.h>
 #include "boot.h"
+#include "offsets.h"
 
 SETUPSECTS	= 4			/* default nr of setup-sectors */
 BOOTSEG		= 0x07C0		/* original address of boot-sector */
@@ -223,6 +224,9 @@ hardware_subarch:	.long 0			# subarchitecture, added with 2.07
 
 hardware_subarch_data:	.quad 0
 
+payload_offset:		.long input_data
+payload_length:		.long input_data_end-input_data
+
 # End of setup header #####################################################
 
 	.section ".inittext", "ax"
-- 
1.5.4



-- 
Ian Campbell

The moss on the tree does not fear the talons of the hawk.

