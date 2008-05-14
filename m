Return-Path: <linux-kernel-owner+w=401wt.eu-S1763440AbYENPD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763440AbYENPD2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 11:03:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762737AbYENPCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 11:02:39 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:51250 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932325AbYENPCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 11:02:37 -0400
From: Alexey Starikovskiy <astarikovskiy@suse.de>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] x86: make config_irqsrc not MPspec specific
Date: Wed, 14 May 2008 19:03:17 +0400
Message-ID: <20080514150317.24443.82858.stgit@thinkpad>
In-Reply-To: <20080514150251.24443.5516.stgit@thinkpad>
References: <20080514150251.24443.5516.stgit@thinkpad>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
---

 arch/x86/kernel/acpi/boot.c  |   43 ++++++++++++++--------------
 arch/x86/kernel/io_apic_32.c |   64 +++++++++++++++++++++---------------------
 arch/x86/kernel/io_apic_64.c |   58 +++++++++++++++++++-------------------
 arch/x86/kernel/mpparse.c    |    8 +++++
 include/asm-x86/io_apic.h    |   12 +++++++-
 5 files changed, 100 insertions(+), 85 deletions(-)


diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 4652475..6841598 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -967,14 +967,14 @@ void __init mp_override_legacy_irq(u8 bus_irq, u8 polarity, u8 trigger, u32 gsi)
 	if ((bus_irq == 0) && (trigger == 3))
 		trigger = 1;
 
-	mp_irqs[mp_irq_entries].mpc_type = MP_INTSRC;
-	mp_irqs[mp_irq_entries].mpc_irqtype = mp_INT;
-	mp_irqs[mp_irq_entries].mpc_irqflag = (trigger << 2) | polarity;
-	mp_irqs[mp_irq_entries].mpc_srcbus = MP_ISA_BUS;
-	mp_irqs[mp_irq_entries].mpc_srcbusirq = bus_irq;	/* IRQ */
-	mp_irqs[mp_irq_entries].mpc_dstapic =
+	mp_irqs[mp_irq_entries].mp_type = MP_INTSRC;
+	mp_irqs[mp_irq_entries].mp_irqtype = mp_INT;
+	mp_irqs[mp_irq_entries].mp_irqflag = (trigger << 2) | polarity;
+	mp_irqs[mp_irq_entries].mp_srcbus = MP_ISA_BUS;
+	mp_irqs[mp_irq_entries].mp_srcbusirq = bus_irq;	/* IRQ */
+	mp_irqs[mp_irq_entries].mp_dstapic =
 			mp_ioapics[ioapic].mp_apicid;	/* APIC ID */
-	mp_irqs[mp_irq_entries].mpc_dstirq = pin;	/* INTIN# */
+	mp_irqs[mp_irq_entries].mp_dstirq = pin;	/* INTIN# */
 
 	if (++mp_irq_entries == MAX_IRQ_SOURCES)
 		panic("Max # of irq sources exceeded!!\n");
@@ -1010,12 +1010,11 @@ void __init mp_config_acpi_legacy_irqs(void)
 	if (ioapic < 0)
 		return;
 
-	mp_irqs[mp_irq_entries].mpc_type = MP_INTSRC;
-	mp_irqs[mp_irq_entries].mpc_irqflag = 0;	/* Conforming */
-	mp_irqs[mp_irq_entries].mpc_srcbus = MP_ISA_BUS;
-#ifdef CONFIG_X86_IO_APIC
-	mp_irqs[mp_irq_entries].mpc_dstapic = mp_ioapics[ioapic].mp_apicid;
-#endif
+	mp_irqs[mp_irq_entries].mp_type = MP_INTSRC;
+	mp_irqs[mp_irq_entries].mp_irqflag = 0;	/* Conforming */
+	mp_irqs[mp_irq_entries].mp_srcbus = MP_ISA_BUS;
+	mp_irqs[mp_irq_entries].mp_dstapic = mp_ioapics[ioapic].mp_apicid;
+
 	/*
 	 * Use the default configuration for the IRQs 0-15.  Unless
 	 * overridden by (MADT) interrupt source override entries.
@@ -1024,17 +1023,17 @@ void __init mp_config_acpi_legacy_irqs(void)
 		int idx;
 
 		for (idx = 0; idx < mp_irq_entries; idx++) {
-			struct mpc_config_intsrc *irq = mp_irqs + idx;
+			struct mp_config_intsrc *irq = mp_irqs + idx;
 
 			/* Do we already have a mapping for this ISA IRQ? */
