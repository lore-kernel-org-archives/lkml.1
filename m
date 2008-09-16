Return-Path: <linux-kernel-owner+w=401wt.eu-S1754820AbYIPRnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820AbYIPRnZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 13:43:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753098AbYIPRnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 13:43:17 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:57568 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002AbYIPRnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 13:43:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AHlx02l/xChui1u86K22GcVGZcNvCCtTpBYu9BnAgY2eQHsjRmZ+8yPU7g4vWF2Egj
         TA+QllT9c1gS0FiyBr2D+NCdYHyKoltj0HPWFdr9+SDtRY4LP3sV78EZpygA9I2F1HLo
         0FbRvTI5qDTcqyW2patIRXfob9ktmhTjSaN/I=
Date: Tue, 16 Sep 2008 19:42:17 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: RFC: [patch] log fatal signals like SIGSEGV
Message-ID: <20080916174202.GA5703@joi>
References: <200809121502.15264.thomas.jarosch@intra2net.com> <20080912171055.GA5532@joi> <200809161459.17750.thomas.jarosch@intra2net.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809161459.17750.thomas.jarosch@intra2net.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2008 at 02:59:16PM +0200, Thomas Jarosch wrote:
> Here's the new version:
> -----------------------------------------------------------------
> From: Thomas Jarosch <thomas.jarosch@intra2net.com>
> 
> Log the signals SIGSEGV, SIGILL, SIGABRT, SIGBUS, SIGKILL and SIGFPE
> to aid debugging of obscure problems. Also logs the sender of the signal.
> 
> The log message looks like this:
> "kernel: signal 9 sent to freezed[2634] uid:100,
>  parent init[1] uid:0 by bash[3168] uid:0, parent sshd[3164] uid:0"
> 
> The printing code is based on grsecurity's signal logger.
> 
> Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
> Signed-off-by: Gerd v. Egidy <gve@intra2net.com>
> 
> diff -u -r -p linux-2.6.26.vanilla/kernel/signal.c linux-2.6.26/kernel/signal.c
> --- linux-2.6.26.vanilla/kernel/signal.c	Tue Sep 16 13:45:34 2008
> +++ linux-2.6.26/kernel/signal.c	Tue Sep 16 14:02:54 2008
> @@ -801,6 +801,24 @@ static inline int legacy_queue(struct si
>  	return (sig < SIGRTMIN) && sigismember(&signals->signal, sig);
>  }
>  
> +static void log_signal_and_sender(const int sig, const struct task_struct *t)
> +{
> +	if (!((sig == SIGSEGV) || (sig == SIGILL) || (sig == SIGABRT)
> +		|| (sig == SIGBUS) || (sig == SIGKILL) || (sig == SIGFPE)))
> +			return;
> +
> +	if (printk_ratelimit()) {
> +		/* Note: tasklist_lock is already locked by siglock */
> +		printk(KERN_WARNING "signal %d sent to %.30s[%d] uid:%u, "
> +				"parent %.30s[%d] uid:%u by %.30s[%d] uid:%u, "
> +				"parent %.30s[%d] uid:%u\n", sig, t->comm,
> +				t->pid, t->uid, t->parent->comm, t->parent->pid,
> +				t->parent->uid, current->comm, current->pid,
> +				current->uid, current->parent->comm,
> +				current->parent->pid, current->parent->uid);
> +	}
> +}
> +
>  static int send_signal(int sig, struct siginfo *info, struct task_struct *t,
>  			int group)
>  {
> @@ -810,6 +828,8 @@ static int send_signal(int sig, struct s
>  	assert_spin_locked(&t->sighand->siglock);
>  	if (!prepare_signal(sig, t))
>  		return 0;
> +
> +	log_signal_and_sender(sig, t);
>  
>  	pending = group ? &t->signal->shared_pending : &t->pending;
>  	/*
> 

It looks much better now. But I don't think it will go in as is.
Maybe you can disable it by default and create a sysctl switch?

Marcin
