Return-Path: <linux-kernel-owner+w=401wt.eu-S1756082AbZHMUIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082AbZHMUIV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 16:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754322AbZHMUIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 16:08:00 -0400
Received: from kroah.org ([198.145.64.141]:41769 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932172AbZHMT7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:59:41 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Aug 13 12:51:30 2009
Message-Id: <20090813195129.901571614@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Aug 2009 12:50:11 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Peter Korsgaard <jacmet@sunsite.dk>,
       Kumar Gala <galak@kernel.crashing.org>
Subject: [patch 36/74] powerpc/mpc83xx: Fix usb mux setup for mpc834x
References: <20090813194935.985368088@mini.kroah.org>
Content-Disposition: inline; filename=powerpc-mpc83xx-fix-usb-mux-setup-for-mpc834x.patch
In-Reply-To: <20090813195705.GA22393@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Peter Korsgaard <jacmet@sunsite.dk>

commit b7d66c88c968379ebe683a28c4005895497ebbad upstream.

usb0 and usb1 mux settings in the sicrl register were swapped (twice!)
in mpc834x_usb_cfg(), leading to various strange issues with fsl-ehci
and full speed devices.

The USB port config on mpc834x is done using 2 muxes: Port 0 is always
used for MPH port 0, and port 1 can either be used for MPH port 1 or DR
(unless DR uses UTMI phy or OTG, then it uses both ports) - See 8349 RM
figure 1-4..

mpc8349_usb_cfg() had this inverted for the DR, and it also had the bit
positions of the usb0 / usb1 mux settings swapped. It would basically
work if you specified port1 instead of port0 for the MPH controller (and
happened to use ULPI phys), which is what all the 834x dts have done,
even though that configuration is physically invalid.

Instead fix mpc8349_usb_cfg() and adjust the dts files to match reality.

Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/boot/dts/asp834x-redboot.dts |    2 +-
 arch/powerpc/boot/dts/mpc8349emitx.dts    |    2 +-
 arch/powerpc/boot/dts/mpc834x_mds.dts     |    2 +-
 arch/powerpc/boot/dts/sbc8349.dts         |    2 +-
 arch/powerpc/platforms/83xx/mpc83xx.h     |    4 ++--
 arch/powerpc/platforms/83xx/usb.c         |   10 +++++-----
 6 files changed, 11 insertions(+), 11 deletions(-)

--- a/arch/powerpc/boot/dts/asp834x-redboot.dts
+++ b/arch/powerpc/boot/dts/asp834x-redboot.dts
@@ -167,7 +167,7 @@
 			interrupt-parent = <&ipic>;
 			interrupts = <39 0x8>;
 			phy_type = "ulpi";
-			port1;
+			port0;
 		};
 		/* phy type (ULPI, UTMI, UTMI_WIDE, SERIAL) */
 		usb@23000 {
--- a/arch/powerpc/boot/dts/mpc8349emitx.dts
+++ b/arch/powerpc/boot/dts/mpc8349emitx.dts
@@ -156,7 +156,7 @@
 			interrupt-parent = <&ipic>;
 			interrupts = <39 0x8>;
 			phy_type = "ulpi";
-			port1;
+			port0;
 		};
 
 		usb@23000 {
--- a/arch/powerpc/boot/dts/mpc834x_mds.dts
+++ b/arch/powerpc/boot/dts/mpc834x_mds.dts
@@ -153,7 +153,7 @@
 			interrupt-parent = <&ipic>;
 			interrupts = <39 0x8>;
 			phy_type = "ulpi";
-			port1;
+			port0;
 		};
 		/* phy type (ULPI, UTMI, UTMI_WIDE, SERIAL) */
 		usb@23000 {
--- a/arch/powerpc/boot/dts/sbc8349.dts
+++ b/arch/powerpc/boot/dts/sbc8349.dts
@@ -144,7 +144,7 @@
 			interrupt-parent = <&ipic>;
 			interrupts = <39 0x8>;
 			phy_type = "ulpi";
-			port1;
+			port0;
 		};
 		/* phy type (ULPI, UTMI, UTMI_WIDE, SERIAL) */
 		usb@23000 {
--- a/arch/powerpc/platforms/83xx/mpc83xx.h
+++ b/arch/powerpc/platforms/83xx/mpc83xx.h
@@ -22,8 +22,8 @@
 /* system i/o configuration register low */
 #define MPC83XX_SICRL_OFFS         0x114
 #define MPC834X_SICRL_USB_MASK     0x60000000
-#define MPC834X_SICRL_USB0         0x40000000
-#define MPC834X_SICRL_USB1         0x20000000
+#define MPC834X_SICRL_USB0         0x20000000
+#define MPC834X_SICRL_USB1         0x40000000
 #define MPC831X_SICRL_USB_MASK     0x00000c00
 #define MPC831X_SICRL_USB_ULPI     0x00000800
 #define MPC8315_SICRL_USB_MASK     0x000000fc
--- a/arch/powerpc/platforms/83xx/usb.c
+++ b/arch/powerpc/platforms/83xx/usb.c
@@ -47,25 +47,25 @@ int mpc834x_usb_cfg(void)
 		sccr |= MPC83XX_SCCR_USB_DRCM_11;  /* 1:3 */
 
 		prop = of_get_property(np, "phy_type", NULL);
+		port1_is_dr = 1;
 		if (prop && (!strcmp(prop, "utmi") ||
 					!strcmp(prop, "utmi_wide"))) {
 			sicrl |= MPC834X_SICRL_USB0 | MPC834X_SICRL_USB1;
 			sicrh |= MPC834X_SICRH_USB_UTMI;
-			port1_is_dr = 1;
+			port0_is_dr = 1;
 		} else if (prop && !strcmp(prop, "serial")) {
 			dr_mode = of_get_property(np, "dr_mode", NULL);
 			if (dr_mode && !strcmp(dr_mode, "otg")) {
 				sicrl |= MPC834X_SICRL_USB0 | MPC834X_SICRL_USB1;
-				port1_is_dr = 1;
+				port0_is_dr = 1;
 			} else {
-				sicrl |= MPC834X_SICRL_USB0;
+				sicrl |= MPC834X_SICRL_USB1;
 			}
 		} else if (prop && !strcmp(prop, "ulpi")) {
-			sicrl |= MPC834X_SICRL_USB0;
+			sicrl |= MPC834X_SICRL_USB1;
 		} else {
 			printk(KERN_WARNING "834x USB PHY type not supported\n");
 		}
-		port0_is_dr = 1;
 		of_node_put(np);
 	}
 	np = of_find_compatible_node(NULL, NULL, "fsl-usb2-mph");


