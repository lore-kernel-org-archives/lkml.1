Return-Path: <linux-kernel-owner+w=401wt.eu-S946822AbXHMQPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S946822AbXHMQPr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 12:15:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S947759AbXHMPAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 11:00:19 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:40673 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S946056AbXHMPAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 11:00:10 -0400
X-IronPort-AV: i="4.19,255,1183348800"; 
   d="scan'208"; a="36996229:sNHT51713144"
Subject: [GIT PULL] Blackfin updates for 2.6.23-rc3 (GPIO related)
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, dbrownell@users.sourceforge.net
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Ltd.
Date: Mon, 13 Aug 2007 22:32:33 +0800
Message-Id: <1187015553.10375.5.camel@roc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 13 Aug 2007 15:00:06.0433 (UTC) FILETIME=[A28FB110:01C7DDBA]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

If you got this email twice, please forgive me for sending it again.
Because I found LKML didn't receive this email, let me try again.

Please pull from 'for-linus' branch of

master.kernel.org:/pub/scm/linux/kernel/git/cooloney/blackfin-2.6.git for-linus

to receive the following updates:

 arch/blackfin/Kconfig                             |    2 +-
 arch/blackfin/kernel/bfin_gpio.c                  |  323 ++++++++++++++++--
 arch/blackfin/mach-bf548/Kconfig                  |    4 +-
 arch/blackfin/mach-bf548/boards/ezkit.c           |  367 ++++++++++++++++++++-
 arch/blackfin/mach-bf548/gpio.c                   |  103 +++++-
 arch/blackfin/mach-common/ints-priority-dc.c      |    4 +-
 arch/blackfin/mach-common/ints-priority-sc.c      |    8 +-
 include/asm-blackfin/gpio.h                       |   31 ++
 include/asm-blackfin/mach-bf533/bfin_serial_5xx.h |   11 +-
 include/asm-blackfin/mach-bf533/blackfin.h        |    2 +-
 include/asm-blackfin/mach-bf533/irq.h             |    2 +
 include/asm-blackfin/mach-bf537/bfin_serial_5xx.h |   23 +-
 include/asm-blackfin/mach-bf537/blackfin.h        |    2 +-
 include/asm-blackfin/mach-bf537/irq.h             |    2 +
 include/asm-blackfin/mach-bf537/portmux.h         |   35 ++-
 include/asm-blackfin/mach-bf548/bfin_serial_5xx.h |   39 +--
 include/asm-blackfin/mach-bf548/blackfin.h        |    2 +-
 include/asm-blackfin/mach-bf548/gpio.h            |    5 -
 include/asm-blackfin/mach-bf548/irq.h             |    2 +
 include/asm-blackfin/mach-bf561/bfin_serial_5xx.h |   11 +-
 include/asm-blackfin/mach-bf561/blackfin.h        |    2 +-
 include/asm-blackfin/mach-bf561/irq.h             |    2 +
 include/asm-blackfin/portmux.h                    |   22 ++
 23 files changed, 897 insertions(+), 107 deletions(-)

Bryan Wu (2):
      Blackfin arch: bug fixing, add missing BF533_FAMILY GPIO_PFx definition
      Blackfin arch: update platform driver resource information to the ezkitBF548 board file

Michael Hennerich (10):
      Blackfin arch: store labels so we later know who allocated GPIO/Peripheral resources
      Blackfin arch: add peripheral resource allocation support
      Blackfin arch: Add label to call new GPIO API
      Blackfin arch: fix PORT_J BUG for BF537/6 EMAC driver
      Blackfin arch: Finalize the generic gpio support - add gpio_to_irq and irq_to_gpio
      Blackfin arch: Advertise GENERIC_GPIO and remove duplicated GENERIC_CALIBRATE_DELAY
      Blackfin arch: Add PORT_J.High (needed for BF548-EZkit Touchscreen interrupts) - remove PORT_C.H
      Blackfin arch: add missing gpio error handling to make sure we roll back requests in case one fails
      Blackfin arch: Some cosmetics based on LKML feedback from Joe Perches
      Blackfin serial driver: use new GPIO API

Mike Frysinger (1):
      Blackfin arch: scrub remaining ASSEMBLY usage since the switch to __ASSEMBLY__

diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index 017defa..5c1e215 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -57,7 +57,7 @@ config GENERIC_TIME
 	bool
 	default n
 
-config GENERIC_CALIBRATE_DELAY
+config GENERIC_GPIO
 	bool
 	default y
 
diff --git a/arch/blackfin/kernel/bfin_gpio.c b/arch/blackfin/kernel/bfin_gpio.c
index bafcfa5..3eaf53d 100644
--- a/arch/blackfin/kernel/bfin_gpio.c
+++ b/arch/blackfin/kernel/bfin_gpio.c
@@ -84,6 +84,7 @@
 #include <linux/err.h>
 #include <asm/blackfin.h>
 #include <asm/gpio.h>
+#include <asm/portmux.h>
 #include <linux/irq.h>
 
 #ifdef BF533_FAMILY
@@ -115,7 +116,16 @@ static struct gpio_port_t *gpio_bankb[gpio_bank(MAX_BLACKFIN_GPIOS)] = {
 };
 #endif
 
-static unsigned short reserved_map[gpio_bank(MAX_BLACKFIN_GPIOS)];
+static unsigned short reserved_gpio_map[gpio_bank(MAX_BLACKFIN_GPIOS)];
+static unsigned short reserved_peri_map[gpio_bank(MAX_BLACKFIN_GPIOS + 16)];
+
+#define MAX_RESOURCES 		256
+#define RESOURCE_LABEL_SIZE 	16
+
+struct str_ident {
+	char name[RESOURCE_LABEL_SIZE];
+} *str_ident;
+
 
 #ifdef CONFIG_PM
 static unsigned short wakeup_map[gpio_bank(MAX_BLACKFIN_GPIOS)];
@@ -143,22 +153,124 @@ inline int check_gpio(unsigned short gpio)
 	return 0;
 }
 
+static void set_label(unsigned short ident, const char *label)
+{
+
+	if (label && str_ident) {
+		strncpy(str_ident[ident].name, label,
+			 RESOURCE_LABEL_SIZE);
+		str_ident[ident].name[RESOURCE_LABEL_SIZE - 1] = 0;
+	}
+}
+
+static char *get_label(unsigned short ident)
+{
+	if (!str_ident)
+		return "UNKNOWN";
+
+	return (*str_ident[ident].name ? str_ident[ident].name : "UNKNOWN");
+}
+
+static int cmp_label(unsigned short ident, const char *label)
+{
+	if (label && str_ident)
+		return strncmp(str_ident[ident].name,
+				 label, strlen(label));
+	else
+		return -EINVAL;
+}
+
 #ifdef BF537_FAMILY
 static void port_setup(unsigned short gpio, unsigned short usage)
 {
-	if (usage == GPIO_USAGE) {
-		if (*port_fer[gpio_bank(gpio)] & gpio_bit(gpio))
-			printk(KERN_WARNING "bfin-gpio: Possible Conflict with Peripheral "
-			       "usage and GPIO %d detected!\n", gpio);
-		*port_fer[gpio_bank(gpio)] &= ~gpio_bit(gpio);
-	} else
-		*port_fer[gpio_bank(gpio)] |= gpio_bit(gpio);
-	SSYNC();
+	if (!check_gpio(gpio)) {
+		if (usage == GPIO_USAGE) {
+			*port_fer[gpio_bank(gpio)] &= ~gpio_bit(gpio);
+		} else
+			*port_fer[gpio_bank(gpio)] |= gpio_bit(gpio);
+		SSYNC();
+	}
 }
 #else
 # define port_setup(...)  do { } while (0)
 #endif
 
