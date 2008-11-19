Return-Path: <linux-kernel-owner+w=401wt.eu-S1752157AbYKSFOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157AbYKSFOa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 00:14:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750716AbYKSFOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 00:14:22 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:30108 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbYKSFOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 00:14:21 -0500
X-IronPort-AV: E=McAfee;i="5300,2777,5438"; a="13286447"
Message-ID: <4923A0A8.5050009@qualcomm.com>
Date: Tue, 18 Nov 2008 21:14:16 -0800
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Nish Aravamudan <nish.aravamudan@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Dimitri Sivanich <sivanich@sgi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Using cpusets for configuration/isolation [Was Re: RT sched:
 cpupri_vec lock contention with def_root_domain and no load balance]
References: <29495f1d0811071123x37d910a8w6c1604b8159954ec@mail.gmail.com>	 <4923731E.7010601@qualcomm.com> <29495f1d0811181811r1a7476ceyb5cb4a86e11e7651@mail.gmail.com>
In-Reply-To: <29495f1d0811181811r1a7476ceyb5cb4a86e11e7651@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nish Aravamudan wrote:
> On Tue, Nov 18, 2008 at 5:59 PM, Max Krasnyansky <maxk@qualcomm.com> wrote:
>> I do not see how 'partfs' that you described would be different from
>> 'cpusets' that we have now. Just ignore 'tasks' files in the cpusets and you
>> already have your 'partfs'. You do _not_ have to use cpuset for assigning
>> tasks if you do not want to. Just use them to define sets of cpus and keep
>> all the tasks in the 'root' set. You can then explicitly pin your threads
>> down with pthread_set_affinity().
> 
> I guess you're right. It still feels a bit kludgy, but that is probably just me.
> 
> I have wondered, though, if it makes sense to provide an "isolated"
> file in /sys/devices/system/cpu/cpuX/ to do most of the offline
> sequence, break sched_domains and remove a CPU from the load balancer
> (rather than turning the load balancer off), rather than requiring a
> user to explicitly do an offline/online. 
I do not see any benefits in exposing a special 'isolated' bit and have it do
the same thing that the cpu hotplug already does. As I explained in other
threads cpu hotplug is a _perfect_ fit for the isolation purposes. In order to
isolate a CPU dynamically (ie at runtime) we need to flush pending work, flush
chaches, move tasks and timers, etc. Which is _exactly_ what cpu hotplug code
does when it brings CPU down. There is no point in reimplementing it.

btw It sounds like you misunderstood the meaning of the
cpuset.sched_load_balance flag. It's does not turn really turn load balancer
off, it simply causes cpus in different cpusets to be put into separate sched
domains. In other words it already does exactly what you're asking for.

> I guess it can all be rather
> transparently masked via a userspace tool, but we don't have a common
> one yet.
I do :). It's called 'syspart'
	http://git.kernel.org/?p=linux/kernel/git/maxk/syspart.git;a=summary
I'll push an updated version in a couple of days.

> I do have a question, though: is your recommendation to just turn the
> load balancer off in the cpuset you create that has the isolated CPUs?
> I guess the conceptual issue I was having was that the root cpuset (I
> think) always contains all CPUs and all memory nodes. So even if you
> put some CPUs in a cpuset under the root one, and isolate them using
> hotplug + disabling the load balancer in that cpuset, those CPUs are
> still available to tasks in the root cpuset? Maybe I'm just missing a
> step in the configuration, but it seems like as long as the global
> (root cpuset) load balancer is on, a CPU can't be guaranteed to stay
> isolated?
Take a look at what 'syspart' does. In short yes, of course we need to set
sched_load_balance flag in root cpuset to 0.

Max





