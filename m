Return-Path: <linux-kernel-owner+w=401wt.eu-S934316AbZFLV5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934316AbZFLV5m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 17:57:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756878AbZFLV5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 17:57:34 -0400
Received: from tomts38.bellnexxia.net ([209.226.175.95]:43661 "EHLO
	tomts38-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755468AbZFLV5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 17:57:33 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmQFAINsMkpMQW1W/2dsb2JhbACBT85fhAsF
Date: Fri, 12 Jun 2009 17:57:26 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@elte.hu,
       laijs@cn.fujitsu.com, rostedt@goodmis.org, peterz@infradead.org,
       jiayingz@google.com, bligh@google.com, roland@redhat.com,
       fche@redhat.com
Subject: Re: [PATCH 3/7] add syscall tracepoints
Message-ID: <20090612215726.GA9177@Krystal>
References: <cover.1244837725.git.jbaron@redhat.com> <0ee4090012cf46f25d8cd8b022746a43b99d5767.1244837725.git.jbaron@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <0ee4090012cf46f25d8cd8b022746a43b99d5767.1244837725.git.jbaron@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 17:56:16 up 104 days, 18:22,  5 users,  load average: 0.17, 0.46,
	0.54
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jason Baron (jbaron@redhat.com) wrote:
> 
> Introduce a new 'DECLARE_TRACE_REG()' macro, so that tracepoints can associate
> an external register/unregister function.
> 
> 
> Signed-off-by: Jason Baron <jbaron@redhat.com>
> 
> ---
>  include/linux/tracepoint.h |   27 +++++++++++++++++++++++----
>  1 files changed, 23 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
> index 14df7e6..9a3660b 100644
> --- a/include/linux/tracepoint.h
> +++ b/include/linux/tracepoint.h
> @@ -61,7 +61,7 @@ struct tracepoint {
>   * not add unwanted padding between the beginning of the section and the
>   * structure. Force alignment to the same alignment as the section start.
>   */
> -#define DECLARE_TRACE(name, proto, args)				\
> +#define DECLARE_TRACE_REG(name, proto, args, reg, unreg)		\
>  	extern struct tracepoint __tracepoint_##name;			\
>  	static inline void trace_##name(proto)				\
>  	{								\
> @@ -71,13 +71,29 @@ struct tracepoint {
>  	}								\
>  	static inline int register_trace_##name(void (*probe)(proto))	\
>  	{								\
> -		return tracepoint_probe_register(#name, (void *)probe);	\
> +		int ret;						\
> +		void (*func)(void) = (void (*)(void))reg;		\
> +									\
> +		ret = tracepoint_probe_register(#name, (void *)probe);	\
> +		if (func && !ret)					\
> +			func();						\

I don't see why you need to add this weird interface when all you really
need to do is to call the function to set the TIF flags explicitly in
reg_event_syscall_enter when registering a tracepoint.

Mathieu

> +		return ret;						\
>  	}								\
>  	static inline int unregister_trace_##name(void (*probe)(proto))	\
>  	{								\
> -		return tracepoint_probe_unregister(#name, (void *)probe);\
> +		int ret;						\
> +		void (*func)(void) = (void (*)(void))unreg;		\
> +									\
> +		ret = tracepoint_probe_unregister(#name, (void *)probe);\
> +		if (func && !ret)					\
> +			func();						\
> +		return ret;						\
>  	}
>  
> +
> +#define DECLARE_TRACE(name, proto, args)		\
> +	DECLARE_TRACE_REG(name, TP_PROTO(proto), TP_ARGS(args), 0, 0);
> +
>  #define DEFINE_TRACE(name)						\
>  	static const char __tpstrtab_##name[]				\
>  	__attribute__((section("__tracepoints_strings"))) = #name;	\
> @@ -94,7 +110,7 @@ extern void tracepoint_update_probe_range(struct tracepoint *begin,
>  	struct tracepoint *end);
>  
>  #else /* !CONFIG_TRACEPOINTS */
> -#define DECLARE_TRACE(name, proto, args)				\
> +#define DECLARE_TRACE_REG(name, proto, args, reg, unreg)		\
>  	static inline void _do_trace_##name(struct tracepoint *tp, proto) \
>  	{ }								\
>  	static inline void trace_##name(proto)				\
> @@ -108,6 +124,9 @@ extern void tracepoint_update_probe_range(struct tracepoint *begin,
>  		return -ENOSYS;						\
>  	}
>  
> +#define DECLARE_TRACE(name, proto, args)                \
> +	DECLARE_TRACE_REG(name, TP_PROTO(proto), TP_ARGS(args), 0, 0);
> +
>  #define DEFINE_TRACE(name)
>  #define EXPORT_TRACEPOINT_SYMBOL_GPL(name)
>  #define EXPORT_TRACEPOINT_SYMBOL(name)
> -- 
> 1.6.0.6
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
