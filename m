Return-Path: <linux-kernel-owner+w=401wt.eu-S1754741AbZFFMsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741AbZFFMsU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 08:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753878AbZFFMsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 08:48:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:36858 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754109AbZFFMsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 08:48:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,315,1241420400"; 
   d="scan'208";a="697040691"
Date: Sat, 6 Jun 2009 20:47:36 +0800
From: Feng Tang <feng.tang@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: "mingo@elte.hu" <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tick: add check for the existence of broadcast clock
 event device
Message-ID: <20090606204736.00700bd0@feng-desktop>
In-Reply-To: <alpine.LFD.2.00.0906061121330.3419@localhost.localdomain>
References: <20090605112711.67e7d5cb@feng-desktop>
	<alpine.LFD.2.00.0906061121330.3419@localhost.localdomain>
Organization: intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Jun 2009 17:24:50 +0800
Thomas Gleixner <tglx@linutronix.de> wrote:

> On Fri, 5 Jun 2009, Feng Tang wrote:
> 
> > >From 2f076e1867c8bbb145b74d289358174644d9fed8 Mon Sep 17 00:00:00
> > >2001
> > From: Feng Tang <feng.tang@intel.com>
> > Date: Fri, 5 Jun 2009 10:36:15 +0800
> > Subject: [PATCH] tick: add check for the existence of broadcast
> > clock event device
> > 
> > Some platform may have no broadcast clock event device, as it use
> > always-on external timers for per-cpu timer and has no extra one
> > for broadcast device. This check will secure the access to bc
> > device when system get some boradcast on/off and enter/exit message
> >
> > Signed-off-by: Feng Tang <feng.tang@intel.com>
> > ---
> >  kernel/time/tick-broadcast.c |    8 +++++++-
> >  1 files changed, 7 insertions(+), 1 deletions(-)
> > 
> > diff --git a/kernel/time/tick-broadcast.c
> > b/kernel/time/tick-broadcast.c index 118a3b3..110e0bc 100644
> > --- a/kernel/time/tick-broadcast.c
> > +++ b/kernel/time/tick-broadcast.c
> > @@ -214,10 +214,13 @@ static void tick_do_broadcast_on_off(void
> > *why) 
> >  	spin_lock_irqsave(&tick_broadcast_lock, flags);
> >  
> > +	bc = tick_broadcast_device.evtdev;
> > +	if (!bc)
> > +		goto out;
> > +
> 
> This check is not necessary because we check whether the percpu device
> is affected by the stops in C3 madness _before_ we touch the broadcast
> device.
> 
> 	 if (!dev || !(dev->features & CLOCK_EVT_FEAT_C3STOP))
> 	    	  got out;
> 
> If your percpu devices are always on (not affected by C3 stop) then
> you never dereference bc. So why do we need an extra check for !bc ?

Hi tglx,

Thanks for the explanation. But we really ran into the NULL pointer case, in our platform, there are 2 X86 CPUs which have lapic, also it has 2 external timers which are pretty similar with HPET timers, those 2 external timers will be used as per-cpu timers (higher rating than lapic timer). In system's power cycle of suspend and resume, disable_nontboot_cpus will be called before goto suspend state,and enable_nonboot_cpus will be called for the resume process, so lapic timer of cpu1 will be first registered as per-cpu timer, and our external timer will be registered later after get a CPU_ONLINE notifier (similar with HPET), right in this time slot that lapic is the per-cpu timer, when system get the CLOCK_EVT_BROADCAST_ENTER/EXIT msg, tick_do_broadcast_on_off() is called and hit the NULL pointer case.

Our external timer driver is very similar with HPET dirver, why HPET doesn't see such an issue? becuase HPET has enough number of timers, and it use "hpet0" as the bc device, while our platform doesn't have a extra one to act as bc.

- Feng 




> 
> Thanks,
> 
> 	tglx
