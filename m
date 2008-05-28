Return-Path: <linux-kernel-owner+w=401wt.eu-S1754860AbYE1KnM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860AbYE1KnM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 06:43:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752431AbYE1Km5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 06:42:57 -0400
Received: from mail.windriver.com ([147.11.1.11]:34171 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752212AbYE1Km4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 06:42:56 -0400
Subject: Re: [PATCH] x86: Get irq for hpet timer
From: Kevin Hao <kexin.hao@windriver.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Clemens Ladisch <clemens@ladisch.de>, venkatesh.pallipadi@intel.com,
       bob.picco@hp.com, mingo@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, Balaji Rao <balajirrao@gmail.com>
In-Reply-To: <Pine.LNX.4.55.0805221609280.13339@cliff.in.clinika.pl>
References: <1210917912.10881.1.camel@kevin-desktop>
	 <482D49CF.4030902@ladisch.de> <1210929270.11912.3.camel@kevin-desktop>
	 <4831A678.5070208@ladisch.de> <1211274219.8718.7.camel@kevin-desktop>
	 <Pine.LNX.4.55.0805201631010.31790@cliff.in.clinika.pl>
	 <4833DD38.2010702@ladisch.de>
	 <Pine.LNX.4.55.0805220105560.4894@cliff.in.clinika.pl>
	 <1211441231.7323.10.camel@kevin-desktop>
	 <Pine.LNX.4.55.0805221609280.13339@cliff.in.clinika.pl>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 28 May 2008 18:42:10 +0800
Message-Id: <1211971330.6085.33.camel@kevin-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
X-OriginalArrivalTime: 28 May 2008 10:41:50.0003 (UTC) FILETIME=[6F59E030:01C8C0AF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the delays.

I have revised this patch according to Maciej & Clemens suggestions.
The modifications include:

1. Assign a irq to the timer when we open the timer device. I think it's
better than do it in platform code. So we will have little impact on
other device.

2. Set IRQ routing entry for the irq we select.

3. If we in PIC mode, we skip all the well known legacy IRQ. And in io
apic we skip all the legacy IRQ.

4. Use level triggered mode by default.

BTW, Maciej. I am not familiar with ACPI subsystem. But I think the 
acpi_register_gsi should return -1 if mp_find_ioapic return error.
Is that right? If you also think so, I will make a patch for that.

---
 drivers/char/hpet.c  |   61 +++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/hpet.h |    3 +-
 2 files changed, 63 insertions(+), 1 deletion(-)
---
commit fa8e14bc3abb93832fbc9b7f86da0d2cf5b3b7a7
Author: Kevin Hao <kexin.hao@windriver.com>
Date:   Wed May 28 13:28:20 2008 +0800

    HPET timer's IRQ is 0 by default. So we have to select which irq
    will be used by these timers. We wait to set the timer's irq until
    we really open it in order to reduce the chance of conflicting with
    other device.
    
    Signed-off-by: Kevin Hao <kexin.hao@windriver.com>

diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index e7fb0bc..94dbfdc 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -184,6 +184,65 @@ static irqreturn_t hpet_interrupt(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
+static void hpet_timer_set_irq(struct hpet_dev *devp)
+{
+	unsigned long v;
+	int irq, gsi;
+	struct hpet_timer __iomem *timer;
+
+	spin_lock_irq(&hpet_lock);
+	if (devp->hd_hdwirq) {
+		spin_unlock_irq(&hpet_lock);
+		return;
+	}
+
+	timer = devp->hd_timer;
+
+	/* we prefer level triggered mode */
+	v = readl(&timer->hpet_config);
+	if (!(v & Tn_INT_TYPE_CNF_MASK)) {
+		v |= Tn_INT_TYPE_CNF_MASK;
+		writel(v, &timer->hpet_config);
+	}
+	spin_unlock_irq(&hpet_lock);
+
+	v = (readq(&timer->hpet_config) & Tn_INT_ROUTE_CAP_MASK)
+				 >> Tn_INT_ROUTE_CAP_SHIFT;
+
+	/*
+	 * In PIC mode, skip IRQ0-4, IRQ6-8, IRQ12-15 which is always used by
+	 * legacy device. In IO APIC mode, we skip all the legacy IRQS.
+	 */
+	if (acpi_irq_model == ACPI_IRQ_MODEL_PIC)
+		v &= ~0xf1df;
+	else
+		v &= ~0xffff;
+
+	for (irq = find_first_bit(&v, HPET_MAX_IRQ); irq < HPET_MAX_IRQ;
+		irq = find_next_bit(&v, HPET_MAX_IRQ, 1 + irq)) {
+
+		if (irq >= NR_IRQS) {
+			irq = HPET_MAX_IRQ;
+			break;
+		}
+
+		gsi = acpi_register_gsi(irq, ACPI_LEVEL_SENSITIVE,
+					ACPI_ACTIVE_LOW);
+		if (gsi > 0)
+			break;
+	}
+
+	if  (irq < HPET_MAX_IRQ) {
+		spin_lock_irq(&hpet_lock);
+		v = readl(&timer->hpet_config);
+		v |= irq << Tn_INT_ROUTE_CNF_SHIFT;
+		writel(v, &timer->hpet_config);
+		devp->hd_hdwirq = gsi;
+		spin_unlock_irq(&hpet_lock);
+	}
+	return;
+}
+
 static int hpet_open(struct inode *inode, struct file *file)
 {
 	struct hpet_dev *devp;
@@ -215,6 +274,8 @@ static int hpet_open(struct inode *inode, struct file *file)
 	devp->hd_flags |= HPET_OPEN;
 	spin_unlock_irq(&hpet_lock);
 
+	hpet_timer_set_irq(devp);
+
 	return 0;
 }
 
diff --git a/include/linux/hpet.h b/include/linux/hpet.h
index 2dc29ce..440ca72 100644
--- a/include/linux/hpet.h
+++ b/include/linux/hpet.h
@@ -37,6 +37,7 @@ struct hpet {
 #define	hpet_compare	_u1._hpet_compare
 
 #define	HPET_MAX_TIMERS	(32)
+#define HPET_MAX_IRQ	(32)
 
 /*
  * HPET general capabilities register
@@ -64,7 +65,7 @@ struct hpet {
  */
 
 #define	Tn_INT_ROUTE_CAP_MASK		(0xffffffff00000000ULL)
-#define	Tn_INI_ROUTE_CAP_SHIFT		(32UL)
+#define	Tn_INT_ROUTE_CAP_SHIFT		(32UL)
 #define	Tn_FSB_INT_DELCAP_MASK		(0x8000UL)
 #define	Tn_FSB_INT_DELCAP_SHIFT		(15)
 #define	Tn_FSB_EN_CNF_MASK		(0x4000UL)
---

Best Regards,
Kevin


On Thu, 2008-05-22 at 16:25 +0100, Maciej W. Rozycki wrote: 
> On Thu, 22 May 2008, Kevin Hao wrote:
> 
> > But if we avoid all the legacy range, the hpet timer will have no chance
> > to work on a host using legacy PIC.
> 
>  It's not meant to be wired to the legacy PIC anyway (except from the
> timers #0 and #1 in some configurations, meant to emulate timer interrupts
> of the 8254 and the RTC), though I can imagine such a non-standard
> extension.
> 
> > Yes, we should setup routing in the I/O APIC and use level-triggered
> > mode. I think it's better to use acpi_register_gsi than mp_register_gsi.
> > Is that right?
> 
>  It sounds right to me.
> 
>   Maciej
