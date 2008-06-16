Return-Path: <linux-kernel-owner+w=401wt.eu-S1758218AbYFPGys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758218AbYFPGys (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 02:54:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbYFPGyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 02:54:40 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:49335 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbYFPGyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 02:54:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=pbtfr3ksScSv01VynmhHHWjx9r+DZ64KJj8jzwJszdmEFn+YO0hR3UlPmpEUoTDS/I
         LNlXRHY8QVK0SKuQOCDWW2msGviA8jXj9a36olsaNnZgJiA2RFF9jF4XRPDn8Nqz1kFG
         xce6zhfJVcpDUnDKJXNwW3n3kEXEsigFzn+EI=
Message-ID: <86802c440806152354i24a1ec5ap316dacec0981d05@mail.gmail.com>
Date: Sun, 15 Jun 2008 23:54:38 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Paul Jackson" <pj@sgi.com>
Subject: Re: [PATCH 4/8] x86 boot: allow overlapping ebda and efi memmap memory ranges
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Jack Steiner" <steiner@sgi.com>, "Mike Travis" <travis@sgi.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       "Huang, Ying" <ying.huang@intel.com>,
       "Andi Kleen" <andi@firstfloor.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20080616063001.14597.96170.sendpatchset@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080616062945.14597.78009.sendpatchset@polaris-admin.engr.sgi.com>
	 <20080616063001.14597.96170.sendpatchset@polaris-admin.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 15, 2008 at 11:30 PM, Paul Jackson <pj@sgi.com> wrote:
> From: Paul Jackson <pj@sgi.com>
>
> In order to support EFI firmware which places the EFI memmap within
> the EBDA (Extended BIOS Data Area), allow for the possibility that we
> might try to reserve_early() the "EFI memmap" area twice, once as part
> of the larger EBDA area and once by itself.  Since the reserve_early()
> mechanism does not allow such double reservations, detect and avoid the
> "EFI memmap" reserve_early() call if it would overlap the EBDA area.
>
> Signed-off-by: Paul Jackson <pj@sgi.com>
>
> ---
>  arch/x86/kernel/efi.c       |    3 ++-
>  arch/x86/kernel/head.c      |   12 +++++++++++-
>  include/asm-x86/bios_ebda.h |    1 +
>  include/asm-x86/e820.h      |    1 +
>  4 files changed, 15 insertions(+), 2 deletions(-)
>
> --- linux.orig/arch/x86/kernel/efi.c    2008-06-13 00:51:17.350774123 -0700
> +++ linux/arch/x86/kernel/efi.c 2008-06-13 00:53:10.053599898 -0700
> @@ -253,7 +253,8 @@ void __init efi_reserve_early(void)
>                boot_params.efi_info.efi_memdesc_size;
>        memmap.desc_version = boot_params.efi_info.efi_memdesc_version;
>        memmap.desc_size = boot_params.efi_info.efi_memdesc_size;
> -       reserve_early(pmap, pmap + memmap.nr_map * memmap.desc_size,
> +       if (!range_in_ebda_area(pmap, pmap + memmap.nr_map * memmap.desc_size))
> +               reserve_early(pmap, pmap + memmap.nr_map * memmap.desc_size,
>                      "EFI memmap");
>  }
>
> --- linux.orig/arch/x86/kernel/head.c   2008-06-13 00:51:17.350774123 -0700
> +++ linux/arch/x86/kernel/head.c        2008-06-13 00:52:45.208095174 -0700
> @@ -6,6 +6,9 @@
>
>  #define BIOS_LOWMEM_KILOBYTES 0x413
>
> +static unsigned int __initdata ebda_start;
> +static unsigned int __initdata ebda_end;
> +
>  /*
>  * The BIOS places the EBDA/XBDA at the top of conventional
>  * memory, and usually decreases the reported amount of
> @@ -51,7 +54,14 @@ void __init reserve_ebda_region(void)
>                lowmem = 0x9f000;
>
>        /* reserve all memory between lowmem and the 1MB mark */
> -       reserve_early(lowmem, 0x100000, "BIOS reserved");
> +       ebda_start = lowmem;
> +       ebda_end = 0x100000;
> +       reserve_early(ebda_start, ebda_end, "BIOS reserved");
> +}
> +
> +int __init range_in_ebda_area(u64 start, u64 end)
> +{
> +       return start >= ebda_start && end <= ebda_end;
>  }
>
>  void __init reserve_setup_data(void)
> --- linux.orig/include/asm-x86/bios_ebda.h      2008-06-13 00:51:17.350774123 -0700
> +++ linux/include/asm-x86/bios_ebda.h   2008-06-13 00:51:31.819650439 -0700
> @@ -15,5 +15,6 @@ static inline unsigned int get_bios_ebda
>  }
>
>  void reserve_ebda_region(void);
> +int range_in_ebda_area(u64 start, u64 end);
>
>  #endif /* _MACH_BIOS_EBDA_H */
> --- linux.orig/include/asm-x86/e820.h   2008-06-13 00:51:17.354774365 -0700
> +++ linux/include/asm-x86/e820.h        2008-06-13 00:51:31.831651166 -0700
> @@ -84,6 +84,7 @@ extern unsigned long end_user_pfn;
>  extern u64 find_e820_area(u64 start, u64 end, u64 size, u64 align);
>  extern u64 find_e820_area_size(u64 start, u64 *sizep, u64 align);
>  extern void reserve_early(u64 start, u64 end, char *name);
> +extern int range_in_ebda_area(u64 start, u64 end);
>  extern void free_early(u64 start, u64 end);
>  extern void early_res_to_bootmem(u64 start, u64 end);
>  extern int page_is_reserved_early(unsigned long pagenr);

how about patial overlapping?

YH
