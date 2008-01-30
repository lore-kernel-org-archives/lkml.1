Return-Path: <linux-kernel-owner+w=401wt.eu-S1756812AbYA3Fwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812AbYA3Fwf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 00:52:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756358AbYA3FwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 00:52:17 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60257 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756312AbYA3FwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 00:52:16 -0500
Date: Wed, 30 Jan 2008 16:51:04 +1100 (EST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@www.l.google.com
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       auke-jan.h.kok@intel.com, jeff@garzik.org,
       "David S. Miller" <davem@davemloft.net>,
       akpm <akpm@linux-foundation.org>
Subject: Re: Mostly revert "e1000/e1000e: Move PCI-Express device IDs over
 to e1000e"
In-Reply-To: <20080129212314.91b9bb5b.randy.dunlap@oracle.com>
Message-ID: <alpine.LFD.1.00.0801301631400.3426@www.l.google.com>
References: <200801292359.m0TNxb75011826@hera.kernel.org> <20080129212314.91b9bb5b.randy.dunlap@oracle.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 29 Jan 2008, Randy Dunlap wrote:
> 
> Andrew was concerned about this when the driver was in -mm.
> He asked for a patch that would set E1000E to same value as E1000
> and I supplied that.  Auke acked it IIRC.  Other people vetoed it.  :(

Yeah, I've been discussing with Jeff and the gang.

I think we have agreed on a solution where the ID's show up in the old 
driver if the new driver is not enabled at all.

(And as a side note: it turns out that the problem I experienced didn't 
come from the new e1000e driver after all, so I'll be removing the 
EXPERIMENTAL flag again).

So I'd suggest the final patch be something like this, but I'm sendign it 
out just as an example of how we could solve this, not necessarily as a 
final patch.

Jeff, Auke, would something like this be acceptable? It makes it very 
obvious in the driver table which entries are for the PCIE versions that 
would be handled by the E1000E driver if it is enabled..

Untested, but as mentioned, this is more of a "this looks maintainable and 
like it should solve the issues" rather than anything I was planning on 
committing now.

		Linus
---
 drivers/net/Kconfig            |    5 ++-
 drivers/net/e1000/e1000_main.c |   60 ++++++++++++++++++++++------------------
 2 files changed, 37 insertions(+), 28 deletions(-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 5a2d1dd..6c57540 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -1992,7 +1992,7 @@ config E1000_DISABLE_PACKET_SPLIT
 
 config E1000E
 	tristate "Intel(R) PRO/1000 PCI-Express Gigabit Ethernet support"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI
 	---help---
 	  This driver supports the PCI-Express Intel(R) PRO/1000 gigabit
 	  ethernet family of adapters. For PCI or PCI-X e1000 adapters,
@@ -2009,6 +2009,9 @@ config E1000E
 	  To compile this driver as a module, choose M here. The module
 	  will be called e1000e.
 
+config E1000E_ENABLED
+	def_bool E1000E != n
+
 config IP1000
 	tristate "IP1000 Gigabit Ethernet support"
 	depends on PCI && EXPERIMENTAL
diff --git a/drivers/net/e1000/e1000_main.c b/drivers/net/e1000/e1000_main.c
index 3111af6..8c87940 100644
--- a/drivers/net/e1000/e1000_main.c
+++ b/drivers/net/e1000/e1000_main.c
@@ -47,6 +47,12 @@ static const char e1000_copyright[] = "Copyright (c) 1999-2006 Intel Corporation
  * Macro expands to...
  *   {PCI_DEVICE(PCI_VENDOR_ID_INTEL, device_id)}
  */
+#ifdef CONFIG_E1000E_ENABLED
+  #define PCIE(x) 
+#else
+  #define PCIE(x) x,
+#endif
+
 static struct pci_device_id e1000_pci_tbl[] = {
 	INTEL_E1000_ETHERNET_DEVICE(0x1000),
 	INTEL_E1000_ETHERNET_DEVICE(0x1001),
@@ -73,14 +79,14 @@ static struct pci_device_id e1000_pci_tbl[] = {
 	INTEL_E1000_ETHERNET_DEVICE(0x1026),
 	INTEL_E1000_ETHERNET_DEVICE(0x1027),
 	INTEL_E1000_ETHERNET_DEVICE(0x1028),
-	INTEL_E1000_ETHERNET_DEVICE(0x1049),
-	INTEL_E1000_ETHERNET_DEVICE(0x104A),
-	INTEL_E1000_ETHERNET_DEVICE(0x104B),
-	INTEL_E1000_ETHERNET_DEVICE(0x104C),
-	INTEL_E1000_ETHERNET_DEVICE(0x104D),
-	INTEL_E1000_ETHERNET_DEVICE(0x105E),
-	INTEL_E1000_ETHERNET_DEVICE(0x105F),
-	INTEL_E1000_ETHERNET_DEVICE(0x1060),
+PCIE(	INTEL_E1000_ETHERNET_DEVICE(0x1049))
+PCIE(	INTEL_E1000_ETHERNET_DEVICE(0x104A))
+PCIE(	INTEL_E1000_ETHERNET_DEVICE(0x104B))
+PCIE(	INTEL_E1000_ETHERNET_DEVICE(0x104C))
+PCIE(	INTEL_E1000_ETHERNET_DEVICE(0x104D))
+PCIE(	INTEL_E1000_ETHERNET_DEVICE(0x105E))
+PCIE(	INTEL_E1000_ETHERNET_DEVICE(0x105F))
+PCIE(	INTEL_E1000_ETHERNET_DEVICE(0x1060))
 	INTEL_E1000_ETHERNET_DEVICE(0x1075),
 	INTEL_E1000_ETHERNET_DEVICE(0x1076),
 	INTEL_E1000_ETHERNET_DEVICE(0x1077),
@@ -89,28 +95,28 @@ static struct pci_device_id e1000_pci_tbl[] = {
 	INTEL_E1000_ETHERNET_DEVICE(0x107A),
 	INTEL_E1000_ETHERNET_DEVICE(0x107B),
 	INTEL_E1000_ETHERNET_DEVICE(0x107C),
-	INTEL_E1000_ETHERNET_DEVICE(0x107D),
-	INTEL_E1000_ETHERNET_DEVICE(0x107E),
-	INTEL_E1000_ETHERNET_DEVICE(0x107F),
+PCIE(	INTEL_E1000_ETHERNET_DEVICE(0x107D))
+PCIE(	INTEL_E1000_ETHERNET_DEVICE(0x107E))
+PCIE(	INTEL_E1000_ETHERNET_DEVICE(0x107F))
 	INTEL_E1000_ETHERNET_DEVICE(0x108A),
-	INTEL_E1000_ETHERNET_DEVICE(0x108B),
-	INTEL_E1000_ETHERNET_DEVICE(0x108C),
-	INTEL_E1000_ETHERNET_DEVICE(0x1096),
-	INTEL_E1000_ETHERNET_DEVICE(0x1098),
+PCIE(	INTEL_E1000_ETHERNET_DEVICE(0x108B))
+PCIE(	INTEL_E1000_ETHERNET_DEVICE(0x108C))
+PCIE(	INTEL_E1000_ETHERNET_DEVICE(0x1096))
+PCIE(	INTEL_E1000_ETHERNET_DEVICE(0x1098))
 	INTEL_E1000_ETHERNET_DEVICE(0x1099),
-	INTEL_E1000_ETHERNET_DEVICE(0x109A),
-	INTEL_E1000_ETHERNET_DEVICE(0x10A4),
-	INTEL_E1000_ETHERNET_DEVICE(0x10A5),
+PCIE(	INTEL_E1000_ETHERNET_DEVICE(0x109A))
+PCIE(	INTEL_E1000_ETHERNET_DEVICE(0x10A4))
+PCIE(	INTEL_E1000_ETHERNET_DEVICE(0x10A5))
 	INTEL_E1000_ETHERNET_DEVICE(0x10B5),
-	INTEL_E1000_ETHERNET_DEVICE(0x10B9),
-	INTEL_E1000_ETHERNET_DEVICE(0x10BA),
-	INTEL_E1000_ETHERNET_DEVICE(0x10BB),
-	INTEL_E1000_ETHERNET_DEVICE(0x10BC),
-	INTEL_E1000_ETHERNET_DEVICE(0x10C4),
-	INTEL_E1000_ETHERNET_DEVICE(0x10C5),
-	INTEL_E1000_ETHERNET_DEVICE(0x10D5),
-	INTEL_E1000_ETHERNET_DEVICE(0x10D9),
-	INTEL_E1000_ETHERNET_DEVICE(0x10DA),
+PCIE(	INTEL_E1000_ETHERNET_DEVICE(0x10B9))
+PCIE(	INTEL_E1000_ETHERNET_DEVICE(0x10BA))
+PCIE(	INTEL_E1000_ETHERNET_DEVICE(0x10BB))
+PCIE(	INTEL_E1000_ETHERNET_DEVICE(0x10BC))
+PCIE(	INTEL_E1000_ETHERNET_DEVICE(0x10C4))
+PCIE(	INTEL_E1000_ETHERNET_DEVICE(0x10C5))
+PCIE(	INTEL_E1000_ETHERNET_DEVICE(0x10D5))
+PCIE(	INTEL_E1000_ETHERNET_DEVICE(0x10D9))
+PCIE(	INTEL_E1000_ETHERNET_DEVICE(0x10DA))
 	/* required last entry */
 	{0,}
 };
