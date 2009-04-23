Return-Path: <linux-kernel-owner+w=401wt.eu-S1754978AbZDWC2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978AbZDWC2A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 22:28:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752777AbZDWC1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 22:27:49 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:59082 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254AbZDWC1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 22:27:48 -0400
Date: Wed, 22 Apr 2009 22:27:40 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: x86@kernel.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       linux-acpi@vger.kernel.org
Subject: [PATCH] x86/hpet: prevent boot hang when hpet=force used on old ICH
Message-id: <alpine.LFD.2.00.0904222223200.21119@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

Linux tells ICH4 users that they can (manually) invoke
"hpet=force" to enable the undocumented HPET.
The HPET becomes available for both clocksource and clockevents.

But as of ff69f2bba67bd45514923aaedbf40fe351787c59
(acpi: fix of pmtimer overflow that make Cx states time incorrect)
the hpet may be used for idle accounting, and
hpet=force on an ICH4 box hangs boot.

It turns out that reading the HPET timer immediately
after return from C3 hangs.

Well, the reason we enable the HPET on these systems
is primarily for clockevents -- the HPET has a longer
maximum timer duration than the PIT.  HPET as a clocksource
is less interesting.

So for "hpet=force" on old ICH, allow HPET clockevents,
but do not allow HPET as a clocksource.

http://bugzilla.kernel.org/show_bug.cgi?id=13087

Signed-off-by: Len Brown <len.brown@intel.com>
---
Ingo/Peter/Thomas,
This regression was filed against ACPI, but the fix is under x86.
I'd wait for Venki's ack on anything related to HPET,
and I can send via your tree or yours, just let me know.

thanks,
-Len

 arch/x86/include/asm/hpet.h |    1 +
 arch/x86/kernel/hpet.c      |    5 +++++
 arch/x86/kernel/quirks.c    |    4 ++++
 3 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/hpet.h b/arch/x86/include/asm/hpet.h
index 1c22cb0..39d4e86 100644
--- a/arch/x86/include/asm/hpet.h
+++ b/arch/x86/include/asm/hpet.h
@@ -66,6 +66,7 @@
 extern unsigned long hpet_address;
 extern unsigned long force_hpet_address;
 extern int hpet_force_user;
+extern int hpet_is_forced_old_ich(void);
 extern int is_hpet_enabled(void);
 extern int hpet_enable(void);
 extern void hpet_disable(void);
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 3f0019e..8b061c7 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -752,6 +752,11 @@ static int hpet_clocksource_register(void)
 	u64 start, now;
 	cycle_t t1;
 
+	if (hpet_is_forced_old_ich()) {
+		printk(KERN_WARNING "hpet: hpet=force on old ICH enables clockevents,"
+				" but not clocksource.\n");
+		return -ENODEV;
+	}
 	/* Start the counter */
 	hpet_restart_counter();
 
diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index e95022e..9e4d73d 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -253,6 +253,10 @@ static void old_ich_force_enable_hpet(struct pci_dev *dev)
 	dev_printk(KERN_DEBUG, &dev->dev, "Failed to force enable HPET\n");
 }
 
+int hpet_is_forced_old_ich() {
+	return (force_hpet_resume_type == OLD_ICH_FORCE_HPET_RESUME);
+}
+
 /*
  * Undocumented chipset features. Make sure that the user enforced
  * this.
-- 
1.6.3.rc1.34.g0be9b

