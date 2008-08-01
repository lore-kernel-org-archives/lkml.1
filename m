Return-Path: <linux-kernel-owner+w=401wt.eu-S1761762AbYHAVO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761762AbYHAVO0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 17:14:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760903AbYHAVKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 17:10:12 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:48995 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760899AbYHAVKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 17:10:07 -0400
Date: Fri, 1 Aug 2008 14:10:02 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, rostedt@goodmis.org, akpm@linux-foundation.org,
       ego@in.ibm.com, dvhltc@us.ibm.com, niv@us.ibm.com
Subject: [PATCH -tip/core/rcu] fixes to include/linux/rcupreempt.h
Message-ID: <20080801211002.GM14851@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

Compared tip/core/rcu to my latest patchset, and found the following
issues:

o	the memory barrier in rcu_exit_nohz() somehow got out of place
	(it is correct in mainline as of 2.6.26-rc7).

o	There is a duplicate declaration of rcu_dyntick_sched.

The attached patch fixes these.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

diff --git a/include/linux/rcupreempt.h b/include/linux/rcupreempt.h
index f04b64e..84678bf 100644
--- a/include/linux/rcupreempt.h
+++ b/include/linux/rcupreempt.h
@@ -111,7 +111,6 @@ extern struct rcupreempt_trace *rcupreempt_trace_cpu(int cpu);
 struct softirq_action;
 
 #ifdef CONFIG_NO_HZ
-DECLARE_PER_CPU(struct rcu_dyntick_sched, rcu_dyntick_sched);
 
 static inline void rcu_enter_nohz(void)
 {
@@ -122,8 +121,8 @@ static inline void rcu_enter_nohz(void)
 
 static inline void rcu_exit_nohz(void)
 {
-	smp_mb(); /* CPUs seeing ++ must see later RCU read-side crit sects */
 	__get_cpu_var(rcu_dyntick_sched).dynticks++;
+	smp_mb(); /* CPUs seeing ++ must see later RCU read-side crit sects */
 	WARN_ON(!(__get_cpu_var(rcu_dyntick_sched).dynticks & 0x1));
 }
 
