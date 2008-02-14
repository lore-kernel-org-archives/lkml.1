Return-Path: <linux-kernel-owner+w=401wt.eu-S1758765AbYBNRuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758765AbYBNRuV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 12:50:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752510AbYBNRuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 12:50:08 -0500
Received: from styx.suse.cz ([82.119.242.94]:55250 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750900AbYBNRuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 12:50:05 -0500
Subject: [PATCH] arm/pxa/spitz.h rewritten and commented
From: Stanislav Brabec <utx@penguin.cz>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Richard Purdie <rpurdie@rpsys.net>
Content-Type: text/plain; charset=ISO-8859-2
Date: Thu, 14 Feb 2008 18:50:01 +0100
Message-Id: <1203011402.7179.2.camel@hammer.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a rewrite of spitz.h, which includes comments documenting
function of particular GPIO pins.

spitz_h_rewrite.patch provides:
- no changes in compiled code
- partial spitz.h rewrite:
  * organized by function
  * describes complete GPIO pinout
  * comments added
  * removed defines cloning pxa-regs.h
- prefer generic pxa-regs.h GPIO if available
- use GPIO names instead of numbers

Thanks to Trisoft for providing needed information.

diff --git a/arch/arm/mach-pxa/spitz_pm.c b/arch/arm/mach-pxa/spitz_pm.c
index 745a4dc..941e6f2 100644
--- a/arch/arm/mach-pxa/spitz_pm.c
+++ b/arch/arm/mach-pxa/spitz_pm.c
@@ -110,9 +110,9 @@ static void spitz_presuspend(void)
 	pxa_gpio_mode(GPIO18_RDY|GPIO_OUT | GPIO_DFLT_HIGH);
 
 	PRER = GPIO_bit(SPITZ_GPIO_KEY_INT);
-	PFER = GPIO_bit(SPITZ_GPIO_KEY_INT) | GPIO_bit(SPITZ_GPIO_RESET);
-	PWER = GPIO_bit(SPITZ_GPIO_KEY_INT) | GPIO_bit(SPITZ_GPIO_RESET) | PWER_RTC;
-	PKWR = GPIO_bit(SPITZ_GPIO_SYNC) | GPIO_bit(SPITZ_GPIO_KEY_INT) | GPIO_bit(SPITZ_GPIO_RESET);
+	PFER = GPIO_bit(SPITZ_GPIO_KEY_INT) | GPIO_bit(GPIO1_RST);
+	PWER = GPIO_bit(SPITZ_GPIO_KEY_INT) | GPIO_bit(GPIO1_RST) | PWER_RTC;
+	PKWR = GPIO_bit(SPITZ_GPIO_SYNC) | GPIO_bit(SPITZ_GPIO_KEY_INT) | GPIO_bit(GPIO1_RST);
 	PKSR = 0xffffffff; // clear
 
 	/* nRESET_OUT Disable */
@@ -128,7 +128,7 @@ static void spitz_presuspend(void)
 static void spitz_postsuspend(void)
 {
 	pxa_gpio_mode(GPIO18_RDY_MD);
-	pxa_gpio_mode(10 | GPIO_IN);
+	pxa_gpio_mode(SPITZ_GPIO_NC_10 | GPIO_IN);
 }
 
 static int spitz_should_wakeup(unsigned int resume_on_alarm)
diff --git a/drivers/video/pxafb.c b/drivers/video/pxafb.c
index 10f912d..be450a4 100644
--- a/drivers/video/pxafb.c
+++ b/drivers/video/pxafb.c
@@ -816,7 +816,7 @@ static void pxafb_setup_gpio(struct pxafb_info *fbi)
 		return;
         }
 
-	for (gpio = 58; ldd_bits; gpio++, ldd_bits--)
+	for (gpio = GPIO58_LDD_0; ldd_bits; gpio++, ldd_bits--)
 		pxa_gpio_mode(gpio | GPIO_ALT_FN_2_OUT);
 	pxa_gpio_mode(GPIO74_LCD_FCLK_MD);
 	pxa_gpio_mode(GPIO75_LCD_LCLK_MD);
diff --git a/include/asm-arm/arch-pxa/akita.h b/include/asm-arm/arch-pxa/akita.h
index 5d8cc1d..d4d01d4 100644
--- a/include/asm-arm/arch-pxa/akita.h
+++ b/include/asm-arm/arch-pxa/akita.h
@@ -12,11 +12,11 @@
 /* Akita IO Expander GPIOs */
 
 #define AKITA_IOEXP_RESERVED_7      (1 << 7)
