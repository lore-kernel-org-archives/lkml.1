Return-Path: <linux-kernel-owner+w=401wt.eu-S1752018AbYLWNQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018AbYLWNQb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 08:16:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750995AbYLWNQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 08:16:20 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:33220 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbYLWNQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 08:16:17 -0500
Date: Tue, 23 Dec 2008 14:17:46 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       sparclinux <sparclinux@vger.kernel.org>
Cc: mingo@elte.hu, sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       kenchen@google.com, paulus@samba.org, tglx@linutronix.de, hpa@zytor.com,
       linux-next@vger.kernel.org, davem@davemloft.net
Subject: [PATCH] sparc64: use unsigned long long for u64
Message-ID: <20081223131746.GA7456@uranus.ravnborg.org>
References: <20081222152247.b934ed5b.sfr@canb.auug.org.au> <b040c32a0812212249p45aba306tbb68a960b79cd0ee@mail.gmail.com> <20081222070426.GD29160@elte.hu> <20081222181932.5dd9514e.sfr@canb.auug.org.au> <20081222080341.GA18897@elte.hu> <20081222144319.1bfc0061.akpm@linux-foundation.org> <20081222230035.GB4074@uranus.ravnborg.org> <20081222151338.3b6ef997.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081222151338.3b6ef997.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:

    People keep on doing

            printk("%llu", some_u64);

    testing it only on x86_64 and this generates a warning storm on
    powerpc, sparc64, etc.  Because they use `long', not `long long'.

    Quite a few 64-bit architectures are using `long' for their
    s64/u64 types.  We should convert them all to `long long'.

Update types.h so we use unsigned long long for u64 and
fix all warnings in sparc64 code.
Tested with an allnoconfig, defconfig and allmodconfig builds.

This patch introduces additional warnings in several drivers.
These will be dealt with in separate patches.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---

It may take a few days before the drivers gets fixed.
Christmas is approaching fast by now.

	Sam

 arch/sparc/include/asm/timer_64.h |    2 +-
 arch/sparc/include/asm/types.h    |    2 +-
 arch/sparc/kernel/ds.c            |   34 +++++++++++++++++-----------------
 arch/sparc/kernel/iommu.c         |    2 +-
 arch/sparc/kernel/mdesc.c         |   14 +++++++-------
 arch/sparc/kernel/of_device_64.c  |    2 +-
 arch/sparc/kernel/pci.c           |    2 +-
 arch/sparc/kernel/pci_common.c    |    2 +-
 arch/sparc/kernel/pci_msi.c       |    4 ++--
 arch/sparc/kernel/pci_schizo.c    |    2 +-
 arch/sparc/kernel/pci_sun4v.c     |    2 +-
 arch/sparc/kernel/power.c         |    2 +-
 arch/sparc/kernel/prom_irqtrans.c |    2 +-
 arch/sparc/kernel/psycho_common.c |    2 +-
 arch/sparc/kernel/smp_64.c        |    4 ++--
 arch/sparc/kernel/time_64.c       |   12 ++++++------
 arch/sparc/kernel/traps_64.c      |   20 ++++++++++----------
 arch/sparc/kernel/vio.c           |    4 ++--
 arch/sparc/mm/init_64.c           |   16 ++++++++--------
 19 files changed, 65 insertions(+), 65 deletions(-)

