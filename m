Return-Path: <linux-kernel-owner+w=401wt.eu-S1753849AbZCIWD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849AbZCIWD2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 18:03:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751511AbZCIWDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 18:03:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49165 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751269AbZCIWDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 18:03:18 -0400
Date: Mon, 9 Mar 2009 15:01:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: torvalds@linux-foundation.org, elendil@planet.nl, schwidefsky@de.ibm.com,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] Fix fixpoint divide exception in acct_update_integrals
Message-Id: <20090309150111.c36c54f7.akpm@linux-foundation.org>
In-Reply-To: <20090309133159.1ef09c7b@osiris.boeblingen.de.ibm.com>
References: <20090309133159.1ef09c7b@osiris.boeblingen.de.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Mar 2009 13:31:59 +0100
Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> ...
>
> --- linux-2.6.orig/kernel/tsacct.c
> +++ linux-2.6/kernel/tsacct.c
> @@ -122,8 +122,10 @@ void acct_update_integrals(struct task_s
>  	if (likely(tsk->mm)) {
>  		cputime_t time, dtime;
>  		struct timeval value;
> +		unsigned long flags;
>  		u64 delta;
>  
> +		local_irq_save(flags);
>  		time = tsk->stime + tsk->utime;
>  		dtime = cputime_sub(time, tsk->acct_timexpd);
>  		jiffies_to_timeval(cputime_to_jiffies(dtime), &value);
> @@ -131,10 +133,12 @@ void acct_update_integrals(struct task_s
>  		delta = delta * USEC_PER_SEC + value.tv_usec;
>  
>  		if (delta == 0)
> -			return;
> +			goto out;
>  		tsk->acct_timexpd = time;
>  		tsk->acct_rss_mem1 += delta * get_mm_rss(tsk->mm);
>  		tsk->acct_vm_mem1 += delta * tsk->mm->total_vm;
> +	out:
> +		local_irq_restore(flags);
>  	}
>  }
>  

hrm, so we use local-interrupt protection for <something>.

I wonder what we can do to reduce the probability of bugs of this
nature being introduced in the future?

