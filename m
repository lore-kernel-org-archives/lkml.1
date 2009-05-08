Return-Path: <linux-kernel-owner+w=401wt.eu-S1760972AbZEHHxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760972AbZEHHxT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 03:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757028AbZEHHxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 03:53:07 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:52106 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755630AbZEHHxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 03:53:05 -0400
Date: Fri, 8 May 2009 09:55:16 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, vgoyal@redhat.com, hbabu@us.ibm.com,
       kexec@lists.infradead.org, ying.huang@intel.com, mingo@elte.hu,
       tglx@linutronix.de, ebiederm@xmission.com,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 09/14] x86, boot: add new runtime_address and runtime_size bzImage fields
Message-ID: <20090508075516.GF12808@uranus.ravnborg.org>
References: <1241735222-6640-1-git-send-email-hpa@linux.intel.com> <1241735222-6640-10-git-send-email-hpa@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241735222-6640-10-git-send-email-hpa@linux.intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 07, 2009 at 03:26:57PM -0700, H. Peter Anvin wrote:
> From: H. Peter Anvin <hpa@zytor.com>
> 
> Make the (minimum) runtime address and the required amount of linear
> address space available to the boot loader.  A relocating boot loader
> can use this information to select a kernel location; furthermore, it
> is permitted to modify the minimum runtime address field in order for
> the boot loader to force a specific location for the kernel (as long
> as it fits the alignment constraints.)
> 
> This means that the address space layout for the kernel compressor has
> to be determined at compile time.  Since we have to do that, we might
> as well reap the benefit and remove some runtime calculations in
> assembly.
> 
> Note: bounding the amount of linear address space (not necessarily
> bounding the amount of memory needed, but the amount that has to be
> linearly contiguous before the memory map is consulted) was only
> possible since Jeremy Fitzhardinge's brk support work.
> 
> [ Impact: new feature; simplication of compressed/head_*.S ]
> 
> Signed-off-by: H. Peter Anvin <hpa@zytor.com>
> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> ---
>  arch/x86/boot/Makefile               |   24 ++++++---
>  arch/x86/boot/compressed/Makefile    |   14 ++++--
>  arch/x86/boot/compressed/head_32.S   |   54 ++++++-------------
>  arch/x86/boot/compressed/head_64.S   |   52 +++++-------------
>  arch/x86/boot/compressed/mkpiggy.c   |   97 ++++++++++++++++++++++++++++++++++
>  arch/x86/boot/compressed/vmlinux.scr |   10 ----
>  arch/x86/boot/header.S               |   19 +++++--
>  arch/x86/include/asm/bootparam.h     |    2 +
>  arch/x86/kernel/asm-offsets_32.c     |    1 +
>  arch/x86/kernel/asm-offsets_64.c     |    1 +
>  10 files changed, 173 insertions(+), 101 deletions(-)
>  create mode 100644 arch/x86/boot/compressed/mkpiggy.c
>  delete mode 100644 arch/x86/boot/compressed/vmlinux.scr
> 
> diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
> index 6633b6e..3332d22 100644
> --- a/arch/x86/boot/Makefile
> +++ b/arch/x86/boot/Makefile
> @@ -86,19 +86,27 @@ $(obj)/vmlinux.bin: $(obj)/compressed/vmlinux FORCE
>  
>  SETUP_OBJS = $(addprefix $(obj)/,$(setup-y))
>  
> -sed-offsets := -e 's/^00*/0/' \
> -        -e 's/^\([0-9a-fA-F]*\) . \(input_data\|input_data_end\)$$/\#define \2 0x\1/p'
> +sed-voffset := -e 's/^\([0-9a-fA-F]*\) . \(_text\|_end\)$$/\#define VO_\2 0x\1/p'
>  
> -quiet_cmd_offsets = OFFSETS $@
> -      cmd_offsets = $(NM) $< | sed -n $(sed-offsets) > $@
> +quiet_cmd_voffset = VOFFSET $@
> +      cmd_voffset = $(NM) $< | sed -n $(sed-voffset) > $@
>  
> -$(obj)/offsets.h: $(obj)/compressed/vmlinux FORCE
> -	$(call if_changed,offsets)
> +targets += voffset.h
> +$(obj)/voffset.h: vmlinux FORCE
> +	$(call if_changed,voffset)
> +
> +sed-zoffset := -e 's/^\([0-9a-fA-F]*\) . \(input_data\|_ebss\|z_.*\)$$/\#define ZO_\2 0x\1/p'
> +
> +quiet_cmd_zoffset = ZOFFSET $@
> +      cmd_zoffset = $(NM) $< | sed -n $(sed-zoffset) > $@
> +
> +targets += zoffset.h
> +$(obj)/zoffset.h: $(obj)/compressed/vmlinux FORCE
> +	$(call if_changed,zoffset)
>  
> -targets += offsets.h
>  
>  AFLAGS_header.o += -I$(obj)
> -$(obj)/header.o: $(obj)/offsets.h
> +$(obj)/header.o: $(obj)/voffset.h $(obj)/zoffset.h
>  
>  LDFLAGS_setup.elf	:= -T
>  $(obj)/setup.elf: $(src)/setup.ld $(SETUP_OBJS) FORCE
> diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
> index b35c3bb..6f4d7ba 100644
> --- a/arch/x86/boot/compressed/Makefile
> +++ b/arch/x86/boot/compressed/Makefile
> @@ -4,7 +4,8 @@
>  # create a compressed vmlinux image from the original vmlinux
>  #
>  
> -targets := vmlinux vmlinux.bin vmlinux.bin.gz vmlinux.bin.bz2 vmlinux.bin.lzma head_$(BITS).o misc.o piggy.o
> +targets := vmlinux vmlinux.bin vmlinux.bin.gz vmlinux.bin.bz2 \
> +	   vmlinux.bin.lzma head_$(BITS).o misc.o