-#define AKITA_IOEXP_IR_ON           (1 << 6)
-#define AKITA_IOEXP_AKIN_PULLUP     (1 << 5)
-#define AKITA_IOEXP_BACKLIGHT_CONT  (1 << 4)
-#define AKITA_IOEXP_BACKLIGHT_ON    (1 << 3)
-#define AKITA_IOEXP_MIC_BIAS        (1 << 2)
+#define AKITA_IOEXP_IR_ON           (1 << 6)	/* IrDA On */
+#define AKITA_IOEXP_AKIN_PULLUP     (1 << 5)	/* Pull-Up for Remote */
+#define AKITA_IOEXP_BACKLIGHT_CONT  (1 << 4)	/* Backlight Control */
+#define AKITA_IOEXP_BACKLIGHT_ON    (1 << 3)	/* Backlight On */
+#define AKITA_IOEXP_MIC_BIAS        (1 << 2)	/* Mic Bias On */
 #define AKITA_IOEXP_RESERVED_1      (1 << 1)
 #define AKITA_IOEXP_RESERVED_0      (1 << 0)
 
diff --git a/include/asm-arm/arch-pxa/pxa-regs.h b/include/asm-arm/arch-pxa/pxa-regs.h
index ac175b4..c613588 100644
--- a/include/asm-arm/arch-pxa/pxa-regs.h
+++ b/include/asm-arm/arch-pxa/pxa-regs.h
@@ -1340,6 +1340,7 @@
 #define GPIO85_nPCE_1		85	/* Card Enable for Card Space (PXA27x) */
 #define GPIO92_MMCDAT0		92	/* MMC DAT0 (PXA27x) */
 #define GPIO102_nPCE_1		102	/* PCMCIA (PXA27x) */
+#define GPIO104_pSKTSEL		104	/* PCMCIA Socket Select (PXA27x) */
 #define GPIO109_MMCDAT1		109	/* MMC DAT1 (PXA27x) */
 #define GPIO110_MMCDAT2		110	/* MMC DAT2 (PXA27x) */
 #define GPIO110_MMCCS0		110	/* MMC Chip Select 0 (PXA27x) */
diff --git a/include/asm-arm/arch-pxa/spitz.h b/include/asm-arm/arch-pxa/spitz.h
index bd14365..3fda52e 100644
--- a/include/asm-arm/arch-pxa/spitz.h
+++ b/include/asm-arm/arch-pxa/spitz.h
@@ -1,8 +1,9 @@
 /*
- * Hardware specific definitions for SL-Cx000 series of PDAs
+ * Hardware specific definitions for SL-Cxx00 series of PDAs
  *
  * Copyright (c) 2005 Alexander Wykes
  * Copyright (c) 2005 Richard Purdie
+ * Copyright (c) 2008 Stanislav Brabec
  *
  * Based on Sharp's 2.4 kernel patches
  *
@@ -13,140 +14,257 @@
  */
 #ifndef __ASM_ARCH_SPITZ_H
 #define __ASM_ARCH_SPITZ_H  1
-#endif
 
-#include <linux/fb.h>
+#include <asm-arm/arch-pxa/irqs.h>
+#include <linux/platform_device.h>
 
 /* Spitz/Akita GPIOs */
 
