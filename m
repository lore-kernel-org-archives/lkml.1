Return-Path: <linux-kernel-owner+w=401wt.eu-S1752579AbXE3ARS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579AbXE3ARS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 20:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751072AbXE3ARF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 20:17:05 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:48706 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751151AbXE3ARE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 20:17:04 -0400
Date: Tue, 29 May 2007 17:16:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: linux-kernel@vger.kernel.org, devel@openvz.org
Subject: Re: [PATCH] /proc/*/environ: wrong placing of ptrace_may_attach()
 check
Message-Id: <20070529171623.6879e159.akpm@linux-foundation.org>
In-Reply-To: <20070528134157.GA7171@localhost.sw.ru>
References: <20070528134157.GA7171@localhost.sw.ru>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 May 2007 17:41:57 +0400
Alexey Dobriyan <adobriyan@sw.ru> wrote:

> Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>

Better changelogs, please.

> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -204,12 +204,17 @@ static int proc_pid_environ(struct task_
>  	int res = 0;
>  	struct mm_struct *mm = get_task_mm(task);
>  	if (mm) {
> -		unsigned int len = mm->env_end - mm->env_start;
> +		unsigned int len;
> +
> +		res = -ESRCH;
> +		if (!ptrace_may_attach(task))
> +			goto out;
> +
> +		len  = mm->env_end - mm->env_start;
>  		if (len > PAGE_SIZE)
>  			len = PAGE_SIZE;
>  		res = access_process_vm(task, mm->env_start, buffer, len, 0);
> -		if (!ptrace_may_attach(task))
> -			res = -ESRCH;
> +out:
>  		mmput(mm);
>  	}
>  	return res;

What's wrong with the existing code?  It's a bit dopey-looking and can, I
guess, permit a task to cause a pagefault in an mm which it doesn't have
permission to read from.  But is there some more serious problem being
fixed here?

I shouldn't have to ask this stuff.
