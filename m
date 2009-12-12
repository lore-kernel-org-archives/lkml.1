Return-Path: <linux-kernel-owner+w=401wt.eu-S935427AbZLMCGI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935427AbZLMCGI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 21:06:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935389AbZLMCGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 21:06:05 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40494 "HELO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S935370AbZLMCF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 21:05:59 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] suspend: add initcall_debug style timing for suspend/resume
Date: Sat, 12 Dec 2009 19:31:56 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>
References: <20091206123552.7be316b2@infradead.org> <200912121927.55186.rjw@sisk.pl> <200912121929.06330.rjw@sisk.pl>
In-Reply-To: <200912121929.06330.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912121931.56928.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 12 December 2009, Rafael J. Wysocki wrote:
> On Saturday 12 December 2009, Rafael J. Wysocki wrote:
> > On Sunday 06 December 2009, Arjan van de Ven wrote:
> > > 
> > > From fcd52b97aa02f19baa570e4a62dfdfab0faed976 Mon Sep 17 00:00:00 2001
> > > From: Arjan van de Ven <arjan@linux.intel.com>
> > > Date: Sun, 6 Dec 2009 12:32:28 -0800
> > > Subject: [PATCH] suspend: add initcall_debug style timing for suspend/resume
> > > 
> > > In order to diagnose overall suspend/resume times, we need
> > > basic instrumentation to break down the total time into per
> > > device timing, similar to initcall_debug.
> > > 
> > > This patch adds the basic timing instrumentation, needed
> > > for a scritps/bootgraph.pl equivalent or humans.
> > > The bootgraph.pl program is still a work in progress, but
> > > is far enough along to know that this patch is sufficient.
> > > 
> > > Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> > > ---
> > >  drivers/base/power/main.c |   29 +++++++++++++++++++++++++++++
> > >  include/linux/init.h      |    2 ++
> > >  2 files changed, 31 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
> > > index 8aa2443..2ad345c 100644
> > > --- a/drivers/base/power/main.c
> > > +++ b/drivers/base/power/main.c
> > > @@ -25,6 +25,7 @@
> > >  #include <linux/resume-trace.h>
> > >  #include <linux/rwsem.h>
> > >  #include <linux/interrupt.h>
> > > +#include <linux/sched.h>
> > >  
> > >  #include "../base.h"
> > >  #include "power.h"
> > > @@ -172,6 +173,12 @@ static int pm_op(struct device *dev,
> > >  		 pm_message_t state)
> > >  {
> > >  	int error = 0;
> > > +	ktime_t calltime, delta, rettime;
> > > +
> > > +	if (initcall_debug) {
> > > +		printk("calling  %s+ @ %i\n", dev_name(dev), task_pid_nr(current));
> > > +		calltime = ktime_get();
> > > +	}
> > >  
> > >  	switch (state.event) {
> > >  #ifdef CONFIG_SUSPEND
> > > @@ -219,6 +226,14 @@ static int pm_op(struct device *dev,
> > >  	default:
> > >  		error = -EINVAL;
> > >  	}
> > > +
> > > +	if (initcall_debug) {
> > > +		rettime = ktime_get();
> > > +		delta = ktime_sub(rettime, calltime);
> > > +		printk("initcall %s+ returned %d after %Ld usecs\n", dev_name(dev),
> > > +			error, (unsigned long long) ktime_to_ns(delta) >> 10);
> > 
> > I've changed that "initcall" to "call".  Hopefully that won't break your scripts. ;-)
> 
> In addition to that I've changed printk to pr_infor

Argh.  pr_info, that is.

Rafael
