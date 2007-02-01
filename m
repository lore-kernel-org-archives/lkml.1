Return-Path: <linux-kernel-owner+w=401wt.eu-S1422734AbXBAXTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422734AbXBAXTs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 18:19:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422837AbXBAXTs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 18:19:48 -0500
Received: from omx2-ext.sgi.com ([192.48.171.19]:36562 "EHLO omx2.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1422734AbXBAXTr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 18:19:47 -0500
Date: Thu, 1 Feb 2007 15:19:33 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: akpm@osdl.org
cc: Oleg Nesterov <oleg@tv-sign.ru>, linux-kernel@vger.kernel.org
Subject: Re: [SLAB] Shutdown cache_reaper when cpu goes down
In-Reply-To: <Pine.LNX.4.64.0702011111560.8307@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0702011517110.9210@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0702011111560.8307@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The comments do not explain correctly what is going on. Sorry Oleg but it 
seems that the protection of the assignment to reap_work is different that 
what we initially thought.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

Index: current/mm/slab.c
===================================================================
--- current.orig/mm/slab.c	2007-02-01 15:07:09.000000000 -0800
+++ current/mm/slab.c	2007-02-01 15:09:21.000000000 -0800
@@ -1274,10 +1274,12 @@ static int __cpuinit cpuup_callback(stru
   	case CPU_DOWN_PREPARE:
 		/*
 		 * Shutdown cache reaper. Note that the cache_chain_mutex is
-		 * held so that cache_reap() cannot modify reap_work
-		 * concurrently.
+		 * held so that if cache_reap() is invoked it cannot do
+		 * anything expensive but will only modify reap_work
+		 * and reschedule the timer.
 		*/
 		cancel_rearming_delayed_work(&per_cpu(reap_work, cpu));
+		/* Now the cache_reaper is guaranteed to be not running. */
 		per_cpu(reap_work, cpu).work.func = NULL;
   		break;
   	case CPU_DOWN_FAILED:
