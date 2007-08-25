Return-Path: <linux-kernel-owner+w=401wt.eu-S964931AbXHYK6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964931AbXHYK6y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 06:58:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932907AbXHYK6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 06:58:45 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:51435 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765059AbXHYK6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 06:58:44 -0400
Date: Sat, 25 Aug 2007 15:01:39 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Dave Airlie <airlied@gmail.com>
Cc: Dave Airlie <airlied@redhat.com>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: What does drm do with signals?
Message-ID: <20070825110139.GA234@tv-sign.ru>
References: <20070823155825.GA1536@tv-sign.ru> <21d7e9970708250056g561912fk45b4b943b0a353e3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21d7e9970708250056g561912fk45b4b943b0a353e3@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25, Dave Airlie wrote:
>
> On 8/24/07, Oleg Nesterov <oleg@tv-sign.ru> wrote:
> > Could someone please explain why do we need block_all_signals() ?
> >
> > I can't understand what was the intended behaviour, but anyway
> > I suspect it doesn't work as expected.
> 
> http://dri.sourceforge.net/doc/drm_low_level.html
> 
> Section 4.1 explains the intent...

Thanks a lot Dave, I'll quote this doc:

> 4.1 Delaying Signal Delivery
>
>  If the direct-rendering client holds the hardware lock and receives
>  a SIGKILL signal, deadlock may result. If the SIGKILL is detected
>  and the hardware lock is immediately taken from the client, the
>  typical PC-class graphics hardware may be left in an unknown state
>  and may lock up (this kind of hardware usually does not deal well
>  with intermingling of command streams).
>
>  Similarly, if the direct-rendering client holds the hardware lock
>  and receives a SIGSTOP, the X server and all other direct-rendering
>  clients will block until the process releases the lock.
>
>  Ideally, the client should be permitted to complete the rendering
>  operation that is currently in progress and have the SIGKILL or SIGSTOP
>  signals delivered as soon as the hardware lock is released (or, after
>  some reasonable timeout, so that buggy clients can be halted). This
>  delay of signal delivery appears to require kernel-level changes
>  that cannot be performed by a loadable module using the standard
>  module interface.

but drm_lock() doesn't even try to block SIGKILL?

However, I think that block_all_signals() and its usage are broken
in many ways. To name a few,

1. It can't work for multithread programs. dequeue_signal() checks
   current->notifier, but this is per thread, not per process.

2. We can't block the "pseudo signals" (freezer).

3. If we want to block SIGKILL, we should also block at least all
   sig_kernel_coredump() signals. But this is not easy to do for
   multithread programms, all sub-threads except ->group_exit_task
   go to sleep in TASK_STOPPED state without doing dequeue_signal()
   at all.

4. What about other sig_fatal() signals?

5. drm_lock() blocks SIGSTOP, SIGTSTP, SIGTTIN, SIGTTOU. Suppose
   that (say) SIGTSTP is pending. In that case we in fact block
   _all_ signals whose numeric value > SIGTSTP. This is somewhat
   strange.

Probably something else... Actually, the whole idea looks broken to
me, but yes, it is very easy to blame somebody else's code and I
don't even remotely understand what drm is.

I tried to google for the patch which introduced this interface
but failed. Looks like this is very old thing.

Actually, I can't understand the explanation above. What if the
task which holds the hardware lock doesn't recieve SIGSTOP, but
instead does something like "for (;;) ;" ?

Oleg.

