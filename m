Return-Path: <linux-kernel-owner+w=401wt.eu-S1757838AbXLFM4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757838AbXLFM4l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 07:56:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755097AbXLFMoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 07:44:37 -0500
Received: from nic2.axis.se ([193.13.178.10]:45018 "EHLO krynn.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753206AbXLFMog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 07:44:36 -0500
From: Jesper Nilsson <jesper.nilsson@axis.com>
Message-Id: <cdda065141073e183216982b6faf7e1aee17b215.1196848533.git.jesper.nilsson@axis.com>
In-Reply-To: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
References: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org
Date: Mon, 3 Dec 2007 11:16:25 +0100
Subject: [PATCH 44/47] Minor fixes for CRISv32 io.h
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Shorten include paths for machine dependent header files.
- Add volatile to hardeware register pointers.
- Add spinlocks around critical region.
- Expand macros for handling of leds.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
 include/asm-cris/arch-v32/io.h |   70 +++++++++++++++++++++++++++++++--------
 1 files changed, 55 insertions(+), 15 deletions(-)

diff --git a/include/asm-cris/arch-v32/io.h b/include/asm-cris/arch-v32/io.h
index 5efe4d9..65a2879 100644
--- a/include/asm-cris/arch-v32/io.h
+++ b/include/asm-cris/arch-v32/io.h
@@ -1,9 +1,10 @@
 #ifndef _ASM_ARCH_CRIS_IO_H
 #define _ASM_ARCH_CRIS_IO_H
 
-#include <asm/arch/hwregs/reg_map.h>
-#include <asm/arch/hwregs/reg_rdwr.h>
-#include <asm/arch/hwregs/gio_defs.h>
+#include <linux/spinlock.h>
+#include <hwregs/reg_map.h>
+#include <hwregs/reg_rdwr.h>
+#include <hwregs/gio_defs.h>
 
 enum crisv32_io_dir
 {
@@ -13,10 +14,11 @@ enum crisv32_io_dir
 
 struct crisv32_ioport
 {
-  unsigned long* oe;
-  unsigned long* data;
-  unsigned long* data_in;
+  volatile unsigned long *oe;
+  volatile unsigned long *data;
+  volatile unsigned long *data_in;
   unsigned int pin_count;
+  spinlock_t lock;
 };
 
 struct crisv32_iopin
@@ -34,22 +36,37 @@ extern struct crisv32_iopin crisv32_led2_red;
 extern struct crisv32_iopin crisv32_led3_green;
 extern struct crisv32_iopin crisv32_led3_red;
 
+extern struct crisv32_iopin crisv32_led_net0_green;
+extern struct crisv32_iopin crisv32_led_net0_red;
+extern struct crisv32_iopin crisv32_led_net1_green;
+extern struct crisv32_iopin crisv32_led_net1_red;
+
 static inline void crisv32_io_set(struct crisv32_iopin* iopin,
 			   int val)
 {
+	long flags;
+	spin_lock_irqsave(&iopin->port->lock, flags);
+
 	if (val)
 		*iopin->port->data |= iopin->bit;
 	else
 		*iopin->port->data &= ~iopin->bit;
+
+	spin_unlock_irqrestore(&iopin->port->lock, flags);
 }
 
 static inline void crisv32_io_set_dir(struct crisv32_iopin* iopin,
 			       enum crisv32_io_dir dir)
 {
+	long flags;
+	spin_lock_irqsave(&iopin->port->lock, flags);
+
 	if (dir == crisv32_io_dir_in)
 		*iopin->port->oe &= ~iopin->bit;
 	else
 		*iopin->port->oe |= iopin->bit;
+
+	spin_unlock_irqrestore(&iopin->port->lock, flags);
 }
 
 static inline int crisv32_io_rd(struct crisv32_iopin* iopin)
@@ -60,28 +77,51 @@ static inline int crisv32_io_rd(struct crisv32_iopin* iopin)
 int crisv32_io_get(struct crisv32_iopin* iopin,
                    unsigned int port, unsigned int pin);
 int crisv32_io_get_name(struct crisv32_iopin* iopin,
-                         char* name);
+			const char *name);
 
 #define LED_OFF    0x00
 #define LED_GREEN  0x01
 #define LED_RED    0x02
 #define LED_ORANGE (LED_GREEN | LED_RED)
 
-#define LED_NETWORK_SET(x)                          \
-	do {                                        \
-		LED_NETWORK_SET_G((x) & LED_GREEN); \
-		LED_NETWORK_SET_R((x) & LED_RED);   \
+#if (defined(CONFIG_ETRAX_NBR_LED_GRP_ONE) || defined(CONFIG_ETRAX_NBR_LED_GRP_TWO))
+#define LED_NETWORK_GRP0_SET(x)                          \
+	do {                                             \
+		LED_NETWORK_GRP0_SET_G((x) & LED_GREEN); \
+		LED_NETWORK_GRP0_SET_R((x) & LED_RED);   \
 	} while (0)
+#else
+#define LED_NETWORK_GRP0_SET(x) while (0) {}
+#endif
+
+#define LED_NETWORK_GRP0_SET_G(x) \
+	crisv32_io_set(&crisv32_led_net0_green, !(x));
+
+#define LED_NETWORK_GRP0_SET_R(x) \
+	crisv32_io_set(&crisv32_led_net0_red, !(x));
+
+#if defined(CONFIG_ETRAX_NBR_LED_GRP_TWO)
+#define LED_NETWORK_GRP1_SET(x)                          \
+	do {                                             \
+		LED_NETWORK_GRP1_SET_G((x) & LED_GREEN); \
+		LED_NETWORK_GRP1_SET_R((x) & LED_RED);   \
+	} while (0)
+#else
+#define LED_NETWORK_GRP1_SET(x) while (0) {}
+#endif
+
+#define LED_NETWORK_GRP1_SET_G(x) \
+	crisv32_io_set(&crisv32_led_net1_green, !(x));
+
+#define LED_NETWORK_GRP1_SET_R(x) \
+	crisv32_io_set(&crisv32_led_net1_red, !(x));
+
 #define LED_ACTIVE_SET(x)                           \
 	do {                                        \
 		LED_ACTIVE_SET_G((x) & LED_GREEN);  \
 		LED_ACTIVE_SET_R((x) & LED_RED);    \
 	} while (0)
 
-#define LED_NETWORK_SET_G(x) \
-	crisv32_io_set(&crisv32_led1_green, !(x));
-#define LED_NETWORK_SET_R(x) \
-	crisv32_io_set(&crisv32_led1_red, !(x));
 #define LED_ACTIVE_SET_G(x) \
 	crisv32_io_set(&crisv32_led2_green, !(x));
 #define LED_ACTIVE_SET_R(x) \
-- 
1.5.3.6.970.gd25430