diff --git a/arch/sparc/include/asm/timer_64.h b/arch/sparc/include/asm/timer_64.h
index 5b779fd..ef3c368 100644
--- a/arch/sparc/include/asm/timer_64.h
+++ b/arch/sparc/include/asm/timer_64.h
@@ -10,7 +10,7 @@
 #include <linux/init.h>
 
 struct sparc64_tick_ops {
-	unsigned long (*get_tick)(void);
+	unsigned long long (*get_tick)(void);
 	int (*add_compare)(unsigned long);
 	unsigned long softint_mask;
 	void (*disable_irq)(void);
diff --git a/arch/sparc/include/asm/types.h b/arch/sparc/include/asm/types.h
index 8c28fde..2237118 100644
--- a/arch/sparc/include/asm/types.h
+++ b/arch/sparc/include/asm/types.h
@@ -11,7 +11,7 @@
 #if defined(__sparc__) && defined(__arch64__)
 
 /*** SPARC 64 bit ***/
-#include <asm-generic/int-l64.h>
+#include <asm-generic/int-ll64.h>
 
 #ifndef __ASSEMBLY__
 
diff --git a/arch/sparc/kernel/ds.c b/arch/sparc/kernel/ds.c
index f52e053..57c3984 100644
--- a/arch/sparc/kernel/ds.c
+++ b/arch/sparc/kernel/ds.c
@@ -286,7 +286,7 @@ static void md_update_data(struct ds_info *dp,
 
 	rp = (struct ds_md_update_req *) (dpkt + 1);
 
-	printk(KERN_INFO "ds-%lu: Machine description update.\n", dp->id);
+	printk(KERN_INFO "ds-%llu: Machine description update.\n", dp->id);
 
 	mdesc_update();
 
@@ -325,7 +325,7 @@ static void domain_shutdown_data(struct ds_info *dp,
 
 	rp = (struct ds_shutdown_req *) (dpkt + 1);
 
-	printk(KERN_ALERT "ds-%lu: Shutdown request from "
+	printk(KERN_ALERT "ds-%llu: Shutdown request from "
 	       "LDOM manager received.\n", dp->id);
 
 	memset(&pkt, 0, sizeof(pkt));
@@ -365,7 +365,7 @@ static void domain_panic_data(struct ds_info *dp,
 
 	rp = (struct ds_panic_req *) (dpkt + 1);
 
-	printk(KERN_ALERT "ds-%lu: Panic request from "
+	printk(KERN_ALERT "ds-%llu: Panic request from "
 	       "LDOM manager received.\n", dp->id);
 
 	memset(&pkt, 0, sizeof(pkt));
@@ -549,7 +549,7 @@ static int __cpuinit dr_cpu_configure(struct ds_info *dp,
 	for_each_cpu_mask(cpu, *mask) {
 		int err;
 
-		printk(KERN_INFO "ds-%lu: Starting cpu %d...\n",
+		printk(KERN_INFO "ds-%llu: Starting cpu %d...\n",
 		       dp->id, cpu);
 		err = cpu_up(cpu);
 		if (err) {
@@ -565,7 +565,7 @@ static int __cpuinit dr_cpu_configure(struct ds_info *dp,
 				res = DR_CPU_RES_CPU_NOT_RESPONDING;
 			}
 
-			printk(KERN_INFO "ds-%lu: CPU startup failed err=%d\n",
+			printk(KERN_INFO "ds-%llu: CPU startup failed err=%d\n",
 			       dp->id, err);
 			dr_cpu_mark(resp, cpu, ncpus, res, stat);
 		}
@@ -605,7 +605,7 @@ static int dr_cpu_unconfigure(struct ds_info *dp,
 	for_each_cpu_mask(cpu, *mask) {
 		int err;
 
-		printk(KERN_INFO "ds-%lu: Shutting down cpu %d...\n",
+		printk(KERN_INFO "ds-%llu: Shutting down cpu %d...\n",
 		       dp->id, cpu);
 		err = cpu_down(cpu);
 		if (err)
@@ -684,7 +684,7 @@ static void ds_pri_data(struct ds_info *dp,
 
 	rp = (struct ds_pri_msg *) (dpkt + 1);
 
-	printk(KERN_INFO "ds-%lu: PRI REQ [%lx:%lx], len=%d\n",
+	printk(KERN_INFO "ds-%llu: PRI REQ [%llx:%llx], len=%d\n",
 	       dp->id, rp->req_num, rp->type, len);
 }
 
@@ -816,7 +816,7 @@ void ldom_set_var(const char *var, const char *value)
 
 		if (ds_var_doorbell == 0 ||
 		    ds_var_response != DS_VAR_SUCCESS)
-			printk(KERN_ERR "ds-%lu: var-config [%s:%s] "
+			printk(KERN_ERR "ds-%llu: var-config [%s:%s] "
 			       "failed, response(%d).\n",
 			       dp->id, var, value,
 			       ds_var_response);
@@ -850,7 +850,7 @@ void ldom_power_off(void)
 
 static void ds_conn_reset(struct ds_info *dp)
 {
-	printk(KERN_ERR "ds-%lu: ds_conn_reset() from %p\n",
+	printk(KERN_ERR "ds-%llu: ds_conn_reset() from %p\n",
 	       dp->id, __builtin_return_address(0));
 }
 
@@ -912,11 +912,11 @@ static int ds_handshake(struct ds_info *dp, struct ds_msg_tag *pkt)
 		struct ds_cap_state *cp = find_cap(dp, ap->handle);
 
 		if (!cp) {
-			printk(KERN_ERR "ds-%lu: REG ACK for unknown "
-			       "handle %lx\n", dp->id, ap->handle);
+			printk(KERN_ERR "ds-%llu: REG ACK for unknown "
+			       "handle %llx\n", dp->id, ap->handle);
 			return 0;
 		}
-		printk(KERN_INFO "ds-%lu: Registered %s service.\n",
+		printk(KERN_INFO "ds-%llu: Registered %s service.\n",
 		       dp->id, cp->service_id);
 		cp->state = CAP_STATE_REGISTERED;
 	} else if (pkt->type == DS_REG_NACK) {
@@ -924,8 +924,8 @@ static int ds_handshake(struct ds_info *dp, struct ds_msg_tag *pkt)
 		struct ds_cap_state *cp = find_cap(dp, np->handle);
 
 		if (!cp) {
-			printk(KERN_ERR "ds-%lu: REG NACK for "
-			       "unknown handle %lx\n",
+			printk(KERN_ERR "ds-%llu: REG NACK for "
+			       "unknown handle %llx\n",
 			       dp->id, np->handle);
 			return 0;
 		}
@@ -982,8 +982,8 @@ static void process_ds_work(void)
 		int req_len = qp->req_len;
 
 		if (!cp) {
-			printk(KERN_ERR "ds-%lu: Data for unknown "
-			       "handle %lu\n",
+			printk(KERN_ERR "ds-%llu: Data for unknown "
+			       "handle %llu\n",
 			       dp->id, dpkt->handle);
 
 			spin_lock_irqsave(&ds_lock, flags);
@@ -1085,7 +1085,7 @@ static void ds_event(void *arg, int event)
 	}
 
 	if (event != LDC_EVENT_DATA_READY) {
-		printk(KERN_WARNING "ds-%lu: Unexpected LDC event %d\n",
+		printk(KERN_WARNING "ds-%llu: Unexpected LDC event %d\n",
 		       dp->id, event);
 		spin_unlock_irqrestore(&ds_lock, flags);
 		return;
diff --git a/arch/sparc/kernel/iommu.c b/arch/sparc/kernel/iommu.c
index 1cc1995..d8900e1 100644
--- a/arch/sparc/kernel/iommu.c
+++ b/arch/sparc/kernel/iommu.c
@@ -434,7 +434,7 @@ static void strbuf_flush(struct strbuf *strbuf, struct iommu *iommu,
 		val = iommu_read(matchreg);
 		if (unlikely(val)) {
 			printk(KERN_WARNING "strbuf_flush: ctx flush "
-			       "timeout matchreg[%lx] ctx[%lx]\n",
+			       "timeout matchreg[%llx] ctx[%lx]\n",
 			       val, ctx);
 			goto do_page_flush;
 		}
diff --git a/arch/sparc/kernel/mdesc.c b/arch/sparc/kernel/mdesc.c
index 3c539a6..3f79f0c 100644
--- a/arch/sparc/kernel/mdesc.c
+++ b/arch/sparc/kernel/mdesc.c
@@ -536,24 +536,24 @@ static void __init report_platform_properties(void)
 
 	v = mdesc_get_property(hp, pn, "hostid", NULL);
 	if (v)
-		printk("PLATFORM: hostid [%08lx]\n", *v);
+		printk("PLATFORM: hostid [%08llx]\n", *v);
 	v = mdesc_get_property(hp, pn, "serial#", NULL);
 	if (v)
-		printk("PLATFORM: serial# [%08lx]\n", *v);
+		printk("PLATFORM: serial# [%08llx]\n", *v);
 	v = mdesc_get_property(hp, pn, "stick-frequency", NULL);
-	printk("PLATFORM: stick-frequency [%08lx]\n", *v);
+	printk("PLATFORM: stick-frequency [%08llx]\n", *v);
 	v = mdesc_get_property(hp, pn, "mac-address", NULL);
 	if (v)
-		printk("PLATFORM: mac-address [%lx]\n", *v);
+		printk("PLATFORM: mac-address [%llx]\n", *v);
 	v = mdesc_get_property(hp, pn, "watchdog-resolution", NULL);
 	if (v)
-		printk("PLATFORM: watchdog-resolution [%lu ms]\n", *v);
+		printk("PLATFORM: watchdog-resolution [%llu ms]\n", *v);
 	v = mdesc_get_property(hp, pn, "watchdog-max-timeout", NULL);
 	if (v)
-		printk("PLATFORM: watchdog-max-timeout [%lu ms]\n", *v);
+		printk("PLATFORM: watchdog-max-timeout [%llu ms]\n", *v);
 	v = mdesc_get_property(hp, pn, "max-cpus", NULL);
 	if (v)
-		printk("PLATFORM: max-cpus [%lu]\n", *v);
+		printk("PLATFORM: max-cpus [%llu]\n", *v);
 
 #ifdef CONFIG_SMP
 	{
diff --git a/arch/sparc/kernel/of_device_64.c b/arch/sparc/kernel/of_device_64.c
index 0f616ae..d8b8ad9 100644
--- a/arch/sparc/kernel/of_device_64.c
+++ b/arch/sparc/kernel/of_device_64.c
@@ -554,7 +554,7 @@ static void __init build_device_resources(struct of_device *op,
 		memset(r, 0, sizeof(*r));
 
 		if (of_resource_verbose)
-			printk("%s reg[%d] -> %lx\n",
+			printk("%s reg[%d] -> %llx\n",
 			       op->node->full_name, index,
 			       result);
 
diff --git a/arch/sparc/kernel/pci.c b/arch/sparc/kernel/pci.c
index bdb7c0a..923e9bb 100644
--- a/arch/sparc/kernel/pci.c
+++ b/arch/sparc/kernel/pci.c
@@ -223,7 +223,7 @@ static void pci_parse_of_addrs(struct of_device *op,
 			continue;
 		i = addrs[0] & 0xff;
 		if (ofpci_verbose)
-			printk("  start: %lx, end: %lx, i: %x\n",
+			printk("  start: %llx, end: %llx, i: %x\n",
 			       op_res->start, op_res->end, i);
 
 		if (PCI_BASE_ADDRESS_0 <= i && i <= PCI_BASE_ADDRESS_5) {
diff --git a/arch/sparc/kernel/pci_common.c b/arch/sparc/kernel/pci_common.c
index 23b8808..64e6edf 100644
--- a/arch/sparc/kernel/pci_common.c
+++ b/arch/sparc/kernel/pci_common.c
@@ -457,7 +457,7 @@ void pci_determine_mem_io_space(struct pci_pbm_info *pbm)
 		prom_halt();
 	}
 
-	printk("%s: PCI IO[%lx] MEM[%lx]\n",
+	printk("%s: PCI IO[%llx] MEM[%llx]\n",
 	       pbm->name,
 	       pbm->io_space.start,
 	       pbm->mem_space.start);
diff --git a/arch/sparc/kernel/pci_msi.c b/arch/sparc/kernel/pci_msi.c
index 2e680f3..a4d38cf 100644
--- a/arch/sparc/kernel/pci_msi.c
+++ b/arch/sparc/kernel/pci_msi.c
@@ -426,8 +426,8 @@ void sparc64_pbm_msi_init(struct pci_pbm_info *pbm,
 		       pbm->name,
 		       pbm->msi_first, pbm->msi_num, pbm->msi_data_mask,
 		       pbm->msix_data_width);
-		printk(KERN_INFO "%s: MSI addr32[0x%lx:0x%x] "
-		       "addr64[0x%lx:0x%x]\n",
+		printk(KERN_INFO "%s: MSI addr32[0x%llx:0x%x] "
+		       "addr64[0x%llx:0x%x]\n",
 		       pbm->name,
 		       pbm->msi32_start, pbm->msi32_len,
 		       pbm->msi64_start, pbm->msi64_len);
diff --git a/arch/sparc/kernel/pci_schizo.c b/arch/sparc/kernel/pci_schizo.c
index 45d9dba..2b5cdde 100644
--- a/arch/sparc/kernel/pci_schizo.c
+++ b/arch/sparc/kernel/pci_schizo.c
@@ -794,7 +794,7 @@ static irqreturn_t schizo_safarierr_intr(int irq, void *dev_id)
 		   pbm->controller_regs + SCHIZO_SAFARI_ERRLOG);
 
 	if (!(errlog & BUS_ERROR_UNMAP)) {
-		printk("%s: Unexpected Safari/JBUS error interrupt, errlog[%016lx]\n",
+		printk("%s: Unexpected Safari/JBUS error interrupt, errlog[%016llx]\n",
 		       pbm->name, errlog);
 
 		return IRQ_HANDLED;
diff --git a/arch/sparc/kernel/pci_sun4v.c b/arch/sparc/kernel/pci_sun4v.c
index 34a1fde..0ef0ab3 100644
--- a/arch/sparc/kernel/pci_sun4v.c
+++ b/arch/sparc/kernel/pci_sun4v.c
@@ -73,7 +73,7 @@ static long iommu_batch_flush(struct iommu_batch *p)
 		if (unlikely(num < 0)) {
 			if (printk_ratelimit())
 				printk("iommu_batch_flush: IOMMU map of "
-				       "[%08lx:%08lx:%lx:%lx:%lx] failed with "
+				       "[%08lx:%08llx:%lx:%lx:%lx] failed with "
 				       "status %ld\n",
 				       devhandle, HV_PCI_TSBID(0, entry),
 				       npages, prot, __pa(pglist), num);
diff --git a/arch/sparc/kernel/power.c b/arch/sparc/kernel/power.c
index 076cad7..ae88f06 100644
--- a/arch/sparc/kernel/power.c
+++ b/arch/sparc/kernel/power.c
@@ -40,7 +40,7 @@ static int __devinit power_probe(struct of_device *op, const struct of_device_id
 
 	power_reg = of_ioremap(res, 0, 0x4, "power");
 
-	printk(KERN_INFO "%s: Control reg at %lx\n",
+	printk(KERN_INFO "%s: Control reg at %llx\n",
 	       op->node->name, res->start);
 
 	if (has_button_interrupt(irq, op->node)) {
diff --git a/arch/sparc/kernel/prom_irqtrans.c b/arch/sparc/kernel/prom_irqtrans.c
index 96958c4..5702ad4 100644
--- a/arch/sparc/kernel/prom_irqtrans.c
+++ b/arch/sparc/kernel/prom_irqtrans.c
@@ -346,7 +346,7 @@ static void tomatillo_wsync_handler(unsigned int ino, void *_arg1, void *_arg2)
 			break;
 	}
 	if (limit <= 0) {
-		printk("tomatillo_wsync_handler: DMA won't sync [%lx:%lx]\n",
+		printk("tomatillo_wsync_handler: DMA won't sync [%llx:%llx]\n",
 		       val, mask);
 	}
 
diff --git a/arch/sparc/kernel/psycho_common.c b/arch/sparc/kernel/psycho_common.c
index 7909964..f6193bc 100644
--- a/arch/sparc/kernel/psycho_common.c
+++ b/arch/sparc/kernel/psycho_common.c
@@ -331,7 +331,7 @@ irqreturn_t psycho_pcierr_intr(int irq, void *dev_id)
 	       (afsr & PSYCHO_PCIAFSR_BMSK) >> 32UL,
 	       (afsr & PSYCHO_PCIAFSR_MID) >> 25UL,
 	       (afsr & PSYCHO_PCIAFSR_BLK) ? 1 : 0);
-	printk(KERN_ERR "%s: PCI AFAR [%016lx]\n", pbm->name, afar);
+	printk(KERN_ERR "%s: PCI AFAR [%016llx]\n", pbm->name, afar);
 	printk(KERN_ERR "%s: PCI Secondary errors [", pbm->name);
 	reported = 0;
 	if (afsr & PSYCHO_PCIAFSR_SMA) {
diff --git a/arch/sparc/kernel/smp_64.c b/arch/sparc/kernel/smp_64.c
index bfe99d8..6aa3aa1 100644
--- a/arch/sparc/kernel/smp_64.c
+++ b/arch/sparc/kernel/smp_64.c
@@ -453,7 +453,7 @@ again:
 	__asm__ __volatile__("wrpr %0, 0x0, %%pstate"
 			     : : "r" (pstate));
 	if (stuck == 0) {
-		printk("CPU[%d]: mondo stuckage result[%016lx]\n",
+		printk("CPU[%d]: mondo stuckage result[%016llx]\n",
 		       smp_processor_id(), result);
 	} else {
 		udelay(2);
@@ -588,7 +588,7 @@ retry:
 			/* Busy bits will not clear, continue instead
 			 * of freezing up on this cpu.
 			 */
-			printk("CPU[%d]: mondo stuckage result[%016lx]\n",
+			printk("CPU[%d]: mondo stuckage result[%016llx]\n",
 			       smp_processor_id(), dispatch_stat);
 		} else {
 			int i, this_busy_nack = 0;
diff --git a/arch/sparc/kernel/time_64.c b/arch/sparc/kernel/time_64.c
index 141da37..22a1f63 100644
--- a/arch/sparc/kernel/time_64.c
+++ b/arch/sparc/kernel/time_64.c
@@ -106,7 +106,7 @@ static void tick_init_tick(void)
 	tick_disable_irq();
 }
 
-static unsigned long tick_get_tick(void)
+static unsigned long long tick_get_tick(void)
 {
 	unsigned long ret;
 
@@ -208,7 +208,7 @@ static void stick_init_tick(void)
 	stick_disable_irq();
 }
 
-static unsigned long stick_get_tick(void)
+static unsigned long long stick_get_tick(void)
 {
 	unsigned long ret;
 
@@ -352,7 +352,7 @@ static void hbtick_init_tick(void)
 	hbtick_disable_irq();
 }
 
-static unsigned long hbtick_get_tick(void)
+static unsigned long long hbtick_get_tick(void)
 {
 	return __hbird_read_stick() & ~TICK_PRIV_BIT;
 }
@@ -422,7 +422,7 @@ static int __devinit rtc_probe(struct of_device *op, const struct of_device_id *
 {
 	struct resource *r;
 
-	printk(KERN_INFO "%s: RTC regs at 0x%lx\n",
+	printk(KERN_INFO "%s: RTC regs at 0x%llx\n",
 	       op->node->full_name, op->resource[0].start);
 
 	/* The CMOS RTC driver only accepts IORESOURCE_IO, so cons
@@ -478,7 +478,7 @@ static struct platform_device rtc_bq4802_device = {
 static int __devinit bq4802_probe(struct of_device *op, const struct of_device_id *match)
 {
 
-	printk(KERN_INFO "%s: BQ4802 regs at 0x%lx\n",
+	printk(KERN_INFO "%s: BQ4802 regs at 0x%llx\n",
 	       op->node->full_name, op->resource[0].start);
 
 	rtc_bq4802_device.resource = &op->resource[0];
@@ -542,7 +542,7 @@ static int __devinit mostek_probe(struct of_device *op, const struct of_device_i
 	    strcmp(dp->parent->parent->name, "central") != 0)
 		return -ENODEV;
 
-	printk(KERN_INFO "%s: Mostek regs at 0x%lx\n",
+	printk(KERN_INFO "%s: Mostek regs at 0x%llx\n",
 	       dp->full_name, op->resource[0].start);
 
 	m48t59_rtc.resource = &op->resource[0];
diff --git a/arch/sparc/kernel/traps_64.c b/arch/sparc/kernel/traps_64.c
index 4638af2..bca3b4e 100644
--- a/arch/sparc/kernel/traps_64.c
+++ b/arch/sparc/kernel/traps_64.c
@@ -1168,20 +1168,20 @@ static void cheetah_log_errors(struct pt_regs *regs, struct cheetah_err_info *in
 	}
 
 	/* Now dump the cache snapshots. */
-	printk("%s" "ERROR(%d): D-cache idx[%x] tag[%016lx] utag[%016lx] stag[%016lx]\n",
+	printk("%s" "ERROR(%d): D-cache idx[%x] tag[%016llx] utag[%016llx] stag[%016llx]\n",
 	       (recoverable ? KERN_WARNING : KERN_CRIT), smp_processor_id(),
 	       (int) info->dcache_index,
 	       info->dcache_tag,
 	       info->dcache_utag,
 	       info->dcache_stag);
-	printk("%s" "ERROR(%d): D-cache data0[%016lx] data1[%016lx] data2[%016lx] data3[%016lx]\n",
+	printk("%s" "ERROR(%d): D-cache data0[%016llx] data1[%016llx] data2[%016llx] data3[%016llx]\n",
 	       (recoverable ? KERN_WARNING : KERN_CRIT), smp_processor_id(),
 	       info->dcache_data[0],
 	       info->dcache_data[1],
 	       info->dcache_data[2],
 	       info->dcache_data[3]);
-	printk("%s" "ERROR(%d): I-cache idx[%x] tag[%016lx] utag[%016lx] stag[%016lx] "
-	       "u[%016lx] l[%016lx]\n",
+	printk("%s" "ERROR(%d): I-cache idx[%x] tag[%016llx] utag[%016llx] stag[%016llx] "
+	       "u[%016llx] l[%016llx]\n",
 	       (recoverable ? KERN_WARNING : KERN_CRIT), smp_processor_id(),
 	       (int) info->icache_index,
 	       info->icache_tag,
@@ -1189,22 +1189,22 @@ static void cheetah_log_errors(struct pt_regs *regs, struct cheetah_err_info *in
 	       info->icache_stag,
 	       info->icache_upper,
 	       info->icache_lower);
-	printk("%s" "ERROR(%d): I-cache INSN0[%016lx] INSN1[%016lx] INSN2[%016lx] INSN3[%016lx]\n",
+	printk("%s" "ERROR(%d): I-cache INSN0[%016llx] INSN1[%016llx] INSN2[%016llx] INSN3[%016llx]\n",
 	       (recoverable ? KERN_WARNING : KERN_CRIT), smp_processor_id(),
 	       info->icache_data[0],
 	       info->icache_data[1],
 	       info->icache_data[2],
 	       info->icache_data[3]);
-	printk("%s" "ERROR(%d): I-cache INSN4[%016lx] INSN5[%016lx] INSN6[%016lx] INSN7[%016lx]\n",
+	printk("%s" "ERROR(%d): I-cache INSN4[%016llx] INSN5[%016llx] INSN6[%016llx] INSN7[%016llx]\n",
 	       (recoverable ? KERN_WARNING : KERN_CRIT), smp_processor_id(),
 	       info->icache_data[4],
 	       info->icache_data[5],
 	       info->icache_data[6],
 	       info->icache_data[7]);
-	printk("%s" "ERROR(%d): E-cache idx[%x] tag[%016lx]\n",
+	printk("%s" "ERROR(%d): E-cache idx[%x] tag[%016llx]\n",
 	       (recoverable ? KERN_WARNING : KERN_CRIT), smp_processor_id(),
 	       (int) info->ecache_index, info->ecache_tag);
-	printk("%s" "ERROR(%d): E-cache data0[%016lx] data1[%016lx] data2[%016lx] data3[%016lx]\n",
+	printk("%s" "ERROR(%d): E-cache data0[%016llx] data1[%016llx] data2[%016llx] data3[%016llx]\n",
 	       (recoverable ? KERN_WARNING : KERN_CRIT), smp_processor_id(),
 	       info->ecache_data[0],
 	       info->ecache_data[1],
@@ -1794,7 +1794,7 @@ static void sun4v_log_error(struct pt_regs *regs, struct sun4v_error_entry *ent,
 	int cnt;
 
 	printk("%s: Reporting on cpu %d\n", pfx, cpu);
-	printk("%s: err_handle[%lx] err_stick[%lx] err_type[%08x:%s]\n",
+	printk("%s: err_handle[%llx] err_stick[%llx] err_type[%08x:%s]\n",
 	       pfx,
 	       ent->err_handle, ent->err_stick,
 	       ent->err_type,
@@ -1818,7 +1818,7 @@ static void sun4v_log_error(struct pt_regs *regs, struct sun4v_error_entry *ent,
 		"privileged" : ""),
 	       ((ent->err_attrs & SUN4V_ERR_ATTRS_RES_QUEUE_FULL) ?
 		"queue-full" : ""));
-	printk("%s: err_raddr[%016lx] err_size[%u] err_cpu[%u]\n",
+	printk("%s: err_raddr[%016llx] err_size[%u] err_cpu[%u]\n",
 	       pfx,
 	       ent->err_raddr, ent->err_size, ent->err_cpu);
 
diff --git a/arch/sparc/kernel/vio.c b/arch/sparc/kernel/vio.c
index 92b1f8e..753d128 100644
--- a/arch/sparc/kernel/vio.c
+++ b/arch/sparc/kernel/vio.c
@@ -263,10 +263,10 @@ static struct vio_dev *vio_create_one(struct mdesc_handle *hp, u64 mp,
 		dev_set_name(&vdev->dev, "%s", bus_id_name);
 		vdev->dev_no = ~(u64)0;
 	} else if (!cfg_handle) {
-		dev_set_name(&vdev->dev, "%s-%lu", bus_id_name, *id);
+		dev_set_name(&vdev->dev, "%s-%llu", bus_id_name, *id);
 		vdev->dev_no = *id;
 	} else {
-		dev_set_name(&vdev->dev, "%s-%lu-%lu", bus_id_name,
+		dev_set_name(&vdev->dev, "%s-%llu-%llu", bus_id_name,
 			     *cfg_handle, *id);
 		vdev->dev_no = *cfg_handle;
 	}
diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index 6ea73da..be157a7 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -769,8 +769,8 @@ static int find_node(unsigned long addr)
 	return -1;
 }
 
-static unsigned long nid_range(unsigned long start, unsigned long end,
-			       int *nid)
+static unsigned long long nid_range(unsigned long long start,
+				    unsigned long long end, int *nid)
 {
 	*nid = find_node(start);
 	start += PAGE_SIZE;
@@ -788,8 +788,8 @@ static unsigned long nid_range(unsigned long start, unsigned long end,
 	return start;
 }
 #else
-static unsigned long nid_range(unsigned long start, unsigned long end,
-			       int *nid)
+static unsigned long long nid_range(unsigned long long start,
+				    unsigned long long end, int *nid)
 {
 	*nid = 0;
 	return end;
@@ -1016,8 +1016,8 @@ static int __init grab_mlgroups(struct mdesc_handle *md)
 		val = mdesc_get_property(md, node, "address-mask", NULL);
 		m->mask = *val;
 
-		numadbg("MLGROUP[%d]: node[%lx] latency[%lx] "
-			"match[%lx] mask[%lx]\n",
+		numadbg("MLGROUP[%d]: node[%llx] latency[%llx] "
+			"match[%llx] mask[%llx]\n",
 			count - 1, m->node, m->latency, m->match, m->mask);
 	}
 
@@ -1056,7 +1056,7 @@ static int __init grab_mblocks(struct mdesc_handle *md)
 					 "address-congruence-offset", NULL);
 		m->offset = *val;
 
-		numadbg("MBLOCK[%d]: base[%lx] size[%lx] offset[%lx]\n",
+		numadbg("MBLOCK[%d]: base[%llx] size[%llx] offset[%llx]\n",
 			count - 1, m->base, m->size, m->offset);
 	}
 
@@ -1127,7 +1127,7 @@ static int __init numa_attach_mlgroup(struct mdesc_handle *md, u64 grp,
 	n->mask = candidate->mask;
 	n->val = candidate->match;
 
-	numadbg("NUMA NODE[%d]: mask[%lx] val[%lx] (latency[%lx])\n",
+	numadbg("NUMA NODE[%d]: mask[%lx] val[%lx] (latency[%llx])\n",
 		index, n->mask, n->val, candidate->latency);
 
 	return 0;
-- 
1.6.0.2.GIT

