Return-Path: <linux-kernel-owner+w=401wt.eu-S1756395AbZDWQY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756395AbZDWQY2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 12:24:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752622AbZDWQX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 12:23:58 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57350 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019AbZDWQX4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 12:23:56 -0400
Date: Thu, 23 Apr 2009 18:18:32 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Trond.Myklebust@netapp.com,
       serue@us.ibm.com, steved@redhat.com, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] slow_work_thread() should do the exclusive wait
Message-ID: <20090423161832.GA5646@redhat.com>
References: <20090415162712.342d4c07.akpm@linux-foundation.org> <1239649429.16771.9.camel@heimdal.trondhjem.org> <20090413181733.GA10424@redhat.com> <32260.1239658818@redhat.com> <20090413214852.GA1127@redhat.com> <1239659841.16771.26.camel@heimdal.trondhjem.org> <20090413222451.GA2758@redhat.com> <20712.1240502435@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20712.1240502435@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(add Ingo)

On 04/23, David Howells wrote:
>
> Andrew Morton <akpm@linux-foundation.org> wrote:
>
> > I wonder if slow_work_cull_timeout() should have some sort of barrier,
> > so the write is suitably visible to the woken thread.  Bearing in mind
> > that the thread might _already_ have been woken by someone else?
>
> Perhaps the attached patch?
>
> David
> ---
> From: David Howells <dhowells@redhat.com>
> Subject: [PATCH] slow_work_cull_timeout() should have a memory barrier
>
> slow_work_cull_timeout() should have a write memory barrier so that the setting
> of the cull flag is seen before the wakeup takes place.  This is required
> because wake_up() does not guarantee any memory barriership at all.
>
> Concomitant to this, slow_work_thread() should have a read memory barrier
> between its return from schedule() and its testing of slow_work_cull() as
> finish_wait() isn't a guaranteed barrier either.
>
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
>
>  kernel/slow-work.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
>
> diff --git a/kernel/slow-work.c b/kernel/slow-work.c
> index 521ed20..96e418d 100644
> --- a/kernel/slow-work.c
> +++ b/kernel/slow-work.c
> @@ -382,6 +382,7 @@ static int slow_work_thread(void *_data)
>  		finish_wait(&slow_work_thread_wq, &wait);
>
>  		try_to_freeze();
> +		smp_rmb();
>
>  		vsmax = vslow_work_proportion;
>  		vsmax *= atomic_read(&slow_work_thread_count);
> @@ -416,6 +417,7 @@ static int slow_work_thread(void *_data)
>  static void slow_work_cull_timeout(unsigned long data)
>  {
>  	slow_work_cull = true;
> +	smp_wmb();
>  	wake_up(&slow_work_thread_wq);
>  }

Confused. If we need this barrier, a lot of similar code is broken.

	slow_work_cull_timeout:

		slow_work_cull = true;
		wake_up(&slow_work_thread_wq);


	slow_work_thread:

		prepare_to_wait(&slow_work_thread_wq);
		if (!slow_work_cull)
			schedule();
		finish_wait(&slow_work_thread_wq);

		if (slow_work_cull)
			.....

Both wake_up() and prepare_to_wait() take the same wait_queue_head_t->lock,
and prepare_to_wait() does set_current_state() under this lock.

How can we miss the event? If wake_up() happens before prepare_to_wait(),
slow_work_thread() must see slow_work_cull = T, otherwise the subsequent
wake_up() must see the result of list_add() + set_current_state() and
wake up the sleeping thread.

Could you please clarify?

Oleg.

