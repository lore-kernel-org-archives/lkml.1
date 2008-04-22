Return-Path: <linux-kernel-owner+w=401wt.eu-S1766012AbYDVPWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766012AbYDVPWV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 11:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755900AbYDVPWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 11:22:13 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:15958 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755631AbYDVPWM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 11:22:12 -0400
Message-Id: <480E1ECD.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Tue, 22 Apr 2008 16:22:21 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: extend MCE CPU quirk handling
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At least on my Barcelona, I see MCE log entries after cold boot caused
by BIOS not properly clearing the respective registers. Therefore, this
patch extends the workaround to families 0x10 and 0x11 (the latter just
for completeness, I have nothing to verify this against).
At the same time, provide a way to make these entries visible via the
'mce=bootlog' command line option even on these machines.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/kernel/cpu/mcheck/mce_64.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- linux-2.6.25/arch/x86/kernel/cpu/mcheck/mce_64.c	2008-04-17 04:49:44.000000000 +0200
+++ 2.6.25-x86_64-amd-fam10-mce-clear/arch/x86/kernel/cpu/mcheck/mce_64.c	2008-04-15 10:49:20.000000000 +0200
@@ -49,7 +49,7 @@ static int banks;
 static unsigned long bank[NR_BANKS] = { [0 ... NR_BANKS-1] = ~0UL };
 static unsigned long notify_user;
 static int rip_msr;
-static int mce_bootlog = 1;
+static int mce_bootlog = -1;
 static atomic_t mce_events;
 
 static char trigger[128];
@@ -471,13 +471,15 @@ static void mce_init(void *dummy)
 static void __cpuinit mce_cpu_quirks(struct cpuinfo_x86 *c)
 {
 	/* This should be disabled by the BIOS, but isn't always */
-	if (c->x86_vendor == X86_VENDOR_AMD && c->x86 == 15) {
-		/* disable GART TBL walk error reporting, which trips off
-		   incorrectly with the IOMMU & 3ware & Cerberus. */
-		clear_bit(10, &bank[4]);
-		/* Lots of broken BIOS around that don't clear them
-		   by default and leave crap in there. Don't log. */
-		mce_bootlog = 0;
+	if (c->x86_vendor == X86_VENDOR_AMD) {
+		if(c->x86 == 15)
+			/* disable GART TBL walk error reporting, which trips off
+			   incorrectly with the IOMMU & 3ware & Cerberus. */
+			clear_bit(10, &bank[4]);
+		if(c->x86 <= 17 && mce_bootlog < 0)
+			/* Lots of broken BIOS around that don't clear them
+			   by default and leave crap in there. Don't log. */
+			mce_bootlog = 0;
 	}
 
 }



