Return-Path: <linux-kernel-owner+w=401wt.eu-S1030982AbXDPVYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030982AbXDPVYX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 17:24:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030983AbXDPVYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 17:24:23 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58923 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030982AbXDPVYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 17:24:22 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC][PATCH][EXPERIMENTAL] CPU hotplug with frozen tasks
Date: Mon, 16 Apr 2007 23:06:06 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Oleg Nesterov <oleg@tv-sign.ru>
References: <200704061732.32712.rjw@sisk.pl> <200704160027.58425.rjw@sisk.pl> <20070416070531.GC1783@elf.ucw.cz>
In-Reply-To: <20070416070531.GC1783@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704162306.06910.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 16 April 2007 09:05, Pavel Machek wrote:
> Hi!
> 
> > As I said before, we have a problem with using the CPU hotplug for suspending
> > because of the notifiers that are called from within cpu_up()/cpu_down() and
> > (sometimes) assume that the system is fully functional.
> > 
> > One obvious solution of this problem would be to make the notifiers behave
> > differently if tasks are frozen, but for this purpose we'd need to tell them
> > that this is the case.  In principle, we could do it in many different ways
> > (eg. by using a global variable, with the help of suspend notifiers etc.), but
> > IMO one of the cleanest methods woud be to use some special values for the
> > notifications occuring while tasks are frozen (eg. CPU_DEAD_FROZEN instead of
> > CPU_DEAD etc.).  In that case the notifiers could react in some special ways
> > to the "FROZEN" notfifications and that would allow us to simplify some code
> > paths (eg. in the microcode driver).
> > 
> > The appended patch introduces such "FROZEN" notfifications, modifies the CPU
> > hotplug core to use them and updates all of the users of CPU hotplug notifiers
> > to recognize them.  For now, they are treated in the same way as the
> > corresponding "normal" notifications, but I'm going to modify the microcode
> > driver to really use them and I believe that some other subsystems can benefit
> > from using them as well.
> > 
> > The patch is totally experimental and untested, although it's been successfully
> > compiled on x86_64 and it's main purpose is to show what exactly I
> > mean. :-)
> 
> Looks sane to me.
> 
> > Index: linux-2.6.21-rc6/kernel/cpu.c
> > ===================================================================
> > --- linux-2.6.21-rc6.orig/kernel/cpu.c	2007-04-16 00:24:56.000000000 +0200
> > +++ linux-2.6.21-rc6/kernel/cpu.c	2007-04-16 00:25:14.000000000 +0200
> > @@ -120,11 +120,12 @@ static int take_cpu_down(void *unused)
> >  }
> >  
> >  /* Requires cpu_add_remove_lock to be held */
> > -static int _cpu_down(unsigned int cpu)
> > +static int _cpu_down(unsigned int cpu, int tasks_frozen)
> >  {
> >  	int err;
> >  	struct task_struct *p;
> >  	cpumask_t old_allowed, tmp;
> > +	unsigned long mod = tasks_frozen ? 0x0008 : 0;
> >  
> 
> Can we get constant instead of 0x0008 here?

Sure.  Updated patch is in the reply to Gautham.

Greetings,
Rafael
