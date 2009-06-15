Return-Path: <linux-kernel-owner+w=401wt.eu-S1761466AbZFOOJQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761466AbZFOOJQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 10:09:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761336AbZFOOIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 10:08:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:51752 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761378AbZFOOIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 10:08:52 -0400
Date: Mon, 15 Jun 2009 14:07:39 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, penberg@cs.helsinki.fi,
       torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       torvalds@linux-foundation.org, penberg@cs.helsinki.fi, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf report: Add per system call overhead histogram
Message-ID: <tip-3dfabc74c65904c9e6cf952391312d16ea772ef5@git.kernel.org>
Git-Commit-ID: 3dfabc74c65904c9e6cf952391312d16ea772ef5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 15 Jun 2009 14:07:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3dfabc74c65904c9e6cf952391312d16ea772ef5
Gitweb:     http://git.kernel.org/tip/3dfabc74c65904c9e6cf952391312d16ea772ef5
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Mon, 15 Jun 2009 11:24:38 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 15 Jun 2009 15:58:03 +0200

perf report: Add per system call overhead histogram

Take advantage of call-graph percounter sampling/recording to
display a non-trivial histogram: the true, collapsed/summarized
cost measurement, on a per system call total overhead basis:

 aldebaran:~/linux/linux/tools/perf> ./perf record -g -a -f ~/hackbench 10
 aldebaran:~/linux/linux/tools/perf> ./perf report -s symbol --syscalls | head -10
 #
 # (3536 samples)
 #
 # Overhead  Symbol
 # ........  ......
 #
     40.75%  [k] sys_write
     40.21%  [k] sys_read
      4.44%  [k] do_nmi
 ...

This is done by accounting each (reliable) call-chain that chains back
to a given system call to that system call function.

[ So in the above example we can see that hackbench spends about 40% of
  its total time somewhere in sys_write() and 40% somewhere in
  sys_read(), the rest of the time is spent in user-space. The time
  is not spent in sys_write() _itself_ but in one of its many child
  functions. ]

Or, a recording of a (source files are already in the page-cache) kernel build:

 $ perf record -g -m 512 -f -- make -j32 kernel
 $ perf report -s s --syscalls | grep '\[k\]' | grep -v nmi

     4.14%  [k] do_page_fault
     1.20%  [k] sys_write
     1.10%  [k] sys_open
     0.63%  [k] sys_exit_group
     0.48%  [k] smp_apic_timer_interrupt
     0.37%  [k] sys_read
     0.37%  [k] sys_execve
     0.20%  [k] sys_mmap
     0.18%  [k] sys_close
     0.14%  [k] sys_munmap
     0.13%  [k] sys_poll
     0.09%  [k] sys_newstat
     0.07%  [k] sys_clone
     0.06%  [k] sys_newfstat
     0.05%  [k] sys_access
     0.05%  [k] schedule

Shows the true total cost of each syscall variant that gets used
during a kernel build. This profile reveals it that pagefaults are
the costliest, followed by read()/write().

An interesting detail: timer interrupts cost 0.5% - or 0.5 seconds
per 100 seconds of kernel build-time. (this was done with HZ=1000)

The summary is done in 'perf report', i.e. in the post-processing
stage - so once we have a good call-graph recording, this type of
non-trivial high-level analysis becomes possible.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-report.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index aebba56..1e2f5dd 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -40,6 +40,7 @@ static int		dump_trace = 0;
 
 static int		verbose;
 static int		full_paths;
+static int		collapse_syscalls;
 
 static unsigned long	page_size;
 static unsigned long	mmap_window = 32;
@@ -983,6 +984,15 @@ process_overflow_event(event_t *event, unsigned long offset, unsigned long head)
 			for (i = 0; i < chain->nr; i++)
 				dprintf("..... %2d: %p\n", i, (void *)chain->ips[i]);
 		}
+		if (collapse_syscalls) {
+			/*
+			 * Find the all-but-last kernel entry
+			 * amongst the call-chains - to get
+			 * to the level of system calls:
+			 */
+			if (chain->kernel >= 2)
+				ip = chain->ips[chain->kernel-2];
+		}
 	}
 
 	dprintf(" ... thread: %s:%d\n", thread->comm, thread->pid);
@@ -1343,6 +1353,8 @@ static const struct option options[] = {
 		   "sort by key(s): pid, comm, dso, symbol. Default: pid,symbol"),
 	OPT_BOOLEAN('P', "full-paths", &full_paths,
 		    "Don't shorten the pathnames taking into account the cwd"),
+	OPT_BOOLEAN('S', "syscalls", &collapse_syscalls,
+		    "show per syscall summary overhead, using call graph"),
 	OPT_END()
 };
 
