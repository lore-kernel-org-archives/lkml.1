Return-Path: <linux-kernel-owner+w=401wt.eu-S1755073AbZKKHV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073AbZKKHV2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 02:21:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754064AbZKKHV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 02:21:27 -0500
Received: from www.tglx.de ([62.245.132.106]:41349 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752673AbZKKHV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 02:21:26 -0500
Date: Wed, 11 Nov 2009 08:21:28 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jupyung Lee <jupyung@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH-rt 1/1] softirqs: add preempt_check_resched() in
 ksoftirqd()
In-Reply-To: <1257914122-9637-1-git-send-email-jupyung@gmail.com>
Message-ID: <alpine.LFD.2.00.0911110818300.2897@localhost.localdomain>
References: <1257914122-9637-1-git-send-email-jupyung@gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jupyung,

On Wed, 11 Nov 2009, Jupyung Lee wrote:

> In its current preempt-rt kernel, ksoftirq() includes a series of primitives
> related with kernel preemption and irq on/off, in the following order:
> 
> preempt_disable()		... (1)
> local_irq_disable()		... (2)
> __preempt_enable_no_resched()	... (3)
> local_irq_enable()		... (4)
> 
> A problem arises if a process is awakened between (1) and (2) because
> it is not given a chance to preempt the currently running process
> for a while since (4): since (4), the kernel is preemptible, but there
> is no explicit reschedule point.
> 
> A simple suggestion to resolve the problem is to add a reschedule point,
> preempt_check_resched(), just after (4).

Good catch. I applied it with a simple modification.

Thanks,

	tglx
---
commit ca0b4bfa5994856bbcf4227e29f9c73722efaef2
Author: Jupyung Lee <jupyung@gmail.com>

<snip>

--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -1033,10 +1033,10 @@ sleep_more:
 				goto sleep_more;
 			}
 			per_cpu(softirq_running, cpu) |= softirq_mask;
-			__preempt_enable_no_resched();
 			set_softirq_pending(local_softirq_pending() & ~softirq_mask);
 			local_bh_disable();
 			local_irq_enable();
+			preempt_enable();
 
 			h = &softirq_vec[data->nr];
 			if (h)
