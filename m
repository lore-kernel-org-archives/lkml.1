Return-Path: <linux-kernel-owner+w=401wt.eu-S1760403AbXELQ7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760403AbXELQ7a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 12:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756997AbXELQ7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 12:59:19 -0400
Received: from mail.screens.ru ([213.234.233.54]:56895 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757029AbXELQ7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 12:59:17 -0400
Date: Sat, 12 May 2007 20:58:57 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 1/7] Freezer: Read PF_BORROWED_MM in a nonracy way
Message-ID: <20070512165857.GA274@tv-sign.ru>
References: <200705110035.32229.rjw@sisk.pl> <200705121245.50715.rjw@sisk.pl> <20070512141813.GA98@tv-sign.ru> <200705121835.21333.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200705121835.21333.rjw@sisk.pl>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12, Rafael J. Wysocki wrote:
>
> Ah, I see.  We spawn a kernel thread from a code path that belongs to a
> user space task and we need to call deamonize() to make it become a
> 'real' kernel thread.
> 
> Still, this means that is_user_space() may return 'true' for this thread
> before it calls daemonize() and then the scenario described by me in the
> previous message may occur.  It seems.

Yes sure. Probably not so bad in practice. Most likely this fresh thread
is not "important" and could be freezed, I dunno.

> It's in freezer-fix-pf_nofreeze-vs-freezeable-race.patch (appended for
> convenience, white space may be broken).
>
> ---
> --- a/include/linux/freezer.h~freezer-fix-pf_nofreeze-vs-freezeable-race
> +++ a/include/linux/freezer.h
> @@ -63,8 +63,10 @@ static inline int thaw_process(struct ta
>   */
>  static inline void frozen_process(struct task_struct *p)
>  {
> -       p->flags |= PF_FROZEN;
> -       wmb();
> +       if (!unlikely(p->flags & PF_NOFREEZE)) {
> +               p->flags |= PF_FROZEN;
> +               wmb();
> +       }
>         clear_tsk_thread_flag(p, TIF_FREEZE);
>  }

This is OK if a kernel thread does try_to_freeze() eventually.

But what if it does not, because it marks itself as PF_NOFREEZE?
This means it may run with signal_pending() forever. That is why
I think we should clear TIF_FREEZE when we set PF_NOFREEZE.

Oleg.

