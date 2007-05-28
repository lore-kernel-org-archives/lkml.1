Return-Path: <linux-kernel-owner+w=401wt.eu-S1762727AbXE1WqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762727AbXE1WqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 18:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752418AbXE1WqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 18:46:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33408 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751358AbXE1WqJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 18:46:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: nigel@nigel.suspend2.net
Subject: Re: [RFC][PATCH][EXPERIMENTAL] Make kernel threads nonfreezable by default
Date: Tue, 29 May 2007 00:51:22 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Pavel Machek <pavel@ucw.cz>
References: <200705270012.59177.rjw@sisk.pl> <200705282017.51210.rjw@sisk.pl> <1180387582.4102.38.camel@nigel.suspend2.net>
In-Reply-To: <1180387582.4102.38.camel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705290051.23006.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 28 May 2007 23:26, Nigel Cunningham wrote:
> Hi.
> 
> On Mon, 2007-05-28 at 20:17 +0200, Rafael J. Wysocki wrote:
> > On Monday, 28 May 2007 11:46, Nigel Cunningham wrote:
> > > Hello!
> > > 
> > > In reply to your more recent message, I had looked but not tried, so
> > > didn't feel in a position to reply yet.
> > > 
> > > On Sun, 2007-05-27 at 00:12 +0200, Rafael J. Wysocki wrote:
> > > >  63 files changed, 78 insertions(+), 138 deletions(-)
> > > 
> > > Well, that looks good, for a start :)
> > > 
> > > > Index: linux-2.6.22-rc3/kernel/exit.c
> > > > ===================================================================
> > > > --- linux-2.6.22-rc3.orig/kernel/exit.c
> > > > +++ linux-2.6.22-rc3/kernel/exit.c
> > > > @@ -389,6 +389,11 @@ void daemonize(const char *name, ...)
> > > >  	 * they would be locked into memory.
> > > >  	 */
> > > >  	exit_mm(current);
> > > > +	/*
> > > > +	 * We don't want to have TIF_FREEZE set if the system-wide hibernation
> > > > +	 * or suspend transision begins right now.
> > > > +	 */
> > > > +	current->flags |= PF_NOFREEZE;
> > > 
> > > s/transision/transition
> > 
> > Thanks, will fix.
> > 
> > > >  	set_special_pids(1, 1);
> > > >  	proc_clear_tty(current);
> > > > Index: linux-2.6.22-rc3/include/linux/freezer.h
> > > > ===================================================================
> > > > --- linux-2.6.22-rc3.orig/include/linux/freezer.h
> > > > +++ linux-2.6.22-rc3/include/linux/freezer.h
> > > > @@ -118,6 +118,14 @@ static inline int freezer_should_skip(st
> > > >  	return !!(p->flags & PF_FREEZER_SKIP);
> > > >  }
> > > >  
> > > > +/*
> > > > + * Tell the freezer that the current task should be frozen by it
> > > > + */
> > > > +static inline void set_freezable(void)
> > > > +{
> > > > +	current->flags &= ~PF_NOFREEZE;
> > > > +}
> > > > +
> > > 
> > > Given the clearing of the flag above, should we just have a
> > > set_unfreezeable here that's used above (and potentially elsewhere)...
> > > (reads more)... or more generic set_[un]freezeable(task_struct *p)
> > > routines that could also be used in copy_flags below?
> > 
> > Yes, I can introduce set_unfreezeable(), although that would be used in
> > a couple of places only.
> > 
> > I don't think it's a good idea to have set_[un]freezeable(task_struct *p),
> > since only current is allowed to set/unset its flags.
> 
> The copy_flags routine changes another process's flags - that's why I
> was suggesting this.

Yes, it does, but I'm dropping the clearing of PF_NOFREEZE from there,
not adding anything new. :-)

Greetings,
Rafael
