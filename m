Return-Path: <linux-kernel-owner+w=401wt.eu-S1759704AbYDQBH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759704AbYDQBH7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 21:07:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755028AbYDQBGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 21:06:43 -0400
Received: from sous-sol.org ([216.99.217.87]:58721 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754496AbYDQBGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 21:06:39 -0400
Message-Id: <20080417010333.079765252@sous-sol.org>
References: <20080417010122.148289106@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Wed, 16 Apr 2008 18:01:41 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jean Delvare <khali@linux-fr.org>,
       Tomasz Koprowski <tomek@koprowski.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: pci: revert SMBus unhide on HP Compaq nx6110
Content-Disposition: inline; filename=pci-revert-smbus-unhide-on-hp-compaq-nx6110.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Jean Delvare <khali@linux-fr.org>

upstream commit: a99acc832de1104afaba02d7c2576fd9b9fd6422

This reverts commit 3c0a654e390d00fef9d8faed758f5e1e8078adb5 and
fixes kernel bug #10245:

	http://bugzilla.kernel.org/show_bug.cgi?id=10245

The HP Compaq nc6120 has the same PCI sub-device ID as the nx6110, and the
SMBus is used by ACPI for thermal management on the nc6120, so Linux should
not attach a native driver to it.  This means that this quirk is unsafe and
has to be removed.

I also added a comment to help developers realize that adding new IDs to this
SMBus unhiding quirk table should be done only with great care, and in
particular only after checking that ACPI is not making use of the SMBus.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Tomasz Koprowski <tomek@koprowski.org>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/pci/quirks.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -950,6 +950,12 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_I
  * accesses to the SMBus registers, with potentially bad effects. Thus you
  * should be very careful when adding new entries: if SMM is accessing the
  * Intel SMBus, this is a very good reason to leave it hidden.
+ *
+ * Likewise, many recent laptops use ACPI for thermal management. If the
+ * ACPI DSDT code accesses the SMBus, then Linux should not access it
+ * natively, and keeping the SMBus hidden is the right thing to do. If you
+ * are about to add an entry in the table below, please first disassemble
+ * the DSDT and double-check that there is no code accessing the SMBus.
  */
 static int asus_hides_smbus;
 
@@ -1022,11 +1028,6 @@ static void __init asus_hides_smbus_host
 			case 0x12bd: /* HP D530 */
 				asus_hides_smbus = 1;
 			}
-		else if (dev->device == PCI_DEVICE_ID_INTEL_82915GM_HB)
-			switch (dev->subsystem_device) {
-			case 0x099c: /* HP Compaq nx6110 */
-				asus_hides_smbus = 1;
-			}
        } else if (unlikely(dev->subsystem_vendor == PCI_VENDOR_ID_SAMSUNG)) {
                if (dev->device ==  PCI_DEVICE_ID_INTEL_82855PM_HB)
                        switch(dev->subsystem_device) {

-- 
