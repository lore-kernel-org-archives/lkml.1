Return-Path: <linux-kernel-owner+w=401wt.eu-S1753411AbYIYCjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbYIYCjT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 22:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752647AbYIYCjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 22:39:11 -0400
Received: from ozlabs.org ([203.10.76.45]:52289 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752337AbYIYCjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 22:39:09 -0400
Date: Thu, 25 Sep 2008 12:39:04 +1000
From: David Gibson <david@gibson.dropbear.id.au>
To: Paul Mackerras <paulus@samba.org>
Cc: Josh Boyer <jwboyer@linux.vnet.ibm.com>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Fix PCI in Holly device tree
Message-ID: <20080925023904.GC15169@yookeroo.seuss>
Mail-Followup-To: Paul Mackerras <paulus@samba.org>,
	Josh Boyer <jwboyer@linux.vnet.ibm.com>, linuxppc-dev@ozlabs.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PCI bridge on the Holly board is current incorrectly represented
in the device tree.  The current device tree node for the PCI bridge
sits under the tsi-bridge node.  That's not obviously wrong, but the
PCI bridge translated some PCI spaces into CPU address ranges which
were not translated by the tsi-bridge node.

We used to get away with this problem because the PCI bridge discovery
code was also buggy, assuming incorrectly that PCI host bridge nodes
were always directly under the root bus and treating the translated
addresses as raw CPU addresses, rather than parent bus addresses.
This has since been fixed, breaking Holly.

This could be fixed by adding extra translations to the tsi-bridge
node, but this patch instead moves the Holly PCI bridge out of the
tsi-bridge node to the root bus.  This makes the tsi-bridge node
represent only the built-in IO devices in the bridge, with a
more-or-less contiguous address range.  This is the same convention
used on Freescale SoC chips, where the "soc" node represents only the
IMMR region, and the PCI and other bus bridges are separate nodes
under the root bus.

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>

Index: working-2.6/arch/powerpc/boot/dts/holly.dts
===================================================================
--- working-2.6.orig/arch/powerpc/boot/dts/holly.dts	2008-09-02 11:50:12.000000000 +1000
+++ working-2.6/arch/powerpc/boot/dts/holly.dts	2008-09-17 11:50:23.000000000 +1000
@@ -133,61 +133,61 @@
 			reg = <0x00007400 0x00000400>;
 			big-endian;
 		};
+	};
 
