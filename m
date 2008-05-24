Return-Path: <linux-kernel-owner+w=401wt.eu-S1758630AbYEXPmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758630AbYEXPmv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 11:42:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756082AbYEXPlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 11:41:55 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:10446 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755440AbYEXPlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 11:41:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition:message-id;
        b=bPNP0+8Lh8yevbqwT+WQ2nfQIwZU9pKt1Dx9jjH65Mz+JXayvEYYK4fxjBn8gMZ4yk8WCKQLqMY66HC1bxf7MXGLwVR6jJw7s1wcPB6sowekydny0LWEx+wxNDcgooiklyVs82ZLNSMSaMK0hl/VbvvZYdwduH8chnauMu7R98U=
References: <20080524153630.669797039@gmail.com>>
User-Agent: quilt/0.46-1
Date: Sat, 24 May 2008 19:36:35 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [patch 05/11] x86: nmi_32.c - add nmi_watchdog_default helper
Content-Disposition: inline; filename=nmi-32-nmi-watchdog-default
Message-ID: <48383740.1438560a.693e.3cf3@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/arch/x86/kernel/nmi_32.c
====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/nmi_32.c	2008-05-24 13:01:21.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/nmi_32.c	2008-05-24 13:04:20.000000000 +0400
@@ -51,6 +51,17 @@ static DEFINE_PER_CPU(short, wd_enabled)
 
 static int endflag __initdata = 0;
 
+/* Run after command line and cpu_init init, but before all other checks */
+void nmi_watchdog_default(void)
+{
+	if (nmi_watchdog != NMI_DEFAULT)
+		return;
+	if (lapic_watchdog_ok())
+		nmi_watchdog = NMI_LOCAL_APIC;
+	else
+		nmi_watchdog = NMI_IO_APIC;
+}
+
 #ifdef CONFIG_SMP
 /* The performance counters used by NMI_LOCAL_APIC don't trigger when
  * the CPU is idle. To make sure the NMI watchdog really ticks on all
@@ -437,12 +448,8 @@ int proc_nmi_enabled(struct ctl_table *t
 		return -EIO;
 	}
 
-	if (nmi_watchdog == NMI_DEFAULT) {
-		if (lapic_watchdog_ok())
-			nmi_watchdog = NMI_LOCAL_APIC;
-		else
-			nmi_watchdog = NMI_IO_APIC;
-	}
+	/* if nmi_watchdog is not set yet, then set it */
+	nmi_watchdog_default();
 
 	if (nmi_watchdog == NMI_LOCAL_APIC) {
 		if (nmi_watchdog_enabled)
Index: linux-2.6.git/include/asm-x86/nmi.h
====================================================================
--- linux-2.6.git.orig/include/asm-x86/nmi.h	2008-05-24 13:00:50.000000000 +0400
+++ linux-2.6.git/include/asm-x86/nmi.h	2008-05-24 13:04:51.000000000 +0400
@@ -38,11 +38,9 @@ static inline void unset_nmi_pm_callback
 
 #ifdef CONFIG_X86_64
 extern void default_do_nmi(struct pt_regs *);
-extern void nmi_watchdog_default(void);
-#else
-#define nmi_watchdog_default() do {} while (0)
 #endif
 
+extern void nmi_watchdog_default(void);
 extern void die_nmi(char *str, struct pt_regs *regs, int do_panic);
 extern int check_nmi_watchdog(void);
 extern int nmi_watchdog_enabled;

-- 
