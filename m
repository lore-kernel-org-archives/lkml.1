Return-Path: <linux-kernel-owner+w=401wt.eu-S1754651AbYE1Ust@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651AbYE1Ust (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 16:48:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752799AbYE1Usl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 16:48:41 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:51711 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669AbYE1Usk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 16:48:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Ikp4Nc7Ftu+fxe7aR7JhXZzy55XWVHqWXygtDFrtK/lt6wlAI7GBU1PnnQIzRx/wq0sUiCgEyHtxQINSQjNXSBQzKx6aeVFNXaXBwk3Rk7J35pslV1t/1TCpp+3SPKXHiZdJK1ZplvF1OvF13q7t63xZoW1AF/dmRpgvoAGHwBA=
Message-ID: <86802c440805281348u2fdd6ce2t71231f0fc94d8b5b@mail.gmail.com>
Date: Wed, 28 May 2008 13:48:39 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: [PATCH] x86: extend e820 ealy_res support 32bit - fix #2
Cc: "Rusty Russell" <rusty@rustcorp.com.au>,
       "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <483D2D8A.5040800@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200805110030.15510.yhlu.kernel@gmail.com>
	 <200805251000.10205.yhlu.kernel@gmail.com>
	 <alpine.LFD.1.10.0805271744080.3295@apollo.tec.linutronix.de>
	 <483C70F9.2030901@goop.org>
	 <86802c440805271406l4348db33r5622c440b494baa2@mail.gmail.com>
	 <483C7BB0.6080901@goop.org>
	 <86802c440805271435l744eab84xe55ac9ce6196c03b@mail.gmail.com>
	 <483C8157.7080702@goop.org>
	 <86802c440805271552k724415a6i66686b9abb8c083f@mail.gmail.com>
	 <483D2D8A.5040800@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2008 at 3:01 AM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> Yinghai Lu wrote:
>>
>> can you try attached patch?
>>
>
> Thanks, that nearly works.  I needed the patch below to get it to
> successfully boot.
>
> For reference, this is what the early reserve map looks like now:
>
> (early) 256MB LOWMEM available.
> (early)   low ram: 02634000 - 10000000
> (early)   bootmap 02634000 - 02636000
> (early)   early res: 0 [0-fff] BIOS data page
> (early)   early res: 1 [1000-1fff] EX TRAMPOLINE
> (early)   early res: 2 [6000-6fff] TRAMPOLINE
> (early)   early res: 3 [25db000-261dfff] XEN
> (early)   early res: 4 [1000000-18a8303] TEXT DATA BSS
> (early)   early res: 5 [18a9000-25dafff] RAMDISK
> (early)   early res: 6 [261e000-2633fff] INIT_PG_TABLE
> (early)   early res: 7 [2634000-2635fff] BOOTMAP
>
>
>   J
>
>
> Subject: xen: reserve_early Xen-specific memory
>
> Make sure that the start_info and pfn->mfn translation array are reserved.
> i386_start_kernel will arrange to reserve the kernel code/data, initrd
> and pagetable.
>
> Also, add prototype for i386_start_kernel.
>
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> ---
> arch/x86/xen/enlighten.c |    9 +++++++++
> include/asm-x86/setup.h  |    1 +
> 2 files changed, 10 insertions(+)
>
> ===================================================================
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -1266,6 +1266,15 @@
>                add_preferred_console("hvc", 0, NULL);
>        }
>
> +       /*
> +        * Reserve Xen bits:
> +        *  - mfn_list
> +        *  - xen_start_info
> +        * See comment above "struct start_info" in <xen/interface/xen.h>
> +        */
> +       reserve_early(__pa(xen_start_info->mfn_list),
> +                     __pa(xen_start_info->pt_base), "XEN");
> +

can we use e820 entries for that? So the domain builder could have
several entries for E820_RAM and E820_RESERVED...

>        /* Start the world */
>        i386_start_kernel();
> }
> ===================================================================
> --- a/include/asm-x86/setup.h
> +++ b/include/asm-x86/setup.h
> @@ -58,6 +58,7 @@
> int __init copy_e820_map(struct e820entry *biosmap, int nr_map);
> void __init add_memory_region(unsigned long long start,
>                              unsigned long long size, int type);
> +void __init i386_start_kernel(void);

will need x86_64_start_kernel there, maybe we should change all name
to x86_start_kernel

YH
