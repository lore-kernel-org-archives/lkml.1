Return-Path: <linux-kernel-owner+w=401wt.eu-S932741AbZLEBUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932741AbZLEBUq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 20:20:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932696AbZLEBUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 20:20:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40308 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932654AbZLEBUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 20:20:45 -0500
Message-ID: <4B19B53B.60605@zytor.com>
Date: Fri, 04 Dec 2009 17:19:55 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Rakib Mullick <rakib.mullick@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       "Cihula, Joseph" <joseph.cihula@intel.com>,
       Shane Wang <shane.wang@intel.com>
Subject: Re: [PATCH] x86: Put trampoline_data into readonly section.
References: <b9df5fa10912040824r4c496b54x6165523935293001@mail.gmail.com>
In-Reply-To: <b9df5fa10912040824r4c496b54x6165523935293001@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2009 08:24 AM, Rakib Mullick wrote:
> WARNING: arch/x86/kernel/built-in.o(.text+0x13c77): Section mismatch
> in reference from the function tboot_setup_sleep() to the variable
> .cpuinit.rodata:trampoline_end
> The function tboot_setup_sleep() references
> the variable __cpuinitconst trampoline_end.
> This is often because tboot_setup_sleep lacks a __cpuinitconst
> annotation or the annotation of trampoline_end is wrong.
> 
> WARNING: arch/x86/kernel/built-in.o(.text+0x13c84): Section mismatch
> in reference from the function tboot_setup_sleep() to the variable
> .cpuinit.rodata:trampoline_data
> The function tboot_setup_sleep() references
> the variable __cpuinitconst trampoline_data.
> This is often because tboot_setup_sleep lacks a __cpuinitconst
> annotation or the annotation of trampoline_data is wrong.
> 
> --- linus/arch/x86/kernel/trampoline_32.S	2009-12-04 17:17:51.000000000 +0600
> +++ rakib/arch/x86/kernel/trampoline_32.S	2009-12-04 17:24:44.000000000 +0600
> @@ -32,8 +32,13 @@
>  #include <asm/segment.h>
>  #include <asm/page_types.h>
> 
> +#ifdef CONFIG_ACPI_SLEEP
> +.section .rodata, "a", @progbits
> +#else
>  /* We can free up trampoline after bootup if cpu hotplug is not supported. */
>  __CPUINITRODATA
> +#endif
> +

This is a false positive.

The reference in question is actually:

	add_mac_region(virt_to_phys(trampoline_base), TRAMPOLINE_SIZE);

... which in turn is defined as ...

#define TRAMPOLINE_SIZE roundup(trampoline_end - trampoline_data, PAGE_SIZE)

This causes "references" of two symbols which aren't actually referenced
at all.

Perhaps the better thing would be to define trampoline_size as an
absolute symbol in arch/x86/kernel/trampoline_*.S, especially since it
probably generates bad code to subtract two global symbols like that.

	-hpa
