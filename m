Return-Path: <linux-kernel-owner+w=401wt.eu-S1755861AbYBXDy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861AbYBXDy3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 22:54:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752067AbYBXDyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 22:54:18 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:48025 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbYBXDyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 22:54:16 -0500
X-IronPort-AV: E=McAfee;i="5200,2160,5236"; a="880812"
Message-ID: <47C0EA62.4000807@qualcomm.com>
Date: Sat, 23 Feb 2008 19:54:10 -0800
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Andreas Dilger <adilger@sun.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Spang <daniel.spang@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Jon Masters <jonathan@jonmasters.org>,
       Marcelo Tosatti <marcelo@kvack.org>, Paul Menage <menage@google.com>,
       Pavel Machek <pavel@ucw.cz>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Tiny cpusets -- cpusets for small systems?
References: <20080223060911.e1d13cc1.pj@sgi.com>
In-Reply-To: <20080223060911.e1d13cc1.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

> A couple of proposals have been made recently by people working Linux
> on smaller systems, for improving realtime isolation and memory
> pressure handling:
> 
> (1) cpu isolation for hard(er) realtime
> 	http://lkml.org/lkml/2008/2/21/517
> 	Max Krasnyanskiy <maxk@qualcomm.com>
> 	[PATCH sched-devel 0/7] CPU isolation extensions
> 
> (2) notify user space of tight memory
> 	http://lkml.org/lkml/2008/2/9/144
> 	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> 	[PATCH 0/8][for -mm] mem_notify v6
> 
> In both cases, some of us have responded "why not use cpusets", and the
> original submitters have replied "cpusets are too fat"  (well, they
> were more diplomatic than that, but I guess I can say that ;)

My primary issue with cpusets (from CPU isolation perspective that is) was 
not the fatness. I did make a couple of comments like "On dual-cpu box
I do not need cpusets to manage the CPUs" but that's not directly related to
the CPU isolation.
For the CPU isolation in particular I need code like this
	
int select_irq_affinity(unsigned int irq)
{
        cpumask_t usable_cpus;
        cpus_andnot(usable_cpus, cpu_online_map, cpu_isolated_map);
        irq_desc[irq].affinity = usable_cpus;
        irq_desc[irq].chip->set_affinity(irq, usable_cpus);
        return 0;
}

How would you implement that with cpusets ?
I haven't seen you patches but I'd imagine that they will still need locks and 
iterators for "Is CPU N isolated" functionality.

So. I see cpusets as a higher level API/mechanism and cpu_isolated_map as lower
level mechanism that actually makes kernel aware of what's isolated what's not.
Kind of like sched domain/cpuset relationship. ie cpusets affect sched domains
but scheduler does not use cpusets directly.

> I wonder if there might be room for a "tiny cpusets" configuration option:
>   * provide the same hooks to the rest of the kernel, and
>   * provide the same syntactic interface to user space, but
>   * with more limited semantics.
> 
> The primary semantic limit I'd suggest would be supporting exactly
> one layer depth of cpusets, not a full hierarchy.  So one could still
> successfully issue from user space 'mkdir /dev/cpuset/foo', but trying
> to do 'mkdir /dev/cpuset/foo/bar' would fail.  This reminds me of
> very early FAT file systems, which had just a single, fixed size
> root directory ;).  There might even be a configurable fixed upper
> limit on how many /dev/cpuset/* directories were allowed, further
> simplifying the locking and dynamic memory behavior of this apparatus.
In a foreseeable future 2-8 cores will be most common configuration.
Do you think that cpusets are needed/useful for those machines ?
The reason I'm asking is because given the restrictions you mentioned
above it seems that you might as well just do
	taskset -c 1,2,3 app1
	taskset -c 3,4,5 app2 
Yes it's not quite the same of course but imo covers most cases. That's what we
do on 2-4 cores these days, and are quite happy with that. ie We either let the 
specialized apps manage their thread affinities themselves or use "taskset" to 
manage the apps.

> User space would see the same API, except that some valid operations
> on full cpusets, such as a nested mkdir, would fail on tiny cpusets.
Speaking of user-space API. I guess it's not directly related to the tiny-cpusets 
proposal but rather to the cpusets in general.
Stuff that I'm working on this days (wireless basestations) is designed with the 
following model:
	cpuN - runs soft-RT networking and management code
	cpuN+1 to cpuN+x - are used as dedicated engines
ie Simplest example would be
	cpu0 - runs IP, L2 and control plane
	cpu1 - runs hard-RT MAC 

So if CPU isolation is implemented on top of the cpusets what kind of API do 
you envision for such an app ? I mean currently cpusets seems to be mostly dealing
with entire processes, whereas in this case we're really dealing with the threads. 
ie Different threads of the same process require different policies, some must run
on isolated cpus some must not. I guess one could write a thread's pid into cpusets
fs but that's not very convenient. pthread_set_affinity() is exactly what's needed.
Personally I do not see much use for cpusets for those kinds of designs. But maybe
I missing something. I got really excited when cpusets where first merged into 
mainline but after looking closer I could not really find a use for them, at least 
for not for our apps.

Max
