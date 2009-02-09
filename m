Return-Path: <linux-kernel-owner+w=401wt.eu-S1755259AbZBIWuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259AbZBIWuS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 17:50:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752587AbZBIWuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 17:50:04 -0500
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:45867 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161AbZBIWuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 17:50:03 -0500
Date: Mon, 9 Feb 2009 15:50:00 -0700
From: Alex Chiang <achiang@hp.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: tony.luck@intel.com, linux-ia64@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: RCU can use cpu_active_map?
Message-ID: <20090209225000.GC3939@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	tony.luck@intel.com, linux-ia64@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <20090209201345.GB13107@ldl.fc.hp.com> <20090209213929.GQ6802@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090209213929.GQ6802@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney <paulmck@linux.vnet.ibm.com>:
> On Mon, Feb 09, 2009 at 01:13:45PM -0700, Alex Chiang wrote:
> > Paul,
> > 
> > I don't pretend to understand RCU, but a very quick and naive
> > look through rcupreempt.c makes me think that we could use the
> > cpu_active_map instead of cpu_online_map?
> > 
> > cpu_active_map was introduced by e761b772.
> > 
> > In the CPU hotplug path, we touch the cpu_active_map very early
> > on:
> > 
> > int __ref cpu_down(unsigned int cpu)
> > {
> >         int err;
> >         err = stop_machine_create();
> >         if (err)
> >                 return err;
> >         cpu_maps_update_begin();
> > 
> >         if (cpu_hotplug_disabled) {
> >                 err = -EBUSY;
> >                 goto out;
> >         }
> > 
> >         cpu_clear(cpu, cpu_active_map);
> > 	/* ... */
> >         synchronize_sched();
> >         err = _cpu_down(cpu, 0);
> >         if (cpu_online(cpu))
> >                 cpu_set(cpu, cpu_active_map);
> > 
> > out:
> >         cpu_maps_update_done();
> >         stop_machine_destroy();
> >         return err;
> > }
> > 
> > The call to _cpu_down() is where we eventually get to the code
> > that my patch below touches, so you can see that we mark the CPU
> > as !active before we ever get to the step of migrating interrupts
> > (which relies on cpu_online_map).
> > 
> > If RCU looked at cpu_active_map instead of cpu_online_map, it
> > seems like we would avoid the potential race situation you
> > mentioned earlier.
> > 
> > Alternatively, I could explore just playing with the ia64
> > interrupt migration code to use cpu_active_mask instead, but
> > wanted to get your thoughts from the RCU perspective.
> 
> Perhaps I am confused, but if the CPU is on its way down, doesn't RCU
> need a mask where the CPU's bit stays set longer rather than shorter?
> 
> If I use cpu_active_mask, couldn't there be device interrupts during
> (for example) the synchronize_sched(), which might have RCU read-side
> critical sections that RCU needs to pay attention to?

Hm, I think you're right.

Thanks.

/ac

