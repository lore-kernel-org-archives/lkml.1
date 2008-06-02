Return-Path: <linux-kernel-owner+w=401wt.eu-S1755306AbYFBSjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306AbYFBSjf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 14:39:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754550AbYFBSjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 14:39:23 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:4744 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754042AbYFBSjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 14:39:19 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5308"; a="3613923"
Message-ID: <48443E66.6060205@qualcomm.com>
Date: Mon, 02 Jun 2008 11:39:34 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Dimitri Sivanich <sivanich@sgi.com>
CC: Paul Jackson <pj@sgi.com>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, "Derek L. Fults" <dfults@sgi.com>,
       devik <devik@cdi.cz>, Dinakar Guniguntala <dino@in.ibm.com>,
       Emmanuel Pacaud <emmanuel.pacaud@univ-poitiers.fr>,
       Frederik Deweerdt <deweerdt@free.fr>, Ingo Molnar <mingo@elte.hu>,
       Matthew Dobson <colpatch@us.ibm.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, rostedt@goodmis.org,
       Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Paul Menage <menage@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Randy.Dunlap" <rddunlap@osdl.org>, suresh.b.siddha@intel.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Inquiry: Should we remove "isolcpus= kernel boot option? (may
 have realtime uses)
References: <20080601213019.14ea8ef8.pj@sgi.com> <20080602164203.GA2477@sgi.com>
In-Reply-To: <20080602164203.GA2477@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dimitri Sivanich wrote:
> Paul,
> 
> On Sun, Jun 01, 2008 at 09:30:19PM -0500, Paul Jackson wrote:
>>     Do you, or someone you know, use "isolcpus="?
> 
> We use it.
> 
>>     Can we remove it?
> 
> We use isolcpus to ensure that boot-time intialization, specifically timer
> initialization, happens on a specific set of cpus that we won't be using for
> lower latency purposes. Some of these timers will repeatedly restart
> themselves on the same cpu and a few do add latency (although admittedly I
> haven't checked timer latency recently).
> 
> Looking at tracebacks in 2.6.26-rc3 from hrtimer_init() and
> internal_add_timer() things still appear to be working this way, with the
> timer starting on the originating cpu. If I isolate all but, say one, cpu,
> timers all seem to start on the unisolated cpu.
> 
> Attempts have been made to add an interface to ward timers off of specific
> cpus, but these have always been rejected.

Ah, I know exactly what you're talking about.  However this is non-issue these
days. In order to clear cpuN from all the timers and other things all you need
to do is to bring that cpu off-line
	echo 0 > /sys/devices/cpu/cpuN/online
and then bring it back online
	echo 1 > /sys/devices/cpu/cpuN/online

There are currently a couple of issues with scheduler domains and hotplug
event handling. I do have the fix for them, and Paul had already acked it.

btw Disabling scheduler load balancer is not enough.  Some timers are started
from the hard- and soft- irq handlers. Which means that you have to also
ensure that those CPUs do not handle any irqs (at least during
initialization). See my latest "default IRQ affinity" patch.

>>     Should we remove it?
> 
> Why?
Because the same functionality is available via more flexible mechanism that
is actively supported. isolcpus= is a static mechanism that requires reboots.
cpusets and cpu hotplug let you dynamically repartition the system at any time.
Also isolcpus= conflicts with the scheduler domains created by the cpusets.

>  
>>     Should we first deprecate it somehow, for a while, before
>>     removing it?
> 
> A better idea than just removing it.

I'd either nuke it or expose it when cpusets are disabled.
In other words
- if cpusets are enabled people should use cpusets to configure cpu resources.
- if cpusets are disabled then we could provide a sysctl (sched_balancer_mask
for example) that lets us control which cpus are balanced and which aren't.

Max

