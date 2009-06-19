Return-Path: <linux-kernel-owner+w=401wt.eu-S1758625AbZFSCAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758625AbZFSCAK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 22:00:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753011AbZFSB76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 21:59:58 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:64015 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693AbZFSB75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 21:59:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Z+yG3SQ5gTIUmNNGTb+/d0mUJF75l2evjbxXehUigUBh5N6G8kwKF0LFBR7rkIxiIB
         Z2cIs33tTwSoweVM+cGYs/yhwBzd/dsgiQBCS9r7dbrNZ2Lb0/ZT942XaTn7wl8GRwEr
         uHFs7YiFhYUgijsEUpcV1tieYe02xMvz37pWg=
Date: Fri, 19 Jun 2009 03:59:55 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, mathieu.desnoyers@polymtl.ca,
       jiayingz@google.com, bligh@google.com, roland@redhat.com,
       fche@redhat.com
Subject: Re: [PATCH 3/7] add syscall tracepoints
Message-ID: <20090619015954.GA7903@nowhere>
References: <cover.1244837725.git.jbaron@redhat.com> <0ee4090012cf46f25d8cd8b022746a43b99d5767.1244837725.git.jbaron@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0ee4090012cf46f25d8cd8b022746a43b99d5767.1244837725.git.jbaron@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12, 2009 at 05:24:49PM -0400, Jason Baron wrote:
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



May be it deserves a comment? DECLARE_TRACE_REG() as a name is not enough
obvious on its own :)

Thanks,
Frederic.




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

