Return-Path: <linux-kernel-owner+w=401wt.eu-S1761717AbZANOq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761717AbZANOq0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 09:46:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752853AbZANOqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 09:46:17 -0500
Received: from ti-out-0910.google.com ([209.85.142.184]:59976 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623AbZANOqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 09:46:16 -0500
Date: Wed, 14 Jan 2009 15:46:02 +0100
From: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org, dst@ioremap.net
Subject: Re: [4/7] dst: thread pool.
Message-ID: <20090114144602.GG10720@gambetta>
References: <1231887933-17843-1-git-send-email-zbr@ioremap.net> <1231887933-17843-2-git-send-email-zbr@ioremap.net> <1231887933-17843-3-git-send-email-zbr@ioremap.net> <1231887933-17843-4-git-send-email-zbr@ioremap.net> <1231887933-17843-5-git-send-email-zbr@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231887933-17843-5-git-send-email-zbr@ioremap.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Evgeniy,

On Wed, Jan 14, 2009 at 02:05:30AM +0300, Evgeniy Polyakov wrote:
[...]
> +void thread_pool_del_worker(struct thread_pool *p)
> +{
> +	struct thread_pool_worker *w = NULL;
> +
> +	while (!w) {
> +		wait_event(p->wait, !list_empty(&p->ready_list) || !p->thread_num);
								   ^^^^^^^^^^^^^^
What's the purpose of !p->thread_num here? Is there an exit case missing
in the loop below?

> +
> +		dprintk("%s: locking list_empty: %d, thread_num: %d.\n",
> +				__func__, list_empty(&p->ready_list), p->thread_num);
> +
> +		mutex_lock(&p->thread_lock);
> +		if (!list_empty(&p->ready_list)) {
> +			w = list_first_entry(&p->ready_list,
> +					struct thread_pool_worker,
> +					worker_entry);
> +
> +			dprintk("%s: deleting w: %p, thread_num: %d, list: %p [%p.%p].\n",
> +					__func__, w, p->thread_num, &p->ready_list,
> +					p->ready_list.prev, p->ready_list.next);
> +
> +			p->thread_num--;
> +			list_del(&w->worker_entry);
> +		}
> +		mutex_unlock(&p->thread_lock);
> +	}
> +
> +	if (w)
> +		thread_pool_exit_worker(w);
> +	dprintk("%s: deleted w: %p, thread_num: %d.\n",
> +			__func__, w, p->thread_num);
> +}
