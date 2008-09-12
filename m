Return-Path: <linux-kernel-owner+w=401wt.eu-S1757154AbYILRLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757154AbYILRLt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 13:11:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753603AbYILRLl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 13:11:41 -0400
Received: from rn-out-0910.google.com ([64.233.170.186]:62148 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167AbYILRLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 13:11:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xhvnjBOxFCiGoAX5tWeFgdrOrcE5oB7RJRI58fEQ8UwIhuhS4FycMGJqa6WsUYYtky
         Zx5pIff5tBHY2xYcow40snrEaalzmGQId7HgyoLg2umwtSndyVxll9AOmhAp2TC5bMv2
         RhVEx9rA0vVdjpXR3Ox0pWBgunjuEy1ZPqxLU=
Date: Fri, 12 Sep 2008 19:11:09 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: RFC: [patch] log fatal signals like SIGSEGV
Message-ID: <20080912171055.GA5532@joi>
References: <200809121502.15264.thomas.jarosch@intra2net.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809121502.15264.thomas.jarosch@intra2net.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2008 at 03:02:14PM +0200, Thomas Jarosch wrote:
> --------------------------------------------------------
> Log fatal signals like SIGSEGV or SIGBUS

Note that on current kernel when process segfaults it printks:
a.out[5974]: segfault at 0 ip 00000000004004c1 sp 00007fffdd1a3ce0 error 6 in a.out[400000+1000]

> to aid debugging of obscure problems.
> 
> The code is a stripped down version
> of grsecurity's signal logger.
> 
> Signed-Off-By: Gerd v. Egidy <gve@intra2net.com>
> Signed-Off-By: Thomas Jarosch <thomas.jarosch@intra2net.com>

Please look at Documentation/SubmittingPatches.
(Signed-off-by capitalization and lack of (?) From field)

> 
> diff -u -r -p linux-2.6.22/kernel/signal.c linux.siglog/kernel/signal.c
> --- linux-2.6.22/kernel/signal.c	Mon Jul  9 01:32:17 2007
> +++ linux.siglog/kernel/signal.c	Wed Aug 22 11:08:58 2007
> @@ -514,6 +514,64 @@ static int rm_from_queue(unsigned long m
>  }
>  
>  /*
> + * Stuff needed for signal logger
> + */
> +
> +spinlock_t siglog_lock = SPIN_LOCK_UNLOCKED;

Please use DEFINE_SPINLOCK if spinlock is really needed (look below).

> +unsigned long volatile siglog_wtime = 0;
> +unsigned long volatile siglog_fyet = 0;
> +
> +/* time span in which flooding is measured */
> +#define SIGLOG_FLOOD_SECONDS 5
> +
> +/* how many log entries are allowed in this time span */
> +#define SIGLOG_FLOOD_BURST_LINES 20
> +
> +/*
> + * Log fatal signals
> + */
> +void
> +log_fatal_signal(const int sig, const struct task_struct *t)
> +{
> +	if ((sig == SIGSEGV) || (sig == SIGILL) || (sig == SIGABRT)
> +        || (sig == SIGBUS) || (sig == SIGKILL) || (sig == SIGFPE)) {

It would be clearer if you could write this code as:

if (!sth)
	return;
do_other_stuff;

> +
> +		/* flood protection */
> +		spin_lock(&siglog_lock);
> +		if (!siglog_wtime || jiffies - siglog_wtime > SIGLOG_FLOOD_SECONDS * HZ) {
> +			/* no logging activity yet */
> +			siglog_wtime = jiffies;
> +			siglog_fyet = 0;
> +		} else if ((jiffies - siglog_wtime <= SIGLOG_FLOOD_SECONDS * HZ)
> +                    && (siglog_fyet < SIGLOG_FLOOD_BURST_LINES)) {
> +			/* logging within SIGLOG_FLOOD_SECONDS, but below threshold */
> +			siglog_fyet++;
> +		} else {
> +			/* flooding detected, warn once and return */
> +			if (siglog_fyet == SIGLOG_FLOOD_BURST_LINES) {
> +				siglog_wtime = jiffies;
> +				siglog_fyet++;
> +				printk(KERN_ALERT "siglog: more alerts, logging disabled for"
> +                       " %d seconds\n", SIGLOG_FLOOD_SECONDS);
> +			}
> +			spin_unlock(&siglog_lock);
> +			return;
> +		}
> +		spin_unlock(&siglog_lock);

You probably want to use printk_ratelimit or DEFINE_RATELIMIT_STATE/__ratelimit.

> +
> +		read_lock(&tasklist_lock);
> +		printk(KERN_WARNING "signal %d sent to %.30s[%d] uid:%u, "
> +               "parent %.30s[%d] uid:%u by %.30s[%d] uid:%u, "
> +               "parent %.30s[%d] uid:%u\n", sig, t->comm, t->pid, t->uid,
> +               t->parent->comm, t->parent->pid, t->parent->uid,
> +               current->comm, current->pid, current->uid,
> +               current->parent->comm, current->parent->pid, current->parent->uid);
> +		read_unlock(&tasklist_lock);
> +	}
> +	return;
> +}
> +
> +/*
>   * Bad permissions for sending the signal
>   */
>  static int check_kill_permission(int sig, struct siginfo *info,
> @@ -536,6 +594,8 @@ static int check_kill_permission(int sig
>  	    && !capable(CAP_KILL))
>  		return error;
>  
> +	log_fatal_signal(sig, t);
> +
>  	return security_task_kill(t, info, sig, 0);
>  }
>  
> @@ -773,6 +833,9 @@ force_sig_info(int sig, struct siginfo *
>  		}
>  	}
>  	ret = specific_send_sig_info(sig, info, t);
> +
> +	log_fatal_signal(sig, t);
> +
>  	spin_unlock_irqrestore(&t->sighand->siglock, flags);
>  
>  	return ret;
> 
> --

Marcin
