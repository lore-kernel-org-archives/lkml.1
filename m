Return-Path: <linux-kernel-owner+w=401wt.eu-S1762041AbZJJSAL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762041AbZJJSAL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 14:00:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754222AbZJJSAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 14:00:10 -0400
Received: from www.tglx.de ([62.245.132.106]:46383 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752455AbZJJSAJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 14:00:09 -0400
Date: Sat, 10 Oct 2009 19:59:06 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Blaise Gassend <blaise@willowgarage.com>
cc: LKML <linux-kernel@vger.kernel.org>, Jeremy Leibs <leibs@willowgarage.com>,
       Darren Hart <dvhltc@us.ibm.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: ERESTARTSYS escaping from sem_wait with RTLinux patch
In-Reply-To: <1255165747.6385.117.camel@doodleydee>
Message-ID: <alpine.LFD.2.00.0910101931080.9428@localhost.localdomain>
References: <1255165747.6385.117.camel@doodleydee>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Blaise,

On Sat, 10 Oct 2009, Blaise Gassend wrote:
> 1) Where is the ERESTARTSYS being prevented from getting to user space? 
> 
> The only likely place I see for preventing ERESTARTSYS from escaping to
> user space is in arch/*/kernel/signal*.c. However, I don't see how the
> code there is being called if there no signal pending. Is that a path
> for ERESTARTSYS to escape from the kernel?
> 
> The following comment in kernel/futex.h in futex_wait makes me wonder if
> two threads are getting marked as ERESTARTSYS. The first one to leave
> the kernel processes the signal and restarts. The second one doesn't
> have a signal to handle, so it returns to user space without getting
> into signal*.c and wreaks havoc.
> 
>     (...)
>         /*
>          * We expect signal_pending(current), but another thread may
>          * have handled it for us already.
>          */
>         if (!abs_time)
>                 return -ERESTARTSYS;
>     (...)

If the task is woken by a signal, then the task private flag
TIF_SIGPENDING is set, but in case of a process wide signal the signal
might have been handled by another thread of the same process before
that thread reaches the signal handling code, but then ERESTARTSYS is
handled gracefully. So you seem to trigger a code path which does not
go through do_signal.

> 2) Why would this be happening only with RT kernels?

Slightly different timing and locking semantics.

> 3) Any suggestions on the best place to patch/workaround this? 
> 
> My understanding is that if I was to treat ERESTARTSYS as an EAGAIN,
> most applications would be perfectly happy. Would bad things happen if I
> replaced the ERESTARTSYS in futex_wait with an EAGAIN?

No workarounds please. We really want to know what's wrong.

Two things to look at:

1) Does that happen with 2.6.31.2-rt13 as well ?

2) Add a check to the code path where ERESTARTSYS is returned:

   if (!signal_pending(current))
      printk(KERN_ERR "....."); 

If you can see that message then we'll look further. I'll give your
script a test ride on my systems as well.

Thanks,

	tglx