-			if (irq->mpc_srcbus == MP_ISA_BUS
-			    && irq->mpc_srcbusirq == i)
+			if (irq->mp_srcbus == MP_ISA_BUS
+			    && irq->mp_srcbusirq == i)
 				break;
 
 			/* Do we already have a mapping for this IOAPIC pin */
-			if ((irq->mpc_dstapic ==
-				mp_irqs[mp_irq_entries].mpc_dstapic) &&
-			    (irq->mpc_dstirq == i))
+			if ((irq->mp_dstapic ==
+				mp_irqs[mp_irq_entries].mp_dstapic) &&
+			    (irq->mp_dstirq == i))
 				break;
 		}
 
@@ -1043,9 +1042,9 @@ void __init mp_config_acpi_legacy_irqs(void)
 			continue;	/* IRQ already used */
 		}
 
-		mp_irqs[mp_irq_entries].mpc_irqtype = mp_INT;
-		mp_irqs[mp_irq_entries].mpc_srcbusirq = i;	/* Identity mapped */
-		mp_irqs[mp_irq_entries].mpc_dstirq = i;
+		mp_irqs[mp_irq_entries].mp_irqtype = mp_INT;
+		mp_irqs[mp_irq_entries].mp_srcbusirq = i;	/* Identity mapped */
+		mp_irqs[mp_irq_entries].mp_dstirq = i;
 
 		if (++mp_irq_entries == MAX_IRQ_SOURCES)
 			panic("Max # of irq sources exceeded!!\n");
diff --git a/arch/x86/kernel/io_apic_32.c b/arch/x86/kernel/io_apic_32.c
index b7b231c..3037aa4 100644
--- a/arch/x86/kernel/io_apic_32.c
+++ b/arch/x86/kernel/io_apic_32.c
@@ -76,7 +76,7 @@ struct mp_config_ioapic mp_ioapics[MAX_IO_APICS];
 int nr_ioapics;
 
 /* MP IRQ source entries */
-struct mpc_config_intsrc mp_irqs[MAX_IRQ_SOURCES];
+struct mp_config_intsrc mp_irqs[MAX_IRQ_SOURCES];
 
 /* # of MP IRQ source entries */
 int mp_irq_entries;
@@ -801,10 +801,10 @@ static int find_irq_entry(int apic, int pin, int type)
 	int i;
 
 	for (i = 0; i < mp_irq_entries; i++)
-		if (mp_irqs[i].mpc_irqtype == type &&
-		    (mp_irqs[i].mpc_dstapic == mp_ioapics[apic].mp_apicid ||
-		     mp_irqs[i].mpc_dstapic == MP_APIC_ALL) &&
-		    mp_irqs[i].mpc_dstirq == pin)
+		if (mp_irqs[i].mp_irqtype == type &&
+		    (mp_irqs[i].mp_dstapic == mp_ioapics[apic].mp_apicid ||
+		     mp_irqs[i].mp_dstapic == MP_APIC_ALL) &&
+		    mp_irqs[i].mp_dstirq == pin)
 			return i;
 
 	return -1;
@@ -818,13 +818,13 @@ static int __init find_isa_irq_pin(int irq, int type)
 	int i;
 
 	for (i = 0; i < mp_irq_entries; i++) {
-		int lbus = mp_irqs[i].mpc_srcbus;
+		int lbus = mp_irqs[i].mp_srcbus;
 
 		if (test_bit(lbus, mp_bus_not_pci) &&
-		    (mp_irqs[i].mpc_irqtype == type) &&
-		    (mp_irqs[i].mpc_srcbusirq == irq))
+		    (mp_irqs[i].mp_irqtype == type) &&
+		    (mp_irqs[i].mp_srcbusirq == irq))
 
-			return mp_irqs[i].mpc_dstirq;
+			return mp_irqs[i].mp_dstirq;
 	}
 	return -1;
 }
