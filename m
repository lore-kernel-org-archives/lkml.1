Return-Path: <linux-kernel-owner+w=401wt.eu-S1758969AbZEFK61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758969AbZEFK61 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 06:58:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752710AbZEFK6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 06:58:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39980 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753502AbZEFK6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 06:58:16 -0400
Date: Wed, 6 May 2009 12:57:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@lst.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>
Cc: cbe-oss-dev@ozlabs.org, srostedt@redhat.com, linux-kernel@vger.kernel.org,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH, RFC] sputrace: use the generic event tracer
Message-ID: <20090506105748.GE25203@elte.hu>
References: <20090506102918.GA23278@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090506102918.GA23278@lst.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


(Note: please Cc all tracing related patches to lkml.)

* Christoph Hellwig <hch@lst.de> wrote:

> I wrote sputrace before generic tracing infrastrucure was 
> available. Now that we have the generic event tracer we can 
> convert it over and remove a lot of code:
> 
>   8 files changed, 45 insertions(+), 285 deletions(-)

Nice! Needs also an Ack from PowerPC folks before we can do this. 
The cross section to other powerpc code seems to be rather low.

A few comments:

> To use it make sure CONFIG_EVENT_TRACING is enabled and then enable
> the spufs trace channel by
> 
>   echo 1 > /sys/kernel/debug/tracing/events/spufs/spufs_context
> 
> and then read the trace records using e.g.
> 
>   cat /sys/kernel/debug/tracing/trace
> 
> 
> Note that the patch is ontop of the current tracing tree
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git#tracing/ftrace
> 
> as there have been some TRACE_EVENT changes in there that aren't in
> mainline yet.
> 
> I don't have any cell hardware anymore so this is only compile tested.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6-tip/arch/powerpc/platforms/cell/spufs/sputrace.h
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6-tip/arch/powerpc/platforms/cell/spufs/sputrace.h	2009-05-06 10:17:20.000000000 +0000
> @@ -0,0 +1,39 @@
> +#if !defined(_TRACE_SPUFS_H) || defined(TRACE_HEADER_MULTI_READ)
> +#define _TRACE_SPUFS_H
> +
> +#include <linux/tracepoint.h>
> +
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM spufs
> +
> +TRACE_EVENT(spufs_context,
> +	TP_PROTO(struct spu_context *ctx, struct spu *spu, const char *name),
> +	TP_ARGS(ctx, spu, name),
> +
> +	TP_STRUCT__entry(
> +		__field(int, owner_tid)
> +		__field(const char *, name)
> +		__field(int, number)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->owner_tid = ctx->tid;
> +		__entry->name = name;
> +		__entry->number = spu ? spu->number : -1;
> +	),
> +
> +	TP_printk("%s (ctxthread = %d, spu = %d)",
> +		__entry->name, __entry->owner_tid, __entry->number)

Please keep the natural field ordering that is visible in the output 
format:

		__field(const char *, name)
		__field(int, owner_tid)
		__field(int, number)

This also has the advantage of (potentially) compressing the trace 
entry some more, as two int's are now following each other. The 
original sputrace record format had this order:

struct sputrace {
	ktime_t tstamp;
	int owner_tid; /* owner */
	int curr_tid;
	const char *name;
	int number;
};

There 'name' and 'curr_tid' was probably flipped around because 
'curr_tid' was there too. In the event tracer the PID is at the head 
of the record.

> +);
> +
> +#define spu_context_trace(name, ctx, spu) \
> +	trace_spufs_context(ctx, spu, __stringify(name))
> +#define spu_context_nospu_trace(name, ctx) \
> +	trace_spufs_context(ctx, NULL, __stringify(name))
> +
> +#endif /* _TRACE_SPUFS_H */
> +
> +#undef TRACE_INCLUDE_PATH
> +#define TRACE_INCLUDE_PATH .
> +#define TRACE_INCLUDE_FILE sputrace
> +#include <trace/define_trace.h>
> Index: linux-2.6-tip/arch/powerpc/platforms/cell/spufs/spufs.h
> ===================================================================
> --- linux-2.6-tip.orig/arch/powerpc/platforms/cell/spufs/spufs.h	2009-05-06 10:14:40.000000000 +0000
> +++ linux-2.6-tip/arch/powerpc/platforms/cell/spufs/spufs.h	2009-05-06 10:20:14.000000000 +0000
> @@ -373,9 +373,4 @@
>  extern void spuctx_switch_state(struct spu_context *ctx,
>  		enum spu_utilization_state new_state);
>  
> -#define spu_context_trace(name, ctx, spu) \
> -	trace_mark(name, "ctx %p spu %p", ctx, spu);
> -#define spu_context_nospu_trace(name, ctx) \
> -	trace_mark(name, "ctx %p", ctx);
> -
>  #endif
> Index: linux-2.6-tip/arch/powerpc/platforms/cell/Kconfig
> ===================================================================
> --- linux-2.6-tip.orig/arch/powerpc/platforms/cell/Kconfig	2009-05-06 10:17:46.000000000 +0000
> +++ linux-2.6-tip/arch/powerpc/platforms/cell/Kconfig	2009-05-06 10:17:50.000000000 +0000
> @@ -77,13 +77,6 @@
>  	  uses 4K pages. This can improve performances of applications
>  	  using multiple SPEs by lowering the TLB pressure on them.
>  
> -config SPU_TRACE
> -	tristate "SPU event tracing support"
> -	depends on SPU_FS && MARKERS
> -	help
> -	  This option allows reading a trace of spu-related events through
> -	  the sputrace file in procfs.

I think we should keep this option around.

> -
>  config SPU_BASE
>  	bool
>  	default n
> Index: linux-2.6-tip/arch/powerpc/platforms/cell/spufs/Makefile
> ===================================================================
> --- linux-2.6-tip.orig/arch/powerpc/platforms/cell/spufs/Makefile	2009-05-06 10:17:56.000000000 +0000
> +++ linux-2.6-tip/arch/powerpc/platforms/cell/spufs/Makefile	2009-05-06 10:22:23.000000000 +0000
> @@ -4,7 +4,8 @@
>  spufs-y += sched.o backing_ops.o hw_ops.o run.o gang.o
>  spufs-y += switch.o fault.o lscsa_alloc.o
>  
> -obj-$(CONFIG_SPU_TRACE)	+= sputrace.o
> +# magic for the trace events
> +CFLAGS_sched.o := -I$(src)

Steve, i'm wondering whether this type of Makefile hackery (caused 
by modular tracepoints) could be eliminated ...

Anyway, nice patch!

	Ingo
