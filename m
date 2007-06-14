Return-Path: <linux-kernel-owner+w=401wt.eu-S1752681AbXFNMUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681AbXFNMUo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 08:20:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751703AbXFNMUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 08:20:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50986 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450AbXFNMUS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 08:20:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [BUG] ptraced process waiting on syscall may return kernel internal errnos
Date: Thu, 14 Jun 2007 14:26:44 +0200
User-Agent: KMail/1.9.5
Cc: Roland McGrath <roland@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
References: <87hcplvdkl.wl%takeuchi_satoru@jp.fujitsu.com> <20070606105900.DE5E94D0592@magilla.localdomain> <20070613151530.GA232@tv-sign.ru>
In-Reply-To: <20070613151530.GA232@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706141426.45522.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for being late, I've just realized that you are discussing the freezer
here. ;-)

On Wednesday, 13 June 2007 17:15, Oleg Nesterov wrote:
> Sorry for delay, I was completely offline,
> 
> On 06/06, Roland McGrath wrote:
> > 
> > [PATCH] Restrict clearing TIF_SIGPENDING
> > 
> > This patch should get a few birds.  It prevents sigaction calls from
> > clearing TIF_SIGPENDING in other threads, which could leak -ERESTART*.
> > It fixes ptrace_stop not to clear it, which done at the syscall exit
> > stop could leak -ERESTART*.  It probably removes the harm from
> > signalfd, at least assuming it never calls dequeue_signal on kernel
> > threads that might have used block_all_signals.
> > 
> > Signed-off-by: Roland McGrath <roland@redhat.com>
> > ---
> >  kernel/signal.c |   40 ++++++++++++++++++++++++----------------
> >  1 files changed, 24 insertions(+), 16 deletions(-)
> > 
> > diff --git a/kernel/signal.c b/kernel/signal.c
> > index acdfc05..dc5797c 100644  
> > --- a/kernel/signal.c
> > +++ b/kernel/signal.c
> > @@ -105,7 +105,11 @@ static int recalc_sigpending_tsk(struct 
> >  		set_tsk_thread_flag(t, TIF_SIGPENDING);
> >  		return 1;
> >  	}
> > -	clear_tsk_thread_flag(t, TIF_SIGPENDING);
> > +	/*
> > +	 * We must never clear the flag in another thread, or in current
> > +	 * when it's possible the current syscall is returning -ERESTART*.
> > +	 * So we don't clear it here, and only callers who know they should do.
> > +	 */
> >  	return 0;
> >  }
> 
> This breaks cancel_freezing(). Somehow we should clear TIF_SIGPENDING for
> kernel threads. Otherwise we may have subtle failures if try_to_freeze_tasks()
> fails.

Well, the only code path in which we'd want to call cancel_freezing() for kernel
threads is when the freezing of kernel threads.  However, this only happens if
one of the kernel threads declares itself as freezable and the fails to call
try_to_freeze(), which is a bug.  Thus I don't think that we need to worry
about that case too much.

Moreover, I'm not sure that it's a good idea at all to send signals to kernel
threads from the freezer, since in fact we only need to wake them up to make
them call try_to_freeze() (after we've set TIF_FREEZE for them).

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
