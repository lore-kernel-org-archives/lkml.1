Return-Path: <linux-kernel-owner+w=401wt.eu-S1760743AbYHFJXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760743AbYHFJXR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 05:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758463AbYHFJKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 05:10:08 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:55081 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756404AbYHFJKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 05:10:06 -0400
To: kamezawa.hiroyu@jp.fujitsu.com
Cc: linux-mm@kvack.org, menage@google.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl
Subject: Re: [PATCH][RFC] dirty balancing for cgroups
In-Reply-To: Your message of "Wed, 6 Aug 2008 17:53:52 +0900"
	<20080806175352.6330c00a.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080806175352.6330c00a.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Cue version 0.8 (080625-0732/takashi)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Message-Id: <20080806091005.B883A5A7B@siro.lan>
Date: Wed,  6 Aug 2008 18:10:05 +0900 (JST)
From: yamamoto@valinux.co.jp (YAMAMOTO Takashi)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

> On Wed,  6 Aug 2008 17:20:46 +0900 (JST)
> yamamoto@valinux.co.jp (YAMAMOTO Takashi) wrote:
> 
> > hi,
> > 
> > > On Fri, 11 Jul 2008 17:34:46 +0900 (JST)
> > > yamamoto@valinux.co.jp (YAMAMOTO Takashi) wrote:
> > > 
> > > > hi,
> > > > 
> > > > > > my patch penalizes heavy-writer cgroups as task_dirty_limit does
> > > > > > for heavy-writer tasks.  i don't think that it's necessary to be
> > > > > > tied to the memory subsystem because i merely want to group writers.
> > > > > > 
> > > > > Hmm, maybe what I need is different from this ;)
> > > > > Does not seem to be a help for memory reclaim under memcg.
> > > > 
> > > > to implement what you need, i think that we need to keep track of
> > > > the numbers of dirty-pages in each memory cgroups as a first step.
> > > > do you agree?
> > > > 
> > > yes, I think so, now.
> > > 
> > > may be not difficult but will add extra overhead ;( Sigh..
> > 
> > the following is a patch to add the overhead. :)
> > any comments?
> > 
> Do you have some numbers ? ;) 

not yet.

> I like this because this seems very straightforward. thank you.

good to hear.

> How about changing these to be
> 
> ==
> void mem_cgroup_test_set_page_dirty()
> {
> 	if (try_lock_page_cgroup(pg)) {
> 		pc = page_get_page_cgroup(pg);
> 		if (pc ......) {
> 		}
> 		unlock_page_cgroup(pg)
> 	}
> }
> ==

i'm not sure how many opportunities to update statistics
we would lose for the trylock failure.
although the statistics don't need to be too precise,
its error should have a reasonable upper-limit to be useful.

> Off-topic: I wonder we can delete this "lock" in future.
> 
> Because page->page_cgroup is
>  1. attached at first use.(Obiously no race with set_dirty)
>  2. deleted at removal. (force_empty is problematic here..)

i hope it's possible. :)

YAMAMOTO Takashi

> 
> But, now, we need this lock.
> 
> Thanks,
> -Kame
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
