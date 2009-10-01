Return-Path: <linux-kernel-owner+w=401wt.eu-S1752551AbZJAVJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551AbZJAVJ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 17:09:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752106AbZJAVJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 17:09:57 -0400
Received: from smtp-out.google.com ([216.239.33.17]:48765 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842AbZJAVJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 17:09:56 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=pAbfwTi5cgDWI3ei0i1+F9cVy1h+TMUst1E2pYhwkKFhrUdtSaNku1rPsSW6viru6
	FjYNLCTc3QJ4/mi24vWMg==
Date: Thu, 1 Oct 2009 14:09:54 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Suresh Jayaraman <sjayaraman@suse.de>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org, Neil Brown <neilb@suse.de>,
       Miklos Szeredi <mszeredi@suse.cz>, Wouter Verhelst <w@uter.be>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, trond.myklebust@fys.uio.no
Subject: Re: [PATCH 04/31] mm: tag reseve pages
In-Reply-To: <1254405917-15796-1-git-send-email-sjayaraman@suse.de>
Message-ID: <alpine.DEB.1.00.0910011407390.32006@chino.kir.corp.google.com>
References: <1254405917-15796-1-git-send-email-sjayaraman@suse.de>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Oct 2009, Suresh Jayaraman wrote:

> Index: mmotm/mm/page_alloc.c
> ===================================================================
> --- mmotm.orig/mm/page_alloc.c
> +++ mmotm/mm/page_alloc.c
> @@ -1501,8 +1501,10 @@ zonelist_scan:
>  try_this_zone:
>  		page = buffered_rmqueue(preferred_zone, zone, order,
>  						gfp_mask, migratetype);
> -		if (page)
> +		if (page) {
> +			page->reserve = !!(alloc_flags & ALLOC_NO_WATERMARKS);
>  			break;
> +		}
>  this_zone_full:
>  		if (NUMA_BUILD)
>  			zlc_mark_zone_full(zonelist, z);

page->reserve won't necessary indicate that access to reserves was 
_necessary_ for the allocation to succeed, though.  This will mark any 
page being allocated under PF_MEMALLOC as reserve when all zones may be 
well above their min watermarks.

