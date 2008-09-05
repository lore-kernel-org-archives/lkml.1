Return-Path: <linux-kernel-owner+w=401wt.eu-S1753579AbYIEQ4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579AbYIEQ4e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 12:56:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751090AbYIEQ40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 12:56:26 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:45250 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbYIEQ4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 12:56:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=juFiu6Slw6zEmVNkeNIZO1VNf0HEhgOYsexNie3EnaLFTYt699vLK/mwQ+Ts9BPbZc
         8arCDuAc6kOysO1SlBjh85sYdjINmWkDTwe7Mu9ayKhHZ06VUB85XLmWKJq9ZcszTs+b
         5tg5QEsRSXp9XQM/pZhxj+oO4Kuk09Sd/UfCI=
Message-ID: <86802c440809050956u1298f05ftb2ed813c5b10ad72@mail.gmail.com>
Date: Fri, 5 Sep 2008 09:56:23 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86: x86_{phys,virt}_bits field also for i386 (v2)
Cc: "Jan Beulich" <jbeulich@novell.com>, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080905150030.GD10292@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48C13D1C.76E4.0078.0@novell.com> <20080905150030.GD10292@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 5, 2008 at 8:00 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Jan Beulich <jbeulich@novell.com> wrote:
>
>> Make the x86_{phys,virt}_bits common for 32- and 64-bits, and use the
>> former in ioremap's phys_addr_valid() check also on 32bit/PAE.
>>
>> Signed-off-by: Jan Beulich <jbeulich@novell.com>
>>
>> ---
>>  arch/x86/kernel/cpu/common.c |   17 +++++++++++++++++
>>  arch/x86/mm/ioremap.c        |   15 ++++++---------
>>  include/asm-x86/processor.h  |    4 ++--
>>  3 files changed, 25 insertions(+), 11 deletions(-)
>
> hm, the cpu/common.c bits just got reworked massively in tip/master.
> I've tried a blind merge (see the patch below) but at least the first
> hunk looks wrong. Mind looking at how to merge this?
>
>        Ingo
>
> --------------->
> Subject: x86: x86_{phys,virt}_bits field also for i386 (v2)
> From: "Jan Beulich" <jbeulich@novell.com>
> Date: Fri, 05 Sep 2008 13:07:24 +0100
>
> Make the x86_{phys,virt}_bits common for 32- and 64-bits, and use the
> former in ioremap's phys_addr_valid() check also on 32bit/PAE.
>
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
>
> ---
>  arch/x86/kernel/cpu/common.c |   17 +++++++++++++++++
>  arch/x86/mm/ioremap.c        |   15 ++++++---------
>  include/asm-x86/processor.h  |    4 ++--
>  3 files changed, 25 insertions(+), 11 deletions(-)
>
> Index: tip/arch/x86/kernel/cpu/common.c
> ===================================================================
> --- tip.orig/arch/x86/kernel/cpu/common.c
> +++ tip/arch/x86/kernel/cpu/common.c
> @@ -464,6 +464,18 @@ static void __cpuinit get_cpu_cap(struct
>                        c->x86_capability[1] = cpuid_edx(0x80000001);
>                        c->x86_capability[6] = cpuid_ecx(0x80000001);
>                }
> +                       if (xlvl >= 0x80000008) {
> +                               u32 eax = cpuid_eax(0x80000008);
> +
> +                               c->x86_phys_bits = eax & 0xff;
> +                               c->x86_virt_bits = (eax >> 8) & 0xff;
> +                               /* CPUID workaround for Intel 0F33/0F34 CPU */
> +                               if (c->x86_vendor == X86_VENDOR_INTEL
> +                                   && c->x86 == 0xF && c->x86_model == 0x3
> +                                   && (c->x86_mask == 0x3
> +                                       || c->x86_mask == 0x4))
> +                                       c->x86_phys_bits = 36;
> +                       }
>        }
>
>  #ifdef CONFIG_X86_64

there is the same code in the same func for 64 bit.

also could move the intel workaround code to early_init_intel and init_intel of
intel.c/intel_64.c

YH
