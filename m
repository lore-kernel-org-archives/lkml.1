Return-Path: <linux-kernel-owner+w=401wt.eu-S965840AbXFGDVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965840AbXFGDVR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 23:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935753AbXFGDVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 23:21:07 -0400
Received: from gate.crashing.org ([63.228.1.57]:59666 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935607AbXFGDVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 23:21:06 -0400
Subject: Re: [BUG] ptraced process waiting on syscall may return kernel
	internal errnos
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Roland McGrath <roland@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
       Oleg Nesterov <oleg@tv-sign.ru>
In-Reply-To: <20070606105900.DE5E94D0592@magilla.localdomain>
References: <20070606105900.DE5E94D0592@magilla.localdomain>
Content-Type: text/plain
Date: Thu, 07 Jun 2007 13:20:18 +1000
Message-Id: <1181186418.14818.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-06 at 03:59 -0700, Roland McGrath wrote:
> Oleg and I were just discussing this issue in relation to other problems.
> We established that it is never safe to clear TIF_SIGPENDING on another
> thread.  But I hadn't really thought through that it's sometimes not safe
> to clear your own TIF_SIGPENDING either.  That is, any time you are not
> positive you cannot be in a syscall that will return a -ERESTART* code.
> (I had the ptrace_stop case lurking in the back of my mind but hadn't
> considered how it would really come up.)

Ah, I missed that ptrace_stop() case indeed.

> I have a general recollection of thinking that dequeue_signal could only
> be called on current and that it mattered somehow.

I matter with that, and with the notifier thingy. It might matter for
other things as well, I don't know for sure yet though signalfd will
definitely cause it to be called for !current, though with my patch only
for shared signals.

>   But aside from
> avoiding recalc_sigpending, and kernel threads with notifier_mask set, I
> can't see off hand what it is.  I won't testify that I think signalfd is
> necessarily on safe ground, though.

Yeah, I'm a little worried too, the whole thing seems a bit fragile to
me.

I'm tempted to in fact make dequeue_signal() be the only one to every
clear TIF_SIGPENDING and only when tsk==current, but then, that does
mean there are a few cases, like when explicitely masking signals, where
we might end up with it spurriously set... thus causing spurrious -EINTR
returns for blocked signals.

I must admit at this point, it's becoming almost tempting to split it
into two different flags. TIF_SIGPENDING would then be the exact logic
"there is currently a non blocked signal pending" and could be cleared
at any time provided the siglock is help (which btw, is another source
of headaches if you grep ... people maniupate these things here or there
without the lock). And another one, TIF_SIGNALED, which would be set
always if TIG_SIGPENDING is set, and only ever cleared by
dequeue_signal, and causes the exception path to get into do_signal.

That would mean occasional spurrious trips in do_signal but that's
totally harmless and it wouldn't, I beleive, happen often enough to
impact performances significantly.

Cheers,
Ben.
 

