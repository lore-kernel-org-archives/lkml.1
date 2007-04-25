Return-Path: <linux-kernel-owner+w=401wt.eu-S2992687AbXDYLTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992687AbXDYLTq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 07:19:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992691AbXDYLTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 07:19:45 -0400
Received: from ns.oss.ntt.co.jp ([222.151.198.98]:47157 "EHLO
	serv1.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992687AbXDYLTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 07:19:45 -0400
Subject: [PATCH 3/10] smpboot: use safe_apic_wait_icr_idle - i386
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: horms@verge.net.au, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, ak@suse.de, vgoyal@in.ibm.com,
       mbligh@google.com, Keith Owens <kaos@ocs.com.au>,
       akpm@linux-foundation.org
In-Reply-To: <1177498984.16078.37.camel@sebastian.intellilink.co.jp>
References: <1177498984.16078.37.camel@sebastian.intellilink.co.jp>
Content-Type: text/plain
Organization: NTT Open Source Software Center
Date: Wed, 25 Apr 2007 20:19:43 +0900
Message-Id: <1177499983.17974.19.camel@sebastian.intellilink.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The functionality provided by the new safe_apic_wait_icr_idle is being
open-coded all over "kernel/smpboot.c". Use safe_apic_wait_icr_idle
instead to consolidate code and ease maintenance.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

diff -urNp linux-2.6.21-rc7-orig/arch/i386/kernel/smpboot.c linux-2.6.21-rc7/arch/i386/kernel/smpboot.c
--- linux-2.6.21-rc7-orig/arch/i386/kernel/smpboot.c	2007-04-18 15:27:48.000000000 +0900
+++ linux-2.6.21-rc7/arch/i386/kernel/smpboot.c	2007-04-18 15:44:41.000000000 +0900
@@ -568,8 +568,8 @@ static inline void __inquire_remote_apic
 static int __devinit
 wakeup_secondary_cpu(int logical_apicid, unsigned long start_eip)
 {
-	unsigned long send_status = 0, accept_status = 0;
-	int timeout, maxlvt;
+	unsigned long send_status, accept_status = 0;
+	int maxlvt;
 
 	/* Target chip */
 	apic_write_around(APIC_ICR2, SET_APIC_DEST_FIELD(logical_apicid));
@@ -579,12 +579,7 @@ wakeup_secondary_cpu(int logical_apicid,
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
@@ -614,8 +609,8 @@ wakeup_secondary_cpu(int logical_apicid,
 static int __devinit
 wakeup_secondary_cpu(int phys_apicid, unsigned long start_eip)
 {
-	unsigned long send_status = 0, accept_status = 0;
-	int maxlvt, timeout, num_starts, j;
+	unsigned long send_status, accept_status = 0;
+	int maxlvt, num_starts, j;
 
 	/*
 	 * Be paranoid about clearing APIC errors.
@@ -640,12 +635,7 @@ wakeup_secondary_cpu(int phys_apicid, un
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
 
@@ -658,12 +648,7 @@ wakeup_secondary_cpu(int phys_apicid, un
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
 
@@ -719,12 +704,7 @@ wakeup_secondary_cpu(int phys_apicid, un
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


