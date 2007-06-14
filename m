Return-Path: <linux-kernel-owner+w=401wt.eu-S1753863AbXFNRAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863AbXFNRAY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 13:00:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751278AbXFNRAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 13:00:13 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:63106 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751004AbXFNRAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 13:00:11 -0400
Date: Thu, 14 Jun 2007 19:00:04 +0200
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] AVR32 fixes
Message-ID: <20070614190004.70e183f5@dhcp-255-175.norway.atmel.com>
Organization: Atmel Norway
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the 'for-linus' branch of

  git://www.atmel.no/~hskinnemoen/linux/kernel/avr32.git for-linus

to receive the following updates.

Note that this will crash on boot if CONFIG_SLUB_DEBUG=y and slub_debug
is not set, but the alternative is more subtle DMA breakage and
Christoph Lameter has sent a patch to Andrew (Subject: "SLUB: minimum
alignment fixes") which takes care of it.

Andrea Righi (1):
      [AVR32] ratelimit segfault reporting rate

David Brownell (1):
      [AVR32] gpio_*_cansleep() fix

Haavard Skinnemoen (2):
      [AVR32] STK1000: Set SPI_MODE_3 in the ltv350qv board info
      [AVR32] Define ARCH_KMALLOC_MINALIGN to L1_CACHE_BYTES

 arch/avr32/boards/atstk1000/atstk1002.c |    1 +
 arch/avr32/mm/fault.c                   |    2 +-
 include/asm-avr32/arch-at32ap/gpio.h    |    2 ++
 include/asm-avr32/cache.h               |    9 +++++++++
 4 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/arch/avr32/boards/atstk1000/atstk1002.c b/arch/avr32/boards/atstk1000/atstk1002.c
index fe1dbe2..e253e86 100644
--- a/arch/avr32/boards/atstk1000/atstk1002.c
+++ b/arch/avr32/boards/atstk1000/atstk1002.c
@@ -42,6 +42,7 @@ static struct spi_board_info spi0_board_info[] __initdata = {
 		.modalias	= "ltv350qv",
 		.max_speed_hz	= 16000000,
 		.chip_select	= 1,
+		.mode		= SPI_MODE_3,
 	},
 };
 
diff --git a/arch/avr32/mm/fault.c b/arch/avr32/mm/fault.c
index e011f1c..4b24952 100644
--- a/arch/avr32/mm/fault.c
+++ b/arch/avr32/mm/fault.c
@@ -158,7 +158,7 @@ bad_area:
 	up_read(&mm->mmap_sem);
 
 	if (user_mode(regs)) {
-		if (exception_trace)
+		if (exception_trace && printk_ratelimit())
 			printk("%s%s[%d]: segfault at %08lx pc %08lx "
 			       "sp %08lx ecr %lu\n",
 			       is_init(tsk) ? KERN_EMERG : KERN_INFO,
diff --git a/include/asm-avr32/arch-at32ap/gpio.h b/include/asm-avr32/arch-at32ap/gpio.h
index 80a21aa..af7f953 100644
--- a/include/asm-avr32/arch-at32ap/gpio.h
+++ b/include/asm-avr32/arch-at32ap/gpio.h
@@ -14,6 +14,8 @@ int gpio_direction_output(unsigned int gpio, int value);
 int gpio_get_value(unsigned int gpio);
 void gpio_set_value(unsigned int gpio, int value);
 
+#include <asm-generic/gpio.h>		/* cansleep wrappers */
+
 static inline int gpio_to_irq(unsigned int gpio)
 {
 	return gpio + GPIO_IRQ_BASE;
diff --git a/include/asm-avr32/cache.h b/include/asm-avr32/cache.h
index dabb955..d3cf35a 100644
--- a/include/asm-avr32/cache.h
+++ b/include/asm-avr32/cache.h
@@ -4,6 +4,15 @@
 #define L1_CACHE_SHIFT 5
 #define L1_CACHE_BYTES (1 << L1_CACHE_SHIFT)
 
+/*
+ * Memory returned by kmalloc() may be used for DMA, so we must make
+ * sure that all such allocations are cache aligned. Otherwise,
+ * unrelated code may cause parts of the buffer to be read into the
+ * cache before the transfer is done, causing old data to be seen by
+ * the CPU.
+ */
+#define ARCH_KMALLOC_MINALIGN	L1_CACHE_BYTES
+
 #ifndef __ASSEMBLER__
 struct cache_info {
 	unsigned int ways;
