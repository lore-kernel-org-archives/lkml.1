Return-Path: <linux-kernel-owner+w=401wt.eu-S1423442AbXD3P6I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423442AbXD3P6I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 11:58:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423472AbXD3P4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 11:56:15 -0400
Received: from mx1.suse.de ([195.135.220.2]:44992 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423373AbXD3Ptm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 11:49:42 -0400
From: Andi Kleen <ak@suse.de>
References: <20070430549.617098000@suse.de>
In-Reply-To: <20070430549.617098000@suse.de>
To: fernando@oss.ntt.co.jp, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [9/34] x86_64: use safe_apic_wait_icr_idle in smpboot.c - x86_64
Message-Id: <20070430154941.44CF3151CA@wotan.suse.de>
Date: Mon, 30 Apr 2007 17:49:41 +0200 (CEST)
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
 arch/x86_64/kernel/smpboot.c |   25 +++++--------------------
 1 file changed, 5 insertions(+), 20 deletions(-)

Index: linux/arch/x86_64/kernel/smpboot.c
===================================================================
--- linux.orig/arch/x86_64/kernel/smpboot.c
+++ linux/arch/x86_64/kernel/smpboot.c
@@ -429,8 +429,8 @@ static void inquire_remote_apic(int apic
  */
 static int __cpuinit wakeup_secondary_via_INIT(int phys_apicid, unsigned int start_rip)
 {
-	unsigned long send_status = 0, accept_status = 0;
-	int maxlvt, timeout, num_starts, j;
+	unsigned long send_status, accept_status = 0;
+	int maxlvt, num_starts, j;
 
 	Dprintk("Asserting INIT.\n");
 
@@ -446,12 +446,7 @@ static int __cpuinit wakeup_secondary_vi
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
 
@@ -464,12 +459,7 @@ static int __cpuinit wakeup_secondary_vi
 	apic_write(APIC_ICR, APIC_INT_LEVELTRIG | APIC_DM_INIT);
 
 	Dprintk("Waiting for send to finish...\n");
-	timeout = 0;
-	do {
-		Dprintk("+");
-		udelay(100);
-		send_status = apic_read(APIC_ICR) & APIC_ICR_BUSY;
-	} while (send_status && (timeout++ < 1000));
+	send_status = safe_apic_wait_icr_idle();
 
 	mb();
 	atomic_set(&init_deasserted, 1);
@@ -508,12 +498,7 @@ static int __cpuinit wakeup_secondary_vi
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
