Return-Path: <linux-kernel-owner+w=401wt.eu-S1758863AbYE2Sws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758863AbYE2Sws (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 14:52:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752190AbYE2Swk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 14:52:40 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:54988 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522AbYE2Swj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 14:52:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=US8X1YS+tHbdIVKa51SHXvcXQrimh+EqbTfTanoHMLlpr0Pud7oQXClENyVZuiGwcMnORnp2ecJd2WK2ymJOYi2+Icoh1yFwCKZBH1KWbXivC/dwmm7rT09OKvRGXnKQBsLmPl2lWiuY5Gu9+xuI1JgDmihZDzg5wey24rN6YRA=
Message-ID: <86802c440805291152w1cdfa5feoac7c92bc2ecca9d6@mail.gmail.com>
Date: Thu, 29 May 2008 11:52:35 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: [PATCH] x86: extend e820 ealy_res support 32bit - fix #2
Cc: "Rusty Russell" <rusty@rustcorp.com.au>,
       "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <483EB18F.4070105@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200805110030.15510.yhlu.kernel@gmail.com>
	 <483C70F9.2030901@goop.org>
	 <86802c440805271406l4348db33r5622c440b494baa2@mail.gmail.com>
	 <483C7BB0.6080901@goop.org>
	 <86802c440805271435l744eab84xe55ac9ce6196c03b@mail.gmail.com>
	 <483C8157.7080702@goop.org>
	 <86802c440805271552k724415a6i66686b9abb8c083f@mail.gmail.com>
	 <483D2D8A.5040800@goop.org>
	 <86802c440805281348u2fdd6ce2t71231f0fc94d8b5b@mail.gmail.com>
	 <483EB18F.4070105@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2008 at 6:37 AM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> Yinghai Lu wrote:
>>
>> can we use e820 entries for that? So the domain builder could have
>> several entries for E820_RAM and E820_RESERVED...
>>
>
> I tried this, but it doesn't work; the kernel crashes during boot,
> presumably because it's trying to use the reserved memory as heap.  I
> suspect the e820 maps are not registered early enough or something...
>
> (One thought: if reserving in the E820 map were enough, then couldn't we use
> it for all the early reservations?)
>
> I've attached the non-working patch below.
>
> The working kernel reports:
>
> (early) BIOS-provided physical RAM map:
> (early)  Xen: 0000000000000000 - 000000000009f000 (usable)
> (early)  Xen: 0000000000100000 - 0000000010000000 (usable)
> (early) console [xenboot0] enabled
> (early) debug: ignoring loglevel setting.
> (early) 0MB HIGHMEM available.
> (early) 256MB LOWMEM available.
> (early)   low ram: 018fd000 - 10000000
> (early)   bootmap 018fd000 - 018ff000
> (early)   early res: 0 [0-fff] BIOS data page
> (early)   early res: 1 [1000-1fff] EX TRAMPOLINE
> (early)   early res: 2 [6000-6fff] TRAMPOLINE
> (early)   early res: 3 [18aa000-18ecfff] XEN
> (early)   early res: 4 [1000000-18a9303] TEXT DATA BSS
> (early)   early res: 5 [18ed000-18fcfff] INIT_PG_TABLE
> (early)   early res: 6 [18fd000-18fefff] BOOTMAP
>
> But the non-working one says:
>
> (early) BIOS-provided physical RAM map:
> (early)  Xen: 0000000000000000 - 000000000009f000 (usable)
> (early)  Xen: 0000000000100000 - 0000000010000000 (usable)
> (early)  Xen: 00000000018aa000 - 00000000018ed000 (reserved)

it seems we miss to call sanitize_e820_map for 32 bit. we should get
(early)  Xen: 0000000000000000 - 000000000009f000 (usable)
(early)  Xen: 0000000000100000 - 00000000018aa000 (usable)
(early)  Xen: 00000000018aa000 - 00000000018ed000 (reserved)
(early)  Xen: 00000000018ed000 - 0000000010000000 (usable)

YH


> (early) console [xenboot0] enabled
> (early) debug: ignoring loglevel setting.
> (early) 0MB HIGHMEM available.
> (early) 256MB LOWMEM available.
> (early)   low ram: 018fd000 - 10000000
> (early)   bootmap 018fd000 - 018ff000
> (early)   early res: 0 [0-fff] BIOS data page
> (early)   early res: 1 [1000-1fff] EX TRAMPOLINE
> (early)   early res: 2 [6000-6fff] TRAMPOLINE
> (early)   early res: 3 [1000000-18a9303] TEXT DATA BSS
> (early)   early res: 4 [18ed000-18fcfff] INIT_PG_TABLE
> (early)   early res: 5 [18fd000-18fefff] BOOTMAP
>
>        J
>
> Subject: xen: reserve Xen-specific memory in e820 map
>
> Make sure that the start_info and pfn->mfn translation array are reserved.
>
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> ---
> arch/x86/xen/setup.c |    9 +++++++++
> 1 file changed, 9 insertions(+)
>
> diff -r ad372188bccf arch/x86/xen/setup.c
> --- a/arch/x86/xen/setup.c      Thu May 29 13:56:09 2008 +0100
> +++ b/arch/x86/xen/setup.c      Thu May 29 14:34:35 2008 +0100
> @@ -40,9 +40,19 @@
>        max_pfn = min(MAX_DOMAIN_PAGES, max_pfn);
>
>        e820.nr_map = 0;
> +
>        add_memory_region(0, LOWMEMSIZE(), E820_RAM);
>        add_memory_region(HIGH_MEMORY, PFN_PHYS(max_pfn)-HIGH_MEMORY,
> E820_RAM);
>
> +       /*
> +        * Reserve Xen bits:
> +        *  - mfn_list
> +        *  - xen_start_info
> +        * See comment above "struct start_info" in <xen/interface/xen.h>
> +        */
> +       add_memory_region(__pa(xen_start_info->mfn_list),
> +                         xen_start_info->pt_base -
> xen_start_info->mfn_list,
> +                         E820_RESERVED);
>        return "Xen";
> }
>
>
>
>
