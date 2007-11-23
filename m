Return-Path: <linux-kernel-owner+w=401wt.eu-S1756719AbXKWKYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719AbXKWKYx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 05:24:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754842AbXKWKYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 05:24:45 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:32426 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754630AbXKWKYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 05:24:44 -0500
Date: Fri, 23 Nov 2007 13:23:51 +0300
From: Alexey Dobriyan <adobriyan@sw.ru>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>,
       Scott James Remnant <scott@ubuntu.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 1/2] ptrace_stop: fix the race with ptrace detach+attach
Message-ID: <20071123102351.GD6240@localhost.sw.ru>
References: <20071122161459.GA5973@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071122161459.GA5973@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 22, 2007 at 07:14:59PM +0300, Oleg Nesterov wrote:
> If the tracer went away (may_ptrace_stop() failed), ptrace_stop() drops tasklist
> and then changes the ->state from TASK_TRACED to TASK_RUNNING.
> 
> This can fool another tracer which attaches to us in between. Change the ->state
> under tasklist_lock to ensure that ptrace_check_attach() can't wrongly succeed.

ptrace_check_attach? Both do read_lock -- can run in parallel, so how can it help?

> --- PT/kernel/signal.c~1_ptrace_stop	2007-11-21 21:41:02.000000000 +0300
> +++ PT/kernel/signal.c	2007-11-22 16:59:35.000000000 +0300
> @@ -1628,11 +1628,11 @@ static void ptrace_stop(int exit_code, i
>  	} else {
>  		/*
>  		 * By the time we got the lock, our tracer went away.
> -		 * Don't stop here.
> +		 * Don't drop the lock yet, another tracer may come.
>  		 */
> -		read_unlock(&tasklist_lock);
> -		set_current_state(TASK_RUNNING);
> +		__set_current_state(TASK_RUNNING);
>  		current->exit_code = nostop_code;
> +		read_unlock(&tasklist_lock);
>  	}
>  
>  	/*

