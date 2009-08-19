Return-Path: <linux-kernel-owner+w=401wt.eu-S1751882AbZHSRJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882AbZHSRJr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 13:09:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751242AbZHSRJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 13:09:47 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33771 "EHLO mx2.redhat.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751191AbZHSRJq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 13:09:46 -0400
Message-ID: <4A8C3290.3070900@redhat.com>
Date: Wed, 19 Aug 2009 13:12:48 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH 15/16] tracing: Add fields format definition for syscall
 events
References: <1250016545-6601-1-git-send-email-fweisbec@gmail.com> <1250016545-6601-16-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1250016545-6601-16-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> Define the format of the syscall trace fields to parse the binary
> values from a raw trace using the syscall events "format" file.
> 
> This is defined dynamically using the syscalls metadata.
> It prepares the export of syscall event raw records to perf
> counters.
> 
> Example:
> 
> $ cat /debug/tracing/events/syscalls/sys_enter_sched_getparam/format
> name: sys_enter_sched_getparam
> ID: 39
> format:
> 	field:unsigned short common_type;	offset:0;	size:2;
> 	field:unsigned char common_flags;	offset:2;	size:1;
> 	field:unsigned char common_preempt_count;	offset:3;	size:1;
> 	field:int common_pid;	offset:4;	size:4;
> 	field:int common_tgid;	offset:8;	size:4;
> 
> 	field:pid_t pid;	offset:12;	size:8;
> 	field:struct sched_param * param;	offset:20;	size:8;
> 
> print fmt: "pid: 0x%08lx, param: 0x%08lx", ((unsigned long)(REC->pid)), ((unsigned long)(REC->param))

Hi Frederic,

I've found that the formats of some syscall events were too big.

---
$ for i in sys_enter* ;do grep name $i/format > /dev/null || echo $i has broken format. ; done sys_enter_getegid has broken format.
sys_enter_geteuid has broken format.
sys_enter_getgid has broken format.
sys_enter_getpgrp has broken format.
sys_enter_getpid has broken format.
sys_enter_getppid has broken format.
sys_enter_gettid has broken format.
sys_enter_getuid has broken format.
sys_enter_inotify_init has broken format.
sys_enter_munlockall has broken format.
sys_enter_pause has broken format.
sys_enter_restart_syscall has broken format.
sys_enter_sched_yield has broken format.
sys_enter_setsid has broken format.
sys_enter_sync has broken format.
sys_enter_vhangup has broken format.

$ cat sys_enter_getegid/format
FORMAT TOO BIG
---

And it causes an error on ./perf trace.

---
$ ./perf record -R -e syscalls:sys_enter_read -a -f  cat libperf.a > /dev/null

$ ./perf trace
  Fatal: Error: expected 'name' but read 'FORMAT'
version = 0.5
---

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

