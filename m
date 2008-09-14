Return-Path: <linux-kernel-owner+w=401wt.eu-S1754037AbYINICV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037AbYINICV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 04:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752176AbYINIBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 04:01:44 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:10757 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbYINIBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 04:01:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition
         :message-id;
        b=N4Ji577bexW9weHrFFUJh0jPiJ8turVHd/9EsDMDqTyTLnK5nK2Je20x1G5z5P5iD3
         iDWKkVnZ+9XDinpsBcFR3Kiy1SCn7/c4MgpQswtoJD5pmzqt4+EtIdHc6J7KyDOrfvan
         cP5c1M+rpMu5ndvCGR4ijQ1id8OQO7cxvPz4c=
References: <20080914075536.619891882@gmail.com>>
User-Agent: quilt/0.46-1
Date: Sun, 14 Sep 2008 11:55:37 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, macro@linux-mips.org, linux-kernel@vger.kernel.org
Cc: yhlu.kernel@gmail.com, Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [patch 1/2] x86: apic - lapic_setup_esr does not handle esr_disable - fix it
Content-Disposition: inline; filename=x86-apic-fix-lapic_setup_esr
Message-ID: <48ccc4e3.0c58560a.0891.4b98@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lapic_setup_esr doesn't handle esr_disable inquire.
The error brought in during unification process.
Fix it.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

I've simplified this procedure, ie the algo is following

 - check if apic is not 82489DX (which doesn't have ESR at all)
 - check if ESR was asked to not being touched
 - normal handling of ESR

Index: linux-2.6.git/arch/x86/kernel/apic.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic.c	2008-09-13 16:58:48.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/apic.c	2008-09-14 11:46:02.000000000 +0400
@@ -1081,40 +1081,43 @@ void __init init_bsp_APIC(void)
 
 static void __cpuinit lapic_setup_esr(void)
 {
-	unsigned long oldvalue, value, maxlvt;
-	if (lapic_is_integrated() && !esr_disable) {
-		if (esr_disable) {
-			/*
-			 * Something untraceable is creating bad interrupts on
-			 * secondary quads ... for the moment, just leave the
-			 * ESR disabled - we can't do anything useful with the
-			 * errors anyway - mbligh
-			 */
-			printk(KERN_INFO "Leaving ESR disabled.\n");
-			return;
-		}
-		/* !82489DX */
-		maxlvt = lapic_get_maxlvt();
-		if (maxlvt > 3)		/* Due to the Pentium erratum 3AP. */
-			apic_write(APIC_ESR, 0);
-		oldvalue = apic_read(APIC_ESR);
-
-		/* enables sending errors */
-		value = ERROR_APIC_VECTOR;
-		apic_write(APIC_LVTERR, value);
+	unsigned int oldvalue, value, maxlvt;
+
+	if (!lapic_is_integrated()) {
+		printk(KERN_INFO "No ESR for 82489DX.\n");
+		return;
+	}
+
+	if (esr_disable) {
 		/*
-		 * spec says clear errors after enabling vector.
+		 * Something untraceable is creating bad interrupts on
+		 * secondary quads ... for the moment, just leave the
+		 * ESR disabled - we can't do anything useful with the
+		 * errors anyway - mbligh
 		 */
-		if (maxlvt > 3)
-			apic_write(APIC_ESR, 0);
-		value = apic_read(APIC_ESR);
-		if (value != oldvalue)
-			apic_printk(APIC_VERBOSE, "ESR value before enabling "
-				"vector: 0x%08lx  after: 0x%08lx\n",
-				oldvalue, value);
-	} else {
-		printk(KERN_INFO "No ESR for 82489DX.\n");
+		printk(KERN_INFO "Leaving ESR disabled.\n");
+		return;
 	}
+
+	maxlvt = lapic_get_maxlvt();
+	if (maxlvt > 3)		/* Due to the Pentium erratum 3AP. */
+		apic_write(APIC_ESR, 0);
+	oldvalue = apic_read(APIC_ESR);
+
+	/* enables sending errors */
+	value = ERROR_APIC_VECTOR;
+	apic_write(APIC_LVTERR, value);
+
+	/*
+	 * spec says clear errors after enabling vector.
+	 */
+	if (maxlvt > 3)
+		apic_write(APIC_ESR, 0);
+	value = apic_read(APIC_ESR);
+	if (value != oldvalue)
+		apic_printk(APIC_VERBOSE, "ESR value before enabling "
+			"vector: 0x%08x  after: 0x%08x\n",
+			oldvalue, value);
 }
 
 

-- 
