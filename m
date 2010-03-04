Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315Ab0CDKLN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 05:11:13 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:51107 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081Ab0CDKKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 05:10:21 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Thu, 04 Mar 2010 02:08:56 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 09/12] x86: irq_chip to use desc_mask instead of mask part 2
In-reply-to: <1267697339-5491-1-git-send-email-yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       Eric Biederman <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Message-id: <1267697339-5491-10-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
References: <1267697339-5491-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

for uv/vmi/lgues/xen etc...

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/uv_irq.c       |   36 ++++++++++++++--------------
 arch/x86/kernel/visws_quirks.c |   51 +++++++++++++++++++--------------------
 arch/x86/kernel/vmiclock_32.c  |   18 +++++++-------
 arch/x86/lguest/boot.c         |   14 +++++-----
 drivers/misc/sgi-gru/grufile.c |    8 +++---
 drivers/xen/events.c           |   36 ++++++++++++++--------------
 6 files changed, 81 insertions(+), 82 deletions(-)

diff --git a/arch/x86/kernel/uv_irq.c b/arch/x86/kernel/uv_irq.c
index ece73d8..b70abb2 100644
--- a/arch/x86/kernel/uv_irq.c
+++ b/arch/x86/kernel/uv_irq.c
@@ -27,34 +27,34 @@ struct uv_irq_2_mmr_pnode{
 static spinlock_t		uv_irq_lock;
 static struct rb_root		uv_irq_root;
 
-static int uv_set_irq_affinity(unsigned int, const struct cpumask *);
+static int uv_set_irq_affinity(struct irq_desc *desc, const struct cpumask *);
 
-static void uv_noop(unsigned int irq)
+static void uv_noop(struct irq_desc *desc)
 {
 }
 
-static unsigned int uv_noop_ret(unsigned int irq)
+static unsigned int uv_noop_ret(struct irq_desc *desc)
 {
 	return 0;
 }
 
-static void uv_ack_apic(unsigned int irq)
+static void uv_ack_apic(struct irq_desc *desc)
 {
 	ack_APIC_irq();
 }
 
 struct irq_chip uv_irq_chip = {
-	.name		= "UV-CORE",
-	.startup	= uv_noop_ret,
-	.shutdown	= uv_noop,
-	.enable		= uv_noop,
-	.disable	= uv_noop,
-	.ack		= uv_noop,
-	.mask		= uv_noop,
-	.unmask		= uv_noop,
-	.eoi		= uv_ack_apic,
-	.end		= uv_noop,
-	.set_affinity	= uv_set_irq_affinity,
+	.name			= "UV-CORE",
+	.desc_startup		= uv_noop_ret,
+	.desc_shutdown		= uv_noop,
+	.desc_enable		= uv_noop,
+	.desc_disable		= uv_noop,
+	.desc_ack		= uv_noop,
+	.desc_mask		= uv_noop,
+	.desc_unmask		= uv_noop,
+	.desc_eoi		= uv_ack_apic,
+	.desc_end		= uv_noop,
+	.desc_set_affinity	= uv_set_irq_affinity,
 };
 
 /*
@@ -153,7 +153,7 @@ arch_enable_uv_irq(char *irq_name, unsigned int irq, int cpu, int mmr_blade,
 	BUILD_BUG_ON(sizeof(struct uv_IO_APIC_route_entry) !=
 			sizeof(unsigned long));
 
-	cfg = irq_cfg(irq);
+	cfg = desc->chip_data;
 
 	err = assign_irq_vector(irq, cfg, eligible_cpu);
 	if (err != 0)
@@ -205,9 +205,9 @@ static void arch_disable_uv_irq(int mmr_pnode, unsigned long mmr_offset)
 	uv_write_global_mmr64(mmr_pnode, mmr_offset, mmr_value);
 }
 
-static int uv_set_irq_affinity(unsigned int irq, const struct cpumask *mask)
+static int uv_set_irq_affinity(struct irq_desc *desc, const struct cpumask *mask)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
+	unsigned int irq = desc->irq;
 	struct irq_cfg *cfg = desc->chip_data;
 	unsigned int dest;
 	unsigned long mmr_value;
diff --git a/arch/x86/kernel/visws_quirks.c b/arch/x86/kernel/visws_quirks.c
index e680ea5..1242a9e 100644
--- a/arch/x86/kernel/visws_quirks.c
+++ b/arch/x86/kernel/visws_quirks.c
@@ -430,14 +430,15 @@ static int is_co_apic(unsigned int irq)
  * This is the SGI Cobalt (IO-)APIC:
  */
 
-static void enable_cobalt_irq(unsigned int irq)
+static void enable_cobalt_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	co_apic_set(is_co_apic(irq), irq);
 }
 
