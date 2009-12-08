Return-Path: <linux-kernel-owner+w=401wt.eu-S1751911AbZLHJIE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911AbZLHJIE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 04:08:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751689AbZLHJH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 04:07:59 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:2365 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbZLHJH4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 04:07:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=DDD0R5p/+c5lwNCluTdVc1f32JAb0A2wd4jKm60NduzubL0I+PFqyLDjH2d90mRRK9
         sz/FwZpZNgRvcqs8whm90xc7ImX/BnQxAG0GFsOz3M2shnLqCue37GPa9GblbvD6NjhQ
         MrU4r4KN13Bi3A614BQA7DZAGd3AZSrrQqAIQ=
MIME-Version: 1.0
In-Reply-To: <4B1DF8D4.2010202@novell.com>
References: <4B1D3A3302000078000241CD@vpn.id2.novell.com>
	 <20091207153552.0fadf335.akpm@linux-foundation.org>
	 <4B1DA06A.1050004@kernel.org> <4B1DF8D4.2010202@novell.com>
Date: Tue, 8 Dec 2009 10:08:01 +0100
X-Google-Sender-Auth: 13e270d1f2f70c00
Message-ID: <10f740e80912080108s5e145ee8t74a27e44d31966ed@mail.gmail.com>
Subject: Re: [PATCH] m68k: don't alias VMALLOC_END to vmalloc_end
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Tejun Heo <teheo@novell.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jan Beulich <JBeulich@novell.com>, linux-kernel@vger.kernel.org,
       tony.luck@intel.com, linux-mm@kvack.org, linux-ia64@vger.kernel.org,
       Roman Zippel <zippel@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 8, 2009 at 07:57, Tejun Heo <teheo@novell.com> wrote:
> On SUN3, m68k defines macro VMALLOC_END as unsigned long variable
> vmalloc_end which is adjusted from mmu_emu_init().  This becomes
> problematic if a local variables vmalloc_end is defined in some
> function (not very unlikely) and VMALLOC_END is used in the function -
> the function thinks its referencing the global VMALLOC_END value but
> would be referencing its own local vmalloc_end variable.
>
> There's no reason VMALLOC_END should be a macro.  Just define it as an
> unsigned long variable to avoid nasty surprises.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Roman Zippel <zippel@linux-m68k.org>
> ---
> Okay, here it is.  Compile tested.  Geert, Roman, if you guys don't
> object, I'd like to push it with the rest of percpu changes to Linus.
> What do you think?

Fine for me, except that by convention allcaps is reserved for macros?

>
> Thanks.
>
>  arch/m68k/include/asm/pgtable_mm.h |    3 +--
>  arch/m68k/sun3/mmu_emu.c           |    8 ++++----
>  2 files changed, 5 insertions(+), 6 deletions(-)
>
> diff --git a/arch/m68k/include/asm/pgtable_mm.h b/arch/m68k/include/asm/pgtable_mm.h
> index fe60e1a..0ea9f09 100644
> --- a/arch/m68k/include/asm/pgtable_mm.h
> +++ b/arch/m68k/include/asm/pgtable_mm.h
> @@ -83,9 +83,8 @@
>  #define VMALLOC_START (((unsigned long) high_memory + VMALLOC_OFFSET) & ~(VMALLOC_OFFSET-1))
>  #define VMALLOC_END KMAP_START
>  #else
> -extern unsigned long vmalloc_end;
>  #define VMALLOC_START 0x0f800000
> -#define VMALLOC_END vmalloc_end
> +extern unsigned long VMALLOC_END;
>  #endif /* CONFIG_SUN3 */
>
>  /* zero page used for uninitialized stuff */
> diff --git a/arch/m68k/sun3/mmu_emu.c b/arch/m68k/sun3/mmu_emu.c
> index 3cd1939..25e2b14 100644
> --- a/arch/m68k/sun3/mmu_emu.c
> +++ b/arch/m68k/sun3/mmu_emu.c
> @@ -45,8 +45,8 @@
>  ** Globals
>  */
>
> -unsigned long vmalloc_end;
> -EXPORT_SYMBOL(vmalloc_end);
> +unsigned long VMALLOC_END;
> +EXPORT_SYMBOL(VMALLOC_END);
>
>  unsigned long pmeg_vaddr[PMEGS_NUM];
>  unsigned char pmeg_alloc[PMEGS_NUM];
> @@ -172,8 +172,8 @@ void mmu_emu_init(unsigned long bootmem_end)
>  #endif
>                        // the lowest mapping here is the end of our
>                        // vmalloc region
> -                       if(!vmalloc_end)
> -                               vmalloc_end = seg;
> +                       if (!VMALLOC_END)
> +                               VMALLOC_END = seg;
>
>                        // mark the segmap alloc'd, and reserve any
>                        // of the first 0xbff pages the hardware is
>



-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
