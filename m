Return-Path: <linux-kernel-owner+w=401wt.eu-S1758719AbZKJX64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758719AbZKJX64 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 18:58:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758660AbZKJX6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 18:58:55 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44392 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754373AbZKJX6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 18:58:54 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: + oom-kill-show-virtual-size-and-rss-information-of-the-killed-process.patch added to -mm tree
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
In-Reply-To: <alpine.DEB.2.00.0911101522020.14504@chino.kir.corp.google.com>
References: <200911102159.nAALx4ds016632@imap1.linux-foundation.org> <alpine.DEB.2.00.0911101522020.14504@chino.kir.corp.google.com>
Message-Id: <20091111085345.FD21.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 11 Nov 2009 08:58:48 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc to linux-mm instead mm-commit)

> On Tue, 10 Nov 2009, akpm@linux-foundation.org wrote:
> 
> > diff -puN mm/oom_kill.c~oom-kill-show-virtual-size-and-rss-information-of-the-killed-process mm/oom_kill.c
> > --- a/mm/oom_kill.c~oom-kill-show-virtual-size-and-rss-information-of-the-killed-process
> > +++ a/mm/oom_kill.c
> > @@ -352,6 +352,8 @@ static void dump_header(gfp_t gfp_mask, 
> >  		dump_tasks(mem);
> >  }
> >  
> > +#define K(x) ((x) << (PAGE_SHIFT-10))
> > +
> >  /*
> >   * Send SIGKILL to the selected  process irrespective of  CAP_SYS_RAW_IO
> >   * flag though it's unlikely that  we select a process with CAP_SYS_RAW_IO
> > @@ -371,9 +373,16 @@ static void __oom_kill_task(struct task_
> >  		return;
> >  	}
> >  
> > -	if (verbose)
> > -		printk(KERN_ERR "Killed process %d (%s)\n",
> > -				task_pid_nr(p), p->comm);
> > +	if (verbose) {
> > +		task_lock(p);
> > +		printk(KERN_ERR "Killed process %d (%s) "
> > +		       "vsz:%lukB, anon-rss:%lukB, file-rss:%lukB\n",
> > +		       task_pid_nr(p), p->comm,
> > +		       K(p->mm->total_vm),
> > +		       K(get_mm_counter(p->mm, anon_rss)),
> > +		       K(get_mm_counter(p->mm, file_rss)));
> > +		task_unlock(p);
> > +	}
> >  
> >  	/*
> >  	 * We give our sacrificial lamb high priority and access to
> 
> There's a race there which can dereference a NULL p->mm.
> 
> p->mm is protected by task_lock(), but there's no check added here that 
> ensures p->mm is still valid.  The previous check for !p->mm in 
> __oom_kill_task() is not protected by task_lock(), so there's a race:
> 
> 	select_bad_process()
> 	oom_kill_process(p)
> 					do_exit()
> 					exit_signals(p) /* PF_EXITING */
> 	oom_kill_task(p)
> 	__oom_kill_task(p)
> 					exit_mm(p)
> 					task_lock(p)
> 					p->mm = NULL
> 					task_unlock(p)
> 	printk() of p->mm->total_vm
> 

Nice catch!



> Please merge this as a fix.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -367,22 +367,23 @@ static void __oom_kill_task(struct task_struct *p, int verbose)
>  		return;
>  	}
>  
> +	task_lock(p);
>  	if (!p->mm) {
>  		WARN_ON(1);
> -		printk(KERN_WARNING "tried to kill an mm-less task!\n");
> +		printk(KERN_WARNING "tried to kill an mm-less task %d (%s)!\n",
> +			task_pid_nr(p), p->comm);

This adding pid and comm are you new feature.
I hope andrew remain your signed-off-by to merged patch.
otherthings, looks pretty godd to me.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


> +		task_unlock(p);
>  		return;
>  	}
>  
> -	if (verbose) {
> -		task_lock(p);
> +	if (verbose)
>  		printk(KERN_ERR "Killed process %d (%s) "
>  		       "vsz:%lukB, anon-rss:%lukB, file-rss:%lukB\n",
>  		       task_pid_nr(p), p->comm,
>  		       K(p->mm->total_vm),
>  		       K(get_mm_counter(p->mm, anon_rss)),
>  		       K(get_mm_counter(p->mm, file_rss)));
> -		task_unlock(p);
> -	}
> +	task_unlock(p);
>  
>  	/*
>  	 * We give our sacrificial lamb high priority and access to



