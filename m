Return-Path: <linux-kernel-owner+w=401wt.eu-S1423373AbXD3P6H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423373AbXD3P6H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 11:58:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423442AbXD3P4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 11:56:17 -0400
Received: from mail.suse.de ([195.135.220.2]:44995 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423441AbXD3Ptn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 11:49:43 -0400
From: Andi Kleen <ak@suse.de>
References: <20070430549.617098000@suse.de>
In-Reply-To: <20070430549.617098000@suse.de>
To: fernando@oss.ntt.co.jp, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [10/34] i386: use safe_apic_wait_icr_idle in smpboot.c 
Message-Id: <20070430154942.539F3151D3@wotan.suse.de>
Date: Mon, 30 Apr 2007 17:49:42 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Fernando Luis VazquezCao <fernando@oss.ntt.co.jp>

__inquire_remote_apic is used for APIC debugging, so use
safe_apic_wait_icr_idle  instead of apic_wait_icr_idle to avoid possible
lockups when APIC delivery fails.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Signed-off-by: Andi Kleen <ak@suse.de>

---

---
 arch/i386/kernel/smpboot.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: linux/arch/i386/kernel/smpboot.c
===================================================================
--- linux.orig/arch/i386/kernel/smpboot.c
+++ linux/arch/i386/kernel/smpboot.c
@@ -521,7 +521,8 @@ static inline void __inquire_remote_apic
 {
 	int i, regs[] = { APIC_ID >> 4, APIC_LVR >> 4, APIC_SPIV >> 4 };
 	char *names[] = { "ID", "VERSION", "SPIV" };
-	int timeout, status;
+	int timeout;
+	unsigned long status;
 
 	printk("Inquiring remote APIC #%d...\n", apicid);
 
@@ -531,7 +532,9 @@ static inline void __inquire_remote_apic
 		/*
 		 * Wait for idle.
 		 */
-		apic_wait_icr_idle();
+		status = safe_apic_wait_icr_idle();
+		if (status)
+			printk("a previous APIC delivery may have failed\n");
 
 		apic_write_around(APIC_ICR2, SET_APIC_DEST_FIELD(apicid));
 		apic_write_around(APIC_ICR, APIC_DM_REMRD | regs[i]);
