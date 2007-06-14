Return-Path: <linux-kernel-owner+w=401wt.eu-S1752797AbXFNM6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797AbXFNM6v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 08:58:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751394AbXFNM6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 08:58:43 -0400
Received: from mail.screens.ru ([213.234.233.54]:53554 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333AbXFNM6m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 08:58:42 -0400
Date: Thu, 14 Jun 2007 16:58:43 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Roland McGrath <roland@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [BUG] ptraced process waiting on syscall may return kernel internal errnos
Message-ID: <20070614125843.GA78@tv-sign.ru>
References: <87hcplvdkl.wl%takeuchi_satoru@jp.fujitsu.com> <20070606105900.DE5E94D0592@magilla.localdomain> <20070613151530.GA232@tv-sign.ru> <200706141426.45522.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706141426.45522.rjw@sisk.pl>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14, Rafael J. Wysocki wrote:
>
> Sorry for being late, I've just realized that you are discussing the freezer
> here. ;-)

my fault, I was going to cc you but forgot, sorry!

> On Wednesday, 13 June 2007 17:15, Oleg Nesterov wrote:
>
> > > @@ -105,7 +105,11 @@ static int recalc_sigpending_tsk(struct 
> > >  		set_tsk_thread_flag(t, TIF_SIGPENDING);
> > >  		return 1;
> > >  	}
> > > -	clear_tsk_thread_flag(t, TIF_SIGPENDING);
> > > +	/*
> > > +	 * We must never clear the flag in another thread, or in current
> > > +	 * when it's possible the current syscall is returning -ERESTART*.
> > > +	 * So we don't clear it here, and only callers who know they should do.
> > > +	 */
> > >  	return 0;
> > >  }
> > 
> > This breaks cancel_freezing(). Somehow we should clear TIF_SIGPENDING for
> > kernel threads. Otherwise we may have subtle failures if try_to_freeze_tasks()
> > fails.
> 
> Well, the only code path in which we'd want to call cancel_freezing() for kernel
> threads is when the freezing of kernel threads.  However, this only happens if
> one of the kernel threads declares itself as freezable and the fails to call
> try_to_freeze(), which is a bug.

But this happens? We know a lot of reasons why try_to_freeze() can fail just
because some kthread waits for already frozen task.

>                                   Thus I don't think that we need to worry
> about that case too much.

Well, we can have very subtle problems because a kernel thread may run with
TIF_SIGPENDING forever. This means in particualar that any wait_event_interruptible()
can't succeed. I think this is worse than explicit failure (like -ERESSTART... leak),
because it is hard to reproduce/debug.

> Moreover, I'm not sure that it's a good idea at all to send signals to kernel
> threads from the freezer, since in fact we only need to wake them up to make
> them call try_to_freeze() (after we've set TIF_FREEZE for them).

Yes! I completely agree.

Oleg.

