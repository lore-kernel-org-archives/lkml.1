Return-Path: <linux-kernel-owner+w=401wt.eu-S1757161AbYIRUVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757161AbYIRUVX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 16:21:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755473AbYIRUVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 16:21:12 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:18135 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755329AbYIRUVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 16:21:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=s7reKyp5bqzF4YXnKI83xsRCxcsLLX/TTNBzmZAzj39JmUJsCKfZRaHtypBt1oDxCF
         TwsUzpZb+1bNJlpCT3MoOYP5T++Uf4Pub18SOeninnK6KTykP8bdltXz12rOWRdvOKtT
         gxSV7a+OjC8Bz3QaH+mwI7MZ9xkELfCN2DNoo=
Date: Thu, 18 Sep 2008 22:20:15 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: RFC: [patch] log fatal signals like SIGSEGV
Message-ID: <20080918202010.GA5656@joi>
References: <200809121502.15264.thomas.jarosch@intra2net.com> <200809161459.17750.thomas.jarosch@intra2net.com> <20080916174202.GA5703@joi> <200809181210.40336.thomas.jarosch@intra2net.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809181210.40336.thomas.jarosch@intra2net.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2008 at 12:10:39PM +0200, Thomas Jarosch wrote:
> > It looks much better now. But I don't think it will go in as is.
> > Maybe you can disable it by default and create a sysctl switch?
> 
> Thinking about it some more, I've added a "signal-log-level" sysctl var
> including documentation. The patch applies nicely to 2.6.26 and 2.6 HEAD.
> 
> The idea is to default to log level 1 and log fatal signals only.
> Log output should be close to zero during normal system operation.
> 
> There is a bit of a naming clash with "print-fatal-signals", though that
> should be called "debug-fatal-signals" because of all the register dumps etc.
> I don't want to rename it as it would unnecessarily cause issues
> and it's debug-only (Documentation/kernel-parameters.txt) anyway.
> 
> Enjoy.
> 
> ------------------------------------------------------
> From: Thomas Jarosch <thomas.jarosch@intra2net.com>
> 
> Log signals like SIGSEGV, SIGILL, SIGBUS or SIGFPE to aid tracing
> of obscure problems. Also logs the sender of the signal.
> 
> The log message looks like this:
> "kernel: signal 9 sent to freezed[2634] uid:100,
>  parent init[1] uid:0 by bash[3168] uid:0, parent sshd[3164] uid:0"
> 
> You can control the degree of logging via sysctl: "signal-log-level"
>     0 - Signal logging disabled
>     1 - Log SIGSEGV, SIGILL, SIGBUS and SIGPFE (default)
                                          ^^^^^^

>     2 - Log SIGKILL and SIGABRT and all signals from log level 1
>     3 or higher: Log all signals
> 
> The printing code is based on grsecurity's signal logger.
> 
> Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
> Signed-off-by: Gerd v. Egidy <gve@intra2net.com>
> 
> diff -u -r -p linux-2.6.26.vanilla/kernel/signal.c linux-2.6.26/kernel/signal.c
> --- linux-2.6.26.vanilla/kernel/signal.c	Tue Sep 16 13:45:34 2008
> +++ linux-2.6.26/kernel/signal.c	Thu Sep 18 10:43:27 2008
> @@ -796,6 +796,35 @@ static void complete_signal(int sig, str
>  	return;
>  }
>  
> +int signal_log_level __read_mostly = 1;
> +
> +static void log_signal(const int sig, const struct task_struct *t)
> +{
> +	bool log_signal = false;
> +
> +	if(signal_log_level >= 1 && (sig == SIGSEGV || sig == SIGILL
> +			|| sig == SIGBUS || sig == SIGFPE))
> +		log_signal = true;
> +	else if (signal_log_level >= 2 && (sig == SIGKILL || sig == SIGABRT))
> +		log_signal = true;
> +	else if (signal_log_level >= 3)
> +		log_signal = true;
> +
> +	if (!log_signal)
> +		return;
> +
> +	if (printk_ratelimit()) {
> +		/* Don't lock "tasklist_lock" here as it's already locked by "siglock" */
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
>  static inline int legacy_queue(struct sigpending *signals, int sig)
>  {
>  	return (sig < SIGRTMIN) && sigismember(&signals->signal, sig);
> @@ -810,6 +839,8 @@ static int send_signal(int sig, struct s
>  	assert_spin_locked(&t->sighand->siglock);
>  	if (!prepare_signal(sig, t))
>  		return 0;
> +
> +	log_signal(sig, t);
>  
>  	pending = group ? &t->signal->shared_pending : &t->pending;
>  	/*
> diff -u -r -p linux-2.6.26.vanilla/kernel/sysctl.c linux-2.6.26/kernel/sysctl.c
> --- linux-2.6.26.vanilla/kernel/sysctl.c	Sun Jul 13 23:51:29 2008
> +++ linux-2.6.26/kernel/sysctl.c	Thu Sep 18 10:08:47 2008
> @@ -63,6 +63,7 @@ static int deprecated_sysctl_warning(str
>  /* External variables not in a header file. */
>  extern int C_A_D;
>  extern int print_fatal_signals;
> +extern int signal_log_level;
>  extern int sysctl_overcommit_memory;
>  extern int sysctl_overcommit_ratio;
>  extern int sysctl_panic_on_oom;
> @@ -398,6 +428,14 @@ static struct ctl_table kern_table[] = {
>  		.ctl_name	= CTL_UNNUMBERED,
>  		.procname	= "print-fatal-signals",
>  		.data		= &print_fatal_signals,
> +		.maxlen		= sizeof(int),
> +		.mode		= 0644,
> +		.proc_handler	= &proc_dointvec,
> +	},
> +	{
> +		.ctl_name	= CTL_UNNUMBERED,
> +		.procname	= "signal-log-level",
> +		.data		= &signal_log_level,
>  		.maxlen		= sizeof(int),
>  		.mode		= 0644,
>  		.proc_handler	= &proc_dointvec,
> diff -u -r linux-2.6.26.vanilla/Documentation/sysctl/kernel.txt linux-2.6.26/Documentation/sysctl/kernel.txt
> --- linux-2.6.26.vanilla/Documentation/sysctl/kernel.txt	Sun Jul 13 23:51:29 2008
> +++ linux-2.6.26/Documentation/sysctl/kernel.txt	Thu Sep 18 10:50:13 2008
> @@ -47,6 +47,7 @@
>  - rtsig-max
>  - rtsig-nr
>  - sem
> +- signal-log-level
>  - sg-big-buff                 [ generic SCSI device (sg) ]
>  - shmall
>  - shmmax                      [ sysv ipc ]
> @@ -349,6 +350,21 @@
>  
>  ==============================================================
>  
> +signal-log-level: 
> +
> +Brief logging of signal and sender to aid
> +tracing of obsucure problems later on.
              ^^^^^^^^

> +
> +  0 - Signal logging disabled
> +
> +  1 - Log SIGSEGV, SIGILL, SIGBUS and SIGPFE (default)
                                         ^^^^^^

> +
> +  2 - Log SIGKILL and SIGABRT and all signals from log level 1
> +  
> +  3 or higher: Log all signals
> +
> +==============================================================
> +
>  softlockup_thresh:
>  
>  This value can be used to lower the softlockup tolerance
> 
> 

When fix typos you can add:
Reviewed-by: Marcin Slusarz <marcin.slusarz@gmail.com>
