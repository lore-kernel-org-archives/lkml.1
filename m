Return-Path: <linux-kernel-owner+w=401wt.eu-S1756703AbZCAESP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703AbZCAESP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 23:18:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751408AbZCAER7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 23:17:59 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:45123 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbZCAER6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 23:17:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:in-reply-to:references:from:date:subject:to:cc;
        b=EgjJvOVF1zFYG31wAZ56JUVuawFtPjUnJKibjKq3TD6IVSNKAAB31jbzTVNY9ZDBjq
         NsN5Pc9t6BCczCrArTG+hAToRCIWegthXkPbsAHZjkiqj1OpJjp6/FqELsbC8kFcgqAe
         xMZLNcn+zeSgAQwAb+/087DLwEVuXtVPnw/qY=
Message-ID: <49aa0c73.1c07d00a.4fc6.ffffb4d7@mx.google.com>
In-Reply-To: <20090228091305.GA20533@elte.hu>
References: <20090228091305.GA20533@elte.hu>
From: Frederic Weisbecker <fweisbec@gmail.com>
Date: Sun, 1 Mar 2009 04:31:43 +0100
Subject: [PATCH 0/5] Binary ftrace_printk
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Sorry I had a problem with my first sending, hopefully I'm not spamming
each of you twice).

An new optimization is making its way to ftrace. Its purpose is to
make ftrace_printk() consuming less memory and become faster.

Written by Lai Jiangshan, the approach is to delay the formatting
job from tracing time to output time.
Currently, a call to ftrace_printk will format the whole string and
insert it into the ring buffer. Then you can read it on /debug/tracing/trace
file.

The new implementation stores the address of the format string and
the binary parameters into the ring buffer, making the packet more compact
and faster to insert.
Later, when the user exports the traces, the format string is retrieved
with the binary parameters and the formatting job is eventually done.

Here is the result of a small comparative benchmark while putting the following
ftrace_printk on the timer interrupt. ftrace_printk is the old implementation,
ftrace_bprintk is a the new one:

ftrace_printk("This is the timer interrupt: %llu", jiffies_64);

After some time running on low load (no X, no really active processes):

ftrace_printk:  duration average: 2044 ns, avg of bytes stored per entry: 39
ftrace_bprintk: duration average: 1426 ns, avg of bytes stored per entry: 16

Higher load (started X and launched a cat running on a X console looping on
traces printing):

ftrace_printk:  duration average: 8812 ns
ftrace_bprintk: duration average: 2611 ns

Which means the new implementation can be 70 % faster on higher load.
And it consumes lesser memory on the ring buffer.

The three first patches rebase against latest -tip the ftrace_bprintk work done
by Lai few monthes ago.

The two others integrate ftrace_bprintk as a replacement for the old
ftrace_printk implementation and factorize the printf style format decoding
which is now used by three functions.

---

Frederic Weisbecker (2):
  tracing/core: drop the old ftrace_printk implementation in favour of
    ftrace_bprintk
  vsprintf: unify the format decoding layer for its 3 users

Lai Jiangshan (3):
  add binary printf
  ftrace: infrastructure for supporting binary record
  ftrace: add ftrace_bprintk()

 include/asm-generic/vmlinux.lds.h    |    3 +
 include/linux/ftrace.h               |   44 ++-
 include/linux/module.h               |    5 +
 include/linux/string.h               |    7 +
 kernel/module.c                      |    6 +
 kernel/trace/Kconfig                 |    1 +
 kernel/trace/Makefile                |    1 +
 kernel/trace/trace.c                 |  139 +++---
 kernel/trace/trace.h                 |    8 +-
 kernel/trace/trace_functions_graph.c |    6 +-
 kernel/trace/trace_mmiotrace.c       |    9 +-
 kernel/trace/trace_output.c          |   31 +-
 kernel/trace/trace_output.h          |    2 +
 kernel/trace/trace_printk.c          |  178 ++++++
 lib/Kconfig                          |    3 +
 lib/vsprintf.c                       | 1006 ++++++++++++++++++++++++++--------
 16 files changed, 1127 insertions(+), 322 deletions(-)
 create mode 100644 kernel/trace/trace_printk.c


