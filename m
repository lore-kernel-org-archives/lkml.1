Return-Path: <linux-kernel-owner+w=401wt.eu-S1753069AbYAXNhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069AbYAXNhn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 08:37:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751793AbYAXNgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 08:36:53 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:58653 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751608AbYAXNgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 08:36:52 -0500
Date: Thu, 24 Jan 2008 11:35:50 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Daniel Walker <dwalker@mvista.com>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Jan Kiszka <jan.kiszka@siemens.com>, John Stultz <johnstul@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 01/20 -v5] printk - dont wakeup klogd with interrupts
	disabled
Message-ID: <20080124103550.GA3433@elf.ucw.cz>
References: <20080123160236.969334052@goodmis.org> <20080123160441.236562634@goodmis.org> <1201107978.13596.16.camel@imap.mvista.com> <20080123172509.GC22229@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080123172509.GC22229@Krystal>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-01-23 12:25:09, Mathieu Desnoyers wrote:
> * Daniel Walker (dwalker@mvista.com) wrote:
> > 
> > On Wed, 2008-01-23 at 11:02 -0500, Steven Rostedt wrote:
> > 
> > > +	if (!irqs_disabled() && wake_klogd)
> > >  		wake_up_klogd();
> > 
> > This causes a regression .. When printk is called during an OOPS in
> > kernels without this change then the OOPS will get logged, since the
> > logging process (klogd) is woken to handle the messages.. If you apply
> > this change klogd doesn't wakeup, and hence doesn't log the oops.. So if
> > you remove the wakeup here you have to add it someplace else to maintain
> > the logging ..
> > 
> > (I'm not theorizing here, I have defects logged against this specific
> > piece of code..)
> > 
> 
> Can we change this for :
> if (!(irqs_disabled() && !oops_in_progress) && wake_klogd)
>   wake_up_klogd();
> 
> ?

That's wrong, too.

Just make wake_up_klogd do trylock, if it finds that it can't get
neccessary locks, printk(KERN_ALERT) so at least console gets the
message, but proceed without the lock.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
