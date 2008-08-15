Return-Path: <linux-kernel-owner+w=401wt.eu-S1761337AbYHOTKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761337AbYHOTKv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 15:10:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758478AbYHOTKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 15:10:32 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:9312 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757879AbYHOTKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 15:10:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition
         :message-id;
        b=HmCCj1tr911il7mPU3Le7BFPD0Jecsvmu5DXOqRLFvO7f8+2mGW4aPyh9QSB+Ddz8N
         OBYdv9gJK2Z+haER6d/4+/viaeU+TVfaaNtQ38lf5OvlfCONEykU8f9VSJx0t53cu7xY
         4jG6XMgWEp7yQzScgTwiMWjdqt/OvJXm+TuNA=
References: <20080815190517.850120473@gmail.com>>
User-Agent: quilt/0.46-1
Date: Fri, 15 Aug 2008 23:05:18 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, macro@linux-mips.org
Cc: linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [patch 1/2] x86: apic - unify init_bsp_APIC
Content-Disposition: inline; filename=x86-unify-init_bsp_APIC
Message-ID: <48a5d4a4.1438560a.2951.0060@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- remove redundant read of APIC_LVR register in 64bit mode
- APIC is always integrated for 64bit mode so
  gcc will eliminate lapic_is_integrated call

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/arch/x86/kernel/apic_32.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic_32.c	2008-08-15 22:14:45.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/apic_32.c	2008-08-15 22:41:52.000000000 +0400
@@ -927,7 +927,7 @@ void __init sync_Arb_IDs(void)
  */
 void __init init_bsp_APIC(void)
 {
-	unsigned long value;
+	unsigned int value;
 
 	/*
 	 * Don't do the setup now if we have a SMP BIOS as the
@@ -948,11 +948,13 @@ void __init init_bsp_APIC(void)
 	value &= ~APIC_VECTOR_MASK;
 	value |= APIC_SPIV_APIC_ENABLED;
 
+#ifdef CONFIG_X86_32
 	/* This bit is reserved on P4/Xeon and should be cleared */
 	if ((boot_cpu_data.x86_vendor == X86_VENDOR_INTEL) &&
 	    (boot_cpu_data.x86 == 15))
 		value &= ~APIC_SPIV_FOCUS_DISABLED;
 	else
+#endif
 		value |= APIC_SPIV_FOCUS_DISABLED;
 	value |= SPURIOUS_APIC_VECTOR;
 	apic_write(APIC_SPIV, value);
Index: linux-2.6.git/arch/x86/kernel/apic_64.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic_64.c	2008-08-15 22:14:45.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/apic_64.c	2008-08-15 22:41:53.000000000 +0400
@@ -780,8 +780,6 @@ void __init init_bsp_APIC(void)
 	if (smp_found_config || !cpu_has_apic)
 		return;
 
-	value = apic_read(APIC_LVR);
-
 	/*
 	 * Do not trust the local APIC being empty at bootup.
 	 */
@@ -793,7 +791,15 @@ void __init init_bsp_APIC(void)
 	value = apic_read(APIC_SPIV);
 	value &= ~APIC_VECTOR_MASK;
 	value |= APIC_SPIV_APIC_ENABLED;
-	value |= APIC_SPIV_FOCUS_DISABLED;
+
+#ifdef CONFIG_X86_32
+	/* This bit is reserved on P4/Xeon and should be cleared */
+	if ((boot_cpu_data.x86_vendor == X86_VENDOR_INTEL) &&
+	    (boot_cpu_data.x86 == 15))
+		value &= ~APIC_SPIV_FOCUS_DISABLED;
+	else
+#endif
+		value |= APIC_SPIV_FOCUS_DISABLED;
 	value |= SPURIOUS_APIC_VECTOR;
 	apic_write(APIC_SPIV, value);
 
@@ -802,6 +808,8 @@ void __init init_bsp_APIC(void)
 	 */
 	apic_write(APIC_LVT0, APIC_DM_EXTINT);
 	value = APIC_DM_NMI;
+	if (!lapic_is_integrated())		/* 82489DX */
+		value |= APIC_LVT_LEVEL_TRIGGER;
 	apic_write(APIC_LVT1, value);
 }
 

-- 
