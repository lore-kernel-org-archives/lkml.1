Return-Path: <linux-kernel-owner+w=401wt.eu-S1752552AbXA2TKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552AbXA2TKS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 14:10:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752554AbXA2TKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 14:10:18 -0500
Received: from omx2-ext.sgi.com ([192.48.171.19]:40408 "EHLO omx2.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752552AbXA2TKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 14:10:17 -0500
Date: Mon, 29 Jan 2007 11:09:21 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
cc: Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Gautham shenoy <ego@in.ibm.com>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: slab: start_cpu_timer/cache_reap CONFIG_HOTPLUG_CPU problems
In-Reply-To: <20070129182742.GA158@tv-sign.ru>
Message-ID: <Pine.LNX.4.64.0701291102240.29254@schroedinger.engr.sgi.com>
References: <20070129011301.GA844@tv-sign.ru>
 <Pine.LNX.4.64.0701290852390.28200@schroedinger.engr.sgi.com>
 <20070129171923.GA138@tv-sign.ru> <Pine.LNX.4.64.0701290922390.28330@schroedinger.engr.sgi.com>
 <20070129182742.GA158@tv-sign.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jan 2007, Oleg Nesterov wrote:

> >                                      The slab would need a notification 
> > that the workqueue for a processor was shutdown in order to set work.func 
> > = NULL.
> 
> The slab has a notification: CPU_XXX events. It should cancel a pending per
> cpu "reap_work timer".

Ahh. Okay then the following patch would fix it?

Shutdown cache_reaper when cpu goes down

Shutdown the cache_reaper in slab.c if the cpu is brought down
and set the cache_reap.func to NULL. Otherwise hotplug shuts
down the reaper for good.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

Index: linux-2.6.20-rc6/mm/slab.c
===================================================================
--- linux-2.6.20-rc6.orig/mm/slab.c	2007-01-24 20:19:28.000000000 -0600
+++ linux-2.6.20-rc6/mm/slab.c	2007-01-29 13:08:05.773928988 -0600
@@ -1269,6 +1269,10 @@ static int __cpuinit cpuup_callback(stru
 		break;
 #ifdef CONFIG_HOTPLUG_CPU
 	case CPU_DOWN_PREPARE:
+		/* Shutdown cache reaper */
+		cancel_rearming_delayed_work(&per_cpu(reap_work, cpu));
+		per_cpu(reap_work, cpu).work.func = NULL;
+
 		mutex_lock(&cache_chain_mutex);
 		break;
 	case CPU_DOWN_FAILED:
