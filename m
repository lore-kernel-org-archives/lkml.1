Return-Path: <linux-kernel-owner+w=401wt.eu-S1752408AbYE2Kog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752408AbYE2Kog (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 06:44:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750857AbYE2Ko0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 06:44:26 -0400
Received: from mail.windriver.com ([147.11.1.11]:47193 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750804AbYE2KoY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 06:44:24 -0400
Subject: Re: [PATCH] x86: Get irq for hpet timer
From: Kevin Hao <kexin.hao@windriver.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Clemens Ladisch <clemens@ladisch.de>, venkatesh.pallipadi@intel.com,
       bob.picco@hp.com, mingo@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, Balaji Rao <balajirrao@gmail.com>
In-Reply-To: <Pine.LNX.4.55.0805290348350.29522@cliff.in.clinika.pl>
References: <1210917912.10881.1.camel@kevin-desktop>
	 <482D49CF.4030902@ladisch.de> <1210929270.11912.3.camel@kevin-desktop>
	 <4831A678.5070208@ladisch.de> <1211274219.8718.7.camel@kevin-desktop>
	 <Pine.LNX.4.55.0805201631010.31790@cliff.in.clinika.pl>
	 <4833DD38.2010702@ladisch.de>
	 <Pine.LNX.4.55.0805220105560.4894@cliff.in.clinika.pl>
	 <1211441231.7323.10.camel@kevin-desktop>
	 <Pine.LNX.4.55.0805221609280.13339@cliff.in.clinika.pl>
	 <1211971330.6085.33.camel@kevin-desktop>
	 <Pine.LNX.4.55.0805290348350.29522@cliff.in.clinika.pl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Date: Thu, 29 May 2008 18:41:04 +0800
Message-Id: <1212057664.8343.29.camel@kevin-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
X-OriginalArrivalTime: 29 May 2008 10:41:52.0044 (UTC) FILETIME=[9AFB0EC0:01C8C178]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-29 at 04:13 +0100, Maciej W. Rozycki wrote: 
> On Wed, 28 May 2008, Kevin Hao wrote:
> 
> > BTW, Maciej. I am not familiar with ACPI subsystem. But I think the 
> > acpi_register_gsi should return -1 if mp_find_ioapic return error.
> > Is that right? If you also think so, I will make a patch for that.
> 
>  Well, the interface is documented in the sources -- I do not feel like
> reading through all the execution paths to see whether the implementation
> matches though. ;)
> 
>  A few comments below -- I may not have time available to throw your piece 
> of code at a piece of hardware though.
> 
> > +	/* we prefer level triggered mode */
> > +	v = readl(&timer->hpet_config);
> > +	if (!(v & Tn_INT_TYPE_CNF_MASK)) {
> > +		v |= Tn_INT_TYPE_CNF_MASK;
> > +		writel(v, &timer->hpet_config);
> > +	}
> 
>  Please note that when routing through the 8259A you need to match the
> trigger mode set for the respective input.  It is normally set in the ELCR
> register in the hardware and should be recorded in the ACPI interrupt
> source tables too -- the default for IRQ0-15 is edge-triggered, active
> high, unless overridden.

The IRQ trigger mode is set to level by acpi_register_gsi in PIC mode.
And I have tested it on a host using legacy PIC. It works well.

﻿Yes, we should record these information in ACPI interrupt source table.
And I have noticed that a patch has been made to update mptable. 
http://lkml.org/lkml/2008/5/25/255

We can use mp_config_acpi_gsi to setup route table. But now can we add
somethings like "FIXME: setup interrupt source table" and wait for that
patch to be merged?

> 
> > +	v = (readq(&timer->hpet_config) & Tn_INT_ROUTE_CAP_MASK)
> > +				 >> Tn_INT_ROUTE_CAP_SHIFT;
> 
>  The operator should be at the end of the first line IMHO.

Ok, fix it.

> 
> > +	/*
> > +	 * In PIC mode, skip IRQ0-4, IRQ6-8, IRQ12-15 which is always used by
> > +	 * legacy device. In IO APIC mode, we skip all the legacy IRQS.
> > +	 */
> 
>  Quite reasonable assumption IMO, but again -- I'd expect the information 
> about legacy devices present on these lines to be recorded in ACPI tables.  
> Note that IRQ9 is used for the SCI -- I am not sure if that's a good 
> choice for sharing.

Add IRQ9 to the skipping IRQS.

> 
> > +		gsi = acpi_register_gsi(irq, ACPI_LEVEL_SENSITIVE,
> > +					ACPI_ACTIVE_LOW);
> 
>  I am assuming you have verified ACPI_ACTIVE_LOW works here, contrary to 
> the HPET spec.

Yes, It can work with other PCI device in ACPI_ACTIVE_LOW polarity.

> 
> > +	if  (irq < HPET_MAX_IRQ) {
> 
>  Single space here.

Ok, deleted.

> 
> > @@ -37,6 +37,7 @@ struct hpet {
> >  #define	hpet_compare	_u1._hpet_compare
> >  
> >  #define	HPET_MAX_TIMERS	(32)
> > +#define HPET_MAX_IRQ	(32)
> 
>  Tab here for consistency with the others?

Ok, fix it.

Thanks for your comments.

---
    HPET timer's IRQ is 0 by default. So we have to select which irq
    will be used by these timers. We wait to set the timer's irq until
    we really open it in order to reduce the chance of conflicting with
    other device.
    
    Signed-off-by: Kevin Hao <kexin.hao@windriver.com>
---
diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index e7fb0bc..c9bf5d4 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -184,6 +184,67 @@ static irqreturn_t hpet_interrupt(int irq, void *data)
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
+	v = (readq(&timer->hpet_config) & Tn_INT_ROUTE_CAP_MASK) >>
+				 Tn_INT_ROUTE_CAP_SHIFT;
+
+	/*
+	 * In PIC mode, skip IRQ0-4, IRQ6-9, IRQ12-15 which is always used by
+	 * legacy device. In IO APIC mode, we skip all the legacy IRQS.
+	 */
+	if (acpi_irq_model == ACPI_IRQ_MODEL_PIC)
+		v &= ~0xf3df;
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
+
+		/* FIXME: Setup interrupt source table */
+	}
+
+	if (irq < HPET_MAX_IRQ) {
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
@@ -215,6 +276,8 @@ static int hpet_open(struct inode *inode, struct file *file)
 	devp->hd_flags |= HPET_OPEN;
 	spin_unlock_irq(&hpet_lock);
 
+	hpet_timer_set_irq(devp);
+
 	return 0;
 }
 
diff --git a/include/linux/hpet.h b/include/linux/hpet.h
index 2dc29ce..6d2626b 100644
--- a/include/linux/hpet.h
+++ b/include/linux/hpet.h
@@ -37,6 +37,7 @@ struct hpet {
 #define	hpet_compare	_u1._hpet_compare
 
 #define	HPET_MAX_TIMERS	(32)
+#define	HPET_MAX_IRQ	(32)
 
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

> 
>  Otherwise no obvious problems.
> 
>   Maciej
