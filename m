Return-Path: <linux-kernel-owner+w=401wt.eu-S1765507AbYA2Pyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765507AbYA2Pyn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 10:54:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765141AbYA2Pwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 10:52:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40713 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765130AbYA2Pwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 10:52:39 -0500
Message-ID: <479F4B99.4060701@zytor.com>
Date: Tue, 29 Jan 2008 07:51:53 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: yi.y.yang@intel.com
CC: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 2.6.24] x86: add sysfs interface for cpuid module
References: <1199441414.19185.9.camel@yangyi-dev.bj.intel.com>	 <1201043126.3861.5.camel@yangyi-dev.bj.intel.com> <1201562058.12722.9.camel@yangyi-dev.bj.intel.com>
In-Reply-To: <1201562058.12722.9.camel@yangyi-dev.bj.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yi Yang wrote:
> Current cpuid module will create a char device for every logical cpu,
> when a user cats /dev/cpu/*/cpuid, he/she will enter a limitless loop,
> the root cause is that cpuid module doesn't decide wether a cpuid level
> is valid, it just uses an offset to denote cpuid level and take it to
> cpuid instruction, cpuid instruction will ignore it and return some data
> specific to cpu model, cpuid doesn't an error return value because it is
> void type. So cpuid module will execute cpuid continuously and return
> data although most of data make no sense.
> 
> This patch tries to add a sysfs interface for cpuid, users can see all the
> available cpuid levels, specify a specific level and get cpuid corresponding
> to this cpuid level.
> 
> For every logical cpu, this patch will create a cpuid directory under
> /sys/devices/system/cpu/cpu*/, there are three entries under cpuid:
> 
> avail_levels	cur_level	cur_cpuid
> 
> A user can get all the available cpuid levels from avail_levels, he/she can
> set one available cpuid level to cur_level, then he/she can get cpuid from
> cur_cpuid, cur_cpuid corresponds to cur_level.
> 
> This patch uses sysfs to avoid limitless loop and provide more flexible
> interface for cpuid, please consider to merge to -mm tree in order to test.

This is broken.

Triple broken.

It's broken, because it doesn't take into account the fact that Intel 
broke CPUID level 4 and made it "repeating" (neither did the cpuid char 
device, because it predated the Intel braindamage; I've had a patch for 
it privately for a while, but didn't push it upstream because paravirt 
broke it royally and I wanted the situation to settle down.)

It's broken, because the algorithm used to determine valid CPUID levels 
is incorrect; it fails to recognize any CPUID levels other than the main 
Intel and AMD ones, e.g. the Transmeta 0x8086xxxx (and sometimes more) 
and VIA 0xc000xxxx levels.

It's broken, because it is better for the userspace extractor to have 
this logic than to stuff it into the kernel, where it sits hogging 
unswappable memory at all times.

	-hpa
