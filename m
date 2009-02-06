Return-Path: <linux-kernel-owner+w=401wt.eu-S1760319AbZBFHSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760319AbZBFHSe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 02:18:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757480AbZBFHMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 02:12:50 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58599 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758544AbZBFHMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 02:12:49 -0500
Date: Thu, 5 Feb 2009 23:12:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/4] nmi: add generic nmi tracking state
Message-Id: <20090205231215.412def47.akpm@linux-foundation.org>
In-Reply-To: <20090206065437.986292747@goodmis.org>
References: <20090206065352.940088243@goodmis.org>
	<20090206065437.986292747@goodmis.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Feb 2009 01:53:54 -0500 Steven Rostedt <rostedt@goodmis.org> wrote:

> From: Steven Rostedt <srostedt@redhat.com>
> 
> This code adds an in_nmi() macro that uses the current tasks preempt count
> to track when it is in NMI context. Other parts of the kernel can
> use this to determine if the context is in NMI context or not.
> 
> This code was inspired by the -rt patch in_nmi version that was
> written by Peter Zijlstra.
> 
> Reported-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  include/linux/hardirq.h |   15 +++++++++++++++
>  1 files changed, 15 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
> index f832883..f3cf86e 100644
> --- a/include/linux/hardirq.h
> +++ b/include/linux/hardirq.h
> @@ -61,6 +61,12 @@
>  #error PREEMPT_ACTIVE is too low!
>  #endif
>  
> +#define NMI_OFFSET	(PREEMPT_ACTIVE << 1)
> +
> +#if NMI_OFFSET >= 0x80000000
> +#error PREEMPT_ACTIVE too high!
> +#endif
> +
>  #define hardirq_count()	(preempt_count() & HARDIRQ_MASK)
>  #define softirq_count()	(preempt_count() & SOFTIRQ_MASK)
>  #define irq_count()	(preempt_count() & (HARDIRQ_MASK | SOFTIRQ_MASK))
> @@ -73,6 +79,11 @@
>  #define in_softirq()		(softirq_count())
>  #define in_interrupt()		(irq_count())
>  
> +/*
> + * Are we in NMI context?
> + */
> +#define in_nmi()	(preempt_count() & NMI_OFFSET)
> +
>  #if defined(CONFIG_PREEMPT)
>  # define PREEMPT_INATOMIC_BASE kernel_locked()
>  # define PREEMPT_CHECK_OFFSET 1
> @@ -167,6 +178,8 @@ extern void irq_exit(void);
>  #define nmi_enter()				\
>  	do {					\
>  		ftrace_nmi_enter();		\
> +		BUG_ON(in_nmi());		\
> +		add_preempt_count(NMI_OFFSET);	\
>  		lockdep_off();			\
>  		rcu_nmi_enter();		\
>  		__irq_enter();			\
> @@ -177,6 +190,8 @@ extern void irq_exit(void);
>  		__irq_exit();			\
>  		rcu_nmi_exit();			\
>  		lockdep_on();			\
> +		BUG_ON(!in_nmi());		\
> +		sub_preempt_count(NMI_OFFSET);	\
>  		ftrace_nmi_exit();		\
>  	} while (0)
>  

Well that was tidy.

We're sure that no present or future architecture will for some weird
reason nest NMIs?

