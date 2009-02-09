Return-Path: <linux-kernel-owner+w=401wt.eu-S1756872AbZBITVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872AbZBITVx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 14:21:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754059AbZBITVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 14:21:39 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:51912 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928AbZBITVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 14:21:38 -0500
Date: Mon, 9 Feb 2009 19:20:50 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Lennert Buytenhek <buytenh@wantstofly.org>
cc: Rusty Russell <rusty@rustcorp.com.au>, Rafael Wysocki <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org
Subject: Re: /proc/profile broken on UP machines in 2.6.29-rc3
In-Reply-To: <20090209145058.GY13433@xi.wantstofly.org>
Message-ID: <Pine.LNX.4.64.0902091906440.5718@blonde.anvils>
References: <20090209145058.GY13433@xi.wantstofly.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Feb 2009, Lennert Buytenhek wrote:

> I'm about 130k emails behind on my linux-kernel@ subscription, so I'm
> not entirely sure whether this has been reported, but it seems that
> profiling is broken on !CONFIG_SMP builds in 2.6.29-rc3.

Yes, and CONFIG_SMP builds, and 2.6.29-rc4.

> It appears that since this commit:
> 
> 	commit c309b917cab55799ea489d7b5f1b77025d9f8462
> 	Author: Rusty Russell <rusty@rustcorp.com.au>
> 	Date:   Thu Jan 1 10:12:27 2009 +1030
> 
> 	    cpumask: convert kernel/profile.c
> 
> there's no longer anything that sets any bits in prof_cpu_mask on
> UP systems at all (the default was to assign CPU_MASK_ALL, and
> profile_cpu_callback() which clears/sets bits at run time is only
> built and registered on SMP builds), so the cpumask_test_cpu()
> test in profile_tick() always fails, and no samples are ever counted.

I guess if you cpu down and up, or suspend and resume, that will get
aux cpus profiling in the SMP case, but basically SMP is as broken as
UP.  I noticed yesterday, took a look earlier today, here's the patch
which gets it working for me:


[PATCH] fix broken profiling regression

Commit c309b917cab55799ea489d7b5f1b77025d9f8462 "cpumask: convert
kernel/profile.c" broke profiling.  prof_cpu_mask was previously
initialized to CPU_MASK_ALL, but left uninitialized in that commit.
We need to copy cpu_possible_mask (cpu_online_mask is not enough).

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---

 kernel/profile.c |    3 +++
 1 file changed, 3 insertions(+)

--- 2.6.29-rc4/kernel/profile.c	2009-01-11 01:33:38.000000000 +0000
+++ linux/kernel/profile.c	2009-02-09 15:23:34.000000000 +0000
@@ -114,12 +114,15 @@ int __ref profile_init(void)
 	if (!slab_is_available()) {
 		prof_buffer = alloc_bootmem(buffer_bytes);
 		alloc_bootmem_cpumask_var(&prof_cpu_mask);
+		cpumask_copy(prof_cpu_mask, cpu_possible_mask);
 		return 0;
 	}
 
 	if (!alloc_cpumask_var(&prof_cpu_mask, GFP_KERNEL))
 		return -ENOMEM;
 
+	cpumask_copy(prof_cpu_mask, cpu_possible_mask);
+
 	prof_buffer = kzalloc(buffer_bytes, GFP_KERNEL);
 	if (prof_buffer)
 		return 0;
