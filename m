Return-Path: <linux-kernel-owner+w=401wt.eu-S934198AbXC0TWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934198AbXC0TWp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 15:22:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934197AbXC0TWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 15:22:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44690 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934198AbXC0TWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 15:22:44 -0400
Date: Tue, 27 Mar 2007 21:22:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Early hang with 2.6.21-rc4-rt1
Message-ID: <20070327192230.GA31695@elte.hu>
References: <adad52xnccs.fsf@cisco.com> <20070325073146.GB10734@elte.hu> <ada4po9mlw5.fsf@cisco.com> <adavegpl0jd.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adavegpl0jd.fsf@cisco.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Roland Dreier <rdreier@cisco.com> wrote:

> Any suggestion of where to look?  My /proc/latency_trace stays 
> stubbornly empty -- are there any sysctls I need to change from their 
> default to get latency tracing?  I'm a complete noob when it comes to 
> the -rt patch, so I'm not sure what the right way to use the tracing 
> infrastructure to track down this lost rtc interrupts issue is.

please apply the patch below, from Steve - this should fix the tracer.

	Ingo

---------------------->
Ingo,

I wasn't able to turn on latency tracing on a x86_64 box. Using logdev
to see what was happening, I found that echoing 0
into /proc/sys/kernel/preempt_max_latency would only change the max from
-1ULL to 0xffffffff00000000. Which would keep the max pretty high still.

The problem is in sysctl.c where preempt_max_latency can be modified. On
systems where cycle_t is greater than the size of int (x86_64) we only
write to the 4 LSB.

Here's the patch:

-- Steve

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-2.6.21-rc5/kernel/sysctl.c
===================================================================
--- linux-2.6.21-rc5.orig/kernel/sysctl.c
+++ linux-2.6.21-rc5/kernel/sysctl.c
@@ -287,17 +287,17 @@ static ctl_table kern_table[] = {
 		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "preempt_max_latency",
 		.data		= &preempt_max_latency,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(preempt_max_latency),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= &proc_doulongvec_minmax,
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "preempt_thresh",
 		.data		= &preempt_thresh,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(preempt_thresh),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= &proc_doulongvec_minmax,
 	},
 #endif
 #ifdef CONFIG_EVENT_TRACE

