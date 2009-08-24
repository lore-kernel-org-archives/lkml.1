Return-Path: <linux-kernel-owner+w=401wt.eu-S1751459AbZHXFNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751459AbZHXFNm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 01:13:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751335AbZHXFNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 01:13:41 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35748 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbZHXFNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 01:13:41 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 24 Aug 2009 14:11:41 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix race copy_process() vs de_thread()
Message-Id: <20090824141141.0893a2c0.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4A9210A4.4010108@ct.jp.nec.com>
References: <4A9210A4.4010108@ct.jp.nec.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Aug 2009 13:01:40 +0900
Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:
 
> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> ---
>  kernel/fork.c |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 3ffa10f..be6c5b5 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -882,6 +882,9 @@ static void cleanup_signal(struct task_struct *tsk)
>  {
>  	struct signal_struct *sig = tsk->signal;
>  
> +	if (!sig)
> +		return;
> +
>  	atomic_dec(&sig->live);
>  
>  	if (atomic_dec_and_test(&sig->count))
> @@ -1230,6 +1233,15 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>   	 */
>  	recalc_sigpending();
>  	if (signal_pending(current)) {
> +		/* If there is any task waiting for the group exit, notify it */
> +		if ((clone_flags & CLONE_THREAD) &&
> +		    p->signal->group_exit_task) {
> +			atomic_dec(&p->signal->live);
> +			atomic_dec(&p->signal->count);
> +			if (atomic_read(&p->signal->count) == p->signal->notify_count)
> +				wake_up_process(p->signal->group_exit_task);
> +			p->signal = NULL;
> +		}
>  		spin_unlock(&current->sighand->siglock);
>  		write_unlock_irq(&tasklist_lock);
>  		retval = -ERESTARTNOINTR;

I'm not sure whehter I catch the issue correctly but, shouldn't we encapsulate
this check in cleanup_signal() ?

like...

static void cleanup_signal(struct task_struct *tsk)
{
        struct signal_struct *sig = tsk->signal;
	sighand = rcu_dereference(tsk->sighand);
 
        spin_lock(&sighand->siglock);
        if (sig->group_exit_task && atomic_read(&sig->count) == sig->notify_count)
 		wake_up_process(sig->group_exit_task);
	spin_unlock(&sighand->siglock);

	atomic_dec(&sig->live);
	if (!atomic_dec_and_test(&sig->count))
		 __cleanup_signal(sig);
}


BTW, why sig->xxx members in "signal" struct is guarded by lock in "sighand"
struct ??

Thanks,
-Kame





