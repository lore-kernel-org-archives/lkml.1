Return-Path: <linux-kernel-owner+w=401wt.eu-S1753218AbZHILLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218AbZHILLv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 07:11:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752581AbZHILLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 07:11:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:43897 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998AbZHILLp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 07:11:45 -0400
Date: Sun, 9 Aug 2009 11:11:09 GMT
From: "tip-bot for Carlos R. Mafra" <crmafra2@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, crmafra2@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, crmafra2@gmail.com,
       mingo@elte.hu
In-Reply-To: <20090805185334.GA4535@Pilar.aei.mpg.de>
References: <20090805185334.GA4535@Pilar.aei.mpg.de>
Subject: [tip:perfcounters/core] perf: "Longum est iter per praecepta, breve et efficax per exempla"
Message-ID: <tip-c24b513337f06712b8c81eb4f1413d44591dfee7@git.kernel.org>
Git-Commit-ID: c24b513337f06712b8c81eb4f1413d44591dfee7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 09 Aug 2009 11:11:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c24b513337f06712b8c81eb4f1413d44591dfee7
Gitweb:     http://git.kernel.org/tip/c24b513337f06712b8c81eb4f1413d44591dfee7
Author:     Carlos R. Mafra <crmafra2@gmail.com>
AuthorDate: Wed, 5 Aug 2009 20:53:34 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 9 Aug 2009 12:54:46 +0200

perf: "Longum est iter per praecepta, breve et efficax per exempla"

A few examples of how 'perf' can be used, from an e-mail by
Ingo Molnar http://lkml.org/lkml/2009/8/4/346.

Signed-off-by: Carlos R. Mafra <crmafra2@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Valdis.Kletnieks@vt.edu
LKML-Reference: <20090805185334.GA4535@Pilar.aei.mpg.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/Documentation/perf-examples.txt |  225 ++++++++++++++++++++++++++++
 1 files changed, 225 insertions(+), 0 deletions(-)

