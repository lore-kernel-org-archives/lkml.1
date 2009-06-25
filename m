Return-Path: <linux-kernel-owner+w=401wt.eu-S1758365AbZFYCT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758365AbZFYCT7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 22:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755624AbZFYCTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 22:19:45 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62567 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757431AbZFYCTo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 22:19:44 -0400
Message-ID: <4A42DEF9.4020506@cn.fujitsu.com>
Date: Thu, 25 Jun 2009 10:20:41 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>
CC: linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@elte.hu,
       laijs@cn.fujitsu.com, rostedt@goodmis.org, peterz@infradead.org,
       mathieu.desnoyers@polymtl.ca, jiayingz@google.com, mbligh@google.com,
       roland@redhat.com, fche@redhat.com
Subject: Re: [PATCH 3/7] V2 add syscall tracepoints
References: <cover.1245770664.git.jbaron@redhat.com> <df45ccb4905bff0e49d11386b44b0eb23034e83c.1245770664.git.jbaron@redhat.com>
In-Reply-To: <df45ccb4905bff0e49d11386b44b0eb23034e83c.1245770664.git.jbaron@redhat.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -#define DECLARE_TRACE(name, proto, args)				\
> +#define DECLARE_TRACE_WITH_CALLBACK(name, proto, args, reg, unreg)	\
>  	extern struct tracepoint __tracepoint_##name;			\
>  	static inline void trace_##name(proto)				\
>  	{								\
> @@ -71,13 +73,29 @@ struct tracepoint {
>  	}								\
>  	static inline int register_trace_##name(void (*probe)(proto))	\
>  	{								\
> -		return tracepoint_probe_register(#name, (void *)probe);	\
> +		int ret;						\
> +		void (*func)(void) = (void (*)(void))reg;		\

The explicit cast seems unnecessary.

> +									\
> +		ret = tracepoint_probe_register(#name, (void *)probe);	\
> +		if (func && !ret)					\
> +			func();						\
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
> +	DECLARE_TRACE_WITH_CALLBACK(name, TP_PROTO(proto), TP_ARGS(args), 0, 0);

I think DECLARE_TRACE_WITH_CALLBACK(..., NULL, NULL) is better.

> +
>  #define DEFINE_TRACE(name)						\
>  	static const char __tpstrtab_##name[]				\
>  	__attribute__((section("__tracepoints_strings"))) = #name;	\
> @@ -94,7 +112,7 @@ extern void tracepoint_update_probe_range(struct tracepoint *begin,
>  	struct tracepoint *end);
>  
>  #else /* !CONFIG_TRACEPOINTS */
> -#define DECLARE_TRACE(name, proto, args)				\
> +#define DECLARE_TRACE_WITH_CALLBACK(name, proto, args, reg, unreg)	\
>  	static inline void _do_trace_##name(struct tracepoint *tp, proto) \
>  	{ }								\
>  	static inline void trace_##name(proto)				\
> @@ -108,6 +126,9 @@ extern void tracepoint_update_probe_range(struct tracepoint *begin,
>  		return -ENOSYS;						\
>  	}
>  
> +#define DECLARE_TRACE(name, proto, args)                \
> +	DECLARE_TRACE_WITH_CALLBACK(name, TP_PROTO(proto), TP_ARGS(args), 0, 0);

ditto

> +
>  #define DEFINE_TRACE(name)
>  #define EXPORT_TRACEPOINT_SYMBOL_GPL(name)
>  #define EXPORT_TRACEPOINT_SYMBOL(name)


