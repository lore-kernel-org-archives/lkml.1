Return-Path: <linux-kernel-owner+w=401wt.eu-S1757545AbYA1Wmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757545AbYA1Wmq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 17:42:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751684AbYA1Wmf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 17:42:35 -0500
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:39512 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753529AbYA1Wmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 17:42:33 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>
Content-Type: multipart/mixed; boundary="=-JiHjPXYuLp9y1rulu5lr"
Date: Mon, 28 Jan 2008 22:42:13 +0000
Message-Id: <1201560133.17053.36.camel@cthulhu.hellion.org.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
X-SA-Exim-Connect-IP: 192.168.1.223
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: PATCH/RFC: bzImage payload as compressed ELF file.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-JiHjPXYuLp9y1rulu5lr
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi Peter,

This patch switches the payload of a bzImage file to be in compressed
ELF format. There are several rough edges which need to be addressed
before it could go any further but I'd be interested to hear your
opinion of the general approach before I spend time cleaning it up.

I'm mainly interested in something along these lines to allow the Xen
bootloader to load a bzImage so that distros don't have to maintain two
kernel packages with the same basic bits in different file formats, I
think it would probably be of use to the kexec and/or lguest folks too.

The patch boots on native 32 and 64 bit x86. I haven't done the matching
Xen domain builder work but the attached bzexplode.c is a trivial/ugly
(don't judge me based on it ;-)) test app which extracts the payload,
which I have been able to boot as a 32 bit Xen domU, as you'd expect.

The payload is simply the stripped and compressed toplevel vmlinux file.
I assume that ELF program headers will be ordered by physical address
within the ELF file since this (and the general simplicity of the kernel
ELF layout) makes the ELF "parser" pretty trivial. I think the
assumption is safe because for the kernel paddr=vaddr-offset and the ELF
spec says (in book I chapter 2 "Program Header"):
        Loadable segment entries in the program header table appear in
        ascending order, sorted on the p_vaddr member.
Slightly less obvious is if the data within the ELF file is in the same
order as the program headers. I think the kernel is constrained enough
that we can guarantee this.

What would be the preferred way of allowing bootloaders/domain builders
to find the compressed payload? Tacking the offset from the end onto the
end as I have done for the moment seems pretty skanky...

Ian.

x86: switch compressed payload to ELF format.

This allows other boot loaders such as the Xen domain builder the
opportunity to extract the ELF file.

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index b7541a4..69d740b 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -90,7 +90,6 @@ KBUILD_AFLAGS += $(cfi) $(cfi-sigframe)
 KBUILD_CFLAGS += $(cfi) $(cfi-sigframe)
 
 LDFLAGS := -m elf_$(UTS_MACHINE)
-OBJCOPYFLAGS := -O binary -R .note -R .comment -S
 
 # Speed up the build
 KBUILD_CFLAGS += -pipe
diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
index 349b81a..23fddca 100644
--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -80,6 +80,7 @@ $(obj)/zImage $(obj)/bzImage: $(obj)/setup.bin \
 	$(call if_changed,image)
 	@echo 'Kernel: $@ is ready' ' (#'`cat .version`')'
 
+$(obj)/vmlinux.bin: OBJCOPYFLAGS := -O binary -R .note -R .comment -S
 $(obj)/vmlinux.bin: $(obj)/compressed/vmlinux FORCE
 	$(call if_changed,objcopy)
 
diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index fe24cea..aedea1c 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -22,6 +22,7 @@ $(obj)/vmlinux: $(src)/vmlinux_$(BITS).lds $(obj)/head_$(BITS).o $(obj)/misc.o $
 	$(call if_changed,ld)
 	@:
 
+$(obj)/vmlinux.bin: OBJCOPYFLAGS := -R .comment --strip-all
 $(obj)/vmlinux.bin: vmlinux FORCE
 	$(call if_changed,objcopy)
 
diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 8182e32..2eb8a8b 100644
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
@@ -365,6 +370,71 @@ static void error(char *x)
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
+		putstr("Not ELF... ");
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
+		switch (phdr->p_type) {
+		case PT_NULL:
+			putstr("\nIgnoring PT_NULL PHDR... ");
+			break;
+		case PT_LOAD:
+			putstr("\nProcessing PT_LOAD PHDR... ");
+			memcpy((void*)phdr->p_paddr,
+			       output + phdr->p_offset,
+			       phdr->p_filesz);
+			break;
+		case PT_DYNAMIC:
+			putstr("\nIgnoring PT_DYNAMIC PHDR... ");
+			break;
+		case PT_INTERP:
+			putstr("\nIgnoring PT_INTERP PHDR... ");
+			break;
+		case PT_NOTE:
+			putstr("\nIgnoring PT_NOTE PHDR... ");
+			break;
+		case PT_SHLIB:
+			putstr("\nIgnoring PT_SHLIB PHDR... ");
+			break;
+		case PT_PHDR:
+			putstr("\nIgnoring PT_PHDR PHDR... ");
+			break;
+		case PT_TLS:
+			putstr("\nIgnoring PT_TLS PHDR... ");
+			break;
+		default:
+			putstr("\nIgnoring unknown PHDR... ");
+		}
+	}
+}
+
 asmlinkage void decompress_kernel(void *rmode, memptr heap,
 				  uch *input_data, unsigned long input_len,
 				  uch *output)
