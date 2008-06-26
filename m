Return-Path: <linux-kernel-owner+w=401wt.eu-S1754983AbYFZHNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983AbYFZHNj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 03:13:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750874AbYFZHNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 03:13:31 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:44038 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbYFZHNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 03:13:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=taQm5pMc+us4bq0yO7uIN2dGbPe4OiGsm0AhM9+FLR/x8ihNUjZLAg9Tqu8eRYhemb
         DbVY1jorKkz7n+jmhhRZ4r/wzsnmropnZM+96Ph8oEUP4Z6/5jo7NScobwcizZT4b0so
         V4yzQnfrEHzqvomYt2AcKk+KqLob65UCcy6e8=
Message-ID: <86802c440806260013u447d15d8v94df7bb7bd00da19@mail.gmail.com>
Date: Thu, 26 Jun 2008 00:13:29 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH 2/2] x86 boot: early_res_to_e820
Cc: "H. Peter Anvin" <hpa@zytor.com>, andi@firstfloor.org, mingo@redhat.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
In-Reply-To: <1214461980.10809.7.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1214461980.10809.7.camel@caritas-dev.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2008 at 11:33 PM, Huang, Ying <ying.huang@intel.com> wrote:
> This patch reserves some memory areas of early_res in E820 as
> E820_RESVD_KERN. This is used mainly on i386, for some memory area
> from boot-loader and in highmem, such as linked list of setup_data,
> EFI memory map, etc.
>
> This patch is based on latest x86/master branch of git-x86 tree and
> has been tested on i386 and x86_64 platform.
>
> Signed-off-by: Huang Ying <ying.huang@intel.com>
>
> ---
>  arch/x86/kernel/e820.c     |   22 ++++++++++++++++++++++
>  arch/x86/kernel/setup_32.c |    2 ++
>  include/asm-x86/e820.h     |    1 +
>  3 files changed, 25 insertions(+)
>
> --- a/arch/x86/kernel/e820.c
> +++ b/arch/x86/kernel/e820.c
> @@ -844,6 +844,28 @@ void __init early_res_to_bootmem(u64 sta
>        }
>  }
>
> +void __init early_res_to_e820(u64 start, u64 end)
> +{
> +       int i, changed = 0;
> +       u64 final_start, final_end;
> +       for (i = 0; i < MAX_EARLY_RES && early_res[i].end; i++) {
> +               struct early_res *r = &early_res[i];
> +               final_start = max(start, r->start);
> +               final_end = min(end, r->end);
> +               if (final_start >= final_end)
> +                       continue;
> +               printk(KERN_INFO "  early res: %d [%llx-%llx] %s\n", i,
> +                       final_start, final_end - 1, r->name);
> +               e820_update_range(final_start, final_end - final_start,
> +                                 E820_RAM, E820_RESVD_KERN);
> +               changed = 1;
> +       }
> +       if (changed) {
> +               printk(KERN_INFO "update e820 for early_res\n");
> +               update_e820();
> +       }
> +}
> +
>  /* Check for already reserved areas */
>  static inline int __init bad_addr(u64 *addrp, u64 size, u64 align)
>  {
> --- a/include/asm-x86/e820.h
> +++ b/include/asm-x86/e820.h
> @@ -96,6 +96,7 @@ extern void reserve_early(u64 start, u64
>  extern void reserve_early_overlap_ok(u64 start, u64 end, char *name);
>  extern void free_early(u64 start, u64 end);
>  extern void early_res_to_bootmem(u64 start, u64 end);
> +extern void early_res_to_e820(u64 start, u64 end);
>  extern u64 early_reserve_e820(u64 startt, u64 sizet, u64 align);
>
>  extern unsigned long e820_end_of_ram(void);
> --- a/arch/x86/kernel/setup_32.c
> +++ b/arch/x86/kernel/setup_32.c
> @@ -447,6 +447,8 @@ void __init setup_arch(char **cmdline_p)
>         acpi_numa_init();
>  #endif
>
> +       early_res_to_e820(max_low_pfn<<PAGE_SHIFT, -1);
> +
>        initmem_init(0, max_pfn);
>
>  #ifdef CONFIG_ACPI_SLEEP
>
> --

this one is not needed.

YH
