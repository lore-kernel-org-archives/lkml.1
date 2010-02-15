Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915Ab0BOWB0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 17:01:26 -0500
Received: from smtp-out.google.com ([216.239.33.17]:37425 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969Ab0BOWBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 17:01:25 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=aw+ECgdruxXKSlON0eF1v3ehcFXIn/jmHBrnQ95pjRfg3HfUW5B/2/JLADJotK8b0
	RHUfRL8/d25IwzikADsFg==
Date: Mon, 15 Feb 2010 14:01:17 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Lubos Lunak <l.lunak@suse.cz>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 6/7 -mm] oom: avoid oom killer for lowmem allocations
In-Reply-To: <20100215090949.169f2819.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1002151355000.26927@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1002100224210.8001@chino.kir.corp.google.com> <alpine.DEB.2.00.1002100229410.8001@chino.kir.corp.google.com> <20100212102841.fa148baf.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.1002120200050.22883@chino.kir.corp.google.com>
 <20100215090949.169f2819.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Feb 2010, KAMEZAWA Hiroyuki wrote:

> > I can't agree with that assessment, I don't think it's a desired result to 
> > ever panic the machine regardless of what /proc/sys/vm/panic_on_oom is set 
> > to because a lowmem page allocation fails especially considering, as 
> > mentioned in the changelog, these allocations are never __GFP_NOFAIL and 
> > returning NULL is acceptable.
> > 
> please add
>   WARN_ON((high_zoneidx < ZONE_NORMAL) && (gfp_mask & __GFP_NOFAIL))
> somewhere. Then, it seems your patch makes sense.
> 

high_zoneidx < ZONE_NORMAL is not the only case where this exists: it 
exists for __GFP_NOFAIL allocations that are not __GFP_FS as well and has 
for years, no special handling is now needed.

There should be no cases of either (GFP_DMA | __GFP_NOFAIL, or
GFP_NOFS | __GFP_NOFAIL) in my audit of the kernel code.  And since 
__GFP_NOFAIL is not to be added anymore (see Andrew's dab48dab), there's 
no real reason to add a WARN_ON() here.

> I don't like the "possibility" of inifinte loops.
> 

The possibility of infinite loops has always existed in the page allocator 
for __GFP_NOFAIL allocations, that's precisely why it's deprecated and 
eventually we seek to remove it.
