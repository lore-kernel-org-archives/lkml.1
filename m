Return-Path: <linux-kernel-owner+w=401wt.eu-S1759950AbYFXQV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759950AbYFXQV1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 12:21:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751730AbYFXQUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 12:20:24 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:36153 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbYFXQUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 12:20:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition
         :message-id;
        b=hFweRoBConolWO43cXGMLYDHzlURVOpmo77bF9S5WAqvD0ewT28MnA8mMXUNnDQTLF
         N9fG4wiuz0rhZe8ycspRs65btYdkw/iAuxADSJna+b8zf3hZgbjGHgtaZatvK7xnC/Co
         1ehlZElGbyRYIgWMD7V68TiKOCABBK/YdbsQs=
References: <20080624161624.124913675@gmail.com>>
User-Agent: quilt/0.46-1
Date: Thu, 01 Jan 1970 03:00:05 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, macro@linux-mips.org
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, linux-kernel@vger.kernel.org
Subject: [patch 5/5] x86: nmi_watchdog - introduce nmi_watchdog_active() helper
Content-Disposition: inline; filename=nmi-watchdog-active
Message-ID: <48611ec5.2435440a.32c4.1a96@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/include/asm-x86/nmi.h
====================================================================
--- linux-2.6.git.orig/include/asm-x86/nmi.h	2008-06-24 19:32:44.000000000 +0400
+++ linux-2.6.git/include/asm-x86/nmi.h	2008-06-24 19:45:13.000000000 +0400
@@ -56,6 +56,19 @@ static inline void localise_nmi_watchdog
 	if (nmi_watchdog == NMI_IO_APIC)
 		nmi_watchdog = NMI_LOCAL_APIC;
 }
+
+/* check if nmi_watchdog is active (ie was specified at boot) */
+static inline int nmi_watchdog_active(void)
+{
+	/*
+	 * actually it should be:
+	 * 	return (nmi_watchdog == NMI_LOCAL_APIC ||
+	 * 		nmi_watchdog == NMI_IO_APIC)
+	 * but since they are power of two we could use a
+	 * cheaper way --cvg
+	 */
+	return nmi_watchdog & 0x3;
+}
 #endif
 
 void lapic_watchdog_stop(void);
Index: linux-2.6.git/arch/x86/kernel/nmi.c
====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/nmi.c	2008-06-24 19:32:09.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/nmi.c	2008-06-24 19:34:16.000000000 +0400
@@ -116,10 +116,7 @@ int __init check_nmi_watchdog(void)
 	unsigned int *prev_nmi_count;
 	int cpu;
 
-	if (nmi_watchdog == NMI_NONE)
-		return 0;
-
-	if (!atomic_read(&nmi_active))
+	if (!nmi_watchdog_active() || !atomic_read(&nmi_active))
 		return 0;
 
 	prev_nmi_count = kmalloc(nr_cpu_ids * sizeof(int), GFP_KERNEL);
@@ -316,8 +313,7 @@ void setup_apic_nmi_watchdog(void *unuse
 void stop_apic_nmi_watchdog(void *unused)
 {
 	/* only support LOCAL and IO APICs for now */
-	if (nmi_watchdog != NMI_LOCAL_APIC &&
-	    nmi_watchdog != NMI_IO_APIC)
+	if (!nmi_watchdog_active())
 		return;
 	if (__get_cpu_var(wd_enabled) == 0)
 		return;
@@ -347,8 +343,7 @@ static DEFINE_PER_CPU(int, nmi_touch);
 
 void touch_nmi_watchdog(void)
 {
-	if (nmi_watchdog == NMI_LOCAL_APIC ||
-		nmi_watchdog == NMI_IO_APIC) {
+	if (nmi_watchdog_active()) {
 		unsigned cpu;
 
 		/*
@@ -473,7 +468,7 @@ int proc_nmi_enabled(struct ctl_table *t
 	if (!!old_state == !!nmi_watchdog_enabled)
 		return 0;
 
-	if (atomic_read(&nmi_active) < 0 || nmi_watchdog == NMI_NONE) {
+	if (atomic_read(&nmi_active) < 0 || !nmi_watchdog_active()) {
 		printk(KERN_WARNING
 			"NMI watchdog is permanently disabled\n");
 		return -EIO;

-- 
