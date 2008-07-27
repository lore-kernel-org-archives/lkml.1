Return-Path: <linux-kernel-owner+w=401wt.eu-S1757215AbYG0NLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215AbYG0NLX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 09:11:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751522AbYG0NLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 09:11:14 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:44716 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751518AbYG0NLN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 09:11:13 -0400
Date: Sun, 27 Jul 2008 15:10:06 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, kernel@avr32linux.org
Subject: [GIT PULL] AVR32 updates for 2.6.27-rc1, round 2
Message-ID: <20080727151006.08fa22d9@hskinnemo-gx745.norway.atmel.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 27 Jul 2008 13:10:54.0279 (UTC) FILETIME=[33571570:01C8EFEA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull my 'master' branch

  git://git.kernel.org/pub/scm/linux/kernel/git/hskinnemoen/avr32-2.6.git master

to receive the below updates.

I had to do a merge with your tree due to an MMC conflict. I've tested
the result on two different boards, and while I did find a couple of
problems, they don't seem to be specific to AVR32 and are being worked
on elsewhere.

The problems I found are:
  * ATSTK1004 defconfig doesn't build. Several patches have been posted
    to the thread that starts at http://lkml.org/lkml/2008/7/26/155,
    all of which fix it.
  * NFS oops on reboot. Fixed by http://lkml.org/lkml/2008/7/17/154.

So I'm hoping things will sort themselves out when these patches move
upstream.

Adrian Bunk (2):
      fix avr32 build errors
      include/video/atmel_lcdc.h must #include <linux/workqueue.h>

Ben Nizette (1):
      avr32: clean up mci platform code

David Brownell (1):
      avr32: some mmc/sd cleanups

Haavard Skinnemoen (1):
      Merge commit 'upstream/master'

Hans-Christian Egtvedt (1):
      avr32: Add platform data for AC97C platform device

Huang Weiyi (1):
      drivers/misc/atmel-ssc.c: Removed duplicated include

Voss, Nikolaus (1):
      avr32: allow system timer to share interrupt to make OProfile work

 arch/avr32/boards/atstk1000/atstk1002.c |   19 ++++++++++-
 arch/avr32/boards/atstk1000/atstk1003.c |    2 +-
 arch/avr32/boards/atstk1000/atstk1004.c |    2 +-
 arch/avr32/kernel/time.c                |    6 +++-
 arch/avr32/mach-at32ap/at32ap700x.c     |   56 +++++++++++++++++++++----------
 drivers/misc/atmel-ssc.c                |    1 -
 drivers/mmc/host/atmel-mci.c            |   17 +++++----
 include/asm-avr32/arch-at32ap/board.h   |   10 +++++-
 8 files changed, 81 insertions(+), 32 deletions(-)

diff --git a/arch/avr32/boards/atstk1000/atstk1002.c b/arch/avr32/boards/atstk1000/atstk1002.c
index 14dc5a1..8538ba7 100644
--- a/arch/avr32/boards/atstk1000/atstk1002.c
+++ b/arch/avr32/boards/atstk1000/atstk1002.c
@@ -21,6 +21,8 @@
 
 #include <asm/io.h>
 #include <asm/setup.h>
+#include <asm/atmel-mci.h>
+
 #include <asm/arch/at32ap700x.h>
 #include <asm/arch/board.h>
 #include <asm/arch/init.h>
@@ -260,6 +262,21 @@ void __init setup_board(void)
 	at32_setup_serial_console(0);
 }
 