-#define SPITZ_GPIO_KEY_INT         (0) /* Key Interrupt */
-#define SPITZ_GPIO_RESET           (1)
-#define SPITZ_GPIO_nSD_DETECT      (9)
-#define SPITZ_GPIO_TP_INT          (11) /* Touch Panel interrupt */
-#define SPITZ_GPIO_AK_INT          (13) /* Remote Control */
-#define SPITZ_GPIO_ADS7846_CS      (14)
-#define SPITZ_GPIO_SYNC            (16)
-#define SPITZ_GPIO_MAX1111_CS      (20)
-#define SPITZ_GPIO_FATAL_BAT       (21)
-#define SPITZ_GPIO_HSYNC           (22)
-#define SPITZ_GPIO_nSD_CLK         (32)
-#define SPITZ_GPIO_USB_DEVICE      (35)
-#define SPITZ_GPIO_USB_HOST        (37)
-#define SPITZ_GPIO_USB_CONNECT     (41)
-#define SPITZ_GPIO_LCDCON_CS       (53)
-#define SPITZ_GPIO_nPCE            (54)
-#define SPITZ_GPIO_nSD_WP          (81)
-#define SPITZ_GPIO_ON_RESET        (89)
-#define SPITZ_GPIO_BAT_COVER       (90)
-#define SPITZ_GPIO_CF_CD           (94)
-#define SPITZ_GPIO_ON_KEY          (95)
-#define SPITZ_GPIO_SWA             (97)
-#define SPITZ_GPIO_SWB             (96)
-#define SPITZ_GPIO_CHRG_FULL       (101)
-#define SPITZ_GPIO_CO              (101)
-#define SPITZ_GPIO_CF_IRQ          (105)
-#define SPITZ_GPIO_AC_IN           (115)
-#define SPITZ_GPIO_HP_IN           (116)
-
-/* Spitz Only GPIOs */
-
-#define SPITZ_GPIO_CF2_IRQ         (106) /* CF slot1 Ready */
-#define SPITZ_GPIO_CF2_CD          (93)
+/* This list refers to all GPIO pins either in defines or in comments.
+ *
+ * GPIO pins not listed:
+ * GPIO2	SYS_EN: 		System Power Enable
+ * GPIO5-GPIO8	PWR_CAP0-PWR_CAP3:	sleep DC-DC converter power capacitors
+ * GPIO40	not connected
+ */
+
+
+/* Spitz/Akita System GPIO */
+
+#define SPITZ_GPIO_KEY_INT	   (0)	/* Key Interrupt */
+#define SPITZ_GPIO_SYNC		  (16)	/* IOPORT Wake Up (input) */
+#define SPITZ_GPIO_NAND_CS	  (79)	/* NAND Flash Chip Select */
+#define SPITZ_GPIO_NC_10	  (10)	/* Not Connected (but used in kernel) */
+/* This GPIO pin is connected:
+ * GPIO1_RST
+ */
+
+
+/* Compact Flash Interface */
+
+/* Spitz/Akita Compact Flash Interface */
+#define SPITZ_GPIO_CF_CD	  (94)	/* CF IRQ */
+#define SPITZ_GPIO_CF_IRQ	 (105)	/* CF Ready */
+/* These GPIO pins are connected:
+ * GPIO48_nPOE
+ * GPIO49_nPWE
+ * GPIO50_nPIOR
+ * GPIO51_nPIOW
+ * GPIO54_nPCE_2
+ * GPIO55_nPREG
+ * GPIO56_nPWAIT
+ * GPIO57_nIOIS16
+ * GPIO80_nCS_4
+ * GPIO85_nPCE_1
+ * GPIO104_pSKTSEL
+ */
+
+/* Spitz only Compact Flash Interface */
+#define SPITZ_GPIO_CF2_CD	  (93)	/* CF slot1 IRQ */
+#define SPITZ_GPIO_CF2_IRQ	 (106)	/* CF slot1 Ready */
+/* This GPIO pin is connected:
+ * GPIO78_nCS_2
+ */
+
+
+/* Spitz/Akita Battery, Power and Service Connector */
+
+#define SPITZ_GPIO_FATAL_BAT	  (21)	/* Fatal Battery */
+#define SPITZ_GPIO_BAT_COVER	  (90)	/* Battery Cover switch */
+#define SPITZ_GPIO_BAT_COVER2	  (15)	/* Battery Cover switch, parallel pin */
+#define SPITZ_GPIO_CHRG_FULL	 (101)	/* Battery Full */
+#define SPITZ_GPIO_AC_IN	 (115)	/* External Power Supply is active */
+#define SPITZ_GPIO_ON_RESET	  (89)	/* Software Reset */
+#define SPITZ_GPIO_SERVICE0	  (83)	/* Service Connector */
+#define SPITZ_GPIO_SERVICE1	  (84)	/* Service Connector */
+/* This GPIO pin is connected:
+ * GPIO18_RDY
+ */
+
+
+/* Spitz/Akita Display Controller */
+
+#define SPITZ_GPIO_HSYNC	  (22)	/* Line Sync Feedback */
+/* These GPIO pins are connected:
+ * GPIO58_LDD_0-GPIO58_LDD_15
+ * GPIO74_LCD_FCLK
+ * GPIO75_LCD_LCLK
+ * GPIO76_LCD_PCLK
+ * GPIO77_LCD_ACBIAS
+ */
+
+
+/* Spitz/Akita SSP/SPI Bus and Devices */
+
+#define SPITZ_GPIO_SSP_CLK	  (19)	/* SSP bus Clock */
+#define SPITZ_GPIO_SSP_RXD	  (86)	/* SSP bus RxD */
+#define SPITZ_GPIO_SSP_TXD	  (87)	/* SSP bus TxD */
+#define SPITZ_GPIO_TP_INT	  (11)	/* Touch Panel IRQ */
+#define SPITZ_GPIO_ADS7846_CS	  (14)	/* Touch Panel Controller Chip Select */
+#define SPITZ_GPIO_MAX1111_CS	  (20)	/* Multi Channel ADC Chip Select */
+#define SPITZ_GPIO_LCDCON_CS	  (53)	/* LCD Controller Chip Select */
+
 
