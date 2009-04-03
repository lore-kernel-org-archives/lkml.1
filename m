Return-Path: <linux-kernel-owner+w=401wt.eu-S1762350AbZDCJxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762350AbZDCJxx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 05:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754592AbZDCJxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 05:53:44 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:46846 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbZDCJxn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 05:53:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SHu3CoObHMFi6DJgLm0IqwLGVV8WsWaWFeIaMUk8Ug/sS/1s1+/ffKx1bZ57qqkg0P
         RF82SMku2QThhnZDdfyijdvQ1+t45zNDkjSPv0e5C6gYlAENBBQrQw+BznGNwfcPI1ZE
         Br59o/n1kVPXNHRbcuf2FzqzozSPdpb8jUl+4=
MIME-Version: 1.0
In-Reply-To: <20090402004933.GE10490@linux-os.sc.intel.com>
References: <200903302317.04515.a.miskiewicz@gmail.com>
	 <200903302331.10995.a.miskiewicz@gmail.com>
	 <1238449555.4529.1095.camel@localhost.localdomain>
	 <200903310031.10335.a.miskiewicz@gmail.com>
	 <20090331002815.GB10490@linux-os.sc.intel.com>
	 <20090402004933.GE10490@linux-os.sc.intel.com>
Date: Fri, 3 Apr 2009 11:53:38 +0200
Message-ID: <5a4c581d0904030253v44294f1bo1c65e89a3db9ae9b@mail.gmail.com>
Subject: Re: 2.6.29 git master and PAT problems
From: Alessandro Suardi <alessandro.suardi@gmail.com>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 2, 2009 at 2:49 AM, Pallipadi, Venkatesh
<venkatesh.pallipadi@intel.com> wrote:
> On Mon, Mar 30, 2009 at 05:28:15PM -0700, Pallipadi, Venkatesh wrote:
>> On Mon, Mar 30, 2009 at 03:31:09PM -0700, Arkadiusz Miskiewicz wrote:
>> > On Monday 30 of March 2009, Pallipadi, Venkatesh wrote:
>> >
>> > More info follows. Now I've switched to
>> > e1c502482853f84606928f5a2f2eb6da1993cda1 which contains latest drm fixes and
>> > now I get much lower numbers of PAT errors but still.
>> >
>> > > On Mon, 2009-03-30 at 14:31 -0700, Arkadiusz Miskiewicz wrote:
>> > > > On Monday 30 of March 2009, Pallipadi, Venkatesh wrote:
>> > > > > Patch here should get rid of these errors.
>> > > > >
>> > > > > http://marc.info/?l=linux-kernel&m=123788806506230&w=2
>> > > > >
>> > > > > The patch is in tip and on its way to upstream.
>> > > >
>> > > > The problem is that kernel I'm running already contains this patch (it's
>> > > > merged already). Other ideas?
>> > > >
>> > > > ratelimiting that error is good IMO anyway.
>> > >
>> > > Rate limiting will just work around the problem here. Ideally we should
>> > > never see these errors. So, it will be better if we can narrow down on
>> > > the bug resulting in these error messages.
>> >
>> > Of course it's better. I'm saying that when these messages "fire" then it's
>> > hard to do anything else on the system for a while until these stop.
>> >
>> > > Can you please send me the output of
>> > > # cat /debug/x86/pat_memtype_list
>> > > with debugfs mounted.
>> > > and
>> > > # cat /proc/mtrr
>> >
>>
>> There seems to be two different problems here.
>> - We should not have that many single page ranges reserved. That will cause a
>> performance problem with drm even without the "freeing invalid type" error.
>> - "freeing invalid type" error itself. Seems to be caused due to some
>> unbalanced free along the drm path. We tried to find anything obvious in the
>> code that may be causing problem here. But, haven't found anything so far.
>> Will try to reproduce the problem internally and debug it further.
>>
>
> OK. I think we have root caused the thinko that was resulting in
> "freeing invalid type" error. Can you try the below test
> patch. Patch is not final version and may need some cleanup.
>
> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
>
> diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
> index 640339e..c161700 100644
> --- a/arch/x86/mm/pat.c
> +++ b/arch/x86/mm/pat.c
> @@ -847,7 +847,8 @@ cleanup_ret:
>  * can be for the entire vma (in which case size can be zero).
>  */
>  void untrack_pfn_vma(struct vm_area_struct *vma, unsigned long pfn,
> -                       unsigned long size)
> +                       unsigned long size,
> +                       unsigned long vstart, unsigned long vend)
>  {
>        unsigned long i;
>        resource_size_t paddr;
> @@ -866,7 +867,7 @@ void untrack_pfn_vma(struct vm_area_struct *vma, unsigned long pfn,
>                return;
>        }
>
> -       if (size != 0 && size != vma_size) {
> +       if (size != 0) {
>                /* free page by page, using pfn and size */
>                paddr = (resource_size_t)pfn << PAGE_SHIFT;
>                for (i = 0; i < size; i += PAGE_SIZE) {
> @@ -874,9 +875,12 @@ void untrack_pfn_vma(struct vm_area_struct *vma, unsigned long pfn,
>                        free_pfn_range(paddr, PAGE_SIZE);
>                }
>        } else {
> -               /* free entire vma, page by page, using the pfn from pte */
> -               for (i = 0; i < vma_size; i += PAGE_SIZE) {
> -                       if (follow_phys(vma, vma_start + i, 0, &prot, &paddr))
> +               /*
> +                * free vma range from vstart to end, page by page
> +                * using the pfn from pte
> +                */
> +               for (i = vstart; i < vend; i += PAGE_SIZE) {
> +                       if (follow_phys(vma, i, 0, &prot, &paddr))
>                                continue;
>
>                        free_pfn_range(paddr, PAGE_SIZE);
> diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
> index 8e6d0ca..a325dc1 100644
> --- a/include/asm-generic/pgtable.h
> +++ b/include/asm-generic/pgtable.h
> @@ -328,7 +328,8 @@ static inline int track_pfn_vma_copy(struct vm_area_struct *vma)
>  * can be for the entire vma (in which case size can be zero).
>  */
>  static inline void untrack_pfn_vma(struct vm_area_struct *vma,
> -                                       unsigned long pfn, unsigned long size)
> +                               unsigned long pfn, unsigned long size,
> +                               unsigned long vstart, unsigned long vend)
>  {
>  }
>  #else
> @@ -336,7 +337,8 @@ extern int track_pfn_vma_new(struct vm_area_struct *vma, pgprot_t *prot,
>                                unsigned long pfn, unsigned long size);
>  extern int track_pfn_vma_copy(struct vm_area_struct *vma);
>  extern void untrack_pfn_vma(struct vm_area_struct *vma, unsigned long pfn,
> -                               unsigned long size);
> +                               unsigned long size,
> +                               unsigned long vstart, unsigned long vend);
>  #endif
>
>  #endif /* !__ASSEMBLY__ */
> diff --git a/mm/memory.c b/mm/memory.c
> index cf6873e..6e111c5 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -983,7 +983,7 @@ unsigned long unmap_vmas(struct mmu_gather **tlbp,
>                        *nr_accounted += (end - start) >> PAGE_SHIFT;
>
>                if (unlikely(is_pfn_mapping(vma)))
> -                       untrack_pfn_vma(vma, 0, 0);
> +                       untrack_pfn_vma(vma, 0, 0, start, end);
>
>                while (start != end) {
>                        if (!tlb_start_valid) {
> @@ -1537,7 +1537,7 @@ int vm_insert_pfn(struct vm_area_struct *vma, unsigned long addr,
>        ret = insert_pfn(vma, addr, pfn, pgprot);
>
>        if (ret)
> -               untrack_pfn_vma(vma, pfn, PAGE_SIZE);
> +               untrack_pfn_vma(vma, pfn, PAGE_SIZE, 0, 0);
>
>        return ret;
>  }
> @@ -1702,7 +1702,7 @@ int remap_pfn_range(struct vm_area_struct *vma, unsigned long addr,
>        } while (pgd++, addr = next, addr != end);
>
>        if (err)
> -               untrack_pfn_vma(vma, pfn, PAGE_ALIGN(size));
> +               untrack_pfn_vma(vma, pfn, PAGE_ALIGN(size), 0, 0);
>
>        return err;
>  }

2.6.29-git9 plus the above patch still doesn't fix my Dell E6400 running
 Fedora 10 x86_64:

[asuardi@duff ~]$ dmesg|grep type |grep mem
X:3509 conflicting memory types e0000000-f0000000 uncached<->write-combining
reserve_memtype failed 0xe0000000-0xf0000000, track uncached, req write-back
X:3509 conflicting memory types f6e00000-f7000000 uncached<->uncached-minus
reserve_memtype failed 0xf6e00000-0xf7000000, track uncached, req write-back
X:3509 conflicting memory types f6c00000-f6c80000 uncached<->uncached-minus
reserve_memtype failed 0xf6c00000-0xf6c80000, track uncached, req write-back
X:3509 conflicting memory types e0000000-f0000000 uncached<->write-combining
reserve_memtype failed 0xe0000000-0xf0000000, track uncached, req write-back
X:3509 conflicting memory types f6e00000-f7000000 uncached<->uncached-minus
reserve_memtype failed 0xf6e00000-0xf7000000, track uncached, req write-back
X:3509 conflicting memory types f6c00000-f6c80000 uncached<->uncached-minus
reserve_memtype failed 0xf6c00000-0xf6c80000, track uncached, req write-back
X:3509 conflicting memory types e0000000-f0000000 uncached<->write-combining
reserve_memtype failed 0xe0000000-0xf0000000, track uncached, req write-back
X:3509 conflicting memory types f6e00000-f7000000 uncached<->uncached-minus
reserve_memtype failed 0xf6e00000-0xf7000000, track uncached, req write-back
X:3509 conflicting memory types f6c00000-f6c80000 uncached<->uncached-minus
reserve_memtype failed 0xf6c00000-0xf6c80000, track uncached, req write-back
X:3509 conflicting memory types e0000000-f0000000 uncached<->write-combining
reserve_memtype failed 0xe0000000-0xf0000000, track uncached, req write-back
X:3509 conflicting memory types f6e00000-f7000000 uncached<->uncached-minus
reserve_memtype failed 0xf6e00000-0xf7000000, track uncached, req write-back
X:3509 conflicting memory types f6c00000-f6c80000 uncached<->uncached-minus
reserve_memtype failed 0xf6c00000-0xf6c80000, track uncached, req write-back
X:3561 freeing invalid memtype e0000000-f0000000
X:3561 freeing invalid memtype f6e00000-f7000000
X:3509 conflicting memory types e0000000-f0000000 uncached<->write-combining
reserve_memtype failed 0xe0000000-0xf0000000, track uncached, req write-back
X:3509 conflicting memory types f6e00000-f7000000 uncached<->uncached-minus
reserve_memtype failed 0xf6e00000-0xf7000000, track uncached, req write-back
X:3509 conflicting memory types f6c00000-f6c80000 uncached<->uncached-minus
reserve_memtype failed 0xf6c00000-0xf6c80000, track uncached, req write-back
X:3562 freeing invalid memtype e0000000-f0000000
X:3562 freeing invalid memtype f6e00000-f7000000
X:3562 freeing invalid memtype f6c00000-f6c80000
X:3509 conflicting memory types e0000000-f0000000 uncached<->write-combining
reserve_memtype failed 0xe0000000-0xf0000000, track uncached, req write-back
X:3509 conflicting memory types f6e00000-f7000000 uncached<->uncached-minus
reserve_memtype failed 0xf6e00000-0xf7000000, track uncached, req write-back
X:3509 conflicting memory types f6c00000-f6c80000 uncached<->uncached-minus
reserve_memtype failed 0xf6c00000-0xf6c80000, track uncached, req write-back
X:3563 freeing invalid memtype e0000000-f0000000
X:3563 freeing invalid memtype f6e00000-f7000000
X:3563 freeing invalid memtype f6c00000-f6c80000
X:3509 conflicting memory types e0000000-f0000000 uncached<->write-combining
reserve_memtype failed 0xe0000000-0xf0000000, track uncached, req write-back
X:3509 conflicting memory types f6e00000-f7000000 uncached<->uncached-minus
reserve_memtype failed 0xf6e00000-0xf7000000, track uncached, req write-back
X:3509 conflicting memory types f6c00000-f6c80000 uncached<->uncached-minus
reserve_memtype failed 0xf6c00000-0xf6c80000, track uncached, req write-back
X:3564 freeing invalid memtype e0000000-f0000000
X:3564 freeing invalid memtype f6e00000-f7000000
X:3564 freeing invalid memtype f6c00000-f6c80000
X:3509 conflicting memory types e0000000-f0000000 uncached<->write-combining
reserve_memtype failed 0xe0000000-0xf0000000, track uncached, req write-back
X:3509 conflicting memory types f6e00000-f7000000 uncached<->uncached-minus
reserve_memtype failed 0xf6e00000-0xf7000000, track uncached, req write-back
X:3509 conflicting memory types f6c00000-f6c80000 uncached<->uncached-minus
reserve_memtype failed 0xf6c00000-0xf6c80000, track uncached, req write-back
X:822 freeing invalid memtype e0000000-f0000000
X:822 freeing invalid memtype f6e00000-f7000000
X:822 freeing invalid memtype f6c00000-f6c80000


I also get a corrupted display exiting X to tty console (monitor flashes
 wildly, looking like it's redisplaying the shell prompt but on top instead
 of on bottom), and if I try to Alt-Fn from X to a tty console, the laptop
 locks up hard - Caps doesn't light its led anymore, and I have to keep
 the power button pressed for 10" to power off the box.

The F10 kernel has the same display corruption exiting X to console,
 haven't tried yet Alt-Fn.

I don't have earlier kernel comparisons as I installed F10 a week ago
 on this brand new laptop, 2.6.29-git5 was the first I built; but I could
 try building 2.6.28 if deemed useful; right now I'm building up 2.6.29.1
 and will report later.


Any details - just ask. Thanks,

--alessandro

 "Sun keeps rising in the west / I keep on waking fully confused"

   (The Replacements, "Within Your Reach")
