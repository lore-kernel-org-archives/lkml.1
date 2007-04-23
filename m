Return-Path: <linux-kernel-owner+w=401wt.eu-S1161071AbXDWRts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161071AbXDWRts (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 13:49:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161113AbXDWRts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 13:49:48 -0400
Received: from mail.screens.ru ([213.234.233.54]:36437 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161071AbXDWRtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 13:49:47 -0400
Date: Mon, 23 Apr 2007 21:49:34 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: akpm@linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, vatsa@in.ibm.com,
       paulmck@us.ibm.com, pavel@ucw.cz
Subject: Re: [RFC PATCH 1/2] Fix PF_NOFREEZE and freezeable race
Message-ID: <20070423174934.GA229@tv-sign.ru>
References: <20070419120131.GB13435@in.ibm.com> <20070419120234.GA17069@in.ibm.com> <200704192339.30783.rjw@sisk.pl> <20070420180208.GA721@tv-sign.ru> <20070423102618.GA25144@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070423102618.GA25144@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23, Gautham R Shenoy wrote:
>
> On Fri, Apr 20, 2007 at 10:02:08PM +0400, Oleg Nesterov wrote:
> > 
> > Gautham, isn't it possible to make a more simpler patch ? Just add PF_NOFREEZE
> > check to frozen_process,
> > 
> > 	static inline void frozen_process(struct task_struct *p)
> > 	{
> > 		if (!unlikely(current->flags & PF_NOFREEZE)) {
> > 			p->flags |= PF_FROZEN;
> > 			wmb();
> > 		}
> > 		clear_tsk_thread_flag(p, TIF_FREEZE);
> > 	}
> > 
> 
> Btw, since frozen_process is currently being called only from
> refrigerator, I am wondering if we still need the struct task_struct *p
> parameter there. It's very unlikely that some other task would mark a
> particular task as frozen. No?

I agree. Only "current" can set PF_FROZEN anyway. I also think it is better
to move this function into kernel/power/process.c, no need to export it in
freezer.h. It is special, should be called from refrigerator() with task_lock()
held.

> Anyways, Andrew, Could you please replace the earlier sent patch titled
> "fix_pf_nofreeze_and_freezeable_race.patch" with the following one?
>
> ...
>
> --- linux-2.6.21-rc6.orig/include/linux/freezer.h
> +++ linux-2.6.21-rc6/include/linux/freezer.h
> @@ -57,8 +57,10 @@ static inline int thaw_process(struct ta
>   */
>  static inline void frozen_process(struct task_struct *p)
>  {
> -	p->flags |= PF_FROZEN;
> -	wmb();
> +	if (!unlikely(p->flags & PF_NOFREEZE)) {
> +		p->flags |= PF_FROZEN;
> +		wmb();
> +	}
>  	clear_tsk_thread_flag(p, TIF_FREEZE);
>  }

On the second thought, this patch doesn't help if the thread never
calls try_to_freeze() exactly because it marks itself PF_NOFREEZE.

Perhaps it is better to cancel freezing in soon-to-be-introduced
freezer_exempt().

In any case I agree, this one is better than current
	fix_pf_nofreeze_and_freezeable_race.patch

Oleg.

