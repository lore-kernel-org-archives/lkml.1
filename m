Return-Path: <linux-kernel-owner+w=401wt.eu-S2992945AbXCIE1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992945AbXCIE1O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 23:27:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992947AbXCIE1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 23:27:14 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:34698 "EHLO
	netops-testserver-3.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S2992945AbXCIE1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 23:27:13 -0500
Date: Thu, 8 Mar 2007 20:27:13 -0800
From: Paul Jackson <pj@sgi.com>
To: Sam Vilain <sam@vilain.net>
Cc: menage@google.com, ebiederm@xmission.com, serue@us.ibm.com,
       vatsa@in.ibm.com, akpm@linux-foundation.org, dev@sw.ru, xemul@sw.ru,
       containers@lists.osdl.org, winget@google.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] resource control file system - aka containers on
 top of nsproxy!
Message-Id: <20070308202713.34de89ed.pj@sgi.com>
In-Reply-To: <45EF5E71.7090101@vilain.net>
References: <20070301133543.GK15509@in.ibm.com>
	<6599ad830703061832w49179e75q1dd975369ba8ef39@mail.gmail.com>
	<20070307173031.GC2336@in.ibm.com>
	<20070307174346.GA19521@sergelap.austin.ibm.com>
	<20070307180055.GC17151@in.ibm.com>
	<20070307205846.GB7010@sergelap.austin.ibm.com>
	<6599ad830703071320ib687019h34d2e66c4abc3794@mail.gmail.com>
	<m1odn4bs6n.fsf@ebiederm.dsl.xmission.com>
	<6599ad830703071518y715ecdb2y33752a6e25b5ecdb@mail.gmail.com>
	<45EF5A62.8000103@vilain.net>
	<6599ad830703071642n69bbd801n6114fa6f9e60a168@mail.gmail.com>
	<45EF5E71.7090101@vilain.net>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> But "namespace" has well-established historical semantics too - a way
> of changing the mappings of local * to global objects. This
> accurately describes things liek resource controllers, cpusets, resource
> monitoring, etc.

No!

Cpusets don't rename or change the mapping of objects.

I suspect you seriously misunderstand cpusets and are trying to cram them
into a 'namespace' remapping role into which they don't fit.

So far as cpusets are concerned, CPU #17 is CPU #17, for all tasks,
regardless of what cpuset they are in.  They just might not happen to
be allowed to execute on CPU #17 at the moment, because that CPU is not
allowed by the cpuset they are in.

But they still call it CPU #17.

Similary the namespace of cpusets and of tasks (pid's) are single
system-wide namespaces, so far as cpusets are concerned.

Cpusets are not about alternative or multiple or variant name spaces.
They are about (considering just CPUs for the moment):
 1) creating a set of maps M0, M1, ... from the set of CPUs to a Boolean,
 2) creating a mapping Q from the set of tasks to these M0, ... maps, and
 3) imposing constraints on where tasks can run, as follows:
	For any task t, that task is allowed to run on CPU x iff Q(t)(x)
	is True.  Here, Q(t) will be one of the maps M0, ... aka a cpuset.

So far as cpusets are concerned, there is only one each of:
 A] a namespace numbering CPUs,
 B] a namespace numbering tasks (the process id),
 C] a namespace naming cpusets (the hierarchical name space normally
    mounted at /dev/cpuset, and corresponding to the Mn maps above) and
 D] a mapping of tasks to cpusets, system wide (just a map, not a namespace.)

All tasks (of sufficient authority) can see each of these, using a single
system wide name space for each of [A], [B], and [C].

Unless, that is, you call any mapping a "way of changing mappings".
To do so would be a senseless abuse of the phrase, in my view.

More generally, these resource managers all tend to divide some external
limited physical resource into multiple separately allocatable units.

If the resource is amorphous (one atom or cycle of it is interchangeable
with another) then we usually do something like divide it into 100
equal units and speak of percentages.  If the resource is naturally
subdivided into sufficiently small units (sufficient for the
granularity of resource management we require) then we take those units
as is.  Occassionally, as in the 'fake numa node' patch by David
Rientjes <rientjes@cs.washington.edu>, who worked at Google over the
last summer, if the natural units are not of sufficient granularity, we
fake up a somewhat finer division.

Then, in any case, and somewhat separately, we divide the tasks running
on the system into subsets.  More precisely, we partition the tasks,
where a partition of a set is a set of subsets of that set, pairwise
disjoint, whose union equals that set.

Then, finally, we map the task subsets (partition element) to the
resource units, and add hooks in the kernel where this particular
resource is allocated or scheduled to constrain the tasks to only using
the units to which their task partition element is mapped.

These hooks are usually the 'interesting' part of a resource management
patch; one needs to minimize impact on both the kernel source code and
on the runtime performance, and for these hooks, that can be a
challenge.  In particular, what are naturally system wide resource
management stuctures cannot be allowed to impose system wide locks on
critical resource allocation code paths (and it's usually the most
critical resources, such as memory, cpu and network, that we most need
to manage in the first place.)

==> This has nothing to do with remapping namespaces as I might use that
    phrase though I cannot claim to be qualified enough to speak on behalf
    of the Generally Established Principles of Computer Science.

I am as qualified as anyone to speak on behalf of cpusets, and I suspect
you are not accurately understanding them if you think of them as remapping
namespaces.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
