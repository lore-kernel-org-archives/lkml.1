Return-Path: <linux-kernel-owner+w=401wt.eu-S1756127AbYEEG4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127AbYEEG4t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 02:56:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752714AbYEEG4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 02:56:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36877 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751855AbYEEG4j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 02:56:39 -0400
Date: Mon, 5 May 2008 08:55:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, systemtap@sources.redhat.com,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: System call instrumentation
Message-ID: <20080505065559.GD3350@elte.hu>
References: <20080504134838.GA21487@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080504134838.GA21487@Krystal>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> Hi Ingo,
> 
> I looked at the system call instrumentation present in LTTng lately. I 
> tried different solutions, e.g. hooking a kernel-wide syscall trace in 
> do_syscall_trace, but it appears that I ended up re-doing another 
> syscall table, which consists of specialized functions which extracts 
> the string and data structure parameters from user-space. Since code 
> duplication is not exactly wanted, I think that the original approach 
> taken in my patchset, which is to instrument the kernel code at the 
> sys_* level (e.g. sys_open), which is the earliest level where the 
> parameter information is made available to the kernel, is still the 
> best way to go.

hm, i'm not sure about this. I've implemented system call tracing in -rt 
[embedded in the latency tracer] and it only needed changes in entry.S, 
not in every system call site. Now, granted, that tracer was simpler 
than what LTTng tries to do, but do we _really_ need more complexity? A 
trace point that simply expresses:

   sys_call_event(int sysno, long param1, long param2, long param3,
                             long param4, long param5, long param6);

would be more than enough in 99% of the cases. If you want to extract 
the strings from the system call table, to make the filtering of these 
syscall events easier, do it during build time (by for example modifying 
the __SYSCALL() macros in unistd.h), instead of a parallel syscall 
table.

OTOH, as long as it's just one simple nonintrusive line per syscall, 
it's not a big deal - as long as it only traces the parameters as they 
come from the syscall ABI - we wont change them anyway. I.e. hide the 
ugly string portion, just turn them into a simple:

  trace_sys_getpid();
  trace_sys_time(tloc);
  trace_sys_gettimeofday(tz, tv);

(although even such a solution would still need a general policy level 
buy-in i guess - we dont want half of the syscalls traced, the other 
half objected to by maintainers. So it's either all or nothing.)

and the question also arises: why not do this on a debuginfo level? This 
information can be extracted from the debuginfo. We could change 
'asmlinkage' to 'syscall_linkage' to make it clear which functions are 
syscalls.

	Ingo