+/* Spitz/Akita Supplementary USB OTG Pins */
+
+#define SPITZ_GPIO_USB_DEVICE	  (35)	/* USB Client power is present */
+#define SPITZ_GPIO_USB_HOST	  (37)	/* USB OTG 5V Host power supply control */
+#define SPITZ_GPIO_USB_CONNECT	  (41)	/* USB Host Cable is connected */
+
+
+/* Spitz/Akita Audio */
+
+#define SPITZ_GPIO_HP_IN	 (116)	/* CPU Headphone detect */
+#define SPITZ_GPIO_AK_INT	  (13)	/* Remote Control detect */
+/* These GPIO AC97 pins are connected:
+ * GPIO28_BITCLK
+ * GPIO29_SDATA_IN
+ * GPIO30_SDATA_OUT
+ * GPIO31_SYNC
+ * GPIO113_AC97_RESET_N
+ */
+
+
+/* Spitz/Akita SD Slot */
+
+#define SPITZ_GPIO_nSD_DETECT	  (9)	/* SD Card Presence */
+#define SPITZ_GPIO_nSD_WP	 (81)	/* SD Write Protection */
+/* These GPIO pins are connected:
+ * GPIO32_MMCCLK
+ * GPIO92_MMCDAT0
+ * GPIO109_MMCDAT1
+ * GPIO110_MMCDAT2
+ * GPIO111_MMCDAT3
+ * GPIO112_MMCCMD
+ */
+
+/* Spitz/Akita I2C bus */
+#define SPITZ_GPIO_SCL		 (117)	/* I2C SCL */
+#define SPITZ_GPIO_SDA		 (118)	/* I2C SDA */
+#define SPITZ_GPIO_PWR_SCL	   (3)	/* I2C SCL power */
+#define SPITZ_GPIO_PWR_SDA	   (4)	/* I2C SDA power */
+
+/* audio codec pins */
+
+
+/* Spitz/Akita UART ports */
+
+/* Fully Featured UART - connected to IOPORT connector */
+#define SPITZ_GPIO_FFRXD	 (102)	/* IOPORT has nRXD inverted levels */
+#define SPITZ_GPIO_FFTXD	  (99)	/* IOPORT has nTXD inverted levels */
+#define SPITZ_GPIO_FFRTS	  (98)
+#define SPITZ_GPIO_FFCTS	 (100)
+#define SPITZ_GPIO_FFDTR	  (82)
+#define SPITZ_GPIO_FFDSR	  (33)
+
+/* These UART GPIO pins are connected to Bluetooth
+ * (only on Akita version with Bluetooth)
+ * GPIO42_BTRXD
+ * GPIO43_BTTXD
+ * GPIO44_BTCTS
+ * GPIO45_BTRTS
+ */
+
+/* These UART GPIO pins are connected to IrDA:
+ * GPIO46_STRXD
+ * GPIO47_STTXD
+ */
 
 /* Spitz/Akita Keyboard Definitions */
 
