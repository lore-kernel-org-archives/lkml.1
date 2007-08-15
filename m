Return-Path: <linux-kernel-owner+w=401wt.eu-S932646AbXHOO6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932646AbXHOO6V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 10:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763200AbXHOO6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 10:58:14 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:65060 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762620AbXHOO6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 10:58:13 -0400
Date: Wed, 15 Aug 2007 16:57:56 +0200
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, kernel@avr32linux.org
Subject: [GIT PULL] AVR32 update
Message-ID: <20070815165756.3c3b1f09@dhcp-255-175.norway.atmel.com>
Organization: Atmel Norway
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/hskinnemoen/avr32-2.6.git for-linus

to receive the following changes.

David Brownell (1):
      [AVR32] leds-gpio for stk1000

Haavard Skinnemoen (4):
      [AVR32] Wire up i2c-gpio on the ATNGW100 board
      [AVR32] Simplify pte_alloc_one{,_kernel}
      [AVR32] Fix bogus pte_page() definition
      [AVR32] Define mmiowb()

Mariusz Kozlowski (1):
      include/asm-avr32/pgalloc.h: kmalloc + memset conversion to kcalloc

 arch/avr32/boards/atngw100/setup.c      |   18 +++++++++
 arch/avr32/boards/atstk1000/Kconfig     |   26 +++++++++++++
 arch/avr32/boards/atstk1000/atstk1002.c |   62 +++++++++++++++++++++++++++++++
 include/asm-avr32/io.h                  |    2 +
 include/asm-avr32/pgalloc.h             |   30 +-------------
 include/asm-avr32/pgtable.h             |    4 +-
 6 files changed, 112 insertions(+), 30 deletions(-)

diff --git a/arch/avr32/boards/atngw100/setup.c b/arch/avr32/boards/atngw100/setup.c
index 2edcecd..ef80156 100644
--- a/arch/avr32/boards/atngw100/setup.c
+++ b/arch/avr32/boards/atngw100/setup.c
@@ -9,6 +9,7 @@
  */
 #include <linux/clk.h>
 #include <linux/etherdevice.h>
+#include <linux/i2c-gpio.h>
 #include <linux/init.h>
 #include <linux/linkage.h>
 #include <linux/platform_device.h>
@@ -123,6 +124,19 @@ static struct platform_device ngw_gpio_leds = {
 	}
 };
 
+static struct i2c_gpio_platform_data i2c_gpio_data = {
+	.sda_pin	= GPIO_PIN_PA(6),
+	.scl_pin	= GPIO_PIN_PA(7),
+};
+
+static struct platform_device i2c_gpio_device = {
+	.name		= "i2c-gpio",
+	.id		= 0,
+	.dev		= {
+		.platform_data	= &i2c_gpio_data,
+	},
+};
+
 static int __init atngw100_init(void)
 {
 	unsigned	i;
@@ -147,6 +161,10 @@ static int __init atngw100_init(void)
 	}
 	platform_device_register(&ngw_gpio_leds);
 
+	at32_select_gpio(i2c_gpio_data.sda_pin, 0);
+	at32_select_gpio(i2c_gpio_data.scl_pin, 0);
+	platform_device_register(&i2c_gpio_device);
+
 	return 0;
 }
 postcore_initcall(atngw100_init);
diff --git a/arch/avr32/boards/atstk1000/Kconfig b/arch/avr32/boards/atstk1000/Kconfig
index 71bc7d3..718578f 100644
--- a/arch/avr32/boards/atstk1000/Kconfig
+++ b/arch/avr32/boards/atstk1000/Kconfig
@@ -50,4 +50,30 @@ config BOARD_ATSTK1002_SPI1
 	  GPIO lines and accessed through the J1 jumper block.  Say "y"
 	  here to configure that SPI controller.
 
