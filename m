Return-Path: <linux-kernel-owner+w=401wt.eu-S1751875AbYKSCAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875AbYKSCAP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 21:00:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751827AbYKSCAB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 21:00:01 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:63690 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbYKSCAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 21:00:00 -0500
X-IronPort-AV: E=McAfee;i="5300,2777,5438"; a="13282838"
Message-ID: <4923731E.7010601@qualcomm.com>
Date: Tue, 18 Nov 2008 17:59:58 -0800
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Nish Aravamudan <nish.aravamudan@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Dimitri Sivanich <sivanich@sgi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Paul Jackson <pj@sgi.com>
Subject: Re: Using cpusets for configuration/isolation [Was Re: RT sched:
 cpupri_vec lock contention with def_root_domain and no load balance]
References: <29495f1d0811071123x37d910a8w6c1604b8159954ec@mail.gmail.com>
In-Reply-To: <29495f1d0811071123x37d910a8w6c1604b8159954ec@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nish Aravamudan wrote:
> Perhaps this is not a welcome comment, but I have been wondering this
> as I spent some time playing with CPU isolation. Are cpusets the right
> interface for system configuration?
> 
> It seems to me that, and the Documentation agrees with me, that
> cpusets are designed around tasks and constraining in various ways
> what system resources the tasks have. But may not have been originally
> designed around the configuration of the system resources itself at
> the system level. Now obviously these constraints will have
> interactions with things like CPU hotplug, sched domains, etc. But it
> does not seem obvious to me that cpusets *should* be the recommended
> way to achieve isolation.
> 
> It *almost* makes sense to me to have a separate interface for system
> configuration, perhaps in a system filesystem ... say sysfs :) ...
> that could be used to indicate a given CPU should be isolated from the
> remainder of the system. It could take the form of a file just like
> "online", perhaps called "isolated". But rather than go all the way
> through the hotplug sequence as writing to "online" does, it just goes
> "through the motions" and then brings the CPU back up. In fact, we
> could do more than we do with cpusets-based isolation, like removing
> workqueues and stop machine. We would have an isolated_map (I guess)
> that corresponds to those CPUs with isolated=1 and provide that list
> in /sys/devices/system/cpu like the online file.
> 
> Or perhaps it makes more sense to present a filesystem *just* for
> system partitioning (partfs?). The root directory would have all the
> CPUs (for now, perhaps memory should be there too) and administrators
> could create isolated groups of CPUs. But we wouldn't present a
> transparent way to assign tasks to isolated CPUs (the tasks file) and
> the root directory would automatically lose CPUs placed in its
> subdirectories. Perhaps the latter is supported in cpusets by the
> cpu_exclusive flag, but let me just say the Documentation is pretty
> bad. The only reference to what this flag does:
> 
> " - cpu_exclusive flag: is cpu placement exclusive?"
> 
> I can't tell exactly what the author means by exclusive here.
> 
> This feels like something I read Max K. proposing a while ago, and I'm
> sorry if it has already been Nak'd then. It just feels like we're
> shoehorning system configuration into cpusets in a way that isn't the
> most straightforward, when we have an existing system layout that
> should work or could design one that is sane.

What you described is almost exactly what I did in my original cpu 
isolation patch, which did get NAKed :). Basically I used global 
cpu_isolated_map and exposed 'isolated' bit, etc.

I do not see how 'partfs' that you described would be different from 
'cpusets' that we have now. Just ignore 'tasks' files in the cpusets and 
you already have your 'partfs'. You do _not_ have to use cpuset for 
assigning tasks if you do not want to. Just use them to define sets of 
cpus and keep all the tasks in the 'root' set. You can then explicitly 
pin your threads down with pthread_set_affinity().

Max
