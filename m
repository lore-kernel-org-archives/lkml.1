Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933714Ab0BQAGj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 19:06:39 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36746 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933683Ab0BQAGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 19:06:37 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 17 Feb 2010 09:03:03 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Cc: Nick Piggin <npiggin@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Lubos Lunak <l.lunak@suse.cz>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch -mm 8/9 v2] oom: avoid oom killer for lowmem allocations
Message-Id: <20100217090303.6bd64209.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.1002161555170.11952@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1002151416470.26927@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1002151419260.26927@chino.kir.corp.google.com>
	<20100216085706.c7af93e1.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.1002151606320.14484@chino.kir.corp.google.com>
	<20100216064402.GC5723@laptop>
	<alpine.DEB.2.00.1002152334260.7470@chino.kir.corp.google.com>
	<20100216075330.GJ5723@laptop>
	<alpine.DEB.2.00.1002160024370.15201@chino.kir.corp.google.com>
	<20100217084858.fd72ec4f.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.1002161555170.11952@chino.kir.corp.google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Feb 2010 16:03:23 -0800 (PST)
David Rientjes <rientjes@google.com> wrote:

> On Wed, 17 Feb 2010, KAMEZAWA Hiroyuki wrote:
> 
> > > > > I'll add this check to __alloc_pages_may_oom() for the !(gfp_mask & 
> > > > > __GFP_NOFAIL) path since we're all content with endlessly looping.
> > > > 
> > > > Thanks. Yes endlessly looping is far preferable to randomly oopsing
> > > > or corrupting memory.
> > > > 
> > > 
> > > Here's the new patch for your consideration.
> > > 
> > 
> > Then, can we take kdump in this endlessly looping situaton ?
> > 
> > panic_on_oom=always + kdump can do that. 
> > 
> 
> The endless loop is only helpful if something is going to free memory 
> external to the current page allocation: either another task with 
> __GFP_WAIT | __GFP_FS that invokes the oom killer, a task that frees 
> memory, or a task that exits.
> 
> The most notable endless loop in the page allocator is the one when a task 
> has been oom killed, gets access to memory reserves, and then cannot find 
> a page for a __GFP_NOFAIL allocation:
> 
> 	do {
> 		page = get_page_from_freelist(gfp_mask, nodemask, order,
> 			zonelist, high_zoneidx, ALLOC_NO_WATERMARKS,
> 			preferred_zone, migratetype);
> 
> 		if (!page && gfp_mask & __GFP_NOFAIL)
> 			congestion_wait(BLK_RW_ASYNC, HZ/50);
> 	} while (!page && (gfp_mask & __GFP_NOFAIL));
> 
> We don't expect any such allocations to happen during the exit path, but 
> we could probably find some in the fs layer.
> 
> I don't want to check sysctl_panic_on_oom in the page allocator because it 
> would start panicking the machine unnecessarily for the integrity 
> metadata GFP_NOIO | __GFP_NOFAIL allocation, for any 
> order > PAGE_ALLOC_COSTLY_ORDER, or for users who can't lock the zonelist 
> for oom kill that wouldn't have panicked before.
> 

Then, why don't you check higzone_idx in oom_kill.c

Thanks,
-Kame