+config BOARD_ATSTK1002_J2_LED
+	bool
+	default BOARD_ATSTK1002_J2_LED8 || BOARD_ATSTK1002_J2_RGB
+
+choice
+	prompt "LEDs connected to J2:"
+	depends on LEDS_GPIO && !BOARD_ATSTK1002_SW4_CUSTOM
+	optional
+	help
+	  Select this if you have jumpered the J2 jumper block to the
+	  LED0..LED7 amber leds, or to the RGB leds, using a ten-pin
+	  IDC cable.  A default "heartbeat" trigger is provided, but
+	  you can of course override this.
+
+config BOARD_ATSTK1002_J2_LED8
+	bool "LED0..LED7"
+	help
+	  Select this if J2 is jumpered to LED0..LED7 amber leds.
+
+config BOARD_ATSTK1002_J2_RGB
+	bool "RGB leds"
+	help
+	  Select this if J2 is jumpered to the RGB leds.
+
+endchoice
+
 endif	# stk 1002
diff --git a/arch/avr32/boards/atstk1000/atstk1002.c b/arch/avr32/boards/atstk1000/atstk1002.c
index cb93eab..c9981b7 100644
--- a/arch/avr32/boards/atstk1000/atstk1002.c
+++ b/arch/avr32/boards/atstk1000/atstk1002.c
@@ -11,6 +11,7 @@
 #include <linux/etherdevice.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
+#include <linux/leds.h>
 #include <linux/platform_device.h>
 #include <linux/string.h>
 #include <linux/types.h>
@@ -120,6 +121,65 @@ static void __init set_hw_addr(struct platform_device *pdev)
 	clk_put(pclk);
 }
 
+#ifdef CONFIG_BOARD_ATSTK1002_J2_LED
+
+static struct gpio_led stk_j2_led[] = {
+#ifdef CONFIG_BOARD_ATSTK1002_J2_LED8
+#define LEDSTRING "J2 jumpered to LED8"
+	{ .name = "led0:amber", .gpio = GPIO_PIN_PB( 8), },
+	{ .name = "led1:amber", .gpio = GPIO_PIN_PB( 9), },
+	{ .name = "led2:amber", .gpio = GPIO_PIN_PB(10), },
+	{ .name = "led3:amber", .gpio = GPIO_PIN_PB(13), },
+	{ .name = "led4:amber", .gpio = GPIO_PIN_PB(14), },
+	{ .name = "led5:amber", .gpio = GPIO_PIN_PB(15), },
+	{ .name = "led6:amber", .gpio = GPIO_PIN_PB(16), },
+	{ .name = "led7:amber", .gpio = GPIO_PIN_PB(30),
+			.default_trigger = "heartbeat", },
+#else	/* RGB */
+#define LEDSTRING "J2 jumpered to RGB LEDs"
+	{ .name = "r1:red",     .gpio = GPIO_PIN_PB( 8), },
+	{ .name = "g1:green",   .gpio = GPIO_PIN_PB(10), },
+	{ .name = "b1:blue",    .gpio = GPIO_PIN_PB(14), },
+
+	{ .name = "r2:red",     .gpio = GPIO_PIN_PB( 9),
+			.default_trigger = "heartbeat", },
+	{ .name = "g2:green",   .gpio = GPIO_PIN_PB(13), },
+	{ .name = "b2:blue",    .gpio = GPIO_PIN_PB(15),
+			.default_trigger = "heartbeat", },
+	/* PB16, PB30 unused */
+#endif
+};
+
+static struct gpio_led_platform_data stk_j2_led_data = {
+	.num_leds	= ARRAY_SIZE(stk_j2_led),
+	.leds		= stk_j2_led,
+};
+
+static struct platform_device stk_j2_led_dev = {
+	.name		= "leds-gpio",
+	.id		= 2,	/* gpio block J2 */
+	.dev		= {
+		.platform_data	= &stk_j2_led_data,
+	},
+};
+
+static void setup_j2_leds(void)
+{
+	unsigned	i;
+
+	for (i = 0; i < ARRAY_SIZE(stk_j2_led); i++)
+		at32_select_gpio(stk_j2_led[i].gpio, AT32_GPIOF_OUTPUT);
+
+	printk("STK1002: " LEDSTRING "\n");
+	platform_device_register(&stk_j2_led_dev);
+}
+
+#else
+static void setup_j2_leds(void)
+{
+}
+#endif
+
 void __init setup_board(void)
 {
 #ifdef	CONFIG_BOARD_ATSTK1002_SW2_CUSTOM
@@ -185,6 +245,8 @@ static int __init atstk1002_init(void)
 	at32_add_device_ssc(0, ATMEL_SSC_TX);
 #endif
 
+	setup_j2_leds();
+
 	return 0;
 }
 postcore_initcall(atstk1002_init);
