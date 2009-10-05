Return-Path: <linux-kernel-owner+w=401wt.eu-S932478AbZJELvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932478AbZJELvk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 07:51:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932435AbZJELvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 07:51:40 -0400
Received: from www.tglx.de ([62.245.132.106]:52407 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932434AbZJELvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 07:51:39 -0400
Date: Mon, 5 Oct 2009 13:50:46 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Anirban Sinha <ani@anirban.org>,
       linux-kernel@vger.kernel.org, Darren Hart <dvhltc@us.ibm.com>,
       Kaz Kylheku <kaz@zeugmasystems.com>,
       Anirban Sinha <asinha@zeugmasystems.com>
Subject: Re: futex question
In-Reply-To: <20091005111933.GA25889@elte.hu>
Message-ID: <alpine.LFD.2.00.0910051347470.2646@localhost.localdomain>
References: <20091001092218.GH15345@elte.hu> <DDFD17CC94A9BD49A82147DDF7D545C501FD8409@exchange.ZeugmaSystems.local> <4AC68F13.8050601@us.ibm.com> <alpine.LFD.2.00.0910041031330.2646@localhost.localdomain> <DDFD17CC94A9BD49A82147DDF7D545C501F457C5@exchange.ZeugmaSystems.local>
 <4AC8CF32.8060108@anirban.org> <alpine.LFD.2.00.0910041853180.2646@localhost.localdomain> <1254738974.26976.24.camel@twins> <alpine.LFD.2.00.0910051251080.2646@localhost.localdomain> <1254741372.26976.35.camel@twins> <20091005111933.GA25889@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Oct 2009, Ingo Molnar wrote:
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > diff --git a/fs/exec.c b/fs/exec.c
> > index d49be6b..0812ba6 100644
> > --- a/fs/exec.c
> > +++ b/fs/exec.c
> > @@ -1295,6 +1295,22 @@ int do_execve(char * filename,
> >  	bool clear_in_exec;
> >  	int retval;
> >  
> > +	retval = -EWOULDBLOCK;
> > +#ifdef CONFIG_FUTEX
> > +	if (unlikely(current->robust_list))
> > +		goto out_ret;
> > +#ifdef CONFIG_COMPAT
> > +	if (unlikely(current->compat_robust_list))
> > +		goto out_ret;
> > +#endif
> > +	spin_lock_irq(&current->pi_lock);
> > +	if (!list_empty(&current->pi_state_list)) {
> > +		spin_unlock_irq(&current->pi_lock);
> > +		goto out_ret;
> > +	}
> > +	spin_unlock_irq(&current->pi_lock);
> > +#endif
> 
> i suspect this should have the form of:
> 
> 	retval = can_exec_robust_futexes();
> 	if (retval)
> 		goto out_ret

  Yes.
 
>   	retval = unshare_files(&displaced);
>   	if (retval)
>   		goto out_ret;
> 
> 	...
> 
> but ... shouldnt we just do what exec normally does and zap any state 
> that shouldnt be carried over into the new context - instead of denying 
> the exec? Am i missing something?

We want to check whether the robust list is empty. If it's not empty
then we deny the exec instead of silently releasing the futexes or
just ignoring the robust list entirely. Same applies for the pi
waiters list.

Thanks,

	tglx
