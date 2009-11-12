Return-Path: <linux-kernel-owner+w=401wt.eu-S1754497AbZKLUtB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497AbZKLUtB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 15:49:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754458AbZKLUs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 15:48:56 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:57456 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876AbZKLUsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 15:48:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=eNNgiU7atiU4xmsn88uEMJcScmb0w/v4ZQdX/dgQG2tjFFxsIcYSIemPpNhvPc1xxm
         pR9JFZQSL/Qbq6NvX7MKD6k2mC/5m242OUJKGD624vV/iAD547R34ytlH4/KRmEaPQRk
         AhtpZT2WytZIfwYHwlebyhnbtJefRAIvdWbtY=
Date: Thu, 12 Nov 2009 23:48:52 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
       Yinghai Lu <yinghai@kernel.org>, x86team <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [RFC -tip] x86,io-apic: Do not map IO-APIC direct registers twice
Message-ID: <20091112204852.GB5728@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please review, I didn't manage to test (emulate actually since I don't
have such a hardware) it yet (going to do so this weekend).

Meanwhile I would like to heard comments, complains and etc...
Perhaps I miss something obvious so don't hesitate to poke me.

	-- Cyrill
---
x86,io-apic: Do not map IO-APIC direct registers twice

In case if IO-APIC address is not 4K aligned (which is pretty
established by MPS-1.4) we may not fixmap they twice and
should eliminate resourse overlap in this case.

An example of a such configureation is

	http://marc.info/?l=linux-kernel&m=118114792006520

| Quoting the message
|
| IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
| IOAPIC[1]: apic_id 3, version 32, address 0xfec80000, GSI 24-47
| IOAPIC[2]: apic_id 4, version 32, address 0xfec80400, GSI 48-71
| IOAPIC[3]: apic_id 5, version 32, address 0xfec84000, GSI 72-95
| IOAPIC[4]: apic_id 8, version 32, address 0xfec84400, GSI 96-119

Some io-apics are 4K aligned while others are -- 1K. We may have
the situation when next IO-APIC address (1K aligned) is following
previous 4K one. So instead of allocating new fixmap we may use already
done one.

To implement it ioapic_fixmap_shared is introduced which check if
new IO-APIC base address lays inside already mapped page.

Also insert_resourse will not fail anymore on 1K aligned io-apics.

CC: "Maciej W. Rozycki" <macro@linux-mips.org>
CC: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---
 arch/x86/include/asm/apicdef.h    |   23 +++++++++++++++--
 arch/x86/include/asm/mpspec_def.h |    9 +++---
 arch/x86/kernel/apic/io_apic.c    |   50 +++++++++++++++++++++++++++++++-------
 arch/x86/kernel/mpparse.c         |    2 -
 4 files changed, 67 insertions(+), 17 deletions(-)

Index: linux-2.6.git/arch/x86/include/asm/apicdef.h
=====================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/apicdef.h
+++ linux-2.6.git/arch/x86/include/asm/apicdef.h
@@ -1,6 +1,3 @@
-#ifndef _ASM_X86_APICDEF_H
-#define _ASM_X86_APICDEF_H
-
 /*
  * Constants for various Intel APICs. (local APIC, IOAPIC, etc.)
  *
@@ -8,9 +5,29 @@
  * Ingo Molnar <mingo@redhat.com>, 1999, 2000
  */
 
+#ifndef _ASM_X86_APICDEF_H
+#define _ASM_X86_APICDEF_H
+
 #define IO_APIC_DEFAULT_PHYS_BASE	0xfec00000
 #define	APIC_DEFAULT_PHYS_BASE		0xfee00000
 
+/*
+ * MP 1.4 specify that LAPIC must be aligned
+ * on 4K bound and IO-APIC on 1K
+ * (4K boud on IO-APIC is widely used too)
+ */
+#define APIC_PHYS_BASE_SHIFT		(12)
+#define IO_APIC_PHYS_BASE_SHIFT		(10)
+#define APIC_PHYS_BASE_MASK		(~((1U << APIC_PHYS_BASE_SHIFT) - 1))
+#define IO_APIC_PHYS_BASE_MASK		(~((1U << IO_APIC_PHYS_BASE_SHIFT) - 1))
+
+/*
+ * We assume that 1024 bytes will be more
+ * then enough in feasible feauture to cover
+ * all direct accessible IO-APIC registers
+ */
+#define IO_APIC_SLOT_SIZE		(1 << IO_APIC_PHYS_BASE_SHIFT)
+
 #define	APIC_ID		0x20
 
 #define	APIC_LVR	0x30
Index: linux-2.6.git/arch/x86/include/asm/mpspec_def.h
=====================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/mpspec_def.h
+++ linux-2.6.git/arch/x86/include/asm/mpspec_def.h
@@ -1,11 +1,11 @@
-#ifndef _ASM_X86_MPSPEC_DEF_H
-#define _ASM_X86_MPSPEC_DEF_H
-
 /*
  * Structure definitions for SMP machines following the
  * Intel Multiprocessing Specification 1.1 and 1.4.
  */
 
