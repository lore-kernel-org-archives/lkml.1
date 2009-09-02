Return-Path: <linux-kernel-owner+w=401wt.eu-S1752296AbZIBNyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296AbZIBNyl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 09:54:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752131AbZIBNyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 09:54:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54350 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778AbZIBNyk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 09:54:40 -0400
Date: Wed, 2 Sep 2009 15:50:24 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: akpm@linux-foundation.org, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] core: allow setrlimit to non-current tasks
Message-ID: <20090902135024.GA6452@redhat.com>
References: <1251884703-14523-1-git-send-email-jirislaby@gmail.com> <1251884703-14523-2-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251884703-14523-2-git-send-email-jirislaby@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02, Jiri Slaby wrote:
>
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -1240,20 +1240,28 @@ int setrlimit(struct task_struct *tsk, unsigned int resource,
>  		struct rlimit *new_rlim)
>  {
>  	struct rlimit *old_rlim;
> +	unsigned long flags;
>  	int retval;
>
>  	if (new_rlim->rlim_cur > new_rlim->rlim_max)
>  		return -EINVAL;
> +
> +	if (lock_task_sighand(tsk, &flags) == NULL)
> +		return -ESRCH;

No, sorry, this can't work.

Because we need task_lock() to update rlimits, and ->alloc_lock does not
nest under ->siglock.

Looks like we have to use tasklist_lock, but please don't use _irq, and
please do not check ->signal != NULL. Perhaps it makes sense to take
tasklist only if !same_thread_group(tsk, current) though.

Oh. We really need to make ->signal refcountable.


But there is another minor problem. If we use read_lock(ttasklist), then
the write to /proc/application_pid/limits can race with application doing
sys_setrlimits().

Nothing bad can happen, but this means that "echo ... > /proc/limits" can
be lost. Not good, if admin wants to lower ->rlim_max we should try to ensure
this always works.

Oleg.

