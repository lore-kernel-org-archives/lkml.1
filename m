Return-Path: <linux-kernel-owner+w=401wt.eu-S964931AbXBTOXG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964931AbXBTOXG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 09:23:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964936AbXBTOXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 09:23:06 -0500
Received: from mail.screens.ru ([213.234.233.54]:45589 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964931AbXBTOXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 09:23:05 -0500
Date: Tue, 20 Feb 2007 17:22:57 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       akpm@linux-foundation.org, Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH] fix handling of SIGCHILD from reaped child
Message-ID: <20070220142257.GA155@tv-sign.ru>
References: <20070220183220.41b3f1ca.kamezawa.hiroyu@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070220183220.41b3f1ca.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20, KAMEZAWA Hiroyuki wrote:
>
> SUSv3 says
> ==
> if SIGCHLD is blocked, if wait() or waitpid() return because the status of a
> child process is available, any pending SIGCHLD signal shall be cleared unless
> the status of another child process is available.
> ==

Ingo, Roland, should we implement this?

I must admit, I don't understand the text above, "blocked" is per-thread, but
wait() is process wide (any sub-thread can reap a dead child).

> -static int collect_signal(int sig, struct sigpending *list, siginfo_t *info)
> +static int collect_signal(int sig, struct sigpending *list, siginfo_t *info, pid_t checkpid)
>  {
> -	list_for_each_entry(q, &list->list, list) {
> -		if (q->info.si_signo == sig) {
> -			if (first) {
> -				still_pending = 1;
> -				break;
> +	if (unlikely(checkpid)) {
> +		list_for_each_entry(q, &list->list, list) {
> +			if (q->info.si_signo == sig) {
> +			    if (q->info.si_pid == checkpid)
> +					first = q;
> +				else
> +					still_pending = 1;
> +			}
> +		}
> +	} else {
> +		list_for_each_entry(q, &list->list, list) {
> +			if (q->info.si_signo == sig) {
> +				if (first) {
> +					still_pending = 1;
> +					break;
> +				}
> +				first = q;
>  			}
> -			first = q;

I'd suggest to make a separate function, but not complicate collect_signal().

> --- linux-2.6.20-devel.orig/kernel/exit.c
> +++ linux-2.6.20-devel/kernel/exit.c
> @@ -1252,8 +1252,12 @@ static int wait_task_zombie(struct task_
>  		}
>  		write_unlock_irq(&tasklist_lock);
>  	}
> -	if (p != NULL)
> +	if (p != NULL) {
>  		release_task(p);
> +		/* if we received sigchild from "p" and p is released,
> +		   we remove sigchild from it. */

current may be ptracer, not a parent. Should be ok, clear_stale_sigchild(pid)
can't have a false positive (until we have namespace for pid_t), but the comment
is misleading a bit.

> +		clear_stale_sigchild(current, retval);

But we are not checking that SIGCHLD is blocked?

Oleg.

