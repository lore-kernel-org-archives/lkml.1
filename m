Return-Path: <linux-kernel-owner+w=401wt.eu-S1752550AbYC2Kjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550AbYC2Kjw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 06:39:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751399AbYC2Kjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 06:39:45 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:35877 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380AbYC2Kjo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 06:39:44 -0400
Date: Sat, 29 Mar 2008 13:39:29 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ptrace children revamp
Message-ID: <20080329103929.GB359@tv-sign.ru>
References: <20080329033412.120EE26FA1D@magilla.localdomain> <20080329033542.BFF4526FA1D@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080329033542.BFF4526FA1D@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I didn't read the patch yet (will do), just a minor nit right now,

On 03/28, Roland McGrath wrote:
>
> @@ -1528,19 +1534,11 @@ static int do_wait_thread(struct task_struct *tsk, int *retval,
>  			return 1;
>  	}
>  
> -	/*
> -	 * If we never saw an eligile child, check for children stolen by
> -	 * ptrace.  We don't leave -ECHILD in *@retval if there are any,
> -	 * because we will eventually be allowed to wait for them again.
> -	 */
> -	if (*retval)
> -		list_for_each_entry(p, &tsk->ptrace_children, ptrace_list) {
> -			int ret = eligible_child(type, pid, options, p);
> -			if (ret) {
> -				*retval = unlikely(ret < 0) ? ret : 0;
> -				break;
> -			}
> -		}
> +	list_for_each_entry(p, &tsk->ptrace_attach, ptrace_list) {
> +		if (wait_consider_task(tsk, p, retval, type, pid, options,
> +				       infop, stat_addr, ru))
> +			return 1;
> +	}

Afaics, this adds a minor pessimization. We shouldn't scan ->ptrace_attach
list if it was already found that another thread has a "hidden" task.

Oleg.

