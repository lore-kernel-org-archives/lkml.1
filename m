Return-Path: <linux-kernel-owner+w=401wt.eu-S1756691AbYGZQJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691AbYGZQJe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 12:09:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753489AbYGZQJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 12:09:11 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:36368 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752872AbYGZQJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 12:09:08 -0400
Date: Sat, 26 Jul 2008 20:12:13 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrea Righi <righi.andrea@gmail.com>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       balbir@linux.vnet.ibm.com, matt@bluehost.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] task IO accounting: correctly account threads IO statistics
Message-ID: <20080726161213.GA594@tv-sign.ru>
References: <1217087532-22620-1-git-send-email-righi.andrea@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217087532-22620-1-git-send-email-righi.andrea@gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26, Andrea Righi wrote:
>
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -2381,35 +2381,18 @@ static int do_io_accounting(struct task_struct *task, char *buffer, int whole)
>  	u64 rchar, wchar, syscr, syscw;
>  	struct task_io_accounting ioac;
>  
> -	if (!whole) {
> -		rchar = task->rchar;
> -		wchar = task->wchar;
> -		syscr = task->syscr;
> -		syscw = task->syscw;
> -		memcpy(&ioac, &task->ioac, sizeof(ioac));
> -	} else {
> -		unsigned long flags;
> -		struct task_struct *t = task;
> -		rchar = wchar = syscr = syscw = 0;
> -		memset(&ioac, 0, sizeof(ioac));
> +	rchar = task->rchar;
> +	wchar = task->wchar;
> +	syscr = task->syscr;
> +	syscw = task->syscw;
> +	memcpy(&ioac, &task->ioac, sizeof(ioac));
>  
> -		rcu_read_lock();
> -		do {
> -			rchar += t->rchar;
> -			wchar += t->wchar;
> -			syscr += t->syscr;
> -			syscw += t->syscw;
> -
> -			ioac.read_bytes += t->ioac.read_bytes;
> -			ioac.write_bytes += t->ioac.write_bytes;
> -			ioac.cancelled_write_bytes +=
> -					t->ioac.cancelled_write_bytes;
> -			t = next_thread(t);
> -		} while (t != task);
> -		rcu_read_unlock();
> +	if (whole) {
> +		unsigned long flags;
>  
>  		if (lock_task_sighand(task, &flags)) {
>  			struct signal_struct *sig = task->signal;
> +			struct task_struct *t = task;
>  
>  			rchar += sig->rchar;
>  			wchar += sig->wchar;
> @@ -2420,11 +2403,20 @@ static int do_io_accounting(struct task_struct *task, char *buffer, int whole)
>  			ioac.write_bytes += sig->ioac.write_bytes;
>  			ioac.cancelled_write_bytes +=
>  					sig->ioac.cancelled_write_bytes;
> -
> +			while_each_thread(task, t) {
> +				rchar += t->rchar;
> +				wchar += t->wchar;
> +				syscr += t->syscr;
> +				syscw += t->syscw;
> +
> +				ioac.read_bytes += t->ioac.read_bytes;
> +				ioac.write_bytes += t->ioac.write_bytes;
> +				ioac.cancelled_write_bytes +=
> +					t->ioac.cancelled_write_bytes;
> +			}
>  			unlock_task_sighand(task, &flags);
>  		}
>  	}
> -
>  	return sprintf(buffer,
>  			"rchar: %llu\n"
>  			"wchar: %llu\n"
> @@ -2433,13 +2425,9 @@ static int do_io_accounting(struct task_struct *task, char *buffer, int whole)
>  			"read_bytes: %llu\n"
>  			"write_bytes: %llu\n"
>  			"cancelled_write_bytes: %llu\n",
> -			(unsigned long long)rchar,
> -			(unsigned long long)wchar,
> -			(unsigned long long)syscr,
> -			(unsigned long long)syscw,
> -			(unsigned long long)ioac.read_bytes,
> -			(unsigned long long)ioac.write_bytes,
> -			(unsigned long long)ioac.cancelled_write_bytes);
> +			rchar, wchar, syscr, syscw,
> +			ioac.read_bytes, ioac.write_bytes,
> +			ioac.cancelled_write_bytes);
>  }

Looks good!

And thanks for correcting me, of course we should initialize t
before while_each_thread(task, t).

Oleg.

