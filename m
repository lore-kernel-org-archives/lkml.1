Return-Path: <linux-kernel-owner+w=401wt.eu-S932217AbZHQUoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932217AbZHQUoj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 16:44:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756062AbZHQUoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 16:44:39 -0400
Received: from www.tglx.de ([62.245.132.106]:41973 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755047AbZHQUoi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 16:44:38 -0400
Date: Mon, 17 Aug 2009 22:44:16 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stephen Hemminger <shemminger@vyatta.com>
cc: john stultz <johnstul@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: clocksource changes in 2.6.31 - possible regression
In-Reply-To: <20090817132703.2db7b0c9@nehalam>
Message-ID: <alpine.LFD.2.00.0908172233400.2782@localhost.localdomain>
References: <20090817090319.20979986@nehalam> <1250531337.26171.12.camel@work-vm> <20090817110127.40ee5c29@nehalam> <1250532954.26171.35.camel@work-vm> <20090817112704.2b4b2987@nehalam> <alpine.LFD.2.00.0908172032500.2782@localhost.localdomain>
 <20090817125406.03e26060@nehalam> <alpine.LFD.2.00.0908172202430.2782@localhost.localdomain> <20090817132703.2db7b0c9@nehalam>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen,

On Mon, 17 Aug 2009, Stephen Hemminger wrote:
> > 
> cat /sys/devices/system/clocksource/clocksource0/available_clocksource
> 
> acpi_pm jiffies tsc 

Hmm. So while your dmesg does not tell anything about the TSC being
unreliable, it's listed as the worst clocksource of all.

The missing dmesg output is not really suprising, see patch below.

Thanks,

	tglx
---
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 71f4368..e254bc0 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -761,7 +761,7 @@ void mark_tsc_unstable(char *reason)
 {
 	if (!tsc_unstable) {
 		tsc_unstable = 1;
-		printk("Marking TSC unstable due to %s\n", reason);
+		printk(KERN_NOTICE "Marking TSC unstable due to %s\n", reason);
 		/* Change only the rating, when not registered */
 		if (clocksource_tsc.mult)
 			clocksource_change_rating(&clocksource_tsc, 0);
@@ -815,6 +815,8 @@ static void __init check_system_tsc_reliable(void)
  */
 __cpuinit int unsynchronized_tsc(void)
 {
+	int unstable = tsc_unstable;
+
 	if (!cpu_has_tsc || tsc_unstable)
 		return 1;
 
@@ -832,10 +834,10 @@ __cpuinit int unsynchronized_tsc(void)
 	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL) {
 		/* assume multi socket systems are not synchronized: */
 		if (num_possible_cpus() > 1)
-			tsc_unstable = 1;
+			unstable = 1;
 	}
 
-	return tsc_unstable;
+	return unstable;
 }
 
 static void __init init_tsc_clocksource(void)


