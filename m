Return-Path: <linux-kernel-owner+w=401wt.eu-S1757027AbZKMTJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757027AbZKMTJz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 14:09:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756435AbZKMTJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 14:09:52 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:44409 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754570AbZKMTJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 14:09:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vnChgDm3RNB7GiYWjs2CkJKK2NGq8QGHuHIvYKMRKiv/rYjI31jwFGWtAyR41UPP0D
         QiLZW8HR62pfm1lPxK7VL5njXLlAEou14/9gm6G+k3fNZKSvfA2nagbJgvyzC+aBLr2m
         4Zo+Tpt10jj5Vg2q62LZoNgLWtGwNvpePxxbM=
Date: Fri, 13 Nov 2009 22:09:55 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, "Maciej W. Rozycki" <macro@linux-mips.org>,
       x86team <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC -tip] x86,io-apic: Do not map IO-APIC direct registers
	twice
Message-ID: <20091113190955.GC5695@lenovo>
References: <20091112204852.GB5728@lenovo> <4AFC98CF.5030408@kernel.org> <20091113175057.GA5695@lenovo> <4AFDABE3.2050006@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AFDABE3.2050006@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 13, 2009 at 10:56:35AM -0800, Yinghai Lu wrote:
> Cyrill Gorcunov wrote:
> > On Thu, Nov 12, 2009 at 03:22:55PM -0800, Yinghai Lu wrote:
> >> Cyrill Gorcunov wrote:
> >>> Please review, I didn't manage to test (emulate actually since I don't
> >>>
> > ...
> > 
> > First of all -- thanks a lot for review Yinghai!
> > 
> >>> Also insert_resourse will not fail anymore on 1K aligned io-apics.
> >> looks that we don't need that ...
> >> not io_apic_base already have that + &. left problems are
> >> 1. display.
> >> 2. insert resource problem.
> >>
> >> YH
> >>
> >> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> >> index 90e8bc5..6a9379b 100644
> >> --- a/arch/x86/kernel/apic/io_apic.c
> >> +++ b/arch/x86/kernel/apic/io_apic.c
> >> @@ -4140,11 +4140,13 @@ fake_ioapic_page:
> >>  		set_fixmap_nocache(idx, ioapic_phys);
> >>  		apic_printk(APIC_VERBOSE,
> >>  			    "mapped IOAPIC to %08lx (%08lx)\n",
> >> -			    __fix_to_virt(idx), ioapic_phys);
> >> +			    __fix_to_virt(idx) + (ioapic_phys & ~PAGE_MASK),
> > 
> > Don't understand, why? What is wrong with physical address,
> > could you elaborate please?
> 
> ioapic_phys could be 1k aligned, but __fix_to_virt(idx) will always return 4k aligned.

yeah, I just misread your patch, I thought you've changed second argument,
sorry. OK, I see what you mean, good catch, thanks!

> 
> > 
> >> +			    ioapic_phys);
> >>  		idx++;
> >>  
> >> +		/* spec says size is 1024 */
> > 
> > Hmm, MP says nothing about size of IO-APIC direct registers
> > cound and as a result -- the size of MMIO. It will (and
> > is) differ between IO-APIC versions. An example -- IO-APIC EOI register
> > which 82489DX just dont have at all. At moment (ICH-10) the lenght is 68
> > bytes so you may note the comment in the former patch that we "hope" such
> > a size will be enough for quite a long time to cover all direct register
> > space an IO-APIC provides (though to be precise from this 68 bytes only
> > index,data,eoi registers specified).
> > 
> >>  		ioapic_res->start = ioapic_phys;
> >> -		ioapic_res->end = ioapic_phys + PAGE_SIZE-1;
> >> +		ioapic_res->end = ioapic_phys + (1<<10) - 1;
> >>  		ioapic_res++;
> >>  	}
> >>  }
> >>
> > 
> > I think I've compicated the patch/idea too much indeed :)
> > Since we have fixmap for all io_apics build time reserved
> > even if some io-apic is 1K aligned we still may use new
> > fixmap index. So only issue remains -- resource allocation.
> > Here is an updated patch. Please review.
> 
> 2. print out ...?

Print out what? Not sure I understand you right. Perhaps you mean
to check insert_resourse results?

> 
> YH
> 
	-- Cyrill
