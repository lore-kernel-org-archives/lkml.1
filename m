Return-Path: <linux-kernel-owner+w=401wt.eu-S1753148AbXH1UXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148AbXH1UXX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 16:23:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761536AbXH1UWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 16:22:20 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:38885 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761500AbXH1UWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 16:22:11 -0400
Subject: Re: nmi_watchdog=2 regression in 2.6.21
From: Daniel Walker <dwalker@mvista.com>
To: eranian@hpl.hp.com
Cc: =?ISO-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>, ak@suse.de,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <20070828194636.GB2814@frankl.hpl.hp.com>
References: <1186531609.22044.50.camel@imap.mvista.com>
	 <20070808142059.GF30805@atjola.homenet>
	 <20070827175431.GD784@frankl.hpl.hp.com>
	 <1188237331.2435.255.camel@dhcp193.mvista.com>
	 <20070827225555.GI784@frankl.hpl.hp.com>
	 <1188256074.2435.272.camel@dhcp193.mvista.com>
	 <20070828091217.GA1645@frankl.hpl.hp.com>
	 <1188311684.2435.288.camel@dhcp193.mvista.com>
	 <20070828170556.GI1645@frankl.hpl.hp.com>
	 <1188325835.2435.317.camel@dhcp193.mvista.com>
	 <20070828194636.GB2814@frankl.hpl.hp.com>
Content-Type: text/plain
Date: Tue, 28 Aug 2007 13:13:44 -0700
Message-Id: <1188332024.2435.328.camel@dhcp193.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-08-28 at 12:46 -0700, Stephane Eranian wrote:


> I think I found the problem. As I suspected, it seems there is an assymetry
> between the 1st end 2nd counter (just like what they have on P6 core). Yet
> for architectural perfmon v1, this restriction is supposed to be lifted.
> 
> Unfortunately, a quick look at the errata document at
> http://download.intel.com/design/mobile/SPECUPDT/30922212.pdf
> 
> for Core Duo shows bugs A49 as 'nofix':
>   Core Duo processor has a bug which renders the enable bit (22) of
>   PERFEVTSEL1 inoperative. The processor behaves like former P6 cores,
>   the enable bit of PERFEVTSEL0 controls the activation of both counters

Your patch switched the nmi from PERFEVTSEL0 to PERFEVTSEL1  (right?)..
So 0 works, 1 does not , for me anyway ..

> That explains why you get the 'NMI stuck' message when using PERFEVTSEL1.
> I suspect when using PERFEVTSEL0, then NMI watchdog is not stuck. So it
> is possible that in case NMI is stuck the code does not cleanly shutdown the
> NMI interrupt and you get some spurious NMI interrupt later in the boot at
> you are stuck because you are holding a lock. We need to look at the error
> path of check_nmi_watchdog(). I glance through it and could not find the place
> where the APIC vector is cleared.

As far as I can tell the check_nmi_watchdog() doesn't take locks, and it
can't safely share a lock with the NMI .. 

The patch below fixes the hang (not the stuck NMI) .. Not totally sure
why, but the cpus are stuck in a loop waiting for the endflag which
never comes .. This also plays with the nmi hz which might do
something.. /proc/interrupt doesn't show any nmi's either..

Daniel

Signed-off-by: Daniel Walker <dwalker@mvista.com>

Index: linux-2.6.22/arch/i386/kernel/nmi.c
===================================================================
--- linux-2.6.22.orig/arch/i386/kernel/nmi.c	2007-08-15 00:51:12.000000000 +0000
+++ linux-2.6.22/arch/i386/kernel/nmi.c	2007-08-28 20:15:04.000000000 +0000
@@ -82,7 +82,7 @@ static __init void nmi_cpu_busy(void *da
 static int __init check_nmi_watchdog(void)
 {
 	unsigned int *prev_nmi_count;
-	int cpu;
+	int cpu, ret = 0;
 
 	if ((nmi_watchdog == NMI_NONE) || (nmi_watchdog == NMI_DEFAULT))
 		return 0;
@@ -125,18 +125,18 @@ static int __init check_nmi_watchdog(voi
 	if (!atomic_read(&nmi_active)) {
 		kfree(prev_nmi_count);
 		atomic_set(&nmi_active, -1);
-		return -1;
-	}
+		printk("nmi malfunctioning.\n");
+		ret = -1;
+	} else 
+		printk("OK.\n");
 	endflag = 1;
-	printk("OK.\n");
-
 	/* now that we know it works we can reduce NMI frequency to
 	   something more reasonable; makes a difference in some configs */
 	if (nmi_watchdog == NMI_LOCAL_APIC)
 		nmi_hz = lapic_adjust_nmi_hz(1);
 
 	kfree(prev_nmi_count);
-	return 0;
+	return ret;
 }
 /* This needs to happen later in boot so counters are working */
 late_initcall(check_nmi_watchdog);


