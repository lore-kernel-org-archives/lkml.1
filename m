Return-Path: <linux-kernel-owner+w=401wt.eu-S1765666AbYEIRny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765666AbYEIRny (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 13:43:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753674AbYEIRno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 13:43:44 -0400
Received: from relay2.sgi.com ([192.48.171.30]:51003 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752195AbYEIRnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 13:43:42 -0400
Date: Fri, 9 May 2008 12:43:38 -0500
From: Paul Jackson <pj@sgi.com>
To: Paul Jackson <pj@sgi.com>
Cc: a.p.zijlstra@chello.nl, maxk@qualcomm.com, menage@google.com,
       mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: IRQ affinities (was: boot cgroup questions)
Message-Id: <20080509124338.5a3c4f81.pj@sgi.com>
In-Reply-To: <20080509073650.045d037d.pj@sgi.com>
References: <47D73086.2030008@qualcomm.com>
	<6599ad830803111827n1cb8e2c7i47c2ef3f3bb58995@mail.gmail.com>
	<47D7411E.1000009@qualcomm.com>
	<6599ad830803111936jd940deam8584bc971c3b6f41@mail.gmail.com>
	<47D74595.4080100@qualcomm.com>
	<6599ad830803112009y18d9e43ft8e3fc4a551d891da@mail.gmail.com>
	<20080311235939.1ebee8e3.pj@sgi.com>
	<47D81FE1.6030205@qualcomm.com>
	<20080312135746.89456f2a.pj@sgi.com>
	<47D82AD2.1070108@qualcomm.com>
	<20080312143253.3dd72c7f.pj@sgi.com>
	<47D83858.4030806@qualcomm.com>
	<20080312153712.bc5df7a1.pj@sgi.com>
	<47D8593A.6040503@qualcomm.com>
	<20080312183059.6716d630.pj@sgi.com>
	<47D87BE5.4010702@qualcomm.com>
	<20080313020300.92244956.pj@sgi.com>
	<47FE5655.10900@qualcomm.com>
	<20080414133902.7878cfce.pj@sgi.com>
	<1210329926.13978.224.camel@twins>
	<20080509061727.5057de1f.pj@sgi.com>
	<1210333738.13978.246.camel@twins>
	<20080509070314.f86aece4.pj@sgi.com>
	<1210335270.13978.252.camel@twins>
	<20080509073650.045d037d.pj@sgi.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pj, talking to himself:
> That is, for example, one might want all the CPUs in cpusets
> foo, bar and baz, except the CPUs in cpuset blip, to handle
> IRQs so and so.

Ahh!  Perhaps that example has the keys to this kingdom.

How about this.  We add two files to each cpuset:

    irq_affinity_include	# IRQs to direct to CPUs in this cpuset
    irq_affinity_exclude	# IRQs -not- to direct to these CPUs

where irq_affinity_exclude overrides irq_affinity_include.

So, to determine to which CPUs a given interrupt (IRQ) can be directed:
 1) Combine (union) the 'cpus' of all the cpusets for which
    that IRQ is in that cpusets irq_affinity_include, then
 2) Remove (set substraction) the 'cpus' of any cpuset for which
    that IRQ is in that cpusets irq_affinity_exclude.

In the simplest case of just wanting to isolate some CPUs with their
own special list of interrupts, one would:
 1) include all interrupts in the top cpusets irq_affinity_include, and
 2) include the interrupts you don't want in the isolated cpusets
    irq_affinity_exclude.

Observe that there is no dependency on the cpuset hierarchy in the above.

The contents of the files irq_affinity_include and irq_affinity_exclude
would be inherited by child cpusets on creation from their parents.

The one detail that puzzles me at the moment is what ownership and
permissions these two irq_affinity_* files would have.  I am concerned
that the usual permissions, which allow a job to write its own cpuset
files would allow a job to affect the overall system to a greater
degree than is desired.  Perhaps an additional inheritance rule would
be useful and appropriate, such as a rule that a given cpusets
irq_affinity_include must be a subset of its parents or a rule that
a given cpusets irq_affinity_exclude must be a -superset- of its
parents; I'm unsure here.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
