Return-Path: <linux-kernel-owner+w=401wt.eu-S1755218AbXL1QYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218AbXL1QYb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 11:24:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754075AbXL1QYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 11:24:22 -0500
Received: from mail0.scram.de ([78.47.204.202]:49093 "EHLO mail0.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754150AbXL1QYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 11:24:19 -0500
X-Spam-Score: -4.008
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.4 AWL AWL: From: address is in the auto white-list
Message-ID: <477522DB.4000100@scram.de>
Date: Fri, 28 Dec 2007 17:22:51 +0100
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071009)
MIME-Version: 1.0
To: linuxppc-dev@ozlabs.org
CC: Scott Wood <scottwood@freescale.com>,
       Vitaly Bordug <vitb@kernel.crashing.org>, linux-kernel@vger.kernel.org,
       "linuxppc-embedded@ozlabs.org" <linuxppc-embedded@ozlabs.org>
Subject: [PATCHv3] powerpc: DBox2 Board Support
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds device tree source, default config and setup code for
DBox2 devices.

Signed-off-by: Jochen Friedrich <jochen@scram.de>
---
 arch/powerpc/boot/Makefile               |    4 +-
 arch/powerpc/boot/cuboot-dbox2.c         |  280 ++++++++
 arch/powerpc/boot/dts/dbox2.dts          |  251 ++++++++
 arch/powerpc/configs/dbox2_defconfig     | 1034 ++++++++++++++++++++++++++++++
 arch/powerpc/platforms/8xx/Kconfig       |    7 +
 arch/powerpc/platforms/8xx/Makefile      |    1 +
 arch/powerpc/platforms/8xx/dbox2_setup.c |  173 +++++
 7 files changed, 1749 insertions(+), 1 deletions(-)
 create mode 100644 arch/powerpc/boot/cuboot-dbox2.c
 create mode 100644 arch/powerpc/boot/dts/dbox2.dts
 create mode 100644 arch/powerpc/configs/dbox2_defconfig
 create mode 100644 arch/powerpc/platforms/8xx/dbox2_setup.c

diff --git a/arch/powerpc/boot/Makefile b/arch/powerpc/boot/Makefile
index 18e3271..4c9ec63 100644
--- a/arch/powerpc/boot/Makefile
+++ b/arch/powerpc/boot/Makefile
@@ -55,7 +55,8 @@ src-wlib := string.S crt0.S stdio.c main.c flatdevtree.c flatdevtree_misc.c \
 src-plat := of.c cuboot-52xx.c cuboot-83xx.c cuboot-85xx.c holly.c \
 		cuboot-ebony.c treeboot-ebony.c prpmc2800.c \
 		ps3-head.S ps3-hvcall.S ps3.c treeboot-bamboo.c cuboot-8xx.c \
-		cuboot-pq2.c cuboot-sequoia.c treeboot-walnut.c cuboot-bamboo.c \
+		cuboot-pq2.c cuboot-sequoia.c treeboot-walnut.c \
+		cuboot-bamboo.c cuboot-dbox2.c \
 		fixed-head.S ep88xc.c cuboot-hpc2.c
 src-boot := $(src-wlib) $(src-plat) empty.c
 
@@ -159,6 +160,7 @@ image-$(CONFIG_EBONY)			+= treeImage.ebony cuImage.ebony
 image-$(CONFIG_BAMBOO)			+= treeImage.bamboo cuImage.bamboo
 image-$(CONFIG_SEQUOIA)			+= cuImage.sequoia
 image-$(CONFIG_WALNUT)			+= treeImage.walnut
+image-$(CONFIG_DBOX2)			+= cuImage.dbox2
 endif
 
 # For 32-bit powermacs, build the COFF and miboot images
