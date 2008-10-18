Return-Path: <linux-kernel-owner+w=401wt.eu-S1751936AbYJRTcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936AbYJRTcU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 15:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750905AbYJRTcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 15:32:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49551 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750754AbYJRTcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 15:32:11 -0400
Date: Sat, 18 Oct 2008 12:31:33 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Keith Packard <keithp@keithp.com>
cc: Nick Piggin <nickpiggin@yahoo.com.au>, Dave Airlie <airlied@linux.ie>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       dri-devel@lists.sf.net
Subject: Re: [git pull] drm patches for 2.6.27-rc1
In-Reply-To: <1224357062.4384.72.camel@koto.keithp.com>
Message-ID: <alpine.LFD.2.00.0810181220510.3438@nehalem.linux-foundation.org>
References: <alpine.DEB.0.82.0810172227490.14817@skynet.skynet.ie>  <200810181237.49784.nickpiggin@yahoo.com.au> <1224357062.4384.72.camel@koto.keithp.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 18 Oct 2008, Keith Packard wrote:
>
> The basic plan is to have four new functions (yes, I'm making up names 
> here):
> 
> struct io_mapping *io_reserve_pci_resource(struct pci_dev *dev, 
>                                            int bar, 
>                                            int prot);
> void io_mapping_free(struct io_mapping *mapping);
> 
> void *io_map_atomic(struct io_mapping *mapping, unsigned long pfn);
> void io_unmap_atomic(struct io_mapping *mapping, unsigned long pfn);

The important thing is that mappings need to be per-CPU, so the above may 
work, but only if it's designed so that "io_reserve_pci_resource()" will 
actually reserve space for 'nr_possible_cpu' page mappings, and then the 
"io_[un]map_atomic()" functions do per-CPU mappings.

Anything else is a disaster, because anything else implies TLB shootdown.

And quite frankly, even so, we'd possibly still be _better_ off with just 
exposing the "kmap_atomic_pfn()" functionality even so. Because quite 
frankly, your "io_reserve_pci_resource()" infrastructure is going to 
inevitably be more complex and slower than the rather efficient 
kmap_atomic_pfn() thing we have.

[ The *non-atomic* kmap() functions are fairly high-overhead, in that they 
  want to keep track of cached mappings and remember page addresses etc. 
  So those are the ones we don't want to support for non-HIGHMEM setups. 

  But the atomic kmaps are pretty simple, and really only need some 
  trivial FIXMAP support. We could easily extend it for x86-64, methinks, 
  and do it for x86-32 even when we don't do HIGHMEM.

  Ingo? ]

One small detail: our we currently have "kmap_atomic_pfn()" and 
"kmap_atomic_prot()", and we really should maek the fundamental core 
operation be "kmap_atomic_pfn_prot()", and have everything be done in 
terms of that. Looking at it, it also looks like kmap_atomic_prot() is 
actually incorrect right now, and doesn't do a "prot" thing for 
non-highmem pages, but just returns "page_address(page);"

		Linus