-#define SPITZ_KEY_STROBE_NUM         (11)
-#define SPITZ_KEY_SENSE_NUM          (7)
-#define SPITZ_GPIO_G0_STROBE_BIT     0x0f800000
-#define SPITZ_GPIO_G1_STROBE_BIT     0x00100000
-#define SPITZ_GPIO_G2_STROBE_BIT     0x01000000
-#define SPITZ_GPIO_G3_STROBE_BIT     0x00041880
-#define SPITZ_GPIO_G0_SENSE_BIT      0x00021000
-#define SPITZ_GPIO_G1_SENSE_BIT      0x000000d4
-#define SPITZ_GPIO_G2_SENSE_BIT      0x08000000
-#define SPITZ_GPIO_G3_SENSE_BIT      0x00000000
-
-#define SPITZ_GPIO_KEY_STROBE0       88
-#define SPITZ_GPIO_KEY_STROBE1       23
-#define SPITZ_GPIO_KEY_STROBE2       24
-#define SPITZ_GPIO_KEY_STROBE3       25
-#define SPITZ_GPIO_KEY_STROBE4       26
-#define SPITZ_GPIO_KEY_STROBE5       27
-#define SPITZ_GPIO_KEY_STROBE6       52
-#define SPITZ_GPIO_KEY_STROBE7       103
-#define SPITZ_GPIO_KEY_STROBE8       107
-#define SPITZ_GPIO_KEY_STROBE9       108
-#define SPITZ_GPIO_KEY_STROBE10      114
-
-#define SPITZ_GPIO_KEY_SENSE0        12
-#define SPITZ_GPIO_KEY_SENSE1        17
-#define SPITZ_GPIO_KEY_SENSE2        91
-#define SPITZ_GPIO_KEY_SENSE3        34
-#define SPITZ_GPIO_KEY_SENSE4        36
-#define SPITZ_GPIO_KEY_SENSE5        38
-#define SPITZ_GPIO_KEY_SENSE6        39
-
-
-/* Spitz Scoop Device (No. 1) GPIOs */
+#define SPITZ_KEY_STROBE_NUM	  (11)
+#define SPITZ_KEY_SENSE_NUM	   (7)
+#define SPITZ_GPIO_G0_STROBE_BIT  0x0f800000
+#define SPITZ_GPIO_G1_STROBE_BIT  0x00100000
+#define SPITZ_GPIO_G2_STROBE_BIT  0x01000000
+#define SPITZ_GPIO_G3_STROBE_BIT  0x00041880
+#define SPITZ_GPIO_G0_SENSE_BIT   0x00021000
+#define SPITZ_GPIO_G1_SENSE_BIT   0x000000d4
+#define SPITZ_GPIO_G2_SENSE_BIT   0x08000000
+#define SPITZ_GPIO_G3_SENSE_BIT   0x00000000
+#define SPITZ_GPIO_KEY_STROBE0	  (88)
+#define SPITZ_GPIO_KEY_STROBE1	  (23)
+#define SPITZ_GPIO_KEY_STROBE2	  (24)
+#define SPITZ_GPIO_KEY_STROBE3	  (25)
+#define SPITZ_GPIO_KEY_STROBE4	  (26)
+#define SPITZ_GPIO_KEY_STROBE5	  (27)
+#define SPITZ_GPIO_KEY_STROBE6	  (52)
+#define SPITZ_GPIO_KEY_STROBE7   (103)
+#define SPITZ_GPIO_KEY_STROBE8   (107)
+#define SPITZ_GPIO_KEY_STROBE9   (108)
+#define SPITZ_GPIO_KEY_STROBE10  (114)
+#define SPITZ_GPIO_KEY_SENSE0	  (12)
+#define SPITZ_GPIO_KEY_SENSE1	  (17)
+#define SPITZ_GPIO_KEY_SENSE2	  (91)
+#define SPITZ_GPIO_KEY_SENSE3	  (34)
+#define SPITZ_GPIO_KEY_SENSE4	  (36)
+#define SPITZ_GPIO_KEY_SENSE5	  (38)
+#define SPITZ_GPIO_KEY_SENSE6	  (39)
+
+#define SPITZ_GPIO_SWA		  (97)	/* Keyboard Interrupt A */
+#define SPITZ_GPIO_SWB		  (96)	/* Keyboard Interrupt B */
+#define SPITZ_GPIO_ON_KEY	  (95)	/* Power On Key */
+
+
+/* Spitz/Akita Scoop Device (No. 1) GPIOs */
 /* Suspend States in comments */
