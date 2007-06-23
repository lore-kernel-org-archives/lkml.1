Return-Path: <linux-kernel-owner+w=401wt.eu-S1761323AbXFWN3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761323AbXFWN3X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 09:29:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758462AbXFWNW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 09:22:28 -0400
Received: from www.osadl.org ([213.239.205.134]:59303 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758172AbXFWNWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 09:22:17 -0400
Message-Id: <20070623124031.210773624@inhelltoy.tec.linutronix.de>
References: <20070623124005.931747831@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Sat, 23 Jun 2007 13:32:49 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       John Stultz <johnstul@us.ibm.com>, Chris Wright <chrisw@sous-sol.org>,
       LKML <linux-kernel@vger.kernel.org>,
       =?UTF-8?q?S=C3=A9bastien=20Dugu=C3=A9?= <sebastien.dugue@bull.net>
Subject: [patch -mm 24/28] x86_64: hpet restore vread
Content-Disposition: inline; filename=x86-64-hpet-restore-vread.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From sebastien.dugue@bull.net

It seems the hpet clocksource's vread method was lost in the x86_64 conversion
to clockevents. So here it is.

Signed-off-by: Sébastien Dugué <sebastien.dugue@bull.net>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

 arch/i386/kernel/hpet.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

Index: linux-2.6.22-rc4-mm/arch/i386/kernel/hpet.c
===================================================================
--- linux-2.6.22-rc4-mm.orig/arch/i386/kernel/hpet.c	2007-06-23 14:39:00.000000000 +0200
+++ linux-2.6.22-rc4-mm/arch/i386/kernel/hpet.c	2007-06-23 14:39:00.000000000 +0200
@@ -255,6 +255,13 @@ static cycle_t read_hpet(void)
 	return (cycle_t)hpet_readl(HPET_COUNTER);
 }
 
+#ifdef CONFIG_X86_64
+static cycle_t __vsyscall_fn vread_hpet(void)
+{
+	return readl((const void __iomem *)fix_to_virt(VSYSCALL_HPET) + 0xf0);
+}
+#endif
+
 static struct clocksource clocksource_hpet = {
 	.name		= "hpet",
 	.rating		= 250,
@@ -263,6 +270,9 @@ static struct clocksource clocksource_hp
 	.shift		= HPET_SHIFT,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 	.resume		= hpet_start_counter,
+#ifdef CONFIG_X86_64
+	.vread		= vread_hpet,
+#endif
 };
 
 /*

-- 

