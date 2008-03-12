Return-Path: <linux-kernel-owner+w=401wt.eu-S1752367AbYCLE74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367AbYCLE74 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 00:59:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751147AbYCLE7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 00:59:46 -0400
Received: from relay2.sgi.com ([192.48.171.30]:58109 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751130AbYCLE7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 00:59:45 -0400
Date: Tue, 11 Mar 2008 23:59:39 -0500
From: Paul Jackson <pj@sgi.com>
To: "Paul Menage" <menage@google.com>
Cc: maxk@qualcomm.com, mingo@elte.hu, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org
Subject: Re: boot cgroup questions
Message-Id: <20080311235939.1ebee8e3.pj@sgi.com>
In-Reply-To: <6599ad830803112009y18d9e43ft8e3fc4a551d891da@mail.gmail.com>
References: <47D73086.2030008@qualcomm.com>
	<6599ad830803111827n1cb8e2c7i47c2ef3f3bb58995@mail.gmail.com>
	<47D7411E.1000009@qualcomm.com>
	<6599ad830803111936jd940deam8584bc971c3b6f41@mail.gmail.com>
	<47D74595.4080100@qualcomm.com>
	<6599ad830803112009y18d9e43ft8e3fc4a551d891da@mail.gmail.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul M wrote:
> >  they will now have to unset it in the 'boot' set as well.
> 
> That can break existing userspace, so I presume PaulJ isn't in favour
> of this change.

You're right - I don't favor it.

Using the 'cpus' in one or more cpusets to determine both:
 1) which CPUs can receive an irq, and
 2) resolving conflicts in such irq placement,
excessively overloads the cpuset hierarchy, breaking existing
userspace, as Paul M notes.

If you don't have any other cpuset hierarchy you need to use, and
so don't really otherwise care what your cpuset hierarchy is, then
I suppose this works just fine.

But if you also need to use the cpuset hierarchy to define nested
subsets of CPUs and Memory Nodes, for the purposes of controlling
which tasks can run where (the original and still primary motivation
for cpusets) then one can only conveniently specify those trivial
irq configurations that happen to exactly conform with that hierarchy
(that exactly want to make use of some of the same sets of CPUs, and
that don't depend on the hierarchy to resolve conflicts in overlapping
irq directives).

Almost any non-trivial use of cpusets for both irq directivity and CPU
and Memory placement would complicate both hierarchies, forcing
unending confusion and breakage on the existing cpuset users.

Some examples:

    Let's say I have three cpusets defining the CPU and Memory Node
    sets in which I want to place my tasks:

	    /dev/cpuset/A
	    /dev/cpuset/B
	    /dev/cpuset/C

    and I want a particular set of irqs to be directed to the CPUs in A
    and B, but not C.  Well -- guess I can duplicate the irqs settings.

    But don't tell me to use a 'boot' cpuset, as in:

	    /dev/cpuset/boot/A
	    /dev/cpuset/boot/B
	    /dev/cpuset/C

    to accomplish this, as that intrudes in the hierarchy, breaking
    user code.

    If my irq isolation needs don't exactly partition along the
    'cpus' settings in A, B and C, then not even duplication helps.

    If the 'irqs' in /dev/cpuset/A/Z (where Z's cpus are a proper
    subset of A's) don't match the 'irqs' in /dev/cpuset/A, then I
    have further confusions resulting from conflicting irq directives.

(If your proposal handles all the above, without forcing changes
on the cpuset hierarchy, then I misread it - in that case, sorry.)

Paul M has already proposed pulling apart the binding of CPUs and
Memory Nodes, in the underlying cgroups, as he apparently has cases in
which the legacy connection of those two into a single cpuset hierarchy
is an undesired constraint on (complication of) the hierarchy.
That's more likely the direction in which we should be proceeding --
making these hierarchies independent, not entwining them.

This additional overloading of the current cpuset hierarchy might
handle the simple case you need.  But that's only because you don't
have conflicting needs for the cpuset hierarchy.

Hopefully, Paul M will be able to view with some sense of humor that I
am complaining that this proposal of yourself (and Peter Z's earlier
patches) isn't general enough, even as I have complained of some of
some other recent cgroup proposals of Paul M that their increased
generality isn't sufficient to justify their subtle incompatibilities.

At a minimum, as in my proposal (http://lkml.org/lkml/2008/3/6/512) of
last week, one needs some mechanism independent of the cpuset hierarchy
to resolve conflicts in these irq directives.  As you may recall,
that proposal named each set of irqs, let each cpuset specify which
named set of irqs applied to its CPUs, and encoded the precedence N
of each named list of irqs in the filename '/dev/cpuset/irqs.N.name'
of the file listing the irqs in that named set.  Then one can specify
irqs for each cpuset, and have some way to specify the precedence of
these irq specifications, without overloading the cpuset hierarchy.

Even this minimum proposal might be insufficient, if one has needs
to specify irq directives for sets of CPUs that are not otherwise
present in the cpuset hierarchy.  Observe that this proposal does
not handle the next to the last example case above.  I am not yet
convinced that this deficiency is a show stopper.  It might be.

The other direction considered, making this its own cgroup, -seemed-
to fail as well, as someone, I forget whom, noted.  Cgroups attach
tasks to sets of things.  We aren't trying to attach tasks to anything.
We're trying to attach irqs to CPUs.  We are trying now to treat irqs
as 'pseudo-tasks', but that forces the irq hierarchy to be a subset
of the CPU hierarchy, due to overloading the 'cpus' set.  This is the
problem noted above.

Paul M -- could we take a different tack here -- extend cgroups to map
-either- tasks or irqs to the managed resources?  Then irqs would be
managed by a cgroup hierarchy that mapped irqs to a subsystem specific
attribute of 'cpus' (resembling the cpuset 'cpus').  If the hierarchy
one needed for irqs was a nice subset of ones cpuset hierarchy, one
might even mount both cgroup subsystems on the same mount, so long
as we could work out what it means for two cgroup subsystems to share
the same subsystem specific attribute, 'cpus' in this case.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
