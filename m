Return-Path: <linux-kernel-owner+w=401wt.eu-S1754790AbZFHB7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790AbZFHB7R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 21:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753608AbZFHB7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 21:59:06 -0400
Received: from mga03.intel.com ([143.182.124.21]:21402 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753439AbZFHB7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 21:59:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,322,1241420400"; 
   d="scan'208";a="151661131"
Date: Mon, 8 Jun 2009 09:57:30 +0800
From: Feng Tang <feng.tang@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: "mingo@elte.hu" <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       <shaohua.li@intel.com>, <jacob.jun.pan@intel.com>
Subject: Re: [PATCH] tick: add check for the existence of broadcast clock
 event device
Message-ID: <20090608095730.0c945e78@feng-desktop>
In-Reply-To: <alpine.LFD.2.00.0906061815460.3419@localhost.localdomain>
References: <20090605112711.67e7d5cb@feng-desktop>
	<alpine.LFD.2.00.0906061121330.3419@localhost.localdomain>
	<20090606204736.00700bd0@feng-desktop>
	<alpine.LFD.2.00.0906061450220.3419@localhost.localdomain>
	<alpine.LFD.2.00.0906061815460.3419@localhost.localdomain>
Organization: intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 7 Jun 2009 00:18:55 +0800
Thomas Gleixner <tglx@linutronix.de> wrote:

> On Sat, 6 Jun 2009, Thomas Gleixner wrote:
> > Feng,
> > 
> > On Sat, 6 Jun 2009, Feng Tang wrote:
> > > > If your percpu devices are always on (not affected by C3 stop)
> > > > then you never dereference bc. So why do we need an extra check
> > > > for !bc ?
> > > 
> > > Hi tglx,
> > 
> > > Thanks for the explanation. But we really ran into the NULL
> > > pointer case, in our platform, there are 2 X86 CPUs which have
> > > lapic, also it has 2 external timers which are pretty similar
> > > with HPET timers, those 2 external timers will be used as per-cpu
> > > timers (higher rating than lapic timer). In system's power cycle
> > > of suspend and resume, disable_nontboot_cpus will be called
> > > before goto suspend state,and enable_nonboot_cpus will be called
> > > for the resume process, so lapic timer of cpu1 will be first
> > > registered as per-cpu timer, and our external timer will be
> > > registered later after get a CPU_ONLINE notifier (similar with
> > > HPET), right in this time slot that lapic is the per-cpu timer,
> > > when system get the CLOCK_EVT_BROADCAST_ENTER/EXIT msg,
> > > tick_do_broadcast_on_off() is called and hit the NULL pointer
> > > case.
> > 
> > Ok, I can understand now why we need it. I'll apply your patch and
> > add some more info into the commit msg so we do not look at it in a
> > year and scratch our heads. :)
> 
> Hmm, thought more about it.
> 
> 1) How do you calibrate the local APIC timer if you do not have some
> initial timer device ?
Yes, we have external timer device with the name "apbt"
> 
> 2) If you have some initial timer device (PIT/HPET) why isn't it
> registered as broadcast device.
We only have 2 available apbt, apbt0 for cpu0 and apbt1 for cpu1. And based on my understanding, there is no explicit API to register a timer as bc, and bc is setup during clockevents_register_device() --> tick_check_new_device() -->tick_check_broadcast_device(), and HPET case can just meet the condition: lapic's rating is 110, timer "hpet"is 50 and set to be the broadcast device, and other hpet(2/3/4/5..)'s are 150 and set to be the per-cpu timer

> 
> 3) When the CPU uses the local APIC before the external timer is
> initialized what happens if the system goes into a deeper c-state ?
Good point, for cpu1, this is not an issue, as cpu0 will register apbt1 for cpu1. there is a window cpu1 is in deep c-idle state and no timer wake it up, but window is small as cpu0 will send IPI soon.
>  
> Thanks,
> 
> 	tglx
