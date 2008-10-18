Return-Path: <linux-kernel-owner+w=401wt.eu-S1751472AbYJRWrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751472AbYJRWrS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 18:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750952AbYJRWrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 18:47:09 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:61239 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbYJRWrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 18:47:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=nwB5KaHU7MOEUcotxeKlC4Q42dlZXnnWNA8JVd6KIPVKt2asTX9HotSgupv1L2Pptd
         nrC9/N3EfDcYyNqJ0lsI14x60SdzAp4oLSW6KfiYbe3HSZ3R5SoHsaOYETOkZf1t9XIS
         Hi0z0iCtsAjJc7G0U/jYOjf+FrV30D4dcTrIg=
Message-ID: <9e4733910810181547k98f2a02p82769c51975f5865@mail.gmail.com>
Date: Sat, 18 Oct 2008 18:47:05 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [git pull] drm patches for 2.6.27-rc1
Cc: "Keith Packard" <keithp@keithp.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Dave Airlie" <airlied@linux.ie>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       dri-devel@lists.sf.net, "Andrew Morton" <akpm@linux-foundation.org>,
       "Yinghai Lu" <yinghai@kernel.org>
In-Reply-To: <20081018223214.GA5093@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.DEB.0.82.0810172227490.14817@skynet.skynet.ie>
	 <200810181237.49784.nickpiggin@yahoo.com.au>
	 <1224357062.4384.72.camel@koto.keithp.com>
	 <alpine.LFD.2.00.0810181220510.3438@nehalem.linux-foundation.org>
	 <20081018203741.GA23396@elte.hu>
	 <1224366690.4384.89.camel@koto.keithp.com>
	 <20081018223214.GA5093@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 18, 2008 at 6:32 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Keith Packard <keithp@keithp.com> wrote:
>
>> On Sat, 2008-10-18 at 22:37 +0200, Ingo Molnar wrote:
>>
>> > But i think the direction of the new GEM code is subtly wrong here,
>> > because it tries to manage memory even on 64-bit systems. IMO it
>> > should just map the _whole_ graphics aperture (non-cached) and be
>> > done with it. There's no faster method at managing pages than the
>> > CPU doing a TLB fill from pagetables.
>>
>> Yeah, we're stuck thinking that we "can't" map the aperture because
>> it's too large, but with a 64-bit kernel, we should be able to keep it
>> mapped permanently.
>>
>> Of course, the io_reserve_pci_resource and io_map_atomic functions
>> could do precisely that, as kmap_atomic does on non-HIGHMEM systems
>> today.
>
> okay, so basically what we need is a shared API that does per page
> kmap_atomic on 32-bit, and just an ioremap() on 64-bit. I had the
> impression that you were suggesting to extend kmap_atomic() to 64-bit -
> which would be wrong.

Is it possible to use a segment register to map the whole aperture on
32b? A segment register might allow common code on 64b/32b by
eliminating the need to move the mapping window around.

>
> So, in terms of the 4 APIs you suggest:
>
>  struct io_mapping *io_reserve_pci_resource(struct pci_dev *dev,
>                                             int bar,
>                                             int prot);
>  void io_mapping_free(struct io_mapping *mapping);
>
>  void *io_map_atomic(struct io_mapping *mapping, unsigned long pfn);
>  void io_unmap_atomic(struct io_mapping *mapping, unsigned long pfn);
>
> here is what we'd do on 64-bit:
>
>  - io_reserve_pci_resource() would just do an ioremap(), and would save
>    the ioremap-ed memory into struct io_mapping.
>
>  - io_mapping_free() does the iounmap()
>
>  - io_map_atomic(): just arithmetics, returns mapping->base + pfn - no
>    TLB activities at all.
>
>  - io_unmap_atomic(): NOP.
>
> it's as fast as it gets: zero overhead in essence. Note that it's also
> shared between all CPUs and there's no aliasing trouble.
>
> And we could make it even faster: if you think we could even use 2MB
> TLBs for the _linear_ ioremap()s here, hm? There's plenty of address
> space on 64-bit so we can align to 2MB just fine - and aperture sizes
> are 2MB sized anyway.
>
> Or we could go one step further and install these aperture mappings into
> the _kernel linear_ address space. That would be even faster, because
> we'd have a constant offset. We have the (2MB mappings aware) mechanism
> for that already. (Yinghai Cc:-ed - he did a lot of great work to
> generalize this area.)
>
> (In fact if we installed it into the linear kernel address space, and if
> the aperture is 1GB aligned, we will automatically use gbpages for it.
> Were Intel to support gbpages in the future ;-)
>
> the _real_ remapping in a graphics aperture happens on the GPU level
> anyway, you manage an in-RAM GPU pagetable that just works like an
> IOMMU, correct?
>
> on 32-bit we'd have what you use in the GEM code today:
>
>  - io_reserve_pci_resource(): a NOP in essence
>
>  - io_mapping_free(): a NOP
>
>  - io_map_atomic(): does a kmap_atomic(pfn)
>
>  - io_unmap_atomic(): does a kunmap_atomic(pfn)
>
> so on 32-bit we have the INVLPG TLB overhead and preemption restrictions
> - but we knew that. We'd have to allow atomic_kmap() on non-highmem as
> well but that's fair.
>
> Mind sending patches for this? :-)
>
>        Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Jon Smirl
jonsmirl@gmail.com