+#ifdef BF537_FAMILY
+
+static struct {
+	unsigned short res;
+	unsigned short offset;
+} port_mux_lut[] = {
+	{.res = P_PPI0_D13, .offset = 11},
+	{.res = P_PPI0_D14, .offset = 11},
+	{.res = P_PPI0_D15, .offset = 11},
+	{.res = P_SPORT1_TFS, .offset = 11},
+	{.res = P_SPORT1_TSCLK, .offset = 11},
+	{.res = P_SPORT1_DTPRI, .offset = 11},
+	{.res = P_PPI0_D10, .offset = 10},
+	{.res = P_PPI0_D11, .offset = 10},
+	{.res = P_PPI0_D12, .offset = 10},
+	{.res = P_SPORT1_RSCLK, .offset = 10},
+	{.res = P_SPORT1_RFS, .offset = 10},
+	{.res = P_SPORT1_DRPRI, .offset = 10},
+	{.res = P_PPI0_D8, .offset = 9},
+	{.res = P_PPI0_D9, .offset = 9},
+	{.res = P_SPORT1_DRSEC, .offset = 9},
+	{.res = P_SPORT1_DTSEC, .offset = 9},
+	{.res = P_TMR2, .offset = 8},
+	{.res = P_PPI0_FS3, .offset = 8},
+	{.res = P_TMR3, .offset = 7},
+	{.res = P_SPI0_SSEL4, .offset = 7},
+	{.res = P_TMR4, .offset = 6},
+	{.res = P_SPI0_SSEL5, .offset = 6},
+	{.res = P_TMR5, .offset = 5},
+	{.res = P_SPI0_SSEL6, .offset = 5},
+	{.res = P_UART1_RX, .offset = 4},
+	{.res = P_UART1_TX, .offset = 4},
+	{.res = P_TMR6, .offset = 4},
+	{.res = P_TMR7, .offset = 4},
+	{.res = P_UART0_RX, .offset = 3},
+	{.res = P_UART0_TX, .offset = 3},
+	{.res = P_DMAR0, .offset = 3},
+	{.res = P_DMAR1, .offset = 3},
+	{.res = P_SPORT0_DTSEC, .offset = 1},
+	{.res = P_SPORT0_DRSEC, .offset = 1},
+	{.res = P_CAN0_RX, .offset = 1},
+	{.res = P_CAN0_TX, .offset = 1},
+	{.res = P_SPI0_SSEL7, .offset = 1},
+	{.res = P_SPORT0_TFS, .offset = 0},
+	{.res = P_SPORT0_DTPRI, .offset = 0},
+	{.res = P_SPI0_SSEL2, .offset = 0},
+	{.res = P_SPI0_SSEL3, .offset = 0},
+};
+
+static void portmux_setup(unsigned short per, unsigned short function)
+{
+	u16 y, offset, muxreg;
+
+	for (y = 0; y < ARRAY_SIZE(port_mux_lut); y++) {
+		if (port_mux_lut[y].res == per) {
+
+			/* SET PORTMUX REG */
+
+			offset = port_mux_lut[y].offset;
+			muxreg = bfin_read_PORT_MUX();
+
+			if (offset != 1) {
+				muxreg &= ~(1 << offset);
+			} else {
+				muxreg &= ~(3 << 1);
+			}
+
+			muxreg |= (function << offset);
+			bfin_write_PORT_MUX(muxreg);
+		}
+	}
+}
+
+#else
+# define portmux_setup(...)  do { } while (0)
+#endif
 
 static void default_gpio(unsigned short gpio)
 {
@@ -179,24 +291,18 @@ static void default_gpio(unsigned short gpio)
 
 static int __init bfin_gpio_init(void)
 {
-	int i;
-
-	printk(KERN_INFO "Blackfin GPIO Controller\n");
+	str_ident = kcalloc(MAX_RESOURCES,
+				 sizeof(struct str_ident), GFP_KERNEL);
+	if (str_ident == NULL)
+		return -ENOMEM;
 
-	for (i = 0; i < MAX_BLACKFIN_GPIOS; i += GPIO_BANKSIZE)
-		reserved_map[gpio_bank(i)] = 0;
+	memset(str_ident, 0, MAX_RESOURCES * sizeof(struct str_ident));
 
-#if defined(BF537_FAMILY) && (defined(CONFIG_BFIN_MAC) || defined(CONFIG_BFIN_MAC_MODULE))
-# if defined(CONFIG_BFIN_MAC_RMII)
-	reserved_map[gpio_bank(PORT_H)] = 0xC373;
-# else
-	reserved_map[gpio_bank(PORT_H)] = 0xFFFF;
-# endif
-#endif
+	printk(KERN_INFO "Blackfin GPIO Controller\n");
 
 	return 0;
-}
 
+}
 arch_initcall(bfin_gpio_init);
 
 
