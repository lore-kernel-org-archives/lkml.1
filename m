Return-Path: <linux-kernel-owner+w=401wt.eu-S1759832AbXGCTEO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759832AbXGCTEO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 15:04:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757306AbXGCTEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 15:04:00 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:59229
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756782AbXGCTD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 15:03:59 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Don't miss the ARM-scsi fix.
Date: Tue, 3 Jul 2007 15:03:56 -0400
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_c2piGLbQNYifRFU"
Message-Id: <200707031503.56561.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_c2piGLbQNYifRFU
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Just making sure this fix winds up in 2.6.23:

http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=4454/1

It fixes a regression that occurred between 2.6.20 and 2.6.20-rc1.  Without 
it, qemu-system-arm can't use emulated SCSI drives.  It wasn't in -rc7, and 
the attached patch Works For Me (tm).

Signed-off-by: Rob Landley <rob@landley.net>

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.

--Boundary-00=_c2piGLbQNYifRFU
Content-Type: text/x-diff;
  charset="utf-8";
  name="linux-armfix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="linux-armfix.patch"

ARM Versatile PCI config reads of one byte width have the lowest two<br />
bits of the address cleared and result in reading from a wrong place<br />
in the config space.  This change is to use word size accesses like it is done for halfword reads.

Byte reads are used for retrieving the IRQ number of a PCI device and the problem was not exposed until 2.6.20 because the value read was discarded in drivers/pci/setup-irq.c (recently fixed).

Signed-off-by: Andrzej Zaborowski  &lt;(address hidden)&gt;<br />
Acked-by: Paul Brook  &lt;(address hidden)&gt;

Note 2 submitted by Russell King on 02 Jul 2007 12:39:41 (UTC)
Moved to applied
Applied to git-curr.

diff --git a/arch/arm/mach-versatile/pci.c b/arch/arm/mach-versatile/pci.c
index ba58223..ca82901 100644
--- a/arch/arm/mach-versatile/pci.c
+++ b/arch/arm/mach-versatile/pci.c
@@ -117,7 +117,10 @@ static int versatile_read_config(struct pci_bus *bus, unsigned int devfn, int wh
 	} else {
 		switch (size) {
 		case 1:
-			v = __raw_readb(addr);
+			v = __raw_readl(addr);
+			if (where & 2) v >>= 16;
+			if (where & 1) v >>= 8;
+ 			v &= 0xff;
 			break;
 
 		case 2:

--Boundary-00=_c2piGLbQNYifRFU--
