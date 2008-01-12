Return-Path: <linux-kernel-owner+w=401wt.eu-S1763046AbYALB1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763046AbYALB1P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 20:27:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762427AbYALB0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 20:26:42 -0500
Received: from kanga.kvack.org ([66.96.29.28]:41708 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758579AbYALB0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 20:26:40 -0500
Date: Fri, 11 Jan 2008 20:26:26 -0500
From: Benjamin LaHaise <bcrl@kvack.org>
To: dipankar@in.ibm.com, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [PATCH/RFC] synchronize_rcu(): high latency on idle system
Message-ID: <20080112012626.GI28570@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello folks,

I'd like to put the patch below out for comments to see if folks think the 
approach is a valid fix to reduce the latency of synchronize_rcu().  The 
motivation is that an otherwise idle system takes about 3 ticks per network 
interface in unregister_netdev() due to multiple calls to synchronize_rcu(), 
which adds up to quite a few seconds for tearing down thousands of 
interfaces.  By flushing pending rcu callbacks in the idle loop, the system 
makes progress hundreds of times faster.  If this is indeed a sane thing to, 
it probably needs to be done for other architectures than x86.  And yes, the 
network stack shouldn't call synchronize_rcu() quite so much, but fixing that 
is a little more involved.

		-ben

diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 9663c2a..592f6e4 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -188,6 +188,9 @@ void cpu_idle(void)
 			rmb();
 			idle = pm_idle;
 
+			if (rcu_pending(cpu))
+				rcu_check_callbacks(cpu, 0);
+
 			if (!idle)
 				idle = default_idle;
 
