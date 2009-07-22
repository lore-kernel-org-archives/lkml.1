Return-Path: <linux-kernel-owner+w=401wt.eu-S1751909AbZGVMOB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909AbZGVMOB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 08:14:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751192AbZGVMOB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 08:14:01 -0400
Received: from nox.protox.org ([88.191.38.29]:39793 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973AbZGVMOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 08:14:00 -0400
Subject: Re: TTM page pool allocator
From: Jerome Glisse <glisse@freedesktop.org>
To: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas@shipmail.org>
Cc: Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
In-Reply-To: <4A66CD54.6070104@shipmail.org>
References: <1245931298.13359.8.camel@localhost.localdomain>
	 <4A439D7D.9030401@shipmail.org> <1248197676.2368.11.camel@localhost>
	 <4A66CD54.6070104@shipmail.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Jul 2009 14:12:42 +0200
Message-Id: <1248264762.2336.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-22 at 10:27 +0200, Thomas Hellström wrote:
> Jerome Glisse wrote:
> > On Thu, 2009-06-25 at 17:53 +0200, Thomas Hellström wrote:
> >   
> >> Jerome Glisse skrev:
> >>     
> >>> Hi,
> >>>
> >>> Thomas i attach a reworked page pool allocator based on Dave works,
> >>> this one should be ok with ttm cache status tracking. It definitely
> >>> helps on AGP system, now the bottleneck is in mesa vertex's dma
> >>> allocation.
> >>>
> >>> Cheers,
> >>> Jerome
> >>>   
> >>>       
> >> Hi, Jerome!
> >> In general it looks very good. Some things that need fixing:
> >>
> >> 1)  We must have a way to hand back pages. I still not quite understand 
> >> how the shrink callbacks work and whether they are applicable. Another 
> >> scheme would be to free, say 1MB when we have at least 2MB available.
> >>
> >> 2) We should avoid including AGP headers if AGP is not configured. 
> >> Either reimplement unmap_page_from_agp or map_page_into_agp or move them 
> >> out from the AGP headers. We've hade complaints before from people with 
> >> AGP free systems that the code doesn't compile.
> >>
> >> 3) Since we're allocating (and freeing) in batches we should use the 
> >> set_pages_array() interface to avoid a global tlb flush per page.
> >>
> >> 4) We could now skip the ttm_tt_populate() in ttm_tt_set_caching, since 
> >> it will always allocate cached pages and then transition them.
> >>
> >>     
> >
> > Okay 4) is bad, what happens (my brain is a bit meltdown so i might be
> > wrong) :
> > 1 - bo get allocated tt->state = unpopulated
> > 2 - bo is mapped few page are faulted tt->state = unpopulated
> > 3 - bo is cache transitioned but tt->state == unpopulated but
> >     they are page which have been touch by the cpu so we need
> >     to clflush them and transition them, 
> 
> Right.
> 
> > this never happen if
> >     we don't call ttm_tt_populate and proceed with the remaining
> >     of the cache transitioning functions
> >   
> 
> Why can't we just skip ttm_tt_populate and proceed with the remaining of 
> the cache transitioning functions? Then all pages currently allocated to 
> the TTM will be transitioned.
> 

Because not all tt->pages entry have valid page some are null and thus
we have to go through the whole table and transition page per page. I
did that and quick benchmark showed that it's faster to fully populate
and fully transition.

Cheers,
Jerome

