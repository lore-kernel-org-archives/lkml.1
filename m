Return-Path: <linux-kernel-owner+w=401wt.eu-S1753823AbZEHNh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823AbZEHNh3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 09:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752430AbZEHNhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 09:37:13 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:31354 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229AbZEHNhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 09:37:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZyycgDuZ89FnYLIdEGeHU0TFaPldpGWd4PksuVqzHoyftXuVOLgzj5qZjjvGfzWbdn
         lgQF9f/79Q4+1ubCKdtU5Hr62hbiYHgFS8jsXQnAHtABv40he8p/vXmJPYwpauMyP1vb
         16MBnrv9/uAFoFVzANVm07bSUBto0QoLeEOWE=
Date: Fri, 8 May 2009 17:37:04 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Andrew Morton <akpm@linux-foundation.org>, cl@linux.com, mingo@elte.hu,
       mel@csn.ul.ie, linux-kernel@vger.kernel.org, riel@redhat.com,
       rientjes@google.com, xemul@openvz.org
Subject: Re: [RFC/PATCH v2] mm: Introduce GFP_PANIC for non-failing
	allocations
Message-ID: <20090508133704.GE6132@lenovo>
References: <20090504122740.GH4173@lenovo> <20090504131311.GA23330@elte.hu> <20090504131638.GJ4173@lenovo> <alpine.DEB.1.10.0905040940490.9553@qirst.com> <20090504115335.9bc08587.akpm@linux-foundation.org> <20090504192117.GB31176@lenovo> <20090504123453.d130a6cf.akpm@linux-foundation.org> <20090504200925.GD31176@lenovo> <1241787448.28600.26.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241787448.28600.26.camel@penberg-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Pekka Enberg - Fri, May 08, 2009 at 03:57:28PM +0300]
| From: Cyrill Gorcunov <gorcunov@openvz.org>
| 
| This patch introduces a GFP_PANIC flag that can be used as an annotation
| that a call to kmalloc() or alloc_pages() is expected to never fail.
| This is useful in early boot code, for example.
| 
| To save one GFP flag bit, use a combination of __GFP_NOFAIL,
| __GFP_NOREPEAT, and __GFP_NOMEMALLOC to make sure we always end up in
| the "nopage" path of the page allocator if an allocation fails.
| 
| Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
| Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
| ---
| Yes, this is totally untested and needs to be rebased on top of -mm.
| 
|  include/linux/gfp.h |    1 +
|  mm/page_alloc.c     |    3 +++
|  2 files changed, 4 insertions(+), 0 deletions(-)
| 
| diff --git a/include/linux/gfp.h b/include/linux/gfp.h
| index 0bbc15f..c7c8a63 100644
| --- a/include/linux/gfp.h
| +++ b/include/linux/gfp.h
| @@ -70,6 +70,7 @@ struct vm_area_struct;
|  #define GFP_HIGHUSER_MOVABLE	(__GFP_WAIT | __GFP_IO | __GFP_FS | \
|  				 __GFP_HARDWALL | __GFP_HIGHMEM | \
|  				 __GFP_MOVABLE)
| +#define GFP_PANIC	(__GFP_NOFAIL | __GFP_NORETRY | __GFP_NOMEMALLOC)
|  
|  #ifdef CONFIG_NUMA
|  #define GFP_THISNODE	(__GFP_THISNODE | __GFP_NOWARN | __GFP_NORETRY)
| diff --git a/mm/page_alloc.c b/mm/page_alloc.c
| index e2f2699..4b062e5 100644
| --- a/mm/page_alloc.c
| +++ b/mm/page_alloc.c
| @@ -1670,6 +1670,9 @@ nopage:
|  		dump_stack();
|  		show_mem();
|  	}
| +	if (unlikely(gfp_mask & GFP_PANIC))
| +		panic("Out of memory: %s order: %d, gfp_mask:0x%x\n",
| +			p->comm, order, gfp_mask);
|  got_pg:
|  	return page;
|  }
| -- 
| 1.5.6.3
|

Thanks Pekka! At moment it's usefull for x86 uv_system_init (3 times)
for early boot code. Plain panic_on_null (suggested by Andrew) could
be usefull as well but would lead to additional wrapper around kmalloc
which is already inlined. Which means -- at moment we have those cases
handled by BUG_ON but having one common option would be better I guess
(ie have an ability to say page allocator that just do panic on fail).

Anyway, if there is still objections on such an approach (even having
gpf bits saved by elegant way Pekka suggested) -- I'm fine with having
those BUG_ONs instead of short and gracious GFP_PANIC :)

	-- Cyrill
