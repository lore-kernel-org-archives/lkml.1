Return-Path: <linux-kernel-owner+w=401wt.eu-S1754845AbYJPQ4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845AbYJPQ4j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 12:56:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754098AbYJPQ41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 12:56:27 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57170 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753919AbYJPQ40 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 12:56:26 -0400
Date: Thu, 16 Oct 2008 18:57:27 +0200
From: Oleg Nesterov <onestero@redhat.com>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Roland McGrath <roland@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: SIGTRAP vs. sys_exit_group race
Message-ID: <20081016165727.GA6442@redhat.com>
References: <48EA1BE9.1030707@siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48EA1BE9.1030707@siemens.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland, what do you think?

On 10/06, Jan Kiszka wrote:
>
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -1528,10 +1528,11 @@ static void ptrace_stop(int exit_code, i
>  		spin_unlock_irq(&current->sighand->siglock);
>  		arch_ptrace_stop(exit_code, info);
>  		spin_lock_irq(&current->sighand->siglock);
> -		if (sigkill_pending(current))
> -			return;
>  	}
>
> +	if (sigkill_pending(current))
> +		return;
> +

Personally, I think this change is good anyway. The tracee shouldn't
sleep in TASK_TRACED with the pending SIGKILL.

And the current code is confusing, imho. Why do we check sigkill_pending()
under arch_ptrace_stop_needed() ? Yes, it unlocks ->siglock and can sleep,
so SIGKILL can come in between. But it is quite possible that SIGKILL is
already pending when we enter ptrace_stop().


The only problem I can see this patch adds a user-visible change, even
if this change looks good to me. For example, if we send SIGKILL to
the thread group, the tracee will not send PTRACE_EVENT_EXIT.

I think we need further changes. If the thread group group was killed
by some fatal signal (but not SIGKILL) the tracee will sleep with
SIGNAL_GROUP_EXIT, this is not nice too. But imho the patch makes
sense anyway.

Oleg.

