Return-Path: <linux-kernel-owner+w=401wt.eu-S1756788AbZCLSD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788AbZCLSD0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 14:03:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755249AbZCLSDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 14:03:09 -0400
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:56308 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755031AbZCLSDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 14:03:06 -0400
X-Greylist: delayed 1079 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Mar 2009 14:03:05 EDT
Subject: Re: [tip:x86/setup] x86: remove zImage support
From: Paul Bolle <pebolle@tiscali.nl>
To: hpa@zytor.com
Cc: linux-tip-commits@vger.kernel.org, mingo@redhat.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <tip-5e47c478b0b69bc9bc3ba544e4b1ca3268f98fef@git.kernel.org>
References: <49B703D4.1000008@zytor.com>
	 <tip-5e47c478b0b69bc9bc3ba544e4b1ca3268f98fef@git.kernel.org>
Content-Type: text/plain
Date: Thu, 12 Mar 2009 18:45:00 +0100
Message-Id: <1236879901.24144.26.camel@test.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.92 (2.25.92-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-11 at 18:06 +0000, H. Peter Anvin wrote:
>  arch/x86/boot/Makefile      |   23 +++++++--------------
>  arch/x86/boot/header.S      |   29 ++++++++-------------------
>  arch/x86/boot/pm.c          |   44 -------------------------------------------
>  arch/x86/boot/tools/build.c |    9 +-------
>  arch/x86/include/asm/boot.h |    4 ---
>  5 files changed, 18 insertions(+), 91 deletions(-)

Shouldn't the zImage target (and therefore the compressed, zlilo, and
zdisk targets) also be dropped from arch/x86/Makefile?

> diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
> index c70eff6..57a29fe 100644
> --- a/arch/x86/boot/Makefile
> +++ b/arch/x86/boot/Makefile
> @@ -6,26 +6,23 @@
>  # for more details.
>  #
>  # Copyright (C) 1994 by Linus Torvalds
> +# Changed by many, many contributors over the years.
>  #
>  
>  # ROOT_DEV specifies the default root-device when making the image.
>  # This can be either FLOPPY, CURRENT, /dev/xxxx or empty, in which case
>  # the default of FLOPPY is used by 'build'.
>  
> -ROOT_DEV := CURRENT
> +ROOT_DEV	:= CURRENT
>  
>  # If you want to preset the SVGA mode, uncomment the next line and
>  # set SVGA_MODE to whatever number you want.
>  # Set it to -DSVGA_MODE=NORMAL_VGA if you just want the EGA/VGA mode.
>  # The number is the same as you would ordinarily press at bootup.
>  
> -SVGA_MODE := -DSVGA_MODE=NORMAL_VGA
> +SVGA_MODE	:= -DSVGA_MODE=NORMAL_VGA
>  
> -# If you want the RAM disk device, define this to be the size in blocks.
> -
> -#RAMDISK := -DRAMDISK=512
> -
> -targets		:= vmlinux.bin setup.bin setup.elf zImage bzImage
> +targets		:= vmlinux.bin setup.bin setup.elf bzImage
>  subdir-		:= compressed
>  
>  setup-y		+= a20.o cmdline.o copy.o cpu.o cpucheck.o edd.o
> @@ -71,17 +68,13 @@ KBUILD_CFLAGS	:= $(LINUXINCLUDE) -g -Os -D_SETUP -D__KERNEL__ \
>  KBUILD_CFLAGS +=   $(call cc-option,-m32)
>  KBUILD_AFLAGS	:= $(KBUILD_CFLAGS) -D__ASSEMBLY__
>  
> -$(obj)/zImage:  asflags-y := $(SVGA_MODE) $(RAMDISK)
> -$(obj)/bzImage: ccflags-y := -D__BIG_KERNEL__
> -$(obj)/bzImage: asflags-y := $(SVGA_MODE) $(RAMDISK) -D__BIG_KERNEL__
> -$(obj)/bzImage: BUILDFLAGS   := -b
> +$(obj)/bzImage: asflags-y  := $(SVGA_MODE)
>  
>  quiet_cmd_image = BUILD   $@
> -cmd_image = $(obj)/tools/build $(BUILDFLAGS) $(obj)/setup.bin \
> -	    $(obj)/vmlinux.bin $(ROOT_DEV) > $@
> +cmd_image = $(obj)/tools/build $(obj)/setup.bin $(obj)/vmlinux.bin \
> +	$(ROOT_DEV) > $@
>  
> -$(obj)/zImage $(obj)/bzImage: $(obj)/setup.bin \
> -			      $(obj)/vmlinux.bin $(obj)/tools/build FORCE
> +$(obj)/bzImage: $(obj)/setup.bin $(obj)/vmlinux.bin $(obj)/tools/build FORCE
>  	$(call if_changed,image)
>  	@echo 'Kernel: $@ is ready' ' (#'`cat .version`')'

Should the zlilo and zdisk targets be renamed to bzlilo and bzdisk in
this file?
 
> diff --git a/arch/x86/boot/tools/build.c b/arch/x86/boot/tools/build.c
> index 44dc192..ee3a4ea 100644
> --- a/arch/x86/boot/tools/build.c
> +++ b/arch/x86/boot/tools/build.c
> @@ -130,7 +130,7 @@ static void die(const char * str, ...)
>  
>  static void usage(void)
>  {
> -	die("Usage: build [-b] setup system [rootdev] [> image]");
> +	die("Usage: build setup system [rootdev] [> image]");
>  }
>  
>  int main(int argc, char ** argv)
> @@ -145,11 +145,6 @@ int main(int argc, char ** argv)
>  	void *kernel;
>  	u32 crc = 0xffffffffUL;
>  
> -	if (argc > 2 && !strcmp(argv[1], "-b"))
> -	  {
> -	    is_big_kernel = 1;
> -	    argc--, argv++;
> -	  }
>  	if ((argc < 3) || (argc > 4))
>  		usage();
>  	if (argc > 3) {
> @@ -216,8 +211,6 @@ int main(int argc, char ** argv)
>  		die("Unable to mmap '%s': %m", argv[2]);
>  	/* Number of 16-byte paragraphs, including space for a 4-byte CRC */
>  	sys_size = (sz + 15 + 4) / 16;
> -	if (!is_big_kernel && sys_size > DEF_SYSSIZE)
> -		die("System is too big. Try using bzImage or modules.");
>  
>  	/* Patch the setup code with the appropriate size parameters */
>  	buf[0x1f1] = setup_sectors-1;

is_big_kernel now is unused. It can be dropped entirely, can't it?


Paul Bolle

