Return-Path: <linux-kernel-owner+w=401wt.eu-S1762788AbXFECtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762788AbXFECtV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 22:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757767AbXFECtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 22:49:13 -0400
Received: from ozlabs.org ([203.10.76.45]:49467 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756873AbXFECtM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 22:49:12 -0400
Subject: Re: lguest rebroken in 2.6.22-rc3-mm1
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200706042012.15915.ak@suse.de>
References: <20070522223828.GV11115@waste.org>
	 <20070604171932.GE11115@waste.org>
	 <20070604102820.a4a0ee15.akpm@linux-foundation.org>
	 <200706042012.15915.ak@suse.de>
Content-Type: text/plain
Date: Tue, 05 Jun 2007 12:48:56 +1000
Message-Id: <1181011737.25878.146.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-06-04 at 20:12 +0200, Andi Kleen wrote:
> > >
> > > Looks like this one got lost in rc3-mm1.
> >
> > Andi said that he fixed the zero-divide by other means?
> 
> I determined it cannot happen in my source tree. When notsc
> is passed TSC CPUID is cleared and sched-clock works.
> 
> I suspect what happens is that lguest forgets to clear the TSC cpuid
> bit when it disables TSC. Then the TSC frequency doesn't get computed
> and sched-clock can divide by zero.That's purely a lguest bug that needs
> to be fixed in lguest with a 
> clear_bit(X86_FEATURE_TSC, &boot_cpu_data.x86_capability) 
> somewhere

It's not quite that simple; lguest's paravirt_ops->cpuid sets TSC off,
and indeed X86_FEATURE_TSC isn't set in boot_cpu_data.x86_capability.

But TSC is a "required feature", so "cpu_has_tsc" is always true.

How about this patch:
===
Don't try to disable the TSC: it's a required feature under modern
configurations, so just mark the sched clock unstable which has the
same effect.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/lguest/lguest.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

===================================================================
--- a/drivers/lguest/lguest.c
+++ b/drivers/lguest/lguest.c
@@ -37,6 +37,7 @@
 #include <asm/e820.h>
 #include <asm/mce.h>
 #include <asm/io.h>
+#include <asm/sched-clock.h>
 
 /* Declarations for definitions in lguest_guest.S */
 extern char lguest_noirq_start[], lguest_noirq_end[];
@@ -508,7 +509,8 @@ __init void lguest_init(void *boot)
 	/* Math is always hard! */
 	new_cpu_data.hard_math = 1;
 
-	tsc_disable = 1;
+	/* Sched clock is unusable: you'll just hurt yourself if you try. */
+	__get_cpu_var(sc_data).unstable++;
 
 #ifdef CONFIG_X86_MCE
 	mce_disabled = 1;


