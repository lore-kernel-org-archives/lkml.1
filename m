Return-Path: <linux-kernel-owner+w=401wt.eu-S1754095AbYFWXWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095AbYFWXWX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 19:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751495AbYFWXWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 19:22:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48432 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751573AbYFWXWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 19:22:06 -0400
Date: Tue, 24 Jun 2008 01:21:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alok Kataria <akataria@vmware.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Daniel Hecht <dhecht@vmware.com>,
       Tim Mann <mann@vmware.com>, Zach Amsden <zach@vmware.com>,
       Sahil Rihan <srihan@vmware.com>
Subject: Re: [RFC PATCH] x86:Use cpu_khz for loops_per_jiffy calculation
Message-ID: <20080623232149.GA22926@elte.hu>
References: <1212540069.19290.57.camel@promb-2n-dhcp368.eng.vmware.com> <20080603182014.79a38d03@infradead.org> <35f686220806032101h103152dat841818982aaa5052@mail.gmail.com> <20080604061637.6bab3f67@infradead.org> <1213924953.27983.52.camel@promb-2n-dhcp368.eng.vmware.com> <20080620113922.GG7439@elte.hu> <1213999593.31598.52.camel@promb-2n-dhcp368.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1213999593.31598.52.camel@promb-2n-dhcp368.eng.vmware.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alok Kataria <akataria@vmware.com> wrote:

> +	lpj = ((u64)tsc_khz * 1000);
> +	do_div(lpj, HZ);
> +	lpj_tsc = lpj;

this needed the fix below.

but there's another problem as well: why are generic files 
(init/calibrate.c and include/linux/delay.h) using something that is 
named in an x86-specific way - lpj_tsc ? (TSC is an x86 concept)

	Ingo

------------>
commit 5cd5a41ea6f4363b03156e2208dd0d2266f0d67d
Author: Ingo Molnar <mingo@elte.hu>
Date:   Tue Jun 24 01:19:49 2008 +0200

    x86: fix "x86: use cpu_khz for loops_per_jiffy calculation"
    
    fix:
    
    arch/x86/kernel/tsc_32.c: In function ‘tsc_init':
    arch/x86/kernel/tsc_32.c:421: error: ‘lpj_tsc' undeclared (first use in this function)
    arch/x86/kernel/tsc_32.c:421: error: (Each undeclared identifier is reported only once
    arch/x86/kernel/tsc_32.c:421: error: for each function it appears in.)
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/x86/kernel/tsc_32.c b/arch/x86/kernel/tsc_32.c
index 4adac0d..bfb9193 100644
--- a/arch/x86/kernel/tsc_32.c
+++ b/arch/x86/kernel/tsc_32.c
@@ -1,6 +1,7 @@
 #include <linux/sched.h>
 #include <linux/clocksource.h>
 #include <linux/workqueue.h>
+#include <linux/delay.h>
 #include <linux/cpufreq.h>
 #include <linux/jiffies.h>
 #include <linux/init.h>
