Return-Path: <linux-kernel-owner+w=401wt.eu-S1759610AbYFJVnK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759610AbYFJVnK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 17:43:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755124AbYFJVm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 17:42:57 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:20157 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010AbYFJVm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 17:42:56 -0400
Subject: Re: [PATCH -mm 17/25] Mlocked Pages are non-reclaimable
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Rik van Riel <riel@redhat.com>
Cc: Nick Piggin <npiggin@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, kosaki.motohiro@jp.fujitsu.com,
       linux-mm@kvack.org, eric.whitney@hp.com
In-Reply-To: <20080610171400.149886cf@cuia.bos.redhat.com>
References: <20080606202838.390050172@redhat.com>
	 <20080606202859.522708682@redhat.com>
	 <20080606180746.6c2b5288.akpm@linux-foundation.org>
	 <20080610033130.GK19404@wotan.suse.de>
	 <20080610171400.149886cf@cuia.bos.redhat.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Tue, 10 Jun 2008 17:43:17 -0400
Message-Id: <1213134197.6872.49.camel@lts-notebook>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-06-10 at 17:14 -0400, Rik van Riel wrote:
> On Tue, 10 Jun 2008 05:31:30 +0200
> Nick Piggin <npiggin@suse.de> wrote:
> 
> > If we eventually run out of page flags on 32 bit, then sure this might be
> > one we could look at geting rid of. Once the code has proven itself.
> 
> Yes, after the code has proven stable, we can probably get
> rid of the PG_mlocked bit and use only PG_unevictable to mark
> these pages.
> 
> Lee, Kosaki-san, do you see any problem with that approach?
> Is the PG_mlocked bit really necessary for non-debugging
> purposes?
> 

Well, it does speed up the check for mlocked pages in page_reclaimable()
[now page_evictable()?] as we don't have to walk the reverse map to
determine that a page is mlocked.   In many places where we currently
test page_reclaimable(), we really don't want to and maybe can't walk
the reverse map.

Unless you're evisioning even larger rework, the PG_unevictable flag
[formerly PG_noreclaim, right?] is analogous to PG_active.  It's only
set when the page is on the corresponding lru list or being held
isolated from it, temporarily.  See isolate_lru_page() and
putback_lru_page() and users thereof--such as mlock_vma_page().  Again,
I have seen what changes you're making here, so maybe that's all
changing.  But, currently, PG_unevictable would not be a replacement for
PG_mlocked.

Anyway, let's see what you come up with before we tackle this.

Couple of related items:

+ 26-rc5-mm1 + a small fix to the double unlock_page() in
shrink_page_list() has been running for a couple of hours on my 32G,
16cpu ia64 numa platform w/o error.  Seems to have survived the merge
into -mm, despite the issues Andrew has raised.

+ on same platform, Mel Gorman's mminit debug code is reporting that
we're using 22 page flags with Noreclaim, Mlock and PAGEFLAGS_EXTENDED
configured.

Lee

