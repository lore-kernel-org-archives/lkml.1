Return-Path: <linux-kernel-owner+w=401wt.eu-S1755005AbYA3DE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005AbYA3DE3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 22:04:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752122AbYA3DEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 22:04:21 -0500
Received: from mga09.intel.com ([134.134.136.24]:55418 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727AbYA3DEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 22:04:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,275,1199692800"; 
   d="scan'208";a="294202019"
Subject: Re: [PATCH 2.6.24] x86: add sysfs interface for cpuid module
From: Yi Yang <yi.y.yang@intel.com>
Reply-To: yi.y.yang@intel.com
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <479F4B99.4060701@zytor.com>
References: <1199441414.19185.9.camel@yangyi-dev.bj.intel.com>
	 <1201043126.3861.5.camel@yangyi-dev.bj.intel.com>
	 <1201562058.12722.9.camel@yangyi-dev.bj.intel.com>
	 <479F4B99.4060701@zytor.com>
Content-Type: text/plain
Organization: Intel
Date: Wed, 30 Jan 2008 01:52:18 +0800
Message-Id: <1201629138.12722.23.camel@yangyi-dev.bj.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-01-29 at 07:51 -0800, H. Peter Anvin wrote:
> Yi Yang wrote:
> > Current cpuid module will create a char device for every logical cpu,
> > when a user cats /dev/cpu/*/cpuid, he/she will enter a limitless loop,
> > the root cause is that cpuid module doesn't decide wether a cpuid level
> > is valid, it just uses an offset to denote cpuid level and take it to
> > cpuid instruction, cpuid instruction will ignore it and return some data
> > specific to cpu model, cpuid doesn't an error return value because it is
> > void type. So cpuid module will execute cpuid continuously and return
> > data although most of data make no sense.
> > 
> > This patch tries to add a sysfs interface for cpuid, users can see all the
> > available cpuid levels, specify a specific level and get cpuid corresponding
> > to this cpuid level.
> > 
> > For every logical cpu, this patch will create a cpuid directory under
> > /sys/devices/system/cpu/cpu*/, there are three entries under cpuid:
> > 
> > avail_levels	cur_level	cur_cpuid
> > 
> > A user can get all the available cpuid levels from avail_levels, he/she can
> > set one available cpuid level to cur_level, then he/she can get cpuid from
> > cur_cpuid, cur_cpuid corresponds to cur_level.
> > 
> > This patch uses sysfs to avoid limitless loop and provide more flexible
> > interface for cpuid, please consider to merge to -mm tree in order to test.
> 
> This is broken.
> 
> Triple broken.
> 
> It's broken, because it doesn't take into account the fact that Intel 
> broke CPUID level 4 and made it "repeating" (neither did the cpuid char 
> device, because it predated the Intel braindamage; I've had a patch for 
> it privately for a while, but didn't push it upstream because paravirt 
> broke it royally and I wanted the situation to settle down.)
> 
> It's broken, because the algorithm used to determine valid CPUID levels 
> is incorrect; it fails to recognize any CPUID levels other than the main 
> Intel and AMD ones, e.g. the Transmeta 0x8086xxxx (and sometimes more) 
> and VIA 0xc000xxxx levels.
Thank you for pointing out these issues, i think we can let users input
any cpuid level and output the corresponding cpuid, in this way we can
avoid to consider cpu differences and left this to userspace. We can
also consider all the x86 platforms to do cpuid for every one.

> 
> It's broken, because it is better for the userspace extractor to have 
> this logic than to stuff it into the kernel, where it sits hogging 
> unswappable memory at all times.
It seems not to be very appropriate to let user space consider hardware
details. /proc/cpuinfo should be an example to justify this.

Is there any user application using /dev/cpu/*/cpuid? if no, i think it
is feasible to provide an interface in the kernel.

I noticed an application cpu-z on Windows, maybe we can clone it on
Linux.
> 
> 	-hpa