-static void disable_cobalt_irq(unsigned int irq)
+static void disable_cobalt_irq(struct irq_desc *desc)
 {
-	int entry = is_co_apic(irq);
+	int entry = is_co_apic(desc->irq);
 
 	co_apic_write(CO_APIC_LO(entry), CO_APIC_MASK);
 	co_apic_read(CO_APIC_LO(entry));
@@ -448,48 +449,46 @@ static void disable_cobalt_irq(unsigned int irq)
  * map this to the Cobalt APIC entry where it's physically wired.
  * This is called via request_irq -> setup_irq -> irq_desc->startup()
  */
-static unsigned int startup_cobalt_irq(unsigned int irq)
+static unsigned int startup_cobalt_irq(struct irq_desc *desc)
 {
 	unsigned long flags;
-	struct irq_desc *desc = irq_to_desc(irq);
 
 	spin_lock_irqsave(&cobalt_lock, flags);
 	if ((desc->status & (IRQ_DISABLED | IRQ_INPROGRESS | IRQ_WAITING)))
 		desc->status &= ~(IRQ_DISABLED | IRQ_INPROGRESS | IRQ_WAITING);
-	enable_cobalt_irq(irq);
+	enable_cobalt_irq(desc);
 	spin_unlock_irqrestore(&cobalt_lock, flags);
 	return 0;
 }
 
-static void ack_cobalt_irq(unsigned int irq)
+static void ack_cobalt_irq(struct irq_desc *desc)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&cobalt_lock, flags);
-	disable_cobalt_irq(irq);
+	disable_cobalt_irq(desc);
 	apic_write(APIC_EOI, APIC_EIO_ACK);
 	spin_unlock_irqrestore(&cobalt_lock, flags);
 }
 
-static void end_cobalt_irq(unsigned int irq)
+static void end_cobalt_irq(struct irq_desc *desc)
 {
 	unsigned long flags;
-	struct irq_desc *desc = irq_to_desc(irq);
 
 	spin_lock_irqsave(&cobalt_lock, flags);
 	if (!(desc->status & (IRQ_DISABLED | IRQ_INPROGRESS)))
-		enable_cobalt_irq(irq);
+		enable_cobalt_irq(desc);
 	spin_unlock_irqrestore(&cobalt_lock, flags);
 }
 
 static struct irq_chip cobalt_irq_type = {
-	.name =		"Cobalt-APIC",
-	.startup =	startup_cobalt_irq,
-	.shutdown =	disable_cobalt_irq,
-	.enable =	enable_cobalt_irq,
-	.disable =	disable_cobalt_irq,
-	.ack =		ack_cobalt_irq,
-	.end =		end_cobalt_irq,
+	.name		= "Cobalt-APIC",
+	.desc_startup	= startup_cobalt_irq,
+	.desc_shutdown	= disable_cobalt_irq,
+	.desc_enable	= enable_cobalt_irq,
+	.desc_disable	= disable_cobalt_irq,
+	.desc_ack	= ack_cobalt_irq,
+	.desc_end	= end_cobalt_irq,
 };
 
 
