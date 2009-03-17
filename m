Return-Path: <linux-kernel-owner+w=401wt.eu-S1757512AbZCQQFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512AbZCQQFs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 12:05:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754920AbZCQQFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 12:05:38 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:36210 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752304AbZCQQFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 12:05:38 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: As0FALNkv0lMQW1W/2dsb2JhbACBTtNug3wG
Date: Tue, 17 Mar 2009 12:00:29 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       utrace-devel@redhat.com
Subject: Re: [RFC][PATCH 1/2] tracing/ftrace: syscall tracing infrastructure
Message-ID: <20090317160029.GD10092@Krystal>
References: <1236401580-5758-1-git-send-email-fweisbec@gmail.com> <1236401580-5758-2-git-send-email-fweisbec@gmail.com> <49BEAA5A.4030708@redhat.com> <20090316201526.GE8393@nowhere> <49BEB8C4.2010606@redhat.com> <20090316214526.GA15119@Krystal> <20090317052442.GA32674@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090317052442.GA32674@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:45:31 up 17 days, 12:11,  1 user,  load average: 0.51, 0.80,
	0.61
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov (oleg@redhat.com) wrote:
> On 03/16, Mathieu Desnoyers wrote:
> >
> > utrace_add_engine()
> >   set_notify_resume(target);
> >
> > ok, so this is where the TIF_NOTIFY_RESUME thread flag is set. I notice
> > that it is set asynchronously with the execution of the target thread
> > (as I do with my TIF_KERNEL_TRACE thread flag).
> >
> > However, on x86_64, _TIF_DO_NOTIFY_MASK is only tested in
> > entry_64.S
> >
> > int_signal:
> > and
> > retint_signal:
> >
> > code paths. However, if there is no syscall tracing to do upon syscall
> > entry, the thread flags are not re-read at syscall exit and you will
> > miss the syscall exit returning from your target thread if this thread
> > was blocked while you set its TIF_NOTIFY_RESUME.
> 
> Afaics, TIF_NOTIFY_RESUME is not needed to trace syscall entry/exit.
> If engine wants the syscall tracing, utrace_set_events(UTRACE_SYSCALL_xxx)
> sets TIF_SYSCALL_TRACE. And syscall_trace_enter/syscall_trace_leave call
> tracehook_report_syscall_xxx().
> 
> Oleg.

I recall that TIF_SYSCALL_TRACE also suffers from the same problem as
TIF_NOTIFY_RESUME if set asynchronously with the target thread's
execution at least on x86_64 and arm. Do you take care to stop the
target thread in utrace_set_events ?

Mathieu

> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
