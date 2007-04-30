Return-Path: <linux-kernel-owner+w=401wt.eu-S1423572AbXD3QA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423572AbXD3QA7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 12:00:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423506AbXD3P4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 11:56:08 -0400
Received: from mail.suse.de ([195.135.220.2]:44998 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423453AbXD3Pto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 11:49:44 -0400
From: Andi Kleen <ak@suse.de>
References: <20070430549.617098000@suse.de>
In-Reply-To: <20070430549.617098000@suse.de>
To: fernando@oss.ntt.co.jp, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [11/34] x86_64: use safe_apic_wait_icr_idle in smpboot.c -  x86_64
Message-Id: <20070430154943.61E60151CA@wotan.suse.de>
Date: Mon, 30 Apr 2007 17:49:43 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Fernando Luis VazquezCao <fernando@oss.ntt.co.jp>

inquire_remote_apic is used for APIC debugging, so use
safe_apic_wait_icr_idle  instead of apic_wait_icr_idle to avoid possible
lockups when APIC delivery fails.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Signed-off-by: Andi Kleen <ak@suse.de>

---

---
 arch/x86_64/kernel/smpboot.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: linux/arch/x86_64/kernel/smpboot.c
===================================================================
--- linux.orig/arch/x86_64/kernel/smpboot.c
+++ linux/arch/x86_64/kernel/smpboot.c
@@ -391,7 +391,8 @@ static void inquire_remote_apic(int apic
 {
 	unsigned i, regs[] = { APIC_ID >> 4, APIC_LVR >> 4, APIC_SPIV >> 4 };
 	char *names[] = { "ID", "VERSION", "SPIV" };
-	int timeout, status;
+	int timeout;
+	unsigned int status;
 
 	printk(KERN_INFO "Inquiring remote APIC #%d...\n", apicid);
 
@@ -401,7 +402,9 @@ static void inquire_remote_apic(int apic
 		/*
 		 * Wait for idle.
 		 */
-		apic_wait_icr_idle();
+		status = safe_apic_wait_icr_idle();
+		if (status)
+			printk("a previous APIC delivery may have failed\n");
 
 		apic_write(APIC_ICR2, SET_APIC_DEST_FIELD(apicid));
 		apic_write(APIC_ICR, APIC_DM_REMRD | regs[i]);