-#define SPITZ_SCP_LED_GREEN     SCOOP_GPCR_PA11  /* Keep */
-#define SPITZ_SCP_JK_B          SCOOP_GPCR_PA12  /* Keep */
-#define SPITZ_SCP_CHRG_ON       SCOOP_GPCR_PA13  /* Keep */
-#define SPITZ_SCP_MUTE_L        SCOOP_GPCR_PA14  /* Low */
-#define SPITZ_SCP_MUTE_R        SCOOP_GPCR_PA15  /* Low */
-#define SPITZ_SCP_CF_POWER      SCOOP_GPCR_PA16  /* Keep */
-#define SPITZ_SCP_LED_ORANGE    SCOOP_GPCR_PA17  /* Keep */
-#define SPITZ_SCP_JK_A          SCOOP_GPCR_PA18  /* Low */
-#define SPITZ_SCP_ADC_TEMP_ON   SCOOP_GPCR_PA19  /* Low */
+#define SPITZ_SCP_LED_GREEN	SCOOP_GPCR_PA11  /* Green LED, Keep */
+#define SPITZ_SCP_JK_B		SCOOP_GPCR_PA12  /* Fast Charge On, Keep */
+#define SPITZ_SCP_CHRG_ON	SCOOP_GPCR_PA13  /* Charge On, Keep */
+#define SPITZ_SCP_MUTE_L	SCOOP_GPCR_PA14  /* Extra Mute Left, Low */
+#define SPITZ_SCP_MUTE_R	SCOOP_GPCR_PA15  /* Extra Mute Right, Low */
+#define SPITZ_SCP_CF_POWER	SCOOP_GPCR_PA16  /* CF+SD Power Circuit, Keep */
+#define SPITZ_SCP_LED_ORANGE	SCOOP_GPCR_PA17  /* Orange LED, Keep */
+#define SPITZ_SCP_JK_A		SCOOP_GPCR_PA18  /* Dummy Load, Low */
+#define SPITZ_SCP_ADC_TEMP_ON	SCOOP_GPCR_PA19  /* Battery Sensor On, Low */
 
 #define SPITZ_SCP_IO_DIR      (SPITZ_SCP_LED_GREEN | SPITZ_SCP_JK_B | SPITZ_SCP_CHRG_ON | \
-                               SPITZ_SCP_MUTE_L | SPITZ_SCP_MUTE_R | SPITZ_SCP_LED_ORANGE | \
-                               SPITZ_SCP_CF_POWER | SPITZ_SCP_JK_A | SPITZ_SCP_ADC_TEMP_ON)
+			       SPITZ_SCP_MUTE_L | SPITZ_SCP_MUTE_R | SPITZ_SCP_LED_ORANGE | \
+			       SPITZ_SCP_CF_POWER | SPITZ_SCP_JK_A | SPITZ_SCP_ADC_TEMP_ON)
 #define SPITZ_SCP_IO_OUT      (SPITZ_SCP_CHRG_ON | SPITZ_SCP_MUTE_L | SPITZ_SCP_MUTE_R)
 #define SPITZ_SCP_SUS_CLR     (SPITZ_SCP_MUTE_L | SPITZ_SCP_MUTE_R | SPITZ_SCP_JK_A | SPITZ_SCP_ADC_TEMP_ON)
 #define SPITZ_SCP_SUS_SET     0
 
 /* Spitz Scoop Device (No. 2) GPIOs */
-/* Suspend States in comments */
-#define SPITZ_SCP2_IR_ON           SCOOP_GPCR_PA11  /* High */
-#define SPITZ_SCP2_AKIN_PULLUP     SCOOP_GPCR_PA12  /* Keep */
-#define SPITZ_SCP2_RESERVED_1      SCOOP_GPCR_PA13  /* High */
-#define SPITZ_SCP2_RESERVED_2      SCOOP_GPCR_PA14  /* Low */
-#define SPITZ_SCP2_RESERVED_3      SCOOP_GPCR_PA15  /* Low */
-#define SPITZ_SCP2_RESERVED_4      SCOOP_GPCR_PA16  /* Low */
-#define SPITZ_SCP2_BACKLIGHT_CONT  SCOOP_GPCR_PA17  /* Low */
-#define SPITZ_SCP2_BACKLIGHT_ON    SCOOP_GPCR_PA18  /* Low */
-#define SPITZ_SCP2_MIC_BIAS        SCOOP_GPCR_PA19  /* Low */
+/* Suspend States in comments
+ * Spitz only, Akita uses corresponding AKITA_IOEXP_ */
+#define SPITZ_SCP2_IR_ON	   SCOOP_GPCR_PA11  /* IrDA On, High */
+#define SPITZ_SCP2_AKIN_PULLUP	   SCOOP_GPCR_PA12  /* Pull-Up for Remote, Keep */
+#define SPITZ_SCP2_RESERVED_1	   SCOOP_GPCR_PA13  /* High */
+#define SPITZ_SCP2_RESERVED_2	   SCOOP_GPCR_PA14  /* Low */
+#define SPITZ_SCP2_RESERVED_3	   SCOOP_GPCR_PA15  /* Low */
+#define SPITZ_SCP2_RESERVED_4	   SCOOP_GPCR_PA16  /* Low */
+#define SPITZ_SCP2_BACKLIGHT_CONT  SCOOP_GPCR_PA17  /* Backlight Control, Low */
+#define SPITZ_SCP2_BACKLIGHT_ON	   SCOOP_GPCR_PA18  /* Backlight On, Low */
+#define SPITZ_SCP2_MIC_BIAS	   SCOOP_GPCR_PA19  /* Mic Bias On, Low */
 
 #define SPITZ_SCP2_IO_DIR (SPITZ_SCP2_IR_ON | SPITZ_SCP2_AKIN_PULLUP | SPITZ_SCP2_RESERVED_1 | \