-		pci@1000 {
-			device_type = "pci";
-			compatible = "tsi109-pci", "tsi108-pci";
-			#interrupt-cells = <1>;
-			#size-cells = <2>;
-			#address-cells = <3>;
-			reg = <0x00001000 0x00001000>;
-			bus-range = <0x0 0x0>;
-			/*----------------------------------------------------+
-			| PCI memory range.
-			| 01 denotes I/O space
-			| 02 denotes 32-bit memory space
-			+----------------------------------------------------*/
-			ranges = <0x02000000 0x00000000 0x40000000 0x40000000 0x00000000 0x10000000
-				  0x01000000 0x00000000 0x00000000 0x7e000000 0x00000000 0x00010000>;
-			clock-frequency = <133333332>;
-			interrupt-parent = <&MPIC>;
+	pci@c0001000 {
+		device_type = "pci";
+		compatible = "tsi109-pci", "tsi108-pci";
+		#interrupt-cells = <1>;
+		#size-cells = <2>;
+		#address-cells = <3>;
+		reg = <0xc0001000 0x00001000>;
+		bus-range = <0x0 0x0>;
+		/*----------------------------------------------------+
+		| PCI memory range.
+		| 01 denotes I/O space
+		| 02 denotes 32-bit memory space
+		+----------------------------------------------------*/
+		ranges = <0x02000000 0x00000000 0x40000000 0x40000000 0x00000000 0x10000000
+			  0x01000000 0x00000000 0x00000000 0x7e000000 0x00000000 0x00010000>;
+		clock-frequency = <133333332>;
+		interrupt-parent = <&MPIC>;
+		interrupts = <0x17 0x2>;
+		interrupt-map-mask = <0xf800 0x0 0x0 0x7>;
+		/*----------------------------------------------------+
+		| The INTA, INTB, INTC, INTD are shared.
+		+----------------------------------------------------*/
+		interrupt-map = <
+			0x800 0x0 0x0 0x1 &RT0 0x24 0x0
+			0x800 0x0 0x0 0x2 &RT0 0x25 0x0
+			0x800 0x0 0x0 0x3 &RT0 0x26 0x0
+			0x800 0x0 0x0 0x4 &RT0 0x27 0x0
+
+			0x1000 0x0 0x0 0x1 &RT0 0x25 0x0
+			0x1000 0x0 0x0 0x2 &RT0 0x26 0x0
+			0x1000 0x0 0x0 0x3 &RT0 0x27 0x0
+			0x1000 0x0 0x0 0x4 &RT0 0x24 0x0
+
+			0x1800 0x0 0x0 0x1 &RT0 0x26 0x0
+			0x1800 0x0 0x0 0x2 &RT0 0x27 0x0
+			0x1800 0x0 0x0 0x3 &RT0 0x24 0x0
+			0x1800 0x0 0x0 0x4 &RT0 0x25 0x0
+
+			0x2000 0x0 0x0 0x1 &RT0 0x27 0x0
+			0x2000 0x0 0x0 0x2 &RT0 0x24 0x0
+			0x2000 0x0 0x0 0x3 &RT0 0x25 0x0
+			0x2000 0x0 0x0 0x4 &RT0 0x26 0x0
+			>;
+
+		RT0: router@1180 {
+			device_type = "pic-router";
+			interrupt-controller;
+			big-endian;
+			clock-frequency = <0>;
+			#address-cells = <0>;
+			#interrupt-cells = <2>;
 			interrupts = <0x17 0x2>;
-			interrupt-map-mask = <0xf800 0x0 0x0 0x7>;
-			/*----------------------------------------------------+
-			| The INTA, INTB, INTC, INTD are shared.
-			+----------------------------------------------------*/
-			interrupt-map = <
-				0x800 0x0 0x0 0x1 &RT0 0x24 0x0
-				0x800 0x0 0x0 0x2 &RT0 0x25 0x0
-				0x800 0x0 0x0 0x3 &RT0 0x26 0x0
-				0x800 0x0 0x0 0x4 &RT0 0x27 0x0
-
-				0x1000 0x0 0x0 0x1 &RT0 0x25 0x0
-				0x1000 0x0 0x0 0x2 &RT0 0x26 0x0
-				0x1000 0x0 0x0 0x3 &RT0 0x27 0x0
-				0x1000 0x0 0x0 0x4 &RT0 0x24 0x0
-
-				0x1800 0x0 0x0 0x1 &RT0 0x26 0x0
-				0x1800 0x0 0x0 0x2 &RT0 0x27 0x0
-				0x1800 0x0 0x0 0x3 &RT0 0x24 0x0
-				0x1800 0x0 0x0 0x4 &RT0 0x25 0x0
-
-				0x2000 0x0 0x0 0x1 &RT0 0x27 0x0
-				0x2000 0x0 0x0 0x2 &RT0 0x24 0x0
-				0x2000 0x0 0x0 0x3 &RT0 0x25 0x0
-				0x2000 0x0 0x0 0x4 &RT0 0x26 0x0
-				>;
-
-			RT0: router@1180 {
- 				device_type = "pic-router";
- 				interrupt-controller;
- 				big-endian;
- 				clock-frequency = <0>;
- 				#address-cells = <0>;
- 				#interrupt-cells = <2>;
- 				interrupts = <0x17 0x2>;
-				interrupt-parent = <&MPIC>;
-			};
+			interrupt-parent = <&MPIC>;
 		};
 	};
 

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
