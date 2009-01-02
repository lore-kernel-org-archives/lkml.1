Return-Path: <linux-kernel-owner+w=401wt.eu-S932436AbZABWY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932436AbZABWY6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 17:24:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757656AbZABWYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 17:24:49 -0500
Received: from yw-out-2324.google.com ([74.125.46.31]:40941 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756919AbZABWYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 17:24:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=fslEnKjJNu/JhkdOF6Mh42Y8sY37TDAdvW2fEg/nv96nYZEUfuzgunXeQfOSQ9hM9a
         6oHbWYJ024OD++uD5xHFNlEV5PaV05347mly0ewQJ/f80vjOgWBxa3Eacbk7846/l0X8
         TP2rEyiKKTIMadXSzp4h7zUyJE3eBYrJRGIAQ=
Message-ID: <39e6f6c70901021424v28c1a7dbgbaaf67ac12ca9526@mail.gmail.com>
Date: Fri, 2 Jan 2009 20:24:45 -0200
From: "Arnaldo Carvalho de Melo" <acme@ghostprotocols.net>
To: "Frederic Weisbecker" <fweisbec@gmail.com>
Subject: Re: [PATCH 2/5] ftrace: infrastructure for supporting binary record
Cc: "Lai Jiangshan" <laijs@cn.fujitsu.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20081231045956.GC28472@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <495ADF45.2030203@cn.fujitsu.com> <20081231045956.GC28472@nowhere>
X-Google-Sender-Auth: 5f4c0ef00660bbd4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 31, 2008 at 2:59 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> Hi Lai.
>
> On Wed, Dec 31, 2008 at 10:56:05AM +0800, Lai Jiangshan wrote:
>>
>> Impact: save on memory for tracing
>>
>> Current tracers are typically using a struct(like struct ftrace_entry,
>> struct ctx_switch_entry, struct special_entr etc...)to record a binary
>> event. These structs can only record a their own kind of events.
>> A new kind of tracer need a new struct and a lot of code too handle it.
>>
>> So we need a generic binary record for events. This infrastructure
>> is for this purpose.
>>
>> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
>> ---
>>  include/linux/ftrace.h       |    3 +
>>  kernel/trace/Kconfig         |    6 ++
>>  kernel/trace/Makefile        |    1
>>  kernel/trace/trace.c         |   57 ++++++++++++++++++++++++++++
>>  kernel/trace/trace.h         |   12 +++++
>>  kernel/trace/trace_bprintk.c |   87 +++++++++++++++++++++++++++++++++++++++++++
>>  kernel/trace/trace_output.c  |   72 +++++++++++++++++++++++++++++++++++
>>  7 files changed, 238 insertions(+)
>> diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
>> index 677432b..0ec4752 100644
>> --- a/include/linux/ftrace.h
>> +++ b/include/linux/ftrace.h
>> @@ -181,6 +181,9 @@ extern int ftrace_make_nop(struct module *mod,
>>   */
>>  extern int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr);
>>
>> +#ifdef CONFIG_TRACE_BPRINTK
>> +extern int trace_vbprintk(unsigned long ip, const char *fmt, va_list args);
>> +#endif
>>
>>  /* May be defined in arch */
>>  extern int ftrace_arch_read_dyn_info(char *buf, int size);
>> diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
>> index e2a4ff6..887bd89 100644
>> --- a/kernel/trace/Kconfig
>> +++ b/kernel/trace/Kconfig
>> @@ -77,6 +77,12 @@ config FUNCTION_GRAPH_TRACER
>>         This is done by setting the current return address on the current
>>         task structure into a stack of calls.
>>
>> +config TRACE_BPRINTK
>> +     bool "Binary printk for tracing"
>> +     default y
>> +     depends on TRACING
>> +     select BINARY_PRINTF
>> +
>>  config IRQSOFF_TRACER
>>       bool "Interrupts-off Latency Tracer"
>>       default n
>> diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
>> index 31cd5fb..8ca3952 100644
>> --- a/kernel/trace/Makefile
>> +++ b/kernel/trace/Makefile
>> @@ -21,6 +21,7 @@ obj-$(CONFIG_RING_BUFFER) += ring_buffer.o
>>  obj-$(CONFIG_TRACING) += trace.o
>>  obj-$(CONFIG_TRACING) += trace_output.o
>>  obj-$(CONFIG_TRACING) += trace_stat.o
>> +obj-$(CONFIG_TRACE_BPRINTK) += trace_bprintk.o
>>  obj-$(CONFIG_CONTEXT_SWITCH_TRACER) += trace_sched_switch.o
>>  obj-$(CONFIG_SYSPROF_TRACER) += trace_sysprof.o
>>  obj-$(CONFIG_FUNCTION_TRACER) += trace_functions.o
>> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
>> index b789c01..6e5c9df 100644
>> --- a/kernel/trace/trace.c
>> +++ b/kernel/trace/trace.c
>> @@ -3027,6 +3027,63 @@ int __ftrace_printk(unsigned long ip, const char *fmt, ...)
>>  }
>>  EXPORT_SYMBOL_GPL(__ftrace_printk);
>>
>> +/**
>> + * trace_vbprintk - write binary msg to tracing buffer
>> + *
>> + * Caller must insure @fmt are valid when msg is in tracing buffer.
>> + */
>> +int trace_vbprintk(unsigned long ip, const char *fmt, va_list args)
>> +{
>> +     static DEFINE_SPINLOCK(trace_buf_lock);
>> +     static u32 trace_buf[TRACE_BUF_SIZE];
>> +
>> +     struct ring_buffer_event *event;
>> +     struct trace_array *tr = &global_trace;
>> +     struct trace_array_cpu *data;
>> +     struct bprintk_entry *entry;
>> +     unsigned long flags, irq_flags;
>> +     int cpu, len = 0, size, pc;
>> +
>> +     if (tracing_disabled || !trace_bprintk_enable)
>> +             return 0;
>> +
>> +     pc = preempt_count();
>> +     preempt_disable_notrace();
>> +     cpu = raw_smp_processor_id();
>> +     data = tr->data[cpu];
>> +
>> +     if (unlikely(atomic_read(&data->disabled)))
>> +             goto out;
>> +
>> +     spin_lock_irqsave(&trace_buf_lock, flags);
>> +     len = vbin_printf(trace_buf, TRACE_BUF_SIZE, fmt, args);
>> +
>> +     if (len > TRACE_BUF_SIZE || len < 0)
>> +             goto out_unlock;
>> +
>> +     size = sizeof(*entry) + sizeof(u32) * len;
>> +     event = ring_buffer_lock_reserve(tr->buffer, size, &irq_flags);
>> +     if (!event)
>> +             goto out_unlock;
>> +     entry = ring_buffer_event_data(event);
>> +     tracing_generic_entry_update(&entry->ent, flags, pc);
>> +     entry->ent.type                 = TRACE_BPRINTK;
>> +     entry->ip                       = ip;
>> +     entry->fmt                      = fmt;
>> +
>> +     memcpy(entry->buf, trace_buf, sizeof(u32) * len);
>> +     ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
>> +
>> +out_unlock:
>> +     spin_unlock_irqrestore(&trace_buf_lock, flags);
>> +
>> +out:
>> +     preempt_enable_notrace();
>> +
>> +     return len;
>> +}
>> +EXPORT_SYMBOL_GPL(trace_vbprintk);
>> +
>>  static int trace_panic_handler(struct notifier_block *this,
>>                              unsigned long event, void *unused)
>>  {
>> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
>> index a8b624c..6885d13 100644
>> --- a/kernel/trace/trace.h
>> +++ b/kernel/trace/trace.h
>> @@ -18,6 +18,7 @@ enum trace_type {
>>       TRACE_WAKE,
>>       TRACE_STACK,
>>       TRACE_PRINT,
>> +     TRACE_BPRINTK,
>>       TRACE_SPECIAL,
>>       TRACE_MMIO_RW,
>>       TRACE_MMIO_MAP,
>> @@ -120,6 +121,16 @@ struct print_entry {
>>       char                    buf[];
>>  };
>>
>> +struct bprintk_entry {
>> +     struct trace_entry ent;
>> +     unsigned long ip;
>> +     const char *fmt;
>> +     u32 buf[];
>> +};
>> +#ifdef CONFIG_TRACE_BPRINTK
>> +extern int trace_bprintk_enable;
>> +#endif
>> +
>>  #define TRACE_OLD_SIZE               88
>>
>>  struct trace_field_cont {
>> @@ -262,6 +273,7 @@ extern void __ftrace_bad_type(void);
>>               IF_ASSIGN(var, ent, struct stack_entry, TRACE_STACK);   \
>>               IF_ASSIGN(var, ent, struct userstack_entry, TRACE_USER_STACK);\
>>               IF_ASSIGN(var, ent, struct print_entry, TRACE_PRINT);   \
>> +             IF_ASSIGN(var, ent, struct bprintk_entry, TRACE_BPRINTK);\
>>               IF_ASSIGN(var, ent, struct special_entry, 0);           \
>>               IF_ASSIGN(var, ent, struct trace_mmiotrace_rw,          \
>>                         TRACE_MMIO_RW);                               \
>> diff --git a/kernel/trace/trace_bprintk.c b/kernel/trace/trace_bprintk.c
>> new file mode 100644
>> index 0000000..1f8e532
>> --- /dev/null
>> +++ b/kernel/trace/trace_bprintk.c
>> @@ -0,0 +1,87 @@
>> +/*
>> + * trace binary printk
>> + *
>> + * Copyright (C) 2008 Lai Jiangshan <laijs@cn.fujitsu.com>
>> + *
>> + */
>> +#include <linux/kernel.h>
>> +#include <linux/ftrace.h>
>> +#include <linux/string.h>
>> +#include <linux/ctype.h>
>> +#include <linux/list.h>
>> +#include <linux/mutex.h>
>> +#include <linux/slab.h>
>> +#include <linux/module.h>
>> +#include <linux/seq_file.h>
>> +#include <linux/fs.h>
>> +#include <linux/marker.h>
>> +#include <linux/uaccess.h>
>> +
>> +#include "trace.h"
>> +
>> +/* binary printk basic */
>> +static DEFINE_MUTEX(btrace_mutex);
>
> Looks like you only need a mutex to protect a counter.
> Wouldn't it be better to have this counter atomic and then drop
> out the mutex?
>
>> +static int btrace_metadata_count;
>> +
>> +static inline void lock_btrace(void)
>> +{
>> +     mutex_lock(&btrace_mutex);
>> +}
>> +
>> +static inline void unlock_btrace(void)
>> +{
>> +     mutex_unlock(&btrace_mutex);
>> +}
>> +
>> +static void get_btrace_metadata(void)
>> +{
>> +     lock_btrace();
>> +     btrace_metadata_count++;
>> +     unlock_btrace();
>> +}
>> +
>> +static void put_btrace_metadata(void)
>> +{
>> +     lock_btrace();
>> +     btrace_metadata_count--;
>> +     unlock_btrace();
>> +}
>> +
>> +/* events tracer */
>> +int trace_bprintk_enable;
>> +
>> +static void start_bprintk_trace(struct trace_array *tr)
>> +{
>> +     get_btrace_metadata();
>> +     tracing_reset_online_cpus(tr);
>> +     trace_bprintk_enable = 1;
>> +}
>> +
>> +static void stop_bprintk_trace(struct trace_array *tr)
>> +{
>> +     trace_bprintk_enable = 0;
>> +     tracing_reset_online_cpus(tr);
>> +     put_btrace_metadata();
>> +}
>> +
>> +static int init_bprintk_trace(struct trace_array *tr)
>> +{
>> +     start_bprintk_trace(tr);
>> +     return 0;
>> +}
>> +
>> +static struct tracer bprintk_trace __read_mostly =
>> +{
>> +     .name        = "events",
>> +     .init        = init_bprintk_trace,
>> +     .reset       = stop_bprintk_trace,
>> +     .start       = start_bprintk_trace,
>> +     .stop        = stop_bprintk_trace,
>> +};
>> +
>> +static __init int init_bprintk(void)
>> +{
>> +     return register_tracer(&bprintk_trace);
>> +}
>> +
>> +device_initcall(init_bprintk);
>> diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
>> index df0c25c..ccc9fa7 100644
>> --- a/kernel/trace/trace_output.c
>> +++ b/kernel/trace/trace_output.c
>> @@ -53,6 +53,26 @@ trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
>>       return len;
>>  }
>>
>> +static int
>> +trace_seq_bprintf(struct trace_seq *s, const char *fmt, const u32 *binary)
>> +{
>> +     int len = (PAGE_SIZE - 1) - s->len;
>> +     int ret;
>> +
>> +     if (!len)
>> +             return 0;
>> +
>> +     ret = bstr_printf(s->buffer + s->len, len, fmt, binary);
>> +
>> +     /* If we can't write it all, don't bother writing anything */
>> +     if (ret >= len)
>> +             return 0;
>> +
>> +     s->len += ret;
>> +
>> +     return len;
>> +}
>> +
>>  /**
>>   * trace_seq_puts - trace sequence printing of simple string
>>   * @s: trace sequence descriptor
>> @@ -800,6 +820,57 @@ static struct trace_event trace_print_event = {
>>       .binary         = trace_nop_print,
>>  };
>>
>> +/* TRACE_BPRINTK */
>> +static int
>> +trace_bprintk_print(struct trace_seq *s, struct trace_entry *entry, int flags)
>> +{
>> +     struct bprintk_entry *field;
>> +
>> +     trace_assign_type(field, entry);
>> +
>> +     if (!seq_print_ip_sym(s, field->ip, flags))
>> +             goto partial;
>> +
>> +     if (!trace_seq_puts(s, ": "))
>> +             goto partial;
>> +
>> +     if (!trace_seq_bprintf(s, field->fmt, field->buf))
>> +             goto partial;
>> +
>> +     return 0;
>> +
>> + partial:
>> +     return TRACE_TYPE_PARTIAL_LINE;
>> +}
>> +
>> +static int
>> +trace_bprintk_raw(struct trace_seq *s, struct trace_entry *entry, int flags)
>> +{
>> +     struct bprintk_entry *field;
>> +
>> +     trace_assign_type(field, entry);
>> +
>> +     if (!trace_seq_printf(s, ": %lx : ", field->ip))
>> +             goto partial;
>> +
>> +     if (!trace_seq_bprintf(s, field->fmt, field->buf))
>> +             goto partial;
>> +
>> +     return 0;
>> +
>> + partial:
>> +     return TRACE_TYPE_PARTIAL_LINE;
>> +}
>> +
>> +static struct trace_event trace_bprintk_event = {
>> +     .type           = TRACE_BPRINTK,
>> +     .trace          = trace_bprintk_print,
>> +     .latency_trace  = trace_bprintk_print,
>> +     .raw            = trace_bprintk_raw,
>> +     .hex            = trace_nop_print,
>> +     .binary         = trace_nop_print,
>> +};
>> +
>>  static struct trace_event *events[] __initdata = {
>>       &trace_fn_event,
>>       &trace_ctx_event,
>> @@ -808,6 +879,7 @@ static struct trace_event *events[] __initdata = {
>>       &trace_stack_event,
>>       &trace_user_stack_event,
>>       &trace_print_event,
>> +     &trace_bprintk_event,
>>       NULL
>>  };
>>
>
>
> Just for curiosity. Why do you need such a binary tracing?
> Do you need it because a string output is really too slow for your needs?

warning: I haven't looked at the patch details

But I would love to use something like this to provide the exact
contents the userspace blktrace utilities want.

- Arnaldo
