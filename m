Return-Path: <linux-kernel-owner+w=401wt.eu-S1760721AbYBZCF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760721AbYBZCF5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 21:05:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756104AbYBZCFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 21:05:49 -0500
Received: from relay2.sgi.com ([192.48.171.30]:35298 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755446AbYBZCFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 21:05:48 -0500
Date: Mon, 25 Feb 2008 20:05:38 -0600
From: Paul Jackson <pj@sgi.com>
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: kosaki.motohiro@jp.fujitsu.com, alan@lxorguk.ukuu.org.uk, adilger@sun.com,
       akpm@linux-foundation.org, daniel.spang@gmail.com, mingo@elte.hu,
       jonathan@jonmasters.org, marcelo@kvack.org, menage@google.com,
       pavel@ucw.cz, a.p.zijlstra@chello.nl, riel@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: Tiny cpusets -- cpusets for small systems?
Message-Id: <20080225200538.e06beb38.pj@sgi.com>
In-Reply-To: <47C0EA62.4000807@qualcomm.com>
References: <20080223060911.e1d13cc1.pj@sgi.com>
	<47C0EA62.4000807@qualcomm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So. I see cpusets as a higher level API/mechanism and cpu_isolated_map as lower
> level mechanism that actually makes kernel aware of what's isolated what's not.
> Kind of like sched domain/cpuset relationship. ie cpusets affect sched domains
> but scheduler does not use cpusets directly.

One could use cpusets to control the setting of cpu_isolated_map,
separate from the code such as your select_irq_affinity() that
uses it.


> In a foreseeable future 2-8 cores will be most common configuration.
> Do you think that cpusets are needed/useful for those machines ?
> The reason I'm asking is because given the restrictions you mentioned
> above it seems that you might as well just do
> 	taskset -c 1,2,3 app1
> 	taskset -c 3,4,5 app2 

People tend to manage the CPU and memory placement of the threads
and processes within a single co-operating job using taskset
(sched_setaffinity) and numactl (mbind, set_mempolicy.)

They tend to manage the placement of multiple unrelated jobs onto
a single system, whether on separate or shared CPUs and nodes,
using cpusets.

Something like cpu_isolated_map looks to me like a system-wide
mechanism, which should, like sched_domains, be managed system-wide.
Managing it with a mechanism that encourages each thread to update
it directly, as if that thread owned the system, will break down,
resulting in conflicting updates, as multiple, insufficiently
co-operating threads issue conflicting settings.


> Stuff that I'm working on this days (wireless basestations) is designed
> with the  following model:
> 	cpuN - runs soft-RT networking and management code
> 	cpuN+1 to cpuN+x - are used as dedicated engines
> ie Simplest example would be
> 	cpu0 - runs IP, L2 and control plane
> 	cpu1 - runs hard-RT MAC 
> 
> So if CPU isolation is implemented on top of the cpusets what kind of API do 
> you envision for such an app ?

That depends on what more API is needed.  Do we need to place
irqs better ... cpusets might not be a natural for that use.
Aren't irqs directed to specific CPUs, not to hierarchically
nested subsets of CPUs.

Separate question:
  Is it desired that the dedicated CPUs cpuN+1 ... cpuN+x even appear
  as general purpose systems running a Linux kernel in your systems?
  These dedicated engines seem more like intelligent devices to me,
  such as disk controllers, which the kernel controls via device
  drivers, not by loading itself on them too.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
