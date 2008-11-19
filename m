Return-Path: <linux-kernel-owner+w=401wt.eu-S1752502AbYKSCLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502AbYKSCLm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 21:11:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751926AbYKSCLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 21:11:33 -0500
Received: from yw-out-2324.google.com ([74.125.46.31]:23793 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbYKSCLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 21:11:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ltow+7+In9oRnGQ4zJsg6XFmT0iAcfPQydu3PLjz/hs5nVt5W1VO7NU0cqwH/JdugU
         atXciqoA39TQwYQpReq4SEhuSYS6mgmp1+ytxsa1qinkY0yS/1YpClD8rqcFVYUuPwPO
         x1SFV7rRd7CUPUhV06orH7MmICpVo8/ltJ6J0=
Message-ID: <29495f1d0811181811r1a7476ceyb5cb4a86e11e7651@mail.gmail.com>
Date: Tue, 18 Nov 2008 18:11:29 -0800
From: "Nish Aravamudan" <nish.aravamudan@gmail.com>
To: "Max Krasnyansky" <maxk@qualcomm.com>
Subject: Re: Using cpusets for configuration/isolation [Was Re: RT sched: cpupri_vec lock contention with def_root_domain and no load balance]
Cc: "Peter Zijlstra" <peterz@infradead.org>,
       "Gregory Haskins" <ghaskins@novell.com>,
       "Dimitri Sivanich" <sivanich@sgi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <4923731E.7010601@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <29495f1d0811071123x37d910a8w6c1604b8159954ec@mail.gmail.com>
	 <4923731E.7010601@qualcomm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Max,

[ Removing Paul's bouncing address... ]

On Tue, Nov 18, 2008 at 5:59 PM, Max Krasnyansky <maxk@qualcomm.com> wrote:
> Nish Aravamudan wrote:
>>
>> Perhaps this is not a welcome comment, but I have been wondering this
>> as I spent some time playing with CPU isolation. Are cpusets the right
>> interface for system configuration?
>>
>> It seems to me that, and the Documentation agrees with me, that
>> cpusets are designed around tasks and constraining in various ways
>> what system resources the tasks have. But may not have been originally
>> designed around the configuration of the system resources itself at
>> the system level. Now obviously these constraints will have
>> interactions with things like CPU hotplug, sched domains, etc. But it
>> does not seem obvious to me that cpusets *should* be the recommended
>> way to achieve isolation.
>>
>> It *almost* makes sense to me to have a separate interface for system
>> configuration, perhaps in a system filesystem ... say sysfs :) ...
>> that could be used to indicate a given CPU should be isolated from the
>> remainder of the system. It could take the form of a file just like
>> "online", perhaps called "isolated". But rather than go all the way
>> through the hotplug sequence as writing to "online" does, it just goes
>> "through the motions" and then brings the CPU back up. In fact, we
>> could do more than we do with cpusets-based isolation, like removing
>> workqueues and stop machine. We would have an isolated_map (I guess)
>> that corresponds to those CPUs with isolated=1 and provide that list
>> in /sys/devices/system/cpu like the online file.
>>
>> Or perhaps it makes more sense to present a filesystem *just* for
>> system partitioning (partfs?). The root directory would have all the
>> CPUs (for now, perhaps memory should be there too) and administrators
>> could create isolated groups of CPUs. But we wouldn't present a
>> transparent way to assign tasks to isolated CPUs (the tasks file) and
>> the root directory would automatically lose CPUs placed in its
>> subdirectories. Perhaps the latter is supported in cpusets by the
>> cpu_exclusive flag, but let me just say the Documentation is pretty
>> bad. The only reference to what this flag does:
>>
>> " - cpu_exclusive flag: is cpu placement exclusive?"
>>
>> I can't tell exactly what the author means by exclusive here.
>>
>> This feels like something I read Max K. proposing a while ago, and I'm
>> sorry if it has already been Nak'd then. It just feels like we're
>> shoehorning system configuration into cpusets in a way that isn't the
>> most straightforward, when we have an existing system layout that
>> should work or could design one that is sane.
>
> What you described is almost exactly what I did in my original cpu isolation
> patch, which did get NAKed :). Basically I used global cpu_isolated_map and
> exposed 'isolated' bit, etc.

Ok, that was what I vaguely recalled from the discussion, thanks.

> I do not see how 'partfs' that you described would be different from
> 'cpusets' that we have now. Just ignore 'tasks' files in the cpusets and you
> already have your 'partfs'. You do _not_ have to use cpuset for assigning
> tasks if you do not want to. Just use them to define sets of cpus and keep
> all the tasks in the 'root' set. You can then explicitly pin your threads
> down with pthread_set_affinity().

I guess you're right. It still feels a bit kludgy, but that is probably just me.

I have wondered, though, if it makes sense to provide an "isolated"
file in /sys/devices/system/cpu/cpuX/ to do most of the offline
sequence, break sched_domains and remove a CPU from the load balancer
(rather than turning the load balancer off), rather than requiring a
user to explicitly do an offline/online. I guess it can all be rather
transparently masked via a userspace tool, but we don't have a common
one yet.

I do have a question, though: is your recommendation to just turn the
load balancer off in the cpuset you create that has the isolated CPUs?
I guess the conceptual issue I was having was that the root cpuset (I
think) always contains all CPUs and all memory nodes. So even if you
put some CPUs in a cpuset under the root one, and isolate them using
hotplug + disabling the load balancer in that cpuset, those CPUs are
still available to tasks in the root cpuset? Maybe I'm just missing a
step in the configuration, but it seems like as long as the global
(root cpuset) load balancer is on, a CPU can't be guaranteed to stay
isolated?

Thanks,
Nish
