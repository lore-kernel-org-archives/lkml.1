Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933718Ab0BQADh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 19:03:37 -0500
Received: from smtp-out.google.com ([216.239.33.17]:47397 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933690Ab0BQADb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 19:03:31 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=xqDjW8wY6PqPzTeVvUzhtV+6SrvoDaktXv6HBvWLZGfGYu0c3/vO0Gh0Lq8211UjY
	siDIloQcBw6FJs9b5WJSw==
Date: Tue, 16 Feb 2010 16:03:23 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Nick Piggin <npiggin@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Lubos Lunak <l.lunak@suse.cz>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch -mm 8/9 v2] oom: avoid oom killer for lowmem
 allocations
In-Reply-To: <20100217084858.fd72ec4f.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1002161555170.11952@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1002151416470.26927@chino.kir.corp.google.com> <alpine.DEB.2.00.1002151419260.26927@chino.kir.corp.google.com> <20100216085706.c7af93e1.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.1002151606320.14484@chino.kir.corp.google.com>
 <20100216064402.GC5723@laptop> <alpine.DEB.2.00.1002152334260.7470@chino.kir.corp.google.com> <20100216075330.GJ5723@laptop> <alpine.DEB.2.00.1002160024370.15201@chino.kir.corp.google.com> <20100217084858.fd72ec4f.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Feb 2010, KAMEZAWA Hiroyuki wrote:

> > > > I'll add this check to __alloc_pages_may_oom() for the !(gfp_mask & 
> > > > __GFP_NOFAIL) path since we're all content with endlessly looping.
> > > 
> > > Thanks. Yes endlessly looping is far preferable to randomly oopsing
> > > or corrupting memory.
> > > 
> > 
> > Here's the new patch for your consideration.
> > 
> 
> Then, can we take kdump in this endlessly looping situaton ?
> 
> panic_on_oom=always + kdump can do that. 
> 

The endless loop is only helpful if something is going to free memory 
external to the current page allocation: either another task with 
__GFP_WAIT | __GFP_FS that invokes the oom killer, a task that frees 
memory, or a task that exits.

The most notable endless loop in the page allocator is the one when a task 
has been oom killed, gets access to memory reserves, and then cannot find 
a page for a __GFP_NOFAIL allocation:

	do {
		page = get_page_from_freelist(gfp_mask, nodemask, order,
			zonelist, high_zoneidx, ALLOC_NO_WATERMARKS,
			preferred_zone, migratetype);

		if (!page && gfp_mask & __GFP_NOFAIL)
			congestion_wait(BLK_RW_ASYNC, HZ/50);
	} while (!page && (gfp_mask & __GFP_NOFAIL));

We don't expect any such allocations to happen during the exit path, but 
we could probably find some in the fs layer.

I don't want to check sysctl_panic_on_oom in the page allocator because it 
would start panicking the machine unnecessarily for the integrity 
metadata GFP_NOIO | __GFP_NOFAIL allocation, for any 
order > PAGE_ALLOC_COSTLY_ORDER, or for users who can't lock the zonelist 
for oom kill that wouldn't have panicked before.
