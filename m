Return-Path: <linux-kernel-owner+w=401wt.eu-S1756953AbYBEHPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756953AbYBEHPZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 02:15:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753644AbYBEHPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 02:15:06 -0500
Received: from mga06.intel.com ([134.134.136.21]:30881 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753522AbYBEHPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 02:15:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,305,1199692800"; 
   d="scan'208";a="335043890"
Message-ID: <47A80CDA.70301@linux.intel.com>
Date: Mon, 04 Feb 2008 23:14:34 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Siddha, Suresh B" <suresh.b.siddha@intel.com>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: issue with patch "x86: no CPA on iounmap"
References: <20080205011357.GA14712@linux-os.sc.intel.com> <47A7EA88.3020404@linux.intel.com> <20080205070535.GA10695@elte.hu>
In-Reply-To: <20080205070535.GA10695@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Arjan van de Ven <arjan@linux.intel.com> wrote:
> 
>> Siddha, Suresh B wrote:
>>> This is wrt to x86 git commit f56d005d30342a45d8af2b75ecccc82200f09600
>>> 	"x86: no CPA on iounmap"
>>>
>>> This can use performance issue. When a GART driver unmaps a RAM page,
>> thinking about this some more...
>>
>> afaik the gart driver doesn't use ioremap....
>>
>> (and it does caching control explicitly, and sets its pages back to 
>> cached)
> 
> there are many GART drivers, and the method used depends on the GART 
> driver. The following GART drivers still use ioremap in one way or 
> another:
> 
>  drivers/char/agp/amd-k7-agp.c
>  drivers/char/agp/ati-agp.c
>  drivers/char/agp/generic.c
>  drivers/char/agp/sworks-agp.c
>  drivers/char/drm/radeon_cp.c
> 
> the method use is in all cases the same: they use __get_free_page() to 
> pick up a general RAM page, they do SetPageReserved() and then they use 
> ioremap_nocache() to map it non-cached, and then they also program the 
> GART to access those pages.
> 
> when the GART code deinits, it does an iounmap() on those pages, unmaps 
> it from the GART hardware itself, does a ClearPageReserved() and does 
> __free_page() to put the page into the general page pool again. So 
> Suresh is right: these pages are currently marked UC at this point and 
> we need to mark them cacheable.
> 
> we could do this automatically in iounmap() upon seeing a page_is_ram() 
> that has PageReserved set. Or we could stick in a set_memory_wb() into 
> the deinit [and ioremap_nocache()-failure] sequence.
> 
> Since we treat PageReserved pages specially in ioremap() already [we 
> allow them, despite them being listed in the e820 map], i think the more 
> robust solution is to recognize them in iounmap() as well - this way it 
> cannot be forgotten accidentally. (and UC pages in the buddy are _hard_ 
> to notice after the fact) There is no aliasing danger i believe: IO bars 
> should never be marked as general RAM in the e820.
> 

agreed, esp for .25

it's sort of a weird case of ioremap() use; I wonder if longer term we need
to have a different sort of interface for this kind of use...
