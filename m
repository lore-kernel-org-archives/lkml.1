Return-Path: <linux-kernel-owner+w=401wt.eu-S1752242AbZBOKzD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242AbZBOKzD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 05:55:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751966AbZBOKyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 05:54:51 -0500
Received: from hera.kernel.org ([140.211.167.34]:50941 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754068AbZBOKyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 05:54:50 -0500
Message-ID: <4997F44B.8060500@kernel.org>
Date: Sun, 15 Feb 2009 02:54:03 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: pre init pirq_entries[]
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: cleanup

set default value early. also could remove pirqs_enabled...
and one #ifdef

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/io_apic.c |   16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

Index: linux-2.6/arch/x86/kernel/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/io_apic.c
+++ linux-2.6/arch/x86/kernel/io_apic.c
@@ -813,8 +813,9 @@ static void clear_IO_APIC (void)
  */
 
 #define MAX_PIRQS 8
-static int pirq_entries [MAX_PIRQS];
-static int pirqs_enabled;
+static int pirq_entries[MAX_PIRQS] = {
+	[0 ... MAX_PIRQS - 1] = -1
+};
 
 static int __init ioapic_pirq_setup(char *str)
 {
@@ -823,10 +824,6 @@ static int __init ioapic_pirq_setup(char
 
 	get_options(str, ARRAY_SIZE(ints), ints);
 
-	for (i = 0; i < MAX_PIRQS; i++)
-		pirq_entries[i] = -1;
-
-	pirqs_enabled = 1;
 	apic_printk(APIC_VERBOSE, KERN_INFO
 			"PIRQ redirection, working around broken MP-BIOS.\n");
 	max = MAX_PIRQS;
@@ -1976,13 +1973,6 @@ void __init enable_IO_APIC(void)
 	int apic;
 	unsigned long flags;
 
-#ifdef CONFIG_X86_32
-	int i;
-	if (!pirqs_enabled)
-		for (i = 0; i < MAX_PIRQS; i++)
-			pirq_entries[i] = -1;
-#endif
-
 	/*
 	 * The number of IO-APIC IRQ registers (== #pins):
 	 */
