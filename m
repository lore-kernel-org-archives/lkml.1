Return-Path: <linux-kernel-owner+w=401wt.eu-S1758085AbYDDJLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758085AbYDDJLq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 05:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751851AbYDDJLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 05:11:36 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44113 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841AbYDDJLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 05:11:35 -0400
Message-ID: <47F5F099.20006@jp.fujitsu.com>
Date: Fri, 04 Apr 2008 18:10:49 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Paul Jackson <pj@sgi.com>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 1/2] Customize sched domain via cpuset (v2)
References: <47F21BE3.5030705@jp.fujitsu.com>
In-Reply-To: <47F21BE3.5030705@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here comes v2!

This patch introduces new feature of cpuset - sched domain customization.

This version provides a per-cpuset file 'sched_relax_domain_level' that
enable us to change the searching range of scheduler, which used to limit
how many cpus the scheduler searches at some schedule events, such as
wakening task and running out of runqueue.

Thanks,
H.Seto

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>

---
 Documentation/cpusets.txt |   72 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 70 insertions(+), 2 deletions(-)

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
+  1.8 What is sched_relax_domain_level ?
+  1.9 How do I use cpusets ?
 2. Usage Examples and Syntax
   2.1 Basic Usage
   2.2 Adding/removing cpus
@@ -497,7 +499,73 @@ the cpuset code to update these sched do
 partition requested with the current, and updates its sched domains,
 removing the old and adding the new, for each change.

-1.8 How do I use cpusets ?
+
+1.8 What is sched_relax_domain_level ?
+--------------------------------------
+
+In sched domain, the scheduler migrates tasks in 2 ways; periodic load
+balance on tick, and at time of some schedule events.
+
+When a task is woken up, scheduler try to move the task on idle CPU.
+For example, if a task A running on CPU X activates another task B
+on the same CPU X, and if CPU Y is X's sibling and performing idle,
+then scheduler migrate task B to CPU Y so that task B can start on
+CPU Y without waiting task A on CPU X.
+
+And if a CPU run out of tasks in its runqueue, the CPU try to pull
+extra tasks from other busy CPUs to help them before it is going to
+be idle.
+
+Of course it takes some searching cost to find movable tasks and/or
+idle CPUs, the scheduler might not search all CPUs in the domain
+everytime.  In fact, in some architectures, the searching ranges on
+events are limited in the same socket or node where the CPU locates,
+while the load balance on tick searches all.
+
+For example, assume CPU Z is relatively far from CPU X.  Even if CPU Z
+is idle while CPU X and the siblings are busy, scheduler can't migrate
+woken task B from X to Z since it is out of its searching range.
+As the result, task B on CPU X need to wait task A or wait load balance
+on the next tick.  For some applications in special situation, waiting
+1 tick may be too long.
+
+The 'sched_relax_domain_level' file allows you to request changing
+this searching range as you like.  This file takes int value which
+indicates size of searching range in levels ideally as follows,
+otherwise initial value -1 that indicates the cpuset has no request.
+
+  -1  : no request. use system default or follow request of others.
+   0  : no search.
+   1  : search siblings (hyperthreads in a core).
+   2  : search cores in a package.
+   3  : search cpus in a node [= system wide on non-NUMA system]
+ ( 4  : search nodes in a chunk of node [on NUMA system] )
+ ( 5~ : search system wide [on NUMA system])
+
+This file is per-cpuset and affect the sched domain where the cpuset
+belongs to.  Therefore if the flag 'sched_load_balance' of a cpuset
+is disabled, then 'sched_relax_domain_level' have no effect since
+there is no sched domain belonging the cpuset.
+
+If multiple cpusets are overlapping and hence they form a single sched
+domain, the largest value among those is used.  Be careful, if one
+requests 0 and others are -1 then 0 is used.
+
+Note that modifying this file will have both good and bad effects,
+and whether it is acceptable or not will be depend on your situation.
+Don't modify this file if you are not sure.
+
+If your situation is:
+ - The migration costs between each cpu can be assumed considerably
+   small(for you) due to your special application's behavior or
+   special hardware support for CPU cache etc.
+ - The searching cost doesn't have impact(for you) or you can make
+   the searching cost enough small by managing cpuset to compact etc.
+ - The latency is required even it sacrifices cache hit rate etc.
+then increasing 'sched_relax_domain_level' would benefit you.
+
+
+1.9 How do I use cpusets ?
 --------------------------

 In order to minimize the impact of cpusets on critical kernel
