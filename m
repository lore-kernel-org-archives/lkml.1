Return-Path: <linux-kernel-owner+w=401wt.eu-S1765052AbYEVWNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765052AbYEVWNs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 18:13:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758758AbYEVWNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 18:13:39 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39587 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757557AbYEVWNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 18:13:37 -0400
Date: Thu, 22 May 2008 23:00:34 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] lcd: Push the BKL down into the driver ioctl handler
Message-ID: <20080522230034.2e6ca40a@core>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@redhat.com>

diff --git a/drivers/char/lcd.c b/drivers/char/lcd.c
index 4fe9206..1690cfb 100644
--- a/drivers/char/lcd.c
+++ b/drivers/char/lcd.c
@@ -21,15 +21,15 @@
 #include <linux/netdevice.h>
 #include <linux/sched.h>
 #include <linux/delay.h>
+#include <linux/smp_lock.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
 
-#include <asm/io.h>
-#include <asm/uaccess.h>
 #include <asm/system.h>
 
 #include "lcd.h"
 
-static int lcd_ioctl(struct inode *inode, struct file *file,
-		     unsigned int cmd, unsigned long arg);
+static long lcd_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
 
 static unsigned int lcd_present = 1;
 
@@ -54,11 +54,13 @@ int lcd_register_linkcheck_func(int iface_num, void *func, void *cookie)
 }
 #endif
 
-static int lcd_ioctl(struct inode *inode, struct file *file,
-		     unsigned int cmd, unsigned long arg)
+static long lcd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct lcd_display button_display;
 	unsigned long address, a;
+	long ret = 0;
+
+	lock_kernel();
 
 	switch (cmd) {
 	case LCD_On:
@@ -135,7 +137,7 @@ static int lcd_ioctl(struct inode *inode, struct file *file,
 			if (copy_to_user
 			    ((struct lcd_display *) arg, &display,
 			     sizeof(struct lcd_display)))
-				return -EFAULT;
+				ret = -EFAULT;
 
 			break;
 		}
@@ -147,14 +149,13 @@ static int lcd_ioctl(struct inode *inode, struct file *file,
 			if (copy_from_user
 			    (&display, (struct lcd_display *) arg,
 			     sizeof(struct lcd_display)))
-				return -EFAULT;
-
-			a = (display.cursor_address | kLCD_Addr);
-
-			udelay(150);
-			BusyCheck();
-			LCDWriteInst(a);
-
+				ret = -EFAULT;
+			else {
+				a = (display.cursor_address | kLCD_Addr);
+				udelay(150);
+				BusyCheck();
+				LCDWriteInst(a);
+			}
 			break;
 		}
 
@@ -168,11 +169,12 @@ static int lcd_ioctl(struct inode *inode, struct file *file,
 			if (copy_to_user
 			    ((struct lcd_display *) arg, &display,
 			     sizeof(struct lcd_display)))
-				return -EFAULT;
-			udelay(150);
-			BusyCheck();
-			LCDWriteInst(0x10);
-
+				ret = -EFAULT;
+			else {
+				udelay(150);
+				BusyCheck();
+				LCDWriteInst(0x10);
+			}
 			break;
 		}
 
@@ -182,15 +184,15 @@ static int lcd_ioctl(struct inode *inode, struct file *file,
 			if (copy_from_user
 			    (&display, (struct lcd_display *) arg,
 			     sizeof(struct lcd_display)))
-				return -EFAULT;
-
-			udelay(150);
-			BusyCheck();
-			LCDWriteData(display.character);
-			udelay(150);
-			BusyCheck();
-			LCDWriteInst(0x10);
-
+				ret = -EFAULT;
+			else {
+				udelay(150);
+				BusyCheck();
+				LCDWriteData(display.character);
+				udelay(150);
+				BusyCheck();
+				LCDWriteInst(0x10);
+			}
 			break;
 		}
 
@@ -220,8 +222,10 @@ static int lcd_ioctl(struct inode *inode, struct file *file,
 
 			if (copy_from_user
 			    (&display, (struct lcd_display *) arg,
-			     sizeof(struct lcd_display)))
-				return -EFAULT;
+			     sizeof(struct lcd_display))) {
+				ret = -EFAULT;
+				break;
+			}
 
 			udelay(150);
 			BusyCheck();
