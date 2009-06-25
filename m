Return-Path: <linux-kernel-owner+w=401wt.eu-S1758362AbZFYPxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758362AbZFYPxs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 11:53:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754048AbZFYPxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 11:53:40 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:48308 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752580AbZFYPxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 11:53:40 -0400
Message-ID: <4A439D7D.9030401@shipmail.org>
Date: Thu, 25 Jun 2009 17:53:33 +0200
From: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@shipmail.org>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Jerome Glisse <glisse@freedesktop.org>
CC: Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Subject: Re: TTM page pool allocator
References: <1245931298.13359.8.camel@localhost.localdomain>
In-Reply-To: <1245931298.13359.8.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jerome Glisse skrev:
> Hi,
>
> Thomas i attach a reworked page pool allocator based on Dave works,
> this one should be ok with ttm cache status tracking. It definitely
> helps on AGP system, now the bottleneck is in mesa vertex's dma
> allocation.
>
> Cheers,
> Jerome
>   
Hi, Jerome!
In general it looks very good. Some things that need fixing:

1)  We must have a way to hand back pages. I still not quite understand 
how the shrink callbacks work and whether they are applicable. Another 
scheme would be to free, say 1MB when we have at least 2MB available.

2) We should avoid including AGP headers if AGP is not configured. 
Either reimplement unmap_page_from_agp or map_page_into_agp or move them 
out from the AGP headers. We've hade complaints before from people with 
AGP free systems that the code doesn't compile.

3) Since we're allocating (and freeing) in batches we should use the 
set_pages_array() interface to avoid a global tlb flush per page.

4) We could now skip the ttm_tt_populate() in ttm_tt_set_caching, since 
it will always allocate cached pages and then transition them.

5) Use TTM_PFX in printouts.

/Thomas



