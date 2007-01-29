Return-Path: <linux-kernel-owner+w=401wt.eu-S1752579AbXA2UaH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579AbXA2UaH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 15:30:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752588AbXA2UaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 15:30:07 -0500
Received: from omx2-ext.sgi.com ([192.48.171.19]:43775 "EHLO omx2.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752579AbXA2UaF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 15:30:05 -0500
Date: Mon, 29 Jan 2007 12:29:15 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
cc: Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Gautham shenoy <ego@in.ibm.com>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: slab: start_cpu_timer/cache_reap CONFIG_HOTPLUG_CPU problems
In-Reply-To: <20070129194938.GB233@tv-sign.ru>
Message-ID: <Pine.LNX.4.64.0701291224340.32740@schroedinger.engr.sgi.com>
References: <20070129011301.GA844@tv-sign.ru>
 <Pine.LNX.4.64.0701290852390.28200@schroedinger.engr.sgi.com>
 <20070129171923.GA138@tv-sign.ru> <Pine.LNX.4.64.0701290922390.28330@schroedinger.engr.sgi.com>
 <20070129182742.GA158@tv-sign.ru> <Pine.LNX.4.64.0701291109310.29254@schroedinger.engr.sgi.com>
 <20070129194938.GB233@tv-sign.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jan 2007, Oleg Nesterov wrote:

> > But we could delay CPU_DOWN in the handler for the slab until we know that 
> > the cache_reaper is no longer running?
> 
> Hmm... I don't undestand this. We can delay CPU_DOWN if we cancel cache_reaper
> like you did in the previous patch. Did you mean this? If yes - then yes :)

Yes sure.

> Worse, we can have 2 handlers running in parallel on the same CPU. But this
> is fixed by your previous patch, I believe.

Good.

Here is the patch against 2.6.20-rc6-mm2. CPU_DOWN_PREPARE and
CPU_DOWN_FAILED somehow vanished in mm?





Shutdown cache_reaper when cpu goes down

Shutdown the cache_reaper in slab.c if the cpu is brought down
and set the cache_reap.func to NULL. Otherwise hotplug shuts
down the reaper for good.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

Index: linux-2.6.20-rc6-mm1/mm/slab.c
===================================================================
--- linux-2.6.20-rc6-mm1.orig/mm/slab.c	2007-01-29 14:18:37.000000000 -0600
+++ linux-2.6.20-rc6-mm1/mm/slab.c	2007-01-29 14:21:18.119155877 -0600
@@ -1271,6 +1271,17 @@ static int __cpuinit cpuup_callback(stru
 		start_cpu_timer(cpu);
 		break;
 #ifdef CONFIG_HOTPLUG_CPU
+  	case CPU_DOWN_PREPARE:
+		/* Shutdown cache reaper */
+		cancel_rearming_delayed_work(&per_cpu(reap_work, cpu));
+		per_cpu(reap_work, cpu).work.func = NULL;
+
+  		mutex_lock(&cache_chain_mutex);
+  		break;
+  	case CPU_DOWN_FAILED:
+  		mutex_unlock(&cache_chain_mutex);
+		start_cpu_timer(cpu);
+  		break;
 	case CPU_DEAD:
 		/*
 		 * Even if all the cpus of a node are down, we don't free the