@@ -287,7 +291,7 @@ static int lcd_ioctl(struct inode *inode, struct file *file,
 			if (copy_to_user
 			    ((struct lcd_display *) arg, &display,
 			     sizeof(struct lcd_display)))
-				return -EFAULT;
+				ret = -EFAULT;
 			break;
 		}
 
@@ -300,10 +304,11 @@ static int lcd_ioctl(struct inode *inode, struct file *file,
 			if (copy_from_user
 			    (&led_display, (struct lcd_display *) arg,
 			     sizeof(struct lcd_display)))
-				return -EFAULT;
-
-			led_state = led_display.leds;
-			LEDSet(led_state);
+				ret = -EFAULT;
+			else {
+				led_state = led_display.leds;
+				LEDSet(led_state);
+			}
 
 			break;
 		}
@@ -320,14 +325,15 @@ static int lcd_ioctl(struct inode *inode, struct file *file,
 			if (copy_from_user
 			    (&led_display, (struct lcd_display *) arg,
 			     sizeof(struct lcd_display)))
-				return -EFAULT;
-
-			for (i = 0; i < (int) led_display.leds; i++) {
-				bit = 2 * bit;
+				ret = -EFAULT;
+			else {
+				for (i = 0; i < (int) led_display.leds; i++) {
+					bit = 2 * bit;
+				}
+
+				led_state = led_state | bit;
+				LEDSet(led_state);
 			}
-
-			led_state = led_state | bit;
-			LEDSet(led_state);
 			break;
 		}
 
@@ -342,14 +348,15 @@ static int lcd_ioctl(struct inode *inode, struct file *file,
 			if (copy_from_user
 			    (&led_display, (struct lcd_display *) arg,
 			     sizeof(struct lcd_display)))
-				return -EFAULT;
-
-			for (i = 0; i < (int) led_display.leds; i++) {
-				bit = 2 * bit;
+				ret = -EFAULT;
+			else {
+				for (i = 0; i < (int) led_display.leds; i++) {
+					bit = 2 * bit;
+				}
+
+				led_state = led_state & ~bit;
+				LEDSet(led_state);
 			}
-
-			led_state = led_state & ~bit;
-			LEDSet(led_state);
 			break;
 		}
 
@@ -359,7 +366,7 @@ static int lcd_ioctl(struct inode *inode, struct file *file,
 			if (copy_to_user
 			    ((struct lcd_display *) arg, &button_display,
 			     sizeof(struct lcd_display)))
-				return -EFAULT;
+				ret = -EFAULT;
 			break;
 		}
 
@@ -369,7 +376,7 @@ static int lcd_ioctl(struct inode *inode, struct file *file,
 			if (copy_to_user
 			    ((struct lcd_display *) arg, &button_display,
 			     sizeof(struct lcd_display)))
-				return -EFAULT;
+				ret = -EFAULT;
 			break;
 		}
 
@@ -382,8 +389,10 @@ static int lcd_ioctl(struct inode *inode, struct file *file,
 			 */
 			if (copy_from_user
 			    (&button_display, (struct lcd_display *) arg,
-			     sizeof(button_display)))
-				return -EFAULT;
+			     sizeof(button_display))) {
+				ret = -EFAULT;
+				break;
+			}
 			iface_num = button_display.buttons;
 #if defined(CONFIG_TULIP) && 0
 			if (iface_num >= 0 &&
@@ -399,17 +408,15 @@ static int lcd_ioctl(struct inode *inode, struct file *file,
 			if (__copy_to_user
 			    ((struct lcd_display *) arg, &button_display,
 			     sizeof(struct lcd_display)))
-				return -EFAULT;
+				ret = -EFAULT;
 			break;
 		}
 
 	default:
-		return -EINVAL;
-
+		ret = -ENOTTY;
 	}
-
-	return 0;
-
+	lock_kernel();
+	return ret;
 }
 
 static int lcd_open(struct inode *inode, struct file *file)
@@ -462,7 +469,7 @@ static ssize_t lcd_read(struct file *file, char *buf,
 
 static const struct file_operations lcd_fops = {
 	.read = lcd_read,
-	.ioctl = lcd_ioctl,
+	.unlocked_ioctl = lcd_ioctl,
 	.open = lcd_open,
 };
 
