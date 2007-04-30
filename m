Return-Path: <linux-kernel-owner+w=401wt.eu-S1423485AbXD3P6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423485AbXD3P6x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 11:58:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423454AbXD3P4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 11:56:12 -0400
Received: from mail.suse.de ([195.135.220.2]:44989 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423442AbXD3Ptl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 11:49:41 -0400
From: Andi Kleen <ak@suse.de>
References: <20070430549.617098000@suse.de>
In-Reply-To: <20070430549.617098000@suse.de>
To: fernando@oss.ntt.co.jp, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [8/34] i386: use safe_apic_wait_icr_idle - i386
Message-Id: <20070430154940.3A768151CA@wotan.suse.de>
Date: Mon, 30 Apr 2007 17:49:40 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Fernando Luis VazquezCao <fernando@oss.ntt.co.jp>

The functionality provided by the new safe_apic_wait_icr_idle is being
open-coded all over "kernel/smpboot.c". Use safe_apic_wait_icr_idle
instead to consolidate code and ease maintenance.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Signed-off-by: Andi Kleen <ak@suse.de>

---

---
 arch/i386/kernel/smpboot.c |   36 ++++++++----------------------------
 1 file changed, 8 insertions(+), 28 deletions(-)

Index: linux/arch/i386/kernel/smpboot.c
===================================================================
--- linux.orig/arch/i386/kernel/smpboot.c
+++ linux/arch/i386/kernel/smpboot.c
@@ -563,8 +563,8 @@ static inline void __inquire_remote_apic
 static int __devinit
 wakeup_secondary_cpu(int logical_apicid, unsigned long start_eip)
 {
-	unsigned long send_status = 0, accept_status = 0;
-	int timeout, maxlvt;
+	unsigned long send_status, accept_status = 0;
+	int maxlvt;
 
 	/* Target chip */
 	apic_write_around(APIC_ICR2, SET_APIC_DEST_FIELD(logical_apicid));
@@ -574,12 +574,7 @@ wakeup_secondary_cpu(int logical_apicid,
 	apic_write_around(APIC_ICR, APIC_DM_NMI | APIC_DEST_LOGICAL);
 
 	Dprintk("Waiting for send to finish...\n");
-	timeout = 0;
-	do {
-		Dprintk("+");
-		udelay(100);
-		send_status = apic_read(APIC_ICR) & APIC_ICR_BUSY;
-	} while (send_status && (timeout++ < 1000));
+	send_status = safe_apic_wait_icr_idle();
 
 	/*
 	 * Give the other CPU some time to accept the IPI.
@@ -609,8 +604,8 @@ wakeup_secondary_cpu(int logical_apicid,
 static int __devinit
 wakeup_secondary_cpu(int phys_apicid, unsigned long start_eip)
 {
-	unsigned long send_status = 0, accept_status = 0;
-	int maxlvt, timeout, num_starts, j;
+	unsigned long send_status, accept_status = 0;
+	int maxlvt, num_starts, j;
 
 	/*
 	 * Be paranoid about clearing APIC errors.
@@ -635,12 +630,7 @@ wakeup_secondary_cpu(int phys_apicid, un
 				| APIC_DM_INIT);
 
 	Dprintk("Waiting for send to finish...\n");
-	timeout = 0;
-	do {
-		Dprintk("+");
-		udelay(100);
-		send_status = apic_read(APIC_ICR) & APIC_ICR_BUSY;
-	} while (send_status && (timeout++ < 1000));
+	send_status = safe_apic_wait_icr_idle();
 
 	mdelay(10);
 
@@ -653,12 +643,7 @@ wakeup_secondary_cpu(int phys_apicid, un
 	apic_write_around(APIC_ICR, APIC_INT_LEVELTRIG | APIC_DM_INIT);
 
 	Dprintk("Waiting for send to finish...\n");
-	timeout = 0;
-	do {
-		Dprintk("+");
-		udelay(100);
-		send_status = apic_read(APIC_ICR) & APIC_ICR_BUSY;
-	} while (send_status && (timeout++ < 1000));
+	send_status = safe_apic_wait_icr_idle();
 
 	atomic_set(&init_deasserted, 1);
 
@@ -714,12 +699,7 @@ wakeup_secondary_cpu(int phys_apicid, un
 		Dprintk("Startup point 1.\n");
 
 		Dprintk("Waiting for send to finish...\n");
-		timeout = 0;
-		do {
-			Dprintk("+");
-			udelay(100);
-			send_status = apic_read(APIC_ICR) & APIC_ICR_BUSY;
-		} while (send_status && (timeout++ < 1000));
+		send_status = safe_apic_wait_icr_idle();
 
 		/*
 		 * Give the other CPU some time to accept the IPI.
