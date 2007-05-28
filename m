Return-Path: <linux-kernel-owner+w=401wt.eu-S1762944AbXE1SMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762944AbXE1SMR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 14:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751916AbXE1SMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 14:12:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60749 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751766AbXE1SMF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 14:12:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: nigel@nigel.suspend2.net
Subject: Re: [RFC][PATCH][EXPERIMENTAL] Make kernel threads nonfreezable by default
Date: Mon, 28 May 2007 20:17:50 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Pavel Machek <pavel@ucw.cz>
References: <200705270012.59177.rjw@sisk.pl> <1180345596.14749.40.camel@nigel.suspend2.net>
In-Reply-To: <1180345596.14749.40.camel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705282017.51210.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 28 May 2007 11:46, Nigel Cunningham wrote:
> Hello!
> 
> In reply to your more recent message, I had looked but not tried, so
> didn't feel in a position to reply yet.
> 
> On Sun, 2007-05-27 at 00:12 +0200, Rafael J. Wysocki wrote:
> >  63 files changed, 78 insertions(+), 138 deletions(-)
> 
> Well, that looks good, for a start :)
> 
> > Index: linux-2.6.22-rc3/kernel/exit.c
> > ===================================================================
> > --- linux-2.6.22-rc3.orig/kernel/exit.c
> > +++ linux-2.6.22-rc3/kernel/exit.c
> > @@ -389,6 +389,11 @@ void daemonize(const char *name, ...)
> >  	 * they would be locked into memory.
> >  	 */
> >  	exit_mm(current);
> > +	/*
> > +	 * We don't want to have TIF_FREEZE set if the system-wide hibernation
> > +	 * or suspend transision begins right now.
> > +	 */
> > +	current->flags |= PF_NOFREEZE;
> 
> s/transision/transition

Thanks, will fix.

> >  	set_special_pids(1, 1);
> >  	proc_clear_tty(current);
> > Index: linux-2.6.22-rc3/include/linux/freezer.h
> > ===================================================================
> > --- linux-2.6.22-rc3.orig/include/linux/freezer.h
> > +++ linux-2.6.22-rc3/include/linux/freezer.h
> > @@ -118,6 +118,14 @@ static inline int freezer_should_skip(st
> >  	return !!(p->flags & PF_FREEZER_SKIP);
> >  }
> >  
> > +/*
> > + * Tell the freezer that the current task should be frozen by it
> > + */
> > +static inline void set_freezable(void)
> > +{
> > +	current->flags &= ~PF_NOFREEZE;
> > +}
> > +
> 
> Given the clearing of the flag above, should we just have a
> set_unfreezeable here that's used above (and potentially elsewhere)...
> (reads more)... or more generic set_[un]freezeable(task_struct *p)
> routines that could also be used in copy_flags below?

Yes, I can introduce set_unfreezeable(), although that would be used in
a couple of places only.

I don't think it's a good idea to have set_[un]freezeable(task_struct *p),
since only current is allowed to set/unset its flags.

> >  #else
> >  static inline int frozen(struct task_struct *p) { return 0; }
> >  static inline int freezing(struct task_struct *p) { return 0; }
> > @@ -134,6 +142,7 @@ static inline int try_to_freeze(void) { 
> >  static inline void freezer_do_not_count(void) {}
> >  static inline void freezer_count(void) {}
> >  static inline int freezer_should_skip(struct task_struct *p) { return 0; }
> > +static inline void set_freezable_current(void) {}

Ah, this is a mistake (wrong name).

> >  #endif
> >  
> >  #endif /* LINUX_FREEZER_H */
> > Index: linux-2.6.22-rc3/kernel/fork.c
> > ===================================================================
> > --- linux-2.6.22-rc3.orig/kernel/fork.c
> > +++ linux-2.6.22-rc3/kernel/fork.c
> > @@ -920,7 +920,7 @@ static inline void copy_flags(unsigned l
> >  {
> >  	unsigned long new_flags = p->flags;
> >  
> > -	new_flags &= ~(PF_SUPERPRIV | PF_NOFREEZE);
> > +	new_flags &= ~PF_SUPERPRIV;
> >  	new_flags |= PF_FORKNOEXEC;
> >  	if (!(clone_flags & CLONE_PTRACE))
> >  		p->ptrace = 0;
> > Index: linux-2.6.22-rc3/arch/i386/kernel/io_apic.c
> > ===================================================================
> > --- linux-2.6.22-rc3.orig/arch/i386/kernel/io_apic.c
> > +++ linux-2.6.22-rc3/arch/i386/kernel/io_apic.c
> > @@ -669,7 +669,6 @@ static int balanced_irq(void *unused)
> >  
> >  	for ( ; ; ) {
> >  		time_remaining = schedule_timeout_interruptible(time_remaining);
> > -		try_to_freeze();
> >  		if (time_after(jiffies,
> >  				prev_balance_time+balanced_irq_interval)) {
> >  			preempt_disable();
> 
> I'm the one who is confused, aren't I? If I'm reading this right,
> io_apic used to be frozen. After this patch, it will not be frozen. If
> that's the intended behaviour, shouldn't this be two patches - one to
> make kernel threads unfreezeable by default, and one to make threads
> that were formerly freezeable unfreezeable?

Yes, I think you're right.  I tend to try to make too many changes in one
shot. :-)

> 
> [...]
> 
> > Index: linux-2.6.22-rc3/Documentation/power/swsusp.txt
> > ===================================================================
> > --- linux-2.6.22-rc3.orig/Documentation/power/swsusp.txt
> > +++ linux-2.6.22-rc3/Documentation/power/swsusp.txt
> > @@ -140,22 +140,6 @@ should be sent to the mailing list avail
> >  website, and not to the Linux Kernel Mailing List. We are working
> >  toward merging suspend2 into the mainline kernel.
> >  
> > -Q: A kernel thread must voluntarily freeze itself (call 'refrigerator').
> > -I found some kernel threads that don't do it, and they don't freeze
> > -so the system can't sleep. Is this a known behavior?
> > -
> > -A: All such kernel threads need to be fixed, one by one. Select the
> > -place where the thread is safe to be frozen (no kernel semaphores
> > -should be held at that point and it must be safe to sleep there), and
> > -add:
> > -
> > -       try_to_freeze();
> > -
> > -If the thread is needed for writing the image to storage, you should
> > -instead set the PF_NOFREEZE process flag when creating the thread (and
> > -be very careful).
> > -
> > -
> >  Q: What is the difference between "platform" and "shutdown"?
> >  
> >  A:
> 
> Perhaps it would be good to keep a variant of this question, along the
> lines of:
> 
> Q: I have a kernel thread that needs to be frozen during hibernation.
> How do I make that happen?

Good idea.

Thanks for the comments.

Greetings,
Rafael
