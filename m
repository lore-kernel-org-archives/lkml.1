Return-Path: <linux-kernel-owner+w=401wt.eu-S1751564AbZHSRhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751564AbZHSRhk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 13:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751142AbZHSRhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 13:37:39 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:61613 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbZHSRhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 13:37:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=H/kw9it6xALlg8nOWFxX3JVrKmu6rKEZPlWS4u5m4cVHQm2kE0fF4gB305rbz+eGF6
         5ETmmvJWtVhGlDDQB3VcCL25uWUGInPWLyfooXTeFOCEqjPoaNmizgS+frlfgV9oTmOq
         ciw6N9ZuhUumwQslHNgssUTSRWj3vCPLMWMqc=
Date: Wed, 19 Aug 2009 19:37:35 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH 15/16] tracing: Add fields format definition for
	syscall events
Message-ID: <20090819173734.GG4972@nowhere>
References: <1250016545-6601-1-git-send-email-fweisbec@gmail.com> <1250016545-6601-16-git-send-email-fweisbec@gmail.com> <4A8C3290.3070900@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A8C3290.3070900@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 19, 2009 at 01:12:48PM -0400, Masami Hiramatsu wrote:
> Frederic Weisbecker wrote:
> > Define the format of the syscall trace fields to parse the binary
> > values from a raw trace using the syscall events "format" file.
> > 
> > This is defined dynamically using the syscalls metadata.
> > It prepares the export of syscall event raw records to perf
> > counters.
> > 
> > Example:
> > 
> > $ cat /debug/tracing/events/syscalls/sys_enter_sched_getparam/format
> > name: sys_enter_sched_getparam
> > ID: 39
> > format:
> > 	field:unsigned short common_type;	offset:0;	size:2;
> > 	field:unsigned char common_flags;	offset:2;	size:1;
> > 	field:unsigned char common_preempt_count;	offset:3;	size:1;
> > 	field:int common_pid;	offset:4;	size:4;
> > 	field:int common_tgid;	offset:8;	size:4;
> > 
> > 	field:pid_t pid;	offset:12;	size:8;
> > 	field:struct sched_param * param;	offset:20;	size:8;
> > 
> > print fmt: "pid: 0x%08lx, param: 0x%08lx", ((unsigned long)(REC->pid)), ((unsigned long)(REC->param))
> 
> Hi Frederic,
> 
> I've found that the formats of some syscall events were too big.
> 
> ---
> $ for i in sys_enter* ;do grep name $i/format > /dev/null || echo $i has broken format. ; done sys_enter_getegid has broken format.
> sys_enter_geteuid has broken format.
> sys_enter_getgid has broken format.
> sys_enter_getpgrp has broken format.
> sys_enter_getpid has broken format.
> sys_enter_getppid has broken format.
> sys_enter_gettid has broken format.
> sys_enter_getuid has broken format.
> sys_enter_inotify_init has broken format.
> sys_enter_munlockall has broken format.
> sys_enter_pause has broken format.
> sys_enter_restart_syscall has broken format.
> sys_enter_sched_yield has broken format.
> sys_enter_setsid has broken format.
> sys_enter_sync has broken format.
> sys_enter_vhangup has broken format.
> 
> $ cat sys_enter_getegid/format
> FORMAT TOO BIG
> ---
> 
> And it causes an error on ./perf trace.
> 
> ---
> $ ./perf record -R -e syscalls:sys_enter_read -a -f  cat libperf.a > /dev/null
> 
> $ ./perf trace
>   Fatal: Error: expected 'name' but read 'FORMAT'
> version = 0.5
> ---
> 
> Thank you,


Yeah, I have yet to fix this, that because syscalls that have no parameters
raise a small bug in the return value of trace_seq_printf() while printing
their format, returning 0 as if the buffer was full and lost some bits.

However, It's possible that the last patches from Li fix this, since he did
a total/better refactoring of the format definition for syscall events.

I'll check this,
Thanks!

