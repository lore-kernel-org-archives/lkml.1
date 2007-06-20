Return-Path: <linux-kernel-owner+w=401wt.eu-S1763514AbXFTSpO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763514AbXFTSpO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 14:45:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760847AbXFTSex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 14:34:53 -0400
Received: from mail.gmx.net ([213.165.64.20]:50961 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1760825AbXFTSew (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 14:34:52 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX18x4sRkfEYxdhQFY5n5+f1KOlW1LVVM2KlBOSf+E1
	TZs+xAwjwx8IhM
Date: Wed, 20 Jun 2007 20:34:48 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Andi Kleen <ak@suse.de>, eranian@hpl.hp.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, levon@movementarian.org,
       perfmon@napali.hpl.hp.com, oprofile-list@lists.sourceforge.net,
       wcohen@redhat.com, akpm@linux-foundation.org
Subject: [PATCH 1/2] Always probe the NMI watchdog
Message-ID: <20070620183448.GB3251@atjola.homenet>
Mail-Followup-To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
	Andi Kleen <ak@suse.de>, eranian@hpl.hp.com, mingo@elte.hu,
	linux-kernel@vger.kernel.org, levon@movementarian.org,
	perfmon@napali.hpl.hp.com, oprofile-list@lists.sourceforge.net,
	wcohen@redhat.com, akpm@linux-foundation.org
References: <20070618103214.GA12045@atjola.homenet> <200706201431.44014.ak@suse.de> <20070620124959.GB24906@frankl.hpl.hp.com> <200706201501.02582.ak@suse.de> <20070620183315.GA3251@atjola.homenet>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070620183315.GA3251@atjola.homenet>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The performance counter allocator relies on the nmi watchdog being
probed, so we have to do that even if the watchdog is not enabled.

Signed-off-by: Björn Steinbrink <B.Steinbrink@gmx.de>
---
 arch/i386/kernel/cpu/perfctr-watchdog.c |   11 +++++------
 arch/i386/kernel/nmi.c                  |    3 +++
 arch/x86_64/kernel/nmi.c                |    3 +++
 include/asm-i386/nmi.h                  |    1 +
 include/asm-x86_64/nmi.h                |    1 +
 5 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/arch/i386/kernel/cpu/perfctr-watchdog.c b/arch/i386/kernel/cpu/perfctr-watchdog.c
index f0b6763..a12dbcf 100644
--- a/arch/i386/kernel/cpu/perfctr-watchdog.c
+++ b/arch/i386/kernel/cpu/perfctr-watchdog.c
@@ -572,7 +572,7 @@ static struct wd_ops intel_arch_wd_ops = {
 	.evntsel = MSR_ARCH_PERFMON_EVENTSEL0,
 };
 
-static void probe_nmi_watchdog(void)
+void probe_nmi_watchdog(void)
 {
 	switch (boot_cpu_data.x86_vendor) {
 	case X86_VENDOR_AMD:
@@ -610,17 +610,16 @@ static void probe_nmi_watchdog(void)
 
 int lapic_watchdog_init(unsigned nmi_hz)
 {
-	if (!wd_ops) {
-		probe_nmi_watchdog();
-		if (!wd_ops)
-			return -1;
+	if (!wd_ops)
+		return -1;
 
+	/* hack to make sure that we only try to reserver the perfctrs once */
+	if (smp_processor_id() == 0)
 		if (!wd_ops->reserve()) {
 			printk(KERN_ERR
 				"NMI watchdog: cannot reserve perfctrs\n");
 			return -1;
 		}
-	}
 
 	if (!(wd_ops->setup(nmi_hz))) {
 		printk(KERN_ERR "Cannot setup NMI watchdog on CPU %d\n",
diff --git a/arch/i386/kernel/nmi.c b/arch/i386/kernel/nmi.c
index fba121f..8788f91 100644
--- a/arch/i386/kernel/nmi.c
+++ b/arch/i386/kernel/nmi.c
@@ -248,6 +248,9 @@ void setup_apic_nmi_watchdog (void *unused)
 	if ((smp_processor_id() != 0) && (atomic_read(&nmi_active) <= 0))
 		return;
 
+	/* always probe the watchdog, the perfctr allocator requires that */
+	probe_nmi_watchdog();
+
 	switch (nmi_watchdog) {
 	case NMI_LOCAL_APIC:
 		__get_cpu_var(wd_enabled) = 1; /* enable it before to avoid race with handler */
diff --git a/arch/x86_64/kernel/nmi.c b/arch/x86_64/kernel/nmi.c
index 931c64b..3229a26 100644
--- a/arch/x86_64/kernel/nmi.c
+++ b/arch/x86_64/kernel/nmi.c
@@ -255,6 +255,9 @@ void setup_apic_nmi_watchdog(void *unused)
 	if ((smp_processor_id() != 0) && (atomic_read(&nmi_active) <= 0))
 		return;
 
+	/* always probe the watchdog, the perfctr allocator requires that */
+	probe_nmi_watchdog();
+
 	switch (nmi_watchdog) {
 	case NMI_LOCAL_APIC:
 		__get_cpu_var(wd_enabled) = 1;
diff --git a/include/asm-i386/nmi.h b/include/asm-i386/nmi.h
index fb1e133..cf87cd0 100644
--- a/include/asm-i386/nmi.h
+++ b/include/asm-i386/nmi.h
@@ -18,6 +18,7 @@
 int do_nmi_callback(struct pt_regs *regs, int cpu);
 
 extern int nmi_watchdog_enabled;
+extern void probe_nmi_watchdog(void);
 extern int avail_to_resrv_perfctr_nmi_bit(unsigned int);
 extern int avail_to_resrv_perfctr_nmi(unsigned int);
 extern int reserve_perfctr_nmi(unsigned int);
diff --git a/include/asm-x86_64/nmi.h b/include/asm-x86_64/nmi.h
index d0a7f53..f61653b 100644
--- a/include/asm-x86_64/nmi.h
+++ b/include/asm-x86_64/nmi.h
@@ -45,6 +45,7 @@ extern int panic_on_timeout;
 extern int unknown_nmi_panic;
 extern int nmi_watchdog_enabled;
 
+extern void probe_nmi_watchdog(void);
 extern int check_nmi_watchdog(void);
 extern int avail_to_resrv_perfctr_nmi_bit(unsigned int);
 extern int avail_to_resrv_perfctr_nmi(unsigned int);
-- 
1.5.2.2

