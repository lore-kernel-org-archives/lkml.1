Return-Path: <linux-kernel-owner+w=401wt.eu-S1161870AbXECM7N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161870AbXECM7N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 08:59:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161878AbXECM7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 08:59:13 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:19253 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161870AbXECM7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 08:59:12 -0400
Date: Thu, 3 May 2007 13:58:52 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Andrea Arcangeli <andrea@suse.de>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: 2.6.22 -mm merge plans -- vm bugfixes
In-Reply-To: <4639D8E8.2090608@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0705031351180.29450@blonde.wat.veritas.com>
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
 <4636FDD7.9080401@yahoo.com.au> <Pine.LNX.4.64.0705011931520.16502@blonde.wat.veritas.com>
 <4638009E.3070408@yahoo.com.au> <Pine.LNX.4.64.0705021418030.16517@blonde.wat.veritas.com>
 <46393BA7.6030106@yahoo.com.au> <Pine.LNX.4.64.0705031306300.24945@blonde.wat.veritas.com>
 <4639D8E8.2090608@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 03 May 2007 12:59:08.0951 (UTC) FILETIME=[D6A15270:01C78D82]
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAABmluYm94AGFuZHJlYUBzdXNlLmRlAGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAYWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZwBsaW51eC1tbUBrdmFjay5vcmcAaGNoQGluZnJhZGVhZC5vcmcAbmlja3BpZ2dpbkB5YWhvby5jb20uYXUA
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 May 2007, Nick Piggin wrote:
> >>@@ -568,6 +570,11 @@ __lock_page (diff -p would tell us!)
> > > {
> > >  DEFINE_WAIT_BIT(wait, &page->flags, PG_locked);
> > >
> > >+	set_bit(PG_waiters, &page->flags);
> > >+	if (unlikely(!TestSetPageLocked(page))) {
> > 
> > What happens if another cpu is coming through __lock_page at the
> > same time, did its set_bit, now finds PageLocked, and so proceeds
> > to the __wait_on_bit_lock?  But this cpu now clears PG_waiters,
> > so this task's unlock_page won't wake the other?
> 
> You're right, we can't clear the bit here. Doubt it mattered much anyway?

Ah yes, that's a good easy answer.  In fact, just remove this whole
test and block (we already tried TestSetPageLocked outside just a
short while ago, so this repeat won't often save anything).

> 
> BTW. I also forgot an smp_mb__after_clear_bit() before the wake_up_page
> above... that barrier is in the slow path as well though, so it shouldn't
> matter either.

I vaguely wondered how such barriers had managed to dissolve away,
but cranking my brain up to think about barriers takes far too long.

> > >+		clear_bit(PG_waiters, &page->flags);
> > >+		return;
> > >+	}
> > >  __wait_on_bit_lock(page_waitqueue(page), &wait, sync_page,
> > >        TASK_UNINTERRUPTIBLE);
> >> }
