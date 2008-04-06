Return-Path: <linux-kernel-owner+w=401wt.eu-S1753987AbYDFHDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987AbYDFHDU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 03:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751471AbYDFHDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 03:03:10 -0400
Received: from wx-out-0506.google.com ([66.249.82.225]:54180 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbYDFHDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 03:03:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CAuagqHXK9Xxj8Jxqtu13PqmbTcDuQ4s5L54D3CmEnTSYr+uMtgxsy0eGBtgXklJw68zaidmvBmHIIibPNmSFMEplFqvyggIBP/vIG8N9XHChdScsyhFxhR7ofgtdXHRJ4And5jW0i8oHvBRrAN81eThHHUXFXI3/W/ncjiR7sc=
Message-ID: <86802c440804060003q43f14122vd527514daf77cb89@mail.gmail.com>
Date: Sun, 6 Apr 2008 00:03:05 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ian Campbell" <ijc@hellion.org.uk>, "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCHv3 1/3] x86: use ELF format in compressed images.
Cc: linux-kernel@vger.kernel.org, "Thomas Gleixner" <tglx@linutronix.de>,
       "Ingo Molnar" <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       virtualization@lists.linux-foundation.org
In-Reply-To: <9d3a007a2bfe774201b6deed5115a0cc8182bbb4.1202935389.git.ijc@hellion.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1202936100-30859-1-git-send-email-ijc@hellion.org.uk>
	 <9d3a007a2bfe774201b6deed5115a0cc8182bbb4.1202935389.git.ijc@hellion.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 1:54 PM, Ian Campbell <ijc@hellion.org.uk> wrote:
> This allows other boot loaders such as the Xen domain builder the
>  opportunity to extract the ELF file.
>
>  Signed-off-by: Ian Campbell <ijc@hellion.org.uk>
>  Cc: Thomas Gleixner <tglx@linutronix.de>
>  Cc: Ingo Molnar <mingo@redhat.com>
>  Cc: H. Peter Anvin <hpa@zytor.com>
>  Cc: Jeremy Fitzhardinge <jeremy@goop.org>
>  Cc: virtualization@lists.linux-foundation.org
>  ---
>   Documentation/i386/boot.txt       |   18 ++++++++++++
>   arch/x86/boot/Makefile            |   14 +++++++++
>   arch/x86/boot/compressed/Makefile |    2 +-
>   arch/x86/boot/compressed/misc.c   |   56 +++++++++++++++++++++++++++++++++++++
>   arch/x86/boot/header.S            |    6 ++++
>   5 files changed, 95 insertions(+), 1 deletions(-)
>
>  diff --git a/Documentation/i386/boot.txt b/Documentation/i386/boot.txt
>  index fc49b79..b5f5ba1 100644
>  --- a/Documentation/i386/boot.txt
>  +++ b/Documentation/i386/boot.txt
>  @@ -170,6 +170,8 @@ Offset      Proto   Name            Meaning
>   0238/4 2.06+   cmdline_size    Maximum size of the kernel command line
>   023C/4 2.07+   hardware_subarch Hardware subarchitecture
>   0240/8 2.07+   hardware_subarch_data Subarchitecture-specific data
>  +0248/4 2.08+   compressed_payload_offset
>  +024C/4 2.08+   compressed_payload_length
>
>   (1) For backwards compatibility, if the setup_sects field contains 0, the
>      real value is 4.
>  @@ -512,6 +514,22 @@ Protocol:  2.07+
>
>    A pointer to data that is specific to hardware subarch
>
>  +Field name:    compressed_payload_offset
>  +Type:          read
>  +Offset/size:   0x248/4
>  +Protocol:      2.08+
>  +
>  +  If non-zero then this field contains the offset from the end of the
>  +  real-mode code to the compressed payload. The compression format
>  +  should be determined using the standard magic number, currently only
>  +  gzip is used.
>  +
>  +Field name:    compressed_payload_length
>  +Type:          read
>  +Offset/size:   0x24c/4
>  +Protocol:      2.08+
>  +
>  +  The length of the compressed payload.
>
>   **** THE KERNEL COMMAND LINE
>
>  diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
>  index f88458e..9695aff 100644
>  --- a/arch/x86/boot/Makefile
>  +++ b/arch/x86/boot/Makefile
>  @@ -94,6 +94,20 @@ $(obj)/vmlinux.bin: $(obj)/compressed/vmlinux FORCE
>
>   SETUP_OBJS = $(addprefix $(obj)/,$(setup-y))
>
>  +sed-offsets := -e 's/^00*/0/' \
>  +        -e 's/^\([0-9a-fA-F]*\) . \(input_data\|input_data_end\)$$/\#define \2 0x\1/p'
>  +
>  +quiet_cmd_offsets = OFFSETS $@
>  +      cmd_offsets = $(NM) $< | sed -n $(sed-offsets) > $@
>  +
>  +$(obj)/offsets.h: $(obj)/compressed/vmlinux FORCE
>  +       $(call if_changed,offsets)
>  +
>  +targets += offsets.h
>  +
>  +AFLAGS_header.o += -I$(obj)
>  +$(obj)/header.o: $(obj)/offsets.h
>  +
>   LDFLAGS_setup.elf      := -T
>   $(obj)/setup.elf: $(src)/setup.ld $(SETUP_OBJS) FORCE
>         $(call if_changed,ld)
>  diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
>  index d2b9f3b..92fdd35 100644
>  --- a/arch/x86/boot/compressed/Makefile
>  +++ b/arch/x86/boot/compressed/Makefile
>  @@ -22,7 +22,7 @@ $(obj)/vmlinux: $(src)/vmlinux_$(BITS).lds $(obj)/head_$(BITS).o $(obj)/misc.o $
>         $(call if_changed,ld)
>         @:
>
>  -OBJCOPYFLAGS_vmlinux.bin := -O binary -R .note -R .comment -S
>  +OBJCOPYFLAGS_vmlinux.bin :=  -R .comment -S
>   $(obj)/vmlinux.bin: vmlinux FORCE
>         $(call if_changed,objcopy)
>
>  diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
>  index 8182e32..69aec2f 100644
>  --- a/arch/x86/boot/compressed/misc.c
>  +++ b/arch/x86/boot/compressed/misc.c
>  @@ -15,6 +15,10 @@
>   * we just keep it from happening
>   */
>   #undef CONFIG_PARAVIRT
>  +#ifdef CONFIG_X86_32
>  +#define _ASM_DESC_H_ 1
>  +#endif
>  +
>   #ifdef CONFIG_X86_64
>   #define _LINUX_STRING_H_ 1
>   #define __LINUX_BITMAP_H 1
>  @@ -22,6 +26,7 @@
>
>   #include <linux/linkage.h>
>   #include <linux/screen_info.h>
>  +#include <linux/elf.h>
>   #include <asm/io.h>
>   #include <asm/page.h>
>   #include <asm/boot.h>
>  @@ -365,6 +370,56 @@ static void error(char *x)
>                 asm("hlt");
>   }
>
>  +static void parse_elf(void *output)
>  +{
>  +#ifdef CONFIG_X86_64
>  +       Elf64_Ehdr ehdr;
>  +       Elf64_Phdr *phdrs, *phdr;
>  +#else
>  +       Elf32_Ehdr ehdr;
>  +       Elf32_Phdr *phdrs, *phdr;
>  +#endif
>  +       void *dest;
>  +       int i;
>  +
>  +       memcpy(&ehdr, output, sizeof(ehdr));
>  +       if(ehdr.e_ident[EI_MAG0] != ELFMAG0 ||
>  +          ehdr.e_ident[EI_MAG1] != ELFMAG1 ||
>  +          ehdr.e_ident[EI_MAG2] != ELFMAG2 ||
>  +          ehdr.e_ident[EI_MAG3] != ELFMAG3)
>  +       {
>  +               error("Kernel is not a valid ELF file");
>  +               return;
>  +       }
>  +
>  +       putstr("Parsing ELF... ");
>  +
>  +       phdrs = malloc(sizeof(*phdrs) * ehdr.e_phnum);
>  +       if (!phdrs)
>  +               error("Failed to allocate space for phdrs");
>  +
>  +       memcpy(phdrs, output + ehdr.e_phoff, sizeof(*phdrs) * ehdr.e_phnum);
>  +
>  +       for (i=0; i<ehdr.e_phnum; i++) {
>  +               phdr = &phdrs[i];
>  +
>  +               switch (phdr->p_type) {
>  +               case PT_LOAD:
>  +#ifdef CONFIG_RELOCATABLE
>  +                       dest = output;
>  +                       dest += (phdr->p_paddr - LOAD_PHYSICAL_ADDR);
>  +#else
>  +                       dest = (void*)(phdr->p_paddr);
>  +#endif
>  +                       memcpy(dest,
>  +                              output + phdr->p_offset,
>  +                              phdr->p_filesz);
>  +                       break;

so will cost every bzImage extra memory copy? that could be 18M or
even more big.

wonder if can have one some other kind elf format, and offset load
address to avoid that mem copy.

YH
