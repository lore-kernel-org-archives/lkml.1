Return-Path: <linux-kernel-owner+w=401wt.eu-S1755042AbYFLRBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755042AbYFLRBb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 13:01:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752512AbYFLRBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 13:01:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:38503 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376AbYFLRBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 13:01:23 -0400
Subject: Re: [PATCH] workqueues: insert_work: use "list_head *" instead of
	"int tail"
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jarek Poplawski <jarkao2@o2.pl>,
       Max Krasnyansky <maxk@qualcomm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20080612165550.GA12183@tv-sign.ru>
References: <20080612165120.GA12177@tv-sign.ru>
	 <20080612165550.GA12183@tv-sign.ru>
Content-Type: text/plain
Date: Thu, 12 Jun 2008 19:01:14 +0200
Message-Id: <1213290074.31518.136.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-06-12 at 20:55 +0400, Oleg Nesterov wrote:
> On 06/12, Oleg Nesterov wrote:
> >
> > insert_work() inserts the new work_struct before or after cwq->worklist,
> > depending on the "int tail" parameter. Change it to accept "list_head *"
> > instead, this shrinks .text a bit and allows us to insert the barrier
> > after specific work_struct.
> 
> This allows us to implement
> 
> 	int flush_work(struct work_struct *work)
> 	{
> 		struct cpu_workqueue_struct *cwq;
> 		struct list_head *head;
> 		struct wq_barrier barr;
> 
> 		cwq = get_wq_data(work);
> 		if (!cwq)
> 			return 0;
> 
> 		head = NULL;
> 		spin_lock_irq(&cwq->lock);
> 		if (!list_empty(&work->entry)) {
> 			smp_rmb();
> 			/*
> 			 * ---- FAT COMMENT ----
> 			 */
> 			if (cwq == get_wq_data(work))
> 				head = work->entry.next;
> 		} else if (cwq->current_work == work) {
> 			head = cwq->worklist.next;
> 		}
> 
> 		if (head)
> 			insert_wq_barrier(cwq, &barr, head);
> 		spin_unlock_irq(&cwq->lock);
> 
> 		if (!head)
> 			return 0;
> 		wait_for_completion(&barr.done);
> 		return 1;
> 	}
> 
> suggested by Peter. It only waits for selected work_struct.
> 
> I doubt it will have a lot of users though. In most cases we need
> cancel_work_sync() and nothing more.

Are there cases where we dynamically allocate work structs and queue
them and then forget about them? In such cases we'd need something a
little more complex as we don't have work pointers to flush or cancel.

Hence that idea of flush context and completions.

Aside from that, this seems like a fine idea. :-)

