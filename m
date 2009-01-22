Return-Path: <linux-kernel-owner+w=401wt.eu-S1756414AbZAVQOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756414AbZAVQOe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 11:14:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752333AbZAVQO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 11:14:26 -0500
Received: from mx2.redhat.com ([66.187.237.31]:36415 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751161AbZAVQOZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 11:14:25 -0500
Date: Thu, 22 Jan 2009 17:11:32 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] workqueue: don't alloc_percpu for single workqueue
Message-ID: <20090122161132.GA27250@redhat.com>
References: <4976EE0B.5090200@cn.fujitsu.com> <20090121121756.GA11942@redhat.com> <4977EB1C.4030405@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4977EB1C.4030405@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22, Lai Jiangshan wrote:
>
> Oleg Nesterov wrote:
> > On 01/21, Lai Jiangshan wrote:
> >> @@ -906,6 +907,13 @@ void destroy_workqueue(struct workqueue_struct *wq)
> >>  	const struct cpumask *cpu_map = wq_cpu_map(wq);
> >>  	int cpu;
> >>
> >> +	if (is_wq_single_threaded(wq)) {
> >> +		cleanup_workqueue_thread(wq->cpu_wq);
> >> +		kfree(wq->cpu_wq);
> >> +		kfree(wq);
> >> +		return;
> >> +	}
> >
> > again, not sure I understand why this change is needed. Afaics we
> > only need to use kfree(wq->cpu_wq) instead of free_percpu() if
> > it is single-threaded.
> >
>
> I think this change is needed.
> In the single thread case, we don't need
> 1) cpu_maps_update_begin(). --> require cpu_add_remove_lock
> 2) remove workqueue from the list. (we did not inserted it)
>
> It is indeed that there is no bad result occurred when we do these
> things for single thread. But I think the destroying should not
> do things more than the creating.

I disagree.

Firstly, this path is rare and not time critical, it is better
to save a couple of bytes from .text.

But mostly I dislike the fact that we add another special case
for the single-threaded wqs which is not strictly needed.

Following your logic we can also change flush_workqueue(), it
doesn't need for_each_cpu_mask_nr() when single-threaded.


That said, I agree this is a matter of taste, I won't persist.

Oleg.

