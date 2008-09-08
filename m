Return-Path: <linux-kernel-owner+w=401wt.eu-S1753966AbYIHOyB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966AbYIHOyB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 10:54:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752235AbYIHOxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 10:53:53 -0400
Received: from el-out-1112.google.com ([209.85.162.180]:54651 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167AbYIHOxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 10:53:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=EJiggOVF16XiVaBcRy7DsYXDWsBC3EluEuMyYHa1ALyR8GQnO+KsEFjU68JaeTMWjF
         d7hXJYUXjcDf20WZYdkpSieQjmkCKaoOjJmuFr4yLq6bBCcFVP8fsmIu8wvlMHyy+wzx
         vmM7p4IC9P4uGUDgk0OTsYZEit55ex1QJIkGc=
Message-ID: <86802c440809080753u5c42d052l65c7690b45854115@mail.gmail.com>
Date: Mon, 8 Sep 2008 07:53:48 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jan Beulich" <jbeulich@novell.com>
Subject: Re: [PATCH] x86: x86_{phys,virt}_bits field also for i386 (v2)
Cc: "Ingo Molnar" <mingo@elte.hu>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, hpa@zytor.com
In-Reply-To: <48C51F8D.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48C13D1C.76E4.0078.0@novell.com> <20080905150030.GD10292@elte.hu>
	 <48C51F8D.76E4.0078.0@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 8, 2008 at 3:50 AM, Jan Beulich <jbeulich@novell.com> wrote:
>>>> Ingo Molnar <mingo@elte.hu> 05.09.08 17:00 >>>
>>
>>* Jan Beulich <jbeulich@novell.com> wrote:
>>
>>> Make the x86_{phys,virt}_bits common for 32- and 64-bits, and use the
>>> former in ioremap's phys_addr_valid() check also on 32bit/PAE.
>>>
>>> Signed-off-by: Jan Beulich <jbeulich@novell.com>
>>>
>>> ---
>>>  arch/x86/kernel/cpu/common.c |   17 +++++++++++++++++
>>>  arch/x86/mm/ioremap.c        |   15 ++++++---------
>>>  include/asm-x86/processor.h  |    4 ++--
>>>  3 files changed, 25 insertions(+), 11 deletions(-)
>>
>>hm, the cpu/common.c bits just got reworked massively in tip/master.
>>I've tried a blind merge (see the patch below) but at least the first
>>hunk looks wrong. Mind looking at how to merge this?
>
> This is my take at it:
>
> Make the x86_{phys,virt}_bits common for 32- and 64-bits, and use the
> former in ioremap's phys_addr_valid() check also on 32bit/PAE.
>
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
>
> ---
>  arch/x86/kernel/cpu/common.c |   22 +++++++++++++++++++++-
>  arch/x86/mm/ioremap.c        |   13 ++++++-------
>  include/asm-x86/processor.h  |    4 ++--
>  3 files changed, 29 insertions(+), 10 deletions(-)
>
> --- linux-x86.orig/arch/x86/kernel/cpu/common.c
> +++ linux-x86/arch/x86/kernel/cpu/common.c
> @@ -472,14 +472,20 @@ static void __cpuinit get_cpu_cap(struct
>                if (xlvl >= 0x80860001)
>                        c->x86_capability[2] = cpuid_edx(0x80860001);
>        }
> +#endif
>
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

these lines should be in early_init_intel/init_intel.
also need to be checked if it could be overwriten by others functions later..

BTW, did you address Peter's concern?

YH