diff --git a/include/asm-avr32/io.h b/include/asm-avr32/io.h
index e30d4b3..64bb92b 100644
--- a/include/asm-avr32/io.h
+++ b/include/asm-avr32/io.h
@@ -255,6 +255,8 @@ static inline void memset_io(volatile void __iomem *addr, unsigned char val,
 	memset((void __force *)addr, val, count);
 }
 
+#define mmiowb()
+
 #define IO_SPACE_LIMIT	0xffffffff
 
 extern void __iomem *__ioremap(unsigned long offset, size_t size,
diff --git a/include/asm-avr32/pgalloc.h b/include/asm-avr32/pgalloc.h
index bb82e70..0e680f4 100644
--- a/include/asm-avr32/pgalloc.h
+++ b/include/asm-avr32/pgalloc.h
@@ -27,13 +27,7 @@ static __inline__ void pmd_populate(struct mm_struct *mm, pmd_t *pmd,
  */
 static __inline__ pgd_t *pgd_alloc(struct mm_struct *mm)
 {
-	unsigned int pgd_size = (USER_PTRS_PER_PGD * sizeof(pgd_t));
-	pgd_t *pgd = kmalloc(pgd_size, GFP_KERNEL);
-
-	if (pgd)
-		memset(pgd, 0, pgd_size);
-
-	return pgd;
+	return kcalloc(USER_PTRS_PER_PGD, sizeof(pgd_t), GFP_KERNEL);
 }
 
 static inline void pgd_free(pgd_t *pgd)
@@ -44,18 +38,9 @@ static inline void pgd_free(pgd_t *pgd)
 static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm,
 					  unsigned long address)
 {
-	int count = 0;
 	pte_t *pte;
 
-	do {
-		pte = (pte_t *) __get_free_page(GFP_KERNEL | __GFP_REPEAT);
-		if (pte)
-			clear_page(pte);
-		else {
-			current->state = TASK_UNINTERRUPTIBLE;
-			schedule_timeout(HZ);
-		}
-	} while (!pte && (count++ < 10));
+	pte = (pte_t *)get_zeroed_page(GFP_KERNEL | __GFP_REPEAT);
 
 	return pte;
 }
@@ -63,18 +48,9 @@ static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm,
 static inline struct page *pte_alloc_one(struct mm_struct *mm,
 					 unsigned long address)
 {
-	int count = 0;
 	struct page *pte;
 
-	do {
-		pte = alloc_pages(GFP_KERNEL, 0);
-		if (pte)
-			clear_page(page_address(pte));
-		else {
-			current->state = TASK_UNINTERRUPTIBLE;
-			schedule_timeout(HZ);
-		}
-	} while (!pte && (count++ < 10));
+	pte = alloc_page(GFP_KERNEL | __GFP_REPEAT | __GFP_ZERO);
 
 	return pte;
 }
diff --git a/include/asm-avr32/pgtable.h b/include/asm-avr32/pgtable.h
index c07bdd1..018f6e2 100644
--- a/include/asm-avr32/pgtable.h
+++ b/include/asm-avr32/pgtable.h
@@ -32,8 +32,6 @@
 #define USER_PTRS_PER_PGD	(TASK_SIZE / PGDIR_SIZE)
 #define FIRST_USER_ADDRESS	0
 
-#define PTE_PHYS_MASK	0x1ffff000
-
 #ifndef __ASSEMBLY__
 extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
 extern void paging_init(void);
@@ -265,7 +263,7 @@ static inline pte_t pte_mkyoung(pte_t pte)
  * trivial.
  */
 #define pages_to_mb(x)	((x) >> (20-PAGE_SHIFT))
-#define pte_page(x) 	phys_to_page(pte_val(x) & PTE_PHYS_MASK)
+#define pte_page(x)	(pfn_to_page(pte_pfn(x)))
 
 /*
  * Mark the prot value as uncacheable and unbufferable
