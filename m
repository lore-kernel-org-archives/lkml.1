Return-Path: <linux-kernel-owner+w=401wt.eu-S2992680AbXDYL01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992680AbXDYL01 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 07:26:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992691AbXDYL01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 07:26:27 -0400
Received: from serv1.oss.ntt.co.jp ([222.151.198.98]:47180 "EHLO
	serv1.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992680AbXDYL00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 07:26:26 -0400
Subject: [PATCH 5/10] __inquire_remote_apic: use safe_apic_wait_icr_idle -
	i386
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
Date: Wed, 25 Apr 2007 20:26:25 +0900
Message-Id: <1177500385.17974.28.camel@sebastian.intellilink.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

__inquire_remote_apic is used for APIC debugging, so use
safe_apic_wait_icr_idle  instead of apic_wait_icr_idle to avoid possible
lockups when APIC delivery fails.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

diff -urNp linux-2.6.21-rc7-orig/arch/i386/kernel/smpboot.c linux-2.6.21-rc7/arch/i386/kernel/smpboot.c
--- linux-2.6.21-rc7-orig/arch/i386/kernel/smpboot.c	2007-04-18 15:49:33.000000000 +0900
+++ linux-2.6.21-rc7/arch/i386/kernel/smpboot.c	2007-04-18 16:36:27.000000000 +0900
@@ -526,7 +526,8 @@ static inline void __inquire_remote_apic
 {
 	int i, regs[] = { APIC_ID >> 4, APIC_LVR >> 4, APIC_SPIV >> 4 };
 	char *names[] = { "ID", "VERSION", "SPIV" };
-	int timeout, status;
+	int timeout;
+	unsigned long status;
 
 	printk("Inquiring remote APIC #%d...\n", apicid);
 
@@ -536,7 +537,9 @@ static inline void __inquire_remote_apic
 		/*
 		 * Wait for idle.
 		 */
-		apic_wait_icr_idle();
+		status = safe_apic_wait_icr_idle();
+		if (status)
+			printk("a previous APIC delivery may have failed\n");
 
 		apic_write_around(APIC_ICR2, SET_APIC_DEST_FIELD(apicid));
 		apic_write_around(APIC_ICR, APIC_DM_REMRD | regs[i]);


