Return-Path: <linux-kernel-owner+w=401wt.eu-S1757114AbYLPO0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757114AbYLPO0l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 09:26:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754933AbYLPO0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 09:26:32 -0500
Received: from one.firstfloor.org ([213.235.205.2]:54678 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754683AbYLPO0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 09:26:31 -0500
Date: Tue, 16 Dec 2008 15:27:08 +0100
From: Andi Kleen <andi@firstfloor.org>
To: torvalds@linux-foundation.org, x86@kernel.org,
       linux-kernel@vger.kernel.org, youquan.song@intel.com,
       suresh.b.siddha@intel.com
Subject: [PATCH] Only scan the root bus in early PCI quirks.
Message-ID: <20081216142708.GA27315@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only scan the root bus in early PCI quirks.

We found a situation on Linus' machine that the Nvidia timer
quirk hit on a Intel chipset system. The problem is that the
system has a fancy Nvidia card with an own PCI bridge, and
the early-quirks code looking for any NVidia bridge triggered
on it incorrectly. This didn't lead a boot failure by luck,
but the timer routing code selecting the wrong timer first and 
some ugly messages. It might lead to real problems on
other systems.

Update: according to Suresh the problem can cause real boot failures
together with x2apic.

I checked all the devices which are currently checked for
by early_quirks and it turns out they are all located in 
the root bus zero.

So change the early-quirks loop to only scan bus 0. This
incidently also saves quite some unnecessary scanning work,
because early_quirks doesn't go through all the non root
busses. I don't expect that it will make the boot visible
faster, but doing less work is still good.

The graphics card is not on bus 0, so it is not matched
anymore.

Cc: youquan.song@intel.com
Cc: suresh.b.siddha@intel.com

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kernel/early-quirks.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

Index: linux-2.6.28-rc4-test/arch/x86/kernel/early-quirks.c
===================================================================
--- linux-2.6.28-rc4-test.orig/arch/x86/kernel/early-quirks.c	2008-10-24 13:34:40.000000000 +0200
+++ linux-2.6.28-rc4-test/arch/x86/kernel/early-quirks.c	2008-12-16 15:23:07.000000000 +0100
@@ -214,6 +214,12 @@
 	void (*f)(int num, int slot, int func);
 };
 
+/*
+ * Only works for devices on the root bus. If you add any devices
+ * not on bus 0 readd another loop level in early_quirks(). But
+ * be careful because at least the Nvidia quirk here relies on
+ * only matching on bus 0.
+ */
 static struct chipset early_qrk[] __initdata = {
 	{ PCI_VENDOR_ID_NVIDIA, PCI_ANY_ID,
 	  PCI_CLASS_BRIDGE_PCI, PCI_ANY_ID, QFLAG_APPLY_ONCE, nvidia_bugs },
@@ -284,17 +290,17 @@
 
 void __init early_quirks(void)
 {
-	int num, slot, func;
+	int slot, func;
 
 	if (!early_pci_allowed())
 		return;
 
 	/* Poor man's PCI discovery */
-	for (num = 0; num < 32; num++)
-		for (slot = 0; slot < 32; slot++)
-			for (func = 0; func < 8; func++) {
-				/* Only probe function 0 on single fn devices */
-				if (check_dev_quirk(num, slot, func))
-					break;
-			}
+	/* Only scan the root bus */
+	for (slot = 0; slot < 32; slot++)
+		for (func = 0; func < 8; func++) {
+			/* Only probe function 0 on single fn devices */
+			if (check_dev_quirk(0, slot, func))
+				break;
+		}
 }
