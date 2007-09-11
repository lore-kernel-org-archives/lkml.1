Return-Path: <linux-kernel-owner+w=401wt.eu-S1763804AbXIKMDD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763804AbXIKMDD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 08:03:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763700AbXIKMCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 08:02:15 -0400
Received: from mx2.suse.de ([195.135.220.15]:37487 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763682AbXIKMCN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 08:02:13 -0400
From: Andi Kleen <ak@suse.de>
References: <20070911202.911586000@suse.de>
In-Reply-To: <20070911202.911586000@suse.de>
To: venkatesh.pallipadi@intel.com, ashok.raj@intel.com, akinobu.mita@gmail.com,
       torvalds@osdl.org, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH for 2.6.23] [2/3] x86_64: Prevent doing anything from cache_remove_dev() when info setup failed.
Message-Id: <20070911120211.1E25F14EEC@wotan.suse.de>
Date: Tue, 11 Sep 2007 14:02:11 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


AK: Removed the unlikelies because gcc heuristics default to unlikely for test
AK: == NULL and for negative returns.

Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Ashok Raj <ashok.raj@intel.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux/arch/i386/kernel/cpu/intel_cacheinfo.c
===================================================================
--- linux.orig/arch/i386/kernel/cpu/intel_cacheinfo.c
+++ linux/arch/i386/kernel/cpu/intel_cacheinfo.c
@@ -515,7 +515,7 @@ static int __cpuinit detect_cache_attrib
 
 	cpuid4_info[cpu] = kzalloc(
 	    sizeof(struct _cpuid4_info) * num_cache_leaves, GFP_KERNEL);
-	if (unlikely(cpuid4_info[cpu] == NULL))
+	if (cpuid4_info[cpu] == NULL)
 		return -ENOMEM;
 
 	oldmask = current->cpus_allowed;
@@ -748,6 +748,8 @@ static void __cpuinit cache_remove_dev(s
 	unsigned int cpu = sys_dev->id;
 	unsigned long i;
 
+	if (cpuid4_info[cpu] == NULL)
+		return;
 	for (i = 0; i < num_cache_leaves; i++) {
 		cache_remove_shared_cpu_map(cpu, i);
 		kobject_unregister(&(INDEX_KOBJECT_PTR(cpu,i)->kobj));