@@ -503,27 +502,27 @@ static struct irq_chip cobalt_irq_type = {
  * interrupt controller type, and through a special virtual interrupt-
  * controller. Device drivers only see the virtual interrupt sources.
  */
-static unsigned int startup_piix4_master_irq(unsigned int irq)
+static unsigned int startup_piix4_master_irq(struct irq_desc *desc)
 {
 	legacy_pic->init(0);
 
-	return startup_cobalt_irq(irq);
+	return startup_cobalt_irq(desc);
 }
 
-static void end_piix4_master_irq(unsigned int irq)
+static void end_piix4_master_irq(struct irq_desc *desc)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&cobalt_lock, flags);
-	enable_cobalt_irq(irq);
+	enable_cobalt_irq(desc);
 	spin_unlock_irqrestore(&cobalt_lock, flags);
 }
 
 static struct irq_chip piix4_master_irq_type = {
-	.name =		"PIIX4-master",
-	.startup =	startup_piix4_master_irq,
-	.ack =		ack_cobalt_irq,
-	.end =		end_piix4_master_irq,
+	.name		= "PIIX4-master",
+	.desc_startup	= startup_piix4_master_irq,
+	.desc_ack	= ack_cobalt_irq,
+	.desc_end	= end_piix4_master_irq,
 };
 
 
diff --git a/arch/x86/kernel/vmiclock_32.c b/arch/x86/kernel/vmiclock_32.c
index 3d48386..a0bd8a7 100644
--- a/arch/x86/kernel/vmiclock_32.c
+++ b/arch/x86/kernel/vmiclock_32.c
@@ -84,7 +84,7 @@ static inline unsigned int vmi_get_timer_vector(void)
 
 /** vmi clockchip */
 #ifdef CONFIG_X86_LOCAL_APIC
-static unsigned int startup_timer_irq(unsigned int irq)
+static unsigned int startup_timer_irq(struct irq_desc *desc)
 {
 	unsigned long val = apic_read(APIC_LVTT);
 	apic_write(APIC_LVTT, vmi_get_timer_vector());
@@ -92,29 +92,29 @@ static unsigned int startup_timer_irq(unsigned int irq)
 	return (val & APIC_SEND_PENDING);
 }
 
-static void mask_timer_irq(unsigned int irq)
+static void mask_timer_irq(struct irq_desc *desc)
 {
 	unsigned long val = apic_read(APIC_LVTT);
 	apic_write(APIC_LVTT, val | APIC_LVT_MASKED);
 }
 
-static void unmask_timer_irq(unsigned int irq)
+static void unmask_timer_irq(struct irq_desc *desc)
 {
 	unsigned long val = apic_read(APIC_LVTT);
 	apic_write(APIC_LVTT, val & ~APIC_LVT_MASKED);
 }
 
-static void ack_timer_irq(unsigned int irq)
+static void ack_timer_irq(struct irq_desc *desc)
 {
 	ack_APIC_irq();
 }
 
 static struct irq_chip vmi_chip __read_mostly = {
-	.name 		= "VMI-LOCAL",
-	.startup 	= startup_timer_irq,
-	.mask	 	= mask_timer_irq,
-	.unmask	 	= unmask_timer_irq,
-	.ack 		= ack_timer_irq
+	.name		= "VMI-LOCAL",
+	.desc_startup	= startup_timer_irq,
+	.desc_mask	= mask_timer_irq,
+	.desc_unmask	= unmask_timer_irq,
+	.desc_ack	= ack_timer_irq
 };
 #endif
 
diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
index e0f6b26..4142bd8 100644
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -789,22 +789,22 @@ static void lguest_flush_tlb_kernel(void)
  * simple as setting a bit.  We don't actually "ack" interrupts as such, we
  * just mask and unmask them.  I wonder if we should be cleverer?
  */
-static void disable_lguest_irq(unsigned int irq)
+static void disable_lguest_irq(struct irq_desc *desc)
 {
-	set_bit(irq, lguest_data.blocked_interrupts);
+	set_bit(desc->irq, lguest_data.blocked_interrupts);
 }
 
