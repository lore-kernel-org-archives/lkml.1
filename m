Return-Path: <linux-kernel-owner+w=401wt.eu-S1757215AbXFKTM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215AbXFKTM2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 15:12:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753527AbXFKTMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 15:12:20 -0400
Received: from www.osadl.org ([213.239.205.134]:42569 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753478AbXFKTMT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 15:12:19 -0400
Subject: [patch-mm 19a/23] x86_64: hpet restore vread
From: Thomas Gleixner <tglx@linutronix.de>
To: =?ISO-8859-1?Q?S=E9bastien_Dugu=E9?= <sebastien.dugue@bull.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Chris Wright <chrisw@sous-sol.org>,
       Jean Pierre Dion <jean-pierre.dion@bull.net>,
       Gilles Carry <Gilles.Carry@ext.bull.net>
In-Reply-To: <20070611104740.22adc9bc@frecb000686.frec.bull.fr>
References: <20070610092437.118387863@inhelltoy.tec.linutronix.de>
	 <20070610092447.072839259@inhelltoy.tec.linutronix.de>
	 <20070611104740.22adc9bc@frecb000686.frec.bull.fr>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 11 Jun 2007 21:12:14 +0200
Message-Id: <1181589134.8176.157.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: x86_64: hpet restore vread

>From Sébastien Dugué <sebastien.dugue@bull.net>

It seems the hpet clocksource's vread method was lost in the x86_64
conversion to clockevents. So here it is.

Signed-off-by: Sébastien Dugué <sebastien.dugue@bull.net>
Signed-off-by: Thomas Gleixner <tglx@linutronix,de>

 arch/i386/kernel/hpet.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

Index: linux-2.6.22-rc4-mm/arch/i386/kernel/hpet.c
===================================================================
--- linux-2.6.22-rc4-mm.orig/arch/i386/kernel/hpet.c	2007-06-11 21:19:11.000000000 +0200
+++ linux-2.6.22-rc4-mm/arch/i386/kernel/hpet.c	2007-06-11 21:20:14.000000000 +0200
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


