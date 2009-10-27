Return-Path: <linux-kernel-owner+w=401wt.eu-S932411AbZJ0VMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932411AbZJ0VMl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 17:12:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932391AbZJ0VMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 17:12:41 -0400
Received: from smtp-out.google.com ([216.239.33.17]:14331 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932265AbZJ0VMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 17:12:40 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=P+V3h/hL8Lxe9BGMVU2E3yn8NHaZywdLIfPfG3oKWYV4fYPSKtUGoi9rm56XU5dQo
	WjSHCnuQPFn951HBkcIFg==
Date: Tue, 27 Oct 2009 14:12:36 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Mel Gorman <mel@csn.ul.ie>, stable@kernel.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Frans Pop <elendil@planet.nl>, Jiri Kosina <jkosina@suse.cz>,
       Sven Geggus <lists@fuchsschwanzdomain.de>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Tobias Oetiker <tobi@oetiker.ch>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       kernel-testers@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 2/3] page allocator: Do not allow interrupts to use
 ALLOC_HARDER
In-Reply-To: <20091027130924.fa903f5a.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.0910271411530.9183@chino.kir.corp.google.com>
References: <1256650833-15516-1-git-send-email-mel@csn.ul.ie> <1256650833-15516-3-git-send-email-mel@csn.ul.ie> <20091027130924.fa903f5a.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Oct 2009, Andrew Morton wrote:

> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index dfa4362..7f2aa3e 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -1769,7 +1769,7 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
> >  		 * See also cpuset_zone_allowed() comment in kernel/cpuset.c.
> >  		 */
> >  		alloc_flags &= ~ALLOC_CPUSET;
> > -	} else if (unlikely(rt_task(p)))
> > +	} else if (unlikely(rt_task(p)) && !in_interrupt())
> >  		alloc_flags |= ALLOC_HARDER;
> >  
> >  	if (likely(!(gfp_mask & __GFP_NOMEMALLOC))) {
> 
> What are the runtime-observeable effects of this change?
> 

Giving rt tasks access to memory reserves is necessary to reduce latency, 
the privilege does not apply to interrupts that subsequently get run on 
the same cpu.

> The description is a bit waffly-sounding for a -stable backportable
> thing, IMO.  What reason do the -stable maintainers and users have to
> believe that this patch is needed, and an improvement?
> 

Allowing interrupts to allocate below the low watermark when not 
GFP_ATOMIC depletes memory reserves; this fixes an inconsistency 
introduced by the page allocator refactoring patchset that went into 
2.6.31.
