Return-Path: <linux-kernel-owner+w=401wt.eu-S1755298AbZFHI6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298AbZFHI6c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 04:58:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751506AbZFHI6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 04:58:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49759 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308AbZFHI6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 04:58:24 -0400
Date: Mon, 8 Jun 2009 10:58:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v3] printk: add halt_delay parameter for printk delay
	in halt phase
Message-ID: <20090608085819.GH6372@elte.hu>
References: <a8e1da0906080040k7852f770v1e2aa2ebb0f52369@mail.gmail.com> <20090608081439.GB6372@elte.hu> <a8e1da0906080137r179b0a5l81bb604fd64800d3@mail.gmail.com> <20090608084611.GD6372@elte.hu> <a8e1da0906080156g29ebee6fv446b488f4d55d1a1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a8e1da0906080156g29ebee6fv446b488f4d55d1a1@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dave Young <hidave.darkstar@gmail.com> wrote:

> On Mon, Jun 8, 2009 at 4:46 PM, Ingo Molnar<mingo@elte.hu> wrote:
> >
> > * Dave Young <hidave.darkstar@gmail.com> wrote:
> >
> >> On Mon, Jun 8, 2009 at 4:14 PM, Ingo Molnar<mingo@elte.hu> wrote:
> >> >
> >> > * Dave Young <hidave.darkstar@gmail.com> wrote:
> >> >
> >> >> Add a halt_delay module parameter in printk.c used to read the
> >> >> printk messages in halt/poweroff/restart phase, delay each printk
> >> >> messages by halt_delay milliseconds. It is useful for debugging if
> >> >> there's no other way to dump kernel messages that time.
> >> >>
> >> >> The halt_delay max value is 65535, default value is 0, change it
> >> >> by:
> >> >>
> >> >> echo xxx > /sys/module/printk/parameters/halt_delay
> >> >>
> >> >> Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
> >> >> ---
> >> >> Documentation/kernel-parameters.txt |    5 +++++
> >> >> kernel/printk.c                     |   17 +++++++++++++++++
> >> >> 2 files changed, 22 insertions(+)
> >> >>
> >> >> --- linux-2.6.orig/kernel/printk.c    2009-06-08 13:55:35.000000000 +0800
> >> >> +++ linux-2.6/kernel/printk.c 2009-06-08 13:56:23.000000000 +0800
> >> >> @@ -250,6 +250,22 @@ static inline void boot_delay_msec(void)
> >> >>  }
> >> >>  #endif
> >> >>
> >> >> +/* msecs delay after each halt/poweroff/restart phase printk,
> >> >> + unsigned short is enough for delay in milliseconds */
> >> >> +static unsigned short halt_delay;
> >> >> +
> >> >> +static inline void halt_delay_msec(void)
> >> >> +{
> >> >> +     if (unlikely(halt_delay == 0 || !(system_state == SYSTEM_HALT
> >> >> +                             || system_state == SYSTEM_POWER_OFF
> >> >> +                             || system_state == SYSTEM_RESTART)))
> >> >> +             return;
> >> >
> >> > This is a tiny bit ugly (and goes into the vprintf path) but i
> >> > can see no other way either - a system_state > SYSTEM_RUNNING
> >> > check would needlessly include the suspend-to-disk state (which
> >> > we dont want to include here).
> >>
> >> Can we move suspend-to-disk before halt state?
> >
> > Yes, we could do that - if all system_state uses are checked for
> > side-effects - in particular comparisons. We have a few places that
> > do 'if (system_state > SYSTEM_RUNNING)' - to designate 'shutdown
> > state'. Now, if we have any use of > SYSTEM_SHUTDOWN that might
> > break from such a reordering.
> >
> > I wouldnt expect such usage really, but it has to be checked. That
> > would make this patch quite a bit cleaner.
> >
> > Mind sending a followup delta patch with this cleanup?
> 
> I'm glad to check the system_state usage, then write a followup patch.

I'd also suggest to add a comment to the constants, to make sure 
that when new system states are added, the ordering assumptions are 
not broken.

	Ingo
