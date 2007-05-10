Return-Path: <linux-kernel-owner+w=401wt.eu-S1754921AbXEJBut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921AbXEJBut (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 21:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752652AbXEJBul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 21:50:41 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56114 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752440AbXEJBuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 21:50:40 -0400
Date: Wed, 9 May 2007 18:50:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sripathi Kodi <sripathik@in.ibm.com>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>,
       Roland McGrath <roland@redhat.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 2/2] Use write_trylock_irqsave in ptrace_attach
Message-Id: <20070509185003.34a45673.akpm@linux-foundation.org>
In-Reply-To: <200705091413.27344.sripathik@in.ibm.com>
References: <200705091413.27344.sripathik@in.ibm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 May 2007 14:13:27 +0530 Sripathi Kodi <sripathik@in.ibm.com> wrote:

> Hi,
> 
> This patch makes ptrace_attach use write_trylock_irqsave.
> 
> Signed-off-by: Sripathi Kodi <sripathik@in.ibm.com>
> 
> ---
>  kernel/ptrace.c |    7 +++----
>  1 files changed, 3 insertions(+), 4 deletions(-)
> 
> Index: linux-2.6.21/kernel/ptrace.c
> ===================================================================
> --- linux-2.6.21.orig/kernel/ptrace.c
> +++ linux-2.6.21/kernel/ptrace.c
> @@ -160,6 +160,7 @@ int ptrace_may_attach(struct task_struct
>  int ptrace_attach(struct task_struct *task)
>  {
>  	int retval;
> +	unsigned long flags = 0;
>  
>  	retval = -EPERM;
>  	if (task->pid <= 1)
> @@ -178,9 +179,7 @@ repeat:
>  	 * cpu's that may have task_lock).
>  	 */
>  	task_lock(task);
> -	local_irq_disable();
> -	if (!write_trylock(&tasklist_lock)) {
> -		local_irq_enable();
> +	if (!write_trylock_irqsave(&tasklist_lock, flags)) {
>  		task_unlock(task);
>  		do {
>  			cpu_relax();
> @@ -208,7 +207,7 @@ repeat:
>  	force_sig_specific(SIGSTOP, task);
>  
>  bad:
> -	write_unlock_irq(&tasklist_lock);
> +	write_unlock_irqrestore(&tasklist_lock, flags);
>  	task_unlock(task);
>  out:
>  	return retval;

Your changelogs aren't vey logical.  The context for this change is off in
a different patch.  I reproduce it here:

> I am trying to fix the BUG I mentioned here: 
> http://lkml.org/lkml/2007/04/20/41. I noticed that an elegant way to solve 
> this problem is to have a write_trylock_irqsave helper function. Since we 
> don't have this now, the code in ptrace_attach  implements it using 
> local_irq_disable and write_trylock. I wish to add write_trylock_irqsave to 
> mainline kernel and then fix the -rt specific problem using this.

I can't imagine why -rt's write_unlock_irq() doesn't do local_irq_enable().

I have no problem adding write_trylock_irqsave() - it fills a gap in the
API.

Once we have write_trylock_irqsave() it makes sense to use it here.

One the downside, we added a few bytes to the SMP kernel, which I guess we
can live with.

Whether this change is desired in -rt I don't know.  Ingo?

I don't think the initialisation of `flags' there was needed?

