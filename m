Return-Path: <linux-kernel-owner+w=401wt.eu-S1755473AbYIRHwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473AbYIRHwt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 03:52:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752710AbYIRHwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 03:52:41 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:21766 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285AbYIRHwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 03:52:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Deh/VLFHnbNY7f1fuN0i+8U/UdL9qWnjkDYL9L9qzwzKVJPjlBQzcdDPLFlc6XrZuQ
         lFaLlOLjIwUnTSCUa7VQauo7Da2wQa0nYa6KKr7a+OuvPFSPscod6Mq0BrRihjSBeQYZ
         fZDwS25psk1uZjaoBBkL8RtvYlIPfZpB3tcvM=
Message-ID: <86802c440809180052g30cdb75m2cdd3209795c7390@mail.gmail.com>
Date: Thu, 18 Sep 2008 00:52:39 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jan Beulich" <jbeulich@novell.com>
Subject: Re: [PATCH] x86: x86_{phys,virt}_bits field also for i386 (v3)
Cc: "Ingo Molnar" <mingo@elte.hu>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, hpa@zytor.com
In-Reply-To: <48D21BA3.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48D21BA3.76E4.0078.0@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2008 at 12:13 AM, Jan Beulich <jbeulich@novell.com> wrote:
> Make the x86_{phys,virt}_bits common for 32- and 64-bits, and use the
> former in ioremap's phys_addr_valid() check also on 32bit/PAE.
>
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
>
> ---
>  arch/x86/kernel/cpu/common.c |   17 +++++++++++++++--
>  arch/x86/mm/ioremap.c        |   15 +++++++--------
>  include/asm-x86/processor.h  |    4 ++--
>  3 files changed, 24 insertions(+), 12 deletions(-)
>
> --- linux-tip.orig/arch/x86/kernel/cpu/common.c
> +++ linux-tip/arch/x86/kernel/cpu/common.c
> @@ -439,6 +439,11 @@ void __cpuinit cpu_detect(struct cpuinfo
>                        c->x86_cache_alignment = c->x86_clflush_size;
>                }
>        }
> +
> +#ifdef CONFIG_X86_32
> +       if (cpu_has(c, X86_FEATURE_PAE) || cpu_has(c, X86_FEATURE_PSE36))
> +               c->x86_phys_bits = 36;
> +#endif
>  }
>
>  static void __cpuinit get_cpu_cap(struct cpuinfo_x86 *c)
> @@ -464,14 +469,18 @@ static void __cpuinit get_cpu_cap(struct
>                }
>        }
>
> -#ifdef CONFIG_X86_64
>        if (c->extended_cpuid_level >= 0x80000008) {
>                u32 eax = cpuid_eax(0x80000008);
>
>                c->x86_virt_bits = (eax >> 8) & 0xff;
>                c->x86_phys_bits = eax & 0xff;
> +               /* CPUID workaround for Intel 0F33/0F34 CPU */
> +               if (c->x86_vendor == X86_VENDOR_INTEL
> +                   && c->x86 == 0xF && c->x86_model == 0x3
> +                   && (c->x86_mask == 0x3
> +                       || c->x86_mask == 0x4))
> +                       c->x86_phys_bits = 36;

please move those lines to intel.c

YH
