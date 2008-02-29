Return-Path: <linux-kernel-owner+w=401wt.eu-S934091AbYB2VmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934091AbYB2VmV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 16:42:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761480AbYB2VmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 16:42:05 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:58471 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761411AbYB2VmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 16:42:04 -0500
X-IronPort-AV: E=McAfee;i="5200,2160,5242"; a="1040968"
Message-ID: <47C87C28.2010606@qualcomm.com>
Date: Fri, 29 Feb 2008 13:42:00 -0800
From: Max Krasnyanskiy <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Jackson <pj@sgi.com>, mingo@elte.hu, tglx@linutronix.de,
       oleg@tv-sign.ru, rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       rientjes@google.com
Subject: Re: [RFC/PATCH] cpuset: cpuset irq affinities
References: <20080227222103.673194000@chello.nl>	 <1204311351.6243.130.camel@lappy>  <20080229145516.4d96aeaa.pj@sgi.com> <1204319674.6243.145.camel@lappy>
In-Reply-To: <1204319674.6243.145.camel@lappy>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Fri, 2008-02-29 at 14:55 -0600, Paul Jackson wrote:

>> Do these irqs have any special hardware affinity?  Or are they
>> just consumers of CPU cycles that can be jammed onto whatever CPU(s)
>> we're willing to let be interrupted?
> 
> Depends a bit, the genirq layer seems to allow for irqs that can't be
> freely placed. But most of them can be given a free mask - /me looks @
> tglx/ingo.
We should just check the return value from irq_set_affinity(). If it fails we 
refuse to add it to the set.

>> If for reason of desired hardware affinity, or perhaps for some other
>> reason that I'm not aware of, we wanted to have the combined CPUs in
>> both the 'boot' and 'big_special_app' handle some irq, then we'd be
>> screwed.  We can't easily define, using the cpuset interface and its
>> conventions, a distinct cpuset overlapping boot and big_special_app,
>> to hold that irq.  Any such combining cpuset would have to be the
>> common parent of both the combined cpusets, an annoying intrusion on
>> the expected hierarchy.
>>
>> If the actual set of CPUs we wanted to handle a particular irq wasn't
>> even the union of any pre-existing set of cpusets, then we'd be even
>> more screwed, unable even to force the issue by imposing additional
>> intermediate combined cpusets to meet the need.
> 
> I see the issue. We don't support mv on cgroups, right? To easily create
> common parents...
I guess there maybe some fancy HW topologies that may be a problem but for 
most cases we should be ok.
Simple cases like unmovable IRQs are easy to handle (ie set_affinity() fails 
and we refuse to add it to the cpuset).

>> If there is any potential for this to be a problem, then we should
>> examine the possibility of making irqs their own cgroup, rather than
>> piggy backing them on cpusets (which are now just one instance of a
>> cgroup module.)
> 
> Hmm, but that would then be another controller based on cpus. Might be a
> tad confusing. Might be needed. I'll ponder..
Yeah, I'd prefer it to be along with cpusets. As I mentioned will need similar 
mechanisms for other things besides irqs for complete isolation. Creating a 
separate group for each sounds like an overkill.

Max


