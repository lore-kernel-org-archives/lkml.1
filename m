Return-Path: <linux-kernel-owner+w=401wt.eu-S1753296AbXCWS3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296AbXCWS3e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 14:29:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753300AbXCWS3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 14:29:34 -0400
Received: from smtp.osdl.org ([65.172.181.24]:59717 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753296AbXCWS3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 14:29:33 -0400
Date: Fri, 23 Mar 2007 11:28:41 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Ingo Molnar <mingo@elte.hu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Mingming Cao <cmm@us.ibm.com>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Oliver Pinter <oliver.pntr@gmail.com>,
       Sid Boyce <g3vbv@blueyonder.co.uk>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, Thomas Renninger <trenn@suse.de>,
       Len Brown <len.brown@intel.com>
Subject: Re: [1/6] 2.6.21-rc4: known regressions
In-Reply-To: <Pine.LNX.4.64.0703231115090.6730@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0703231124370.6730@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> 
 <20070318184908.GU752@stusta.de>  <Pine.LNX.4.64.0703212023550.6730@woody.linux-foundation.org>
  <46020385.50301@yahoo.com.au>  <Pine.LNX.4.64.0703220813340.6730@woody.linux-foundation.org>
  <1174612132.16068.114.camel@localhost.localdomain> 
 <Pine.LNX.4.64.0703221830470.6730@woody.linux-foundation.org> 
 <20070323114223.GA23483@elte.hu> <1174650969.10840.274.camel@localhost.localdomain>
 <Pine.LNX.4.64.0703231112350.6730@woody.linux-foundation.org>
 <Pine.LNX.4.64.0703231115090.6730@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 23 Mar 2007, Linus Torvalds wrote:
> 
> Thomas, please fix.

Here's a possible fix. It compiles. And I still wish we had common files.

ia64 shouldn't be affected, because ia64 doesn't #define the 
ARCH_APICTIMER_STOPS_ON_C3 flag (and then we don't use the "c2_ok" thing 
either. But this is still pretty damn ugly.

Maybe a field in "struct acpi_processor" for C2/C3 problems?

		Linus

---
diff --git a/arch/x86_64/kernel/apic.c b/arch/x86_64/kernel/apic.c
index 723417d..46acf4f 100644
--- a/arch/x86_64/kernel/apic.c
+++ b/arch/x86_64/kernel/apic.c
@@ -47,6 +47,10 @@ int apic_calibrate_pmtmr __initdata;
 
 int disable_apic_timer __initdata;
 
+/* Local APIC timer works in C2? */
+int local_apic_timer_c2_ok;
+EXPORT_SYMBOL_GPL(local_apic_timer_c2_ok);
+
 static struct resource *ioapic_resources;
 static struct resource lapic_resource = {
 	.name = "Local APIC",
@@ -1192,6 +1196,13 @@ static __init int setup_nolapic(char *str)
 } 
 early_param("nolapic", setup_nolapic);
 
+static int __init parse_lapic_timer_c2_ok(char *arg)
+{
+	local_apic_timer_c2_ok = 1;
+	return 0;
+}
+early_param("lapic_timer_c2_ok", parse_lapic_timer_c2_ok);
+
 static __init int setup_noapictimer(char *str) 
 { 
 	if (str[0] != ' ' && str[0] != 0)
diff --git a/include/asm-x86_64/apic.h b/include/asm-x86_64/apic.h
index e81d0f2..7cfb39c 100644
--- a/include/asm-x86_64/apic.h
+++ b/include/asm-x86_64/apic.h
@@ -102,5 +102,6 @@ void switch_ipi_to_APIC_timer(void *cpumask);
 #define ARCH_APICTIMER_STOPS_ON_C3	1
 
 extern unsigned boot_cpu_id;
+extern int local_apic_timer_c2_ok;
 
 #endif /* __ASM_APIC_H */
