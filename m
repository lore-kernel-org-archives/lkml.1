Return-Path: <linux-kernel-owner+w=401wt.eu-S1757244AbZAVJxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244AbZAVJxS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 04:53:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754426AbZAVJxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 04:53:04 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:52067 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754158AbZAVJxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 04:53:01 -0500
Subject: Re: [PATCH] workqueue: not allow recursion run_workqueue
From: Peter Zijlstra <peterz@infradead.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <49780C3A.1050601@cn.fujitsu.com>
References: <4976EE11.7010007@cn.fujitsu.com>
	 <1232536373.4847.115.camel@laptop>  <49780C3A.1050601@cn.fujitsu.com>
Content-Type: text/plain
Date: Thu, 22 Jan 2009 10:52:45 +0100
Message-Id: <1232617965.4890.110.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-22 at 14:03 +0800, Lai Jiangshan wrote:
> 
> void do_some_cleanup(void)
> {
>         find_all_queued_work_struct_and_mark_it_old();
>         flush_workqueue(workqueue);
>         /* we can destroy old work_struct for we have flushed them */
>         destroy_old_work_structs();
> }
> 
> if work->func() called do_some_cleanup(), it's very probably a bug.

Of course it is, if only because calling flush on the same workqueue is
pretty dumb.

But I'm still not getting it, flush_workqueue() provides the guarantee
that all work enqueued previous to the call will be finished thereafter.

The self-flush stuff you propose to rip out doesn't violate that
guarantee afaict.

Suppose we have a workqueue Q, with pending work W1..Wn.

Suppose W5 will have the nested flush, it will then recursively complete
W6..Wn+i, where i accounts for any concurrent worklet additions.

Therefore it will have completed (at least) those worklets that were
enqueued at the time flush got called.

So, to get back at your changelog.

 1) yes lockdep will complain -- for good reasons, and I'm all for
getting rid of this mis-feature.

 2) I've no clue what you're on about

 3) more mystery.



