Return-Path: <linux-kernel-owner+w=401wt.eu-S1751368AbYKFTsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751368AbYKFTsQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 14:48:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751128AbYKFTr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 14:47:59 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:34164 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbYKFTr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 14:47:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KU8HEtX4B5nmsy66cmQKqa6imVObPKspRnOnsd9weVO83359bt7gJs1SQscBaZu1t7
         K/AKXdoGV5kolu4XyupM2nu5c1oFMvumLPolWgt3JrGpUohctILSdXkD/RYm2NwDiQj/
         5TQwVDLpxgCC4FZKSuWRiRFjWyirtrT+hbBEk=
Date: Thu, 6 Nov 2008 22:51:07 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Ken Chen <kenchen@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [patch] add /proc/pid/stack to dump task's stack trace
Message-ID: <20081106195107.GA17545@x200.localdomain>
References: <b040c32a0811061101j4a93a0f2pe30c0598726acd08@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b040c32a0811061101j4a93a0f2pe30c0598726acd08@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2008 at 11:01:39AM -0800, Ken Chen wrote:
> This patch adds the ability to query a task's stack trace via /proc/pid/stack.
> It is considered to be more useful than /proc/pid/wchan as it provides full
> stack trace instead of single depth.

Please, name handler proc_pid_stack following current convention.
And drop space before casts.

> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -338,6 +339,35 @@ static int proc_pid_wchan
>  	else
>  		return sprintf(buffer, "%s", symname);
>  }
> +
> +#define MAX_STACK_TRACE_DEPTH	32
> +static int proc_stack_trace(struct task_struct *task, char *buffer)
> +{
> +	int i, len = 0;
> +	unsigned long *entries;
> +	struct stack_trace trace;
> +
> +	entries = kmalloc(sizeof(*entries) * MAX_STACK_TRACE_DEPTH, GFP_KERNEL);
> +	if (!entries)
> +		goto out;
> +
> +	trace.nr_entries = 0;
> +	trace.max_entries = MAX_STACK_TRACE_DEPTH;
> +	trace.entries = entries;
> +	trace.skip = 0;
> +
> +	read_lock(&tasklist_lock);
> +	save_stack_trace_tsk(task, &trace);
> +	read_unlock(&tasklist_lock);
> +
> +	for (i = 0; i < trace.nr_entries; i++) {
> +		len += sprintf(buffer + len, "[<%p>] %pS\n",
> +				(void *) entries[i], (void *) entries[i]);
> +	}
> +	kfree(entries);
> +out:
> +	return len;
> +}
>  #endif /* CONFIG_KALLSYMS */
> 
>  #ifdef CONFIG_SCHEDSTATS
> @@ -2489,6 +2519,7 @@ static const struct pid_entry tgid_base_stuff[] = {
>  	DIR("attr",       S_IRUGO|S_IXUGO, attr_dir),
>  #endif
>  #ifdef CONFIG_KALLSYMS
> +	INF("stack",      S_IRUSR, stack_trace),
>  	INF("wchan",      S_IRUGO, pid_wchan),
>  #endif
>  #ifdef CONFIG_SCHEDSTATS
