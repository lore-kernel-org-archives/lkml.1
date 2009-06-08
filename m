Return-Path: <linux-kernel-owner+w=401wt.eu-S1753919AbZFHI3K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919AbZFHI3K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 04:29:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752905AbZFHI26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 04:28:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49797 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752818AbZFHI25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 04:28:57 -0400
Date: Mon, 8 Jun 2009 01:28:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Dave Young <hidave.darkstar@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v3] printk: add halt_delay parameter for printk delay in
 halt phase
Message-Id: <20090608012845.9c428525.akpm@linux-foundation.org>
In-Reply-To: <20090608081439.GB6372@elte.hu>
References: <a8e1da0906080040k7852f770v1e2aa2ebb0f52369@mail.gmail.com>
	<20090608081439.GB6372@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Jun 2009 10:14:39 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Dave Young <hidave.darkstar@gmail.com> wrote:
> 
> > Add a halt_delay module parameter in printk.c used to read the 
> > printk messages in halt/poweroff/restart phase, delay each printk 
> > messages by halt_delay milliseconds. It is useful for debugging if 
> > there's no other way to dump kernel messages that time.
> > 
> > The halt_delay max value is 65535, default value is 0, change it 
> > by:
> > 
> > echo xxx > /sys/module/printk/parameters/halt_delay
> > 
> > Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
> > ---
> > Documentation/kernel-parameters.txt |    5 +++++
> > kernel/printk.c                     |   17 +++++++++++++++++
> > 2 files changed, 22 insertions(+)
> > 
> > --- linux-2.6.orig/kernel/printk.c	2009-06-08 13:55:35.000000000 +0800
> > +++ linux-2.6/kernel/printk.c	2009-06-08 13:56:23.000000000 +0800
> > @@ -250,6 +250,22 @@ static inline void boot_delay_msec(void)
> >  }
> >  #endif
> > 
> > +/* msecs delay after each halt/poweroff/restart phase printk,
> > + unsigned short is enough for delay in milliseconds */
> > +static unsigned short halt_delay;
> > +
> > +static inline void halt_delay_msec(void)
> > +{
> > +	if (unlikely(halt_delay == 0 || !(system_state == SYSTEM_HALT
> > +				|| system_state == SYSTEM_POWER_OFF
> > +				|| system_state == SYSTEM_RESTART)))
> > +		return;
> 
> This is a tiny bit ugly (and goes into the vprintf path) but i can 
> see no other way either - a system_state > SYSTEM_RUNNING check 
> would needlessly include the suspend-to-disk state (which we dont 
> want to include here).
> 
> In theory we could turn system_state into a bitmask and have a 
> print_delay_mask check instead of these flags ... but that is a far 
> wider change and i'm not sure it's a net step forwards.
> 
> I've applied your patch to tip:core/printk with small edits to the 
> changelog - Linus & Andrew is Cc:ed, should they have any 
> objections.

Could we not put just a single delay in there, immediately prior to halting,
restarting or poweroffing?

