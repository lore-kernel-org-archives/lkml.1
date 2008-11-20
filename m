Return-Path: <linux-kernel-owner+w=401wt.eu-S1753993AbYKTEvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993AbYKTEvv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 23:51:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752962AbYKTEvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 23:51:41 -0500
Received: from hera.kernel.org ([140.211.167.34]:59417 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752841AbYKTEvk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 23:51:40 -0500
Message-ID: <4924ECAD.7080603@kernel.org>
Date: Wed, 19 Nov 2008 20:50:53 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fix wakeup_cpu with numaq/es7000 v2 - fix v2
References: <491FDE2A.1010809@kernel.org> <49200031.2040701@kernel.org> <20081117165224.GH12081@elte.hu> <20081117173728.GA7384@elte.hu> <4921FC19.1080803@kernel.org> <20081117232837.GA10308@elte.hu> <20081118074346.GA21875@elte.hu> <4922E99B.8090604@kernel.org> <20081118211413.GE11490@elte.hu>
In-Reply-To: <20081118211413.GE11490@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Yinghai Lu <yinghai@kernel.org> wrote:
> 
>> Impact: fix wakeup_secondary_cpu with hotplug
>>
>> We can not put that in x86_quirks, because that is __initdata.
>> So try to move that to genapic, and add update_genapic in x86_quirks.
>>
>> later we even could use that stub to
>> 1. autodetect CONFIG_ES7000_CLUSTERED_APIC
>> 2. more correct inquire_remote_apic with apic_verbosity setting.
> 
> thanks - this patch and the next one did the trick to stabilize the 
> tip/x86/quirks topic tree - no more hotplug crashes and no more build 
> failures either. The lineup is:
> 
>  b5fe363: x86: use update_genapic to get rid of ES7000_CLUSTERED_APIC v2
>  f632ddc: x86: fix wakeup_cpu with numaq/es7000, v2, fix #2
>  54ac14a: x86: fix wakeup_cpu with numaq/es7000, v2, fix
>  569712b: x86: fix wakeup_cpu with numaq/es7000, v2
> 
> and i've merged them into tip/master as well.
> 

need more update_genapic calling

diff --git a/arch/x86/mach-generic/probe.c b/arch/x86/mach-generic/probe.c
index 90b134f..c346d9d 100644
--- a/arch/x86/mach-generic/probe.c
+++ b/arch/x86/mach-generic/probe.c
@@ -76,12 +76,15 @@ void __init generic_bigsmp_probe(void)
 	 * - we find more than 8 CPUs in acpi LAPIC listing with xAPIC support
 	 */
 
-	if (!cmdline_apic && genapic == &apic_default)
+	if (!cmdline_apic && genapic == &apic_default) {
 		if (apic_bigsmp.probe()) {
 			genapic = &apic_bigsmp;
+			if (x86_quirks->update_genapic)
+				x86_quirks->update_genapic();
 			printk(KERN_INFO "Overriding APIC driver with %s\n",
 			       genapic->name);
 		}
+	}
 #endif
 }
 
@@ -98,6 +101,9 @@ void __init generic_apic_probe(void)
 		/* Not visible without early console */
 		if (!apic_probe[i])
 			panic("Didn't find an APIC driver");
+
+		if (x86_quirks->update_genapic)
+			x86_quirks->update_genapic();
 	}
 	printk(KERN_INFO "Using APIC driver %s\n", genapic->name);
 }
@@ -112,6 +118,8 @@ int __init mps_oem_check(struct mp_config_table *mpc, char *oem,
 		if (apic_probe[i]->mps_oem_check(mpc, oem, productid)) {
 			if (!cmdline_apic) {
 				genapic = apic_probe[i];
+				if (x86_quirks->update_genapic)
+					x86_quirks->update_genapic();
 				printk(KERN_INFO "Switched to APIC driver `%s'.\n",
 				       genapic->name);
 			}
@@ -128,6 +136,8 @@ int __init acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 		if (apic_probe[i]->acpi_madt_oem_check(oem_id, oem_table_id)) {
 			if (!cmdline_apic) {
 				genapic = apic_probe[i];
+				if (x86_quirks->update_genapic)
+					x86_quirks->update_genapic();
 				printk(KERN_INFO "Switched to APIC driver `%s'.\n",
 				       genapic->name);
 			}
