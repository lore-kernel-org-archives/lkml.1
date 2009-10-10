Return-Path: <linux-kernel-owner+w=401wt.eu-S934629AbZJJAOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934629AbZJJAOj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 20:14:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758959AbZJJAOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 20:14:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44548 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756847AbZJJAOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 20:14:37 -0400
Date: Fri, 9 Oct 2009 17:13:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Bryan Donlan <bdonlan@gmail.com>, linux-kernel@vger.kernel.org,
       Ulrich Drepper <drepper@redhat.com>, linux-api@vger.kernel.org
Subject: Re: [resend][PATCH] Added PR_SET_PROCTITLE_AREA option for prctl()
Message-Id: <20091009171344.3fc5f28b.akpm@linux-foundation.org>
In-Reply-To: <20091009134354.12A7.A69D9226@jp.fujitsu.com>
References: <20091009134354.12A7.A69D9226@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  9 Oct 2009 13:50:17 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> ok, all lkml reviewer ack this patch.
> then, I've switched to linux-api review.
> 
> Any comments?
> 
> 
> 
> ==================================================
> From: Timo Sirainen <tss@iki.fi>
> 
> Currently glibc2 doesn't have setproctitle(3), so several userland 
> daemons attempt to emulate it by doing some brutal stack modifications.
> This works most of the time, but it has problems. For example:
> 
>  % ps -ef |grep avahi-daemon
>  avahi     1679     1  0 09:20 ?        00:00:00 avahi-daemon: running [kosadesk.local]
> 
>  # cat /proc/1679/cmdline
>  avahi-daemon: running [kosadesk.local]
> 
> This looks good, but the process has also overwritten its environment
> area and made the environ file useless:
> 
>  # cat /proc/1679/environ
>  adesk.local]
> 
> Another problem is that the process title length is limited by the size of
> the environment. Security conscious people try to avoid potential information
> leaks by clearing most of the environment before running a daemon:
> 
>  # env - MINIMUM_NEEDED_VAR=foo /path/to/daemon
> 
> The resulting environment size may be too small to fit the wanted process
> titles.
> 
> This patch makes it possible for userspace to implement setproctitle()
> cleanly. It adds a new PR_SET_PROCTITLE_AREA option for prctl(), which
> updates task's mm_struct->arg_start and arg_end to the given area.
> 
>  test_setproctitle.c
>  ================================================
>  #define ERR(str) (perror(str), exit(1))
> 
>  void settitle(char* title){
>          int err;
> 
>          err = prctl(34, title, strlen(title)+1);
>          if (err < 0)
>                  ERR("prctl ");
>  }
> 
>  void main(void){
>          long i;
>          char buf[1024];
> 
>          for (i = 0; i < 10000000000LL; i++){
>                  sprintf(buf, "loooooooooooooooooooooooong string %d",i);
>                  settitle(buf);
>          }
>  }

gee that's a good changelog.

> ...
>
> @@ -255,32 +255,47 @@ static int proc_pid_cmdline(struct task_struct *task, char * buffer)
>  	int res = 0;
>  	unsigned int len;
>  	struct mm_struct *mm = get_task_mm(task);
> +	unsigned seq;
> +
>  	if (!mm)
>  		goto out;
> +
> +	/* The process was not constructed yet? */
>  	if (!mm->arg_end)
> -		goto out_mm;	/* Shh! No looking before we're done */
> +		goto out_mm;
>  
> - 	len = mm->arg_end - mm->arg_start;
> - 
> -	if (len > PAGE_SIZE)
> -		len = PAGE_SIZE;
> - 
> -	res = access_process_vm(task, mm->arg_start, buffer, len, 0);
> -
> -	// If the nul at the end of args has been overwritten, then
> -	// assume application is using setproctitle(3).
> -	if (res > 0 && buffer[res-1] != '\0' && len < PAGE_SIZE) {
> -		len = strnlen(buffer, res);
> -		if (len < res) {
> -		    res = len;
> -		} else {
> -			len = mm->env_end - mm->env_start;
> -			if (len > PAGE_SIZE - res)
> -				len = PAGE_SIZE - res;
> -			res += access_process_vm(task, mm->env_start, buffer+res, len, 0);
> +	do {
> +		seq = read_seqbegin(&mm->arg_lock);
> +
> +		len = mm->arg_end - mm->arg_start;
> +		if (len > PAGE_SIZE)
> +			len = PAGE_SIZE;
> +
> +		res = access_process_vm(task, mm->arg_start, buffer, len, 0);
> +
> +		if (mm->arg_end != mm->env_start)
> +			/* PR_SET_PROCTITLE_AREA used */
>  			res = strnlen(buffer, res);

Hang on.

If PR_SET_PROCTITLE_AREA installed a bad address then
access_process_vm() will return -EFAULT and nothing was written to
`buffer'?

Also, concurrent PR_SET_PROCTITLE_AREA could cause arg_start and
arg_end to have inconsistent/incoherent values.  This might result in a
fault but it also might result in a read of garbage userspace memory.

I guess all of these issues could be written off as "userspace bugs",
but our behaviour here isn't nice.  We should at least return that
-EFAULT!.

> +		else if (res > 0 && buffer[res-1] != '\0' && len < PAGE_SIZE) {
> +			/*
> +			 * If the nul at the end of args has been overwritten,
> +			 * then assume application is using sendmail's
> +			 * SPT_REUSEARGV style argv override.
> +			 */
> +			len = strnlen(buffer, res);
> +			if (len < res) {
> +				res = len;
> +			} else {
> +				len = mm->env_end - mm->env_start;
> +				if (len > PAGE_SIZE - res)
> +					len = PAGE_SIZE - res;
> +				res += access_process_vm(task, mm->env_start,
> +							 buffer+res, len, 0);
> +				res = strnlen(buffer, res);
> +			}

And if access_process_vm() returns a -ve errno here, the code simply
flies off into the weeds.

>  		}
> -	}
> +	} while (read_seqretry(&mm->arg_lock, seq));
> +
>  out_mm:
>  	mmput(mm);
>
> ...
>
> @@ -236,6 +237,7 @@ struct mm_struct {
>  	unsigned long stack_vm, reserved_vm, def_flags, nr_ptes;
>  	unsigned long start_code, end_code, start_data, end_data;
>  	unsigned long start_brk, brk, start_stack;
> +	seqlock_t arg_lock;
>  	unsigned long arg_start, arg_end, env_start, env_end;
>  
>  	unsigned long saved_auxv[AT_VECTOR_SIZE]; /* for /proc/PID/auxv */

seqlocks are nice but I have to wonder if they made this patch
unnecessarily complex.  Couldn't we just do:

	 PR_SET_PROCTITLE_AREA:

		spin_lock(mm->lock);
		mm->arg_start = addr;
		mm->arg_end = addr + len;
		spin_unlock(mm->lock);

and

	proc_pid_cmdline()
	{
		unsigned long addr;
		unsigned long end;

		spin_lock(mm->lock);
		addr = mm->arg_start;
		end = mm->arg_end;
		spin_unlock(mm->lock);

		<use `addr' and `len'>
	}

?


