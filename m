Return-Path: <linux-kernel-owner+w=401wt.eu-S1757799AbYGXPIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757799AbYGXPIm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 11:08:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756624AbYGXPIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 11:08:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33493 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754157AbYGXPIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 11:08:20 -0400
Date: Thu, 24 Jul 2008 11:08:18 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [patch 02/17] Kernel Tracepoints
In-Reply-To: <20080715222746.361289615@polymtl.ca>
Message-ID: <Pine.LNX.4.58.0807241105280.14946@gandalf.stny.rr.com>
References: <20080715222604.331269462@polymtl.ca> <20080715222746.361289615@polymtl.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[Added Paul McKenney to CC]

On Tue, 15 Jul 2008, Mathieu Desnoyers wrote:
> +++ linux-2.6-lttng/include/linux/tracepoint.h	2008-07-15 17:35:19.000000000 -0400
> @@ -0,0 +1,127 @@
> +#ifndef _LINUX_TRACEPOINT_H
> +#define _LINUX_TRACEPOINT_H
> +
> +/*
> + * Kernel Tracepoint API.
> + *
> + * See Documentation/tracepoint.txt.
> + *
> + * (C) Copyright 2008 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> + *
> + * Heavily inspired from the Linux Kernel Markers.
> + *
> + * This file is released under the GPLv2.
> + * See the file COPYING for more details.
> + */
> +
> +#include <linux/types.h>
> +#include <linux/rcupdate.h>
> +
> +struct module;
> +struct tracepoint;
> +
> +struct tracepoint {
> +	const char *name;		/* Tracepoint name */
> +	int state;			/* State. */
> +	void **funcs;
> +} __attribute__((aligned(8)));
> +
> +
> +#define TPPROTO(args...)	args
> +#define TPARGS(args...)		args
> +
> +#ifdef CONFIG_TRACEPOINTS
> +
> +/*
> + * it_func[0] is never NULL because there is at least one element in the array
> + * when the array itself is non NULL.
> + */
> +#define __DO_TRACE(tp, proto, args)					\
> +	do {								\
> +		void **it_func;						\
> +									\
> +		rcu_read_lock_sched();					\
> +		it_func = rcu_dereference((tp)->funcs);			\
> +		if (it_func) {						\
> +			do {						\
> +				((void(*)(proto))(*it_func))(args);	\
> +			} while (*(++it_func));				\

OK, I still don't understand the concept of the rcu_dereference, but why
is it needed for the first assignment of it_func but not the ++? Is it
only needed with the (tp)->funcs?

-- Steve


> +		}							\
> +		rcu_read_unlock_sched();				\
> +	} while (0)

