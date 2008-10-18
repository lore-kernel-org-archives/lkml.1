Return-Path: <linux-kernel-owner+w=401wt.eu-S1751713AbYJRUIO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751713AbYJRUIO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 16:08:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750966AbYJRUH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 16:07:58 -0400
Received: from relay.gothnet.se ([82.193.160.251]:5870 "EHLO
	GOTHNET-SMTP2.gothnet.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750958AbYJRUH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 16:07:57 -0400
Message-ID: <48FA421B.2000605@tungstengraphics.com>
Date: Sat, 18 Oct 2008 22:07:55 +0200
From: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@tungstengraphics.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080926)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Keith Packard <keithp@keithp.com>, Dave Airlie <airlied@linux.ie>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       dri-devel@lists.sf.net
Subject: Re: [git pull] drm patches for 2.6.27-rc1
References: <alpine.DEB.0.82.0810172227490.14817@skynet.skynet.ie>	<200810181237.49784.nickpiggin@yahoo.com.au>	<1224357062.4384.72.camel@koto.keithp.com> <alpine.LFD.2.00.0810181220510.3438@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0810181220510.3438@nehalem.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-BitDefender-Scanner: Mail not scanned due to license constraints
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Sat, 18 Oct 2008, Keith Packard wrote:
>   
>> The basic plan is to have four new functions (yes, I'm making up names 
>> here):
>>
>> struct io_mapping *io_reserve_pci_resource(struct pci_dev *dev, 
>>                                            int bar, 
>>                                            int prot);
>> void io_mapping_free(struct io_mapping *mapping);
>>
>> void *io_map_atomic(struct io_mapping *mapping, unsigned long pfn);
>> void io_unmap_atomic(struct io_mapping *mapping, unsigned long pfn);
>>     
>
> The important thing is that mappings need to be per-CPU, so the above may 
> work, but only if it's designed so that "io_reserve_pci_resource()" will 
> actually reserve space for 'nr_possible_cpu' page mappings, and then the 
> "io_[un]map_atomic()" functions do per-CPU mappings.
>
> Anything else is a disaster, because anything else implies TLB shootdown.
>
> And quite frankly, even so, we'd possibly still be _better_ off with just 
> exposing the "kmap_atomic_pfn()" functionality even so. Because quite 
> frankly, your "io_reserve_pci_resource()" infrastructure is going to 
> inevitably be more complex and slower than the rather efficient 
> kmap_atomic_pfn() thing we have.
>
> [ The *non-atomic* kmap() functions are fairly high-overhead, in that they 
>   want to keep track of cached mappings and remember page addresses etc. 
>   So those are the ones we don't want to support for non-HIGHMEM setups. 
>
>   But the atomic kmaps are pretty simple, and really only need some 
>   trivial FIXMAP support. We could easily extend it for x86-64, methinks, 
>   and do it for x86-32 even when we don't do HIGHMEM.
>
>   Ingo? ]
>
> One small detail: our we currently have "kmap_atomic_pfn()" and 
> "kmap_atomic_prot()", and we really should maek the fundamental core 
> operation be "kmap_atomic_pfn_prot()", and have everything be done in 
> terms of that. Looking at it, it also looks like kmap_atomic_prot() is 
> actually incorrect right now, and doesn't do a "prot" thing for 
> non-highmem pages, but just returns "page_address(page);"
>   
Actually, a "kmap_atomic_prot_pfn()" has been lurking in the drm repos 
for some time now, but hasn't been suggested for upstream. It was 
intended for drivers that require quick in-kernel patching of 
write-combined io and highmem pages. The latter is a common situation 
for PCIE graphics devices with their own MMU, so IMHO an exported 
kmap_atomic_pfn_prot() would be a big help in such cases.

/Thomas

> 		Linus
>
> -------------------------------------------------------------------------
> This SF.Net email is sponsored by the Moblin Your Move Developer's challenge
> Build the coolest Linux based applications with Moblin SDK & win great prizes
> Grand prize is a trip for two to an Open Source event anywhere in the world
> http://moblin-contest.org/redirect.php?banner_id=100&url=/
> --
> _______________________________________________
> Dri-devel mailing list
> Dri-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/dri-devel
>   



