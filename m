Return-Path: <linux-kernel-owner+w=401wt.eu-S1758160AbYFCSsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758160AbYFCSsv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 14:48:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755047AbYFCSsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 14:48:42 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:58021 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbYFCSsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 14:48:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition:message-id;
        b=FE0NpV7LOyCVa+wmZxnGPxeGFf/67qJoI7BMSMNywk2elUYPF98l51lUjkhWy5zINpstPxM5dktbsUFEfnFhvLq1lw6chpXr5vAzprLEys+hR0LOudT+E9YA/f9Qu/0YC7ODm11zFjsoqFMYs8zQRjIgkjKlrwX1cVvKkSRG2cQ=
References: <20080603184648.162308982@gmail.com>>
User-Agent: quilt/0.46-1
Date: Thu, 01 Jan 1970 03:00:01 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, macro@linux-mips.org
Cc: linux-kernel@vger.kernel.org, gorcunov@gmail.com
Subject: [patch 1/2] x86: nmi - consolidate nmi_watchdog_default for 32bit mode
Content-Disposition: inline; filename=nmi-consolidate-nmi_watchdog_default
Message-ID: <48459207.0637560a.672f.1b0d@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

64bit mode bootstrap code does set nmi_watchdog to NMI_NONE
by default and doing the same on 32bit mode is safe too.
Such an action saves us from several #ifdef.

Btw, my previous commit

commit 19ec673ced067316b9732bc6d1c4ff4052e5f795
Author: Cyrill Gorcunov <gorcunov@gmail.com>
Date:   Wed May 28 23:00:47 2008 +0400

    x86: nmi - fix incorrect NMI watchdog used by default
    
did not fix the problem completely, moreover it
introduced additional bug - nmi_watchdog would be
set to either NMI_LOCAL_APIC or NMI_IO_APIC
_regardless_ to boot option if being enabled thru
/proc/sys/kernel/nmi_watchdog. Sorry for that.
Fix it too.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/arch/x86/kernel/nmi.c
====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/nmi.c	2008-06-02 18:03:13.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/nmi.c	2008-06-02 20:33:31.000000000 +0400
@@ -487,14 +487,16 @@ int proc_nmi_enabled(struct ctl_table *t
 		return -EIO;
 	}
 
-#ifdef CONFIG_X86_64
 	/* if nmi_watchdog is not set yet, then set it */
 	nmi_watchdog_default();
-#else
-	if (lapic_watchdog_ok())
-		nmi_watchdog = NMI_LOCAL_APIC;
-	else
-		nmi_watchdog = NMI_IO_APIC;
+
+#ifdef CONFIG_X86_32
+	if (nmi_watchdog == NMI_NONE) {
+		if (lapic_watchdog_ok())
+			nmi_watchdog = NMI_LOCAL_APIC;
+		else
+			nmi_watchdog = NMI_IO_APIC;
+	}
 #endif
 
 	if (nmi_watchdog == NMI_LOCAL_APIC) {
Index: linux-2.6.git/include/asm-x86/nmi.h
====================================================================
--- linux-2.6.git.orig/include/asm-x86/nmi.h	2008-06-02 18:03:14.000000000 +0400
+++ linux-2.6.git/include/asm-x86/nmi.h	2008-06-02 20:31:48.000000000 +0400
@@ -38,12 +38,10 @@ static inline void unset_nmi_pm_callback
 
 #ifdef CONFIG_X86_64
 extern void default_do_nmi(struct pt_regs *);
-extern void nmi_watchdog_default(void);
-#else
-#define nmi_watchdog_default() do { } while (0)
 #endif
 
 extern void die_nmi(char *str, struct pt_regs *regs, int do_panic);
+extern void nmi_watchdog_default(void);
 extern int check_nmi_watchdog(void);
 extern int nmi_watchdog_enabled;
 extern int avail_to_resrv_perfctr_nmi_bit(unsigned int);

-- 