You still have a piggy.o target.

>  
>  KBUILD_CFLAGS := -m$(BITS) -D__KERNEL__ $(LINUX_INCLUDE) -O2
>  KBUILD_CFLAGS += -fno-strict-aliasing -fPIC
> @@ -19,6 +20,8 @@ KBUILD_AFLAGS  := $(KBUILD_CFLAGS) -D__ASSEMBLY__
>  LDFLAGS := -m elf_$(UTS_MACHINE)
>  LDFLAGS_vmlinux := -T
>  
> +hostprogs-y	:= mkpiggy
> +
>  $(obj)/vmlinux: $(obj)/vmlinux.lds $(obj)/head_$(BITS).o $(obj)/misc.o $(obj)/piggy.o FORCE
>  	$(call if_changed,ld)
>  	@:
> @@ -50,6 +53,9 @@ suffix_$(CONFIG_KERNEL_GZIP)  = gz
>  suffix_$(CONFIG_KERNEL_BZIP2) = bz2
>  suffix_$(CONFIG_KERNEL_LZMA)  = lzma

No need for a recursive assignment here. Use ":="
Ann we usually uses "-y" not "_y".

>  
> -LDFLAGS_piggy.o := -r --format binary --oformat $(CONFIG_OUTPUT_FORMAT) -T
> -$(obj)/piggy.o: $(obj)/vmlinux.scr $(obj)/vmlinux.bin.$(suffix_y) FORCE
> -	$(call if_changed,ld)
> +quiet_cmd_mkpiggy = MKPIGGY $@
> +      cmd_mkpiggy = $(obj)/mkpiggy $< > $@


> +      cmd_mkpiggy = $(obj)/mkpiggy $< > $@ || (rm -f $@; false)

So we delete the file on error.

> +
> +targets += piggy.S
> +$(obj)/piggy.S: $(obj)/vmlinux.bin.$(suffix_y) $(obj)/mkpiggy FORCE
> +	$(call if_changed,mkpiggy)


	Sam  
