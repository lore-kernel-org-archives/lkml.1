Return-Path: <linux-kernel-owner+w=401wt.eu-S1764041AbXFKA1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764041AbXFKA1p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 20:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760668AbXFKA1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 20:27:39 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:60999 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760576AbXFKA1i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 20:27:38 -0400
Date: Mon, 11 Jun 2007 09:26:14 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Chris Wright <chrisw@sous-sol.org>, Adam Belay <abelay@novell.com>,
       Len Brown <lenb@kernel.org>, Dave Miller <davem@davemloft.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [patch-mm 01/23] NOHZ: Fix ARM,SH,SPARC64 idle nohz handling
Message-ID: <20070611002614.GA20676@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
	Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
	Arjan van de Ven <arjan@infradead.org>,
	Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
	Chris Wright <chrisw@sous-sol.org>, Adam Belay <abelay@novell.com>,
	Len Brown <lenb@kernel.org>, Dave Miller <davem@davemloft.net>,
	Russell King <rmk+kernel@arm.linux.org.uk>
References: <20070610092437.118387863@inhelltoy.tec.linutronix.de> <20070610092446.402212606@inhelltoy.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070610092446.402212606@inhelltoy.tec.linutronix.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 10, 2007 at 09:43:59AM -0000, Thomas Gleixner wrote:
> Index: linux-2.6.22-rc4-mm/arch/sh/kernel/process.c
> ===================================================================
> --- linux-2.6.22-rc4-mm.orig/arch/sh/kernel/process.c	2007-06-10 10:44:38.000000000 +0200
> +++ linux-2.6.22-rc4-mm/arch/sh/kernel/process.c	2007-06-10 10:44:38.000000000 +0200
> @@ -62,8 +62,10 @@ void default_idle(void)
>  		clear_thread_flag(TIF_POLLING_NRFLAG);
>  		smp_mb__after_clear_bit();
>  		set_bl_bit();
> -		while (!need_resched())
> +		while (!need_resched()) {
> +			tick_nohz_stop_sched_tick();
>  			cpu_sleep();
> +		}
>  		clear_bl_bit();
>  		set_thread_flag(TIF_POLLING_NRFLAG);
>  	} else
> @@ -82,7 +84,6 @@ void cpu_idle(void)
>  		if (!idle)
>  			idle = default_idle;
>  
> -		tick_nohz_stop_sched_tick();
>  		while (!need_resched())
>  			idle();
>  		tick_nohz_restart_sched_tick();

There are two paths here depending on hlt/nohlt setting, we need to have
tick_nohz_stop_sched_tick() for the TIF_POLLING_NRFLAG case, too.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

--

diff --git a/arch/sh/kernel/process.c b/arch/sh/kernel/process.c
index a11e2aa..42e156b 100644
--- a/arch/sh/kernel/process.c
+++ b/arch/sh/kernel/process.c
@@ -62,13 +62,17 @@ void default_idle(void)
 		clear_thread_flag(TIF_POLLING_NRFLAG);
 		smp_mb__after_clear_bit();
 		set_bl_bit();
-		while (!need_resched())
+		while (!need_resched()) {
+			tick_nohz_stop_sched_tick();
 			cpu_sleep();
+		}
 		clear_bl_bit();
 		set_thread_flag(TIF_POLLING_NRFLAG);
 	} else
-		while (!need_resched())
+		while (!need_resched()) {
+			tick_nohz_stop_sched_tick();
 			cpu_relax();
+		}
 }
 
 void cpu_idle(void)
@@ -82,7 +86,6 @@ void cpu_idle(void)
 		if (!idle)
 			idle = default_idle;
 
-		tick_nohz_stop_sched_tick();
 		while (!need_resched())
 			idle();
 		tick_nohz_restart_sched_tick();
