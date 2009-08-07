Return-Path: <linux-kernel-owner+w=401wt.eu-S1753632AbZHGPzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632AbZHGPzA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 11:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753474AbZHGPy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 11:54:59 -0400
Received: from viefep13-int.chello.at ([62.179.121.33]:10684 "EHLO
	viefep13-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104AbZHGPy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 11:54:58 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH] perfcounters: Support for ftrace event records sampling
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Steven Rostedt <rostedt@goodmis.org>,
       Paul Mackerras <paulus@samba.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>
In-Reply-To: <1249601154-5597-1-git-send-email-fweisbec@gmail.com>
References: <1249601154-5597-1-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain
Date: Fri, 07 Aug 2009 17:54:38 +0200
Message-Id: <1249660478.32113.736.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-08-07 at 01:25 +0200, Frederic Weisbecker wrote:
> +static void ftrace_profile_##call(proto)                               \
> +{                                                                      \
> +       struct ftrace_data_offsets_##call __maybe_unused __data_offsets;\
> +       struct ftrace_event_call *event_call = &event_##call;           \
> +       extern void perf_tpcounter_event(int, u64, u64, void *, int);   \
> +       struct ftrace_raw_##call *entry;                                \
> +       u64 __addr = 0, __count = 1;                                    \
> +       unsigned long irq_flags;                                        \
> +       int __entry_size;                                               \
> +       int __data_size;                                                \
> +       int pc;                                                         \
> +                                                                       \
> +       local_save_flags(irq_flags);                                    \
> +       pc = preempt_count();                                           \
> +                                                                       \
> +       __data_size = ftrace_get_offsets_##call(&__data_offsets, args); \
> +       __entry_size = __data_size + sizeof(*entry);                    \
> +                                                                       \
> +       do {                                                            \
> +               char raw_data[__entry_size];                            \
> +               struct trace_entry *ent;                                \
> +                                                                       \
> +               entry = (struct ftrace_raw_##call *)raw_data;           \
> +               ent = &entry->ent;                                      \
> +               tracing_generic_entry_update(ent, irq_flags, pc);       \
> +               ent->type = event_call->id;                             \
> +                                                                       \
> +               tstruct                                                 \
> +                                                                       \
> +               { assign; }                                             \
> +                                                                       \
> +               perf_tpcounter_event(event_call->id, __addr, __count, entry,\
> +                            __entry_size);                             \
> +       } while (0);                                                    \

Causes:

ERROR: "tracing_generic_entry_update" [fs/jbd2/jbd2.ko] undefined!
ERROR: "tracing_generic_entry_update" [fs/ext4/ext4.ko] undefined!

Which will be fixed by:

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/trace/trace.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 6344573..e793cda 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -848,6 +848,7 @@ tracing_generic_entry_update(struct trace_entry *entry, unsigned long flags,
 		((pc & SOFTIRQ_MASK) ? TRACE_FLAG_SOFTIRQ : 0) |
 		(need_resched() ? TRACE_FLAG_NEED_RESCHED : 0);
 }
+EXPORT_SYMBOL_GPL(tracing_generic_entry_update);
 
 struct ring_buffer_event *trace_buffer_lock_reserve(struct trace_array *tr,
 						    int type,


