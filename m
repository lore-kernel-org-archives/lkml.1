Return-Path: <linux-kernel-owner+w=401wt.eu-S1761287AbYGQW70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761287AbYGQW70 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 18:59:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755338AbYGQW7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 18:59:19 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:59110 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753740AbYGQW7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 18:59:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=CeyeD3wDWyI43jLF2LkHIGXhCcKBnNLnAKDsaGjuvbK0uZavbmX1sTa+q5wRsq2gfy
         ew5i+xfEPJX2QdUiXYM5wFnMunRNamEMW8f3iYXf13ww6j4JjqNZQb+2HB2SNSoY1srw
         3/L7lsf757GKCNNt68pt2ZP5ecjAzWU9Ba41A=
Date: Fri, 18 Jul 2008 02:56:32 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 23/23] /proc/PID/syscall
Message-ID: <20080717225632.GA16887@martell.zuzino.mipt.ru>
References: <20080717072541.F390E15411D@magilla.localdomain> <20080717073144.5A28715411D@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080717073144.5A28715411D@magilla.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 12:31:44AM -0700, Roland McGrath wrote:
> This adds /proc/PID/syscall and /proc/PID/task/TID/syscall magic files.
> These use task_current_syscall() to show the task's current system call
> number and argument registers, stack pointer and PC.

> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -509,6 +509,26 @@ static int proc_pid_limits(struct task_struct *task, char *buffer)
>  	return count;
>  }
>  
> +#ifdef CONFIG_HAVE_ARCH_TRACEHOOK
> +static int proc_pid_syscall(struct task_struct *task, char *buffer)
> +{
> +	long nr;
> +	unsigned long args[6], sp, pc;
> +
> +	if (task_current_syscall(task, &nr, args, 6, &sp, &pc))
> +		return sprintf(buffer, "running\n");
> +
> +	if (nr < 0)
> +		return sprintf(buffer, "%ld 0x%lx 0x%lx\n", nr, sp, pc);
> +
> +	return sprintf(buffer,
> +		       "%ld 0x%lx 0x%lx 0x%lx 0x%lx 0x%lx 0x%lx 0x%lx 0x%lx\n",
> +		       nr,
> +		       args[0], args[1], args[2], args[3], args[4], args[5],
> +		       sp, pc);
> +}
> +#endif /* CONFIG_HAVE_ARCH_TRACEHOOK */

My gut feeling this code needs ptrace_may_access() checks.

