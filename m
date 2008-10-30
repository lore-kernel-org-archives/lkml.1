Return-Path: <linux-kernel-owner+w=401wt.eu-S1756293AbYJ3T0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756293AbYJ3T0O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 15:26:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753641AbYJ3TYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 15:24:04 -0400
Received: from smtp-out.google.com ([216.239.45.13]:38444 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301AbYJ3TYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 15:24:02 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type;
	b=Da4FTmo1DNKrrUi7IQzEeFlSnboBrnsKxjKM+VmHQu4rGHu+3dju4aMOI+k9m7Deg
	tYgNl98V/mpuWvc8wynpg==
Date: Thu, 30 Oct 2008 12:23:16 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Christoph Lameter <cl@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       Peter Zijlstra <peterz@infradead.org>, Paul Menage <menage@google.com>,
       Derek Fults <dfults@sgi.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org
Subject: [patch 7/7] cpusets: update documentation for writeback throttling
In-Reply-To: <alpine.DEB.2.00.0810292337170.23858@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.0810300312110.18283@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0810292337170.23858@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update Documentation/cpusets.txt for per-cpuset writeback throttling.

Cc: Nick Piggin <npiggin@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Menage <menage@google.com>
Cc: Derek Fults <dfults@sgi.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
---
 Documentation/cpusets.txt          |   58 +++++++++++++++++++++++++++--------
 Documentation/filesystems/proc.txt |    6 ++++
 2 files changed, 50 insertions(+), 14 deletions(-)

diff --git a/Documentation/cpusets.txt b/Documentation/cpusets.txt
--- a/Documentation/cpusets.txt
+++ b/Documentation/cpusets.txt
@@ -14,15 +14,17 @@ CONTENTS:
 =========
 
 1. Cpusets
-  1.1 What are cpusets ?
-  1.2 Why are cpusets needed ?
-  1.3 How are cpusets implemented ?
-  1.4 What are exclusive cpusets ?
-  1.5 What is memory_pressure ?
-  1.6 What is memory spread ?
-  1.7 What is sched_load_balance ?
-  1.8 What is sched_relax_domain_level ?
-  1.9 How do I use cpusets ?
+  1.1  What are cpusets ?
+  1.2  Why are cpusets needed ?
+  1.3  How are cpusets implemented ?
+  1.4  What are exclusive cpusets ?
+  1.5  What is memory_pressure ?
+  1.6  What is memory spread ?
+  1.7  What is sched_load_balance ?
+  1.8  What is sched_relax_domain_level ?
+  1.9  What is dirty_background_ratio ?
+  1.10 What is dirty_ratio ?
+  1.11 How do I use cpusets ?
 2. Usage Examples and Syntax
   2.1 Basic Usage
   2.2 Adding/removing cpus
@@ -148,6 +150,8 @@ into the rest of the kernel, none in performance critical paths:
    Memory Nodes by what's allowed in that tasks cpuset.
  - in page_alloc.c, to restrict memory to allowed nodes.
  - in vmscan.c, to restrict page recovery to the current cpuset.
+ - in pdflush.c, to restrict pdflush's nodes of interest to those
+   of the current task's cpuset.
 
 You should mount the "cgroup" filesystem type in order to enable
 browsing and modifying the cpusets presently known to the kernel.  No
@@ -572,9 +576,34 @@ If your situation is:
 then increasing 'sched_relax_domain_level' would benefit you.
 
 
-1.9 How do I use cpusets ?
+1.9 What is dirty_background_ratio ?
+------------------------------------
+
+The per-cpuset percentage of dirtyable memory (free pages + mapped
+pages + file cache, not including locked or huge pages), the number of
+pages at which the pdflush background writeout daemon will start writing
+out dirtied data.
+
+The default value is /proc/sys/vm/dirty_background_ratio.  Set the
+cpuset's dirty_background_ratio to -1 to accept this system-wide
+default.
+
+
+1.10 What is dirty_ratio ?
 --------------------------
 
+The per-cpuset percentage of dirtyable memory (free pages + mapped
+pages + file cache, not including locked or huge pages), the number of
+pages at which a process generating disk writes will itself start
+writing out dirtied data.
+
+The default value is /proc/sys/vm/dirty_ratio.  Set the cpuset's
+dirty_ratio to -1 to accept this system-wide default.
+
+
+1.11 How do I use cpusets ?
+---------------------------
+
 In order to minimize the impact of cpusets on critical kernel
 code, such as the scheduler, and due to the fact that the kernel
 does not support one task updating the memory placement of another
@@ -716,10 +745,11 @@ Now you want to do something with this cpuset.
 
 In this directory you can find several files:
 # ls
-cpu_exclusive  memory_migrate      mems                      tasks
-cpus           memory_pressure     notify_on_release
-mem_exclusive  memory_spread_page  sched_load_balance
-mem_hardwall   memory_spread_slab  sched_relax_domain_level
+cpu_exclusive		mem_hardwall		mems
+cpus			memory_migrate		notify_on_release
+dirty_background_ratio	memory_pressure		sched_load_balance
+dirty_ratio		memory_spread_page	sched_relax_domain_level
+mem_exclusive		memory_spread_slab	tasks
 
 Reading them will give you information about the state of this cpuset:
 the CPUs and Memory Nodes it can use, the processes that are using
diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -1389,6 +1389,9 @@ pages + file cache, not including locked pages and HugePages), the number of
 pages at which the pdflush background writeback daemon will start writing out
 dirty data.
 
+This ratio can be superseded for memory belonging to a cpuset; see
+Documentation/cpusets.txt for more information.
+
 dirty_ratio
 -----------------
 
@@ -1397,6 +1400,9 @@ pages + file cache, not including locked pages and HugePages), the number of
 pages at which a process which is generating disk writes will itself start
 writing out dirty data.
 
+This ratio can be superseded for memory belonging to a cpuset; see
+Documentation/cpusets.txt for more information.
+
 dirty_writeback_centisecs
 -------------------------
 
