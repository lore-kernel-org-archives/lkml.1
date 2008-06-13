Return-Path: <linux-kernel-owner+w=401wt.eu-S1760964AbYFMH3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760964AbYFMH3W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 03:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753535AbYFMH3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 03:29:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46097 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753449AbYFMH3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 03:29:14 -0400
Date: Fri, 13 Jun 2008 00:28:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, arjan@infradead.org,
       andreas.herrmann3@amd.com
Subject: Re: [patch 6/6] x86: add c1e aware idle function
Message-Id: <20080613002808.a085bf45.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0806130800060.3193@apollo.tec.linutronix.de>
References: <20080610171639.551369443@linutronix.de>
	<20080610171712.465591661@linutronix.de>
	<20080612175533.5b6c1736.akpm@linux-foundation.org>
	<alpine.LFD.1.10.0806130800060.3193@apollo.tec.linutronix.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jun 2008 08:02:30 +0200 (CEST) Thomas Gleixner <tglx@linutronix.de> wrote:

> On Thu, 12 Jun 2008, Andrew Morton wrote:
> > On Thu, 12 Jun 2008 10:29:00 -0000
> > Thomas Gleixner <tglx@linutronix.de> wrote:
> > > +		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &cpu);
> > > +		default_idle();
> > > +		local_irq_disable();
> > > +		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &cpu);
> > > +		local_irq_enable();
> > 
> > I worked it out!  It took me a while.
> > 
> > This function is called with local irqs disabled.
> > 
> > default_idle() is entered with local irqs disabled but returns with them
> > enabled.
> > 
> > clockevents_notify() is supposed to be called with local irqs disabled.
> > 
> > This functions returns with local irqs enabled.
> 
> Damn, you decoded my sekrit.

The wonders of the GPL.

> > Was I right?  None of any of that is documented anywhere.  But it should
> > be.
> 
> Yeah, needs a big comment. Will add one.
> 

Actually it need lots of little comments.  One at default_idle(), one at
clockevents_notify(), one at whatever-this-function-was.

Because "must be called with local irqs disabled" is as much a part of
a function's interface as "must be passed a foo* and an integer and
returns a bar*".  Ditto "must be called under zot_lock".  But people
often forget these things.

I guess kerneldoc should have a standard "call environment" template. 
Maybe it does, dunno.

Of course, WARN_ON(!irqs_disabled()) and WARN_ON(!spin_is_locked(foo))
is robust documentation.


