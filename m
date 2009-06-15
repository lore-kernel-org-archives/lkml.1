Return-Path: <linux-kernel-owner+w=401wt.eu-S1763230AbZFOPxH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763230AbZFOPxH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 11:53:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752577AbZFOPw4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 11:52:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52146 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752077AbZFOPwz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 11:52:55 -0400
Date: Mon, 15 Jun 2009 17:52:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>, linux-kernel@vger.kernel.org,
       mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       efault@gmx.de, npiggin@suse.de, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org, mathieu.desnoyers@polymtl.ca,
       torvalds@linux-foundation.org, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [tip:perfcounters/core] x86: Add NMI types for kmap_atomic
Message-ID: <20090615155228.GA19529@elte.hu>
References: <tip-3ff0141aa3a03ca3388b40b36167d0a37919f3fd@git.kernel.org> <1245077165.6800.497.camel@laptop> <Pine.LNX.4.64.0906151623570.5225@sister.anvils> <1245080486.6800.561.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245080486.6800.561.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> > I've not been following the background to this,
> 
> We need/want to do a user-space stack walk from IRQ/NMI context. 
> The NMI bit means we cannot simply use __copy_from_user_inatomic() 
> since that will still fault (albeit not page), and the fault 
> return path invokes IRET which will terminate the NMI context.

The goal is to allow 'perf' (see tools/perf/) non-flat 
categorizations like the sample output in the (pending) commit (see 
it attached further below). Here's the kind of output it allows:

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

Note that Oprofile uses the same method of __copy_user_inatomic() in 
arch/x86/oprofile/backtrace.c, but i believe that code is broken - i 
doubt the call-chain support for user-space stacks ever worked in 
oprofile - with perfcounters i can make this method crash under 
load. (we re-enter the NMI which due to IST executes over the exact 
same, still pending NMI frame. Kaboom.)

I saw you being involved with the Oprofile code 3 years ago:

| commit c34d1b4d165c67b966bca4aba026443d7ff161eb
| Author: Hugh Dickins <hugh@veritas.com>
| Date:   Sat Oct 29 18:16:32 2005 -0700
|
|    [PATCH] mm: kill check_user_page_readable

That method of __copy_user_inatomic(), while elegant, is subtly 
wrong in an NMI context. We really must avoid taking faults there.

	Ingo

------------>
>From 3dfabc74c65904c9e6cf952391312d16ea772ef5 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Mon, 15 Jun 2009 11:24:38 +0200
Subject: [PATCH] perf report: Add per system call overhead histogram

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
 
