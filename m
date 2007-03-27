Return-Path: <linux-kernel-owner+w=401wt.eu-S933907AbXC0RTO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933907AbXC0RTO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 13:19:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933980AbXC0RTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 13:19:14 -0400
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:51703 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933907AbXC0RTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 13:19:12 -0400
Subject: [PATCH -rt] fix setting of preempt_max_latency and preempt_thresh
	on 64 bit systems
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 27 Mar 2007 13:19:07 -0400
Message-Id: <1175015947.19634.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

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