-static void enable_lguest_irq(unsigned int irq)
+static void enable_lguest_irq(struct irq_desc *desc)
 {
-	clear_bit(irq, lguest_data.blocked_interrupts);
+	clear_bit(desc->irq, lguest_data.blocked_interrupts);
 }
 
 /* This structure describes the lguest IRQ controller. */
 static struct irq_chip lguest_irq_controller = {
 	.name		= "lguest",
-	.mask		= disable_lguest_irq,
-	.mask_ack	= disable_lguest_irq,
-	.unmask		= enable_lguest_irq,
+	.desc_mask	= disable_lguest_irq,
+	.desc_mask_ack	= disable_lguest_irq,
+	.desc_unmask	= enable_lguest_irq,
 };
 
 /*
diff --git a/drivers/misc/sgi-gru/grufile.c b/drivers/misc/sgi-gru/grufile.c
index cb3b4d2..037fd35 100644
--- a/drivers/misc/sgi-gru/grufile.c
+++ b/drivers/misc/sgi-gru/grufile.c
@@ -348,15 +348,15 @@ static unsigned long gru_chiplet_cpu_to_mmr(int chiplet, int cpu, int *corep)
 
 static int gru_irq_count[GRU_CHIPLETS_PER_BLADE];
 
-static void gru_noop(unsigned int irq)
+static void gru_noop(struct irq_desc *desc)
 {
 }
 
 static struct irq_chip gru_chip[GRU_CHIPLETS_PER_BLADE] = {
 	[0 ... GRU_CHIPLETS_PER_BLADE - 1] {
-		.mask		= gru_noop,
-		.unmask		= gru_noop,
-		.ack		= gru_noop
+		.desc_mask		= gru_noop,
+		.desc_unmask		= gru_noop,
+		.desc_ack		= gru_noop
 	}
 };
 
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 2f84137..b8c1109 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -725,11 +725,11 @@ static int rebind_irq_to_cpu(unsigned irq, unsigned tcpu)
 	return 0;
 }
 
-static int set_affinity_irq(unsigned irq, const struct cpumask *dest)
+static int set_affinity_irq(struct irq_desc *desc, const struct cpumask *dest)
 {
 	unsigned tcpu = cpumask_first(dest);
 
-	return rebind_irq_to_cpu(irq, tcpu);
+	return rebind_irq_to_cpu(desc->irq, tcpu);
 }
 
 int resend_irq_on_evtchn(unsigned int irq)
@@ -748,35 +748,35 @@ int resend_irq_on_evtchn(unsigned int irq)
 	return 1;
 }
 
-static void enable_dynirq(unsigned int irq)
+static void enable_dynirq(struct irq_desc *desc)
 {
-	int evtchn = evtchn_from_irq(irq);
+	int evtchn = evtchn_from_irq(desc->irq);
 
 	if (VALID_EVTCHN(evtchn))
 		unmask_evtchn(evtchn);
 }
 
-static void disable_dynirq(unsigned int irq)
+static void disable_dynirq(struct irq_desc *desc)
 {
-	int evtchn = evtchn_from_irq(irq);
+	int evtchn = evtchn_from_irq(desc->irq);
 
 	if (VALID_EVTCHN(evtchn))
 		mask_evtchn(evtchn);
 }
 
-static void ack_dynirq(unsigned int irq)
+static void ack_dynirq(struct irq_desc *desc)
 {
-	int evtchn = evtchn_from_irq(irq);
+	int evtchn = evtchn_from_irq(desc->irq);
 
-	move_native_irq(irq);
+	move_native_irq_desc(desc);
 
 	if (VALID_EVTCHN(evtchn))
 		clear_evtchn(evtchn);
 }
 
-static int retrigger_dynirq(unsigned int irq)
+static int retrigger_dynirq(struct irq_desc *desc)
 {
-	int evtchn = evtchn_from_irq(irq);
+	int evtchn = evtchn_from_irq(desc->irq);
 	struct shared_info *sh = HYPERVISOR_shared_info;
 	int ret = 0;
 
@@ -921,15 +921,15 @@ void xen_irq_resume(void)
 }
 
 static struct irq_chip xen_dynamic_chip __read_mostly = {
-	.name		= "xen-dyn",
+	.name			= "xen-dyn",
 
-	.disable	= disable_dynirq,
-	.mask		= disable_dynirq,
-	.unmask		= enable_dynirq,
+	.desc_disable		= disable_dynirq,
+	.desc_mask		= disable_dynirq,
+	.desc_unmask		= enable_dynirq,
 
-	.ack		= ack_dynirq,
-	.set_affinity	= set_affinity_irq,
-	.retrigger	= retrigger_dynirq,
+	.desc_ack		= ack_dynirq,
+	.desc_set_affinity	= set_affinity_irq,
+	.desc_retrigger		= retrigger_dynirq,
 };
 
 void __init xen_init_IRQ(void)
-- 
1.6.4.2

