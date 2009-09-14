Return-Path: <linux-kernel-owner+w=401wt.eu-S1756179AbZINSAM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179AbZINSAM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 14:00:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756181AbZINSAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 14:00:08 -0400
Received: from mtagate5.de.ibm.com ([195.212.17.165]:33173 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756172AbZINSAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 14:00:06 -0400
Date: Mon, 14 Sep 2009 19:59:59 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jens Axboe <jens.axboe@oracle.com>, John Stultz <johnstul@us.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org
Subject: Re: [crash, bisected] Re: clocksource: Resolve cpu hotplug dead
 lock with TSC unstable
Message-ID: <20090914195959.5a14d3c4@skybase>
In-Reply-To: <20090914151958.GA17791@elte.hu>
References: <20090909122006.GA18599@kernel.dk>
	<1252565738.7205.29.camel@laptop>
	<20090910065856.GL18599@kernel.dk>
	<20090910073317.GP18599@kernel.dk>
	<20090910074902.GA10634@elte.hu>
	<20090910075357.GT18599@kernel.dk>
	<20090910100214.GB21314@elte.hu>
	<20090910180049.GA10579@elte.hu>
	<20090911073747.GA8209@elte.hu>
	<20090911153305.3fe9a361@skybase>
	<20090914151958.GA17791@elte.hu>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Sep 2009 17:19:58 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> Now another box crashes during bootup. Reverting these two:
> 
>  f79e025: clocksource: Resolve cpu hotplug dead lock with TSC unstable, fix crash
>  7285dd7: clocksource: Resolve cpu hotplug dead lock with TSC unstable
> 
> allows me to boot it.
> 
> plain 32-bit defconfig.

Ok, I forced the situation where the bad thing happens. With the patch below
the crash goes away.

[    0.152056] checking TSC synchronization [CPU#0 -> CPU#1]:
[    0.156001] Measured 0 cycles TSC warp between CPUs, turning off TSC clock.
[    0.156001] Marking TSC unstable due to check_tsc_sync_source failed

Is there a reason why we need the TSC as a clocksource early in the boot
process?

--
Subject: clocksource: delay tsc clocksource registration

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

Until the tsc clocksource has been registered it can be
downgraded by setting the CLOCK_SOURCE_UNSTABLE bit and the
rating to zero. Once the tsc clocksource is registered a
work queue is needed to change the rating.

Delay the registration of the tsc clocksource to a point in
the boot process after the work queues have been initialized.

This hopefully finally resolves the boot crash due to the
tsc downgrade.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: John Stultz <johnstul@us.ibm.com>
---

Index: linux-2.6-tip/arch/x86/kernel/tsc.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/tsc.c	2009-09-14 19:25:02.000000000 +0200
+++ linux-2.6-tip/arch/x86/kernel/tsc.c	2009-09-14 19:30:13.000000000 +0200
@@ -853,9 +853,16 @@
 		clocksource_tsc.rating = 0;
 		clocksource_tsc.flags &= ~CLOCK_SOURCE_IS_CONTINUOUS;
 	}
+}
+
+static int __init register_tsc_clocksource(void)
+{
 	clocksource_register(&clocksource_tsc);
+	return 0;
 }
 
+core_initcall(register_tsc_clocksource);
+
 #ifdef CONFIG_X86_64
 /*
  * calibrate_cpu is used on systems with fixed rate TSCs to determine
-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

