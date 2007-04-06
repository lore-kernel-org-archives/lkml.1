Return-Path: <linux-kernel-owner+w=401wt.eu-S933001AbXDFWU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933001AbXDFWU6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 18:20:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933100AbXDFWU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 18:20:58 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:41150 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933001AbXDFWU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 18:20:57 -0400
Subject: Re: [PATCH 1/8] Enhance process freezer interface for usage beyond
	software suspend
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, Gautham R Shenoy <ego@in.ibm.com>,
       akpm@linux-foundation.org, paulmck@us.ibm.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       vatsa@in.ibm.com, Oleg Nesterov <oleg@tv-sign.ru>, mingo@elte.hu,
       dipankar@in.ibm.com, dino@in.ibm.com, masami.hiramatsu.pt@hitachi.com
In-Reply-To: <200704061634.51046.rjw@sisk.pl>
References: <20070402053457.GA9076@in.ibm.com>
	 <200704022248.25948.rjw@sisk.pl> <20070402205127.GF3840@elf.ucw.cz>
	 <200704061634.51046.rjw@sisk.pl>
Content-Type: text/plain
Date: Sat, 07 Apr 2007 08:20:55 +1000
Message-Id: <1175898055.6481.83.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Fri, 2007-04-06 at 16:34 +0200, Rafael J. Wysocki wrote:
> On Monday, 2 April 2007 22:51, Pavel Machek wrote:
> > Hi!
> > 
> > > > > +/* Per process freezer specific flags */
> > > > > +#define PF_FE_SUSPEND	0x00008000	/* This thread should not be frozen
> > > > > +					 * for suspend
> > > > > +					 */
> > > > > +
> > > > > +#define PF_FE_KPROBES	0x00000010	/* This thread should not be frozen
> > > > > +					 * for Kprobes
> > > > > +					 */
> > > > 
> > > > Just put the comment before the define for long comments?
> > > 
> > > Agreed.
> > 
> > (Actually it would be nice to say
> > 
> > /* This thread should not be frozen for suspend, becuase it is needed
> >    for getting image saved to disk */
> > 
> > > > > -#ifdef CONFIG_PM
> > > > > +#if defined(CONFIG_PM) || defined(CONFIG_HOTPLUG_CPU) || \
> > > > > +					defined(CONFIG_KPROBES)
> > > > 
> > > > Should we create CONFIG_FREEZER?
> > > 
> > > Why do you think so?  I think the freezer should be compiled automatically
> > > if any of the above is set, which is what this directive really means.
> > 
> > Kconfig can do that. ("select statement"). If we have one such ifdef,
> > it is okay, but if it would be more of them.
> > 
> > > > Hmmm, I do not really like softlockup watchdog running during suspend.
> > > > Can we make this freezeable and make watchdog shut itself off while
> > > > suspending?
> > > 
> > > Generally, I agree, but this patch only replaces the existing instances
> > > of PF_NOFREEZE with the new mechanism.  The changes you're talking about
> > > require a separate patch series (or at least one separate patch), I think, and
> > > they need not be so simple to make.
> > 
> > Agreed about separate patch series.
> > 
> > > > > -	current->flags |= PF_NOFREEZE;
> > > > > +	freezer_exempt(FE_ALL);
> > > > >  	pid = kernel_thread(do_linuxrc, "/linuxrc", SIGCHLD);
> > > > >  	if (pid > 0) {
> > > > >  		while (pid != sys_wait4(-1, NULL, 0, NULL))
> > > > 
> > > > Does this mean we have userland /linuxrc running with PF_NOFREEZE?
> > > > That would be very bad...
> > > 
> > > No, actually it is _required_ for the userland resume to work.  Well, perhaps
> > > I should place a comment in there so that I don't have to explain this again
> > > and again. :-)
> > 
> > Can you put big bold comment there?
> >
> > Why is it needed? Freezer never freezes _current_ task.
> 
> No, it doesn't, but this task spawns linuxrc and then calls sys_wait4() in a
> loop.
> 
> Well, actually, I'll try to plant try_to_freeze() in this loop and see if that
> works.  If it doesn't, I'll add a comment.

It works. I've had:

                while (pid != sys_wait4(-1, NULL, 0, NULL)) {
                        yield();
                        try_to_freeze();
                }

there for ages for Suspend2.

Regards,

Nigel

