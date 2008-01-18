Return-Path: <linux-kernel-owner+w=401wt.eu-S1763461AbYARQ3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763461AbYARQ3e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 11:29:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762657AbYARQ2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 11:28:14 -0500
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:64123 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763166AbYARQ2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 11:28:13 -0500
Date: Fri, 18 Jan 2008 11:26:28 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Jan Kiszka <jan.kiszka@siemens.com>
cc: Jiri Kosina <jikos@jikos.cz>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@openvz.org>, Kirill Korotaev <dev@sw.ru>
Subject: Re: [PATCH] printk deadlocks if called with runqueue lock held
In-Reply-To: <4790BDD1.40808@siemens.com>
Message-ID: <Pine.LNX.4.58.0801181120260.7574@gandalf.stny.rr.com>
References: <Pine.LNX.4.58.0801172000430.32679@gandalf.stny.rr.com>
 <Pine.LNX.4.64.0801181203240.15647@twin.jikos.cz>
 <Pine.LNX.4.58.0801180634040.7574@gandalf.stny.rr.com> <4790BDD1.40808@siemens.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 18 Jan 2008, Jan Kiszka wrote:

> Steven Rostedt wrote:
> ....
> > @@ -978,7 +980,13 @@ void release_console_sem(void)
> >  	console_locked = 0;
> >  	up(&console_sem);
>
> Hmm, just looking at this fragment: Doesn't up() include the risk of
> running onto the runqueue lock as well?

Very little risk (if any). If printk fails to get the console_sem it
doesn't block. So there would be no waiters on the semaphore, and thus
try_to_wake_up would not be called. The only place I see the down
actually being called is in suspend code, and even then, we would need to
lock the rq of the task that is trying to grab the console_sem and the
deadlock would only occur if that was on the same CPU. And honestly, I'm
not sure that's even possible.

-- Steve


>
> >  	spin_unlock_irqrestore(&logbuf_lock, flags);
> > -	if (wake_klogd)
> > +	/*
> > +	 * If we try to wake up klogd while printing with the runqueue lock
> > +	 * held, this will deadlock. We don't have access to the runqueue
> > +	 * lock from here, but just checking for interrupts disabled
> > +	 * should be enough.
> > +	 */
> > +	if (!irqs_disabled() && wake_klogd)
> >  		wake_up_klogd();
> >  }
> >  EXPORT_SYMBOL(release_console_sem);
>
> Jan
>
