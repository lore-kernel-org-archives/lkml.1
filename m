Return-Path: <linux-kernel-owner+w=401wt.eu-S1753047AbYIXQtj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047AbYIXQtj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 12:49:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752424AbYIXQsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 12:48:55 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:48144 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbYIXQsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 12:48:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition
         :message-id;
        b=gFB+an/7/7eUeqolvqrettatPpQ3CV8rPcYpzcMM5VQolwBIv8jpWpWbXDIo5D+XY1
         jOvnoz903CT3kAtfsHbpjZkAxsFwON1WRRXRPxKqTxZ/C/ko1Y9IdaITAptd87cz47kn
         zplGQ+jw7g7g8M8UtSrmRfAdWR6RCj1e8lyj4=
References: <20080924164618.588609232@gmail.com>>
User-Agent: quilt/0.46-1
Date: Wed, 24 Sep 2008 20:46:19 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, macro@linux-mips.org, yhlu.kernel@gmail.com
Cc: linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [patch 1/3] x86: apic,io-apic - generalize lapic_get_version helper
Content-Disposition: inline; filename=x86-apic-get-version
Message-ID: <48da6f73.0305560a.6192.5784@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By doing so we are able to not duplicate code in
io_apic.c at least in one case.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/arch/x86/kernel/apic.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic.c	2008-09-24 16:57:54.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/apic.c	2008-09-24 19:17:20.000000000 +0400
@@ -163,14 +163,6 @@ static DEFINE_PER_CPU(struct clock_event
 static unsigned long apic_phys;
 
 /*
- * Get the LAPIC version
- */
-static inline int lapic_get_version(void)
-{
-	return GET_APIC_VERSION(apic_read(APIC_LVR));
-}
-
-/*
  * Check, if the APIC is integrated or a separate chip
  */
 static inline int lapic_is_integrated(void)
Index: linux-2.6.git/arch/x86/kernel/io_apic.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/io_apic.c	2008-09-24 19:08:14.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/io_apic.c	2008-09-24 19:19:03.000000000 +0400
@@ -2759,8 +2759,7 @@ static inline void __init check_timer(vo
 
 	local_irq_save(flags);
 
-        ver = apic_read(APIC_LVR);
-        ver = GET_APIC_VERSION(ver);
+	ver = lapic_get_version();
 
 	/*
 	 * get/set the timer IRQ vector:
Index: linux-2.6.git/include/asm-x86/apic.h
===================================================================
--- linux-2.6.git.orig/include/asm-x86/apic.h	2008-09-22 17:42:35.000000000 +0400
+++ linux-2.6.git/include/asm-x86/apic.h	2008-09-24 19:16:58.000000000 +0400
@@ -132,6 +132,12 @@ extern struct apic_ops *apic_ops;
 #define apic_wait_icr_idle (apic_ops->wait_icr_idle)
 #define safe_apic_wait_icr_idle (apic_ops->safe_wait_icr_idle)
 
+/* Get the LAPIC version */
+static inline int lapic_get_version(void)
+{
+	return GET_APIC_VERSION(apic_read(APIC_LVR));
+}
+
 extern int get_physical_broadcast(void);
 
 #ifdef CONFIG_X86_64

-- 