+#ifndef CONFIG_BOARD_ATSTK100X_SW2_CUSTOM
+
+/* MMC card detect requires MACB0 *NOT* be used */
+#ifdef CONFIG_BOARD_ATSTK1002_SW6_CUSTOM
+static struct mci_platform_data __initdata mci0_data = {
+	.detect_pin	= GPIO_PIN_PC(14),	/* gpio30/sdcd */
+	.wp_pin		= GPIO_PIN_PC(15),	/* gpio31/sdwp */
+};
+#define MCI_PDATA	&mci0_data
+#else
+#define MCI_PDATA	NULL
+#endif	/* SW6 for sd{cd,wp} routing */
+
+#endif	/* SW2 for MMC signal routing */
+
 static int __init atstk1002_init(void)
 {
 	/*
@@ -309,7 +326,7 @@ static int __init atstk1002_init(void)
 	at32_add_device_spi(1, spi1_board_info, ARRAY_SIZE(spi1_board_info));
 #endif
 #ifndef CONFIG_BOARD_ATSTK1002_SW2_CUSTOM
-	at32_add_device_mci(0, NULL);
+	at32_add_device_mci(0, MCI_PDATA);
 #endif
 #ifdef CONFIG_BOARD_ATSTK1002_SW5_CUSTOM
 	set_hw_addr(at32_add_device_eth(1, &eth_data[1]));
diff --git a/arch/avr32/boards/atstk1000/atstk1003.c b/arch/avr32/boards/atstk1000/atstk1003.c
index ea109f4..591fc73 100644
--- a/arch/avr32/boards/atstk1000/atstk1003.c
+++ b/arch/avr32/boards/atstk1000/atstk1003.c
@@ -154,7 +154,7 @@ static int __init atstk1003_init(void)
 	at32_add_device_spi(1, spi1_board_info, ARRAY_SIZE(spi1_board_info));
 #endif
 #ifndef CONFIG_BOARD_ATSTK100X_SW2_CUSTOM
-	at32_add_device_mci(0);
+	at32_add_device_mci(0, NULL);
 #endif
 	at32_add_device_usba(0, NULL);
 #ifndef CONFIG_BOARD_ATSTK100X_SW3_CUSTOM
diff --git a/arch/avr32/boards/atstk1000/atstk1004.c b/arch/avr32/boards/atstk1000/atstk1004.c
index c7236df..d9c5e0a 100644
--- a/arch/avr32/boards/atstk1000/atstk1004.c
+++ b/arch/avr32/boards/atstk1000/atstk1004.c
@@ -137,7 +137,7 @@ static int __init atstk1004_init(void)
 	at32_add_device_spi(1, spi1_board_info, ARRAY_SIZE(spi1_board_info));
 #endif
 #ifndef CONFIG_BOARD_ATSTK100X_SW2_CUSTOM
-	at32_add_device_mci(0);
+	at32_add_device_mci(0, NULL);
 #endif
 	at32_add_device_lcdc(0, &atstk1000_lcdc_data,
 			     fbmem_start, fbmem_size, 0);
diff --git a/arch/avr32/kernel/time.c b/arch/avr32/kernel/time.c
index abd954f..7e7f327 100644
--- a/arch/avr32/kernel/time.c
+++ b/arch/avr32/kernel/time.c
@@ -43,6 +43,9 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
 {
 	struct clock_event_device *evdev = dev_id;
 
+	if (unlikely(!(intc_get_pending(0) & 1)))
+		return IRQ_NONE;
+
 	/*
 	 * Disable the interrupt until the clockevent subsystem
 	 * reprograms it.
@@ -55,7 +58,8 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
 
 static struct irqaction timer_irqaction = {
 	.handler	= timer_interrupt,
-	.flags		= IRQF_TIMER | IRQF_DISABLED,
+	/* Oprofile uses the same irq as the timer, so allow it to be shared */
+	.flags		= IRQF_TIMER | IRQF_DISABLED | IRQF_SHARED,
 	.name		= "avr32_comparator",
 };
 
diff --git a/arch/avr32/mach-at32ap/at32ap700x.c b/arch/avr32/mach-at32ap/at32ap700x.c
index 351e1b4..1617048 100644
--- a/arch/avr32/mach-at32ap/at32ap700x.c
+++ b/arch/avr32/mach-at32ap/at32ap700x.c
@@ -12,6 +12,7 @@
 #include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/dma-mapping.h>
+#include <linux/gpio.h>
 #include <linux/spi/spi.h>
 #include <linux/usb/atmel_usba_udc.h>
 
