Return-Path: <linux-kernel-owner+w=401wt.eu-S1757114AbYEWURQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757114AbYEWURQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 16:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754528AbYEWURA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 16:17:00 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:22259 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871AbYEWUQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 16:16:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ljKmXdcDbYpZDQ0HdyyZOEGSDmvi8Gr80mNDu2HMYr1BIe5jGu0c7wobMTduuslE0ceGfKoBW9famcRiWUTmf7oLWb0xs9qanlm3P6JI6yP1T5JXN6bGIotQO+Ze1nQr6z5HoQ1w8+gXudjyJ5CmUCuAAB8qS2+cHZuIfXeKqtQ=
Message-ID: <19f34abd0805231316m6432b373s594c794bfdd48183@mail.gmail.com>
Date: Fri, 23 May 2008 22:16:58 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] kmemcheck: use tasklets instead of timers
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080521213758.GB11061@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080521213758.GB11061@damson.getinternet.no>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops. Big mistake on my part. This patch was simply wrong :-(

On Wed, May 21, 2008 at 11:37 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> From: Vegard Nossum <vegard.nossum@gmail.com>
> Date: Wed, 21 May 2008 22:58:37 +0200
> Subject: [PATCH] kmemcheck: use tasklets instead of timers
>
> Instead of triggering a timer every HZ, we use the new tasklet function
> which guarantuees not to touch any other tasklets on the tasklet list,
> and is thus safe to use from the page fault handler.
>
> Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
> ---
>  arch/x86/kernel/kmemcheck.c |   16 ++++++++--------
>  1 files changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/arch/x86/kernel/kmemcheck.c b/arch/x86/kernel/kmemcheck.c
> index def1a08..c0045e8 100644
> --- a/arch/x86/kernel/kmemcheck.c
> +++ b/arch/x86/kernel/kmemcheck.c
> @@ -9,6 +9,7 @@
>  */
>
>  #include <linux/init.h>
> +#include <linux/interrupt.h>
>  #include <linux/kallsyms.h>
>  #include <linux/kdebug.h>
>  #include <linux/kernel.h>
> @@ -18,7 +19,6 @@
>  #include <linux/page-flags.h>
>  #include <linux/percpu.h>
>  #include <linux/stacktrace.h>
> -#include <linux/timer.h>
>
>  #include <asm/cacheflush.h>
>  #include <asm/kmemcheck.h>
> @@ -73,8 +73,6 @@ static unsigned int error_rd;
>  static unsigned int error_wr;
>  static unsigned int error_missed_count;
>
> -static struct timer_list kmemcheck_timer;
> -
>  static struct kmemcheck_error *error_next_wr(void)
>  {
>        struct kmemcheck_error *e;
> @@ -105,6 +103,9 @@ static struct kmemcheck_error *error_next_rd(void)
>        return e;
>  }
>
> +static void do_wakeup(unsigned long);
> +static DECLARE_TASKLET(kmemcheck_tasklet, &do_wakeup, 0);
> +
>  static void *address_get_shadow(unsigned long address);
>
>  /*
> @@ -148,6 +149,8 @@ static void error_save(enum shadow state,
>        BUG_ON(!shadow_copy);
>
>        memcpy(e->shadow_copy, shadow_copy, SHADOW_COPY_SIZE);
> +
> +       tasklet_hi_schedule(&kmemcheck_tasklet);

This should of course say tasklet_hi_schedule_first(), which was the
new function I introduced in the previous patch. Duh.

>  }
>
>  /*
> @@ -170,6 +173,8 @@ static void error_save_bug(struct pt_regs *regs)
>        e->trace.max_entries = ARRAY_SIZE(e->trace_entries);
>        e->trace.skip = 1;
>        save_stack_trace(&e->trace);
> +
> +       tasklet_hi_schedule(&kmemcheck_tasklet);

The same here...

>  }
>
>  static void error_recall(void)
> @@ -233,8 +238,6 @@ static void do_wakeup(unsigned long data)
>                        "the queue was too small\n", error_missed_count);
>                error_missed_count = 0;
>        }
> -
> -       mod_timer(&kmemcheck_timer, kmemcheck_timer.expires + HZ);
>  }
>
>  void __init kmemcheck_init(void)
> @@ -250,9 +253,6 @@ void __init kmemcheck_init(void)
>                setup_max_cpus = 1;
>        }
>  #endif
> -
> -       setup_timer(&kmemcheck_timer, &do_wakeup, 0);
> -       mod_timer(&kmemcheck_timer, jiffies + HZ);
>  }
>
>  #ifdef CONFIG_KMEMCHECK_DISABLED_BY_DEFAULT
> --
> 1.5.4.1
>
>

But even so, tasklet_hi_schedule_first() will call
raise_softirq_irqoff() which will call wakeup_softirqd() which will
call wake_up_process() which will do all sorts of badness like
accessing runqueues, etc., etc.

So forget all about the tasklet patches :-(

But thanks for the reviews... ;-)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
