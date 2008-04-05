Return-Path: <linux-kernel-owner+w=401wt.eu-S1754051AbYDENw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051AbYDENw1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 09:52:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754096AbYDENu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 09:50:56 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:37199 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275AbYDENuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 09:50:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition:message-id;
        b=bD/mRlucQK8SCD/ZXKVQgLrPHEtRu3QlT5VolbttkCh9kOcyE3199eQ1rH0miaYdpSOCSpfnPcLHxL8VsILRPf66NKTme/b7fEeaDBex4k4FI3b/7XcW6DwF/zzAk6Ndu+szkpmrj8ID6Eyx+MpjAOK5EaVbxVgkhZyFYBe51G8=
References: <20080405133903.770639386@gmail.com>>
User-Agent: quilt/0.46-1
Date: Sat, 05 Apr 2008 22:39:11 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [patch 8/9] x86_64: use MP_intsrc_info()
Content-Disposition: inline; filename=x86-use-MP_intsrc_info.patch
Message-ID: <47f783bd.1ba67e0a.4ad4.2135@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove duplicate code by using MP_intsrc_info() in mpparse_{32,64}.c

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 arch/x86/kernel/mpparse_32.c |   23 ++++-------------------
 arch/x86/kernel/mpparse_64.c |   23 ++++-------------------
 2 files changed, 8 insertions(+), 38 deletions(-)

Index: 2.6-git/arch/x86/kernel/mpparse_64.c
===================================================================
--- 2.6-git.orig/arch/x86/kernel/mpparse_64.c
+++ 2.6-git/arch/x86/kernel/mpparse_64.c
@@ -193,9 +193,9 @@ static void __init MP_ioapic_info (struc
 	nr_ioapics++;
 }
 
-static void __init MP_intsrc_info (struct mpc_config_intsrc *m)
+static void __init MP_intsrc_info(struct mpc_config_intsrc *m)
 {
-	mp_irqs [mp_irq_entries] = *m;
+	mp_irqs[mp_irq_entries] = *m;
 	Dprintk("Int: type %d, pol %d, trig %d, bus %d,"
 		" IRQ %02x, APIC ID %x, APIC INT %02x\n",
 			m->mpc_irqtype, m->mpc_irqflag & 3,
@@ -741,14 +741,7 @@ mp_override_legacy_irq(u8 bus_irq, u8 po
 	intsrc.mpc_dstapic = mp_ioapics[ioapic].mpc_apicid;	   /* APIC ID */
 	intsrc.mpc_dstirq = pin;				    /* INTIN# */
 
-	Dprintk("Int: type %d, pol %d, trig %d, bus %d, irq %d, %d-%d\n", 
-		intsrc.mpc_irqtype, intsrc.mpc_irqflag & 3, 
-		(intsrc.mpc_irqflag >> 2) & 3, intsrc.mpc_srcbus, 
-		intsrc.mpc_srcbusirq, intsrc.mpc_dstapic, intsrc.mpc_dstirq);
-
-	mp_irqs[mp_irq_entries] = intsrc;
-	if (++mp_irq_entries == MAX_IRQ_SOURCES)
-		panic("Max # of irq sources exceeded!\n");
+	MP_intsrc_info(&intsrc);
 }
 
 void __init mp_config_acpi_legacy_irqs(void)
@@ -803,15 +796,7 @@ void __init mp_config_acpi_legacy_irqs(v
 		intsrc.mpc_srcbusirq = i;		   /* Identity mapped */
 		intsrc.mpc_dstirq = i;
 
-		Dprintk("Int: type %d, pol %d, trig %d, bus %d, irq %d, "
-			"%d-%d\n", intsrc.mpc_irqtype, intsrc.mpc_irqflag & 3, 
-			(intsrc.mpc_irqflag >> 2) & 3, intsrc.mpc_srcbus, 
-			intsrc.mpc_srcbusirq, intsrc.mpc_dstapic, 
-			intsrc.mpc_dstirq);
-
-		mp_irqs[mp_irq_entries] = intsrc;
-		if (++mp_irq_entries == MAX_IRQ_SOURCES)
-			panic("Max # of irq sources exceeded!\n");
+		MP_intsrc_info(&intsrc);
 	}
 }
 
Index: 2.6-git/arch/x86/kernel/mpparse_32.c
===================================================================
--- 2.6-git.orig/arch/x86/kernel/mpparse_32.c
+++ 2.6-git/arch/x86/kernel/mpparse_32.c
@@ -274,9 +274,9 @@ static void __init MP_ioapic_info (struc
 	nr_ioapics++;
 }
 
-static void __init MP_intsrc_info (struct mpc_config_intsrc *m)
+static void __init MP_intsrc_info(struct mpc_config_intsrc *m)
 {
-	mp_irqs [mp_irq_entries] = *m;
+	mp_irqs[mp_irq_entries] = *m;
 	Dprintk("Int: type %d, pol %d, trig %d, bus %d,"
 		" IRQ %02x, APIC ID %x, APIC INT %02x\n",
 			m->mpc_irqtype, m->mpc_irqflag & 3,
@@ -960,14 +960,7 @@ mp_override_legacy_irq(u8 bus_irq, u8 po
 	intsrc.mpc_dstapic = mp_ioapics[ioapic].mpc_apicid;	   /* APIC ID */
 	intsrc.mpc_dstirq = pin;				    /* INTIN# */
 
-	Dprintk("Int: type %d, pol %d, trig %d, bus %d, irq %d, %d-%d\n",
-		intsrc.mpc_irqtype, intsrc.mpc_irqflag & 3, 
-		(intsrc.mpc_irqflag >> 2) & 3, intsrc.mpc_srcbus, 
-		intsrc.mpc_srcbusirq, intsrc.mpc_dstapic, intsrc.mpc_dstirq);
-
-	mp_irqs[mp_irq_entries] = intsrc;
-	if (++mp_irq_entries == MAX_IRQ_SOURCES)
-		panic("Max # of irq sources exceeded!\n");
+	MP_intsrc_info(&intsrc);
 }
 
 void __init mp_config_acpi_legacy_irqs (void)
@@ -1029,15 +1022,7 @@ void __init mp_config_acpi_legacy_irqs (
 		intsrc.mpc_srcbusirq = i;		   /* Identity mapped */
 		intsrc.mpc_dstirq = i;
 
-		Dprintk("Int: type %d, pol %d, trig %d, bus %d, irq %d, "
-			"%d-%d\n", intsrc.mpc_irqtype, intsrc.mpc_irqflag & 3, 
-			(intsrc.mpc_irqflag >> 2) & 3, intsrc.mpc_srcbus, 
-			intsrc.mpc_srcbusirq, intsrc.mpc_dstapic, 
-			intsrc.mpc_dstirq);
-
-		mp_irqs[mp_irq_entries] = intsrc;
-		if (++mp_irq_entries == MAX_IRQ_SOURCES)
-			panic("Max # of irq sources exceeded!\n");
+		MP_intsrc_info(&intsrc);
 	}
 }
 

-- 