-                           SPITZ_SCP2_RESERVED_2 | SPITZ_SCP2_RESERVED_3 | SPITZ_SCP2_RESERVED_4 | \
-                           SPITZ_SCP2_BACKLIGHT_CONT | SPITZ_SCP2_BACKLIGHT_ON | SPITZ_SCP2_MIC_BIAS)
+			   SPITZ_SCP2_RESERVED_2 | SPITZ_SCP2_RESERVED_3 | SPITZ_SCP2_RESERVED_4 | \
+			   SPITZ_SCP2_BACKLIGHT_CONT | SPITZ_SCP2_BACKLIGHT_ON | SPITZ_SCP2_MIC_BIAS)
 
 #define SPITZ_SCP2_IO_OUT   (SPITZ_SCP2_IR_ON | SPITZ_SCP2_AKIN_PULLUP | SPITZ_SCP2_RESERVED_1)
 #define SPITZ_SCP2_SUS_CLR  (SPITZ_SCP2_RESERVED_2 | SPITZ_SCP2_RESERVED_3 | SPITZ_SCP2_RESERVED_4 | \
-                             SPITZ_SCP2_BACKLIGHT_CONT | SPITZ_SCP2_BACKLIGHT_ON | SPITZ_SCP2_MIC_BIAS)
+			     SPITZ_SCP2_BACKLIGHT_CONT | SPITZ_SCP2_BACKLIGHT_ON | SPITZ_SCP2_MIC_BIAS)
 #define SPITZ_SCP2_SUS_SET  (SPITZ_SCP2_IR_ON | SPITZ_SCP2_RESERVED_1)
 

-/* Spitz IRQ Definitions */
+/* Spitz/Akita IRQ Definitions */
 
-#define SPITZ_IRQ_GPIO_KEY_INT        IRQ_GPIO(SPITZ_GPIO_KEY_INT)
-#define SPITZ_IRQ_GPIO_AC_IN          IRQ_GPIO(SPITZ_GPIO_AC_IN)
-#define SPITZ_IRQ_GPIO_AK_INT         IRQ_GPIO(SPITZ_GPIO_AK_INT)
-#define SPITZ_IRQ_GPIO_HP_IN          IRQ_GPIO(SPITZ_GPIO_HP_IN)
-#define SPITZ_IRQ_GPIO_TP_INT         IRQ_GPIO(SPITZ_GPIO_TP_INT)
-#define SPITZ_IRQ_GPIO_SYNC           IRQ_GPIO(SPITZ_GPIO_SYNC)
-#define SPITZ_IRQ_GPIO_ON_KEY         IRQ_GPIO(SPITZ_GPIO_ON_KEY)
-#define SPITZ_IRQ_GPIO_SWA            IRQ_GPIO(SPITZ_GPIO_SWA)
-#define SPITZ_IRQ_GPIO_SWB            IRQ_GPIO(SPITZ_GPIO_SWB)
+#define SPITZ_IRQ_GPIO_KEY_INT	      IRQ_GPIO(SPITZ_GPIO_KEY_INT)
+#define SPITZ_IRQ_GPIO_AC_IN	      IRQ_GPIO(SPITZ_GPIO_AC_IN)
+#define SPITZ_IRQ_GPIO_AK_INT	      IRQ_GPIO(SPITZ_GPIO_AK_INT)
+#define SPITZ_IRQ_GPIO_HP_IN	      IRQ_GPIO(SPITZ_GPIO_HP_IN)
+#define SPITZ_IRQ_GPIO_TP_INT	      IRQ_GPIO(SPITZ_GPIO_TP_INT)
+#define SPITZ_IRQ_GPIO_SYNC	      IRQ_GPIO(SPITZ_GPIO_SYNC)
+#define SPITZ_IRQ_GPIO_ON_KEY	      IRQ_GPIO(SPITZ_GPIO_ON_KEY)
+#define SPITZ_IRQ_GPIO_SWA	      IRQ_GPIO(SPITZ_GPIO_SWA)
+#define SPITZ_IRQ_GPIO_SWB	      IRQ_GPIO(SPITZ_GPIO_SWB)
 #define SPITZ_IRQ_GPIO_BAT_COVER      IRQ_GPIO(SPITZ_GPIO_BAT_COVER)
 #define SPITZ_IRQ_GPIO_FATAL_BAT      IRQ_GPIO(SPITZ_GPIO_FATAL_BAT)