@@ -408,6 +478,7 @@ asmlinkage void decompress_kernel(void *rmode, memptr heap,
 	makecrc();
 	putstr("\nDecompressing Linux... ");
 	gunzip();
+	parse_elf(output);
 	putstr("done.\nBooting the kernel.\n");
 	return;
 }
diff --git a/arch/x86/boot/compressed/vmlinux_32.lds b/arch/x86/boot/compressed/vmlinux_32.lds
index bb3c483..1eb2a02 100644
--- a/arch/x86/boot/compressed/vmlinux_32.lds
+++ b/arch/x86/boot/compressed/vmlinux_32.lds
@@ -40,4 +40,8 @@ SECTIONS
 		*(COMMON)
 		_end = . ;
 	}
+	.data.trailer : {
+		LONG(. - input_data + 8) payload_offset = .;
+		LONG(input_data_end - input_data) payload_length = .;
+	}
 }
diff --git a/arch/x86/boot/compressed/vmlinux_64.lds b/arch/x86/boot/compressed/vmlinux_64.lds
index f6e5b44..dcb9773 100644
--- a/arch/x86/boot/compressed/vmlinux_64.lds
+++ b/arch/x86/boot/compressed/vmlinux_64.lds
@@ -45,4 +45,8 @@ SECTIONS
 		. = . + 4096 * 6;
 		_heap = .;
 	}
+	.data.trailer : {
+		LONG(. - input_data + 8) payload_offset = .;
+		LONG(input_data_end - input_data) payload_length = .;
+	}
 }

-- 
Ian Campbell

Showing up is 80% of life.
		-- Woody Allen

--=-JiHjPXYuLp9y1rulu5lr
Content-Disposition: attachment; filename=bzexplode.c
Content-Type: text/x-csrc; name=bzexplode.c; charset=UTF-8
Content-Transfer-Encoding: 7bit

#include <stdio.h>
#include <fcntl.h>
#include <stdint.h>
#include <unistd.h>
#include <inttypes.h>

#include <err.h>

#include <sys/types.h>
#include <sys/mman.h>
#include <sys/stat.h>

#define min(x,y) (x<y?x:y)

int main(int argc, char **argv)
{
	int fd;
	off_t payload_offset = 0;
	struct stat sb;
	unsigned int len;
	off_t offset;
	int rc;
	char buf[4096];

	if (argc != 2)
		errx(1, "usage: bzexlode <bzImage>");

	fd = open(argv[1], O_RDONLY);
	if (fd < 0)
		err(1, "open");

	if (fstat(fd, &sb) < 0)
		err(1, "fstat");

	offset = lseek(fd, -8, SEEK_END);
	rc = read(fd, &payload_offset, 4);
	rc = read(fd, &len, 4);
	fprintf(stderr, "payload is at offset %zx = %zx\n",
		payload_offset, sb.st_size - payload_offset);
	fprintf(stderr, "payload len is %x\n", len);

	offset = lseek(fd, -payload_offset, SEEK_END);
	fprintf(stderr, "starting from %"PRIx64"\n", offset);

	while(len) {
		rc = read(fd, buf, min(len,sizeof(buf)));
		fprintf(stderr, "\rremaining %x %d", len, rc);
		write(1, buf, rc);
		len -= rc;
	}
	fprintf(stderr, "\n");
	return 0;
}

--=-JiHjPXYuLp9y1rulu5lr--