@@ -223,7 +329,7 @@ arch_initcall(bfin_gpio_init);
 void set_gpio_ ## name(unsigned short gpio, unsigned short arg) \
 { \
 	unsigned long flags; \
-	BUG_ON(!(reserved_map[gpio_bank(gpio)] & gpio_bit(gpio))); \
+	BUG_ON(!(reserved_gpio_map[gpio_bank(gpio)] & gpio_bit(gpio))); \
 	local_irq_save(flags); \
 	if (arg) \
 		gpio_bankb[gpio_bank(gpio)]->name |= gpio_bit(gpio); \
@@ -243,7 +349,7 @@ SET_GPIO(both)
 #define SET_GPIO_SC(name) \
 void set_gpio_ ## name(unsigned short gpio, unsigned short arg) \
 { \
-	BUG_ON(!(reserved_map[gpio_bank(gpio)] & gpio_bit(gpio))); \
+	BUG_ON(!(reserved_gpio_map[gpio_bank(gpio)] & gpio_bit(gpio))); \
 	if (arg) \
 		gpio_bankb[gpio_bank(gpio)]->name ## _set = gpio_bit(gpio); \
 	else \
@@ -258,7 +364,7 @@ SET_GPIO_SC(maskb)
 void set_gpio_data(unsigned short gpio, unsigned short arg)
 {
 	unsigned long flags;
-	BUG_ON(!(reserved_map[gpio_bank(gpio)] & gpio_bit(gpio)));
+	BUG_ON(!(reserved_gpio_map[gpio_bank(gpio)] & gpio_bit(gpio)));
 	local_irq_save(flags);
 	if (arg)
 		gpio_bankb[gpio_bank(gpio)]->data_set = gpio_bit(gpio);
@@ -277,7 +383,7 @@ SET_GPIO_SC(data)
 void set_gpio_toggle(unsigned short gpio)
 {
 	unsigned long flags;
-	BUG_ON(!(reserved_map[gpio_bank(gpio)] & gpio_bit(gpio)));
+	BUG_ON(!(reserved_gpio_map[gpio_bank(gpio)] & gpio_bit(gpio)));
 	local_irq_save(flags);
 	gpio_bankb[gpio_bank(gpio)]->toggle = gpio_bit(gpio);
 	bfin_read_CHIPID();
@@ -286,7 +392,7 @@ void set_gpio_toggle(unsigned short gpio)
 #else
 void set_gpio_toggle(unsigned short gpio)
 {
-	BUG_ON(!(reserved_map[gpio_bank(gpio)] & gpio_bit(gpio)));
+	BUG_ON(!(reserved_gpio_map[gpio_bank(gpio)] & gpio_bit(gpio)));
 	gpio_bankb[gpio_bank(gpio)]->toggle = gpio_bit(gpio);
 }
 #endif
@@ -350,7 +456,7 @@ unsigned short get_gpio_data(unsigned short gpio)
 {
 	unsigned long flags;
 	unsigned short ret;
-	BUG_ON(!(reserved_map[gpio_bank(gpio)] & gpio_bit(gpio)));
+	BUG_ON(!(reserved_gpio_map[gpio_bank(gpio)] & gpio_bit(gpio)));
 	local_irq_save(flags);
 	ret = 0x01 & (gpio_bankb[gpio_bank(gpio)]->data >> gpio_sub_n(gpio));
 	bfin_read_CHIPID();
@@ -494,13 +600,14 @@ u32 gpio_pm_setup(void)
 			gpio_bank_saved[bank].dir   = gpio_bankb[bank]->dir;
 			gpio_bank_saved[bank].edge  = gpio_bankb[bank]->edge;
 			gpio_bank_saved[bank].both  = gpio_bankb[bank]->both;
-			gpio_bank_saved[bank].reserved = reserved_map[bank];
+			gpio_bank_saved[bank].reserved =
+						reserved_gpio_map[bank];
 
 			gpio = i;
 
 			while (mask) {
 				if (mask & 1) {
-					reserved_map[gpio_bank(gpio)] |=
+					reserved_gpio_map[gpio_bank(gpio)] |=
 							gpio_bit(gpio);
 					bfin_gpio_wakeup_type(gpio,
 						wakeup_flags_map[gpio]);
@@ -540,7 +647,8 @@ void gpio_pm_restore(void)
 			gpio_bankb[bank]->edge  = gpio_bank_saved[bank].edge;
 			gpio_bankb[bank]->both  = gpio_bank_saved[bank].both;
 
-			reserved_map[bank] = gpio_bank_saved[bank].reserved;
+			reserved_gpio_map[bank] =
+					gpio_bank_saved[bank].reserved;
 
 		}
 
@@ -550,6 +658,147 @@ void gpio_pm_restore(void)
 
 #endif
 
+
+
+
+int peripheral_request(unsigned short per, const char *label)
+{
+	unsigned long flags;
+	unsigned short ident = P_IDENT(per);
+
+	/*
+	 * Don't cares are pins with only one dedicated function
+	 */
+
+	if (per & P_DONTCARE)
+		return 0;
+
+	if (!(per & P_DEFINED))
+		return -ENODEV;
+
+	local_irq_save(flags);
+
+	if (!check_gpio(ident)) {
+
+	if (unlikely(reserved_gpio_map[gpio_bank(ident)] & gpio_bit(ident))) {
+		printk(KERN_ERR
+		       "%s: Peripheral %d is already reserved as GPIO by %s !\n",
+		       __FUNCTION__, ident, get_label(ident));
+		dump_stack();
+		local_irq_restore(flags);
+		return -EBUSY;
+	}
+
+	}
+
+	if (unlikely(reserved_peri_map[gpio_bank(ident)] & gpio_bit(ident))) {
+
+	/*
+	 * Pin functions like AMC address strobes my
+	 * be requested and used by several drivers
+	 */
+
+	if (!(per & P_MAYSHARE)) {
+
+	/*
+	 * Allow that the identical pin function can
+	 * be requested from the same driver twice
+	 */
+
+		if (cmp_label(ident, label) == 0)
+			goto anyway;
+
+			printk(KERN_ERR
+			       "%s: Peripheral %d function %d is already"
+			       " reserved by %s !\n",
+			       __FUNCTION__, ident, P_FUNCT2MUX(per),
+				get_label(ident));
+			dump_stack();
+			local_irq_restore(flags);
+			return -EBUSY;
+		}
+
+	}
+
+anyway:
+
+
+	portmux_setup(per, P_FUNCT2MUX(per));
+
+	port_setup(ident, PERIPHERAL_USAGE);
+
+	reserved_peri_map[gpio_bank(ident)] |= gpio_bit(ident);
+	local_irq_restore(flags);
+	set_label(ident, label);
+
+	return 0;
+}
+EXPORT_SYMBOL(peripheral_request);
+
+int peripheral_request_list(unsigned short per[], const char *label)
+{
+	u16 cnt;
+	int ret;
+
+	for (cnt = 0; per[cnt] != 0; cnt++) {
+
+		ret = peripheral_request(per[cnt], label);
+
+		if (ret < 0) {
+			for ( ; cnt > 0; cnt--) {
+				peripheral_free(per[cnt - 1]);
+			}
+		return ret;
+		}
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(peripheral_request_list);
+
+void peripheral_free(unsigned short per)
+{
+	unsigned long flags;
+	unsigned short ident = P_IDENT(per);
+
+	if (per & P_DONTCARE)
+		return;
+
+	if (!(per & P_DEFINED))
+		return;
+
+	if (check_gpio(ident) < 0)
+		return;
+
+	local_irq_save(flags);
+
+	if (unlikely(!(reserved_peri_map[gpio_bank(ident)]
+			 & gpio_bit(ident)))) {
+		local_irq_restore(flags);
+		return;
+	}
+
+	if (!(per & P_MAYSHARE)) {
+		port_setup(ident, GPIO_USAGE);
+	}
+
+	reserved_peri_map[gpio_bank(ident)] &= ~gpio_bit(ident);
+
+	local_irq_restore(flags);
+}
+EXPORT_SYMBOL(peripheral_free);
+
+void peripheral_free_list(unsigned short per[])
+{
+	u16 cnt;
+
+	for (cnt = 0; per[cnt] != 0; cnt++) {
+		peripheral_free(per[cnt]);
+	}
+
+}
+EXPORT_SYMBOL(peripheral_free_list);
+
 /***********************************************************
 *
 * FUNCTIONS: Blackfin GPIO Driver
@@ -574,13 +823,13 @@ int gpio_request(unsigned short gpio, const char *label)
 
 	local_irq_save(flags);
 
-	if (unlikely(reserved_map[gpio_bank(gpio)] & gpio_bit(gpio))) {
+	if (unlikely(reserved_gpio_map[gpio_bank(gpio)] & gpio_bit(gpio))) {
 		printk(KERN_ERR "bfin-gpio: GPIO %d is already reserved!\n", gpio);
 		dump_stack();
 		local_irq_restore(flags);
 		return -EBUSY;
 	}
-	reserved_map[gpio_bank(gpio)] |= gpio_bit(gpio);
+	reserved_gpio_map[gpio_bank(gpio)] |= gpio_bit(gpio);
 
 	local_irq_restore(flags);
 
@@ -599,7 +848,7 @@ void gpio_free(unsigned short gpio)
 
 	local_irq_save(flags);
 
-	if (unlikely(!(reserved_map[gpio_bank(gpio)] & gpio_bit(gpio)))) {
+	if (unlikely(!(reserved_gpio_map[gpio_bank(gpio)] & gpio_bit(gpio)))) {
 		printk(KERN_ERR "bfin-gpio: GPIO %d wasn't reserved!\n", gpio);
 		dump_stack();
 		local_irq_restore(flags);
@@ -608,7 +857,7 @@ void gpio_free(unsigned short gpio)
 
 	default_gpio(gpio);
 
-	reserved_map[gpio_bank(gpio)] &= ~gpio_bit(gpio);
+	reserved_gpio_map[gpio_bank(gpio)] &= ~gpio_bit(gpio);
 
 	local_irq_restore(flags);
 }
@@ -618,7 +867,7 @@ void gpio_direction_input(unsigned short gpio)
 {
 	unsigned long flags;
 
-	BUG_ON(!(reserved_map[gpio_bank(gpio)] & gpio_bit(gpio)));
+	BUG_ON(!(reserved_gpio_map[gpio_bank(gpio)] & gpio_bit(gpio)));
 
 	local_irq_save(flags);
 	gpio_bankb[gpio_bank(gpio)]->dir &= ~gpio_bit(gpio);
@@ -631,7 +880,7 @@ void gpio_direction_output(unsigned short gpio)
 {
 	unsigned long flags;
 
-	BUG_ON(!(reserved_map[gpio_bank(gpio)] & gpio_bit(gpio)));
+	BUG_ON(!(reserved_gpio_map[gpio_bank(gpio)] & gpio_bit(gpio)));
 
 	local_irq_save(flags);
 	gpio_bankb[gpio_bank(gpio)]->inen &= ~gpio_bit(gpio);
diff --git a/arch/blackfin/mach-bf548/Kconfig b/arch/blackfin/mach-bf548/Kconfig
index e78b03d..3976b7f 100644
--- a/arch/blackfin/mach-bf548/Kconfig
+++ b/arch/blackfin/mach-bf548/Kconfig
@@ -282,7 +282,7 @@ menu "Assignment"
 
 config PINTx_REASSIGN
 	bool "Reprogram PINT Assignment"
-	default n
+	default y
 	help
 	  The interrupt assignment registers controls the pin-to-interrupt
 	  assignment in a byte-wide manner. Each option allows you to select
@@ -303,7 +303,7 @@ config PINT1_ASSIGN
 config PINT2_ASSIGN
 	hex "PINT2_ASSIGN"
 	depends on PINTx_REASSIGN
-	default 0x00000101
+	default 0x07000101
 config PINT3_ASSIGN
 	hex "PINT3_ASSIGN"
 	depends on PINTx_REASSIGN
diff --git a/arch/blackfin/mach-bf548/boards/ezkit.c b/arch/blackfin/mach-bf548/boards/ezkit.c
index 96ad95f..59e64c5 100644
--- a/arch/blackfin/mach-bf548/boards/ezkit.c
+++ b/arch/blackfin/mach-bf548/boards/ezkit.c
@@ -35,9 +35,13 @@
 #include <linux/spi/spi.h>
 #include <linux/spi/flash.h>
 #include <linux/irq.h>
-#include <linux/irq.h>
 #include <linux/interrupt.h>
 #include <asm/bfin5xx_spi.h>
+#include <asm/dma.h>
+#include <asm/gpio.h>
+#include <asm/mach/nand.h>
+#include <asm/mach/bf54x_keys.h>
+#include <linux/spi/ad7877.h>
 
 /*
  * Name the Board for the /proc/cpuinfo
@@ -48,6 +52,87 @@ char *bfin_board_name = "ADSP-BF548-EZKIT";
  *  Driver needs to know address, irq and flag pin.
  */
 
+#if defined(CONFIG_FB_BF54X_LQ043) || defined(CONFIG_FB_BF54X_LQ043_MODULE)
+
+#include <asm/mach/bf54x-lq043.h>
+
+static struct bfin_bf54xfb_mach_info bf54x_lq043_data = {
+	.width =	480,
+	.height =	272,
+	.xres =		{480, 480, 480},
+	.yres =		{272, 272, 272},
+	.bpp =		{24, 24, 24},
+	.disp =		GPIO_PE3,
+};
+
+static struct resource bf54x_lq043_resources[] = {
+	{
+		.start = IRQ_EPPI0_ERR,
+		.end = IRQ_EPPI0_ERR,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device bf54x_lq043_device = {
+	.name		= "bf54x-lq043",
+	.id		= -1,
+	.num_resources 	= ARRAY_SIZE(bf54x_lq043_resources),
+	.resource 	= bf54x_lq043_resources,
+	.dev		= {
+		.platform_data = &bf54x_lq043_data,
+	},
+};
+#endif
+
+#if defined(CONFIG_KEYBOARD_BFIN) || defined(CONFIG_KEYBOARD_BFIN_MODULE)
+static int bf548_keymap[] = {
+	KEYVAL(0, 0, KEY_ENTER),
+	KEYVAL(0, 1, KEY_HELP),
+	KEYVAL(0, 2, KEY_0),
+	KEYVAL(0, 3, KEY_BACKSPACE),
+	KEYVAL(1, 0, KEY_TAB),
+	KEYVAL(1, 1, KEY_9),
+	KEYVAL(1, 2, KEY_8),
+	KEYVAL(1, 3, KEY_7),
+	KEYVAL(2, 0, KEY_DOWN),
+	KEYVAL(2, 1, KEY_6),
+	KEYVAL(2, 2, KEY_5),
+	KEYVAL(2, 3, KEY_4),
+	KEYVAL(3, 0, KEY_UP),
+	KEYVAL(3, 1, KEY_3),
+	KEYVAL(3, 2, KEY_2),
+	KEYVAL(3, 3, KEY_1),
+};
+
+static struct bfin_kpad_platform_data bf54x_kpad_data = {
+	.rows			= 4,
+	.cols			= 4,
+	.keymap 		= bf548_keymap,
+	.keymapsize 		= ARRAY_SIZE(bf548_keymap),
+	.debounce_time		= 5000,	/* ns (5ms) */
+	.coldrive_time		= 1000, /* ns (1ms) */
+	.keyup_test_interval	= 50, /* ms (50ms) */
+};
+
+static struct resource bf54x_kpad_resources[] = {
+	{
+		.start = IRQ_KEY,
+		.end = IRQ_KEY,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device bf54x_kpad_device = {
+	.name		= "bf54x-keys",
+	.id		= -1,
+	.num_resources 	= ARRAY_SIZE(bf54x_kpad_resources),
+	.resource 	= bf54x_kpad_resources,
+	.dev		= {
+		.platform_data = &bf54x_kpad_data,
+	},
+};
+#endif
+
 #if defined(CONFIG_RTC_DRV_BFIN) || defined(CONFIG_RTC_DRV_BFIN_MODULE)
 static struct platform_device rtc_device = {
 	.name = "rtc-bfin",
@@ -94,6 +179,248 @@ static struct platform_device bfin_uart_device = {
 };
 #endif
 
+#if defined(CONFIG_SMSC911X) || defined(CONFIG_SMSC911X_MODULE)
+static struct resource smsc911x_resources[] = {
+	{
+		.name = "smsc911x-memory",
+		.start = 0x24000000,
+		.end = 0x24000000 + 0xFF,
+		.flags = IORESOURCE_MEM,
+	},
+	{
+		.start = IRQ_PE8,
+		.end = IRQ_PE8,
+		.flags = IORESOURCE_IRQ | IORESOURCE_IRQ_LOWLEVEL,
+	},
+};
+static struct platform_device smsc911x_device = {
+	.name = "smsc911x",
+	.id = 0,
+	.num_resources = ARRAY_SIZE(smsc911x_resources),
+	.resource = smsc911x_resources,
+};
+#endif
+
+#if defined(CONFIG_USB_BF54x_HCD) || defined(CONFIG_USB_BF54x_HCD_MODULE)
+static struct resource bf54x_hcd_resources[] = {
+	{
+		.start = 0xFFC03C00,
+		.end = 0xFFC040FF,
+		.flags = IORESOURCE_MEM,
+	},
+};
+
+static struct platform_device bf54x_hcd = {
+	.name = "bf54x-hcd",
+	.id = 0,
+	.num_resources = ARRAY_SIZE(bf54x_hcd_resources),
+	.resource = bf54x_hcd_resources,
+};
+#endif
+
+#if defined(CONFIG_PATA_BF54X) || defined(CONFIG_PATA_BF54X_MODULE)
+static struct resource bfin_atapi_resources[] = {
+	{
+		.start = 0xFFC03800,
+		.end = 0xFFC0386F,
+		.flags = IORESOURCE_MEM,
+	},
+	{
+		.start = IRQ_ATAPI_ERR,
+		.end = IRQ_ATAPI_ERR,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device bfin_atapi_device = {
+	.name = "bf54x-atapi",
+	.id = -1,
+	.num_resources = ARRAY_SIZE(bfin_atapi_resources),
+	.resource = bfin_atapi_resources,
+};
+#endif
+
+#if defined(CONFIG_MTD_NAND_BF54X) || defined(CONFIG_MTD_NAND_BF54X_MODULE)
+static struct mtd_partition partition_info[] = {
+	{
+		.name = "Linux Kernel",
+		.offset = 0,
+		.size = 4 * SIZE_1M,
+	},
+	{
+		.name = "File System",
+		.offset = 4 * SIZE_1M,
+		.size = (256 - 4) * SIZE_1M,
+	},
+};
+
+static struct bf54x_nand_platform bf54x_nand_platform = {
+	.page_size = NFC_PG_SIZE_256,
+	.data_width = NFC_NWIDTH_8,
+	.partitions = partition_info,
+	.nr_partitions = ARRAY_SIZE(partition_info),
+	.rd_dly = 3,
+	.wr_dly = 3,
+};
+
+static struct resource bf54x_nand_resources[] = {
+	{
+		.start = 0xFFC03B00,
+		.end = 0xFFC03B4F,
+		.flags = IORESOURCE_MEM,
+	},
+	{
+		.start = CH_NFC,
+		.end = CH_NFC,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device bf54x_nand_device = {
+	.name = "bf54x-nand",
+	.id = 0,
+	.num_resources = ARRAY_SIZE(bf54x_nand_resources),
+	.resource = bf54x_nand_resources,
+	.dev = {
+		.platform_data = &bf54x_nand_platform,
+	},
+};
+#endif
+
+#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+/* all SPI peripherals info goes here */
+#if defined(CONFIG_MTD_M25P80) \
+	|| defined(CONFIG_MTD_M25P80_MODULE)
+/* SPI flash chip (m25p16) */
+static struct mtd_partition bfin_spi_flash_partitions[] = {
+	{
+		.name = "bootloader",
+		.size = 0x00030000,
+		.offset = 0,
+		.mask_flags = MTD_CAP_ROM
+	}, {
+		.name = "linux kernel",
+		.size = 0x1d0000,
+		.offset = 0x30000
+	}
+};
+
+static struct flash_platform_data bfin_spi_flash_data = {
+	.name = "m25p80",
+	.parts = bfin_spi_flash_partitions,
+	.nr_parts = ARRAY_SIZE(bfin_spi_flash_partitions),
+	.type = "m25p16",
+};
+
+static struct bfin5xx_spi_chip spi_flash_chip_info = {
+	.enable_dma = 0,         /* use dma transfer with this chip*/
+	.bits_per_word = 8,
+	.cs_change_per_word = 0,
+};
+#endif
+
+#if defined(CONFIG_TOUCHSCREEN_AD7877) || defined(CONFIG_TOUCHSCREEN_AD7877_MODULE)
+static struct bfin5xx_spi_chip spi_ad7877_chip_info = {
+	.cs_change_per_word = 1,
+	.enable_dma = 0,
+	.bits_per_word = 16,
+};
+
+static const struct ad7877_platform_data bfin_ad7877_ts_info = {
+	.model			= 7877,
+	.vref_delay_usecs	= 50,	/* internal, no capacitor */
+	.x_plate_ohms		= 419,
+	.y_plate_ohms		= 486,
+	.pressure_max		= 1000,
+	.pressure_min		= 0,
+	.stopacq_polarity 	= 1,
+	.first_conversion_delay = 3,
+	.acquisition_time 	= 1,
+	.averaging 		= 1,
+	.pen_down_acc_interval 	= 1,
+};
+#endif
+
+static struct spi_board_info bf54x_spi_board_info[] __initdata = {
+#if defined(CONFIG_MTD_M25P80) \
+	|| defined(CONFIG_MTD_M25P80_MODULE)
+	{
+		/* the modalias must be the same as spi device driver name */
+		.modalias = "m25p80", /* Name of spi_driver for this device */
+		.max_speed_hz = 25000000,     /* max spi clock (SCK) speed in HZ */
+		.bus_num = 0, /* Framework bus number */
+		.chip_select = 1, /* SPI_SSEL1*/
+		.platform_data = &bfin_spi_flash_data,
+		.controller_data = &spi_flash_chip_info,
+		.mode = SPI_MODE_3,
+	},
+#endif
+#if defined(CONFIG_TOUCHSCREEN_AD7877) || defined(CONFIG_TOUCHSCREEN_AD7877_MODULE)
+{
+	.modalias		= "ad7877",
+	.platform_data		= &bfin_ad7877_ts_info,
+	.irq			= IRQ_PJ11,
+	.max_speed_hz		= 12500000,     /* max spi clock (SCK) speed in HZ */
+	.bus_num		= 1,
+	.chip_select  		= 2,
+	.controller_data = &spi_ad7877_chip_info,
+},
+#endif
+};
+
+/* SPI (0) */
+static struct resource bfin_spi0_resource[] = {
+	[0] = {
+		.start = SPI0_REGBASE,
+		.end   = SPI0_REGBASE + 0xFF,
+		.flags = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start = CH_SPI0,
+		.end   = CH_SPI0,
+		.flags = IORESOURCE_IRQ,
+	}
+};
+
+/* SPI controller data */
+static struct bfin5xx_spi_master bf54x_spi_master_info = {
+	.num_chipselect = 8,
+	.enable_dma = 1,  /* master has the ability to do dma transfer */
+};
+
+static struct platform_device bf54x_spi_master_device = {
+	.name = "bfin-spi",
+	.id = 0, /* Bus number */
+	.num_resources = ARRAY_SIZE(bfin_spi0_resource),
+	.resource = bfin_spi0_resource,
+	.dev = {
+		.platform_data = &bf54x_spi_master_info, /* Passed to driver */
+		},
+};
+#endif  /* spi master and devices */
+
+#if defined(CONFIG_I2C_BLACKFIN_TWI) || defined(CONFIG_I2C_BLACKFIN_TWI_MODULE)
+static struct resource bfin_twi0_resource[] = {
+	[0] = {
+		.start = 0xFFC01400,
+		.end   = 0xFFC014FF,
+		.flags = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start = IRQ_TWI0,
+		.end   = IRQ_TWI0,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device i2c_bfin_twi0_device = {
+	.name = "i2c-bfin-twi",
+	.id = 0,
+	.num_resources = ARRAY_SIZE(bfin_twi0_resource),
+	.resource = bfin_twi0_resource,
+};
+#endif
+
 static struct platform_device *ezkit_devices[] __initdata = {
 #if defined(CONFIG_RTC_DRV_BFIN) || defined(CONFIG_RTC_DRV_BFIN_MODULE)
 	&rtc_device,
@@ -102,12 +429,50 @@ static struct platform_device *ezkit_devices[] __initdata = {
 #if defined(CONFIG_SERIAL_BFIN) || defined(CONFIG_SERIAL_BFIN_MODULE)
 	&bfin_uart_device,
 #endif
+
+#if defined(CONFIG_FB_BF54X_LQ043) || defined(CONFIG_FB_BF54X_LQ043_MODULE)
+	&bf54x_lq043_device,
+#endif
+
+#if defined(CONFIG_SMSC911X) || defined(CONFIG_SMSC911X_MODULE)
+	&smsc911x_device,
+#endif
+
+#if defined(CONFIG_USB_BF54x_HCD) || defined(CONFIG_USB_BF54x_HCD_MODULE)
+	&bf54x_hcd,
+#endif
+
+#if defined(CONFIG_PATA_BF54X) || defined(CONFIG_PATA_BF54X_MODULE)
+	&bfin_atapi_device,
+#endif
+
+#if defined(CONFIG_MTD_NAND_BF54X) || defined(CONFIG_MTD_NAND_BF54X_MODULE)
+	&bf54x_nand_device,
+#endif
+
+#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+	&bf54x_spi_master_device,
+#endif
+
+#if defined(CONFIG_KEYBOARD_BFIN) || defined(CONFIG_KEYBOARD_BFIN_MODULE)
+	&bf54x_kpad_device,
+#endif
+
+#if defined(CONFIG_I2C_BLACKFIN_TWI) || defined(CONFIG_I2C_BLACKFIN_TWI_MODULE)
+	&i2c_bfin_twi0_device,
+#endif
 };
 
 static int __init stamp_init(void)
 {
 	printk(KERN_INFO "%s(): registering device resources\n", __FUNCTION__);
 	platform_add_devices(ezkit_devices, ARRAY_SIZE(ezkit_devices));
+
+#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+	spi_register_board_info(bf54x_spi_board_info,
+			ARRAY_SIZE(bf54x_spi_board_info));
+#endif
+
 	return 0;
 }
 
diff --git a/arch/blackfin/mach-bf548/gpio.c b/arch/blackfin/mach-bf548/gpio.c
index 0da5f00..390dd8c 100644
--- a/arch/blackfin/mach-bf548/gpio.c
+++ b/arch/blackfin/mach-bf548/gpio.c
@@ -50,6 +50,13 @@ static struct gpio_port_t *gpio_array[gpio_bank(MAX_BLACKFIN_GPIOS)] = {
 static unsigned short reserved_gpio_map[gpio_bank(MAX_BLACKFIN_GPIOS)];
 static unsigned short reserved_peri_map[gpio_bank(MAX_BLACKFIN_GPIOS)];
 
+#define MAX_RESOURCES 		256
+#define RESOURCE_LABEL_SIZE 	16
+
+struct str_ident {
+	char name[RESOURCE_LABEL_SIZE];
+} *str_ident;
+
 inline int check_gpio(unsigned short gpio)
 {
 	if (gpio == GPIO_PB15 || gpio == GPIO_PC14 || gpio == GPIO_PC15
@@ -70,7 +77,6 @@ inline void portmux_setup(unsigned short portno, unsigned short function)
 	pmux |= (function & 0x3) << (2 * gpio_sub_n(portno));
 
 	gpio_array[gpio_bank(portno)]->port_mux = pmux;
-
 }
 
 inline u16 get_portmux(unsigned short portno)
@@ -80,16 +86,11 @@ inline u16 get_portmux(unsigned short portno)
 	pmux = gpio_array[gpio_bank(portno)]->port_mux;
 
 	return (pmux >> (2 * gpio_sub_n(portno)) & 0x3);
-
 }
 
 static void port_setup(unsigned short gpio, unsigned short usage)
 {
 	if (usage == GPIO_USAGE) {
-		if (gpio_array[gpio_bank(gpio)]->port_fer & gpio_bit(gpio))
-			printk(KERN_WARNING
-			       "bfin-gpio: Possible Conflict with Peripheral "
-			       "usage and GPIO %d detected!\n", gpio);
 		gpio_array[gpio_bank(gpio)]->port_fer &= ~gpio_bit(gpio);
 	} else
 		gpio_array[gpio_bank(gpio)]->port_fer |= gpio_bit(gpio);
@@ -98,6 +99,14 @@ static void port_setup(unsigned short gpio, unsigned short usage)
 
 static int __init bfin_gpio_init(void)
 {
+
+	str_ident = kcalloc(MAX_RESOURCES,
+				 sizeof(struct str_ident), GFP_KERNEL);
+	if (str_ident == NULL)
+		return -ENOMEM;
+
+	memset(str_ident, 0, MAX_RESOURCES * sizeof(struct str_ident));
+
 	printk(KERN_INFO "Blackfin GPIO Controller\n");
 
 	return 0;
@@ -105,11 +114,45 @@ static int __init bfin_gpio_init(void)
 
 arch_initcall(bfin_gpio_init);
 
+static void set_label(unsigned short ident, const char *label)
+{
+
+	if (label && str_ident) {
+		strncpy(str_ident[ident].name, label,
+			 RESOURCE_LABEL_SIZE);
+		str_ident[ident].name[RESOURCE_LABEL_SIZE - 1] = 0;
+	}
+}
+
+static char *get_label(unsigned short ident)
+{
+	if (!str_ident)
+		return "UNKNOWN";
+
+	return (*str_ident[ident].name ? str_ident[ident].name : "UNKNOWN");
+}
+
+static int cmp_label(unsigned short ident, const char *label)
+{
+	if (label && str_ident)
+		return strncmp(str_ident[ident].name,
+				 label, strlen(label));
+	else
+		return -EINVAL;
+}
+
 int peripheral_request(unsigned short per, const char *label)
 {
 	unsigned long flags;
 	unsigned short ident = P_IDENT(per);
 
+	/*
+	 * Don't cares are pins with only one dedicated function
+	 */
+
+	if (per & P_DONTCARE)
+		return 0;
+
 	if (!(per & P_DEFINED))
 		return -ENODEV;
 
@@ -120,8 +163,8 @@ int peripheral_request(unsigned short per, const char *label)
 
 	if (unlikely(reserved_gpio_map[gpio_bank(ident)] & gpio_bit(ident))) {
 		printk(KERN_ERR
-		       "%s: Peripheral %d is already reserved as GPIO!\n",
-		       __FUNCTION__, per);
+		       "%s: Peripheral %d is already reserved as GPIO by %s !\n",
+		       __FUNCTION__, ident, get_label(ident));
 		dump_stack();
 		local_irq_restore(flags);
 		return -EBUSY;
@@ -131,22 +174,38 @@ int peripheral_request(unsigned short per, const char *label)
 
 		u16 funct = get_portmux(ident);
 
+	/*
+	 * Pin functions like AMC address strobes my
+	 * be requested and used by several drivers
+	 */
+
 		if (!((per & P_MAYSHARE) && (funct == P_FUNCT2MUX(per)))) {
+
+		/*
+		 * Allow that the identical pin function can
+		 * be requested from the same driver twice
+		 */
+
+		if (cmp_label(ident, label) == 0)
+			goto anyway;
+
 			printk(KERN_ERR
-			       "%s: Peripheral %d is already reserved!\n",
-			       __FUNCTION__, per);
+			       "%s: Peripheral %d function %d is already reserved by %s !\n",
+			       __FUNCTION__, ident, P_FUNCT2MUX(per), get_label(ident));
 			dump_stack();
 			local_irq_restore(flags);
 			return -EBUSY;
 		}
 	}
 
+anyway:
 	reserved_peri_map[gpio_bank(ident)] |= gpio_bit(ident);
 
 	portmux_setup(ident, P_FUNCT2MUX(per));
 	port_setup(ident, PERIPHERAL_USAGE);
 
 	local_irq_restore(flags);
+	set_label(ident, label);
 
 	return 0;
 }
@@ -154,16 +213,22 @@ EXPORT_SYMBOL(peripheral_request);
 
 int peripheral_request_list(unsigned short per[], const char *label)
 {
-
 	u16 cnt;
 	int ret;
 
 	for (cnt = 0; per[cnt] != 0; cnt++) {
+
 		ret = peripheral_request(per[cnt], label);
-		if (ret < 0)
-			return ret;
+
+		if (ret < 0) {
+			for ( ; cnt > 0; cnt--) {
+				peripheral_free(per[cnt - 1]);
+			}
+		return ret;
+		}
 	}
 
+
 	return 0;
 }
 EXPORT_SYMBOL(peripheral_request_list);
@@ -173,6 +238,9 @@ void peripheral_free(unsigned short per)
 	unsigned long flags;
 	unsigned short ident = P_IDENT(per);
 
+	if (per & P_DONTCARE)
+		return;
+
 	if (!(per & P_DEFINED))
 		return;
 
@@ -182,8 +250,6 @@ void peripheral_free(unsigned short per)
 	local_irq_save(flags);
 
 	if (unlikely(!(reserved_peri_map[gpio_bank(ident)] & gpio_bit(ident)))) {
-		printk(KERN_ERR "bfin-gpio: Peripheral %d wasn't reserved!\n", per);
-		dump_stack();
 		local_irq_restore(flags);
 		return;
 	}
@@ -234,7 +300,8 @@ int gpio_request(unsigned short gpio, const char *label)
 	local_irq_save(flags);
 
 	if (unlikely(reserved_gpio_map[gpio_bank(gpio)] & gpio_bit(gpio))) {
-		printk(KERN_ERR "bfin-gpio: GPIO %d is already reserved!\n", gpio);
+		printk(KERN_ERR "bfin-gpio: GPIO %d is already reserved by %s !\n",
+			 gpio, get_label(gpio));
 		dump_stack();
 		local_irq_restore(flags);
 		return -EBUSY;
@@ -242,7 +309,8 @@ int gpio_request(unsigned short gpio, const char *label)
 
 	if (unlikely(reserved_peri_map[gpio_bank(gpio)] & gpio_bit(gpio))) {
 		printk(KERN_ERR
-		       "bfin-gpio: GPIO %d is already reserved as Peripheral!\n", gpio);
+		       "bfin-gpio: GPIO %d is already reserved as Peripheral by %s !\n",
+		       gpio, get_label(gpio));
 		dump_stack();
 		local_irq_restore(flags);
 		return -EBUSY;
@@ -253,6 +321,7 @@ int gpio_request(unsigned short gpio, const char *label)
 	local_irq_restore(flags);
 
 	port_setup(gpio, GPIO_USAGE);
+	set_label(gpio, label);
 
 	return 0;
 }
diff --git a/arch/blackfin/mach-common/ints-priority-dc.c b/arch/blackfin/mach-common/ints-priority-dc.c
index 660f881..d5d9e57 100644
--- a/arch/blackfin/mach-common/ints-priority-dc.c
+++ b/arch/blackfin/mach-common/ints-priority-dc.c
@@ -221,7 +221,7 @@ static unsigned int bf561_gpio_irq_startup(unsigned int irq)
 
 	if (!(gpio_enabled[gpio_bank(gpionr)] & gpio_bit(gpionr))) {
 
-		ret = gpio_request(gpionr, NULL);
+		ret = gpio_request(gpionr, "IRQ");
 		if (ret)
 			return ret;
 
@@ -261,7 +261,7 @@ static int bf561_gpio_irq_type(unsigned int irq, unsigned int type)
 
 		if (!(gpio_enabled[gpio_bank(gpionr)] & gpio_bit(gpionr))) {
 
-			ret = gpio_request(gpionr, NULL);
+			ret = gpio_request(gpionr, "IRQ");
 			if (ret)
 				return ret;
 
diff --git a/arch/blackfin/mach-common/ints-priority-sc.c b/arch/blackfin/mach-common/ints-priority-sc.c
index 4708023..505b948 100644
--- a/arch/blackfin/mach-common/ints-priority-sc.c
+++ b/arch/blackfin/mach-common/ints-priority-sc.c
@@ -343,7 +343,7 @@ static unsigned int bfin_gpio_irq_startup(unsigned int irq)
 	u16 gpionr = irq - IRQ_PF0;
 
 	if (!(gpio_enabled[gpio_bank(gpionr)] & gpio_bit(gpionr))) {
-		ret = gpio_request(gpionr, NULL);
+		ret = gpio_request(gpionr, "IRQ");
 		if (ret)
 			return ret;
 	}
@@ -377,7 +377,7 @@ static int bfin_gpio_irq_type(unsigned int irq, unsigned int type)
 	if (type & (IRQ_TYPE_EDGE_RISING | IRQ_TYPE_EDGE_FALLING |
 		    IRQ_TYPE_LEVEL_HIGH | IRQ_TYPE_LEVEL_LOW)) {
 		if (!(gpio_enabled[gpio_bank(gpionr)] & gpio_bit(gpionr))) {
-			ret = gpio_request(gpionr, NULL);
+			ret = gpio_request(gpionr, "IRQ");
 			if (ret)
 				return ret;
 		}
@@ -587,7 +587,7 @@ static unsigned int bfin_gpio_irq_startup(unsigned int irq)
 	}
 
 	if (!(gpio_enabled[gpio_bank(gpionr)] & gpio_bit(gpionr))) {
-		ret = gpio_request(gpionr, NULL);
+		ret = gpio_request(gpionr, "IRQ");
 		if (ret)
 			return ret;
 	}
@@ -627,7 +627,7 @@ static int bfin_gpio_irq_type(unsigned int irq, unsigned int type)
 	if (type & (IRQ_TYPE_EDGE_RISING | IRQ_TYPE_EDGE_FALLING |
 		    IRQ_TYPE_LEVEL_HIGH | IRQ_TYPE_LEVEL_LOW)) {
 		if (!(gpio_enabled[gpio_bank(gpionr)] & gpio_bit(gpionr))) {
-			ret = gpio_request(gpionr, NULL);
+			ret = gpio_request(gpionr, "IRQ");
 			if (ret)
 				return ret;
 		}
diff --git a/include/asm-blackfin/gpio.h b/include/asm-blackfin/gpio.h
index 7480cfa..dd203cd 100644
--- a/include/asm-blackfin/gpio.h
+++ b/include/asm-blackfin/gpio.h
@@ -144,6 +144,24 @@
 
 #ifdef BF533_FAMILY
 #define MAX_BLACKFIN_GPIOS 16
+
+#define	GPIO_PF0	0
+#define	GPIO_PF1	1
+#define	GPIO_PF2	2
+#define	GPIO_PF3	3
+#define	GPIO_PF4	4
+#define	GPIO_PF5	5
+#define	GPIO_PF6	6
+#define	GPIO_PF7	7
+#define	GPIO_PF8	8
+#define	GPIO_PF9	9
+#define	GPIO_PF10	10
+#define	GPIO_PF11	11
+#define	GPIO_PF12	12
+#define	GPIO_PF13	13
+#define	GPIO_PF14	14
+#define	GPIO_PF15	15
+
 #endif
 
 #ifdef BF537_FAMILY
@@ -421,6 +439,19 @@ unsigned short gpio_get_value(unsigned short gpio);
 void gpio_direction_input(unsigned short gpio);
 void gpio_direction_output(unsigned short gpio);
 
+#include <asm-generic/gpio.h>		/* cansleep wrappers */
+#include <asm/irq.h>
+
+static inline int gpio_to_irq(unsigned gpio)
+{
+	return (gpio + GPIO_IRQ_BASE);
+}
+
+static inline int irq_to_gpio(unsigned irq)
+{
+	return (irq - GPIO_IRQ_BASE);
+}
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* __ARCH_BLACKFIN_GPIO_H__ */
diff --git a/include/asm-blackfin/mach-bf533/bfin_serial_5xx.h b/include/asm-blackfin/mach-bf533/bfin_serial_5xx.h
index e043caf..69b9f8e 100644
--- a/include/asm-blackfin/mach-bf533/bfin_serial_5xx.h
+++ b/include/asm-blackfin/mach-bf533/bfin_serial_5xx.h
@@ -1,5 +1,6 @@
 #include <linux/serial.h>
 #include <asm/dma.h>
+#include <asm/portmux.h>
 
 #define NR_PORTS                1
 
@@ -92,18 +93,24 @@ struct bfin_serial_res bfin_serial_resource[] = {
 	}
 };
 
+#define DRIVER_NAME "bfin-uart"
 
 int nr_ports = NR_PORTS;
 static void bfin_serial_hw_init(struct bfin_serial_port *uart)
 {
 
+#ifdef CONFIG_SERIAL_BFIN_UART0
+	peripheral_request(P_UART0_TX, DRIVER_NAME);
+	peripheral_request(P_UART0_RX, DRIVER_NAME);
+#endif
+
 #ifdef CONFIG_SERIAL_BFIN_CTSRTS
 	if (uart->cts_pin >= 0) {
-		gpio_request(uart->cts_pin, NULL);
+		gpio_request(uart->cts_pin, DRIVER_NAME);
 		gpio_direction_input(uart->cts_pin);
 	}
 	if (uart->rts_pin >= 0) {
-		gpio_request(uart->rts_pin, NULL);
+		gpio_request(uart->rts_pin, DRIVER_NAME);
 		gpio_direction_input(uart->rts_pin);
 	}
 #endif
diff --git a/include/asm-blackfin/mach-bf533/blackfin.h b/include/asm-blackfin/mach-bf533/blackfin.h
index e438449..f3b240a 100644
--- a/include/asm-blackfin/mach-bf533/blackfin.h
+++ b/include/asm-blackfin/mach-bf533/blackfin.h
@@ -38,7 +38,7 @@
 #include "defBF532.h"
 #include "anomaly.h"
 
-#if !(defined(__ASSEMBLY__) || defined(ASSEMBLY))
+#if !defined(__ASSEMBLY__)
 #include "cdefBF532.h"
 #endif
 
diff --git a/include/asm-blackfin/mach-bf533/irq.h b/include/asm-blackfin/mach-bf533/irq.h
index 9879e68..452fb82 100644
--- a/include/asm-blackfin/mach-bf533/irq.h
+++ b/include/asm-blackfin/mach-bf533/irq.h
@@ -128,6 +128,8 @@ Core        Emulation               **
 #define IRQ_PF14		47
 #define IRQ_PF15		48
 
+#define GPIO_IRQ_BASE		IRQ_PF0
+
 #ifdef CONFIG_IRQCHIP_DEMUX_GPIO
 #define	NR_IRQS		(IRQ_PF15+1)
 #else
diff --git a/include/asm-blackfin/mach-bf537/bfin_serial_5xx.h b/include/asm-blackfin/mach-bf537/bfin_serial_5xx.h
index 8f5d9c4..6fb328f 100644
--- a/include/asm-blackfin/mach-bf537/bfin_serial_5xx.h
+++ b/include/asm-blackfin/mach-bf537/bfin_serial_5xx.h
@@ -1,5 +1,6 @@
 #include <linux/serial.h>
 #include <asm/dma.h>
+#include <asm/portmux.h>
 
 #define NR_PORTS		2
 
@@ -122,25 +123,29 @@ struct bfin_serial_res bfin_serial_resource[] = {
 
 int nr_ports = ARRAY_SIZE(bfin_serial_resource);
 
+#define DRIVER_NAME "bfin-uart"
+
 static void bfin_serial_hw_init(struct bfin_serial_port *uart)
 {
-	unsigned short val;
-	val = bfin_read16(BFIN_PORT_MUX);
-	val &= ~(PFDE | PFTE);
-	bfin_write16(BFIN_PORT_MUX, val);
 
-	val = bfin_read16(PORTF_FER);
-	val |= 0xF;
-	bfin_write16(PORTF_FER, val);
+#ifdef CONFIG_SERIAL_BFIN_UART0
+	peripheral_request(P_UART0_TX, DRIVER_NAME);
+	peripheral_request(P_UART0_RX, DRIVER_NAME);
+#endif
+
+#ifdef CONFIG_SERIAL_BFIN_UART1
+	peripheral_request(P_UART1_TX, DRIVER_NAME);
+	peripheral_request(P_UART1_RX, DRIVER_NAME);
+#endif
 
 #ifdef CONFIG_SERIAL_BFIN_CTSRTS
 	if (uart->cts_pin >= 0) {
-		gpio_request(uart->cts_pin, NULL);
+		gpio_request(uart->cts_pin, DRIVER_NAME);
 		gpio_direction_input(uart->cts_pin);
 	}
 
 	if (uart->rts_pin >= 0) {
-		gpio_request(uart->rts_pin, NULL);
+		gpio_request(uart->rts_pin, DRIVER_NAME);
 		gpio_direction_output(uart->rts_pin);
 	}
 #endif
diff --git a/include/asm-blackfin/mach-bf537/blackfin.h b/include/asm-blackfin/mach-bf537/blackfin.h
index bbd9705..f196588 100644
--- a/include/asm-blackfin/mach-bf537/blackfin.h
+++ b/include/asm-blackfin/mach-bf537/blackfin.h
@@ -43,7 +43,7 @@
 #include "defBF537.h"
 #endif
 
-#if !(defined(__ASSEMBLY__) || defined(ASSEMBLY))
+#if !defined(__ASSEMBLY__)
 #include "cdefBF534.h"
 
 /* UART 0*/
diff --git a/include/asm-blackfin/mach-bf537/irq.h b/include/asm-blackfin/mach-bf537/irq.h
index 8af2a83..36c44bc 100644
--- a/include/asm-blackfin/mach-bf537/irq.h
+++ b/include/asm-blackfin/mach-bf537/irq.h
@@ -160,6 +160,8 @@ Core        Emulation               **
 #define IRQ_PH14        96
 #define IRQ_PH15        97
 
+#define GPIO_IRQ_BASE	IRQ_PF0
+
 #ifdef CONFIG_IRQCHIP_DEMUX_GPIO
 #define NR_IRQS     (IRQ_PH15+1)
 #else
diff --git a/include/asm-blackfin/mach-bf537/portmux.h b/include/asm-blackfin/mach-bf537/portmux.h
index 23e13c5..ae6c53b 100644
--- a/include/asm-blackfin/mach-bf537/portmux.h
+++ b/include/asm-blackfin/mach-bf537/portmux.h
@@ -106,4 +106,37 @@
 #define P_SPI0_SSEL2	(P_DEFINED | P_IDENT(PORT_PJ11) | P_FUNCT(1))
 #define P_SPI0_SSEL7	(P_DEFINED | P_IDENT(PORT_PJ5) | P_FUNCT(2))
 
-#endif /* _MACH_PORTMUX_H_ */
+#define P_MII0 {\
+	P_MII0_ETxD0, \
+	P_MII0_ETxD1, \
+	P_MII0_ETxD2, \
+	P_MII0_ETxD3, \
+	P_MII0_ETxEN, \
+	P_MII0_TxCLK, \
+	P_MII0_PHYINT, \
+	P_MII0_COL, \
+	P_MII0_ERxD0, \
+	P_MII0_ERxD1, \
+	P_MII0_ERxD2, \
+	P_MII0_ERxD3, \
+	P_MII0_ERxDV, \
+	P_MII0_ERxCLK, \
+	P_MII0_ERxER, \
+	P_MII0_CRS, \
+	P_MDC, \
+	P_MDIO, 0}
+
+
+#define P_RMII0 {\
+	P_MII0_ETxD0, \
+	P_MII0_ETxD1, \
+	P_MII0_ETxEN, \
+	P_MII0_ERxD0, \
+	P_MII0_ERxD1, \
+	P_MII0_ERxER, \
+	P_RMII0_REF_CLK, \
+	P_RMII0_MDINT, \
+	P_RMII0_CRS_DV, \
+	P_MDC, \
+	P_MDIO, 0}
+#endif			        	/* _MACH_PORTMUX_H_ */
diff --git a/include/asm-blackfin/mach-bf548/bfin_serial_5xx.h b/include/asm-blackfin/mach-bf548/bfin_serial_5xx.h
index 2f4afc9..f21a162 100644
--- a/include/asm-blackfin/mach-bf548/bfin_serial_5xx.h
+++ b/include/asm-blackfin/mach-bf548/bfin_serial_5xx.h
@@ -1,5 +1,6 @@
 #include <linux/serial.h>
 #include <asm/dma.h>
+#include <asm/portmux.h>
 
 #define NR_PORTS		4
 
@@ -143,50 +144,48 @@ struct bfin_serial_res bfin_serial_resource[] = {
 
 int nr_ports = ARRAY_SIZE(bfin_serial_resource);
 
+#define DRIVER_NAME "bfin-uart"
+
 static void bfin_serial_hw_init(struct bfin_serial_port *uart)
 {
 #ifdef CONFIG_SERIAL_BFIN_UART0
-	/* Enable UART0 RX and TX on pin 7 & 8 of PORT E */
-	bfin_write_PORTE_FER(0x180 | bfin_read_PORTE_FER());
-	bfin_write_PORTE_MUX(0x3C000 | bfin_read_PORTE_MUX());
+	peripheral_request(P_UART0_TX, DRIVER_NAME);
+	peripheral_request(P_UART0_RX, DRIVER_NAME);
 #endif
 
 #ifdef CONFIG_SERIAL_BFIN_UART1
-	/* Enable UART1 RX and TX on pin 0 & 1 of PORT H */
-	bfin_write_PORTH_FER(0x3 | bfin_read_PORTH_FER());
-	bfin_write_PORTH_MUX(~0xF & bfin_read_PORTH_MUX());
+	peripheral_request(P_UART1_TX, DRIVER_NAME);
+	peripheral_request(P_UART1_RX, DRIVER_NAME);
+
 #ifdef CONFIG_BFIN_UART1_CTSRTS
-	/* Enable UART1 RTS and CTS on pin 9 & 10 of PORT E */
-	bfin_write_PORTE_FER(0x600 | bfin_read_PORTE_FER());
-	bfin_write_PORTE_MUX(~0x3C0000 & bfin_read_PORTE_MUX());
+	peripheral_request(P_UART1_RTS, DRIVER_NAME);
+	peripheral_request(P_UART1_CTS DRIVER_NAME);
 #endif
 #endif
 
 #ifdef CONFIG_SERIAL_BFIN_UART2
-	/* Enable UART2 RX and TX on pin 4 & 5 of PORT B */
-	bfin_write_PORTB_FER(0x30 | bfin_read_PORTB_FER());
-	bfin_write_PORTB_MUX(~0xF00 & bfin_read_PORTB_MUX());
+	peripheral_request(P_UART2_TX, DRIVER_NAME);
+	peripheral_request(P_UART2_RX, DRIVER_NAME);
 #endif
 
 #ifdef CONFIG_SERIAL_BFIN_UART3
-	/* Enable UART3 RX and TX on pin 6 & 7 of PORT B */
-	bfin_write_PORTB_FER(0xC0 | bfin_read_PORTB_FER());
-	bfin_write_PORTB_MUX(~0xF000 | bfin_read_PORTB_MUX());
+	peripheral_request(P_UART3_TX, DRIVER_NAME);
+	peripheral_request(P_UART3_RX, DRIVER_NAME);
+
 #ifdef CONFIG_BFIN_UART3_CTSRTS
-	/* Enable UART3 RTS and CTS on pin 2 & 3 of PORT B */
-	bfin_write_PORTB_FER(0xC | bfin_read_PORTB_FER());
-	bfin_write_PORTB_MUX(~0xF0 | bfin_read_PORTB_MUX());
+	peripheral_request(P_UART3_RTS, DRIVER_NAME);
+	peripheral_request(P_UART3_CTS DRIVER_NAME);
 #endif
 #endif
 	SSYNC();
 #ifdef CONFIG_SERIAL_BFIN_CTSRTS
 	if (uart->cts_pin >= 0) {
-		gpio_request(uart->cts_pin, NULL);
+		gpio_request(uart->cts_pin, DRIVER_NAME);
 		gpio_direction_input(uart->cts_pin);
 	}
 
 	if (uart->rts_pin >= 0) {
-		gpio_request(uart->rts_pin, NULL);
+		gpio_request(uart->rts_pin, DRIVER_NAME);
 		gpio_direction_output(uart->rts_pin);
 	}
 #endif
diff --git a/include/asm-blackfin/mach-bf548/blackfin.h b/include/asm-blackfin/mach-bf548/blackfin.h
index 791218f..19e84dd 100644
--- a/include/asm-blackfin/mach-bf548/blackfin.h
+++ b/include/asm-blackfin/mach-bf548/blackfin.h
@@ -54,7 +54,7 @@
 #include "defBF549.h"
 #endif
 
-#if !(defined(__ASSEMBLY__) || defined(ASSEMBLY))
+#if !defined(__ASSEMBLY__)
 #ifdef CONFIG_BF542
 #include "cdefBF542.h"
 #endif
diff --git a/include/asm-blackfin/mach-bf548/gpio.h b/include/asm-blackfin/mach-bf548/gpio.h
index dbf66bc..cb8b0f1 100644
--- a/include/asm-blackfin/mach-bf548/gpio.h
+++ b/include/asm-blackfin/mach-bf548/gpio.h
@@ -209,8 +209,3 @@ struct gpio_port_t {
 	unsigned short dummy7;
 	unsigned int port_mux;
 };
-
-int gpio_request(unsigned short gpio, const char *label);
-void peripheral_free(unsigned short per);
-int peripheral_request_list(unsigned short per[], const char *label);
-void peripheral_free_list(unsigned short per[]);
diff --git a/include/asm-blackfin/mach-bf548/irq.h b/include/asm-blackfin/mach-bf548/irq.h
index e548d3c..21f06f7 100644
--- a/include/asm-blackfin/mach-bf548/irq.h
+++ b/include/asm-blackfin/mach-bf548/irq.h
@@ -337,6 +337,8 @@ Events         (highest priority)  EMU         0
 #define IRQ_PJ14	BFIN_PJ_IRQ(14)		/* N/A */
 #define IRQ_PJ15	BFIN_PJ_IRQ(15)		/* N/A */
 
+#define GPIO_IRQ_BASE	IRQ_PA0
+
 #ifdef CONFIG_IRQCHIP_DEMUX_GPIO
 #define NR_IRQS     (IRQ_PJ15+1)
 #else
diff --git a/include/asm-blackfin/mach-bf561/bfin_serial_5xx.h b/include/asm-blackfin/mach-bf561/bfin_serial_5xx.h
index e043caf..69b9f8e 100644
--- a/include/asm-blackfin/mach-bf561/bfin_serial_5xx.h
+++ b/include/asm-blackfin/mach-bf561/bfin_serial_5xx.h
@@ -1,5 +1,6 @@
 #include <linux/serial.h>
 #include <asm/dma.h>
+#include <asm/portmux.h>
 
 #define NR_PORTS                1
 
@@ -92,18 +93,24 @@ struct bfin_serial_res bfin_serial_resource[] = {
 	}
 };
 
+#define DRIVER_NAME "bfin-uart"
 
 int nr_ports = NR_PORTS;
 static void bfin_serial_hw_init(struct bfin_serial_port *uart)
 {
 
+#ifdef CONFIG_SERIAL_BFIN_UART0
+	peripheral_request(P_UART0_TX, DRIVER_NAME);
+	peripheral_request(P_UART0_RX, DRIVER_NAME);
+#endif
+
 #ifdef CONFIG_SERIAL_BFIN_CTSRTS
 	if (uart->cts_pin >= 0) {
-		gpio_request(uart->cts_pin, NULL);
+		gpio_request(uart->cts_pin, DRIVER_NAME);
 		gpio_direction_input(uart->cts_pin);
 	}
 	if (uart->rts_pin >= 0) {
-		gpio_request(uart->rts_pin, NULL);
+		gpio_request(uart->rts_pin, DRIVER_NAME);
 		gpio_direction_input(uart->rts_pin);
 	}
 #endif
diff --git a/include/asm-blackfin/mach-bf561/blackfin.h b/include/asm-blackfin/mach-bf561/blackfin.h
index 2537c84..562aee3 100644
--- a/include/asm-blackfin/mach-bf561/blackfin.h
+++ b/include/asm-blackfin/mach-bf561/blackfin.h
@@ -38,7 +38,7 @@
 #include "defBF561.h"
 #include "anomaly.h"
 
-#if !(defined(__ASSEMBLY__) || defined(ASSEMBLY))
+#if !defined(__ASSEMBLY__)
 #include "cdefBF561.h"
 #endif
 
diff --git a/include/asm-blackfin/mach-bf561/irq.h b/include/asm-blackfin/mach-bf561/irq.h
index a753ce7..1278992 100644
--- a/include/asm-blackfin/mach-bf561/irq.h
+++ b/include/asm-blackfin/mach-bf561/irq.h
@@ -289,6 +289,8 @@
 #define IRQ_PF46		119
 #define IRQ_PF47		120
 
+#define GPIO_IRQ_BASE		IRQ_PF0
+
 #ifdef CONFIG_IRQCHIP_DEMUX_GPIO
 #define NR_IRQS			(IRQ_PF47 + 1)
 #else
diff --git a/include/asm-blackfin/portmux.h b/include/asm-blackfin/portmux.h
index 9d3681e..d1bcd91 100644
--- a/include/asm-blackfin/portmux.h
+++ b/include/asm-blackfin/portmux.h
@@ -14,6 +14,12 @@
 #define P_MAYSHARE	0x2000
 #define P_DONTCARE	0x1000
 
+
+int peripheral_request(unsigned short per, const char *label);
+void peripheral_free(unsigned short per);
+int peripheral_request_list(unsigned short per[], const char *label);
+void peripheral_free_list(unsigned short per[]);
+
 #include <asm/gpio.h>
 #include <asm/mach/portmux.h>
 
@@ -513,6 +519,22 @@
 #define P_SPI0_SSEL3 P_UNDEF
 #endif
 
+#ifndef P_SPI0_SSEL4
+#define P_SPI0_SSEL4 P_UNDEF
+#endif
+
+#ifndef P_SPI0_SSEL5
+#define P_SPI0_SSEL5 P_UNDEF
+#endif
+
+#ifndef P_SPI0_SSEL6
+#define P_SPI0_SSEL6 P_UNDEF
+#endif
+
+#ifndef P_SPI0_SSEL7
+#define P_SPI0_SSEL7 P_UNDEF
+#endif
+
 #ifndef P_UART0_TX
 #define P_UART0_TX P_UNDEF
 #endif
