Return-Path: <linux-kernel-owner+w=401wt.eu-S1754930AbYCQBIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930AbYCQBIg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 21:08:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751594AbYCQBI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 21:08:27 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:42810 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbYCQBI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 21:08:26 -0400
Date: Sun, 16 Mar 2008 18:08:22 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: rostedt@goodmis.org, linux-rt-users@vger.kernel.org, mingo@elte.hu,
       ego@in.ibm.com, dipankar@in.ibm.com, tytso@us.ibm.com,
       dvhltc@us.ibm.com, oleg@tv-sign.ru, akpm@linux-foundation.org,
       josh@freedesktop.org, tglx@linutronix.de, niv@us.ibm.com
Subject: [PATCH] fix misplaced mb() in rcu_enter/exit_nohz()
Message-ID: <20080317010821.GA29875@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

In the process of writing up the mechanical proof of correctness for the
dynticks/preemptable-RCU interface, I noticed misplaced memory barriers
in rcu_enter_nohz() and rcu_exit_nohz().  This patch puts them in the
right place and adds a comment.  The key thing to keep in mind is that
rcu_enter_nohz() is -exiting- the mode that can legally execute RCU
read-side critical sections.  The memory barrier must be between any
potential RCU read-side critical sections and the increment of the per-CPU
dynticks_progress_counter, and thus must come -before- this increment.
And vice versa for rcu_exit_nohz().

The locking in the scheduler is probably saving us for the moment.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 rcupreempt.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -urpNa -X dontdiff linux-2.6.25-rc6/include/linux/rcupreempt.h linux-2.6.25-rc6-rcu_nohz-fix/include/linux/rcupreempt.h
--- linux-2.6.25-rc6/include/linux/rcupreempt.h	2008-03-16 17:45:16.000000000 -0700
+++ linux-2.6.25-rc6-rcu_nohz-fix/include/linux/rcupreempt.h	2008-03-16 17:59:24.000000000 -0700
@@ -87,15 +87,15 @@ DECLARE_PER_CPU(long, dynticks_progress_
 
 static inline void rcu_enter_nohz(void)
 {
+	mb(); /* CPUs seeing ++ must see prior RCU read-side crit sects */
 	__get_cpu_var(dynticks_progress_counter)++;
 	WARN_ON(__get_cpu_var(dynticks_progress_counter) & 0x1);
-	mb();
 }
 
 static inline void rcu_exit_nohz(void)
 {
-	mb();
 	__get_cpu_var(dynticks_progress_counter)++;
+	mb(); /* CPUs seeing ++ must see subsequent RCU read-side crit sects */
 	WARN_ON(!(__get_cpu_var(dynticks_progress_counter) & 0x1));
 }
 
