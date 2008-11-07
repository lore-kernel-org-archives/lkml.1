Return-Path: <linux-kernel-owner+w=401wt.eu-S1752466AbYKGTYG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466AbYKGTYG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 14:24:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755146AbYKGTXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 14:23:52 -0500
Received: from el-out-1112.google.com ([209.85.162.180]:28734 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755060AbYKGTXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 14:23:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=NRiy0C0Uyk5e2q1RLGwjKVxagOH4Kh/WZYvSWuZlmJKgscDAoGzNn6XeFsjA14jooo
         dUpccOLl3xg8Ypch/yETOliPUtMzpcWkzLzVWtxeW01aQpzQl/que3QqpMDBa5JOKcIm
         a6qSPnT0INyx6+cQrRFRZxYTXMLfo4kltssxU=
Message-ID: <29495f1d0811071123x37d910a8w6c1604b8159954ec@mail.gmail.com>
Date: Fri, 7 Nov 2008 11:23:47 -0800
From: "Nish Aravamudan" <nish.aravamudan@gmail.com>
To: "Peter Zijlstra" <peterz@infradead.org>
Subject: Using cpusets for configuration/isolation [Was Re: RT sched: cpupri_vec lock contention with def_root_domain and no load balance]
Cc: "Gregory Haskins" <ghaskins@novell.com>,
       "Dimitri Sivanich" <sivanich@sgi.com>, linux-kernel@vger.kernel.org,
       "Ingo Molnar" <mingo@elte.hu>, "Paul Jackson" <pj@sgi.com>,
       "Max Krasnyansky" <maxk@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Adding Max K. and Paul J. to the Cc]

On 11/6/08, Nish Aravamudan <nish.aravamudan@gmail.com> wrote:
> On Tue, Nov 4, 2008 at 6:36 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>  > On Tue, 2008-11-04 at 09:34 -0500, Gregory Haskins wrote:
>  >> Gregory Haskins wrote:
>  >> > Peter Zijlstra wrote:
>  >> >
>  >> >> On Mon, 2008-11-03 at 15:07 -0600, Dimitri Sivanich wrote:
>  >> >>
>  >> >>
>  >> >>> When load balancing gets switched off for a set of cpus via the
>  >> >>> sched_load_balance flag in cpusets, those cpus wind up with the
>  >> >>> globally defined def_root_domain attached.  The def_root_domain is
>  >> >>> attached when partition_sched_domains calls detach_destroy_domains().
>  >> >>> A new root_domain is never allocated or attached as a sched domain
>  >> >>> will never be attached by __build_sched_domains() for the non-load
>  >> >>> balanced processors.
>  >> >>>
>  >> >>> The problem with this scenario is that on systems with a large number
>  >> >>> of processors with load balancing switched off, we start to see the
>  >> >>> cpupri->pri_to_cpu->lock in the def_root_domain becoming contended.
>  >> >>> This starts to become much more apparent above 8 waking RT threads
>  >> >>> (with each RT thread running on it's own cpu, blocking and waking up
>  >> >>> continuously).
>  >> >>>
>  >> >>> I'm wondering if this is, in fact, the way things were meant to work,
>  >> >>> or should we have a root domain allocated for each cpu that is not to
>  >> >>> be part of a sched domain?  Note the the def_root_domain spans all of
>  >> >>> the non-load-balanced cpus in this case.  Having it attached to cpus
>  >> >>> that should not be load balancing doesn't quite make sense to me.
>  >> >>>
>  >> >>>
>  >> >> It shouldn't be like that, each load-balance domain (in your case a
>  >> >> single cpu) should get its own root domain. Gregory?
>  >> >>
>  >> >>
>  >> >
>  >> > Yeah, this sounds broken.  I know that the root-domain code was being
>  >> > developed coincident to some upheaval with the cpuset code, so I suspect
>  >> > something may have been broken from the original intent.  I will take a
>  >> > look.
>  >> >
>  >> > -Greg
>  >> >
>  >> >
>  >>
>  >> After thinking about it some more, I am not quite sure what to do here.
>  >> The root-domain code was really designed to be 1:1 with a disjoint
>  >> cpuset.  In this case, it sounds like all the non-balanced cpus are
>  >> still in one default cpuset.  In that case, the code is correct to place
>  >> all those cores in the singleton def_root_domain.  The question really
>  >> is: How do we support the sched_load_balance flag better?
>  >>
>  >> I suppose we could go through the scheduler code and have it check that
>  >> flag before consulting the root-domain.  Another alternative is to have
>  >> the sched_load_balance=false flag create a disjoint cpuset.  Any thoughts?
>  >
>  > Hmm, but you cannot disable load-balance on a cpu without placing it in
>  > an cpuset first, right?
>  >
>  > Or are folks disabling load-balance bottom-up, instead of top-down?
>  >
>  > In that case, I think we should dis-allow that.
>
>
> I don't have a lot of insight into the technical discussion, but will
>  say that (if I understand you right), the "bottom-up" approach was
>  recommended on LKML by Max K. in the (long) thread from earlier this
>  year with Subject "Inquiry: Should we remove "isolcpus= kernel boot
>  option? (may have realtime uses)":
>
>  "Just to complete the example above. Lets say you want to isolate cpu2
>  (assuming that cpusets are already mounted).
>
>        # Bring cpu2 offline
>        echo 0 > /sys/devices/system/cpu/cpu2/online
>
>        # Disable system wide load balancing
>        echo 0 > /dev/cpuset/cpuset.sched_load_banace
>
>        # Bring cpu2 online
>        echo 1 > /sys/devices/system/cpu/cpu2/online
>
>  Now if you want to un-isolate cpu2 you do
>
>        # Disable system wide load balancing
>        echo 1 > /dev/cpuset/cpuset.sched_load_banace
>
>  Of course this is not a complete isolation. There are also irqs (see my
>  "default irq affinity" patch), workqueues and the stop machine. I'm working on
>  those too and will release .25 base cpuisol tree when I'm done."
>
>  Would you recommend instead, then, that a new cpuset be created with
>  only cpu 2 in it (should one set cpuset.cpu_exclusive then?) and then
>  disabling load balancing in that cpuset?

