Return-Path: <linux-kernel-owner+w=401wt.eu-S1753501AbYCLW3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501AbYCLW3u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 18:29:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755852AbYCLW3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 18:29:20 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:17633 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755810AbYCLW3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 18:29:17 -0400
X-IronPort-AV: E=McAfee;i="5100,188,5250"; a="1254721"
Message-ID: <47D8593A.6040503@qualcomm.com>
Date: Wed, 12 Mar 2008 15:29:14 -0700
From: Max Krasnyanskiy <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: menage@google.com, mingo@elte.hu, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org
Subject: Re: boot cgroup questions
References: <47D73086.2030008@qualcomm.com>	<6599ad830803111827n1cb8e2c7i47c2ef3f3bb58995@mail.gmail.com>	<47D7411E.1000009@qualcomm.com>	<6599ad830803111936jd940deam8584bc971c3b6f41@mail.gmail.com>	<47D74595.4080100@qualcomm.com>	<6599ad830803112009y18d9e43ft8e3fc4a551d891da@mail.gmail.com>	<20080311235939.1ebee8e3.pj@sgi.com>	<47D81FE1.6030205@qualcomm.com>	<20080312135746.89456f2a.pj@sgi.com>	<47D82AD2.1070108@qualcomm.com>	<20080312143253.3dd72c7f.pj@sgi.com>	<47D83858.4030806@qualcomm.com> <20080312153712.bc5df7a1.pj@sgi.com>
In-Reply-To: <20080312153712.bc5df7a1.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:

>> This is what I meant by "deeper hierarchies" in the earlier emails.
> 
> These deeper hierarchies create an incompatibility in some common uses
> of cpusets.
> 
> When my example had cpusets A, B and C, that was as stated, not as
> might be modified to X, X/A, X/B and C.
> 
> If the user has or would have setup cpusets A, B and C because that's
> what they needed to manage the CPU and Memory Node placement of their
> tasks, then that's what they might have setup, and there is a good
> chance that they would find the imposition of the extra 'X' cpuset to
> be a problem, to require more code and to be a cause of bugs.

Isn't that just an issue of planing ? Those cpusets are not cast in stones are 
they. I mean yes users have setup A,B,C they way they did because that's what 
they needed. Now their plans/requirements have changed. They now want to also 
manage irqs via cpusets and in order to do that they need to replan/redo the 
partitioning.

In order to manager irqs the code has to change anyway because currently there 
is not way to do that via cpuset. The users would have two options:
1. keep all irqs in the top set and manage them individually via /proc
2. layout cpusets differently

btw I still do not see the "incompatibility" argument. Probably because I have 
no idea how the software you're talking about is designed. Are you saying that 
the software relies on a flat cpuset partitioning ? ie That it will brake if 
users add extra cpuset levels.

> Adding irqs to the cpuset hierarchy isn't free; it can further overload
> the hierarchy, with "deeper hierarchies" as you state.
> 
> If instead of deeper hierarchies, we allow the same irq to be listed in
> more than one cpuset (unlike tasks, which only get one cpuset) then we
> need some way, independent of the cpuset hierarchy, to determine how to
> resolve conflicts.  We can't just add all the cpus together, allowing an
> irq to be directed to any CPU which is listed in any cpuset that
> accepts that irq, because a major use for this is to remove irqs from
> certain realtime CPUs.
This sounds like an overkill and as you pointed out is not even clear how it'd 
work.

Looks like we have a trade-off here:
1. use simple "irq == pseudo-task" concept and potentially brake some existing 
software. We do have working solution.
2. come up with something that requires more complex irq management rules at 
the expense of complexity. We do not have working solution.

My vote goes for #1 :).

> So ... if the natural hierarchy needed to map irqs to CPUs is not a
> subset of the natural hierarchy needed to map tasks to sets of CPUs and
> Nodes, then we either deepen the hierarchy (cross product of the the
> two maps, essentially) or we allow the same irq to be listed in
> multiple cpusets and provide some alternative mechanism, outside the
> hierarchy, to resolve the resulting conflicts in the irq to CPU map.
I think by natural you mean "compatible with existing sw". What is unnatural 
in extra levels of cpusets ? If I read cgroup/cpuset documentation it seems to 
imply that nested cgroups/cpuset are allowed.

Max