diff --git a/tools/perf/Documentation/perf-examples.txt b/tools/perf/Documentation/perf-examples.txt
new file mode 100644
index 0000000..8eb6c48
--- /dev/null
+++ b/tools/perf/Documentation/perf-examples.txt
@@ -0,0 +1,225 @@
+
+		------------------------------
+		****** perf by examples ******
+		------------------------------
+
+[ From an e-mail by Ingo Molnar, http://lkml.org/lkml/2009/8/4/346 ]
+
+
+First, discovery/enumeration of available counters can be done via
+'perf list':
+
+titan:~> perf list
+  [...]
+  kmem:kmalloc                             [Tracepoint event]
+  kmem:kmem_cache_alloc                    [Tracepoint event]
+  kmem:kmalloc_node                        [Tracepoint event]
+  kmem:kmem_cache_alloc_node               [Tracepoint event]
+  kmem:kfree                               [Tracepoint event]
+  kmem:kmem_cache_free                     [Tracepoint event]
+  kmem:mm_page_free_direct                 [Tracepoint event]
+  kmem:mm_pagevec_free                     [Tracepoint event]
+  kmem:mm_page_alloc                       [Tracepoint event]
+  kmem:mm_page_alloc_zone_locked           [Tracepoint event]
+  kmem:mm_page_pcpu_drain                  [Tracepoint event]
+  kmem:mm_page_alloc_extfrag               [Tracepoint event]
+
+Then any (or all) of the above event sources can be activated and
+measured. For example the page alloc/free properties of a 'hackbench
+run' are:
+
+ titan:~> perf stat -e kmem:mm_page_pcpu_drain -e kmem:mm_page_alloc
+ -e kmem:mm_pagevec_free -e kmem:mm_page_free_direct ./hackbench 10
+ Time: 0.575
+
+ Performance counter stats for './hackbench 10':
+
+          13857  kmem:mm_page_pcpu_drain
+          27576  kmem:mm_page_alloc
+           6025  kmem:mm_pagevec_free
+          20934  kmem:mm_page_free_direct
+
+    0.613972165  seconds time elapsed
+
+You can observe the statistical properties as well, by using the
+'repeat the workload N times' feature of perf stat:
+
+ titan:~> perf stat --repeat 5 -e kmem:mm_page_pcpu_drain -e
+   kmem:mm_page_alloc -e kmem:mm_pagevec_free -e
+   kmem:mm_page_free_direct ./hackbench 10
+ Time: 0.627
+ Time: 0.644
+ Time: 0.564
+ Time: 0.559
+ Time: 0.626
+
+ Performance counter stats for './hackbench 10' (5 runs):
+
+          12920  kmem:mm_page_pcpu_drain    ( +-   3.359% )
+          25035  kmem:mm_page_alloc         ( +-   3.783% )
+           6104  kmem:mm_pagevec_free       ( +-   0.934% )
+          18376  kmem:mm_page_free_direct   ( +-   4.941% )
+
+    0.643954516  seconds time elapsed   ( +-   2.363% )
+
+Furthermore, these tracepoints can be used to sample the workload as
+well. For example the page allocations done by a 'git gc' can be
+captured the following way:
+
+ titan:~/git> perf record -f -e kmem:mm_page_alloc -c 1 ./git gc
+ Counting objects: 1148, done.
+ Delta compression using up to 2 threads.
+ Compressing objects: 100% (450/450), done.
+ Writing objects: 100% (1148/1148), done.
+ Total 1148 (delta 690), reused 1148 (delta 690)
+ [ perf record: Captured and wrote 0.267 MB perf.data (~11679 samples) ]
+
+To check which functions generated page allocations:
+
+ titan:~/git> perf report
+ # Samples: 10646
+ #
+ # Overhead          Command               Shared Object
+ # ........  ...............  ..........................
+ #
+    23.57%       git-repack  /lib64/libc-2.5.so
+    21.81%              git  /lib64/libc-2.5.so
+    14.59%              git  ./git
+    11.79%       git-repack  ./git
+     7.12%              git  /lib64/ld-2.5.so
+     3.16%       git-repack  /lib64/libpthread-2.5.so
+     2.09%       git-repack  /bin/bash
+     1.97%               rm  /lib64/libc-2.5.so
+     1.39%               mv  /lib64/ld-2.5.so
+     1.37%               mv  /lib64/libc-2.5.so
+     1.12%       git-repack  /lib64/ld-2.5.so
+     0.95%               rm  /lib64/ld-2.5.so
+     0.90%  git-update-serv  /lib64/libc-2.5.so
+     0.73%  git-update-serv  /lib64/ld-2.5.so
+     0.68%             perf  /lib64/libpthread-2.5.so
+     0.64%       git-repack  /usr/lib64/libz.so.1.2.3
+
+Or to see it on a more finegrained level:
+
+titan:~/git> perf report --sort comm,dso,symbol
+# Samples: 10646
+#
+# Overhead          Command               Shared Object  Symbol
+# ........  ...............  ..........................  ......
+#
+     9.35%       git-repack  ./git                       [.] insert_obj_hash
+     9.12%              git  ./git                       [.] insert_obj_hash
+     7.31%              git  /lib64/libc-2.5.so          [.] memcpy
+     6.34%       git-repack  /lib64/libc-2.5.so          [.] _int_malloc
+     6.24%       git-repack  /lib64/libc-2.5.so          [.] memcpy
+     5.82%       git-repack  /lib64/libc-2.5.so          [.] __GI___fork
+     5.47%              git  /lib64/libc-2.5.so          [.] _int_malloc
+     2.99%              git  /lib64/libc-2.5.so          [.] memset
+
+Furthermore, call-graph sampling can be done too, of page
+allocations - to see precisely what kind of page allocations there
+are:
+
+ titan:~/git> perf record -f -g -e kmem:mm_page_alloc -c 1 ./git gc
+ Counting objects: 1148, done.
+ Delta compression using up to 2 threads.
+ Compressing objects: 100% (450/450), done.
+ Writing objects: 100% (1148/1148), done.
+ Total 1148 (delta 690), reused 1148 (delta 690)
+ [ perf record: Captured and wrote 0.963 MB perf.data (~42069 samples) ]
+
+ titan:~/git> perf report -g
+ # Samples: 10686
+ #
+ # Overhead          Command               Shared Object
+ # ........  ...............  ..........................
+ #
+    23.25%       git-repack  /lib64/libc-2.5.so
+                |
+                |--50.00%-- _int_free
+                |
+                |--37.50%-- __GI___fork
+                |          make_child
+                |
+                |--12.50%-- ptmalloc_unlock_all2
+                |          make_child
+                |
+                 --6.25%-- __GI_strcpy
+    21.61%              git  /lib64/libc-2.5.so
+                |
+                |--30.00%-- __GI_read
+                |          |
+                |           --83.33%-- git_config_from_file
+                |                     git_config
+                |                     |
+   [...]
+
+Or you can observe the whole system's page allocations for 10
+seconds:
+
+titan:~/git> perf stat -a -e kmem:mm_page_pcpu_drain -e
+kmem:mm_page_alloc -e kmem:mm_pagevec_free -e
+kmem:mm_page_free_direct sleep 10
+
+ Performance counter stats for 'sleep 10':
+
+         171585  kmem:mm_page_pcpu_drain
+         322114  kmem:mm_page_alloc
+          73623  kmem:mm_pagevec_free
+         254115  kmem:mm_page_free_direct
+
+   10.000591410  seconds time elapsed
+
+Or observe how fluctuating the page allocations are, via statistical
+analysis done over ten 1-second intervals:
+
+ titan:~/git> perf stat --repeat 10 -a -e kmem:mm_page_pcpu_drain -e
+   kmem:mm_page_alloc -e kmem:mm_pagevec_free -e
+   kmem:mm_page_free_direct sleep 1
+
+ Performance counter stats for 'sleep 1' (10 runs):
+
+          17254  kmem:mm_page_pcpu_drain    ( +-   3.709% )
+          34394  kmem:mm_page_alloc         ( +-   4.617% )
+           7509  kmem:mm_pagevec_free       ( +-   4.820% )
+          25653  kmem:mm_page_free_direct   ( +-   3.672% )
+
+    1.058135029  seconds time elapsed   ( +-   3.089% )
+
+Or you can annotate the recorded 'git gc' run on a per symbol basis
+and check which instructions/source-code generated page allocations:
+
+ titan:~/git> perf annotate __GI___fork
+ ------------------------------------------------
+  Percent |      Source code & Disassembly of libc-2.5.so
+ ------------------------------------------------
+          :
+          :
+          :      Disassembly of section .plt:
+          :      Disassembly of section .text:
+          :
+          :      00000031a2e95560 <__fork>:
+ [...]
+     0.00 :        31a2e95602:   b8 38 00 00 00          mov    $0x38,%eax
+     0.00 :        31a2e95607:   0f 05                   syscall
+    83.42 :        31a2e95609:   48 3d 00 f0 ff ff       cmp    $0xfffffffffffff000,%rax
+     0.00 :        31a2e9560f:   0f 87 4d 01 00 00       ja     31a2e95762 <__fork+0x202>
+     0.00 :        31a2e95615:   85 c0                   test   %eax,%eax
+
+( this shows that 83.42% of __GI___fork's page allocations come from
+  the 0x38 system call it performs. )
+
+etc. etc. - a lot more is possible. I could list a dozen of
+other different usecases straight away - neither of which is
+possible via /proc/vmstat.
+
+/proc/vmstat is not in the same league really, in terms of
+expressive power of system analysis and performance
+analysis.
+
+All that the above results needed were those new tracepoints
+in include/tracing/events/kmem.h.
+
+	Ingo
+
+
