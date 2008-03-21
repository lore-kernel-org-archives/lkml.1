Return-Path: <linux-kernel-owner+w=401wt.eu-S1761614AbYCUUCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761614AbYCUUCx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 16:02:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761429AbYCUUCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 16:02:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34416 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754629AbYCUUCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 16:02:11 -0400
Date: Fri, 21 Mar 2008 12:59:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg KH <greg@kroah.com>
Cc: heiko.carstens@de.ibm.com, mb@bu3sch.de, stern@rowland.harvard.edu,
       hmh@hmh.eng.br, david-b@pacbell.net, rpurdie@rpsys.net,
       linux-kernel@vger.kernel.org, mingo@elte.hu, geert@linux-m68k.org,
       netdev@vger.kernel.org, schwidefsky@de.ibm.com,
       linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
       video4linux-list@redhat.com, stefanr@s5r6.in-berlin.de,
       lm-sensors@lm-sensors.org
Subject: Re: use of preempt_count instead of in_atomic() at leds-gpio.c
Message-Id: <20080321125950.a5b38bda.akpm@linux-foundation.org>
In-Reply-To: <20080321165405.GC5766@kroah.com>
References: <Pine.LNX.4.44L0.0803202126240.11234-100000@netrider.rowland.org>
	<200803210236.52063.mb@bu3sch.de>
	<20080320192719.6a32386e.akpm@linux-foundation.org>
	<20080321134750.GB4128@osiris.boeblingen.de.ibm.com>
	<20080321165405.GC5766@kroah.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Mar 2008 09:54:05 -0700 Greg KH <greg@kroah.com> wrote:

> > > > You simply must always _know_, if you are allowed to sleep or not. This is
> > > > done by defining an API. The call-context is part of any kernel API.
> > > 
> > > Yup.  99.99% of kernel code manages to do this...
> > 
> > This is difficult for console drivers. They get called and are supposed to
> > print something and don't have the slightest clue which context they are
> > running in and if they are allowed to schedule.
> > This is the problem with e.g. s390's sclp driver. If there are no write
> > buffers available anymore it tries to allocate memory if schedule is allowed
> > or otherwise has to wait until finally a request finished and memory is
> > available again.
> > And now we have to always busy wait if we are out of buffers, since we
> > cannot tell which context we are in?
> 
> This is the reason why the drivers/usb/misc/sisusbvga driver is trying
> to test for in_atomic:
>         /* We can't handle console calls in non-schedulable
>          * context due to our locks and the USB transport.
>          * So we simply ignore them. This should only affect
>          * some calls to printk.
>          */
>         if (in_atomic())
>                 return NULL;
> 
> 
> So how should this be "fixed" if in_atomic() is not a valid test?

Well.  The kernel has traditionally assumed that console writes are atomic.

But we now have complex sleepy drivers acting as consoles.  Presumably this
means that large amounts of device driver code, page allocator code, etc
cannot have printks in them without going recursive.  Except printk itself
internally handles that, due to its need to be able to handle
printk-from-interrupt-when-this-cpu-is-already-running-printk.

The typical fix is for these console drivers to just assume that they
cannot sleep: pass GFP_ATOMIC down into the device driver code.  But I bet
the device driver code was designed assuming that it could sleep,
oops-bad-we-lose.

And it's not just sleep-in-spinlock.  If any of that device driver code
uses alloc_pages(GFP_KERNEL) then it can deadlock if we do a printk from
within the page allocator (and hence a lot of the block and storage layer).
Because in those code paths we must use GFP_NOFS or GFP_NOIO to allocate
memory.

So I think the right fix here is to switch those drivers to being
unconditionally atomic: don't schedule, don't take mutexes, don't use
__GFP_WAIT allocations.

They could of course be switched to using
kmalloc(GFP_ATOMIC)+memcpy()+schedule_task().  That's rather slow, but this
is not a performance-sensitive area.  But more seriously, this could lead
to messages getting lost from a dying machine.

One possibility would be to do current->called_for_console_output=1 and
then test that in various places.  But a) ugh and b) that's only useful for
memory allocations - it doesn't help if sleeping locks need to be taken.

Another possibility might be:

	if (current->called_for_console_output == false) {
		mutex_lock(lock);
	} else {
		if (!mutex_trylock(lock))
			return -EAGAIN;
	}

and then teach the console-calling code to requeue the message for later. 
But that's hard, because the straightforward implementation would result in
the output being queued for _all_ the currently active consoles, but some
of them might already have displayed this output - there's only one
log_buf.


An interesting problem ;)

