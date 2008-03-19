Return-Path: <linux-kernel-owner+w=401wt.eu-S938795AbYCSVtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938795AbYCSVtf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932109AbYCSUSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:18:51 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57548 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932100AbYCSUSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:18:47 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <greg@kroah.com>
Subject: Re: [RFC][PATCH 1/3] PM: Introduce new top level suspend and hibernation callbacks
Date: Wed, 19 Mar 2008 14:22:00 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <200803170020.55473.rjw@sisk.pl> <200803170022.30345.rjw@sisk.pl> <20080319005340.GC8298@kroah.com>
In-Reply-To: <20080319005340.GC8298@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803191422.02064.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 19 of March 2008, Greg KH wrote:
> On Mon, Mar 17, 2008 at 12:22:29AM +0100, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Introduce 'struct pm_ops' representing a set of suspend and
> > hibernation operations for bus types, device classes and device
> > types.
> 
> Ok, I must have missed the thread describing why we need to do this, so,
> why do we need to do this?  What is this going to buy us in the end
> after everything is changed?

There were many threads related to that.

To summarize, the first purpose is to separate suspend (aka s2ram and standby)
callbacks from hibernation callbacks in such a way that the new callbacks won't
take arguments and the purpose of each of them will be clearly specified.  This
has been requested multiple times by many people, including Linus himself,
and the reason is that within the current scheme if ->resume() is called, for
example, it's difficult to say why it's been called (ie. is it a resume from RAM or
from hibernation or a suspend/hibernation failure etc.?).

The second purpose is to make the suspend/hibernation callbacks more flexible
so that device drivers can handle more than they can within the current scheme.
For example, some drivers may need to prevent new children of the device from
being registered before their ->suspend() callbacks are executed or they may
want to carry out some operations requiring the availability of some other
devices, not directly bound via the parent-child relationship, in order to prepare
for the execution of ->suspend(), etc.

Ultimately, we'd like to stop using the freezing of tasks for suspend and
therefore the drivers' suspend/hibernation code will have to take care of
the handling of the user space during suspend/hibernation which would be
difficult within the current scheme, without the ->prepare() and ->complete()
callbacks.

> > +struct pm_ops {
> > +#ifdef CONFIG_PM_SLEEP
> > +	int (*prepare)(struct device *dev);
> > +	void (*complete)(struct device *dev);
> > +#endif
> > +#ifdef CONFIG_SUSPEND
> > +	int (*suspend)(struct device *dev);
> > +	int (*resume)(struct device *dev);
> > +#endif
> > +#ifdef CONFIG_HIBERNATION
> > +	int (*freeze)(struct device *dev);
> > +	int (*thaw)(struct device *dev);
> > +	int (*poweroff)(struct device *dev);
> > +	int (*quiesce)(struct device *dev);
> > +	int (*restore)(struct device *dev);
> > +	int (*recover)(struct device *dev);
> > +#endif
> 
> 
> Don't ifdef stuff like this, it only causes ifdefs to be needed to the
> .c code as well for all places these structures are defined in
> drivers/busses, right?

Sure, but that code won't be necessary otherwise too.

I'll remove the #ifdefs in the next version of the patch.

Thanks,
Rafael
