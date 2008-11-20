Return-Path: <linux-kernel-owner+w=401wt.eu-S1754869AbYKTJqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869AbYKTJqo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 04:46:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753867AbYKTJqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 04:46:35 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37186 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753897AbYKTJqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 04:46:34 -0500
Date: Thu, 20 Nov 2008 10:46:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fix wakeup_cpu with numaq/es7000 v2
Message-ID: <20081120094621.GD6885@elte.hu>
References: <491FDE2A.1010809@kernel.org> <49200031.2040701@kernel.org> <20081117165224.GH12081@elte.hu> <20081117173728.GA7384@elte.hu> <4921FC19.1080803@kernel.org> <4924E0C7.8000003@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4924E0C7.8000003@ct.jp.nec.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:

> Yinghai Lu wrote:
> > Ingo Molnar wrote:
> >> hm, one of my testboxes is rather unhappy about your patch:
> > 
> > 
> > please check
> > 
> > if you agree, will update update_genapic to autodetect other functions or etc.
> > 
> > YH
> > 
> > ---
> > 
> > [PATCH] x86: fix wakeup_cpu with numaq/es7000 v2 - fix
> > 
> > Impact: fix wakeup_secondary_cpu with hotplug
> > 
> > We can not put that in x86_quirks, because that is __initdata.
> > So try to move that to genapic, and add update_genapic in x86_quirks.
> > 
> > later we even could use that stub to
> > 1. autodetect CONFIG_ES7000_CLUSTERED_APIC
> > 2. more correct inquire_remote_apic with apic_verbosity setting.
> 
> Hi,
> 
> I encountered boot failure on x86_32 box.
> I think setting wakeup_cpu is missing.
> 
> --------
> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> Subject: [PATCH] x86: genapic: fix missing wakeup_cpu setup
> 
> Impact: fix boot failure
> 
> There is no way to setup wakeup_cpu when boot parameter apic= is not passed.
> 
> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> ---
>  arch/x86/mach-generic/probe.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)

thanks - i've applied the wider fix from Yinghai - see it below.

i'm wondering why my tests didnt trigger this boot crash. What makes 
your system or .config special to trigger it?

	Ingo

-------------->
>From 87f7606591aea6a8a38ea4c8911b5eeeee2740b8 Mon Sep 17 00:00:00 2001
From: Yinghai Lu <yinghai@kernel.org>
Date: Wed, 19 Nov 2008 20:50:53 -0800
Subject: [PATCH] x86: fix wakeup_cpu with numaq/es7000 v2 - call ->update_genapic()

Impact: fix boot crash on 32-bit

Hiroshi Shimamoto reported a boot failure on 32-bit x86.

The setting of x86_quirks.wakeup_cpu is missing (when
not passing in an explicit apic= boot parameter).

Reported-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mach-generic/probe.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

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
