Return-Path: <linux-kernel-owner+w=401wt.eu-S1762392AbZAQV4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762392AbZAQV4R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 16:56:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753173AbZAQVz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 16:55:59 -0500
Received: from mx2.redhat.com ([66.187.237.31]:58696 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753135AbZAQVz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 16:55:59 -0500
Date: Sat, 17 Jan 2009 22:51:10 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Chris Mason <chris.mason@oracle.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Matthew Wilcox <matthew@wil.cx>,
       Chuck Lever <cel@citi.umich.edu>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: + lock_page_killable-avoid-lost-wakeups.patch added to -mm tree
Message-ID: <20090117215110.GA3300@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think the patch is correct, just a question,

>  int __lock_page_killable(struct page *page)
>  {
>  	DEFINE_WAIT_BIT(wait, &page->flags, PG_locked);
> +	int ret;
>
> -	return __wait_on_bit_lock(page_waitqueue(page), &wait,
> +	ret = __wait_on_bit_lock(page_waitqueue(page), &wait,
>  					sync_page_killable, TASK_KILLABLE);
> +	/*
> +	 * wait_on_bit_lock uses prepare_to_wait_exclusive, so if multiple
> +	 * procs were waiting on this page, we were the only proc woken up.
> +	 *
> +	 * if ret != 0, we didn't actually get the lock.  We need to
> +	 * make sure any other waiters don't sleep forever.
> +	 */
> +	if (ret)
> +		wake_up_page(page, PG_locked);

This patch assumes that nobody else calls __wait_on_bit_lock() with
action which can return !0. Currently this is correct, but perhaps
it makes sense to move this wake_up_page() into __wait_on_bit_lock ?

Note that we need to "transfer" the wakeup only if wake_up_page()
has already removed us from page_waitqueue(page), this means we
don't need to check ret != 0 twice in __wait_on_bit_lock(), afaics
we can do

	if ((ret = (*action)(q->key.flags))) {
		__wake_up_bit(wq, q->key.flags, q->key.bit_nr);
		// or just __wake_up(wq, TASK_NORMAL, 1, &q->key);
		break;
	}

IOW, imho __wait_on_bit_lock() is buggy, not __lock_page_killable(),
no?

Oleg.

