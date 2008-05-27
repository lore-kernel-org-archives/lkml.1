Return-Path: <linux-kernel-owner+w=401wt.eu-S1759026AbYE0VGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759026AbYE0VGR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 17:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757006AbYE0VGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 17:06:06 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:22473 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756505AbYE0VGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 17:06:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ncyE1g65HTLi04vq89h8+gNecEKOiTcnl0lJ8FedEtchowzz9Sz63DqsR2AyPnHHw5lME90qL+t5NMeG09xc7uxkHCHHqZnnnynMMH4HyCmoFZEIPfQel+WGaRiFYLhWSuTvXWLhLHXGeA+X/z+RuGmOFNeJ+GfCvilXEq6gYH8=
Message-ID: <86802c440805271406l4348db33r5622c440b494baa2@mail.gmail.com>
Date: Tue, 27 May 2008 14:06:04 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: [PATCH] x86: extend e820 ealy_res support 32bit - fix #2
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <483C70F9.2030901@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200805110030.15510.yhlu.kernel@gmail.com>
	 <200805180118.57863.yhlu.kernel@gmail.com>
	 <200805211840.18619.yhlu.kernel@gmail.com>
	 <200805251000.10205.yhlu.kernel@gmail.com>
	 <alpine.LFD.1.10.0805271744080.3295@apollo.tec.linutronix.de>
	 <483C70F9.2030901@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2008 at 1:37 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> Thomas Gleixner wrote:
>>
>> On Sun, 25 May 2008, Yinghai Lu wrote:
>>
>>>
>>> remove extra -1 in reseve_early calling
>>>    panic if can not find space for new RAMDISK
>>>
>>>
>>
>> Thanks, applied on top of the v2 update
>>
>>        tglx
>>
>
> This patch is still required to make Xen boot with the e820 changes:
>
> Subject: xen: boot via i386_start_kernel to get early reservations
>
> Boot Xen via i386_start_kernel so that all the early reservations are
> made properly; without these, it will start using the kernel and
> pagetables as early heap memory, which is a bit suboptimal.
>
> One tricky part is that reserve_early() will just panic if any of the
> early reservations overlap any others.  When a Xen domain is built, it
> constructs the initial address space as:
>
>  kernel text+data+bss
>  initrd
>  inital pagetable
>
> Therefore, when reserving the pagetable (from &_end to
> init_pg_tables_end), it covers the whole initrd area.  If it then
> tries to reserve the initrd, it will panic because of the overlap.
>
> The simple fix here is to reserve INIT_PG_TABLE first, and then only
> reserve the ramdisk if it doesn't overlap with the previous
> reservations.  A better/more complex fix might be to make
> reserve_early() deal with overlapping reservations.
>
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> ---
> arch/x86/kernel/head32.c |    6 ++++--
> arch/x86/xen/enlighten.c |    2 +-
> include/asm-x86/setup.h  |    1 +
> 3 files changed, 6 insertions(+), 3 deletions(-)
>
> ===================================================================
> --- a/arch/x86/kernel/head32.c
> +++ b/arch/x86/kernel/head32.c
> @@ -66,6 +66,7 @@ void __init i386_start_kernel(void)
> void __init i386_start_kernel(void)
> {
>        reserve_early(__pa_symbol(&_text), __pa_symbol(&_end), "TEXT DATA
> BSS");
> +       reserve_early(__pa_symbol(&_end), init_pg_tables_end,
> "INIT_PG_TABLE");
>
> #ifdef CONFIG_BLK_DEV_INITRD
>        /* Reserve INITRD */
> @@ -73,10 +74,11 @@ void __init i386_start_kernel(void)
>                u64 ramdisk_image = boot_params.hdr.ramdisk_image;
>                u64 ramdisk_size  = boot_params.hdr.ramdisk_size;
>                u64 ramdisk_end   = ramdisk_image + ramdisk_size;
> -               reserve_early(ramdisk_image, ramdisk_end, "RAMDISK");
> +               if (ramdisk_end < __pa_symbol(&_text) ||
> +                   ramdisk_image >= init_pg_tables_end)
> +                       reserve_early(ramdisk_image, ramdisk_end,
> "RAMDISK");
>        }
> #endif
> -       reserve_early(__pa_symbol(&_end), init_pg_tables_end,
> "INIT_PG_TABLE");
>
>        reserve_ebda_region();
>
> ===================================================================
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -1264,5 +1264,5 @@ asmlinkage void __init xen_start_kernel(
>        }
>
>        /* Start the world */
> -       start_kernel();
> +       i386_start_kernel();
> }
> ===================================================================
> --- a/include/asm-x86/setup.h
> +++ b/include/asm-x86/setup.h
> @@ -58,6 +58,7 @@ int __init copy_e820_map(struct e820entr
> int __init copy_e820_map(struct e820entry *biosmap, int nr_map);
> void __init add_memory_region(unsigned long long start,
>                              unsigned long long size, int type);
> +void __init i386_start_kernel(void);
>
> extern unsigned long init_pg_tables_end;

Jeremy,

Can you send out your boot log?

I still can not figure out INIT_PG_TABLE and RAMDISK could overlap? or
only one byte? or the same page?

YH
