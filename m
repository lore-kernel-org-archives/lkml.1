Return-Path: <linux-kernel-owner+w=401wt.eu-S1754081AbXLGKel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081AbXLGKel (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 05:34:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751406AbXLGKec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 05:34:32 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51668 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751385AbXLGKeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 05:34:31 -0500
Date: Fri, 7 Dec 2007 02:32:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stefano Brivio <stefano.brivio@polimi.it>, Robert Love <rml@tech9.net>,
       linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Michael Buesch <mb@bu3sch.de>,
       Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] scheduler: fix x86 regression in native_sched_clock
Message-Id: <20071207023241.15274ef6.akpm@linux-foundation.org>
In-Reply-To: <20071207084559.GA11162@elte.hu>
References: <20071207021952.6f0ac922@morte>
	<20071207084559.GA11162@elte.hu>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Dec 2007 09:45:59 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Stefano Brivio <stefano.brivio@polimi.it> wrote:
> 
> > This patch fixes a regression introduced by:
> > 
> > commit bb29ab26863c022743143f27956cc0ca362f258c
> > Author: Ingo Molnar <mingo@elte.hu>
> > Date:   Mon Jul 9 18:51:59 2007 +0200
> > 
> > This caused the jiffies counter to leap back and forth on cpufreq 
> > changes on my x86 box. I'd say that we can't always assume that TSC 
> > does "small errors" only, when marked unstable. On cpufreq changes 
> > these errors can be huge.
> 
> ah, printk_clock() still uses sched_clock(), not jiffies. So it's not 
> the jiffies counter that goes back and forth, it's sched_clock() - so 
> this is a printk timestamps anomaly, not related to jiffies. I thought 
> we have fixed this bug in the printk code already: sched_clock() is a 
> 'raw' interface that should not be used directly - the proper interface 
> is cpu_clock(cpu). Does the patch below help?
> 
> 	Ingo
> 
> ----------------------->
> Subject: sched: fix CONFIG_PRINT_TIME's reliance on sched_clock()
> From: Ingo Molnar <mingo@elte.hu>
> 
> Stefano Brivio reported weird printk timestamp behavior during
> CPU frequency changes:
> 
>   http://bugzilla.kernel.org/show_bug.cgi?id=9475
> 
> fix CONFIG_PRINT_TIME's reliance on sched_clock() and use cpu_clock()
> instead.
> 
> Reported-and-bisected-by: Stefano Brivio <stefano.brivio@polimi.it>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  kernel/printk.c |    2 +-
>  kernel/sched.c  |    7 ++++++-
>  2 files changed, 7 insertions(+), 2 deletions(-)
> 
> Index: linux/kernel/printk.c
> ===================================================================
> --- linux.orig/kernel/printk.c
> +++ linux/kernel/printk.c
> @@ -680,7 +680,7 @@ asmlinkage int vprintk(const char *fmt, 
>  					loglev_char = default_message_loglevel
>  						+ '0';
>  				}
> -				t = printk_clock();
> +				t = cpu_clock(printk_cpu);
>  				nanosec_rem = do_div(t, 1000000000);
>  				tlen = sprintf(tbuf,
>  						"<%c>[%5lu.%06lu] ",

A bit risky - it's quite an expansion of code which no longer can call printk.

You might want to take that WARN_ON out of __update_rq_clock() ;)

