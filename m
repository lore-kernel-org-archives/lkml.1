Return-Path: <linux-kernel-owner+w=401wt.eu-S1752619AbZJPVzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbZJPVzK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 17:55:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751442AbZJPVzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 17:55:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56955 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752035AbZJPVzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 17:55:08 -0400
Date: Fri, 16 Oct 2009 14:54:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Timo Sirainen <tss@iki.fi>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc/pid/cmdline: Handle invalid cmdline change
 failures correctly.
Message-Id: <20091016145431.ed00922e.akpm@linux-foundation.org>
In-Reply-To: <1254542832.5405.6.camel@hurina>
References: <1254542832.5405.6.camel@hurina>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 03 Oct 2009 00:07:12 -0400
Timo Sirainen <tss@iki.fi> wrote:

> Handle access_process_vm() failures correctly in /proc/pid/cmdline.
> This bug might have leaked kernel memory to userspace.
> 

The changelog fails to describe the bug.

> ---
>  fs/proc/base.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 837469a..f66cc4c 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -252,7 +252,7 @@ struct mm_struct *mm_for_maps(struct task_struct *task)
>  
>  static int proc_pid_cmdline(struct task_struct *task, char * buffer)
>  {
> -	int res = 0;
> +	int res = 0, res2;
>  	unsigned int len;
>  	struct mm_struct *mm = get_task_mm(task);
>  	if (!mm)
> @@ -277,8 +277,9 @@ static int proc_pid_cmdline(struct task_struct *task, char * buffer)
>  			len = mm->env_end - mm->env_start;
>  			if (len > PAGE_SIZE - res)
>  				len = PAGE_SIZE - res;
> -			res += access_process_vm(task, mm->env_start, buffer+res, len, 0);
> -			res = strnlen(buffer, res);
> +			res2 = access_process_vm(task, mm->env_start, buffer+res, len, 0);
> +			if (res2 > 0)
> +				res = strnlen(buffer, res + res2);
>  		}
>  	}

And I don't see what it is.  afacit the current code is correct.
