Return-Path: <linux-kernel-owner+w=401wt.eu-S932425AbZACSB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932425AbZACSB2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 13:01:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759118AbZACSBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 13:01:19 -0500
Received: from mx2.redhat.com ([66.187.237.31]:45098 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758339AbZACSBS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 13:01:18 -0500
Date: Sat, 3 Jan 2009 18:59:13 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Jiri Pirko <jpirko@redhat.com>, linux-kernel@vger.kernel.org,
       Hugh Dickins <hugh@veritas.com>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH for -mm] getrusage: fill ru_maxrss value
Message-ID: <20090103175913.GA21180@redhat.com>
References: <20081230201052.128B.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081231110816.5f80e265@psychotron.englab.brq.redhat.com> <20081231213705.1293.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081231213705.1293.KOSAKI.MOTOHIRO@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sorry for delay!

On 12/31, KOSAKI Motohiro wrote:
>
> Jiri's resend3 -> v1
>  - At wait_task_zombie(), parent process doesn't only collect child maxrss,
>    but also cmaxrss.

Ah yes, this looks very right to me.

>  - ru_maxrss inherit at exec()

I must admit, I hate this ;)

That said, I agree with you point about compatibility. So I have to
agree with this change.

Still, I'd like to know what other people think ;)

And I also agree that xacct is linux specific feature, but I still
I dislike the fact that xacct and getrusage report different numbers.
Perhaps we should change xacct as well?

> --- a/kernel/exit.c	2008-12-29 23:27:59.000000000 +0900
> +++ b/kernel/exit.c	2008-12-31 21:08:08.000000000 +0900
> @@ -1053,6 +1053,12 @@ NORET_TYPE void do_exit(long code)
>  	if (group_dead) {
>  		hrtimer_cancel(&tsk->signal->real_timer);
>  		exit_itimers(tsk->signal);
> +		if (tsk->mm) {
> +			unsigned long hiwater_rss = get_mm_hiwater_rss(tsk->mm);
> +
> +			if (tsk->signal->maxrss < hiwater_rss)
> +				tsk->signal->maxrss = hiwater_rss;
> +		}
[...snip...]
> --- a/fs/exec.c	2008-12-25 08:26:37.000000000 +0900
> +++ b/fs/exec.c	2008-12-31 21:11:28.000000000 +0900
> @@ -870,6 +870,13 @@ static int de_thread(struct task_struct 
>  	sig->notify_count = 0;
>
>  no_thread_group:
> +	if (current->mm) {
> +		unsigned long hiwater_rss = get_mm_hiwater_rss(current->mm);
> +
> +		if (sig->maxrss < hiwater_rss)
> +			sig->maxrss = hiwater_rss;
> +	}

Perhaps it makes sense to factor out this code and make a helper?

Unfortunately, exit_mm() and exec_mmap() do not have the common
path which can update sig->maxrss, mm_release() can't do this...

> +	if (who != RUSAGE_CHILDREN) {
> +		struct mm_struct *mm = get_task_mm(p);
> +		if (mm) {
> +			unsigned long hiwater_rss = get_mm_hiwater_rss(mm);
> +
> +			if (maxrss < hiwater_rss)
> +				maxrss = hiwater_rss;
> +			mmput(mm);
> +		}
> +	}
> +	r->ru_maxrss = maxrss * (PAGE_SIZE / 1024); /* convert pages to KBs */

Hmm... So, RUSAGE_THREAD always report maxrss == get_mm_hiwater_rss(mm)
and ignores signal->maxrss. Doesn't look right to me...

Unless I missed something, Jiris's patch was fine, but given that now
we inherit maxrss at exec(), signal->maxrss can have the "inherited"
value?

Oleg.

