Return-Path: <linux-kernel-owner+w=401wt.eu-S1756760AbYAGOJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760AbYAGOJG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 09:09:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753152AbYAGOIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 09:08:55 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:34570 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574AbYAGOIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 09:08:54 -0500
Date: Mon, 7 Jan 2008 06:07:07 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Lord <lkml@rtr.ca>, Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       abelay@novell.com, lenb@kernel.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, rjw@sisk.pl
Subject: Re: + restore-missing-sysfs-max_cstate-attr.patch added to -mm tree
Message-ID: <20080107060707.55af6d9c@laptopd505.fenrus.org>
In-Reply-To: <20080106231848.762e93c1.akpm@linux-foundation.org>
References: <20071130142058.816d1693.akpm@linux-foundation.org>
	<924EFEDD5F540B4284297C4DC59F3DEE2FAEAF@orsmsx423.amr.corp.intel.com>
	<4750CC78.9070105@rtr.ca>
	<20071130190227.1976e682@laptopd505.fenrus.org>
	<4750D180.6080001@rtr.ca>
	<20071130191816.3e744205@laptopd505.fenrus.org>
	<4750D585.1030200@rtr.ca>
	<477C2143.8090406@rtr.ca>
	<924EFEDD5F540B4284297C4DC59F3DEE4FC485@orsmsx423.amr.corp.intel.com>
	<477C622F.6010304@rtr.ca>
	<20080104021619.GA15409@linux-os.sc.intel.com>
	<47814958.3070208@rtr.ca>
	<20080106231848.762e93c1.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Jan 2008 23:18:48 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sun, 06 Jan 2008 16:34:16 -0500 Mark Lord <lkml@rtr.ca> wrote:
> 
> > Venki Pallipadi wrote:
> > > Reintroduce run time configurable max_cstate for !CPU_IDLE case.
> > > 
> > > Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> > > 
> > > Index: linux-2.6.24-rc/drivers/acpi/processor_idle.c
> > > ===================================================================
> > > --- linux-2.6.24-rc.orig/drivers/acpi/processor_idle.c
> > > +++ linux-2.6.24-rc/drivers/acpi/processor_idle.c
> > > @@ -76,7 +76,11 @@ static void (*pm_idle_save) (void) __rea
> > >  #define PM_TIMER_TICKS_TO_US(p)		(((p) *
> > > 1000)/(PM_TIMER_FREQUENCY/1000)) 
> > >  static unsigned int max_cstate __read_mostly =
> > > ACPI_PROCESSOR_MAX_POWER; +#ifdef CONFIG_CPU_IDLE
> > >  module_param(max_cstate, uint, 0000);
> > > +#else
> > > +module_param(max_cstate, uint, 0644);
> > > +#endif
> > >  static unsigned int nocst __read_mostly;
> > >  module_param(nocst, uint, 0000);
> > >  
> > ..
> > 
> > Can we get this patch upstream so that a stock 2.6.24 will work
> > here?
> > 
> 
> umm, OK, I queued it for 2.6.24.  I'll give people a day or so to
> comment on this.
> 
> I had to invent some silly changlelog for it.  Please review it for
> accuracy and completeness?
> 
> It isn't complete, really.  How come we only make max_cstate
> writeable if CONFIG_CPU_IDLE=n?  What happens to people who were
> reliant upon writeable max_cstate who now enable CPU_IDLE?  Things
> still break?  What is the rationale behind this?  What constraints
> led us to this decision?



if we take a step back; Mark afaics only wants to put 1 in there...
And that makes sense; either you want the "no latency" C1, or you want the lot
(esp given that C2 and deeper are at the whim of the bios, what they mean varies
over time. Actually even C1 does that on some AMD systems);

Longer term I'd suggest we make an option that basically is "C1 only",
(or technically, "use hlt only")
that solves Marks VMWARE thing, and is a lot closer to what people really want.
Well, that and if VMWARE really can't deal with latency in their kernel module
they should use the proper code for that. It's also a ton easier to implement, since
it basically is "don't use the CPUIDLE idle loop, but use the traditional hlt one"


