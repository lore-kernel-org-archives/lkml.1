Return-Path: <linux-kernel-owner+w=401wt.eu-S1761279AbXJYD5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761279AbXJYD5d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 23:57:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758638AbXJYD5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 23:57:25 -0400
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:33024 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758500AbXJYD5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 23:57:24 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=WniMMCb9H8rL6HNFEwtrbyUpWZe0mAolPp3BUOAr6bpJUYe3xIZxBbOcUqsIEvblw3kuKfZPurBS6/g8GSPIbDLr1ocYW7s1OHhGVHBEJoi29zn50IpnE/vZC/emMQf8tweUgFdYZpzEeJZekD9X2dFp2v4Lo4Z7PhLNq+qIjDk=  ;
X-YMail-OSG: lFcWShkVM1kns6XTvKj0knoO3rr_Msrqi4uX7xlnBuE_s.9poRPOKXsqii.05QLCuY0xbGDlgg--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 2/5] Use macros instead of TASK_ flags
Date: Thu, 25 Oct 2007 13:50:43 +1000
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
References: <11927463623428-git-send-email-matthew@wil.cx> <11927463622621-git-send-email-matthew@wil.cx>
In-Reply-To: <11927463622621-git-send-email-matthew@wil.cx>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710251350.43281.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 19 October 2007 08:25, Matthew Wilcox wrote:
> Abstracting away direct uses of TASK_ flags allows us to change the
> definitions of the task flags more easily.
>
> Also restructure do_wait() a little
>
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
> ---
>  arch/ia64/kernel/perfmon.c |    4 +-
>  fs/proc/array.c            |    9 +---
>  fs/proc/base.c             |    2 +-
>  include/linux/sched.h      |   15 +++++++
>  include/linux/wait.h       |   11 +++--
>  kernel/exit.c              |   90
> +++++++++++++++++++------------------------ kernel/power/process.c     |   
> 7 +--
>  kernel/ptrace.c            |    8 ++--
>  kernel/sched.c             |   15 +++----
>  kernel/signal.c            |    6 +-
>  kernel/wait.c              |    2 +-
>  11 files changed, 83 insertions(+), 86 deletions(-)
>
> diff --git a/arch/ia64/kernel/perfmon.c b/arch/ia64/kernel/perfmon.c
> index f55fa07..6b0a6cf 100644
> --- a/arch/ia64/kernel/perfmon.c
> +++ b/arch/ia64/kernel/perfmon.c
> @@ -2630,7 +2630,7 @@ pfm_task_incompatible(pfm_context_t *ctx, struct
> task_struct *task) */
>  	if (task == current) return 0;
>
> -	if ((task->state != TASK_STOPPED) && (task->state != TASK_TRACED)) {
> +	if (!is_task_stopped_or_traced(task)) {
>  		DPRINT(("cannot attach to non-stopped task [%d] state=%ld\n", task->pid,
> task->state)); return -EBUSY;
>  	}
> @@ -4790,7 +4790,7 @@ recheck:
>  	 * the task must be stopped.
>  	 */
>  	if (PFM_CMD_STOPPED(cmd)) {
> -		if ((task->state != TASK_STOPPED) && (task->state != TASK_TRACED)) {
> +		if (!is_task_stopped_or_traced(task)) {
>  			DPRINT(("[%d] task not in stopped state\n", task->pid));
>  			return -EBUSY;
>  		}
> diff --git a/fs/proc/array.c b/fs/proc/array.c
> index 27b59f5..8939bf0 100644
> --- a/fs/proc/array.c
> +++ b/fs/proc/array.c
> @@ -140,13 +140,8 @@ static const char *task_state_array[] = {
>
>  static inline const char *get_task_state(struct task_struct *tsk)
>  {
> -	unsigned int state = (tsk->state & (TASK_RUNNING |
> -					    TASK_INTERRUPTIBLE |
> -					    TASK_UNINTERRUPTIBLE |
> -					    TASK_STOPPED |
> -					    TASK_TRACED)) |
> -			(tsk->exit_state & (EXIT_ZOMBIE |
> -					    EXIT_DEAD));
> +	unsigned int state = (tsk->state & TASK_REPORT) |
> +			(tsk->exit_state & (EXIT_ZOMBIE | EXIT_DEAD));
>  	const char **p = &task_state_array[0];
>
>  	while (state) {
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 4fe74d1..e7e1815 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -196,7 +196,7 @@ static int proc_root_link(struct inode *inode, struct
> dentry **dentry, struct vf (task == current || \
>  	(task->parent == current && \
>  	(task->ptrace & PT_PTRACED) && \
> -	 (task->state == TASK_STOPPED || task->state == TASK_TRACED) && \
> +	 (is_task_stopped_or_traced(task)) && \
>  	 security_ptrace(current,task) == 0))
>
>  static int proc_pid_cmdline(struct task_struct *task, char * buffer)
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index c204ab0..5ef5253 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -177,6 +177,21 @@ print_cfs_rq(struct seq_file *m, int cpu, struct
> cfs_rq *cfs_rq) /* in tsk->state again */
>  #define TASK_DEAD		64
>
> +/* Convenience macros for the sake of wake_up */
> +#define TASK_NORMAL		(TASK_INTERRUPTIBLE | TASK_UNINTERRUPTIBLE)
> +#define TASK_ALL		(TASK_NORMAL | TASK_STOPPED | TASK_TRACED)
> +
> +/* get_task_state() */
> +#define TASK_REPORT		(TASK_RUNNING | TASK_INTERRUPTIBLE | \
> +				 TASK_UNINTERRUPTIBLE | TASK_STOPPED | \
> +				 TASK_TRACED)

I think it would be nicer if you made it explicit in the name that
these are not individual flags. Maybe it doesn't matter though...

Also, TASK_NORMAL / TASK_ALL aren't very good names. TASK_SLEEP_NORMAL
TASK_SLEEP_ALL might be a bit more helpful?
