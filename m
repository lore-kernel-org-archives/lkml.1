Return-Path: <linux-kernel-owner+w=401wt.eu-S1757170AbZFZHWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757170AbZFZHWe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 03:22:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752081AbZFZHW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 03:22:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51634 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751334AbZFZHW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 03:22:26 -0400
Date: Fri, 26 Jun 2009 09:22:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH 2/9] x86: introduce a set of platform feature flags
Message-ID: <20090626072218.GH14078@elte.hu>
References: <43F901BD926A4E43B106BF17856F07556412B7E1@orsmsx508.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43F901BD926A4E43B106BF17856F07556412B7E1@orsmsx508.amr.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pan, Jacob jun <jacob.jun.pan@intel.com> wrote:

> >From 41685ae1e8b8e77fdacbdf8e8155f1e54624cbef Mon Sep 17 00:00:00 2001
> From: Jacob Pan <jacob.jun.pan@intel.com>
> Date: Thu, 11 Jun 2009 09:37:26 -0700
> Subject: [PATCH] x86: introduce a set of platform feature flags
> 
> This patch introduces a set of x86 pc platform feature flags. the intention is
> to clean up setup code based on the availability of patform features.
> 
> With the introduction of non-PC x86 platforms, these flags will also pave
> the way for cleaner integration.
> 
> The current feature flags are not a complete set of all possible PC features
> only the ones relavent to system setup, such as resource allocation, are
> included.
> 
> Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
> ---
>  arch/x86/include/asm/platform_feature.h |   65 ++++++++++++++++++
>  arch/x86/kernel/.gitignore              |    1 +
>  arch/x86/kernel/Makefile                |   11 +++
>  arch/x86/kernel/mkx86pcflags.pl         |   32 +++++++++
>  arch/x86/kernel/platform_info.c         |  111 +++++++++++++++++++++++++++++++
>  5 files changed, 220 insertions(+), 0 deletions(-)
>  create mode 100644 arch/x86/include/asm/platform_feature.h
>  create mode 100644 arch/x86/kernel/mkx86pcflags.pl
>  create mode 100644 arch/x86/kernel/platform_info.c
> 
> diff --git a/arch/x86/include/asm/platform_feature.h b/arch/x86/include/asm/platform_feature.h
> new file mode 100644
> index 0000000..bcadda5
> --- /dev/null
> +++ b/arch/x86/include/asm/platform_feature.h
> @@ -0,0 +1,65 @@
> +/*
> + * platform_feature.h - Defines x86 platform feature bits
> + *
> + * (C) Copyright 2008 Intel Corporation
> + * Author: Jacob Pan (jacob.jun.pan@intel.com)
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; version 2
> + * of the License.
> + *
> + * Note: platform feature flags allow kernel to identify hardware capabilities
> + * at boottime and runtime. It enables binary compaitiblity between standard
> + * X86 PC and non-standard X86 platforms such as MID. These flags are default
> + * to X86 PC standard, at boot time, they will be overwritten by system tables
> + * provided by firmware.
> + *
> + */
> +#ifndef _ASM_X86_PLATFORM_FEATURE_H
> +#define _ASM_X86_PLATFORM_FEATURE_H
> +
> +#ifndef __ASSEMBLY__
> +#include <linux/bitops.h>
> +#endif
> +#include <asm/required-features.h>
> +
> +#define N_PLATFORM_CAPINTS	2	/* N 32-bit words worth of info */
> +/* X86 base platform features, include PC, legacy free MID devices, etc.
> + * This list provides early and important information to the kernel in a
> + * centralized place such that kernel can make a decision on the best
> + * choice of which system devices to use. e.g. timers or interrupt
> + * controllers.
> + */
> +#define X86_PLATFORM_FEATURE_8259		(0*32+0) /* i8259A PIC */
> +#define X86_PLATFORM_FEATURE_8254		(0*32+1) /* i8253/4 PIT */
> +#define X86_PLATFORM_FEATURE_IOAPIC		(0*32+2) /* IO-APIC */
> +#define X86_PLATFORM_FEATURE_HPET		(0*32+3) /* HPET timer */
> +#define X86_PLATFORM_FEATURE_RTC		(0*32+4) /* real time clock*/
> +#define X86_PLATFORM_FEATURE_FLOPPY		(0*32+5) /* ISA floppy */
> +#define X86_PLATFORM_FEATURE_ISA		(0*32+6) /* ISA/LPC bus */
> +#define X86_PLATFORM_FEATURE_BIOS		(0*32+7) /* BIOS service,
> +							   *  e.g. int calls
> +							   *  EBDA, etc.
> +							   */
> +#define X86_PLATFORM_FEATURE_ACPI		(0*32+8) /* has ACPI support */
> +#define X86_PLATFORM_FEATURE_SFI		(0*32+9) /* has SFI support */
> +#define X86_PLATFORM_FEATURE_8042		(0*32+10) /* i8042 KBC */

i think a better and cleaner approach would be to 'driverize' the 
affected platform details - not sprinkle the code with 
platform_has() calls.

Whether a given platform has a 'standard PC' or some custom driver 
then depends on that driver's init sequence - it's not a central 
thing.

	Ingo
