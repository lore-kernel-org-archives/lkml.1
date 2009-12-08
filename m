Return-Path: <linux-kernel-owner+w=401wt.eu-S1751866AbZLHJLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866AbZLHJLr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 04:11:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751571AbZLHJLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 04:11:46 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:20761 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbZLHJLn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 04:11:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=nI799fpAN7ePsT8Zmr4Fu7YeMVeOGPYrcpv93Zqq8LYfZM+b+ajgV0YuXMTB1JyXGI
         utW6fSaybAHlDIA7cTvQ3WgCTyyVPYBrNcKlJxuHnegwfysocof89hNpmMxVmN3ekcEO
         wKc9BJtSAtmyE5BNy4ARN7xG59b7pL+prNqWk=
MIME-Version: 1.0
In-Reply-To: <20091207153552.0fadf335.akpm@linux-foundation.org>
References: <4B1D3A3302000078000241CD@vpn.id2.novell.com>
	 <20091207153552.0fadf335.akpm@linux-foundation.org>
Date: Tue, 8 Dec 2009 10:11:49 +0100
X-Google-Sender-Auth: 6eefb341bef45f57
Message-ID: <10f740e80912080111l57b0562doebedb1f878592105@mail.gmail.com>
Subject: Re: [PATCH] mm/vmalloc: don't use vmalloc_end
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Beulich <JBeulich@novell.com>, linux-kernel@vger.kernel.org,
       tony.luck@intel.com, tj@kernel.org, linux-mm@kvack.org,
       linux-ia64@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 8, 2009 at 00:35, Andrew Morton <akpm@linux-foundation.org> wrote:
> (cc linux-ia64)
>
> On Mon, 07 Dec 2009 16:24:03 +0000
> "Jan Beulich" <JBeulich@novell.com> wrote:
>
>> At least on ia64 vmalloc_end is a global variable that VMALLOC_END
>> expands to. Hence having a local variable named vmalloc_end and
>> initialized from VMALLOC_END won't work on such platforms. Rename
>> these variables, and for consistency also rename vmalloc_start.
>>
>
> erk.  So does 2.6.32's vmalloc() actually work correctly on ia64?
>
> Perhaps vmalloc_end wasn't a well chosen name for an arch-specific
> global variable.
>
> arch/m68k/include/asm/pgtable_mm.h does the same thing.  Did it break too?

Rename to m68k_vmalloc_{end,start}?

Hmm, sounds better than introducing allcaps variables...

>
>> ---
>>  mm/vmalloc.c |   16 ++++++++--------
>>  1 file changed, 8 insertions(+), 8 deletions(-)
>>
>> --- linux-2.6.32/mm/vmalloc.c
>> +++ 2.6.32-dont-use-vmalloc_end/mm/vmalloc.c
>> @@ -2060,13 +2060,13 @@ static unsigned long pvm_determine_end(s
>>                                      struct vmap_area **pprev,
>>                                      unsigned long align)
>>  {
>> -     const unsigned long vmalloc_end = VMALLOC_END & ~(align - 1);
>> +     const unsigned long end = VMALLOC_END & ~(align - 1);
>>       unsigned long addr;
>>
>>       if (*pnext)
>> -             addr = min((*pnext)->va_start & ~(align - 1), vmalloc_end);
>> +             addr = min((*pnext)->va_start & ~(align - 1), end);
>>       else
>> -             addr = vmalloc_end;
>> +             addr = end;
>>
>>       while (*pprev && (*pprev)->va_end > addr) {
>>               *pnext = *pprev;
>> @@ -2105,8 +2105,8 @@ struct vm_struct **pcpu_get_vm_areas(con
>>                                    const size_t *sizes, int nr_vms,
>>                                    size_t align, gfp_t gfp_mask)
>>  {
>> -     const unsigned long vmalloc_start = ALIGN(VMALLOC_START, align);
>> -     const unsigned long vmalloc_end = VMALLOC_END & ~(align - 1);
>> +     const unsigned long vstart = ALIGN(VMALLOC_START, align);
>> +     const unsigned long vend = VMALLOC_END & ~(align - 1);
>>       struct vmap_area **vas, *prev, *next;
>>       struct vm_struct **vms;
>>       int area, area2, last_area, term_area;
>> @@ -2142,7 +2142,7 @@ struct vm_struct **pcpu_get_vm_areas(con
>>       }
>>       last_end = offsets[last_area] + sizes[last_area];
>>
>> -     if (vmalloc_end - vmalloc_start < last_end) {
>> +     if (vend - vstart < last_end) {
>>               WARN_ON(true);
>>               return NULL;
>>       }
>> @@ -2167,7 +2167,7 @@ retry:
>>       end = start + sizes[area];
>>
>>       if (!pvm_find_next_prev(vmap_area_pcpu_hole, &next, &prev)) {
>> -             base = vmalloc_end - last_end;
>> +             base = vend - last_end;
>>               goto found;
>>       }
>>       base = pvm_determine_end(&next, &prev, align) - end;
>> @@ -2180,7 +2180,7 @@ retry:
>>                * base might have underflowed, add last_end before
>>                * comparing.
>>                */
>> -             if (base + last_end < vmalloc_start + last_end) {
>> +             if (base + last_end < vstart + last_end) {
>>                       spin_unlock(&vmap_area_lock);
>>                       if (!purged) {
>>                               purge_vmap_area_lazy();
>>
>



-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
