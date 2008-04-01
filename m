Return-Path: <linux-kernel-owner+w=401wt.eu-S1758563AbYDAL1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758563AbYDAL1R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 07:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756710AbYDAL1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 07:27:05 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:60762 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756676AbYDAL1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 07:27:04 -0400
Message-ID: <47F21BE3.5030705@jp.fujitsu.com>
Date: Tue, 01 Apr 2008 20:26:27 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] Customize sched domain via cpuset
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Using cpuset, now we can partition the system into multiple sched domains.
Then, how about providing different characteristics for each domains?

This patch introduces new feature of cpuset - sched domain customization.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>

---
 Documentation/cpusets.txt |   89 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 87 insertions(+), 2 deletions(-)

Index: GIT-torvalds/Documentation/cpusets.txt
===================================================================
--- GIT-torvalds.orig/Documentation/cpusets.txt
+++ GIT-torvalds/Documentation/cpusets.txt
@@ -8,6 +8,7 @@ Portions Copyright (c) 2004-2006 Silicon
 Modified by Paul Jackson <pj@sgi.com>
 Modified by Christoph Lameter <clameter@sgi.com>
 Modified by Paul Menage <menage@google.com>
+Modified by Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>

 CONTENTS:
 =========
@@ -20,7 +21,8 @@ CONTENTS:
   1.5 What is memory_pressure ?
   1.6 What is memory spread ?
   1.7 What is sched_load_balance ?
-  1.8 How do I use cpusets ?
+  1.8 What are other sched_* files ?
+  1.9 How do I use cpusets ?
 2. Usage Examples and Syntax
   2.1 Basic Usage
   2.2 Adding/removing cpus
@@ -497,7 +499,90 @@ the cpuset code to update these sched do
 partition requested with the current, and updates its sched domains,
 removing the old and adding the new, for each change.

-1.8 How do I use cpusets ?
+1.8 What are other sched_* files ?
+----------------------------------
+
+As described in 1.7, cpuset allows you to partition the systems CPUs
+into a number of sched domains.  Each sched domain is load balanced
+independently, in a traditional way that designed to be good for
+usual systems.
+
+But you may want to customize the behavior of load balancing for your
+special system.  For this requirement, cpuset provides some files named
+sched_* to customize the sched domain of the cpuset for some special
+situation, i.e. some specific application on some special system.
+
+These files are per-cpuset and affect the sched domain where the
+cpuset belongs to.  If multiple cpusets are overlapping and hence they
+form a single sched domain, changes in one of them affect others.
+If flag "sched_load_balance" of a cpuset is disabled, sched_* files
+have no effect since there is no sched domain belonging the cpuset.
+
+Note that modifying sched_* files will have both good and bad effects,
+and whether it is acceptable or not will be depend on your situation.
+Don't modify these files if you are not sure the effect.
+
+1.8.1 What is sched_wake_idle_far ?
+-----------------------------------
+
+When a task is woken up, scheduler try to wake up the task on idle CPU.
+
+For example, if a task A running on CPU X activates another task B
+on the same CPU X, and if CPU Y is X's sibling and performing idle,
+then scheduler migrate task B to CPU Y so that task B can start
+on CPU Y without waiting task A on CPU X.
+
+However scheduler doesn't search whole system, just searches nearby
+siblings at default.  Assume CPU Z is relatively far from CPU X.
+Even if CPU Z is idle while CPU X and the siblings are busy, scheduler
+can't migrate woken task B from X to Z.  As the result, task B on CPU X
+need to wait task A or wait load balance on the next tick.  For some
+special applications, waiting 1 tick is too long.
+
+The main reason why scheduler limits the range of searching idle CPU
+so small such as "siblings in the socket" is because it saves
+searching cost and migration cost.  Nowadays there are shared
+resources between siblings - CPU caches and so on, so this limit can
+save some migration cost assuming that the resources contain enough
+not-expired stuff for migrating task.  Usually this assumption will
+work, but not guaranteed.
+
+When the flag 'sched_wake_idle_far' is enabled, this searching range
+is expanded to all CPUs in the sched domain of the cpuset.
+
+If this flag was enabled on the example of CPU Z given above,
+scheduler can find CPU Z by taking some extra searching cost, and
+migrate task B to CPU Z by taking some extra migration cost.
+In exchange of these costs, you can start task B relatively fast.
+
+If your situation is:
+ - The migration costs between each cpu can be assumed considerably
+   small(for you) due to your special application's behavior or
+   special hardware support for CPU cache etc.
+ - The searching cost doesn't have impact(for you) or you can make
+   the searching cost enough small by managing cpuset to compact etc.
+ - The latency is required even it sacrifices cache hit rate etc.
+then turning on 'sched_wake_idle_far' would benefit you.
+
+1.8.2 What is sched_balance_newidle_far ?
+-----------------------------------------
+
+If a CPU run out of tasks in its runqueue, the CPU try to pull extra
+tasks from other busy CPUs to help them before it is going to be idle.
+
+Of course it takes some searching cost to find movable tasks,
+scheduler might not search all CPUs in the system.  For example,
+the range is limited in the same socket or node where the CPU locates.
+
+When the flag 'sched_balance_newidle_far' is enabled, this range
+is expanded to all CPUs in the sched domain of the cpuset.
+
+The assumed situation where this flag is considerable is almost same
+as that of 'sched_wake_idle_far'.  If you would like to trade better
+latency and high operating ratio in return of some other benefits,
+then enable this flag.
+
+1.9 How do I use cpusets ?
 --------------------------

 In order to minimize the impact of cpusets on critical kernel
