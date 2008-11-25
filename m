Return-Path: <linux-kernel-owner+w=401wt.eu-S1753201AbYKYKjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201AbYKYKjp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 05:39:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752509AbYKYKjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 05:39:37 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:14293 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500AbYKYKjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 05:39:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=LljDQoFOpCN6Qf0U7efTgEPD0cO92Qg8QeBKo7yle47dfKfUY4cNCuE2I32ZYPzP9b
         GMIHDMXtlO5JxzT7PdvYx241AU5+vo9GJ75fNA5RdSAd30MVewUbcurwk3O5uQxIJWIZ
         pfoHGN/GkIUm2eoy9eB/gLLdRjj3gs2fQnWSA=
Message-ID: <c62985530811250239v4a51cd1p4de5f1616a41ef36@mail.gmail.com>
Date: Tue, 25 Nov 2008 11:39:35 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Markus Metzger" <markus.t.metzger@intel.com>
Subject: Re: [patch 9/9] x86, bts, ftrace: a BTS ftrace plug-in prototype
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de, markus.t.metzger@gmail.com, roland@redhat.com,
       akpm@linux-foundation.org, mtk.manpages@gmail.com,
       eranian@googlemail.com, juan.villacis@intel.com,
       "Andi Kleen" <andi@firstfloor.org>
In-Reply-To: <20081125092415.A31432@sedona.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081125092415.A31432@sedona.ch.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Markus,

2008/11/25 Markus Metzger <markus.t.metzger@intel.com>:
> +static enum print_line_t bts_trace_print_line(struct trace_iterator *iter)
> +{
> +       struct trace_entry *entry = iter->ent;
> +       struct trace_seq *seq = &iter->seq;
> +       struct bts_entry *it;
> +
> +       trace_assign_type(it, entry);
> +
> +       if (entry->type == TRACE_BTS) {
> +               int ret;
> +#ifdef CONFIG_KALLSYMS
> +               char function[KSYM_SYMBOL_LEN];
> +               sprint_symbol(function, it->from);
> +#else
> +               char *function = "<unknown>";
> +#endif
> +
> +               ret = trace_seq_printf(seq, "%4d  0x%lx -> 0x%lx [%s]\n",
> +                                      entry->cpu, it->from, it->to, function);


You can use seq_print_ip_sym() which handles the ifdef and the sprint_symbol...


> +void trace_bts(struct trace_array *tr, unsigned long from, unsigned long to)
> +{
> +       struct ring_buffer_event *event;
> +       struct bts_entry *entry;
> +       unsigned long irq;
> +
> +       event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry), &irq);
> +       if (!event)
> +               return;
> +       entry   = ring_buffer_event_data(event);
> +       tracing_generic_entry_update(&entry->ent, 0, from);
> +       entry->ent.type = TRACE_BTS;
> +       entry->ent.cpu = smp_processor_id();


If you look at the struct trace_entry, you will see find the cpu
field. It is already inserted automatically :-)