@@ -1285,7 +1286,6 @@ at32_add_device_mci(unsigned int id, struct mci_platform_data *data)
 {
 	struct mci_platform_data	_data;
 	struct platform_device		*pdev;
-	struct dw_dma_slave		*dws;
 
 	if (id != 0)
 		return NULL;
@@ -1300,7 +1300,9 @@ at32_add_device_mci(unsigned int id, struct mci_platform_data *data)
 
 	if (!data) {
 		data = &_data;
-		memset(data, 0, sizeof(struct mci_platform_data));
+		memset(data, -1, sizeof(struct mci_platform_data));
+		data->detect_pin = GPIO_PIN_NONE;
+		data->wp_pin = GPIO_PIN_NONE;
 	}
 
 	if (platform_device_add_data(pdev, data,
@@ -1314,12 +1316,10 @@ at32_add_device_mci(unsigned int id, struct mci_platform_data *data)
 	select_peripheral(PA(14), PERIPH_A, 0);	/* DATA2 */
 	select_peripheral(PA(15), PERIPH_A, 0);	/* DATA3 */
 
-	if (data) {
-		if (data->detect_pin != GPIO_PIN_NONE)
-			at32_select_gpio(data->detect_pin, 0);
-		if (data->wp_pin != GPIO_PIN_NONE)
-			at32_select_gpio(data->wp_pin, 0);
-	}
+	if (gpio_is_valid(data->detect_pin))
+		at32_select_gpio(data->detect_pin, 0);
+	if (gpio_is_valid(data->wp_pin))
+		at32_select_gpio(data->wp_pin, 0);
 
 	atmel_mci0_pclk.dev = &pdev->dev;
 
@@ -1853,11 +1853,11 @@ at32_add_device_cf(unsigned int id, unsigned int extint,
 	if (at32_init_ide_or_cf(pdev, data->cs, extint))
 		goto fail;
 
-	if (data->detect_pin != GPIO_PIN_NONE)
+	if (gpio_is_valid(data->detect_pin))
 		at32_select_gpio(data->detect_pin, AT32_GPIOF_DEGLITCH);
-	if (data->reset_pin != GPIO_PIN_NONE)
+	if (gpio_is_valid(data->reset_pin))
 		at32_select_gpio(data->reset_pin, 0);
-	if (data->vcc_pin != GPIO_PIN_NONE)
+	if (gpio_is_valid(data->vcc_pin))
 		at32_select_gpio(data->vcc_pin, 0);
 	/* READY is used as extint, so we can't select it as gpio */
 
@@ -1937,9 +1937,11 @@ static struct clk atmel_ac97c0_pclk = {
 	.index		= 10,
 };
 
-struct platform_device *__init at32_add_device_ac97c(unsigned int id)
+struct platform_device *__init
+at32_add_device_ac97c(unsigned int id, struct ac97c_platform_data *data)
 {
 	struct platform_device *pdev;
+	struct ac97c_platform_data _data;
 
 	if (id != 0)
 		return NULL;
@@ -1950,19 +1952,37 @@ struct platform_device *__init at32_add_device_ac97c(unsigned int id)
 
 	if (platform_device_add_resources(pdev, atmel_ac97c0_resource,
 				ARRAY_SIZE(atmel_ac97c0_resource)))
-		goto err_add_resources;
+		goto fail;
+
+	if (!data) {
+		data = &_data;
+		memset(data, 0, sizeof(struct ac97c_platform_data));
+		data->reset_pin = GPIO_PIN_NONE;
+	}
 
-	select_peripheral(PB(20), PERIPH_B, 0);	/* SYNC	*/
-	select_peripheral(PB(21), PERIPH_B, 0);	/* SDO	*/
-	select_peripheral(PB(22), PERIPH_B, 0);	/* SDI	*/
-	select_peripheral(PB(23), PERIPH_B, 0);	/* SCLK	*/
+	data->dma_rx_periph_id = 3;
+	data->dma_tx_periph_id = 4;
+	data->dma_controller_id = 0;
+
+	if (platform_device_add_data(pdev, data,
+				sizeof(struct ac97c_platform_data)))
+		goto fail;
+
+	select_peripheral(PB(20), PERIPH_B, 0);	/* SDO	*/
+	select_peripheral(PB(21), PERIPH_B, 0);	/* SYNC	*/
+	select_peripheral(PB(22), PERIPH_B, 0);	/* SCLK	*/
+	select_peripheral(PB(23), PERIPH_B, 0);	/* SDI	*/
+
+	/* TODO: gpio_is_valid(data->reset_pin) with kernel 2.6.26. */
+	if (data->reset_pin != GPIO_PIN_NONE)
+		at32_select_gpio(data->reset_pin, 0);
 
 	atmel_ac97c0_pclk.dev = &pdev->dev;
 
 	platform_device_add(pdev);
 	return pdev;
 
-err_add_resources:
+fail:
 	platform_device_put(pdev);
 	return NULL;
 }
diff --git a/drivers/misc/atmel-ssc.c b/drivers/misc/atmel-ssc.c
index e171650..bf5e4d0 100644
--- a/drivers/misc/atmel-ssc.c
+++ b/drivers/misc/atmel-ssc.c
@@ -13,7 +13,6 @@
 #include <linux/clk.h>
 #include <linux/err.h>
 #include <linux/io.h>
-#include <linux/list.h>
 #include <linux/spinlock.h>
 #include <linux/atmel-ssc.h>
 
diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index b68381f..992b4be 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -11,6 +11,8 @@
 #include <linux/clk.h>
 #include <linux/debugfs.h>
 #include <linux/device.h>
+#include <linux/err.h>
+#include <linux/gpio.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/ioport.h>
@@ -27,7 +29,6 @@
 #include <asm/unaligned.h>
 
 #include <asm/arch/board.h>
-#include <asm/arch/gpio.h>
 
 #include "atmel-mci-regs.h"
 
@@ -573,7 +574,7 @@ static int atmci_get_ro(struct mmc_host *mmc)
 	int			read_only = 0;
 	struct atmel_mci	*host = mmc_priv(mmc);
 
-	if (host->wp_pin >= 0) {
+	if (gpio_is_valid(host->wp_pin)) {
 		read_only = gpio_get_value(host->wp_pin);
 		dev_dbg(&mmc->class_dev, "card is %s\n",
 				read_only ? "read-only" : "read-write");
@@ -635,7 +636,7 @@ static void atmci_detect_change(unsigned long data)
 	 * been freed.
 	 */
 	smp_rmb();
-	if (host->detect_pin < 0)
+	if (!gpio_is_valid(host->detect_pin))
 		return;
 
 	enable_irq(gpio_to_irq(host->detect_pin));
@@ -1050,7 +1051,7 @@ static int __init atmci_probe(struct platform_device *pdev)
 
 	/* Assume card is present if we don't have a detect pin */
 	host->present = 1;
-	if (host->detect_pin >= 0) {
+	if (gpio_is_valid(host->detect_pin)) {
 		if (gpio_request(host->detect_pin, "mmc_detect")) {
 			dev_dbg(&mmc->class_dev, "no detect pin available\n");
 			host->detect_pin = -1;
@@ -1058,7 +1059,7 @@ static int __init atmci_probe(struct platform_device *pdev)
 			host->present = !gpio_get_value(host->detect_pin);
 		}
 	}
-	if (host->wp_pin >= 0) {
+	if (gpio_is_valid(host->wp_pin)) {
 		if (gpio_request(host->wp_pin, "mmc_wp")) {
 			dev_dbg(&mmc->class_dev, "no WP pin available\n");
 			host->wp_pin = -1;
@@ -1069,7 +1070,7 @@ static int __init atmci_probe(struct platform_device *pdev)
 
 	mmc_add_host(mmc);
 
-	if (host->detect_pin >= 0) {
+	if (gpio_is_valid(host->detect_pin)) {
 		setup_timer(&host->detect_timer, atmci_detect_change,
 				(unsigned long)host);
 
@@ -1112,7 +1113,7 @@ static int __exit atmci_remove(struct platform_device *pdev)
 	if (host) {
 		/* Debugfs stuff is cleaned up by mmc core */
 
-		if (host->detect_pin >= 0) {
+		if (gpio_is_valid(host->detect_pin)) {
 			int pin = host->detect_pin;
 
 			/* Make sure the timer doesn't enable the interrupt */
@@ -1132,7 +1133,7 @@ static int __exit atmci_remove(struct platform_device *pdev)
 		mci_readl(host, SR);
 		clk_disable(host->mck);
 
-		if (host->wp_pin >= 0)
+		if (gpio_is_valid(host->wp_pin))
 			gpio_free(host->wp_pin);
 
 		free_irq(platform_get_irq(pdev, 0), host->mmc);
diff --git a/include/asm-avr32/arch-at32ap/board.h b/include/asm-avr32/arch-at32ap/board.h
index 893aa6d..e60e907 100644
--- a/include/asm-avr32/arch-at32ap/board.h
+++ b/include/asm-avr32/arch-at32ap/board.h
@@ -82,7 +82,15 @@ struct mci_platform_data;
 struct platform_device *
 at32_add_device_mci(unsigned int id, struct mci_platform_data *data);
 
-struct platform_device *at32_add_device_ac97c(unsigned int id);
+struct ac97c_platform_data {
+	unsigned short dma_rx_periph_id;
+	unsigned short dma_tx_periph_id;
+	unsigned short dma_controller_id;
+	int reset_pin;
+};
+struct platform_device *
+at32_add_device_ac97c(unsigned int id, struct ac97c_platform_data *data);
+
 struct platform_device *at32_add_device_abdac(unsigned int id);
 struct platform_device *at32_add_device_psif(unsigned int id);
 
