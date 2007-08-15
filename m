Return-Path: <linux-kernel-owner+w=401wt.eu-S933119AbXHOAmL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933119AbXHOAmL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 20:42:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757402AbXHOAki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 20:40:38 -0400
Received: from ns2.suse.de ([195.135.220.15]:55681 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757173AbXHOAkg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 20:40:36 -0400
From: Andi Kleen <ak@suse.de>
References: <20070815240.194452000@suse.de>
In-Reply-To: <20070815240.194452000@suse.de>
To: dgollub@suse.de, patches@x86-64.org, linux-kernel@vger.kernel.org,
       torvalds@osdl.org
Subject: [PATCH] [2/4] x86_64: Fix to keep watchdog disabled by default for i386/x86_64
Message-Id: <20070815004035.5AA7A14DC8@wotan.suse.de>
Date: Wed, 15 Aug 2007 02:40:35 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Daniel Gollub <dgollub@suse.de>
Fixed wrong expression which enabled watchdogs even if nmi_watchdog kernel 
parameter wasn't set. This regression got slightly introduced with commit 
b7471c6da94d30d3deadc55986cc38d1ff57f9ca.

Introduced NMI_DISABLED (-1) which allows to switch the value of NMI_DEFAULT 
without breaking the APIC NMI watchdog code (again).

Fixes:
https://bugzilla.novell.com/show_bug.cgi?id=298084
http://bugzilla.kernel.org/show_bug.cgi?id=7839
And likely some more nmi_watchdog=0 related issues.

Signed-off-by: Daniel Gollub <dgollub@suse.de>
Signed-off-by: Andi Kleen <ak@suse.de>

---
Index: linux/arch/i386/kernel/apic.c
===================================================================
--- linux.orig/arch/i386/kernel/apic.c
+++ linux/arch/i386/kernel/apic.c
@@ -1085,7 +1085,7 @@ static int __init detect_init_APIC (void
 	if (l & MSR_IA32_APICBASE_ENABLE)
 		mp_lapic_addr = l & MSR_IA32_APICBASE_BASE;
 
-	if (nmi_watchdog != NMI_NONE)
+	if (nmi_watchdog != NMI_NONE && nmi_watchdog != NMI_DISABLED)
 		nmi_watchdog = NMI_LOCAL_APIC;
 
 	printk(KERN_INFO "Found and enabled local APIC!\n");
Index: linux/arch/i386/kernel/nmi.c
===================================================================
--- linux.orig/arch/i386/kernel/nmi.c
+++ linux/arch/i386/kernel/nmi.c
@@ -77,7 +77,7 @@ static int __init check_nmi_watchdog(voi
 	unsigned int *prev_nmi_count;
 	int cpu;
 
-	if ((nmi_watchdog == NMI_NONE) || (nmi_watchdog == NMI_DEFAULT))
+	if ((nmi_watchdog == NMI_NONE) || (nmi_watchdog == NMI_DISABLED))
 		return 0;
 
 	if (!atomic_read(&nmi_active))
@@ -424,7 +424,7 @@ int proc_nmi_enabled(struct ctl_table *t
 	if (!!old_state == !!nmi_watchdog_enabled)
 		return 0;
 
-	if (atomic_read(&nmi_active) < 0) {
+	if (atomic_read(&nmi_active) < 0 || nmi_watchdog == NMI_DISABLED) {
 		printk( KERN_WARNING "NMI watchdog is permanently disabled\n");
 		return -EIO;
 	}
Index: linux/arch/x86_64/kernel/nmi.c
===================================================================
--- linux.orig/arch/x86_64/kernel/nmi.c
+++ linux/arch/x86_64/kernel/nmi.c
@@ -85,7 +85,7 @@ int __init check_nmi_watchdog (void)
 	int *counts;
 	int cpu;
 
-	if ((nmi_watchdog == NMI_NONE) || (nmi_watchdog == NMI_DEFAULT))
+	if ((nmi_watchdog == NMI_NONE) || (nmi_watchdog == NMI_DISABLED)) 
 		return 0;
 
 	if (!atomic_read(&nmi_active))
@@ -442,7 +442,7 @@ int proc_nmi_enabled(struct ctl_table *t
 	if (!!old_state == !!nmi_watchdog_enabled)
 		return 0;
 
-	if (atomic_read(&nmi_active) < 0) {
+	if (atomic_read(&nmi_active) < 0 || nmi_watchdog == NMI_DISABLED) {
 		printk( KERN_WARNING "NMI watchdog is permanently disabled\n");
 		return -EIO;
 	}
Index: linux/include/asm-i386/nmi.h
===================================================================
--- linux.orig/include/asm-i386/nmi.h
+++ linux/include/asm-i386/nmi.h
@@ -33,11 +33,12 @@ extern int nmi_watchdog_tick (struct pt_
 
 extern atomic_t nmi_active;
 extern unsigned int nmi_watchdog;
-#define NMI_DEFAULT     -1
+#define NMI_DISABLED    -1
 #define NMI_NONE	0
 #define NMI_IO_APIC	1
 #define NMI_LOCAL_APIC	2
 #define NMI_INVALID	3
+#define NMI_DEFAULT	NMI_DISABLED
 
 struct ctl_table;
 struct file;
Index: linux/include/asm-x86_64/nmi.h
===================================================================
--- linux.orig/include/asm-x86_64/nmi.h
+++ linux/include/asm-x86_64/nmi.h
@@ -64,11 +64,12 @@ extern int setup_nmi_watchdog(char *);
 
 extern atomic_t nmi_active;
 extern unsigned int nmi_watchdog;
-#define NMI_DEFAULT	-1
+#define NMI_DISABLED    -1
 #define NMI_NONE	0
 #define NMI_IO_APIC	1
 #define NMI_LOCAL_APIC	2
 #define NMI_INVALID	3
+#define NMI_DEFAULT	NMI_DISABLED
 
 struct ctl_table;
 struct file;
