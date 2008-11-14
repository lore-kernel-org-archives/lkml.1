Return-Path: <linux-kernel-owner+w=401wt.eu-S1752407AbYKNLyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407AbYKNLyb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 06:54:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751235AbYKNLyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 06:54:22 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:46977 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbYKNLyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 06:54:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=sJ//KfEuyExwojLVcmOt40kPp3ilppmvUppqVojU8Psuxc+46gk4Lxq2TrLjJLR3TZ
         THYSQ6u+qCHkzGSSSDx/dT9Fph7BImafpHBhgDhMuyEPb+se+aC4PTRS3AFrdwRw8m6p
         GTJ6W1GBpVVXcv34oSmpBg9F5gxkXvRCib6Zk=
Message-ID: <c62985530811140354n4645aa25ydb316aa72a566b2d@mail.gmail.com>
Date: Fri, 14 Nov 2008 12:54:19 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/3] ftrace: Add debug_dump trace to dump binary data from kernel to userspace
Cc: rostedt@goodmis.org, mingo@elte.hu, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1226659566-28168-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1226659566-28168-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1226659566-28168-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1226659566-28168-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/14 Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>:
> +struct trace_array *trace_get_global_trace(void)
> +{
> +       return &global_trace;
> +}


I'm not sure this is necessary to export the global_trace.
It is transmitted through init callback of a tracer (struct trace_array *tr).
You have a ctx_trace that you make pointing to global_trace using tr.
And after that you never use it.
That would be better to use your ctx_trace instead of exporting such function.

> +int debug_dump(void *bin_data, int len)
> +{
> +       struct ring_buffer_event *event;
> +       struct trace_array *tr;
> +       struct trace_array_cpu *data;
> +       struct dump_entry *entry;
> +       unsigned long flags, irq_flags;
> +       int cpu, size, pc;
> +
> +       if (!tracer_enabled)
> +               return 0;
> +       tr = trace_get_global_trace();
> +       pc = preempt_count();
> +       preempt_disable_notrace();
> +       cpu = raw_smp_processor_id();
> +       data = tr->data[cpu];
> +
> +       local_irq_save(flags);
> +       size = sizeof(*entry) + len;
> +       event = ring_buffer_lock_reserve(tr->buffer, size, &irq_flags);
> +       if (!event)
> +               goto out;
> +       entry = ring_buffer_event_data(event);
> +       tracing_generic_entry_update(&entry->ent, flags, pc);
> +       entry->ent.type = TRACE_BIN_DUMP;
> +       entry->len      = len;
> +
> +       memcpy(&entry->buf, bin_data, len);
> +       ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
> +
> +out:
> +       local_irq_restore(flags);
> +       preempt_enable_notrace();
> +
> +       return len;
> +}
> +EXPORT_SYMBOL_GPL(debug_dump);


I don't think this is necessary here to protect against preemption or
interrupts.
IE: it is necessary for function tracing to avoid recursion. But for
other usual cases
I think this it is not needed. If you thought about protecting the
ring buffer, it is already
able to protect itself :-)


> +static void dd_trace_ctrl_update(struct trace_array *tr)
> +{
> +       /* When starting a new trace, reset the buffers */
> +       if (tr->ctrl)
> +               start_dd_trace(tr);
> +       else
> +               stop_dd_trace(tr);
> +}


As I said, this callback recently disappeared.


> +
> +#ifdef CONFIG_NOP_TRACER
> +int
> +trace_selftest_startup_dd(struct tracer *trace, struct trace_array *tr)
> +{
> +       /* What could possibly go wrong? */
> +       return 0;
> +}
> +#endif


NOP_TRACER...copy-pasting is not always our friend... :-)


> +static enum print_line_t debug_dump_entry(struct trace_iterator *iter)
> +{
> +       struct trace_seq *s = &iter->seq;
> +       struct trace_entry *entry;
> +
> +       entry = iter->ent;
> +       switch (entry->type) {
> +       case TRACE_BIN_DUMP: {
> +               struct dump_entry *field;
> +               trace_assign_type(field, entry);
> +               trace_seq_putmem(s, field->buf, field->len);
> +               break;


Don't forget the TRACE_TYPE_PRINT_LINE...