-#define SPITZ_IRQ_GPIO_CO             IRQ_GPIO(SPITZ_GPIO_CO)
-#define SPITZ_IRQ_GPIO_CF_IRQ         IRQ_GPIO(SPITZ_GPIO_CF_IRQ)
-#define SPITZ_IRQ_GPIO_CF_CD          IRQ_GPIO(SPITZ_GPIO_CF_CD)
-#define SPITZ_IRQ_GPIO_CF2_IRQ        IRQ_GPIO(SPITZ_GPIO_CF2_IRQ)
-#define SPITZ_IRQ_GPIO_nSD_INT        IRQ_GPIO(SPITZ_GPIO_nSD_INT)
+#define SPITZ_IRQ_GPIO_CF_IRQ	      IRQ_GPIO(SPITZ_GPIO_CF_IRQ)
+#define SPITZ_IRQ_GPIO_CF_CD	      IRQ_GPIO(SPITZ_GPIO_CF_CD)
+#define SPITZ_IRQ_GPIO_CF2_IRQ	      IRQ_GPIO(SPITZ_GPIO_CF2_IRQ)
+#define SPITZ_IRQ_GPIO_nSD_INT	      IRQ_GPIO(SPITZ_GPIO_nSD_INT)
 #define SPITZ_IRQ_GPIO_nSD_DETECT     IRQ_GPIO(SPITZ_GPIO_nSD_DETECT)
 
 /*
@@ -156,3 +274,5 @@ extern struct platform_device spitzscoop_device;
 extern struct platform_device spitzscoop2_device;
 extern struct platform_device spitzssp_device;
 extern struct sharpsl_charger_machinfo spitz_pm_machinfo;
+
+#endif
diff --git a/sound/arm/pxa2xx-ac97.c b/sound/arm/pxa2xx-ac97.c
index 5d86e68..d81f799 100644
--- a/sound/arm/pxa2xx-ac97.c
+++ b/sound/arm/pxa2xx-ac97.c
@@ -132,10 +132,10 @@ static void pxa2xx_ac97_reset(struct snd_ac97 *ac97)
 #ifdef CONFIG_PXA27x
 		/* warm reset broken on Bulverde,
 		   so manually keep AC97 reset high */
-		pxa_gpio_mode(113 | GPIO_OUT | GPIO_DFLT_HIGH); 
+		pxa_gpio_mode(GPIO113_AC97_RESET_N | GPIO_OUT | GPIO_DFLT_HIGH); 
 		udelay(10);
 		GCR |= GCR_WARM_RST;
-		pxa_gpio_mode(113 | GPIO_ALT_FN_2_OUT);
+		pxa_gpio_mode(GPIO113_AC97_RESET_N_MD);
 		udelay(500);
 #else
 		GCR |= GCR_WARM_RST|GCR_PRIRDY_IEN|GCR_SECRDY_IEN;
@@ -334,7 +334,7 @@ static int __devinit pxa2xx_ac97_probe(struct platform_device *dev)
 	pxa_gpio_mode(GPIO29_SDATA_IN_AC97_MD);
 #ifdef CONFIG_PXA27x
 	/* Use GPIO 113 as AC97 Reset on Bulverde */
-	pxa_gpio_mode(113 | GPIO_ALT_FN_2_OUT);
+	pxa_gpio_mode(GPIO113_AC97_RESET_N_MD);
 #endif
 	pxa_set_cken(CKEN_AC97, 1);
 

-- 
Best Regards / S pozdravem,

Stanislav Brabec
software developer
---------------------------------------------------------------------
SUSE LINUX, s. r. o.                          e-mail: sbrabec@suse.cz
Lihovarská 1060/12           tel: +420 284 028 966, +49 911 740538747
190 00 Praha 9                                  fax: +420 284 028 951
Czech Republic                                    http://www.suse.cz/

