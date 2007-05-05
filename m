Return-Path: <linux-kernel-owner+w=401wt.eu-S1754672AbXEEPYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbXEEPYr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 11:24:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755029AbXEEPYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 11:24:47 -0400
Received: from www.osadl.org ([213.239.205.134]:42295 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752897AbXEEPYq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 11:24:46 -0400
Subject: Re: [PATCH] Blacklist Dell Optiplex 320 from using the HPET
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: john stultz <johnstul@us.ibm.com>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       "Guilherme M. Schroeder" <guilherme@centralinf.com.br>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1178321228.6094.34.camel@localhost.localdomain>
References: <1178314144.6094.7.camel@localhost.localdomain>
	 <200705050118.34711.ak@suse.de>
	 <1178321228.6094.34.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sat, 05 May 2007 16:26:54 +0200
Message-Id: <1178375214.31213.13.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Guilherme,

On Fri, 2007-05-04 at 16:27 -0700, john stultz wrote: 
> > Before going to hard to maintain DMI black lists we should first check 
> > if it's a more general problem and can't it be solved better? Most likely
> > that system isn't the one with this issue and I don't want to apply
> > DMI patches forever.
> 
> We can give it a whirl, I just didn't want to add yet another "compare
> with some other counter that may or may not work" check. In this case,
> probably reading three times in a row and getting the same result would
> be a clearly broken box. 

can you please undo John's patch and check whether the patch below works
for you.

Thanks,

	tglx

Index: linux-2.6.21/arch/i386/kernel/hpet.c
===================================================================
--- linux-2.6.21.orig/arch/i386/kernel/hpet.c
+++ linux-2.6.21/arch/i386/kernel/hpet.c
@@ -231,6 +231,7 @@ int __init hpet_enable(void)
 {
 	unsigned long id;
 	uint64_t hpet_freq;
+	cycle_t t1;
 	u64 tmp;
 
 	if (!is_hpet_capable())
@@ -278,6 +279,14 @@ int __init hpet_enable(void)
 	/* Start the counter */
 	hpet_start_counter();
 
+	/* Verify whether hpet counter works */
+	t1 = hpet_read();
+	udelay(50);
+	if (t1 == hpet_read()) {
+		printk(KERN_WARNING "HPET counter is defect\n");
+		goto out_nohpet;
+	}
+
 	/* Initialize and register HPET clocksource
 	 *
 	 * hpet period is in femto seconds per cycle