@@ -834,17 +834,17 @@ static int __init find_isa_irq_apic(int irq, int type)
 	int i;
 
 	for (i = 0; i < mp_irq_entries; i++) {
-		int lbus = mp_irqs[i].mpc_srcbus;
+		int lbus = mp_irqs[i].mp_srcbus;
 
 		if (test_bit(lbus, mp_bus_not_pci) &&
-		    (mp_irqs[i].mpc_irqtype == type) &&
-		    (mp_irqs[i].mpc_srcbusirq == irq))
+		    (mp_irqs[i].mp_irqtype == type) &&
+		    (mp_irqs[i].mp_srcbusirq == irq))
 			break;
 	}
 	if (i < mp_irq_entries) {
 		int apic;
 		for(apic = 0; apic < nr_ioapics; apic++) {
-			if (mp_ioapics[apic].mp_apicid == mp_irqs[i].mpc_dstapic)
+			if (mp_ioapics[apic].mp_apicid == mp_irqs[i].mp_dstapic)
 				return apic;
 		}
 	}
@@ -869,23 +869,23 @@ int IO_APIC_get_PCI_irq_vector(int bus, int slot, int pin)
 		return -1;
 	}
 	for (i = 0; i < mp_irq_entries; i++) {
-		int lbus = mp_irqs[i].mpc_srcbus;
+		int lbus = mp_irqs[i].mp_srcbus;
 
 		for (apic = 0; apic < nr_ioapics; apic++)
-			if (mp_ioapics[apic].mp_apicid == mp_irqs[i].mpc_dstapic ||
-			    mp_irqs[i].mpc_dstapic == MP_APIC_ALL)
+			if (mp_ioapics[apic].mp_apicid == mp_irqs[i].mp_dstapic ||
+			    mp_irqs[i].mp_dstapic == MP_APIC_ALL)
 				break;
 
 		if (!test_bit(lbus, mp_bus_not_pci) &&
-		    !mp_irqs[i].mpc_irqtype &&
+		    !mp_irqs[i].mp_irqtype &&
 		    (bus == lbus) &&
-		    (slot == ((mp_irqs[i].mpc_srcbusirq >> 2) & 0x1f))) {
-			int irq = pin_2_irq(i,apic,mp_irqs[i].mpc_dstirq);
+		    (slot == ((mp_irqs[i].mp_srcbusirq >> 2) & 0x1f))) {
+			int irq = pin_2_irq(i,apic,mp_irqs[i].mp_dstirq);
 
 			if (!(apic || IO_APIC_IRQ(irq)))
 				continue;
 
-			if (pin == (mp_irqs[i].mpc_srcbusirq & 3))
+			if (pin == (mp_irqs[i].mp_srcbusirq & 3))
 				return irq;
 			/*
 			 * Use the first all-but-pin matching entry as a
@@ -952,7 +952,7 @@ static int EISA_ELCR(unsigned int irq)
  * EISA conforming in the MP table, that means its trigger type must
  * be read in from the ELCR */
 
-#define default_EISA_trigger(idx)	(EISA_ELCR(mp_irqs[idx].mpc_srcbusirq))
+#define default_EISA_trigger(idx)	(EISA_ELCR(mp_irqs[idx].mp_srcbusirq))
 #define default_EISA_polarity(idx)	default_ISA_polarity(idx)
 
 /* PCI interrupts are always polarity one level triggered,
@@ -969,13 +969,13 @@ static int EISA_ELCR(unsigned int irq)
 
 static int MPBIOS_polarity(int idx)
 {
-	int bus = mp_irqs[idx].mpc_srcbus;
+	int bus = mp_irqs[idx].mp_srcbus;
 	int polarity;
 
 	/*
 	 * Determine IRQ line polarity (high active or low active):
 	 */
-	switch (mp_irqs[idx].mpc_irqflag & 3)
+	switch (mp_irqs[idx].mp_irqflag & 3)
 	{
 		case 0: /* conforms, ie. bus-type dependent polarity */
 		{
@@ -1012,13 +1012,13 @@ static int MPBIOS_polarity(int idx)
 
 static int MPBIOS_trigger(int idx)
 {
-	int bus = mp_irqs[idx].mpc_srcbus;
+	int bus = mp_irqs[idx].mp_srcbus;
 	int trigger;
 
 	/*
 	 * Determine IRQ trigger mode (edge or level sensitive):
 	 */
-	switch ((mp_irqs[idx].mpc_irqflag>>2) & 3)
+	switch ((mp_irqs[idx].mp_irqflag>>2) & 3)
 	{
 		case 0: /* conforms, ie. bus-type dependent */
 		{
@@ -1097,16 +1097,16 @@ static inline int irq_trigger(int idx)
 static int pin_2_irq(int idx, int apic, int pin)
 {
 	int irq, i;
-	int bus = mp_irqs[idx].mpc_srcbus;
+	int bus = mp_irqs[idx].mp_srcbus;
 
 	/*
 	 * Debugging check, we are in big trouble if this message pops up!
 	 */
-	if (mp_irqs[idx].mpc_dstirq != pin)
+	if (mp_irqs[idx].mp_dstirq != pin)
 		printk(KERN_ERR "broken BIOS or MPTABLE parser, ayiee!!\n");
 
 	if (test_bit(bus, mp_bus_not_pci))
-		irq = mp_irqs[idx].mpc_srcbusirq;
+		irq = mp_irqs[idx].mp_srcbusirq;
 	else {
 		/*
 		 * PCI IRQs are mapped in order
@@ -1793,8 +1793,8 @@ static void __init setup_ioapic_ids_from_mpc(void)
 		 */
 		if (old_id != mp_ioapics[apic].mp_apicid)
 			for (i = 0; i < mp_irq_entries; i++)
-				if (mp_irqs[i].mpc_dstapic == old_id)
-					mp_irqs[i].mpc_dstapic
+				if (mp_irqs[i].mp_dstapic == old_id)
+					mp_irqs[i].mp_dstapic
 						= mp_ioapics[apic].mp_apicid;
 
 		/*
@@ -2810,8 +2810,8 @@ int acpi_get_override_irq(int bus_irq, int *trigger, int *polarity)
 		return -1;
 
 	for (i = 0; i < mp_irq_entries; i++)
-		if (mp_irqs[i].mpc_irqtype == mp_INT &&
-		    mp_irqs[i].mpc_srcbusirq == bus_irq)
+		if (mp_irqs[i].mp_irqtype == mp_INT &&
+		    mp_irqs[i].mp_srcbusirq == bus_irq)
 			break;
 	if (i >= mp_irq_entries)
 		return -1;
diff --git a/arch/x86/kernel/io_apic_64.c b/arch/x86/kernel/io_apic_64.c
index 371ec65..832adf5 100644
--- a/arch/x86/kernel/io_apic_64.c
+++ b/arch/x86/kernel/io_apic_64.c
@@ -112,7 +112,7 @@ struct mp_config_ioapic mp_ioapics[MAX_IO_APICS];
 int nr_ioapics;
 
 /* MP IRQ source entries */
-struct mpc_config_intsrc mp_irqs[MAX_IRQ_SOURCES];
+struct mp_config_intsrc mp_irqs[MAX_IRQ_SOURCES];
 
 /* # of MP IRQ source entries */
 int mp_irq_entries;
@@ -457,10 +457,10 @@ static int find_irq_entry(int apic, int pin, int type)
 	int i;
 
 	for (i = 0; i < mp_irq_entries; i++)
-		if (mp_irqs[i].mpc_irqtype == type &&
-		    (mp_irqs[i].mpc_dstapic == mp_ioapics[apic].mp_apicid ||
-		     mp_irqs[i].mpc_dstapic == MP_APIC_ALL) &&
-		    mp_irqs[i].mpc_dstirq == pin)
+		if (mp_irqs[i].mp_irqtype == type &&
+		    (mp_irqs[i].mp_dstapic == mp_ioapics[apic].mp_apicid ||
+		     mp_irqs[i].mp_dstapic == MP_APIC_ALL) &&
+		    mp_irqs[i].mp_dstirq == pin)
 			return i;
 
 	return -1;
@@ -474,13 +474,13 @@ static int __init find_isa_irq_pin(int irq, int type)
 	int i;
 
 	for (i = 0; i < mp_irq_entries; i++) {
-		int lbus = mp_irqs[i].mpc_srcbus;
+		int lbus = mp_irqs[i].mp_srcbus;
 
 		if (test_bit(lbus, mp_bus_not_pci) &&
-		    (mp_irqs[i].mpc_irqtype == type) &&
-		    (mp_irqs[i].mpc_srcbusirq == irq))
+		    (mp_irqs[i].mp_irqtype == type) &&
+		    (mp_irqs[i].mp_srcbusirq == irq))
 
-			return mp_irqs[i].mpc_dstirq;
+			return mp_irqs[i].mp_dstirq;
 	}
 	return -1;
 }
@@ -490,17 +490,17 @@ static int __init find_isa_irq_apic(int irq, int type)
 	int i;
 
 	for (i = 0; i < mp_irq_entries; i++) {
-		int lbus = mp_irqs[i].mpc_srcbus;
+		int lbus = mp_irqs[i].mp_srcbus;
 
 		if (test_bit(lbus, mp_bus_not_pci) &&
-		    (mp_irqs[i].mpc_irqtype == type) &&
-		    (mp_irqs[i].mpc_srcbusirq == irq))
+		    (mp_irqs[i].mp_irqtype == type) &&
+		    (mp_irqs[i].mp_srcbusirq == irq))
 			break;
 	}
 	if (i < mp_irq_entries) {
 		int apic;
 		for(apic = 0; apic < nr_ioapics; apic++) {
-			if (mp_ioapics[apic].mp_apicid == mp_irqs[i].mpc_dstapic)
+			if (mp_ioapics[apic].mp_apicid == mp_irqs[i].mp_dstapic)
 				return apic;
 		}
 	}
@@ -525,23 +525,23 @@ int IO_APIC_get_PCI_irq_vector(int bus, int slot, int pin)
 		return -1;
 	}
 	for (i = 0; i < mp_irq_entries; i++) {
-		int lbus = mp_irqs[i].mpc_srcbus;
+		int lbus = mp_irqs[i].mp_srcbus;
 
 		for (apic = 0; apic < nr_ioapics; apic++)
-			if (mp_ioapics[apic].mp_apicid == mp_irqs[i].mpc_dstapic ||
-			    mp_irqs[i].mpc_dstapic == MP_APIC_ALL)
+			if (mp_ioapics[apic].mp_apicid == mp_irqs[i].mp_dstapic ||
+			    mp_irqs[i].mp_dstapic == MP_APIC_ALL)
 				break;
 
 		if (!test_bit(lbus, mp_bus_not_pci) &&
-		    !mp_irqs[i].mpc_irqtype &&
+		    !mp_irqs[i].mp_irqtype &&
 		    (bus == lbus) &&
-		    (slot == ((mp_irqs[i].mpc_srcbusirq >> 2) & 0x1f))) {
-			int irq = pin_2_irq(i,apic,mp_irqs[i].mpc_dstirq);
+		    (slot == ((mp_irqs[i].mp_srcbusirq >> 2) & 0x1f))) {
+			int irq = pin_2_irq(i,apic,mp_irqs[i].mp_dstirq);
 
 			if (!(apic || IO_APIC_IRQ(irq)))
 				continue;
 
-			if (pin == (mp_irqs[i].mpc_srcbusirq & 3))
+			if (pin == (mp_irqs[i].mp_srcbusirq & 3))
 				return irq;
 			/*
 			 * Use the first all-but-pin matching entry as a
@@ -569,13 +569,13 @@ int IO_APIC_get_PCI_irq_vector(int bus, int slot, int pin)
 
 static int MPBIOS_polarity(int idx)
 {
-	int bus = mp_irqs[idx].mpc_srcbus;
+	int bus = mp_irqs[idx].mp_srcbus;
 	int polarity;
 
 	/*
 	 * Determine IRQ line polarity (high active or low active):
 	 */
-	switch (mp_irqs[idx].mpc_irqflag & 3)
+	switch (mp_irqs[idx].mp_irqflag & 3)
 	{
 		case 0: /* conforms, ie. bus-type dependent polarity */
 			if (test_bit(bus, mp_bus_not_pci))
@@ -611,13 +611,13 @@ static int MPBIOS_polarity(int idx)
 
 static int MPBIOS_trigger(int idx)
 {
-	int bus = mp_irqs[idx].mpc_srcbus;
+	int bus = mp_irqs[idx].mp_srcbus;
 	int trigger;
 
 	/*
 	 * Determine IRQ trigger mode (edge or level sensitive):
 	 */
-	switch ((mp_irqs[idx].mpc_irqflag>>2) & 3)
+	switch ((mp_irqs[idx].mp_irqflag>>2) & 3)
 	{
 		case 0: /* conforms, ie. bus-type dependent */
 			if (test_bit(bus, mp_bus_not_pci))
@@ -664,16 +664,16 @@ static inline int irq_trigger(int idx)
 static int pin_2_irq(int idx, int apic, int pin)
 {
 	int irq, i;
-	int bus = mp_irqs[idx].mpc_srcbus;
+	int bus = mp_irqs[idx].mp_srcbus;
 
 	/*
 	 * Debugging check, we are in big trouble if this message pops up!
 	 */
-	if (mp_irqs[idx].mpc_dstirq != pin)
+	if (mp_irqs[idx].mp_dstirq != pin)
 		printk(KERN_ERR "broken BIOS or MPTABLE parser, ayiee!!\n");
 
 	if (test_bit(bus, mp_bus_not_pci)) {
-		irq = mp_irqs[idx].mpc_srcbusirq;
+		irq = mp_irqs[idx].mp_srcbusirq;
 	} else {
 		/*
 		 * PCI IRQs are mapped in order
@@ -2246,8 +2246,8 @@ int acpi_get_override_irq(int bus_irq, int *trigger, int *polarity)
 		return -1;
 
 	for (i = 0; i < mp_irq_entries; i++)
-		if (mp_irqs[i].mpc_irqtype == mp_INT &&
-		    mp_irqs[i].mpc_srcbusirq == bus_irq)
+		if (mp_irqs[i].mp_irqtype == mp_INT &&
+		    mp_irqs[i].mp_srcbusirq == bus_irq)
 			break;
 	if (i >= mp_irq_entries)
 		return -1;
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 9f1e5bf..59f051d 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -186,12 +186,18 @@ static void __init MP_ioapic_info(struct mpc_config_ioapic *m)
 
 static void __init MP_intsrc_info(struct mpc_config_intsrc *m)
 {
-	mp_irqs[mp_irq_entries] = *m;
 	printk(KERN_INFO "Int: type %d, pol %d, trig %d, bus %02x,"
 		" IRQ %02x, APIC ID %x, APIC INT %02x\n",
 		m->mpc_irqtype, m->mpc_irqflag & 3,
 		(m->mpc_irqflag >> 2) & 3, m->mpc_srcbus,
 		m->mpc_srcbusirq, m->mpc_dstapic, m->mpc_dstirq);
+	mp_irqs[mp_irq_entries].mp_dstapic = m->mpc_dstapic;
+	mp_irqs[mp_irq_entries].mp_type = m->mpc_type;
+	mp_irqs[mp_irq_entries].mp_irqtype = m->mpc_irqtype;
+	mp_irqs[mp_irq_entries].mp_irqflag = m->mpc_irqflag;
+	mp_irqs[mp_irq_entries].mp_srcbus = m->mpc_srcbus;
+	mp_irqs[mp_irq_entries].mp_srcbusirq = m->mpc_srcbusirq;
+	mp_irqs[mp_irq_entries].mp_dstirq = m->mpc_dstirq;
 	if (++mp_irq_entries == MAX_IRQ_SOURCES)
 		panic("Max # of irq sources exceeded!!\n");
 }
diff --git a/include/asm-x86/io_apic.h b/include/asm-x86/io_apic.h
index ade76c0..86d8c3b 100644
--- a/include/asm-x86/io_apic.h
+++ b/include/asm-x86/io_apic.h
@@ -120,6 +120,16 @@ struct mp_config_ioapic {
 	unsigned char mp_flags;
 };
 
+struct mp_config_intsrc {
+	unsigned int mp_dstapic;
+	unsigned char mp_type;
+	unsigned char mp_irqtype;
+	unsigned short mp_irqflag;
+	unsigned char mp_srcbus;
+	unsigned char mp_srcbusirq;
+	unsigned char mp_dstirq;
+};
+
 /* I/O APIC entries */
 extern struct mp_config_ioapic mp_ioapics[MAX_IO_APICS];
 
@@ -127,7 +137,7 @@ extern struct mp_config_ioapic mp_ioapics[MAX_IO_APICS];
 extern int mp_irq_entries;
 
 /* MP IRQ source entries */
-extern struct mpc_config_intsrc mp_irqs[MAX_IRQ_SOURCES];
+extern struct mp_config_intsrc mp_irqs[MAX_IRQ_SOURCES];
 
 /* non-0 if default (table-less) MP configuration */
 extern int mpc_default_type;

