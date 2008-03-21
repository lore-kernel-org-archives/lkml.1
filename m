Return-Path: <linux-kernel-owner+w=401wt.eu-S1757722AbYCUNsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757722AbYCUNsQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 09:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755910AbYCUNr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 09:47:56 -0400
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:7778 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755616AbYCUNry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 09:47:54 -0400
Date: Fri, 21 Mar 2008 14:47:50 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michael Buesch <mb@bu3sch.de>, Alan Stern <stern@rowland.harvard.edu>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       David Brownell <david-b@pacbell.net>,
       Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Geert Uytterhoeven <geert@linux-m68k.org>,
       netdev@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
       video4linux-list@redhat.com, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       lm-sensors@lm-sensors.org
Subject: Re: use of preempt_count instead of in_atomic() at leds-gpio.c
Message-ID: <20080321134750.GB4128@osiris.boeblingen.de.ibm.com>
References: <Pine.LNX.4.44L0.0803202126240.11234-100000@netrider.rowland.org> <200803210236.52063.mb@bu3sch.de> <20080320192719.6a32386e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080320192719.6a32386e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2008 at 07:27:19PM -0700, Andrew Morton wrote:
> On Fri, 21 Mar 2008 02:36:51 +0100 Michael Buesch <mb@bu3sch.de> wrote:
> > On Friday 21 March 2008 02:31:44 Alan Stern wrote:
> > > On Thu, 20 Mar 2008, Andrew Morton wrote:
> > > > On Thu, 20 Mar 2008 21:36:04 -0300 Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:
> > > > 
> > > > > Well, so far so good for LEDs, but what about the other users of in_atomic
> > > > > that apparently should not be doing it either?
> > > > 
> > > > Ho hum.  Lots of cc's added.
> > > 
> > > ...
> > > 
> > > > The usual pattern for most of the above is
> > > > 
> > > > 	if (!in_atomic())
> > > > 		do_something_which_might_sleep();
> > > > 
> > > > problem is, in_atomic() returns false inside spinlock on non-preptible
> > > > kernels.  So if anyone calls those functions inside spinlock they will
> > > > incorrectly schedule and another task can then come in and try take the
> > > > already-held lock.
> > > > 
> > > > Now, it happens that in_atomic() returns true on non-preemtible kernels
> > > > when running in interrupt or softirq context.  But if the above code really
> > > > is using in_atomic() to detect am-i-called-from-interrupt and NOT
> > > > am-i-called-from-inside-spinlock, they should be using in_irq(),
> > > > in_softirq() or in_interrupt().
> > > 
> > > Presumably most of these places are actually trying to detect 
> > > am-i-allowed-to-sleep.  Isn't that what in_atomic() is supposed to do?  
> > 
> > No, I think there is no such check in the kernel. Most likely for performance
> > reasons, as it would require a global flag that is set on each spinlock.
> 
> Yup.  non-preemptible kernels avoid the inc/dec of
> current_thread_info->preempt_count on spin_lock/spin_unlock
> 
> > You simply must always _know_, if you are allowed to sleep or not. This is
> > done by defining an API. The call-context is part of any kernel API.
> 
> Yup.  99.99% of kernel code manages to do this...

This is difficult for console drivers. They get called and are supposed to
print something and don't have the slightest clue which context they are
running in and if they are allowed to schedule.
This is the problem with e.g. s390's sclp driver. If there are no write
buffers available anymore it tries to allocate memory if schedule is allowed
or otherwise has to wait until finally a request finished and memory is
available again.
And now we have to always busy wait if we are out of buffers, since we
cannot tell which context we are in?
