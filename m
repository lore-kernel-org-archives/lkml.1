Return-Path: <linux-kernel-owner+w=401wt.eu-S932978AbZAPLES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932978AbZAPLES (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 06:04:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755324AbZAPLEB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 06:04:01 -0500
Received: from mga03.intel.com ([143.182.124.21]:62946 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134AbZAPLD6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 06:03:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,276,1231142400"; 
   d="scan'208";a="100685824"
Date: Fri, 16 Jan 2009 12:03:54 +0100
From: Markus Metzger <markus.t.metzger@intel.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com,
       srostedt@redhat.com
Subject: [patch 5/5] x86, ftrace, hw-branch-tracer: documentation
Message-ID: <20090116120354.A30366@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document the hw-branch-tracer in the ftrace documentation.

Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: ftrace/Documentation/ftrace.txt
===================================================================
--- ftrace.orig/Documentation/ftrace.txt	2008-12-11 11:23:48.000000000 +0100
+++ ftrace/Documentation/ftrace.txt	2009-01-16 10:58:07.000000000 +0100
@@ -165,6 +165,8 @@
   nop - This is not a tracer. To remove all tracers from tracing
 		simply echo "nop" into current_tracer.
 
+  hw-branch-tracer - traces branches on all cpu's in a circular buffer.
+
 
 Examples of using the tracer
 ----------------------------
@@ -1152,6 +1154,78 @@
         return 0;
 }
 
+
+hw-branch-tracer (x86 only)
+---------------------------
+
+This tracer uses the x86 last branch tracing hardware feature to
+collect a branch trace on all cpus with relatively low overhead.
+
+The tracer uses a fixed-size circular buffer per cpu and only
+traces ring 0 branches. The trace file dumps that buffer in the
+following format:
+
+# tracer: hw-branch-tracer
+#
+# CPU#        TO  <-  FROM
+   0  scheduler_tick+0xb5/0x1bf	  <-  task_tick_idle+0x5/0x6
+   2  run_posix_cpu_timers+0x2b/0x72a	  <-  run_posix_cpu_timers+0x25/0x72a
+   0  scheduler_tick+0x139/0x1bf	  <-  scheduler_tick+0xed/0x1bf
+   0  scheduler_tick+0x17c/0x1bf	  <-  scheduler_tick+0x148/0x1bf
+   2  run_posix_cpu_timers+0x9e/0x72a	  <-  run_posix_cpu_timers+0x5e/0x72a
+   0  scheduler_tick+0x1b6/0x1bf	  <-  scheduler_tick+0x1aa/0x1bf
+
+
+The tracer may be used to dump the trace for the oops'ing cpu on a
+kernel oops into the system log. To enable this, ftrace_dump_on_oops
+must be set. To set ftrace_dump_on_oops, one can either use the sysctl
+function or set it via the proc system interface.
+
+  sysctl kernel.ftrace_dump_on_oops=1
+
+or
+
+  echo 1 > /proc/sys/kernel/ftrace_dump_on_oops
+
+
+Here's an example of such a dump after a null pointer dereference in a
+kernel module:
+
+[57848.105921] BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
+[57848.106019] IP: [<ffffffffa0000006>] open+0x6/0x14 [oops]
+[57848.106019] PGD 2354e9067 PUD 2375e7067 PMD 0
+[57848.106019] Oops: 0002 [#1] SMP
+[57848.106019] last sysfs file: /sys/devices/pci0000:00/0000:00:1e.0/0000:20:05.0/local_cpus
+[57848.106019] Dumping ftrace buffer:
+[57848.106019] ---------------------------------
+[...]
+[57848.106019]    0  chrdev_open+0xe6/0x165	  <-  cdev_put+0x23/0x24
+[57848.106019]    0  chrdev_open+0x117/0x165	  <-  chrdev_open+0xfa/0x165
+[57848.106019]    0  chrdev_open+0x120/0x165	  <-  chrdev_open+0x11c/0x165
+[57848.106019]    0  chrdev_open+0x134/0x165	  <-  chrdev_open+0x12b/0x165
+[57848.106019]    0  open+0x0/0x14 [oops]	  <-  chrdev_open+0x144/0x165
+[57848.106019]    0  page_fault+0x0/0x30	  <-  open+0x6/0x14 [oops]
+[57848.106019]    0  error_entry+0x0/0x5b	  <-  page_fault+0x4/0x30
+[57848.106019]    0  error_kernelspace+0x0/0x31	  <-  error_entry+0x59/0x5b
+[57848.106019]    0  error_sti+0x0/0x1	  <-  error_kernelspace+0x2d/0x31
+[57848.106019]    0  page_fault+0x9/0x30	  <-  error_sti+0x0/0x1
+[57848.106019]    0  do_page_fault+0x0/0x881	  <-  page_fault+0x1a/0x30
+[...]
+[57848.106019]    0  do_page_fault+0x66b/0x881	  <-  is_prefetch+0x1ee/0x1f2
+[57848.106019]    0  do_page_fault+0x6e0/0x881	  <-  do_page_fault+0x67a/0x881
+[57848.106019]    0  oops_begin+0x0/0x96	  <-  do_page_fault+0x6e0/0x881
+[57848.106019]    0  trace_hw_branch_oops+0x0/0x2d	  <-  oops_begin+0x9/0x96
+[...]
+[57848.106019]    0  ds_suspend_bts+0x2a/0xe3	  <-  ds_suspend_bts+0x1a/0xe3
+[57848.106019] ---------------------------------
+[57848.106019] CPU 0
+[57848.106019] Modules linked in: oops
+[57848.106019] Pid: 5542, comm: cat Tainted: G        W  2.6.28 #23
+[57848.106019] RIP: 0010:[<ffffffffa0000006>]  [<ffffffffa0000006>] open+0x6/0x14 [oops]
+[57848.106019] RSP: 0018:ffff880235457d48  EFLAGS: 00010246
+[...]
+
+
 dynamic ftrace
 --------------
 
---------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen Germany
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 Ust.-IdNr.
VAT Registration No.: DE129385895
Citibank Frankfurt (BLZ 502 109 00) 600119052

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

