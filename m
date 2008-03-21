Return-Path: <linux-kernel-owner+w=401wt.eu-S1759712AbYCUQzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759712AbYCUQzr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 12:55:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758116AbYCUQzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 12:55:22 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39727 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757763AbYCUQzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 12:55:19 -0400
Date: Fri, 21 Mar 2008 09:54:05 -0700
From: Greg KH <greg@kroah.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michael Buesch <mb@bu3sch.de>,
       Alan Stern <stern@rowland.harvard.edu>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       David Brownell <david-b@pacbell.net>,
       Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Geert Uytterhoeven <geert@linux-m68k.org>,
       netdev@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
       video4linux-list@redhat.com, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       lm-sensors@lm-sensors.org
Subject: Re: use of preempt_count instead of in_atomic() at leds-gpio.c
Message-ID: <20080321165405.GC5766@kroah.com>
References: <Pine.LNX.4.44L0.0803202126240.11234-100000@netrider.rowland.org> <200803210236.52063.mb@bu3sch.de> <20080320192719.6a32386e.akpm@linux-foundation.org> <20080321134750.GB4128@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080321134750.GB4128@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2008 at 02:47:50PM +0100, Heiko Carstens wrote:
> On Thu, Mar 20, 2008 at 07:27:19PM -0700, Andrew Morton wrote:
> > On Fri, 21 Mar 2008 02:36:51 +0100 Michael Buesch <mb@bu3sch.de> wrote:
> > > On Friday 21 March 2008 02:31:44 Alan Stern wrote:
> > > > On Thu, 20 Mar 2008, Andrew Morton wrote:
> > > > > On Thu, 20 Mar 2008 21:36:04 -0300 Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:
> > > > > 
> > > > > > Well, so far so good for LEDs, but what about the other users of in_atomic
> > > > > > that apparently should not be doing it either?
> > > > > 
> > > > > Ho hum.  Lots of cc's added.
> > > > 
> > > > ...
> > > > 
> > > > > The usual pattern for most of the above is
> > > > > 
> > > > > 	if (!in_atomic())
> > > > > 		do_something_which_might_sleep();
> > > > > 
> > > > > problem is, in_atomic() returns false inside spinlock on non-preptible
> > > > > kernels.  So if anyone calls those functions inside spinlock they will
> > > > > incorrectly schedule and another task can then come in and try take the
> > > > > already-held lock.
> > > > > 
> > > > > Now, it happens that in_atomic() returns true on non-preemtible kernels
> > > > > when running in interrupt or softirq context.  But if the above code really
> > > > > is using in_atomic() to detect am-i-called-from-interrupt and NOT
> > > > > am-i-called-from-inside-spinlock, they should be using in_irq(),
> > > > > in_softirq() or in_interrupt().
> > > > 
> > > > Presumably most of these places are actually trying to detect 
> > > > am-i-allowed-to-sleep.  Isn't that what in_atomic() is supposed to do?  
> > > 
> > > No, I think there is no such check in the kernel. Most likely for performance
> > > reasons, as it would require a global flag that is set on each spinlock.
> > 
> > Yup.  non-preemptible kernels avoid the inc/dec of
> > current_thread_info->preempt_count on spin_lock/spin_unlock
> > 
> > > You simply must always _know_, if you are allowed to sleep or not. This is
> > > done by defining an API. The call-context is part of any kernel API.
> > 
> > Yup.  99.99% of kernel code manages to do this...
> 
> This is difficult for console drivers. They get called and are supposed to
> print something and don't have the slightest clue which context they are
> running in and if they are allowed to schedule.
> This is the problem with e.g. s390's sclp driver. If there are no write
> buffers available anymore it tries to allocate memory if schedule is allowed
> or otherwise has to wait until finally a request finished and memory is
> available again.
> And now we have to always busy wait if we are out of buffers, since we
> cannot tell which context we are in?

This is the reason why the drivers/usb/misc/sisusbvga driver is trying
to test for in_atomic:
        /* We can't handle console calls in non-schedulable
         * context due to our locks and the USB transport.
         * So we simply ignore them. This should only affect
         * some calls to printk.
         */
        if (in_atomic())
                return NULL;


So how should this be "fixed" if in_atomic() is not a valid test?

thanks,

greg k-h
