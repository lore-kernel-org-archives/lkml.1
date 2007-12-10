Return-Path: <linux-kernel-owner+w=401wt.eu-S1752903AbXLJPh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903AbXLJPh7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 10:37:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751982AbXLJPhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 10:37:52 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:24429
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751692AbXLJPhv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 10:37:51 -0500
Message-Id: <475D6B8C.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Mon, 10 Dec 2007 15:38:36 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@redhat.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: suppress mce boot log on Fam 10 and 11
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

 arch/x86/kernel/cpu/mcheck/mce_64.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

--- linux-2.6.24-rc4/arch/x86/kernel/cpu/mcheck/mce_64.c	2007-12-10 16:11:18.000000000 +0100
+++ 2.6.24-rc4-x86_64-amd-fam10-mce-clear/arch/x86/kernel/cpu/mcheck/mce_64.c	2007-12-04 16:09:33.000000000 +0100
@@ -49,7 +49,7 @@ static int banks;
 static unsigned long bank[NR_BANKS] = { [0 ... NR_BANKS-1] = ~0UL };
 static unsigned long notify_user;
 static int rip_msr;
-static int mce_bootlog = 1;
+static int mce_bootlog = -1;
 static atomic_t mce_events;
 
 static char trigger[128];
@@ -63,7 +63,7 @@ static DECLARE_WAIT_QUEUE_HEAD(mce_wait)
  * separate MCEs from kernel messages to avoid bogus bug reports.
  */
 
-struct mce_log mcelog = {
+static struct mce_log mcelog = {
 	MCE_LOG_SIGNATURE,
 	MCE_LOG_LEN,
 };
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



