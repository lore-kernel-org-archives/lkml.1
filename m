Return-Path: <linux-kernel-owner+w=401wt.eu-S1759746AbXHKAZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759746AbXHKAZg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 20:25:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752520AbXHKAZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 20:25:26 -0400
Received: from cantor.suse.de ([195.135.220.2]:42530 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752029AbXHKAZ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 20:25:26 -0400
From: Daniel Gollub <dgollub@suse.de>
Organization: SUSE Linux Products GmbH
To: Andi Kleen <ak@suse.de>
Subject: [PATCHv2] Fix to keep watchdog disabled by default for i386/x86_64
Date: Sat, 11 Aug 2007 02:25:33 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <200708110029.52369.dgollub@suse.de> <200708110132.34522.ak@suse.de>
In-Reply-To: <200708110132.34522.ak@suse.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200708110225.33719.dgollub@suse.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed wrong expression which enabled watchdogs even if nmi_watchdog kernel 
parameter wasn't set. This regression got slightly introduced with commit 
b7471c6da94d30d3deadc55986cc38d1ff57f9ca.

Introduced NMI_DISABLED (-1) which allows to switch the value of NMI_DEFAULT 
without breaking the APIC NMI watchdog code (again).

Fixes:
https://bugzilla.novell.com/show_bug.cgi?id=298084
http://bugzilla.kernel.org/show_bug.cgi?id=7839
And likely some more nmi_watchdog=0 related issues.

Resubmit: x86_64 changes compiled but untested. Shame on me!

Signed-off-by: Daniel Gollub <dgollub@suse.de>
---
 arch/i386/kernel/apic.c  |    2 +-
 arch/i386/kernel/nmi.c   |    4 ++--
 arch/x86_64/kernel/nmi.c |    4 ++--
 include/asm-i386/nmi.h   |    3 ++-
 include/asm-x86_64/nmi.h |    3 ++-
 5 files changed, 9 insertions(+), 7 deletions(-)

diff -rup a/arch/i386/kernel/apic.c b/arch/i386/kernel/apic.c
--- a/arch/i386/kernel/apic.c	2007-08-04 04:49:55.000000000 +0200
+++ b/arch/i386/kernel/apic.c	2007-08-10 21:38:37.000000000 +0200
@@ -1087,7 +1087,7 @@ static int __init detect_init_APIC (void
 	if (l & MSR_IA32_APICBASE_ENABLE)
 		mp_lapic_addr = l & MSR_IA32_APICBASE_BASE;
 
-	if (nmi_watchdog != NMI_NONE)
+	if (nmi_watchdog != NMI_NONE && nmi_watchdog != NMI_DISABLED)
 		nmi_watchdog = NMI_LOCAL_APIC;
 
 	printk(KERN_INFO "Found and enabled local APIC!\n");
diff -rup a/arch/i386/kernel/nmi.c b/arch/i386/kernel/nmi.c
--- a/arch/i386/kernel/nmi.c	2007-08-04 04:49:55.000000000 +0200
+++ b/arch/i386/kernel/nmi.c	2007-08-10 22:00:40.000000000 +0200
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
diff -rup a/arch/x86_64/kernel/nmi.c b/arch/x86_64/kernel/nmi.c
--- a/arch/x86_64/kernel/nmi.c	2007-08-04 04:49:55.000000000 +0200
+++ b/arch/x86_64/kernel/nmi.c	2007-08-10 21:59:36.000000000 +0200
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
diff -rup a/include/asm-i386/nmi.h b/include/asm-i386/nmi.h
--- a/include/asm-i386/nmi.h	2007-08-04 04:49:55.000000000 +0200
+++ b/include/asm-i386/nmi.h	2007-08-10 22:04:51.000000000 +0200
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
diff -rup a/include/asm-x86_64/nmi.h b/include/asm-x86_64/nmi.h
--- a/include/asm-x86_64/nmi.h	2007-08-04 04:49:55.000000000 +0200
+++ b/include/asm-x86_64/nmi.h	2007-08-10 22:04:41.000000000 +0200
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
