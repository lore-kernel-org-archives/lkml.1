Return-Path: <linux-kernel-owner+w=401wt.eu-S1753178AbZKLPAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178AbZKLPAn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 10:00:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753109AbZKLPAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 10:00:39 -0500
Received: from casper.infradead.org ([85.118.1.10]:44124 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084AbZKLPAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 10:00:39 -0500
Subject: Re: [PATCH] fix granularity of task_u/stime(), v2
From: Peter Zijlstra <peterz@infradead.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       Spencer Candland <spencer@bluehost.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@redhat.com>
In-Reply-To: <20091112144919.GA6218@dhcp-lab-161.englab.brq.redhat.com>
References: <4AF26176.4080307@jp.fujitsu.com>
	 <1257778154.4108.341.camel@laptop> <4AF8FD3C.2090008@jp.fujitsu.com>
	 <4AF8FE76.406@jp.fujitsu.com>
	 <20091111121150.GA2549@dhcp-lab-161.englab.brq.redhat.com>
	 <4AFB5019.7030901@jp.fujitsu.com> <4AFB77C2.8080705@jp.fujitsu.com>
	 <2375c9f90911111855w20491a1er8d3400cf4e027855@mail.gmail.com>
	 <4AFB8C21.6080404@jp.fujitsu.com> <4AFB9029.9000208@jp.fujitsu.com>
	 <20091112144919.GA6218@dhcp-lab-161.englab.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 Nov 2009 16:00:38 +0100
Message-ID: <1258038038.4039.467.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-12 at 15:49 +0100, Stanislaw Gruszka wrote:
>  I can not reproduce
> the bug with below patch:
> 
> diff --git a/kernel/exit.c b/kernel/exit.c
> index f7864ac..b85e384 100644
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -110,8 +110,8 @@ static void __exit_signal(struct task_struct *tsk)
>  		 * We won't ever get here for the group leader, since it
>  		 * will have been the last reference on the signal_struct.
>  		 */
> -		sig->utime = cputime_add(sig->utime, task_utime(tsk));
> -		sig->stime = cputime_add(sig->stime, task_stime(tsk));
> +		sig->utime = cputime_add(sig->utime, tsk->utime); //task_utime(tsk));
> +		sig->stime = cputime_add(sig->stime, tsk->stime); //task_stime(tsk));
>  		sig->gtime = cputime_add(sig->gtime, task_gtime(tsk));
>  		sig->min_flt += tsk->min_flt;
>  		sig->maj_flt += tsk->maj_flt;

Yes, this is the thing I suggested and makes sense.

> diff --git a/kernel/sys.c b/kernel/sys.c
> index ce17760..8be5b75 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -914,8 +914,8 @@ void do_sys_times(struct tms *tms)
>  	struct task_cputime cputime;
>  	cputime_t cutime, cstime;
>  
> -	thread_group_cputime(current, &cputime);
>  	spin_lock_irq(&current->sighand->siglock);
> +	thread_group_cputime(current, &cputime);
>  	cutime = current->signal->cutime;
>  	cstime = current->signal->cstime;
>  	spin_unlock_irq(&current->sighand->siglock);
> 
> Perhaps we can remove task_{u,s}time() in some places or maybe at whole ?

I think task_[us]time() still has value for getrusage() since it avoids
the task hiding from top by never running during the tick crap.

