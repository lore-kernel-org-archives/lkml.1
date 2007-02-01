Return-Path: <linux-kernel-owner+w=401wt.eu-S1422950AbXBATNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422950AbXBATNs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 14:13:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422952AbXBATNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 14:13:48 -0500
Received: from omx1-ext.sgi.com ([192.48.179.11]:58549 "EHLO omx1.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1422950AbXBATNr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 14:13:47 -0500
Date: Thu, 1 Feb 2007 11:13:29 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: akpm@osdl.org
cc: Oleg Nesterov <oleg@tv-sign.ru>, linux-kernel@vger.kernel.org
Subject: [SLAB] Shutdown cache_reaper when cpu goes down
Message-ID: <Pine.LNX.4.64.0702011111560.8307@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Shutdown the cache_reaper if the cpu is brought down and set the 
cache_reap.func to NULL. Otherwise hotplug shuts down the reaper for good.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

Index: linux-2.6.20-rc6-mm2/mm/slab.c
===================================================================
--- linux-2.6.20-rc6-mm2.orig/mm/slab.c	2007-01-29 14:27:34.199229828 -0600
+++ linux-2.6.20-rc6-mm2/mm/slab.c	2007-01-30 13:55:57.936838878 -0600
@@ -1271,6 +1271,18 @@ static int __cpuinit cpuup_callback(stru
 		start_cpu_timer(cpu);
 		break;
 #ifdef CONFIG_HOTPLUG_CPU
+  	case CPU_DOWN_PREPARE:
+		/*
+		 * Shutdown cache reaper. Note that the cache_chain_mutex is
+		 * held so that cache_reap() cannot modify reap_work
+		 * concurrently.
+		*/
+		cancel_rearming_delayed_work(&per_cpu(reap_work, cpu));
+		per_cpu(reap_work, cpu).work.func = NULL;
+  		break;
+  	case CPU_DOWN_FAILED:
+		start_cpu_timer(cpu);
+  		break;
 	case CPU_DEAD:
 		/*
 		 * Even if all the cpus of a node are down, we don't free the
