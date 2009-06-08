Return-Path: <linux-kernel-owner+w=401wt.eu-S1757441AbZFHQbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441AbZFHQbw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 12:31:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756111AbZFHQbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 12:31:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56731 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756033AbZFHQbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 12:31:45 -0400
Date: Mon, 8 Jun 2009 09:26:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Dave Young <hidave.darkstar@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v3] printk: add halt_delay parameter for printk delay in
 halt phase
Message-Id: <20090608092607.8b331bf0.akpm@linux-foundation.org>
In-Reply-To: <20090608084807.GE6372@elte.hu>
References: <a8e1da0906080040k7852f770v1e2aa2ebb0f52369@mail.gmail.com>
	<20090608081439.GB6372@elte.hu>
	<20090608012845.9c428525.akpm@linux-foundation.org>
	<a8e1da0906080142u62a45c47g2181a79addfb6168@mail.gmail.com>
	<20090608084807.GE6372@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Jun 2009 10:48:07 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Dave Young <hidave.darkstar@gmail.com> wrote:
> 
> > On Mon, Jun 8, 2009 at 4:28 PM, Andrew Morton<akpm@linux-foundation.org> wrote:
> > > On Mon, 8 Jun 2009 10:14:39 +0200 Ingo Molnar <mingo@elte.hu> wrote:
> > >
> > >>
> > >> * Dave Young <hidave.darkstar@gmail.com> wrote:
> > >>
> > >> > Add a halt_delay module parameter in printk.c used to read the
> > >> > printk messages in halt/poweroff/restart phase, delay each printk
> > >> > messages by halt_delay milliseconds. It is useful for debugging if
> > >> > there's no other way to dump kernel messages that time.
> > >> >
> > >> > The halt_delay max value is 65535, default value is 0, change it
> > >> > by:
> > >> >
> > >> > echo xxx > /sys/module/printk/parameters/halt_delay
> > >> >
> > >> > Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
> > >> > ---
> > >> > Documentation/kernel-parameters.txt | __ __5 +++++
> > >> > kernel/printk.c __ __ __ __ __ __ __ __ __ __ | __ 17 +++++++++++++++++
> > >> > 2 files changed, 22 insertions(+)
> > >> >
> > >> > --- linux-2.6.orig/kernel/printk.c __2009-06-08 13:55:35.000000000 +0800
> > >> > +++ linux-2.6/kernel/printk.c __ __ __ 2009-06-08 13:56:23.000000000 +0800
> > >> > @@ -250,6 +250,22 @@ static inline void boot_delay_msec(void)
> > >> > __}
> > >> > __#endif
> > >> >
> > >> > +/* msecs delay after each halt/poweroff/restart phase printk,
> > >> > + unsigned short is enough for delay in milliseconds */
> > >> > +static unsigned short halt_delay;
> > >> > +
> > >> > +static inline void halt_delay_msec(void)
> > >> > +{
> > >> > + __ if (unlikely(halt_delay == 0 || !(system_state == SYSTEM_HALT
> > >> > + __ __ __ __ __ __ __ __ __ __ __ __ __ || system_state == SYSTEM_POWER_OFF
> > >> > + __ __ __ __ __ __ __ __ __ __ __ __ __ || system_state == SYSTEM_RESTART)))
> > >> > + __ __ __ __ __ return;
> > >>
> > >> This is a tiny bit ugly (and goes into the vprintf path) but i can
> > >> see no other way either - a system_state > SYSTEM_RUNNING check
> > >> would needlessly include the suspend-to-disk state (which we dont
> > >> want to include here).
> > >>
> > >> In theory we could turn system_state into a bitmask and have a
> > >> print_delay_mask check instead of these flags ... but that is a far
> > >> wider change and i'm not sure it's a net step forwards.
> > >>
> > >> I've applied your patch to tip:core/printk with small edits to the
> > >> changelog - Linus & Andrew is Cc:ed, should they have any
> > >> objections.
> > >
> > > Could we not put just a single delay in there, immediately prior to halting,
> > > restarting or poweroffing?
> > 
> > But, then prink messages will still flush too fast for us to see 
> > the detail.

Only if there are so many unlogged messages that they scroll of the
screen.  Is that the case?

> Plus often there's a loop in architecture code that tries various 
> methods of reboot. We dont know which one works - and any of them 
> could produce warning messages. (and this happened a number of times 
> in the past)
> 
> So this would mean having to find up to a hundred of 'reboot now' 
> places in a two dozen architectures (and keeping them all maintained 
> ongoing as well). Does not seem like a good choice to me.
> 

hm.  If we need to actually capture all of those.

questions: is it possible for interrupts to be disabled at this time? 
If so, can we get an NMI watchdog hit?

Is the softlockup detector still running and if so, can it trigger?

