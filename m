Return-Path: <linux-kernel-owner+w=401wt.eu-S1758238AbYDTKeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758238AbYDTKeq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 06:34:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754417AbYDTKei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 06:34:38 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:62656 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715AbYDTKeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 06:34:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RYG4P6bWiRIB7WrffcAIGlnqtiHNzuOyi0RgS3OZIkvVC7KrbiDd9YddNm1RZkzcGcW2bTLKUE40eF1UEis4CmAaY4jDBXQIOgaTlQGNTcecG5lzVjvWZj+ICdieHixZyOh1Lj2/zR8LEYUZuYl+iYWQIjPdBuNfp0k+Mpqisik=
Message-ID: <86802c440804200334t5cdcd100rfc41e9b1bf379109@mail.gmail.com>
Date: Sun, 20 Apr 2008 03:34:37 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andres Salomon" <dilinger@queued.net>, "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 1/2] OLPC: Add support for calling into Open Firmware
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Joseph Fannin" <jfannin@gmail.com>, linux-kernel@vger.kernel.org,
       jordan.crouse@amd.com, "Mitch Bradley" <wmb@firmworks.com>
In-Reply-To: <20080419133909.5aa6b63e@ephemeral>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080418014757.52fb4a4f.akpm@linux-foundation.org>
	 <20080419031024.GC3503@nineveh.local>
	 <20080418202925.b18452c5.akpm@linux-foundation.org>
	 <20080419092544.378664a8@ephemeral>
	 <20080419133909.5aa6b63e@ephemeral>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 19, 2008 at 10:39 AM, Andres Salomon <dilinger@queued.net> wrote:
>
>  This adds 32-bit support for calling into OFW from the kernel.  It's useful
>  for querying the firmware for misc hardware information, fetching the device
>  tree, etc.
>
>  There's potentially no reason why other platforms couldn't use this, but
>  currently OLPC is the main user of it.
>
>  This work was originally done by Mitch Bradley.
>
>  Signed-off-by: Andres Salomon <dilinger@debian.org>
>  ---
>   arch/x86/Kconfig          |    8 +++++
>   arch/x86/kernel/Makefile  |    1 +
>   arch/x86/kernel/head_32.S |   27 ++++++++++++++++
>   arch/x86/kernel/ofw.c     |   75 +++++++++++++++++++++++++++++++++++++++++++++
>   include/asm-x86/ofw.h     |   50 ++++++++++++++++++++++++++++++
>   include/asm-x86/setup.h   |    1 +
>   6 files changed, 162 insertions(+), 0 deletions(-)
>   create mode 100644 arch/x86/kernel/ofw.c
>   create mode 100644 include/asm-x86/ofw.h
>
>  diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>  index 3b9089b..ce56105 100644
>  --- a/arch/x86/Kconfig
>  +++ b/arch/x86/Kconfig
>  @@ -661,6 +661,14 @@ config I8K
>           Say Y if you intend to run this kernel on a Dell Inspiron 8000.
>           Say N otherwise.
>
>  +config OPEN_FIRMWARE
>  +       bool "Support for Open Firmware"
>  +       default y if OLPC
>  +       ---help---
>  +         This option adds support for the implementation of Open Firmware
>  +         that is used on the OLPC XO laptop.
>  +         If unsure, say N here.
>  +
>   config X86_REBOOTFIXUPS
>         def_bool n
>         prompt "Enable X86 board specific fixups for reboot"
>  diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
>  index 9575754..d33600e 100644
>  --- a/arch/x86/kernel/Makefile
>  +++ b/arch/x86/kernel/Makefile
>  @@ -54,6 +54,7 @@ obj-$(CONFIG_X86_TRAMPOLINE)  += trampoline_$(BITS).o
>   obj-$(CONFIG_X86_MPPARSE)      += mpparse_$(BITS).o
>   obj-$(CONFIG_X86_LOCAL_APIC)   += apic_$(BITS).o nmi_$(BITS).o
>   obj-$(CONFIG_X86_IO_APIC)      += io_apic_$(BITS).o
>  +obj-$(CONFIG_OPEN_FIRMWARE)    += ofw.o
>   obj-$(CONFIG_X86_REBOOTFIXUPS) += reboot_fixups_32.o
>   obj-$(CONFIG_KEXEC)            += machine_kexec_$(BITS).o
>   obj-$(CONFIG_KEXEC)            += relocate_kernel_$(BITS).o crash.o
>  diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
>  index 74d87ea..c9d2d00 100644
>  --- a/arch/x86/kernel/head_32.S
>  +++ b/arch/x86/kernel/head_32.S
>  @@ -132,6 +132,33 @@ ENTRY(startup_32)
>         movsl
>   1:
>
>  +#ifdef CONFIG_OPEN_FIRMWARE
>  +/*
>  + * If Open Firmware booted us, save the OFW client interface callback address
>  + * and preserve the OFW page mappings by priming the kernel's new page
>  + * directory area with a copy of the OFW page directory.  That lets OFW stay
>  + * resident in high memory (high in both the virtual and physical spaces)
>  + * for at least long enough to copy out the device tree.
>  + */
>  +       movl $pa(boot_params + OFW_INFO_OFFSET), %ebp
>  +       cmpl $0x2057464F, (%ebp)                /* Magic number "OFW " */
>  +       jne 4f
>  +
>  +       mov 0x8(%ebp), %eax                     /* Save callback address */
>  +       mov %eax, pa(call_firmware)
>  +
>  +       /* Copy the OFW pdir into swapper_pg_dir */
>  +       movl %esi, %edx         /* save %esi */
>  +       movl $pa(swapper_pg_dir), %edi
>  +       movl %cr3, %esi         /* Source is current pg_dir base address */
>  +       movl $1024, %ecx        /* Number of page directory entries */
>  +       rep
>  +       movsl
>  +       movl %edx, %esi         /* restore %esi */
>  +4:
>  +
>  +#endif
>  +
>   #ifdef CONFIG_PARAVIRT
>         /* This is can only trip for a broken bootloader... */
>         cmpw $0x207, pa(boot_params + BP_version)
>  diff --git a/arch/x86/kernel/ofw.c b/arch/x86/kernel/ofw.c
>  new file mode 100644
>  index 0000000..14036aa
>  --- /dev/null
>  +++ b/arch/x86/kernel/ofw.c
>  @@ -0,0 +1,75 @@
>  +/*
>  + * Open Firmware client interface for 32-bit systems.
>  + *
>  + * Copyright (c) 2007  Mitch Bradley <wmb@firmworks.com>
>  + * Copyright (c) 2007-2008  Andres Salomon <dilinger@debian.org>
>  + *
>  + * This program is free software; you can redistribute it and/or modify
>  + * it under the terms of the GNU General Public License as published by
>  + * the Free Software Foundation; either version 2 of the License, or
>  + * (at your option) any later version.
>  + */
>  +
>  +#include <linux/kernel.h>
>  +#include <linux/spinlock.h>
>  +#include <linux/module.h>
>  +#include <asm/ofw.h>
>  +
>  +/*
>  + * This code is intended to be portable to any 32-bit Open Firmware
>  + * implementation with a standard client interface that can be
>  + * called when Linux is running.

how about changing to ofw_32.c?

YH
