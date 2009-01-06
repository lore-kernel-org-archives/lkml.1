Return-Path: <linux-kernel-owner+w=401wt.eu-S1753728AbZAFQji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728AbZAFQji (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 11:39:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751119AbZAFQj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 11:39:29 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43081 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846AbZAFQj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 11:39:28 -0500
Message-ID: <4963894B.6000705@redhat.com>
Date: Tue, 06 Jan 2009 11:39:39 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: Jim Keniston <jkenisto@us.ibm.com>, David Miller <davem@davemloft.net>,
       LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>
Subject: Re: [PATCH][bugfix] kprobes: fix module compilation error with CONFIG_KPROBES=n
References: <49628849.1000706@redhat.com>
In-Reply-To: <49628849.1000706@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops, this patch was actually for -mm tree.

Masami Hiramatsu wrote:
> Define kprobes related data structures even if CONFIG_KPROBES is not set.
> This fixes compilation errors which occur if CONFIG_KPROBES is not set, in
> kprobe using modules.
> 
> Reviewed-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> ---
>  include/linux/kprobes.h |   45 +++++++++++++++++++++++----------------------
>  1 file changed, 23 insertions(+), 22 deletions(-)
> 
> Index: 2.6.28/include/linux/kprobes.h
> ===================================================================
> --- 2.6.28.orig/include/linux/kprobes.h
> +++ 2.6.28/include/linux/kprobes.h
> @@ -37,9 +37,9 @@
>  #include <linux/spinlock.h>
>  #include <linux/rcupdate.h>
>  #include <linux/mutex.h>
> +#include <asm/kprobes.h>
> 
>  #ifdef CONFIG_KPROBES
> -#include <asm/kprobes.h>
> 
>  /* kprobe_status settings */
>  #define KPROBE_HIT_ACTIVE	0x00000001
> @@ -49,6 +49,9 @@
> 
>  /* Attach to insert probes on any functions which should be ignored*/
>  #define __kprobes	__attribute__((__section__(".kprobes.text"))) notrace
> +#else /* CONFIG_KPROBES */
> +#define __kprobes	notrace
> +#endif /* CONFIG_KPROBES */
> 
>  struct kprobe;
>  struct pt_regs;
> @@ -131,23 +134,6 @@ struct jprobe {
>  /* For backward compatibility with old code using JPROBE_ENTRY() */
>  #define JPROBE_ENTRY(handler)	(handler)
> 
> -DECLARE_PER_CPU(struct kprobe *, current_kprobe);
> -DECLARE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
> -
> -#ifdef CONFIG_KRETPROBES
> -extern void arch_prepare_kretprobe(struct kretprobe_instance *ri,
> -				   struct pt_regs *regs);
> -extern int arch_trampoline_kprobe(struct kprobe *p);
> -#else /* CONFIG_KRETPROBES */
> -static inline void arch_prepare_kretprobe(struct kretprobe *rp,
> -					struct pt_regs *regs)
> -{
> -}
> -static inline int arch_trampoline_kprobe(struct kprobe *p)
> -{
> -	return 0;
> -}
> -#endif /* CONFIG_KRETPROBES */
>  /*
>   * Function-return probe -
>   * Note:
> @@ -188,6 +174,25 @@ struct kprobe_blackpoint {
>  	unsigned long range;
>  };
> 
> +#ifdef CONFIG_KPROBES
> +DECLARE_PER_CPU(struct kprobe *, current_kprobe);
> +DECLARE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
> +
> +#ifdef CONFIG_KRETPROBES
> +extern void arch_prepare_kretprobe(struct kretprobe_instance *ri,
> +				   struct pt_regs *regs);
> +extern int arch_trampoline_kprobe(struct kprobe *p);
> +#else /* CONFIG_KRETPROBES */
> +static inline void arch_prepare_kretprobe(struct kretprobe *rp,
> +					struct pt_regs *regs)
> +{
> +}
> +static inline int arch_trampoline_kprobe(struct kprobe *p)
> +{
> +	return 0;
> +}
> +#endif /* CONFIG_KRETPROBES */
> +
>  extern struct kretprobe_blackpoint kretprobe_blacklist[];
> 
>  static inline void kretprobe_assert(struct kretprobe_instance *ri,
> @@ -264,10 +269,6 @@ void recycle_rp_inst(struct kretprobe_in
> 
>  #else /* CONFIG_KPROBES */
> 
> -#define __kprobes	notrace
> -struct jprobe;
> -struct kretprobe;
> -
>  static inline struct kprobe *get_kprobe(void *addr)
>  {
>  	return NULL;

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