Perhaps this is not a welcome comment, but I have been wondering this
as I spent some time playing with CPU isolation. Are cpusets the right
interface for system configuration?

It seems to me that, and the Documentation agrees with me, that
cpusets are designed around tasks and constraining in various ways
what system resources the tasks have. But may not have been originally
designed around the configuration of the system resources itself at
the system level. Now obviously these constraints will have
interactions with things like CPU hotplug, sched domains, etc. But it
does not seem obvious to me that cpusets *should* be the recommended
way to achieve isolation.

It *almost* makes sense to me to have a separate interface for system
configuration, perhaps in a system filesystem ... say sysfs :) ...
that could be used to indicate a given CPU should be isolated from the
remainder of the system. It could take the form of a file just like
"online", perhaps called "isolated". But rather than go all the way
through the hotplug sequence as writing to "online" does, it just goes
"through the motions" and then brings the CPU back up. In fact, we
could do more than we do with cpusets-based isolation, like removing
workqueues and stop machine. We would have an isolated_map (I guess)
that corresponds to those CPUs with isolated=1 and provide that list
in /sys/devices/system/cpu like the online file.

Or perhaps it makes more sense to present a filesystem *just* for
system partitioning (partfs?). The root directory would have all the
CPUs (for now, perhaps memory should be there too) and administrators
could create isolated groups of CPUs. But we wouldn't present a
transparent way to assign tasks to isolated CPUs (the tasks file) and
the root directory would automatically lose CPUs placed in its
subdirectories. Perhaps the latter is supported in cpusets by the
cpu_exclusive flag, but let me just say the Documentation is pretty
bad. The only reference to what this flag does:

" - cpu_exclusive flag: is cpu placement exclusive?"

I can't tell exactly what the author means by exclusive here.

This feels like something I read Max K. proposing a while ago, and I'm
sorry if it has already been Nak'd then. It just feels like we're
shoehorning system configuration into cpusets in a way that isn't the
most straightforward, when we have an existing system layout that
should work or could design one that is sane.

Thanks,
Nish
