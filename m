Return-Path: <linux-kernel-owner+w=401wt.eu-S1760300AbYHNSth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760300AbYHNSth (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 14:49:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759396AbYHNSrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 14:47:00 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:57044 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758517AbYHNSq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 14:46:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject
         :content-disposition;
        b=I7jZ/7L32mPq6ht7Kk8u54kJJCQ3ZONSmhtxShp6dgY8iu6O5YO6wzibUFW1u09GdP
         tKw281zHwI+C+2oL2Rrf/J/OZu1f2+kBrhgdoexm/Y2fFLrtkipDz3PoOrrvuKKmTbWY
         AtS8VOscYxeQ9kIwDprAXC+FDHjrB5aC0QRE0=
Message-Id: <20080814184652.475361864@gmail.com>
References: <20080814183428.550709025@gmail.com>
User-Agent: quilt/0.46-1
Date: Thu, 01 Jan 1970 03:00:08 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: macro@linux-mips.org, mingo@elte.hu, tglx@linutronix.de
Cc: hpa@zytor.com, yhlu.kernel@gmail.com, linux-kernel@vger.kernel.org,
       Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [patch 8/8] x86: apic - unify init_bsp_APIC
Content-Disposition: inline; filename=0012-x86-apic-unify-init_bsp_APIC.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove redundant apic_read(APIC_LVR) and add check for
reserved bit on P4/Xeon in 64bit mode. For now it's
not really needed and made in a sake of unification.
#ifdef would be added probably.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/arch/x86/kernel/apic_32.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic_32.c	2008-08-14 22:23:04.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/apic_32.c	2008-08-14 22:24:49.000000000 +0400
@@ -927,7 +927,7 @@ void __init sync_Arb_IDs(void)
  */
 void __init init_bsp_APIC(void)
 {
-	unsigned long value;
+	unsigned int value;
 
 	/*
 	 * Don't do the setup now if we have a SMP BIOS as the
@@ -962,7 +962,8 @@ void __init init_bsp_APIC(void)
 	 */
 	apic_write(APIC_LVT0, APIC_DM_EXTINT);
 	value = APIC_DM_NMI;
-	if (!lapic_is_integrated())		/* 82489DX */
+	/* discrete on 82489DX */
+	if (!lapic_is_integrated())
 		value |= APIC_LVT_LEVEL_TRIGGER;
 	apic_write(APIC_LVT1, value);
 }
Index: linux-2.6.git/arch/x86/kernel/apic_64.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic_64.c	2008-08-14 22:23:04.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/apic_64.c	2008-08-14 22:24:49.000000000 +0400
@@ -776,8 +776,6 @@ void __init init_bsp_APIC(void)
 	if (smp_found_config || !cpu_has_apic)
 		return;
 
-	value = apic_read(APIC_LVR);
-
 	/*
 	 * Do not trust the local APIC being empty at bootup.
 	 */
@@ -789,7 +787,12 @@ void __init init_bsp_APIC(void)
 	value = apic_read(APIC_SPIV);
 	value &= ~APIC_VECTOR_MASK;
 	value |= APIC_SPIV_APIC_ENABLED;
-	value |= APIC_SPIV_FOCUS_DISABLED;
+	/* This bit is reserved on P4/Xeon and should be cleared */
+	if ((boot_cpu_data.x86_vendor == X86_VENDOR_INTEL) &&
+	    (boot_cpu_data.x86 == 15))
+		value &= ~APIC_SPIV_FOCUS_DISABLED;
+	else
+		value |= APIC_SPIV_FOCUS_DISABLED;
 	value |= SPURIOUS_APIC_VECTOR;
 	apic_write(APIC_SPIV, value);
 
@@ -798,6 +801,9 @@ void __init init_bsp_APIC(void)
 	 */
 	apic_write(APIC_LVT0, APIC_DM_EXTINT);
 	value = APIC_DM_NMI;
+	/* discrete on 82489DX */
+	if (!lapic_is_integrated())
+		value |= APIC_LVT_LEVEL_TRIGGER;
 	apic_write(APIC_LVT1, value);
 }
 

-- 