diff --git a/arch/powerpc/boot/cuboot-dbox2.c b/arch/powerpc/boot/cuboot-dbox2.c
new file mode 100644
index 0000000..e54cef2
--- /dev/null
+++ b/arch/powerpc/boot/cuboot-dbox2.c
@@ -0,0 +1,280 @@
+/*
+ * Old U-boot compatibility for dbox2
+ *
+ * Copyright (c) 2007 Jochen Friedrich <jochen@scram.de>
+ *
+ * Based on cuboot-8xx.c.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ */
+
+#include "ops.h"
+#include "stdio.h"
+#include "cuboot.h"
+#include "io.h"
+
+#define TARGET_8xx
+#include "ppcboot.h"
+
+static bd_t bd;
+
+#define	MAX_PROP_LEN		256 /* What should this be? */
+#define DBOX2_VENDOR_OFFSET	(0x1ffe0)
+
+enum dbox2_mid {
+	DBOX2_MID_UNKNOWN     = 0,
+	DBOX2_MID_NOKIA       = 1,
+	DBOX2_MID_PHILIPS     = 2,
+	DBOX2_MID_SAGEM       = 3,
+};
+
+struct dbox2_board_info {
+	enum dbox2_mid mid;
+	char *model;
+	char *avs;
+	char *demux;
+	char *fp;
+	u32 cs3start;
+	u32 cs3size;
+	u32 cs5start;
+	u32 cs5size;
+	u32 cs6start;
+	u32 cs6size;
+	u32 cs7start;
+	u32 cs7size;
+	u32 demux0cs;
+	u32 demux0start;
+	u32 demux0size;
+	u32 demux1cs;
+	u32 demux1start;
+	u32 demux1size;
+	u32 fp_id;
+};
+
+static struct dbox2_board_info dbox2_board_info[] = {
+	{
+		.mid		= DBOX2_MID_NOKIA,
+		.model	 	= "nokia,dbox2",
+		.avs		= "sony,cxa2092",
+		.demux		= "c-cube,gtx",	
+		.fp		= "fp@5a",
+		.cs3start	= 0x0c000000,
+		.cs3size	= 0x00040000,
+		.cs5start	= 0x08000000,
+		.cs5size	= 0x00200000,
+		.cs6start	= 0x0b000000,
+		.cs6size	= 0x00008000,
+		.cs7start	= 0x08400000,
+		.cs7size	= 0x00008000,
+		.demux0cs	= 7,
+		.demux0start	= 0x00000000,
+		.demux0size	= 0x00003000,
+		.demux1cs	= 5,
+		.demux1start	= 0x00000000,
+		.demux1size	= 0x00200000,
+		.fp_id		= 0x5a,
+	},
+	{
+		.mid		= DBOX2_MID_PHILIPS,
+		.model	 	= "philips,dbox2",
+		.avs		= "stm,stv6412",
+		.demux		= "c-cube,enx",
+		.fp		= "fp@52",
+		.cs3start	= 0x0c040000,
+		.cs3size	= 0x00040000,
+		.cs5start	= 0x08000000,
+		.cs5size	= 0x00008000,
+		.cs6start	= 0x0b000000,
+		.cs6size	= 0x00008000,
+		.cs7start	= 0x09000000,
+		.cs7size	= 0x01000000,
+		.demux0cs	= 5,
+		.demux0start	= 0x00000000,
+		.demux0size	= 0x00003400,
+		.demux1cs	= 7,
+		.demux1start	= 0x00000000,
+		.demux1size	= 0x00200000,
+		.fp_id		= 0x52,
+	},
+	{
+		.mid		= DBOX2_MID_SAGEM,
+		.model	 	= "sagem,dbox2",
+		.avs		= "sony,cxa2126",
+		.demux		= "c-cube,enx",
+		.fp		= "fp@52",
+		.cs3start	= 0x0c000000,
+		.cs3size	= 0x00040000,
+		.cs5start	= 0x08000000,
+		.cs5size	= 0x00008000,
+		.cs6start	= 0x0b000000,
+		.cs6size	= 0x00008000,
+		.cs7start	= 0x09000000,
+		.cs7size	= 0x01000000,
+		.demux0cs	= 5,
+		.demux0start	= 0x00000000,
+		.demux0size	= 0x00003400,
+		.demux1cs	= 7,
+		.demux1start	= 0x00000000,
+		.demux1size	= 0x00200000,
+		.fp_id		= 0x52,
+	},
+};
+
+struct cs_range {
+	u32 csnum;
+	u32 base; /* must be zero */
+	u32 addr;
+	u32 size;
+};
+
+static struct cs_range cs_ranges_buf[MAX_PROP_LEN / sizeof(struct cs_range)];
+
+static u32 reg_buf[6];
+
+static struct dbox2_board_info *dbox2_get_board_info(enum dbox2_mid mid)
+{
+	struct dbox2_board_info *did;
+	int i;
+
+	did = dbox2_board_info;
+	for (i=0; i<ARRAY_SIZE(dbox2_board_info); i++) {
+		if (mid == did->mid)
+			return did;
+		did++;
+	}
+	return NULL;
+}
+
+static enum dbox2_mid read_mid(void)
+{
+	void *node;
+	u8   *addr;
+	unsigned long size;
+	enum dbox2_mid mid;
+
+	node = finddevice("/localbus/flash");
+	if (!node) {
+		return DBOX2_MID_UNKNOWN;
+	}
+	if (!dt_xlate_reg(node, 0, (unsigned long *)&addr, &size)) {
+		return DBOX2_MID_UNKNOWN;
+	}
+	mid = in_8(&addr[DBOX2_VENDOR_OFFSET]);
+	if (mid <= DBOX2_MID_SAGEM)
+		return mid;
+
+	return DBOX2_MID_UNKNOWN;
+}
+
+static void platform_fixups(void)
+{
+	void *node, *newnode;
+	enum dbox2_mid mid;
+	struct dbox2_board_info *did;
+	int i, len;
+	dt_fixup_memory(bd.bi_memstart, bd.bi_memsize);
+	dt_fixup_mac_addresses(bd.bi_enetaddr);
+	dt_fixup_cpu_clocks(bd.bi_intfreq, bd.bi_busfreq / 16, bd.bi_busfreq);
+
+	node = finddevice("/soc/cpm");
+	if (node)
+		setprop(node, "clock-frequency", &bd.bi_busfreq, 4);
+
+	node = finddevice("/soc/cpm/brg");
+	if (node)
+		setprop(node, "clock-frequency",  &bd.bi_busfreq, 4);
+
+	mid = read_mid();
+	did = dbox2_get_board_info(mid);
+	if (!did)
+		return;
+
+	node = finddevice("/");
+	if (node)
+		setprop_str(node, "model", did->model);
+
+	/* Setup localbus */
+	node = finddevice("/localbus");
+	if (node) {
+		len = getprop(node, "ranges", cs_ranges_buf,
+			      sizeof(cs_ranges_buf));
+
+		for (i = 0; i < len / sizeof(struct cs_range); i++) {
+			if (cs_ranges_buf[i].csnum == 3) {
+				cs_ranges_buf[i].addr = did->cs3start;
+				cs_ranges_buf[i].size = did->cs3size;
+			} else if (cs_ranges_buf[i].csnum == 5) {
+				cs_ranges_buf[i].addr = did->cs5start;
+				cs_ranges_buf[i].size = did->cs5size;
+			} else if (cs_ranges_buf[i].csnum == 6) {
+				cs_ranges_buf[i].addr = did->cs6start;
+				cs_ranges_buf[i].size = did->cs6size;
+			} else if (cs_ranges_buf[i].csnum == 7) {
+				cs_ranges_buf[i].addr = did->cs7start;
+				cs_ranges_buf[i].size = did->cs7size;
+			}
+		}
+		setprop(node, "ranges", cs_ranges_buf, len);
+	}
+
+	node = finddevice("/localbus/mpegdemux");
+	if (node) {
+		setprop_str(node, "compatible", did->demux);
+
+		reg_buf[0] = did->demux0cs;
+		reg_buf[1] = did->demux0start;
+		reg_buf[2] = did->demux0size;
+		reg_buf[3] = did->demux1cs;
+		reg_buf[4] = did->demux1start;
+		reg_buf[5] = did->demux1size;
+
+		setprop(node, "reg", reg_buf, 6 * sizeof(u32));
+	}
+
+	node = finddevice("/soc/cpm/i2c");
+	if (node) {
+
+		newnode = create_node(node, did->fp);
+		setprop_str(newnode, "compatible", "betaresearch,dbox2-fp");
+
+		reg_buf[0] = 4;
+		reg_buf[1] = 2;
+
+		setprop(newnode, "interrupts", reg_buf, 2 * sizeof(u32));
+
+		node = finddevice("/soc/pic");
+		if (node) {
+
+			len = getprop(node, "linux,phandle", reg_buf,
+				      sizeof(reg_buf));
+
+			setprop(newnode, "interrupt-parent", reg_buf,
+				sizeof(u32));
+		}
+
+		reg_buf[0] = 0;
+		reg_buf[1] = 0xe;
+
+		setprop(newnode, "gpios", reg_buf, 2 * sizeof(u32));
+
+		node = finddevice("/soc/cpm/pio");
+		if (node) {
+
+			len = getprop(node, "linux,phandle", reg_buf,
+				      sizeof(reg_buf));
+
+			setprop(newnode, "gpio-parent", reg_buf, sizeof(u32));
+		}
+	}
+}
+
+void platform_init(unsigned long r3, unsigned long r4, unsigned long r5,
+                   unsigned long r6, unsigned long r7)
+{
+	CUBOOT_INIT();
+	fdt_init(_dtb_start);
+	serial_console_init();
+	platform_ops.fixups = platform_fixups;
+}
diff --git a/arch/powerpc/boot/dts/dbox2.dts b/arch/powerpc/boot/dts/dbox2.dts
new file mode 100644
index 0000000..2733134
--- /dev/null
+++ b/arch/powerpc/boot/dts/dbox2.dts
@@ -0,0 +1,251 @@
+/*
+ * DBOX2 Device Tree Source
+ *
+ * Copyright 2007 Jochen Friedrich <jochen@scram.de>
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+/ {
+	model = "unknown,dbox2"; // boot wrapper fills in correct manufacturer
+	compatible = "betaresearch,dbox2";
+	#address-cells = <1>;
+	#size-cells = <1>;
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		PowerPC,823@0 {
+			device_type = "cpu";
+			reg = <0>;
+			d-cache-line-size = <d#16>;
+			i-cache-line-size = <d#16>;
+			d-cache-size = <d#1024>;
+			i-cache-size = <d#2048>;
+			timebase-frequency = <0>;
+			bus-frequency = <0>;
+			clock-frequency = <0>;
+			interrupts = <f 2>;	// decrementer interrupt
+			interrupt-parent = <&PIC>;
+		};
+	};
+
+	memory {
+		device_type = "memory";
+		reg = <0 0>;
+	};
+
+	localbus@8000000 {
+		compatible = "fsl,mpc823-localbus";
+		#address-cells = <2>;
+		#size-cells = <1>;
+		reg = <8000000 18000000>;
+
+		// CS3,5,6,7 are manufacturer specific. Filled by boot wrapper
+		ranges = <
+			0 0 10000000 00800000 // flash 32bit
+			1 0 00000000 02000000 // memory 32bit
+			2 0 02000000 02000000 // mem ext / CPLD 32bit
+			3 0 00000000 00000000 // CAM 16bit
+			4 0 0a000000 00008000 // Avia 8bit
+			5 0 00000000 00000000 // enx/gtx 16bit
+			6 0 00000000 00000000 // CAM 16bit
+			7 0 00000000 00000000 // enx/gtx 16bit
+		>;
+
+		cam@3,0 {
+			compatible = "betaresearch,dbox2-cam";
+			reg = <3 0 20000 6 0 20000>;
+			interrupts = <6 2>;
+			interrupt-parent = <&PIC>;
+			gpios = <1 1c 1 1d 1 1e 1 1f>;
+			gpio-parent = <&CPM1_PIO>;
+		};
+
+		mpegdec@4,0 {
+			compatible = "c-cube,avia";
+			reg = <4 0 200>;
+			interrupts = <8 2>;
+			interrupt-parent = <&PIC>;
+		};
+
+		mpegdemux@5,0 {
+			compatible = "c-cube,enx";
+			reg = <5 0 3400 7 0 200000>;
+			interrupts = <2 2>;
+			interrupt-parent = <&PIC>;
+		};
+
+		flash@0,0 {
+			compatible = "cfi-flash";
+			reg = <0 0 800000>;
+			bank-width = <4>;
+			device-width = <1>;
+			#address-cells = <1>;
+			#size-cells = <1>;
+			partition@0 {
+				label = "BR bootloader";
+				reg = <0 20000>;
+				read-only;
+			};
+			partition@20000 {
+				label = "FLFS (U-Boot)";
+				reg = <20000 20000>;
+			};
+			partition@40000 {
+				label = "rootfs";
+				reg = <40000 7c0000>;
+			};
+			ovpartition@20000 {
+				label = "Flash without bootloader";
+				reg = <20000 7e0000>;
+			};
+			ovpartition@0 {
+				label = "Complete Flash";
+				reg = <0 800000>;
+				read-only;
+			};
+		};
+	};
+
+	soc@ff000000 {
+		compatible = "fsl,mpc823",
+			     "fsl,pq1-soc";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		device_type = "soc";
+		ranges = <0 ff000000 00004000>;
+		reg = <ff000000 00004000>;
+		bus-frequency = <0>;
+
+		PIC: pic@0 {
+			interrupt-controller;
+			#address-cells = <0>;
+			#interrupt-cells = <2>;
+			reg = <0 24>;
+			compatible = "fsl,mpc823-pic",
+				     "fsl,pq1-pic";
+		};
+
+		wdt@0 {
+			compatible = "fsl,mpc823-wdt",
+				     "fsl,pq1-wdt";
+			reg = <0 10>;
+		};
+
+		cpm@9c0 {
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges;
+			reg = <9c0 40>;
+			command-proc = <9c0>;
+			interrupts = <0 2>;	// cpm error interrupt
+			interrupt-parent = <&CPM_PIC>;
+			compatible = "fsl,mpc823-cpm",
+				     "fsl,cpm1";
+
+			muram@2000 {
+				#address-cells = <1>;
+				#size-cells = <1>;
+				ranges = <0 2000 2000>;
+
+				data@0 {
+					compatible = "fsl,cpm-muram-data";
+					reg = <0 1c00>;
+				};
+			};
+
+			// Port D is LCD exclusive. Don't export as GPIO
+			CPM1_PIO: pio@950 {
+				compatible = "fsl,cpm1-pario";
+				reg = <950 180>;
+				num-ports = <4>;
+				ranges = <
+					0 0 000 10 // 16bit PortA
+					1 0 168 10 // 32bit PortB
+					2 0 010 10 // 16bit PortC
+					3 0 020 10 // 16bit PortD
+				>;
+				#gpio-cells = <2>;
+				#address-cells = <2>;
+				#size-cells = <1>;
+
+				lcd@3,0 {
+					reg = <3 0 10>;
+					compatible = "samsung,ks0713";
+				};
+			};
+
+			brg@9f0 {
+				compatible = "fsl,mpc823-brg",
+					     "fsl,cpm1-brg",
+					     "fsl,cpm-brg";
+				reg = <9f0 10>;
+			};
+
+			CPM_PIC: pic@930 {
+				interrupt-controller;
+				#address-cells = <0>;
+				#interrupt-cells = <2>;
+				interrupts = <5 2 0 2>;
+				interrupt-parent = <&PIC>;
+				reg = <930 20>;
+				compatible = "fsl,mpc823-cpm-pic",
+					     "fsl,cpm1-pic";
+			};
+
+			serial@a80 {
+				device_type = "serial";
+				compatible = "fsl,mpc823-smc-uart",
+					     "fsl,cpm1-smc-uart";
+				reg = <a80 10 3e80 40>;
+				interrupts = <4 3>;
+				interrupt-parent = <&CPM_PIC>;
+				fsl,cpm-brg = <1>;
+				fsl,cpm-command = <0090>;
+			};
+
+			serial@a90 {
+				device_type = "serial";
+				compatible = "fsl,mpc823-smc-uart",
+					     "fsl,cpm1-smc-uart";
+				reg = <a90 10 3f80 40>;
+				interrupts = <3 3>;
+				interrupt-parent = <&CPM_PIC>;
+				fsl,cpm-brg = <2>;
+				fsl,cpm-command = <00d0>;
+			};
+
+			ethernet@a00 {
+				device_type = "network";
+				compatible = "fsl,mpc823-scc-enet",
+					     "fsl,cpm1-scc-enet";
+				reg = <a20 20 3d00 80>;
+				interrupts = <1d 3>;
+				interrupt-parent = <&CPM_PIC>;
+				fixed-link = <1 0 d#10>;
+				fsl,cpm-command = <0040>;
+				linux,network-index = <0>;
+			};
+
+			i2c@860 {
+				compatible = "fsl,mpc823-i2c",
+					     "fsl,cpm1-i2c",
+					     "fsl,cpm-i2c";
+				reg = <860 20 3c80 30>;
+				interrupts = <10 3>;
+				interrupt-parent = <&CPM_PIC>;
+				fsl,cpm-command = <0010>;
+				#address-cells = <1>;
+				#size-cells = <0>;
+			};
+		};
+	};
+	chosen {
+		linux,stdout-path = "/soc/cpm/serial@a80";
+	};
+};
diff --git a/arch/powerpc/configs/dbox2_defconfig b/arch/powerpc/configs/dbox2_defconfig
new file mode 100644
index 0000000..525bd00
--- /dev/null
+++ b/arch/powerpc/configs/dbox2_defconfig
@@ -0,0 +1,1034 @@
+#
+# Automatically generated make config: don't edit
+# Linux kernel version: 2.6.24-rc6
+# Fri Dec 28 17:17:51 2007
+#
+# CONFIG_PPC64 is not set
+
+#
+# Processor support
+#
+# CONFIG_6xx is not set
+# CONFIG_PPC_85xx is not set
+CONFIG_PPC_8xx=y
+# CONFIG_40x is not set
+# CONFIG_44x is not set
+# CONFIG_E200 is not set
+CONFIG_8xx=y
+# CONFIG_PPC_MM_SLICES is not set
+CONFIG_NOT_COHERENT_CACHE=y
+CONFIG_PPC32=y
+CONFIG_WORD_SIZE=32
+CONFIG_PPC_MERGE=y
+CONFIG_MMU=y
+CONFIG_GENERIC_CMOS_UPDATE=y
+CONFIG_GENERIC_TIME=y
+CONFIG_GENERIC_TIME_VSYSCALL=y
+CONFIG_GENERIC_CLOCKEVENTS=y
+CONFIG_GENERIC_HARDIRQS=y
+CONFIG_IRQ_PER_CPU=y
+CONFIG_RWSEM_XCHGADD_ALGORITHM=y
+CONFIG_ARCH_HAS_ILOG2_U32=y
+CONFIG_GENERIC_HWEIGHT=y
+CONFIG_GENERIC_CALIBRATE_DELAY=y
+CONFIG_GENERIC_FIND_NEXT_BIT=y
+# CONFIG_ARCH_NO_VIRT_TO_BUS is not set
+CONFIG_PPC=y
+CONFIG_EARLY_PRINTK=y
+CONFIG_GENERIC_NVRAM=y
+CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER=y
+CONFIG_ARCH_MAY_HAVE_PC_FDC=y
+CONFIG_PPC_OF=y
+CONFIG_OF=y
+# CONFIG_PPC_UDBG_16550 is not set
+# CONFIG_GENERIC_TBSYNC is not set
+CONFIG_AUDIT_ARCH=y
+CONFIG_GENERIC_BUG=y
+# CONFIG_DEFAULT_UIMAGE is not set
+# CONFIG_PPC_DCR_NATIVE is not set
+# CONFIG_PPC_DCR_MMIO is not set
+CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
+
+#
+# General setup
+#
+CONFIG_EXPERIMENTAL=y
+CONFIG_BROKEN_ON_SMP=y
+CONFIG_LOCK_KERNEL=y
+CONFIG_INIT_ENV_ARG_LIMIT=32
+CONFIG_LOCALVERSION=""
+CONFIG_LOCALVERSION_AUTO=y
+CONFIG_SWAP=y
+CONFIG_SYSVIPC=y
+CONFIG_SYSVIPC_SYSCTL=y
+# CONFIG_POSIX_MQUEUE is not set
+# CONFIG_BSD_PROCESS_ACCT is not set
+# CONFIG_TASKSTATS is not set
+# CONFIG_USER_NS is not set
+# CONFIG_PID_NS is not set
+# CONFIG_AUDIT is not set
+# CONFIG_IKCONFIG is not set
+CONFIG_LOG_BUF_SHIFT=14
+# CONFIG_CGROUPS is not set
+CONFIG_FAIR_GROUP_SCHED=y
+CONFIG_FAIR_USER_SCHED=y
+# CONFIG_FAIR_CGROUP_SCHED is not set
+CONFIG_SYSFS_DEPRECATED=y
+# CONFIG_RELAY is not set
+# CONFIG_BLK_DEV_INITRD is not set
+CONFIG_CC_OPTIMIZE_FOR_SIZE=y
+CONFIG_SYSCTL=y
+# CONFIG_EMBEDDED is not set
+CONFIG_SYSCTL_SYSCALL=y
+CONFIG_KALLSYMS=y
+# CONFIG_KALLSYMS_ALL is not set
+# CONFIG_KALLSYMS_EXTRA_PASS is not set
+CONFIG_HOTPLUG=y
+CONFIG_PRINTK=y
+CONFIG_BUG=y
+CONFIG_ELF_CORE=y
+CONFIG_BASE_FULL=y
+CONFIG_FUTEX=y
+CONFIG_ANON_INODES=y
+CONFIG_EPOLL=y
+CONFIG_SIGNALFD=y
+CONFIG_EVENTFD=y
+CONFIG_SHMEM=y
+CONFIG_VM_EVENT_COUNTERS=y
+CONFIG_SLAB=y
+# CONFIG_SLUB is not set
+# CONFIG_SLOB is not set
+CONFIG_RT_MUTEXES=y
+# CONFIG_TINY_SHMEM is not set
+CONFIG_BASE_SMALL=0
+CONFIG_MODULES=y
+CONFIG_MODULE_UNLOAD=y
+# CONFIG_MODULE_FORCE_UNLOAD is not set
+# CONFIG_MODVERSIONS is not set
+# CONFIG_MODULE_SRCVERSION_ALL is not set
+# CONFIG_KMOD is not set
+CONFIG_BLOCK=y
+# CONFIG_LBD is not set
+# CONFIG_BLK_DEV_IO_TRACE is not set
+# CONFIG_LSF is not set
+# CONFIG_BLK_DEV_BSG is not set
+
+#
+# IO Schedulers
+#
+CONFIG_IOSCHED_NOOP=y
+# CONFIG_IOSCHED_AS is not set
+CONFIG_IOSCHED_DEADLINE=y
+# CONFIG_IOSCHED_CFQ is not set
+# CONFIG_DEFAULT_AS is not set
+CONFIG_DEFAULT_DEADLINE=y
+# CONFIG_DEFAULT_CFQ is not set
+# CONFIG_DEFAULT_NOOP is not set
+CONFIG_DEFAULT_IOSCHED="deadline"
+
+#
+# Platform support
+#
+# CONFIG_PPC_MPC52xx is not set
+# CONFIG_PPC_MPC5200 is not set
+# CONFIG_PPC_CELL is not set
+# CONFIG_PPC_CELL_NATIVE is not set
+CONFIG_CPM1=y
+# CONFIG_MPC8XXFADS is not set
+# CONFIG_MPC86XADS is not set
+# CONFIG_MPC885ADS is not set
+# CONFIG_PPC_EP88XC is not set
+CONFIG_DBOX2=y
+
+#
+# MPC8xx CPM Options
+#
+
+#
+# Generic MPC8xx Options
+#
+CONFIG_8xx_COPYBACK=y
+# CONFIG_8xx_CPU6 is not set
+CONFIG_8xx_CPU15=y
+CONFIG_NO_UCODE_PATCH=y
+# CONFIG_USB_SOF_UCODE_PATCH is not set
+# CONFIG_I2C_SPI_UCODE_PATCH is not set
+# CONFIG_I2C_SPI_SMC1_UCODE_PATCH is not set
+# CONFIG_PQ2ADS is not set
+# CONFIG_MPIC is not set
+# CONFIG_MPIC_WEIRD is not set
+# CONFIG_PPC_I8259 is not set
+# CONFIG_PPC_RTAS is not set
+# CONFIG_MMIO_NVRAM is not set
+# CONFIG_PPC_MPC106 is not set
+# CONFIG_PPC_970_NAP is not set
+# CONFIG_PPC_INDIRECT_IO is not set
+# CONFIG_GENERIC_IOMAP is not set
+# CONFIG_CPU_FREQ is not set
+# CONFIG_CPM2 is not set
+CONFIG_PPC_CPM_NEW_BINDING=y
+# CONFIG_FSL_ULI1575 is not set
+CONFIG_CPM=y
+
+#
+# Kernel options
+#
+# CONFIG_HIGHMEM is not set
+# CONFIG_TICK_ONESHOT is not set
+# CONFIG_NO_HZ is not set
+# CONFIG_HIGH_RES_TIMERS is not set
+CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
+CONFIG_HZ_100=y
+# CONFIG_HZ_250 is not set
+# CONFIG_HZ_300 is not set
+# CONFIG_HZ_1000 is not set
+CONFIG_HZ=100
+# CONFIG_PREEMPT_NONE is not set
+# CONFIG_PREEMPT_VOLUNTARY is not set
+CONFIG_PREEMPT=y
+CONFIG_PREEMPT_BKL=y
+CONFIG_BINFMT_ELF=y
+# CONFIG_BINFMT_MISC is not set
+# CONFIG_MATH_EMULATION is not set
+CONFIG_8XX_MINIMAL_FPEMU=y
+CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
+CONFIG_ARCH_FLATMEM_ENABLE=y
+CONFIG_ARCH_POPULATES_NODE_MAP=y
+CONFIG_SELECT_MEMORY_MODEL=y
+CONFIG_FLATMEM_MANUAL=y
+# CONFIG_DISCONTIGMEM_MANUAL is not set
+# CONFIG_SPARSEMEM_MANUAL is not set
+CONFIG_FLATMEM=y
+CONFIG_FLAT_NODE_MEM_MAP=y
+# CONFIG_SPARSEMEM_STATIC is not set
+# CONFIG_SPARSEMEM_VMEMMAP_ENABLE is not set
+CONFIG_SPLIT_PTLOCK_CPUS=4
+# CONFIG_RESOURCES_64BIT is not set
+CONFIG_ZONE_DMA_FLAG=1
+CONFIG_BOUNCE=y
+CONFIG_VIRT_TO_BUS=y
+CONFIG_PROC_DEVICETREE=y
+# CONFIG_CMDLINE_BOOL is not set
+# CONFIG_PM is not set
+CONFIG_SUSPEND_UP_POSSIBLE=y
+CONFIG_HIBERNATION_UP_POSSIBLE=y
+# CONFIG_SECCOMP is not set
+CONFIG_WANT_DEVICE_TREE=y
+CONFIG_DEVICE_TREE="dbox2.dts"
+CONFIG_ISA_DMA_API=y
+
+#
+# Bus options
+#
+CONFIG_ZONE_DMA=y
+CONFIG_FSL_SOC=y
+# CONFIG_PCI is not set
+# CONFIG_PCI_DOMAINS is not set
+# CONFIG_PCI_SYSCALL is not set
+# CONFIG_PCI_QSPAN is not set
+# CONFIG_ARCH_SUPPORTS_MSI is not set
+# CONFIG_PCCARD is not set
+
+#
+# Advanced setup
+#
+CONFIG_ADVANCED_OPTIONS=y
+CONFIG_HIGHMEM_START=0xfe000000
+# CONFIG_LOWMEM_SIZE_BOOL is not set
+CONFIG_LOWMEM_SIZE=0x30000000
+# CONFIG_KERNEL_START_BOOL is not set
+CONFIG_KERNEL_START=0xc0000000
+# CONFIG_TASK_SIZE_BOOL is not set
+CONFIG_TASK_SIZE=0x80000000
+CONFIG_CONSISTENT_START_BOOL=y
+CONFIG_CONSISTENT_START=0xe0000000
+# CONFIG_CONSISTENT_SIZE_BOOL is not set
+CONFIG_CONSISTENT_SIZE=0x00200000
+# CONFIG_BOOT_LOAD_BOOL is not set
+CONFIG_BOOT_LOAD=0x00400000
+# CONFIG_PIN_TLB is not set
+
+#
+# Networking
+#
+CONFIG_NET=y
+
+#
+# Networking options
+#
+CONFIG_PACKET=y
+CONFIG_PACKET_MMAP=y
+CONFIG_UNIX=y
+# CONFIG_NET_KEY is not set
+CONFIG_INET=y
+CONFIG_IP_MULTICAST=y
+# CONFIG_IP_ADVANCED_ROUTER is not set
+CONFIG_IP_FIB_HASH=y
+CONFIG_IP_PNP=y
+CONFIG_IP_PNP_DHCP=y
+# CONFIG_IP_PNP_BOOTP is not set
+# CONFIG_IP_PNP_RARP is not set
+# CONFIG_NET_IPIP is not set
+# CONFIG_NET_IPGRE is not set
+CONFIG_IP_MROUTE=y
+# CONFIG_IP_PIMSM_V1 is not set
+# CONFIG_IP_PIMSM_V2 is not set
+# CONFIG_ARPD is not set
+# CONFIG_SYN_COOKIES is not set
+# CONFIG_INET_AH is not set
+# CONFIG_INET_ESP is not set
+# CONFIG_INET_IPCOMP is not set
+# CONFIG_INET_XFRM_TUNNEL is not set
+# CONFIG_INET_TUNNEL is not set
+# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
+# CONFIG_INET_XFRM_MODE_TUNNEL is not set
+# CONFIG_INET_XFRM_MODE_BEET is not set
+# CONFIG_INET_LRO is not set
+# CONFIG_INET_DIAG is not set
+# CONFIG_TCP_CONG_ADVANCED is not set
+CONFIG_TCP_CONG_CUBIC=y
+CONFIG_DEFAULT_TCP_CONG="cubic"
+# CONFIG_TCP_MD5SIG is not set
+# CONFIG_IPV6 is not set
+# CONFIG_INET6_XFRM_TUNNEL is not set
+# CONFIG_INET6_TUNNEL is not set
+# CONFIG_NETWORK_SECMARK is not set
+# CONFIG_NETFILTER is not set
+# CONFIG_IP_DCCP is not set
+# CONFIG_IP_SCTP is not set
+# CONFIG_TIPC is not set
+# CONFIG_ATM is not set
+# CONFIG_BRIDGE is not set
+# CONFIG_VLAN_8021Q is not set
+# CONFIG_DECNET is not set
+# CONFIG_LLC2 is not set
+# CONFIG_IPX is not set
+# CONFIG_ATALK is not set
+# CONFIG_X25 is not set
+# CONFIG_LAPB is not set
+# CONFIG_ECONET is not set
+# CONFIG_WAN_ROUTER is not set
+# CONFIG_NET_SCHED is not set
+
+#
+# Network testing
+#
+# CONFIG_NET_PKTGEN is not set
+# CONFIG_HAMRADIO is not set
+# CONFIG_IRDA is not set
+# CONFIG_BT is not set
+# CONFIG_AF_RXRPC is not set
+
+#
+# Wireless
+#
+# CONFIG_CFG80211 is not set
+# CONFIG_WIRELESS_EXT is not set
+# CONFIG_MAC80211 is not set
+# CONFIG_IEEE80211 is not set
+# CONFIG_RFKILL is not set
+# CONFIG_NET_9P is not set
+
+#
+# Device Drivers
+#
+
+#
+# Generic Driver Options
+#
+CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
+CONFIG_STANDALONE=y
+CONFIG_PREVENT_FIRMWARE_BUILD=y
+CONFIG_FW_LOADER=y
+# CONFIG_DEBUG_DRIVER is not set
+# CONFIG_DEBUG_DEVRES is not set
+# CONFIG_SYS_HYPERVISOR is not set
+# CONFIG_CONNECTOR is not set
+CONFIG_MTD=y
+# CONFIG_MTD_DEBUG is not set
+# CONFIG_MTD_CONCAT is not set
+CONFIG_MTD_PARTITIONS=y
+# CONFIG_MTD_REDBOOT_PARTS is not set
+# CONFIG_MTD_CMDLINE_PARTS is not set
+
+#
+# User Modules And Translation Layers
+#
+CONFIG_MTD_CHAR=y
+CONFIG_MTD_BLKDEVS=y
+# CONFIG_MTD_BLOCK is not set
+CONFIG_MTD_BLOCK_RO=y
+# CONFIG_FTL is not set
+# CONFIG_NFTL is not set
+# CONFIG_INFTL is not set
+# CONFIG_RFD_FTL is not set
+# CONFIG_SSFDC is not set
+# CONFIG_MTD_OOPS is not set
+
+#
+# RAM/ROM/Flash chip drivers
+#
+CONFIG_MTD_CFI=y
+# CONFIG_MTD_JEDECPROBE is not set
+CONFIG_MTD_GEN_PROBE=y
+# CONFIG_MTD_CFI_ADV_OPTIONS is not set
+CONFIG_MTD_MAP_BANK_WIDTH_1=y
+CONFIG_MTD_MAP_BANK_WIDTH_2=y
+CONFIG_MTD_MAP_BANK_WIDTH_4=y
+# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
+# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
+# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
+CONFIG_MTD_CFI_I1=y
+CONFIG_MTD_CFI_I2=y
+# CONFIG_MTD_CFI_I4 is not set
+# CONFIG_MTD_CFI_I8 is not set
+CONFIG_MTD_CFI_INTELEXT=y
+CONFIG_MTD_CFI_AMDSTD=y
+# CONFIG_MTD_CFI_STAA is not set
+CONFIG_MTD_CFI_UTIL=y
+# CONFIG_MTD_RAM is not set
+# CONFIG_MTD_ROM is not set
+# CONFIG_MTD_ABSENT is not set
+
+#
+# Mapping drivers for chip access
+#
+# CONFIG_MTD_COMPLEX_MAPPINGS is not set
+# CONFIG_MTD_PHYSMAP is not set
+CONFIG_MTD_PHYSMAP_OF=y
+# CONFIG_MTD_CFI_FLAGADM is not set
+# CONFIG_MTD_PLATRAM is not set
+
+#
+# Self-contained MTD device drivers
+#
+# CONFIG_MTD_SLRAM is not set
+# CONFIG_MTD_PHRAM is not set
+# CONFIG_MTD_MTDRAM is not set
+# CONFIG_MTD_BLOCK2MTD is not set
+
+#
+# Disk-On-Chip Device Drivers
+#
+# CONFIG_MTD_DOC2000 is not set
+# CONFIG_MTD_DOC2001 is not set
+# CONFIG_MTD_DOC2001PLUS is not set
+# CONFIG_MTD_NAND is not set
+# CONFIG_MTD_ONENAND is not set
+
+#
+# UBI - Unsorted block images
+#
+# CONFIG_MTD_UBI is not set
+CONFIG_OF_DEVICE=y
+# CONFIG_PARPORT is not set
+# CONFIG_BLK_DEV is not set
+CONFIG_MISC_DEVICES=y
+# CONFIG_EEPROM_93CX6 is not set
+# CONFIG_IDE is not set
+
+#
+# SCSI device support
+#
+# CONFIG_RAID_ATTRS is not set
+# CONFIG_SCSI is not set
+# CONFIG_SCSI_DMA is not set
+# CONFIG_SCSI_NETLINK is not set
+# CONFIG_ATA is not set
+# CONFIG_MD is not set
+# CONFIG_MACINTOSH_DRIVERS is not set
+CONFIG_NETDEVICES=y
+# CONFIG_NETDEVICES_MULTIQUEUE is not set
+# CONFIG_DUMMY is not set
+# CONFIG_BONDING is not set
+# CONFIG_MACVLAN is not set
+# CONFIG_EQUALIZER is not set
+# CONFIG_TUN is not set
+# CONFIG_VETH is not set
+CONFIG_PHYLIB=y
+
+#
+# MII PHY device drivers
+#
+# CONFIG_MARVELL_PHY is not set
+# CONFIG_DAVICOM_PHY is not set
+# CONFIG_QSEMI_PHY is not set
+# CONFIG_LXT_PHY is not set
+# CONFIG_CICADA_PHY is not set
+# CONFIG_VITESSE_PHY is not set
+# CONFIG_SMSC_PHY is not set
+# CONFIG_BROADCOM_PHY is not set
+# CONFIG_ICPLUS_PHY is not set
+CONFIG_FIXED_PHY=y
+CONFIG_FIXED_MII_10_FDX=y
+# CONFIG_FIXED_MII_100_FDX is not set
+# CONFIG_FIXED_MII_1000_FDX is not set
+CONFIG_FIXED_MII_AMNT=1
+# CONFIG_MDIO_BITBANG is not set
+CONFIG_NET_ETHERNET=y
+CONFIG_MII=y
+# CONFIG_IBM_NEW_EMAC_ZMII is not set
+# CONFIG_IBM_NEW_EMAC_RGMII is not set
+# CONFIG_IBM_NEW_EMAC_TAH is not set
+# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
+# CONFIG_B44 is not set
+CONFIG_FS_ENET=y
+CONFIG_FS_ENET_HAS_SCC=y
+# CONFIG_FS_ENET_HAS_FEC is not set
+# CONFIG_FS_ENET_MDIO_FEC is not set
+# CONFIG_NETDEV_1000 is not set
+# CONFIG_NETDEV_10000 is not set
+
+#
+# Wireless LAN
+#
+# CONFIG_WLAN_PRE80211 is not set
+# CONFIG_WLAN_80211 is not set
+# CONFIG_WAN is not set
+# CONFIG_PPP is not set
+# CONFIG_SLIP is not set
+# CONFIG_SHAPER is not set
+# CONFIG_NETCONSOLE is not set
+# CONFIG_NETPOLL is not set
+# CONFIG_NET_POLL_CONTROLLER is not set
+# CONFIG_ISDN is not set
+# CONFIG_PHONE is not set
+
+#
+# Input device support
+#
+CONFIG_INPUT=y
+# CONFIG_INPUT_FF_MEMLESS is not set
+# CONFIG_INPUT_POLLDEV is not set
+
+#
+# Userland interfaces
+#
+CONFIG_INPUT_MOUSEDEV=y
+# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
+CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
+CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
+# CONFIG_INPUT_JOYDEV is not set
+CONFIG_INPUT_EVDEV=y
+# CONFIG_INPUT_EVBUG is not set
+
+#
+# Input Device Drivers
+#
+# CONFIG_INPUT_KEYBOARD is not set
+# CONFIG_INPUT_MOUSE is not set
+# CONFIG_INPUT_JOYSTICK is not set
+# CONFIG_INPUT_TABLET is not set
+# CONFIG_INPUT_TOUCHSCREEN is not set
+# CONFIG_INPUT_MISC is not set
+
+#
+# Hardware I/O ports
+#
+# CONFIG_SERIO is not set
+# CONFIG_GAMEPORT is not set
+
+#
+# Character devices
+#
+CONFIG_VT=y
+CONFIG_VT_CONSOLE=y
+CONFIG_HW_CONSOLE=y
+# CONFIG_VT_HW_CONSOLE_BINDING is not set
+# CONFIG_SERIAL_NONSTANDARD is not set
+
+#
+# Serial drivers
+#
+# CONFIG_SERIAL_8250 is not set
+
+#
+# Non-8250 serial port support
+#
+# CONFIG_SERIAL_UARTLITE is not set
+CONFIG_SERIAL_CORE=y
+CONFIG_SERIAL_CORE_CONSOLE=y
+CONFIG_SERIAL_CPM=y
+CONFIG_SERIAL_CPM_CONSOLE=y
+# CONFIG_SERIAL_CPM_SCC1 is not set
+# CONFIG_SERIAL_CPM_SCC2 is not set
+# CONFIG_SERIAL_CPM_SCC3 is not set
+# CONFIG_SERIAL_CPM_SCC4 is not set
+CONFIG_SERIAL_CPM_SMC1=y
+CONFIG_SERIAL_CPM_SMC2=y
+CONFIG_UNIX98_PTYS=y
+# CONFIG_LEGACY_PTYS is not set
+# CONFIG_IPMI_HANDLER is not set
+# CONFIG_HW_RANDOM is not set
+# CONFIG_NVRAM is not set
+# CONFIG_GEN_RTC is not set
+# CONFIG_R3964 is not set
+# CONFIG_RAW_DRIVER is not set
+# CONFIG_TCG_TPM is not set
+CONFIG_I2C=y
+CONFIG_I2C_BOARDINFO=y
+CONFIG_I2C_CHARDEV=m
+
+#
+# I2C Algorithms
+#
+# CONFIG_I2C_ALGOBIT is not set
+# CONFIG_I2C_ALGOPCF is not set
+# CONFIG_I2C_ALGOPCA is not set
+
+#
+# I2C Hardware Bus support
+#
+# CONFIG_I2C_MPC is not set
+# CONFIG_I2C_OCORES is not set
+# CONFIG_I2C_PARPORT_LIGHT is not set
+# CONFIG_I2C_SIMTEC is not set
+# CONFIG_I2C_TAOS_EVM is not set
+# CONFIG_I2C_STUB is not set
+
+#
+# Miscellaneous I2C Chip support
+#
+# CONFIG_SENSORS_DS1337 is not set
+# CONFIG_SENSORS_DS1374 is not set
+# CONFIG_DS1682 is not set
+# CONFIG_SENSORS_EEPROM is not set
+# CONFIG_SENSORS_PCF8574 is not set
+# CONFIG_SENSORS_PCA9539 is not set
+# CONFIG_SENSORS_PCF8591 is not set
+# CONFIG_SENSORS_M41T00 is not set
+# CONFIG_SENSORS_MAX6875 is not set
+# CONFIG_SENSORS_TSL2550 is not set
+# CONFIG_I2C_DEBUG_CORE is not set
+# CONFIG_I2C_DEBUG_ALGO is not set
+# CONFIG_I2C_DEBUG_BUS is not set
+# CONFIG_I2C_DEBUG_CHIP is not set
+
+#
+# SPI support
+#
+# CONFIG_SPI is not set
+# CONFIG_SPI_MASTER is not set
+# CONFIG_W1 is not set
+# CONFIG_POWER_SUPPLY is not set
+# CONFIG_HWMON is not set
+CONFIG_WATCHDOG=y
+# CONFIG_WATCHDOG_NOWAYOUT is not set
+
+#
+# Watchdog Device Drivers
+#
+# CONFIG_SOFT_WATCHDOG is not set
+# CONFIG_8xx_WDT is not set
+
+#
+# Sonics Silicon Backplane
+#
+CONFIG_SSB_POSSIBLE=y
+# CONFIG_SSB is not set
+
+#
+# Multifunction device drivers
+#
+# CONFIG_MFD_SM501 is not set
+
+#
+# Multimedia devices
+#
+CONFIG_VIDEO_DEV=y
+CONFIG_VIDEO_V4L1=y
+CONFIG_VIDEO_V4L1_COMPAT=y
+CONFIG_VIDEO_V4L2=y
+CONFIG_VIDEO_CAPTURE_DRIVERS=y
+# CONFIG_VIDEO_ADV_DEBUG is not set
+CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
+# CONFIG_VIDEO_VIVI is not set
+# CONFIG_VIDEO_CPIA is not set
+# CONFIG_VIDEO_SAA5246A is not set
+# CONFIG_VIDEO_SAA5249 is not set
+# CONFIG_TUNER_3036 is not set
+# CONFIG_RADIO_ADAPTERS is not set
+CONFIG_DVB_CORE=m
+CONFIG_DVB_CORE_ATTACH=y
+CONFIG_DVB_CAPTURE_DRIVERS=y
+# CONFIG_DVB_B2C2_FLEXCOP is not set
+
+#
+# Supported DVB Frontends
+#
+
+#
+# Customise DVB Frontends
+#
+# CONFIG_DVB_FE_CUSTOMISE is not set
+
+#
+# DVB-S (satellite) frontends
+#
+# CONFIG_DVB_STV0299 is not set
+# CONFIG_DVB_CX24110 is not set
+# CONFIG_DVB_CX24123 is not set
+# CONFIG_DVB_TDA8083 is not set
+# CONFIG_DVB_MT312 is not set
+CONFIG_DVB_VES1X93=m
+# CONFIG_DVB_S5H1420 is not set
+# CONFIG_DVB_TDA10086 is not set
+
+#
+# DVB-T (terrestrial) frontends
+#
+# CONFIG_DVB_SP8870 is not set
+# CONFIG_DVB_SP887X is not set
+# CONFIG_DVB_CX22700 is not set
+# CONFIG_DVB_CX22702 is not set
+# CONFIG_DVB_L64781 is not set
+# CONFIG_DVB_TDA1004X is not set
+# CONFIG_DVB_NXT6000 is not set
+# CONFIG_DVB_MT352 is not set
+# CONFIG_DVB_ZL10353 is not set
+# CONFIG_DVB_DIB3000MB is not set
+# CONFIG_DVB_DIB3000MC is not set
+# CONFIG_DVB_DIB7000M is not set
+# CONFIG_DVB_DIB7000P is not set
+
+#
+# DVB-C (cable) frontends
+#
+CONFIG_DVB_VES1820=m
+# CONFIG_DVB_TDA10021 is not set
+# CONFIG_DVB_TDA10023 is not set
+CONFIG_DVB_STV0297=m
+
+#
+# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
+#
+# CONFIG_DVB_NXT200X is not set
+# CONFIG_DVB_OR51211 is not set
+# CONFIG_DVB_OR51132 is not set
+# CONFIG_DVB_BCM3510 is not set
+# CONFIG_DVB_LGDT330X is not set
+# CONFIG_DVB_S5H1409 is not set
+
+#
+# Tuners/PLL support
+#
+# CONFIG_DVB_PLL is not set
+# CONFIG_DVB_TDA826X is not set
+# CONFIG_DVB_TDA827X is not set
+# CONFIG_DVB_TUNER_QT1010 is not set
+# CONFIG_DVB_TUNER_MT2060 is not set
+# CONFIG_DVB_TUNER_MT2266 is not set
+# CONFIG_DVB_TUNER_MT2131 is not set
+# CONFIG_DVB_TUNER_DIB0070 is not set
+
+#
+# Miscellaneous devices
+#
+# CONFIG_DVB_LNBP21 is not set
+# CONFIG_DVB_ISL6421 is not set
+# CONFIG_DVB_TUA6100 is not set
+# CONFIG_DAB is not set
+
+#
+# Graphics support
+#
+# CONFIG_VGASTATE is not set
+CONFIG_VIDEO_OUTPUT_CONTROL=m
+CONFIG_FB=y
+# CONFIG_FIRMWARE_EDID is not set
+# CONFIG_FB_DDC is not set
+# CONFIG_FB_CFB_FILLRECT is not set
+# CONFIG_FB_CFB_COPYAREA is not set
+# CONFIG_FB_CFB_IMAGEBLIT is not set
+# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
+# CONFIG_FB_SYS_FILLRECT is not set
+# CONFIG_FB_SYS_COPYAREA is not set
+# CONFIG_FB_SYS_IMAGEBLIT is not set
+# CONFIG_FB_SYS_FOPS is not set
+CONFIG_FB_DEFERRED_IO=y
+# CONFIG_FB_SVGALIB is not set
+# CONFIG_FB_MACMODES is not set
+# CONFIG_FB_BACKLIGHT is not set
+# CONFIG_FB_MODE_HELPERS is not set
+# CONFIG_FB_TILEBLITTING is not set
+
+#
+# Frame buffer hardware drivers
+#
+# CONFIG_FB_OF is not set
+# CONFIG_FB_VGA16 is not set
+# CONFIG_FB_S1D13XXX is not set
+# CONFIG_FB_IBM_GXT4500 is not set
+# CONFIG_FB_VIRTUAL is not set
+# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
+
+#
+# Display device support
+#
+# CONFIG_DISPLAY_SUPPORT is not set
+
+#
+# Console display driver support
+#
+CONFIG_DUMMY_CONSOLE=y
+CONFIG_FRAMEBUFFER_CONSOLE=y
+# CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
+# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
+CONFIG_FONTS=y
+# CONFIG_FONT_8x8 is not set
+CONFIG_FONT_8x16=y
+# CONFIG_FONT_6x11 is not set
+# CONFIG_FONT_7x14 is not set
+# CONFIG_FONT_PEARL_8x8 is not set
+# CONFIG_FONT_ACORN_8x8 is not set
+# CONFIG_FONT_MINI_4x6 is not set
+# CONFIG_FONT_SUN8x16 is not set
+# CONFIG_FONT_SUN12x22 is not set
+# CONFIG_FONT_10x18 is not set
+# CONFIG_LOGO is not set
+
+#
+# Sound
+#
+CONFIG_SOUND=y
+
+#
+# Advanced Linux Sound Architecture
+#
+# CONFIG_SND is not set
+
+#
+# Open Sound System
+#
+# CONFIG_SOUND_PRIME is not set
+CONFIG_HID_SUPPORT=y
+CONFIG_HID=y
+# CONFIG_HID_DEBUG is not set
+# CONFIG_HIDRAW is not set
+# CONFIG_USB_SUPPORT is not set
+# CONFIG_MMC is not set
+# CONFIG_NEW_LEDS is not set
+# CONFIG_EDAC is not set
+# CONFIG_RTC_CLASS is not set
+
+#
+# Userspace I/O
+#
+# CONFIG_UIO is not set
+
+#
+# File systems
+#
+# CONFIG_EXT2_FS is not set
+# CONFIG_EXT3_FS is not set
+# CONFIG_EXT4DEV_FS is not set
+# CONFIG_REISERFS_FS is not set
+# CONFIG_JFS_FS is not set
+# CONFIG_FS_POSIX_ACL is not set
+# CONFIG_XFS_FS is not set
+# CONFIG_GFS2_FS is not set
+# CONFIG_OCFS2_FS is not set
+# CONFIG_MINIX_FS is not set
+# CONFIG_ROMFS_FS is not set
+# CONFIG_INOTIFY is not set
+# CONFIG_QUOTA is not set
+CONFIG_DNOTIFY=y
+# CONFIG_AUTOFS_FS is not set
+# CONFIG_AUTOFS4_FS is not set
+# CONFIG_FUSE_FS is not set
+
+#
+# CD-ROM/DVD Filesystems
+#
+# CONFIG_ISO9660_FS is not set
+# CONFIG_UDF_FS is not set
+
+#
+# DOS/FAT/NT Filesystems
+#
+CONFIG_FAT_FS=y
+CONFIG_MSDOS_FS=y
+CONFIG_VFAT_FS=y
+CONFIG_FAT_DEFAULT_CODEPAGE=437
+CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
+# CONFIG_NTFS_FS is not set
+
+#
+# Pseudo filesystems
+#
+CONFIG_PROC_FS=y
+CONFIG_PROC_KCORE=y
+CONFIG_PROC_SYSCTL=y
+CONFIG_SYSFS=y
+CONFIG_TMPFS=y
+# CONFIG_TMPFS_POSIX_ACL is not set
+# CONFIG_HUGETLB_PAGE is not set
+# CONFIG_CONFIGFS_FS is not set
+
+#
+# Miscellaneous filesystems
+#
+# CONFIG_ADFS_FS is not set
+# CONFIG_AFFS_FS is not set
+# CONFIG_HFS_FS is not set
+# CONFIG_HFSPLUS_FS is not set
+# CONFIG_BEFS_FS is not set
+# CONFIG_BFS_FS is not set
+# CONFIG_EFS_FS is not set
+CONFIG_JFFS2_FS=y
+CONFIG_JFFS2_FS_DEBUG=0
+CONFIG_JFFS2_FS_WRITEBUFFER=y
+# CONFIG_JFFS2_FS_WBUF_VERIFY is not set
+# CONFIG_JFFS2_SUMMARY is not set
+# CONFIG_JFFS2_FS_XATTR is not set
+# CONFIG_JFFS2_COMPRESSION_OPTIONS is not set
+CONFIG_JFFS2_ZLIB=y
+# CONFIG_JFFS2_LZO is not set
+CONFIG_JFFS2_RTIME=y
+# CONFIG_JFFS2_RUBIN is not set
+# CONFIG_CRAMFS is not set
+# CONFIG_VXFS_FS is not set
+# CONFIG_HPFS_FS is not set
+# CONFIG_QNX4FS_FS is not set
+# CONFIG_SYSV_FS is not set
+# CONFIG_UFS_FS is not set
+CONFIG_NETWORK_FILESYSTEMS=y
+CONFIG_NFS_FS=y
+CONFIG_NFS_V3=y
+# CONFIG_NFS_V3_ACL is not set
+# CONFIG_NFS_V4 is not set
+# CONFIG_NFS_DIRECTIO is not set
+# CONFIG_NFSD is not set
+CONFIG_ROOT_NFS=y
+CONFIG_LOCKD=y
+CONFIG_LOCKD_V4=y
+CONFIG_NFS_COMMON=y
+CONFIG_SUNRPC=y
+# CONFIG_SUNRPC_BIND34 is not set
+# CONFIG_RPCSEC_GSS_KRB5 is not set
+# CONFIG_RPCSEC_GSS_SPKM3 is not set
+# CONFIG_SMB_FS is not set
+# CONFIG_CIFS is not set
+# CONFIG_NCP_FS is not set
+# CONFIG_CODA_FS is not set
+# CONFIG_AFS_FS is not set
+
+#
+# Partition Types
+#
+# CONFIG_PARTITION_ADVANCED is not set
+CONFIG_MSDOS_PARTITION=y
+CONFIG_NLS=y
+CONFIG_NLS_DEFAULT="iso8859-1"
+CONFIG_NLS_CODEPAGE_437=y
+# CONFIG_NLS_CODEPAGE_737 is not set
+# CONFIG_NLS_CODEPAGE_775 is not set
+CONFIG_NLS_CODEPAGE_850=y
+# CONFIG_NLS_CODEPAGE_852 is not set
+# CONFIG_NLS_CODEPAGE_855 is not set
+# CONFIG_NLS_CODEPAGE_857 is not set
+# CONFIG_NLS_CODEPAGE_860 is not set
+# CONFIG_NLS_CODEPAGE_861 is not set
+# CONFIG_NLS_CODEPAGE_862 is not set
+# CONFIG_NLS_CODEPAGE_863 is not set
+# CONFIG_NLS_CODEPAGE_864 is not set
+# CONFIG_NLS_CODEPAGE_865 is not set
+# CONFIG_NLS_CODEPAGE_866 is not set
+# CONFIG_NLS_CODEPAGE_869 is not set
+# CONFIG_NLS_CODEPAGE_936 is not set
+# CONFIG_NLS_CODEPAGE_950 is not set
+# CONFIG_NLS_CODEPAGE_932 is not set
+# CONFIG_NLS_CODEPAGE_949 is not set
+# CONFIG_NLS_CODEPAGE_874 is not set
+# CONFIG_NLS_ISO8859_8 is not set
+# CONFIG_NLS_CODEPAGE_1250 is not set
+# CONFIG_NLS_CODEPAGE_1251 is not set
+# CONFIG_NLS_ASCII is not set
+CONFIG_NLS_ISO8859_1=y
+# CONFIG_NLS_ISO8859_2 is not set
+# CONFIG_NLS_ISO8859_3 is not set
+# CONFIG_NLS_ISO8859_4 is not set
+# CONFIG_NLS_ISO8859_5 is not set
+# CONFIG_NLS_ISO8859_6 is not set
+# CONFIG_NLS_ISO8859_7 is not set
+# CONFIG_NLS_ISO8859_9 is not set
+# CONFIG_NLS_ISO8859_13 is not set
+# CONFIG_NLS_ISO8859_14 is not set
+CONFIG_NLS_ISO8859_15=y
+# CONFIG_NLS_KOI8_R is not set
+# CONFIG_NLS_KOI8_U is not set
+CONFIG_NLS_UTF8=y
+# CONFIG_DLM is not set
+# CONFIG_UCC_SLOW is not set
+
+#
+# Library routines
+#
+CONFIG_BITREVERSE=y
+# CONFIG_CRC_CCITT is not set
+# CONFIG_CRC16 is not set
+# CONFIG_CRC_ITU_T is not set
+CONFIG_CRC32=y
+# CONFIG_CRC7 is not set
+# CONFIG_LIBCRC32C is not set
+CONFIG_ZLIB_INFLATE=y
+CONFIG_ZLIB_DEFLATE=y
+CONFIG_PLIST=y
+CONFIG_HAS_IOMEM=y
+CONFIG_HAS_IOPORT=y
+CONFIG_HAS_DMA=y
+CONFIG_INSTRUMENTATION=y
+# CONFIG_PROFILING is not set
+# CONFIG_KPROBES is not set
+# CONFIG_MARKERS is not set
+
+#
+# Kernel hacking
+#
+# CONFIG_PRINTK_TIME is not set
+CONFIG_ENABLE_WARN_DEPRECATED=y
+CONFIG_ENABLE_MUST_CHECK=y
+# CONFIG_MAGIC_SYSRQ is not set
+# CONFIG_UNUSED_SYMBOLS is not set
+# CONFIG_DEBUG_FS is not set
+# CONFIG_HEADERS_CHECK is not set
+CONFIG_DEBUG_KERNEL=y
+# CONFIG_DEBUG_SHIRQ is not set
+# CONFIG_DETECT_SOFTLOCKUP is not set
+# CONFIG_SCHED_DEBUG is not set
+# CONFIG_SCHEDSTATS is not set
+# CONFIG_TIMER_STATS is not set
+# CONFIG_DEBUG_SLAB is not set
+# CONFIG_DEBUG_RT_MUTEXES is not set
+# CONFIG_RT_MUTEX_TESTER is not set
+# CONFIG_DEBUG_SPINLOCK is not set
+# CONFIG_DEBUG_MUTEXES is not set
+# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
+# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
+# CONFIG_DEBUG_KOBJECT is not set
+CONFIG_DEBUG_BUGVERBOSE=y
+CONFIG_DEBUG_INFO=y
+# CONFIG_DEBUG_VM is not set
+# CONFIG_DEBUG_LIST is not set
+# CONFIG_DEBUG_SG is not set
+# CONFIG_FORCED_INLINING is not set
+# CONFIG_BOOT_PRINTK_DELAY is not set
+# CONFIG_RCU_TORTURE_TEST is not set
+# CONFIG_FAULT_INJECTION is not set
+# CONFIG_SAMPLES is not set
+# CONFIG_DEBUG_STACKOVERFLOW is not set
+# CONFIG_DEBUG_STACK_USAGE is not set
+# CONFIG_DEBUG_PAGEALLOC is not set
+# CONFIG_DEBUGGER is not set
+# CONFIG_BDI_SWITCH is not set
+# CONFIG_PPC_EARLY_DEBUG is not set
+
+#
+# Security options
+#
+# CONFIG_KEYS is not set
+# CONFIG_SECURITY is not set
+# CONFIG_SECURITY_FILE_CAPABILITIES is not set
+# CONFIG_CRYPTO is not set
+# CONFIG_PPC_CLOCK is not set
+CONFIG_PPC_LIB_RHEAP=y
diff --git a/arch/powerpc/platforms/8xx/Kconfig b/arch/powerpc/platforms/8xx/Kconfig
index bd28655..bcd3c40 100644
--- a/arch/powerpc/platforms/8xx/Kconfig
+++ b/arch/powerpc/platforms/8xx/Kconfig
@@ -43,6 +43,13 @@ config PPC_EP88XC
 	  This board is also resold by Freescale as the QUICCStart
 	  MPC885 Evaluation System and/or the CWH-PPC-885XN-VE.
 
+config DBOX2
+	bool "DBOX2"
+	select CPM1
+	select PPC_CPM_NEW_BINDING
+	help
+	  This enables support for the Betaresearch DBOX2.
+
 endchoice
 
 menu "Freescale Ethernet driver platform-specific options"
diff --git a/arch/powerpc/platforms/8xx/Makefile b/arch/powerpc/platforms/8xx/Makefile
index 8b70980..306df8a 100644
--- a/arch/powerpc/platforms/8xx/Makefile
+++ b/arch/powerpc/platforms/8xx/Makefile
@@ -5,3 +5,4 @@ obj-$(CONFIG_PPC_8xx)	  += m8xx_setup.o
 obj-$(CONFIG_MPC885ADS)   += mpc885ads_setup.o
 obj-$(CONFIG_MPC86XADS)   += mpc86xads_setup.o
 obj-$(CONFIG_PPC_EP88XC)  += ep88xc.o
+obj-$(CONFIG_DBOX2)       += dbox2_setup.o
diff --git a/arch/powerpc/platforms/8xx/dbox2_setup.c b/arch/powerpc/platforms/8xx/dbox2_setup.c
new file mode 100644
index 0000000..dfea4cb
--- /dev/null
+++ b/arch/powerpc/platforms/8xx/dbox2_setup.c
@@ -0,0 +1,173 @@
+/*
+ * Platform setup for the DBox2
+ *
+ * Copyright 2007 Jochen Friedrich <jochen@scram.de>
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2. This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/param.h>
+#include <linux/string.h>
+#include <linux/ioport.h>
+#include <linux/device.h>
+#include <linux/delay.h>
+
+#include <linux/fs_enet_pd.h>
+#include <linux/fs_uart_pd.h>
+#include <linux/fsl_devices.h>
+#include <linux/mii.h>
+#include <linux/of_platform.h>
+
+#include <asm/delay.h>
+#include <asm/io.h>
+#include <asm/machdep.h>
+#include <asm/page.h>
+#include <asm/processor.h>
+#include <asm/system.h>
+#include <asm/time.h>
+#include <asm/mpc8xx.h>
+#include <asm/8xx_immap.h>
+#include <asm/commproc.h>
+#include <asm/fs_pd.h>
+#include <asm/udbg.h>
+#include <asm/prom.h>
+
+#include <sysdev/commproc.h>
+#if defined(CONFIG_PQ_WDT) || defined(CONFIG_PQ_WDT_MODULE)
+#include <sysdev/pq_wdt.h>
+#endif
+
+struct cpm_pin {
+	int port, pin, flags;
+};
+
+static const struct cpm_pin dbox2_pins[] = {
+	/* SMC1 (Serial 1) */
+	{CPM_PORTB, 24, CPM_PIN_INPUT}, /* RXD */
+	{CPM_PORTB, 25, CPM_PIN_INPUT}, /* TXD */
+	{CPM_PORTC,  5, CPM_PIN_INPUT | CPM_PIN_GPIO}, /* DCD */
+	{CPM_PORTC,  6, CPM_PIN_INPUT | CPM_PIN_GPIO}, /* DSR */
+	{CPM_PORTC,  7, CPM_PIN_OUTPUT | CPM_PIN_GPIO}, /* DTR */
+	{CPM_PORTC, 10, CPM_PIN_INPUT | CPM_PIN_GPIO}, /* CTS */
+	{CPM_PORTC, 11, CPM_PIN_OUTPUT | CPM_PIN_GPIO}, /* RTS */
+
+	/* SMC2 (Serial 2) */
+	{CPM_PORTA,  7, CPM_PIN_OUTPUT | CPM_PIN_GPIO}, /* */
+	{CPM_PORTA,  8, CPM_PIN_INPUT}, /* TXD */
+	{CPM_PORTA,  9, CPM_PIN_INPUT}, /* RXD */
+	{CPM_PORTB, 16, CPM_PIN_OUTPUT | CPM_PIN_GPIO}, /* DTR */
+	{CPM_PORTB, 17, CPM_PIN_OUTPUT | CPM_PIN_GPIO}, /* RTS */
+	{CPM_PORTB, 18, CPM_PIN_INPUT | CPM_PIN_GPIO}, /* */
+	{CPM_PORTB, 19, CPM_PIN_INPUT | CPM_PIN_GPIO}, /* */
+	{CPM_PORTB, 22, CPM_PIN_INPUT | CPM_PIN_GPIO}, /* */
+	{CPM_PORTB, 23, CPM_PIN_INPUT | CPM_PIN_GPIO}, /* */
+	{CPM_PORTC,  4, CPM_PIN_INPUT | CPM_PIN_GPIO}, /* CTS */
+	{CPM_PORTC, 15, CPM_PIN_INPUT | CPM_PIN_GPIO}, /* DCD */
+
+	/* SSC2 (Ethernet) */
+	{CPM_PORTA,  4, CPM_PIN_INPUT}, /* RCLK */
+	{CPM_PORTA,  6, CPM_PIN_INPUT}, /* TCLK */
+	{CPM_PORTA, 12, CPM_PIN_INPUT}, /* TXD */
+	{CPM_PORTA, 13, CPM_PIN_INPUT}, /* RXD */
+	/* RENA */
+	{CPM_PORTC,  8, CPM_PIN_INPUT | CPM_PIN_SECONDARY | CPM_PIN_GPIO},
+	/* CLSN */
+	{CPM_PORTC,  9, CPM_PIN_INPUT | CPM_PIN_SECONDARY | CPM_PIN_GPIO},
+	{CPM_PORTC, 14, CPM_PIN_INPUT}, /* TENA */
+
+	/* I2C */
+	{CPM_PORTB, 26, CPM_PIN_OUTPUT | CPM_PIN_OPENDRAIN}, /* SCL */
+	{CPM_PORTB, 27, CPM_PIN_OUTPUT | CPM_PIN_OPENDRAIN}, /* SDA */
+
+	/* CAM */
+	{CPM_PORTB, 28, CPM_PIN_OUTPUT | CPM_PIN_GPIO},
+	{CPM_PORTB, 29, CPM_PIN_OUTPUT | CPM_PIN_GPIO | CPM_PIN_OPENDRAIN},
+	{CPM_PORTB, 30, CPM_PIN_OUTPUT | CPM_PIN_GPIO},
+	{CPM_PORTB, 31, CPM_PIN_OUTPUT | CPM_PIN_GPIO},
+
+	/* LCD */
+	{CPM_PORTD,  4, CPM_PIN_OUTPUT | CPM_PIN_GPIO},
+	{CPM_PORTD,  5, CPM_PIN_OUTPUT | CPM_PIN_GPIO},
+	{CPM_PORTD,  6, CPM_PIN_OUTPUT | CPM_PIN_GPIO},
+	{CPM_PORTD,  7, CPM_PIN_OUTPUT | CPM_PIN_GPIO},
+	{CPM_PORTD,  8, CPM_PIN_OUTPUT | CPM_PIN_GPIO},
+	{CPM_PORTD,  9, CPM_PIN_OUTPUT | CPM_PIN_GPIO},
+	{CPM_PORTD, 10, CPM_PIN_OUTPUT | CPM_PIN_GPIO},
+	{CPM_PORTD, 11, CPM_PIN_OUTPUT | CPM_PIN_GPIO},
+	{CPM_PORTD, 12, CPM_PIN_OUTPUT | CPM_PIN_GPIO},
+	{CPM_PORTD, 13, CPM_PIN_OUTPUT | CPM_PIN_GPIO},
+	{CPM_PORTD, 14, CPM_PIN_OUTPUT | CPM_PIN_GPIO},
+	{CPM_PORTD, 15, CPM_PIN_OUTPUT | CPM_PIN_GPIO},
+
+	/* FP */
+	{CPM_PORTA, 14, CPM_PIN_OUTPUT | CPM_PIN_GPIO | CPM_PIN_OPENDRAIN},
+};
+
+static void __init init_ioports(void)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(dbox2_pins); i++) {
+		const struct cpm_pin *pin = &dbox2_pins[i];
+		cpm1_set_pin(pin->port, pin->pin, pin->flags);
+	}
+
+	cpm1_clk_setup(CPM_CLK_SMC1, CPM_BRG1, CPM_CLK_RTX);
+	cpm1_clk_setup(CPM_CLK_SMC2, CPM_BRG2, CPM_CLK_RTX);
+	cpm1_clk_setup(CPM_CLK_SCC2, CPM_CLK2, CPM_CLK_TX);
+	cpm1_clk_setup(CPM_CLK_SCC2, CPM_CLK4, CPM_CLK_RX);
+
+}
+
+static void __init dbox2_setup_arch(void)
+{
+	cpm_reset();
+	init_ioports();
+
+	/* Enable external IRQ pin for AVIA chip */
+	clrbits32(&mpc8xx_immr->im_siu_conf.sc_siumcr, 0x00000c00);
+
+#if defined(CONFIG_PQ_WDT) || defined(CONFIG_PQ_WDT_MODULE)
+	pq_wdt_init();
+#endif
+}
+
+static int __init dbox2_probe(void)
+{
+	unsigned long root = of_get_flat_dt_root();
+	return of_flat_dt_is_compatible(root, "betaresearch,dbox2");
+}
+
+static struct of_device_id __initdata of_bus_ids[] = {
+	{ .name = "soc", },
+	{ .name = "cpm", },
+	{ .name = "localbus", },
+	{},
+};
+
+static int __init declare_of_platform_devices(void)
+{
+	/* Publish the QE devices */
+	if (machine_is(dbox2))
+		of_platform_bus_probe(NULL, of_bus_ids, NULL);
+
+	return 0;
+}
+device_initcall(declare_of_platform_devices);
+
+define_machine(dbox2) {
+	.name			= "DBox2",
+	.probe			= dbox2_probe,
+	.setup_arch		= dbox2_setup_arch,
+	.init_IRQ		= m8xx_pic_init,
+	.get_irq		= mpc8xx_get_irq,
+	.restart		= mpc8xx_restart,
+	.calibrate_decr		= mpc8xx_calibrate_decr,
+	.set_rtc_time		= mpc8xx_set_rtc_time,
+	.get_rtc_time		= mpc8xx_get_rtc_time,
+	.progress		= udbg_progress,
+};
-- 
1.5.3.7

