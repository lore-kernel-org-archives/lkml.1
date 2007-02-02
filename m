Return-Path: <linux-kernel-owner+w=401wt.eu-S1423041AbXBBAgD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423041AbXBBAgD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 19:36:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423040AbXBBAgB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 19:36:01 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:35371 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423035AbXBBAf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 19:35:58 -0500
Date: Thu, 1 Feb 2007 16:35:50 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Subject: Fw: [patch] posix timers: RCU optimization for clock_gettime()
Message-ID: <20070202003550.GA17012@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The attached patch uses RCU to avoid the need to acquire tasklist_lock
in the single-threaded case of clock_gettime().  It still acquires
tasklist_lock when for a (potentially multithreaded) process.  This change
allows realtime applications to frequently monitor CPU consumption of
individual tasks, as requested (and now deployed) by some off-list users.

This has been in Ingo Molnar's -rt patchset since late 2005 with no
problems reported, and tests successfully on 2.6.20-rc6, so I believe
that it is long-since ready for mainline adoption.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---

 kernel/posix-cpu-timers.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: linux/kernel/posix-cpu-timers.c
===================================================================
--- linux.orig/kernel/posix-cpu-timers.c
+++ linux/kernel/posix-cpu-timers.c
@@ -304,7 +304,7 @@ int posix_cpu_clock_get(const clockid_t 
 		 * should be able to see it.
 		 */
 		struct task_struct *p;
-		read_lock(&tasklist_lock);
+		rcu_read_lock();
 		p = find_task_by_pid(pid);
 		if (p) {
 			if (CPUCLOCK_PERTHREAD(which_clock)) {
@@ -313,11 +313,13 @@ int posix_cpu_clock_get(const clockid_t 
 								 p, &rtn);
 				}
 			} else if (p->tgid == pid && p->signal) {
+				read_lock(&tasklist_lock);
 				error = cpu_clock_sample_group(which_clock,
 							       p, &rtn);
+				read_unlock(&tasklist_lock);
 			}
 		}
-		read_unlock(&tasklist_lock);
+		rcu_read_unlock();
 	}

 	if (error)

----- End forwarded message -----