+#ifndef _ASM_X86_MPSPEC_DEF_H
+#define _ASM_X86_MPSPEC_DEF_H
+
 /*
  * This tag identifies where the SMP configuration
  * information is.
@@ -107,7 +107,8 @@ struct mpc_bus {
 #define BUSTYPE_VME	"VME"
 #define BUSTYPE_XPRESS	"XPRESS"
 
-#define MPC_APIC_USABLE		0x01
+#define MPC_IO_APIC_USABLE	(1 << 0)
+#define MPC_IO_APIC_MAPPED	(1 << 1)
 
 struct mpc_ioapic {
 	unsigned char type;
Index: linux-2.6.git/arch/x86/kernel/apic/io_apic.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6.git/arch/x86/kernel/apic/io_apic.c
@@ -4108,6 +4108,38 @@ static struct resource * __init ioapic_s
 	return res;
 }
 
+static __init int ioapic_fixmap_shared(unsigned long phys)
+{
+	unsigned long min, max;
+	int i;
+
+	/* if unpredictable change of PAGE_SHIFT happen */
+	BUILD_BUG_ON(APIC_PHYS_BASE_SHIFT != PAGE_SHIFT);
+
+	if (!(phys & ~APIC_PHYS_BASE_MASK))
+		return -1;
+
+	/*
+	 * if this get "hot-path" status we would need
+	 * more sophisticated/fast algorithm instead
+	 *
+	 * Note that we rely on BIOS that there is no
+	 * *overlapped or same* base addresses
+	 */
+	for (i = 0; i < nr_ioapics; i++) {
+		if (!(mp_ioapics[i].flags & MPC_IO_APIC_MAPPED)) {
+			pr_warning("IO-APIC: IO-APIC %d not mapped yet!\n", i);
+			break;
+		}
+		min = mp_ioapics[i].apicaddr & APIC_PHYS_BASE_MASK;
+		max = min + (PAGE_SIZE - IO_APIC_SLOT_SIZE);
+		if (phys >= min && phys <= max)
+			return i;
+	}
+
+	return -1;
+}
+
 void __init ioapic_init_mappings(void)
 {
 	unsigned long ioapic_phys, idx = FIX_IO_APIC_BASE_0;
@@ -4133,19 +4165,19 @@ void __init ioapic_init_mappings(void)
 #ifdef CONFIG_X86_32
 fake_ioapic_page:
 #endif
-			ioapic_phys = (unsigned long)
-				alloc_bootmem_pages(PAGE_SIZE);
+			ioapic_phys = (unsigned long)alloc_bootmem_pages(PAGE_SIZE);
 			ioapic_phys = __pa(ioapic_phys);
 		}
-		set_fixmap_nocache(idx, ioapic_phys);
-		apic_printk(APIC_VERBOSE,
-			    "mapped IOAPIC to %08lx (%08lx)\n",
-			    __fix_to_virt(idx), ioapic_phys);
-		idx++;
 
+		/* not mapped yet */
+		if (ioapic_fixmap_shared(ioapic_phys) == -1) {
+			set_fixmap_nocache(idx, ioapic_phys);
+			idx++;
+		}
 		ioapic_res->start = ioapic_phys;
-		ioapic_res->end = ioapic_phys + PAGE_SIZE-1;
+		ioapic_res->end	  = ioapic_phys + IO_APIC_SLOT_SIZE - 1;
 		ioapic_res++;
+		mp_ioapics[i].flags |= MPC_IO_APIC_MAPPED;
 	}
 }
 
@@ -4217,7 +4249,7 @@ void __init mp_register_ioapic(int id, u
 	idx = nr_ioapics;
 
 	mp_ioapics[idx].type = MP_IOAPIC;
-	mp_ioapics[idx].flags = MPC_APIC_USABLE;
+	mp_ioapics[idx].flags = MPC_IO_APIC_USABLE;
 	mp_ioapics[idx].apicaddr = address;
 
 	set_fixmap_nocache(FIX_IO_APIC_BASE_0 + idx, address);
Index: linux-2.6.git/arch/x86/kernel/mpparse.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/mpparse.c
+++ linux-2.6.git/arch/x86/kernel/mpparse.c
@@ -132,7 +132,7 @@ static int bad_ioapic(unsigned long addr
 
 static void __init MP_ioapic_info(struct mpc_ioapic *m)
 {
-	if (!(m->flags & MPC_APIC_USABLE))
+	if (!(m->flags & MPC_IO_APIC_USABLE))
 		return;
 
 	printk(KERN_INFO "I/O APIC #%d Version %d at 0x%X.\n",
