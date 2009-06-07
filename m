Return-Path: <linux-kernel-owner+w=401wt.eu-S1755498AbZFGNaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498AbZFGNaL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 09:30:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753229AbZFGNaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 09:30:00 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56539 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753353AbZFGN37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 09:29:59 -0400
Date: Sun, 7 Jun 2009 15:29:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, mathieu.desnoyers@polymtl.ca,
       jiayingz@google.com, mbligh@google.com, roland@redhat.com,
       fche@redhat.com
Subject: Re: [PATCH 2/2] convert to syscall tracepoints
Message-ID: <20090607132936.GC12088@elte.hu>
References: <cover.1244222378.git.jbaron@redhat.com> <af4031af81ce372eac2be125dabc2ea746b4308b.1244222378.git.jbaron@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af4031af81ce372eac2be125dabc2ea746b4308b.1244222378.git.jbaron@redhat.com>
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


* Jason Baron <jbaron@redhat.com> wrote:

> 
> Implements syscall tracer via tracepoints and TRACE_EVENT(). Introduces
> a new tracing flag 'trace_syscalls', which must be toggled to enable this
> feature.
> 
> 
> Signed-off-by: Jason Baron <jbaron@redhat.com>
> 
> ---
>  arch/x86/kernel/ptrace.c        |    8 +-
>  include/asm-generic/syscall.h   |    3 +
>  include/trace/events/syscalls.h | 4202 +++++++++++++++++++++++++++++++++++++++
>  include/trace/syscall.h         |    6 +
>  kernel/trace/Makefile           |    1 -
>  kernel/trace/trace.c            |  101 +
>  kernel/trace/trace_syscalls.c   |  250 ---
>  7 files changed, 4317 insertions(+), 254 deletions(-)
>  create mode 100644 include/trace/events/syscalls.h
>  delete mode 100644 kernel/trace/trace_syscalls.c

the functionality is fine and very desired IMO, but the 
implementation is pretty large and ugly, isnt it?

Wouldnt it be possible to compress this:

> +#ifdef __NR_setgroups
> +trace_event_syscall_enter(2, setgroups, int, gidsetsize, gid_t __user *, grouplist);
> +trace_event_syscall_exit(setgroups);
> +#define ENTERCASEsetgroups create_syscall_enter(2, setgroups, int, gid_t __user *);
> +#define EXITCASEsetgroups create_syscall_exit(setgroups);
> +#else
> +#define ENTERCASEsetgroups
> +#define EXITCASEsetgroups
> +#endif

down to some sane syntax? Do we really want to replicate all the 
DEFINE_SYSCALL() information again in a separate header? Is there no 
way to somehow define the tracepoint in-situ, where the 
DEFINE_SYSCALL macro is present? That would eliminate 
include/trace/events/syscalls.h altogether.

	Ingo
