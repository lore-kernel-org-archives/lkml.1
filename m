Return-Path: <linux-kernel-owner+w=401wt.eu-S1754839AbYLCEfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839AbYLCEfc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 23:35:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752730AbYLCEfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 23:35:23 -0500
Received: from mx2.redhat.com ([66.187.237.31]:42303 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751298AbYLCEfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 23:35:22 -0500
Subject: Re: [RFC PATCH 3/3] kernel tracing prototype
From: Steven Rostedt <srostedt@redhat.com>
To: Jiaying Zhang <jiayingz@google.com>
Cc: linux-kernel@vger.kernel.org, Michael Rubin <mrubin@google.com>,
       Martin Bligh <mbligh@google.com>, Michael Davidson <md@google.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <5df78e1d0812021626y68c7241ahfdba4d37c7840e10@mail.gmail.com>
References: <5df78e1d0812021626y68c7241ahfdba4d37c7840e10@mail.gmail.com>
Content-Type: text/plain
Organization: Red Hat
Date: Tue, 02 Dec 2008 23:35:08 -0500
Message-Id: <1228278908.4886.49.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-12-02 at 16:26 -0800, Jiaying Zhang wrote:
> Refer to the previous email 
> "[RFC PATCH 0/3] A couple of feature requests to the unified trace
> buffer".
> 
> A kernel tracing prototype that uses the unified trace buffer to keep
> the collected trace data.
> 

> Index: linux-2.6.26.2/include/linux/ktrace.h
> ===================================================================
> --- /dev/null   1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6.26.2/include/linux/ktrace.h       2008-11-25
> 11:32:37.000000000 -0800
> @@ -0,0 +1,73 @@
> +#ifndef _LINUX_KTRACE_H
> +#define _LINUX_KTRACE_H
> +
> +#include <linux/types.h>
> +
> +struct kernel_trace;
> +
> +typedef void ktrace_probe_func(struct kernel_trace *, void *,
> size_t);
> +
> +struct kernel_trace {
> +       const char      *name;
> +       const char      *format;  /* format string describing variable
> list */
> +       u32             enabled:1, event_id:31;
> +       ktrace_probe_func *func;  /* probe function */
> +       struct list_head list;  /* list head linked to the hash table
> entry */
> +} __attribute__((aligned(8)));
> +
> +extern int ktrace_enabled;
> +
> +/*
> + * Make sure the alignment of the structure in the __ktrace section
> will
> + * not add unwanted padding between the beginning of the section and
> the
> + * structure. Force alignment to the same alignment as the section
> start.
> + */
> +
> +#define DEFINE_KTRACE_STRUCT(name)     struct ktrace_struct_##name
> +
> +#ifdef CONFIG_KTRACE
> +#define DO_TRACE(name, format, args...)
>            \
> +       do {
>    \
> +               static const char __kstrtab_##name[]
>    \
> +               __attribute__((section("__ktrace_strings")))
>    \
> +               = #name "\0" format;
>    \
> +               static struct kernel_trace __ktrace_##name
>    \
> +               __attribute__((section("__ktrace"), aligned(8))) =
>    \
> +               { __kstrtab_##name, &__kstrtab_##name[sizeof(#name)],
> \
> +               0, 0, NULL, LIST_HEAD_INIT(__ktrace_##name.list) };
> \
> +               __ktrace_check_format(format, ## args);
> \
> +               if (unlikely(ktrace_enabled) &&
> \
> +                               unlikely(__ktrace_##name.enabled))
> {    \
> +                       struct ktrace_struct_##name karg = { args };
>    \
> +                       (*__ktrace_##name.func)
> \
> +                       (&__ktrace_##name, &karg, sizeof(karg));
>    \
> +               }
> \

This looks like another form of markers/trace-points.  Why not use them?

> +       } while (0)
> +
> +#else /* !CONFIG_KTRACE */
> +#define DO_TRACE(name, format, args...)
> +#endif
> +

-- Steve


