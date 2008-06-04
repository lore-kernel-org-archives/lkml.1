Return-Path: <linux-kernel-owner+w=401wt.eu-S1761397AbYFDU0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761397AbYFDU0g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 16:26:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754369AbYFDU02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 16:26:28 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42983 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371AbYFDU01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 16:26:27 -0400
Subject: Re: Inquiry: Should we remove "isolcpus= kernel boot option? (may
	have realtime uses)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: Mark Hounschell <dmarkh@cfl.rr.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Ingo Oeser <ioe-lkml@rameria.de>, Paul Jackson <pj@sgi.com>,
       linux-kernel@vger.kernel.org, Con Kolivas <kernel@kolivas.org>,
       "Derek L. Fults" <dfults@sgi.com>, devik <devik@cdi.cz>,
       Dimitri Sivanich <sivanich@sgi.com>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Emmanuel Pacaud <emmanuel.pacaud@univ-poitiers.fr>,
       Frederik Deweerdt <deweerdt@free.fr>, Ingo Molnar <mingo@elte.hu>,
       Matthew Dobson <colpatch@us.ibm.com>, rostedt@goodmis.org,
       Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Paul Menage <menage@google.com>, "Randy.Dunlap" <rddunlap@osdl.org>,
       suresh.b.siddha@intel.com, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <4846EC77.1020900@qualcomm.com>
References: <20080601213019.14ea8ef8.pj@sgi.com>
	 <200806030035.58387.ioe-lkml@rameria.de>
	 <1212446707.6269.26.camel@lappy.programming.kicks-ass.net>
	 <200806031603.40731.nickpiggin@yahoo.com.au> <48466745.5050802@cfl.rr.com>
	 <4846EC77.1020900@qualcomm.com>
Content-Type: text/plain
Date: Wed, 04 Jun 2008 22:25:47 +0200
Message-Id: <1212611148.19205.22.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-06-04 at 12:26 -0700, Max Krasnyansky wrote:
> Mark Hounschell wrote:
> > IMHO,
> > 
> > What is an abonination, is that cpusets are equired for this type of
> > isolation to begin with, even on a 2 processor machine.
> > 
> > I would like the option to stay and be extended like Max originally
> > proposed. If cpusets/hotplug are configured isolation would be obtained
> > using them. If not then isolcpus could be used to get the same isolation.
> > 
> > From a user land point of view, I just want an easy way to fully isolate
> > a particular cpu. Even a new syscall or extension to sched_setaffinity
> > would make me happy. Cpusets and hotplug don't.
> > 
> > Again this is just MHO.
> 
> Mark, I used to be the same way and I'm a convert now. It does seems like an
> overkill for 2cpu machine to have cpusets and cpu hotplug. But both options
> cost around 50KB worth of text and maybe another 10KB of data. That's on the
> x86-64 box. Let's say it's a 100KB. Not a terribly huge overhead.
> 
> Now if you think about it. In order to be able to dynamically isolate a cpu we
> have to do exact same thing that CPU hotplug does. Which is to clear all
> timers, kernel, threads, etc from that CPUs. It does not make sense to
> implement a separate logic for that. You could argue that you do not need
> dynamic isolation but it's too inflexible in general even on 2way machines
> it's waste to not be able to use second cpu for general load even when RT app
> is not running. Given that CPU hotplug is necessary for many things, including
> suspend on multi-cpu machines it's practically guaranteed to be very stable
> and well supported. In other words we have a perfect synergy here :).
> 
> Now, about the cpusets. You do not really have to do anything fancy with them.
> If all you want to do is to disable systemwide load balancing
> 	mount -tcgroup -o cpuset cpuset /dev/cpuset
> 	echo 0 > /dev/cpuset/cpuset.sched_load_banace
> 
> That's it. You get _exactly_ the same effect as with isolcpus=. And you can
> change that dynamically, and when you switch to quad- and eight- core machines
>  then you'll be to do that with groups of cpus, not just system wide.
> 
> Just to complete the example above. Lets say you want to isolate cpu2
> (assuming that cpusets are already mounted).
> 	
> 	# Bring cpu2 offline
> 	echo 0 > /sys/devices/system/cpu/cpu2/online
> 
> 	# Disable system wide load balancing
> 	echo 0 > /dev/cpuset/cpuset.sched_load_banace
> 	
> 	# Bring cpu2 online
> 	echo 1 > /sys/devices/system/cpu/cpu2/online
> 
> Now if you want to un-isolate cpu2 you do
> 	
> 	# Disable system wide load balancing
> 	echo 1 > /dev/cpuset/cpuset.sched_load_banace
> 	
> Of course this is not a complete isolation. There are also irqs (see my
> "default irq affinity" patch), workqueues and the stop machine. I'm working on
> those too and will release .25 base cpuisol tree when I'm done.

Furthermore, cpusets allow for isolated but load-balanced RT domains. We
now have a reasonably strong RT balancer, and I'm looking at
implementing a full partitioned EDF scheduler somewhere in the future.

This could never be done using isolcpus.

