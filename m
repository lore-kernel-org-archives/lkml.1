Return-Path: <linux-kernel-owner+w=401wt.eu-S1753754AbYFWXem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754AbYFWXem (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 19:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751680AbYFWXee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 19:34:34 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:38326 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751399AbYFWXed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 19:34:33 -0400
Subject: Re: [RFC PATCH] x86:Use cpu_khz for loops_per_jiffy calculation
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Daniel Hecht <dhecht@vmware.com>,
       Tim Mann <mann@vmware.com>, Zach Amsden <zach@vmware.com>,
       Sahil Rihan <srihan@vmware.com>
In-Reply-To: <20080623232149.GA22926@elte.hu>
References: <1212540069.19290.57.camel@promb-2n-dhcp368.eng.vmware.com>
	 <20080603182014.79a38d03@infradead.org>
	 <35f686220806032101h103152dat841818982aaa5052@mail.gmail.com>
	 <20080604061637.6bab3f67@infradead.org>
	 <1213924953.27983.52.camel@promb-2n-dhcp368.eng.vmware.com>
	 <20080620113922.GG7439@elte.hu>
	 <1213999593.31598.52.camel@promb-2n-dhcp368.eng.vmware.com>
	 <20080623232149.GA22926@elte.hu>
Content-Type: text/plain; charset=utf-8
Organization: VMware INC.
Date: Mon, 23 Jun 2008 16:34:30 -0700
Message-Id: <1214264070.3882.22.camel@promb-2n-dhcp368.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-06-23 at 16:21 -0700, Ingo Molnar wrote:
> * Alok Kataria <akataria@vmware.com> wrote:
> 
> > +     lpj = ((u64)tsc_khz * 1000);
> > +     do_div(lpj, HZ);
> > +     lpj_tsc = lpj;
> 
> this needed the fix below.
> 
> but there's another problem as well: why are generic files
> (init/calibrate.c and include/linux/delay.h) using something that is
> named in an x86-specific way - lpj_tsc ? (TSC is an x86 concept)
> 

calibrate_delay_direct was using some variables with "tsc" as the prefix
(tsc_rate_min/max) ...so i thought of using lpj_tsc. And also IMO,
lpj_tsc explains how is this variable initialized. But thinking about
it, maybe we should rename it to "lpj_timer" ?

Also, i still haven't got to testing today's tip tree in my environment,
will let you know as soon as i have done it. 

Thanks,
Alok
>         Ingo
> 
> ------------>
> commit 5cd5a41ea6f4363b03156e2208dd0d2266f0d67d
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Tue Jun 24 01:19:49 2008 +0200
> 
>     x86: fix "x86: use cpu_khz for loops_per_jiffy calculation"
> 
>     fix:
> 
>     arch/x86/kernel/tsc_32.c: In function ‘tsc_init':
>     arch/x86/kernel/tsc_32.c:421: error: ‘lpj_tsc' undeclared (first use in this function)
>     arch/x86/kernel/tsc_32.c:421: error: (Each undeclared identifier is reported only once
>     arch/x86/kernel/tsc_32.c:421: error: for each function it appears in.)
> 
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> diff --git a/arch/x86/kernel/tsc_32.c b/arch/x86/kernel/tsc_32.c
> index 4adac0d..bfb9193 100644
> --- a/arch/x86/kernel/tsc_32.c
> +++ b/arch/x86/kernel/tsc_32.c
> @@ -1,6 +1,7 @@
>  #include <linux/sched.h>
>  #include <linux/clocksource.h>
>  #include <linux/workqueue.h>
> +#include <linux/delay.h>
>  #include <linux/cpufreq.h>
>  #include <linux/jiffies.h>
>  #include <linux/init.h>

