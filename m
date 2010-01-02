Return-Path: <linux-kernel-owner+w=401wt.eu-S1752666Ab0ABKrG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab0ABKrG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 05:47:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599Ab0ABKrE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 05:47:04 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:59451 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214Ab0ABKrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 05:47:03 -0500
Subject: Re: [PATCH] mm, lockdep: annotate reclaim context to zone reclaim
 too
From: Peter Zijlstra <peterz@infradead.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <2f11576a1001012121o4f09d30n6dba925e74099da1@mail.gmail.com>
References: <1262339141-4682-1-git-send-email-kosaki.motohiro@jp.fujitsu.com>
	 <1262387986.16572.234.camel@laptop>
	 <2f11576a1001012121o4f09d30n6dba925e74099da1@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 02 Jan 2010 11:46:06 +0100
Message-ID: <1262429166.32223.32.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-01-02 at 14:21 +0900, KOSAKI Motohiro wrote:
> 2010/1/2 Peter Zijlstra <peterz@infradead.org>:
> > On Fri, 2010-01-01 at 18:45 +0900, KOSAKI Motohiro wrote:
> >> Commit cf40bd16fd (lockdep: annotate reclaim context) introduced reclaim
> >> context annotation. But it didn't annotate zone reclaim. This patch do it.
> >
> > And yet you didn't CC anyone involved in that patch, nor explain why you
> > think it necessary, massive FAIL.
> >
> > The lockdep annotations cover all of kswapd() and direct reclaim through
> > __alloc_pages_direct_reclaim(). So why would you need an explicit
> > annotation in __zone_reclaim()?
> 
> Thanks CCing. The point is zone-reclaim doesn't use
> __alloc_pages_direct_reclaim.
> current call graph is
> 
> __alloc_pages_nodemask
>     get_page_from_freelist
>         zone_reclaim()
>     __alloc_pages_slowpath
>         __alloc_pages_direct_reclaim
>             try_to_free_pages
> 
> Actually, if zone_reclaim_mode=1, VM never call
> __alloc_pages_direct_reclaim in usual VM pressure.
> Thus I think zone-reclaim should be annotated explicitly too.
> I know almost user don't use zone reclaim mode. but explicit
> annotation doesn't have any demerit, I think.

Just be aware that the annotation isn't recursive, I'd have to trace all
calls to __zone_reclaim, but if kswapd were ever to call it you'd just
wrecked things by getting lockdep_clear_current_reclaim_state() called.

So just make sure you don't shorten the existing notations by adding it
here. Other than that it seems ok.

