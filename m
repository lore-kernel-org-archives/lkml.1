Return-Path: <linux-kernel-owner+w=401wt.eu-S1754594AbYFLQxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594AbYFLQxv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 12:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752185AbYFLQxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 12:53:43 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:47670 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751657AbYFLQxn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 12:53:43 -0400
Date: Thu, 12 Jun 2008 20:55:50 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jarek Poplawski <jarkao2@o2.pl>, Max Krasnyansky <maxk@qualcomm.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] workqueues: insert_work: use "list_head *" instead of "int tail"
Message-ID: <20080612165550.GA12183@tv-sign.ru>
References: <20080612165120.GA12177@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080612165120.GA12177@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12, Oleg Nesterov wrote:
>
> insert_work() inserts the new work_struct before or after cwq->worklist,
> depending on the "int tail" parameter. Change it to accept "list_head *"
> instead, this shrinks .text a bit and allows us to insert the barrier
> after specific work_struct.

This allows us to implement

	int flush_work(struct work_struct *work)
	{
		struct cpu_workqueue_struct *cwq;
		struct list_head *head;
		struct wq_barrier barr;

		cwq = get_wq_data(work);
		if (!cwq)
			return 0;

		head = NULL;
		spin_lock_irq(&cwq->lock);
		if (!list_empty(&work->entry)) {
			smp_rmb();
			/*
			 * ---- FAT COMMENT ----
			 */
			if (cwq == get_wq_data(work))
				head = work->entry.next;
		} else if (cwq->current_work == work) {
			head = cwq->worklist.next;
		}

		if (head)
			insert_wq_barrier(cwq, &barr, head);
		spin_unlock_irq(&cwq->lock);

		if (!head)
			return 0;
		wait_for_completion(&barr.done);
		return 1;
	}

suggested by Peter. It only waits for selected work_struct.

I doubt it will have a lot of users though. In most cases we need
cancel_work_sync() and nothing more.

Oleg.

