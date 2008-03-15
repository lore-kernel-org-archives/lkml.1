Return-Path: <linux-kernel-owner+w=401wt.eu-S1754907AbYCOVxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907AbYCOVxV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 17:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752876AbYCOVxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 17:53:12 -0400
Received: from netrider.rowland.org ([192.131.102.5]:2864 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752856AbYCOVxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 17:53:11 -0400
Date: Sat, 15 Mar 2008 17:53:10 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       <linux-next@vger.kernel.org>, <sfr@canb.auug.org.au>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       <apw@shadowen.org>, Len Brown <lenb@kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 0/3] PM wakeup flags revisited
In-Reply-To: <200803142337.12605.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0803151708160.28007-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Mar 2008, Rafael J. Wysocki wrote:

> On Friday, 14 of March 2008, Andrew Morton wrote:

> > Sorry, but that code should be dragged out and shot.  Doing this:
> > 
> > > 	device_can_wakeup(tty_dev) = 1;
> > 
> > is just gross and stupid.  It looks daft, it isn't C and it *requires* that
> > device_can_wakeup() be implemented as a macro, which totally busts any
> > concept of abstraction.

It seems to have been a one-time occurrence.  This patch series fixes 
it.

> > The code previously had quite reasonable accessors:
> > 
> >  #define device_set_wakeup_enable(dev,val) \
> >         ((dev)->power.should_wakeup = !!(val))
> >  #define device_may_wakeup(dev) \
> >         (device_can_wakeup(dev) && (dev)->power.should_wakeup)
> > 
> > can we please go back to that scheme?  Please also convert all these
> > magical macros into inlined C functions.  One reason is that this:
> > 
> > +#define device_init_wakeup(dev,val) \
> > +       do { \
> > +               device_can_wakeup(dev) = !!(val); \
> > +               device_set_wakeup_enable(dev,val); \
> > +       } while(0)
> > 
> > is buggy.  It evaluates its arguments multiple times and will cause
> > failures when passed expressions which have side-effects.

This series converts the macros to inline functions.

> > Alan, please also pass all future patches through checkpatch - there is no
> > need to be adding trivial coding-style errors in this day and age.

Rest assurred that checkpath is now an integral part of my normal 
workflow.  All the patches in this series pass with flying colors.

> Well, Greg please drop the "PM: make wakeup flags available whenever CONFIG_PM
> is set" and Alan please resubmit the patch with the problems pointed out by
> Andrew fixed.
> 
> In fact I'd even prefer it to be two patches, one that moves should_wakeup and
> the related macros out of the CONFIG_PM_SLEEP #ifdef, because that's what fixes
> the problem described in the changelog, and one that makes the remaining
> changes with a separate changelog.

Done.

The 1/3 patch fixes the unfortunate code in the serial-core driver.

The 2/3 patch moves the macros out from under CONFIG_PM_SLEEP.

The 3/3 patch converts the macros to inline functions and creates a new
pm_wakeup.h file for them.  They can't remain in pm.h, because they
depend on the definition of struct device -- and the compiler hasn't
seen that yet when pm.h is read.

It's not clear why the can_wakeup accessors are written to work even
when CONFIG_PM isn't set.  Nevertheless, the patches retain that
behavior.

Alan Stern

