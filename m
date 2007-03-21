Return-Path: <linux-kernel-owner+w=401wt.eu-S1752659AbXCUMI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659AbXCUMI3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 08:08:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752668AbXCUMI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 08:08:29 -0400
Received: from www.osadl.org ([213.239.205.134]:33462 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752659AbXCUMI2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 08:08:28 -0400
Subject: Re: BUG lapic: Can't boot on battery (2.6.21-rc{1,2,3,4})
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Andi Kleen <ak@suse.de>
Cc: Grzegorz Chwesewicz <grzegorz.chwesewicz@chilan.com>,
       Stefan Prechtel <stefan.prechtel@googlemail.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu,
       Len Brown <lenb@kernel.org>, john stultz <johnstul@us.ibm.com>
In-Reply-To: <1174475666.10840.44.camel@localhost.localdomain>
References: <b93822910703191010s1ac9d5d7jf9f761ecb933cc77@mail.gmail.com>
	 <200703211046.20724.ak@suse.de>
	 <1174471808.10840.28.camel@localhost.localdomain>
	 <200703211137.10884.ak@suse.de>
	 <1174475666.10840.44.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 21 Mar 2007 13:15:38 +0100
Message-Id: <1174479339.10840.59.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan, Grzegorz

On Wed, 2007-03-21 at 12:14 +0100, Thomas Gleixner wrote:
> On Wed, 2007-03-21 at 11:37 +0100, Andi Kleen wrote:
> > > The BIOS/ACPI is broken and does only expose C1, which should not switch
> > > off LAPIC. The BIOS is switching into deeper C-States behind the kernels
> > > back somehow.
> > 
> > Hmm, perhaps we can check AMD && (cstate >= 2 || has a battery) ? 
> > Should be doable by looking up the battery object in ACPI
> 
> Which makes us rely on another ACPI feature. What guarantees that the
> ACPI tables are correct for this one ?

Can you please apply the patch below and add "nolapic_timer" to the
kernel command line ?

Please provide also the output of

# dmidecode

on your laptops.

Thanks,

	tglx

diff --git a/arch/i386/kernel/apic.c b/arch/i386/kernel/apic.c
index 5cff797..67f8d9f 100644
--- a/arch/i386/kernel/apic.c
+++ b/arch/i386/kernel/apic.c
@@ -61,6 +61,8 @@ static int enable_local_apic __initdata = 0;
 
 /* Local APIC timer verification ok */
 static int local_apic_timer_verify_ok;
+/* Disable local APIC timer from the kernel commandline */
+static int local_apic_timer_disabled;
 
 /*
  * Debug level, exported for io_apic.c
@@ -340,6 +342,13 @@ void __init setup_boot_APIC_clock(void)
 	long delta, deltapm;
 	int pm_referenced = 0;
 
+	if (local_apic_timer_disabled) {
+		/* No broadcast on UP ! */
+		if (num_possible_cpus() > 1)
+			setup_APIC_timer();
+		return;
+	}}
+
 	apic_printk(APIC_VERBOSE, "Using local APIC timer interrupts.\n"
 		    "calibrating APIC timer ...\n");
 
@@ -1179,6 +1188,13 @@ static int __init parse_nolapic(char *arg)
 }
 early_param("nolapic", parse_nolapic);
 
+static int __init parse_disable_lapic_timer(char *arg)
+{
+	local_apic_timer_disabled = 1;
+	return 0;
+}
+early_param("nolapic_timer", parse_disable_lapic_timer);
+
 static int __init apic_set_verbosity(char *str)
 {
 	if (strcmp("debug", str) == 0)


