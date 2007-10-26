Return-Path: <linux-kernel-owner+w=401wt.eu-S1763113AbXJZSpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763113AbXJZSpw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 14:45:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752866AbXJZSpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 14:45:36 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34502 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752302AbXJZSpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 14:45:34 -0400
Date: Fri, 26 Oct 2007 11:45:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       matthew@wil.cx, willy@linux.intel.com,
       Stephane Eranian <eranian@hpl.hp.com>
Subject: Re: [PATCH 2/5] Use macros instead of TASK_ flags
Message-Id: <20071026114515.6e90222c.akpm@linux-foundation.org>
In-Reply-To: <1193228698799-git-send-email-matthew@wil.cx>
References: <11932286982175-git-send-email-matthew@wil.cx>
	<1193228698799-git-send-email-matthew@wil.cx>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2007 08:24:55 -0400
Matthew Wilcox <matthew@wil.cx> wrote:

> Abstracting away direct uses of TASK_ flags allows us to change the
> definitions of the task flags more easily.
> 
> Also restructure do_wait() a little
>
> ...
>
> diff --git a/arch/ia64/kernel/perfmon.c b/arch/ia64/kernel/perfmon.c
> index 59169bf..c2ca724 100644
> --- a/arch/ia64/kernel/perfmon.c
> +++ b/arch/ia64/kernel/perfmon.c
> @@ -2631,7 +2631,7 @@ pfm_task_incompatible(pfm_context_t *ctx, struct task_struct *task)
>  	 */
>  	if (task == current) return 0;
>  
> -	if ((task->state != TASK_STOPPED) && (task->state != TASK_TRACED)) {
> +	if (!is_task_stopped_or_traced(task)) {
>  		DPRINT(("cannot attach to non-stopped task [%d] state=%ld\n", task_pid_nr(task), task->state));
>  		return -EBUSY;
>  	}
> @@ -4792,7 +4792,7 @@ recheck:
>  	 * the task must be stopped.
>  	 */
>  	if (PFM_CMD_STOPPED(cmd)) {
> -		if ((task->state != TASK_STOPPED) && (task->state != TASK_TRACED)) {
> +		if (!is_task_stopped_or_traced(task)) {
>  			DPRINT(("[%d] task not in stopped state\n", task_pid_nr(task)));
>  			return -EBUSY;
>  		}

I have dropped this hunk because the file which it is patching is removed
by the (newly-added-to-mm) git-perfmon.patch.  I can't immediately find any
corresponding code which was readded in a different place by git-perfmon so
it looks like this code was simply zapped.

Of course, if git-perfmon doesn't merge in 2.6.25 then I'll end up merging
your patch but accidentally leaving 2.6.25's arch/ia64/kernel/perfmon.c
unpatched.  It looks like that'll be non-fatal.

This isn't going to go very well and I might end up having to drop this
whole patch series and ask for a refactored one.  We'll see.

