Return-Path: <linux-kernel-owner+w=401wt.eu-S1767649AbXDFODO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767649AbXDFODO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 10:03:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767659AbXDFODO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 10:03:14 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:53869 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1767649AbXDFODM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 10:03:12 -0400
Date: Mon, 2 Apr 2007 22:51:27 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Gautham R Shenoy <ego@in.ibm.com>, akpm@linux-foundation.org,
       paulmck@us.ibm.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, vatsa@in.ibm.com,
       Oleg Nesterov <oleg@tv-sign.ru>, mingo@elte.hu, dipankar@in.ibm.com,
       dino@in.ibm.com, masami.hiramatsu.pt@hitachi.com
Subject: Re: [PATCH 1/8] Enhance process freezer interface for usage beyond software suspend
Message-ID: <20070402205127.GF3840@elf.ucw.cz>
References: <20070402053457.GA9076@in.ibm.com> <20070402053705.GA12962@in.ibm.com> <20070402135632.GC6739@ucw.cz> <200704022248.25948.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704022248.25948.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > +/* Per process freezer specific flags */
> > > +#define PF_FE_SUSPEND	0x00008000	/* This thread should not be frozen
> > > +					 * for suspend
> > > +					 */
> > > +
> > > +#define PF_FE_KPROBES	0x00000010	/* This thread should not be frozen
> > > +					 * for Kprobes
> > > +					 */
> > 
> > Just put the comment before the define for long comments?
> 
> Agreed.

(Actually it would be nice to say

/* This thread should not be frozen for suspend, becuase it is needed
   for getting image saved to disk */

> > > -#ifdef CONFIG_PM
> > > +#if defined(CONFIG_PM) || defined(CONFIG_HOTPLUG_CPU) || \
> > > +					defined(CONFIG_KPROBES)
> > 
> > Should we create CONFIG_FREEZER?
> 
> Why do you think so?  I think the freezer should be compiled automatically
> if any of the above is set, which is what this directive really means.

Kconfig can do that. ("select statement"). If we have one such ifdef,
it is okay, but if it would be more of them.

> > Hmmm, I do not really like softlockup watchdog running during suspend.
> > Can we make this freezeable and make watchdog shut itself off while
> > suspending?
> 
> Generally, I agree, but this patch only replaces the existing instances
> of PF_NOFREEZE with the new mechanism.  The changes you're talking about
> require a separate patch series (or at least one separate patch), I think, and
> they need not be so simple to make.

Agreed about separate patch series.

> > > -	current->flags |= PF_NOFREEZE;
> > > +	freezer_exempt(FE_ALL);
> > >  	pid = kernel_thread(do_linuxrc, "/linuxrc", SIGCHLD);
> > >  	if (pid > 0) {
> > >  		while (pid != sys_wait4(-1, NULL, 0, NULL))
> > 
> > Does this mean we have userland /linuxrc running with PF_NOFREEZE?
> > That would be very bad...
> 
> No, actually it is _required_ for the userland resume to work.  Well, perhaps
> I should place a comment in there so that I don't have to explain this again
> and again. :-)

Can you put big bold comment there?

Why is it needed? Freezer never freezes _current_ task.

> > > @@ -104,7 +104,7 @@ static int __kprobes check_safety(void)
> > >  {
> > >  	int ret = 0;
> > >  #if defined(CONFIG_PREEMPT) && defined(CONFIG_PM)
> > 
> > Eh? Why does kprobes code depend on config_pm?
> 
> Because it uses the freezer? ;-)

That is no longer true after this patch... Ugly ifdef above makes sure
freezer is there for kprobes. I'm trying to say that #if above is
now broken. Actually it was probably always broken, but it just became
more so.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
