Return-Path: <linux-kernel-owner+w=401wt.eu-S1753485AbZBQPjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485AbZBQPjm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 10:39:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751856AbZBQPjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 10:39:33 -0500
Received: from smtp-102-tuesday.noc.nerim.net ([62.4.17.102]:49947 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751365AbZBQPjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 10:39:32 -0500
Date: Tue, 17 Feb 2009 16:39:25 +0100
From: Damien Wyart <damien.wyart@free.fr>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #12650] Strange load average and ksoftirqd behavior with
	2.6.29-rc2-git1
Message-ID: <20090217153925.GA2308@localhost.localdomain>
References: <20090216122632.GA3158@elte.hu> <87ljs6pmao.fsf@free.fr> <20090216132151.GA17996@elte.hu> <20090216160613.GA6785@linux.vnet.ibm.com> <20090216185616.GB6785@linux.vnet.ibm.com> <20090216200923.GA28938@elte.hu> <20090216223944.GF6785@linux.vnet.ibm.com> <20090216225108.GA15904@linux.vnet.ibm.com> <20090217094657.GA1845@elte.hu> <20090217140130.GA6761@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090217140130.GA6761@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Paul,

> > There's no strong reason - we've been back and forth about RCU in
> > the dynticks code. Mind sending a test patch for Damien to try?

> But of course!  ;-)

With this patch, the problem goes away and system activity seems normal,
both on the P4 with high load and on the recent laptop.

Btw, could you explain briefly why, without this patch, a kernel
enabling classical RCU doesn't show the ksoftirqd problem at all?


Damien

> The following patch removes the call to rcu_pending() and
> rcu_check_callbacks() from the x86 32-bit idle loop in order to
> reduce the softirq load on idle systems.

> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---

>  process_32.c |    3 ---
>  1 file changed, 3 deletions(-)

> diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
> index a546f55..bd4da2a 100644
> --- a/arch/x86/kernel/process_32.c
> +++ b/arch/x86/kernel/process_32.c
> @@ -104,9 +104,6 @@ void cpu_idle(void)
>  			check_pgt_cache();
>  			rmb();

> -			if (rcu_pending(cpu))
> -				rcu_check_callbacks(cpu, 0);
> -
>  			if (cpu_is_offline(cpu))
>  				play_dead();
