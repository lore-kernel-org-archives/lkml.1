Return-Path: <linux-kernel-owner+w=401wt.eu-S932415AbYESNgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932415AbYESNgZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 09:36:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761487AbYESNVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 09:21:38 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46021 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761474AbYESNVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 09:21:37 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 54/57] wdrtas: clean up, coding style, switch to unlocked_ioctl
To: akpm@osdl.org, linux-kernel@vger.kernel.org, wim@iguana.be
Date: Mon, 19 May 2008 14:09:45 +0100
Message-ID: <20080519130945.31722.10030.stgit@core>
In-Reply-To: <20080519124659.31722.51847.stgit@core>
References: <20080519124659.31722.51847.stgit@core>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@redhat.com>


---

 drivers/watchdog/wdrtas.c |  103 ++++++++++++++++++---------------------------
 1 files changed, 41 insertions(+), 62 deletions(-)


diff --git a/drivers/watchdog/wdrtas.c b/drivers/watchdog/wdrtas.c
index 1d64e27..20fd671 100644
--- a/drivers/watchdog/wdrtas.c
+++ b/drivers/watchdog/wdrtas.c
@@ -35,9 +35,9 @@
 #include <linux/reboot.h>
 #include <linux/types.h>
 #include <linux/watchdog.h>
+#include <linux/uaccess.h>
 
 #include <asm/rtas.h>
-#include <asm/uaccess.h>
 
 #define WDRTAS_MAGIC_CHAR		42
 #define WDRTAS_SUPPORTED_MASK		(WDIOF_SETTIMEOUT | \
@@ -56,7 +56,7 @@ static int wdrtas_nowayout = 0;
 #endif
 
 static atomic_t wdrtas_miscdev_open = ATOMIC_INIT(0);
-static char wdrtas_expect_close = 0;
+static char wdrtas_expect_close;
 
 static int wdrtas_interval;
 
@@ -86,8 +86,8 @@ static char wdrtas_logbuffer[WDRTAS_LOGBUFFER_LEN];
  * RTAS function set-indicator (surveillance). The unit of interval is
  * seconds.
  */
-static int
-wdrtas_set_interval(int interval)
+
+static int wdrtas_set_interval(int interval)
 {
 	long result;
 	static int print_msg = 10;
@@ -97,7 +97,7 @@ wdrtas_set_interval(int interval)
 
 	result = rtas_call(wdrtas_token_set_indicator, 3, 1, NULL,
 			   WDRTAS_SURVEILLANCE_IND, 0, interval);
-	if ( (result < 0) && (print_msg) ) {
+	if (result < 0 && print_msg) {
 		printk(KERN_ERR "wdrtas: setting the watchdog to %i "
 		       "timeout failed: %li\n", interval, result);
 		print_msg--;
@@ -116,16 +116,14 @@ wdrtas_set_interval(int interval)
  * as reported by the RTAS function ibm,get-system-parameter. The unit
  * of the return value is seconds.
  */
-static int
-wdrtas_get_interval(int fallback_value)
+static int wdrtas_get_interval(int fallback_value)
 {
 	long result;
 	char value[4];
 
 	result = rtas_call(wdrtas_token_get_sp, 3, 1, NULL,
 			   WDRTAS_SP_SPI, (void *)__pa(&value), 4);
-	if ( (value[0] != 0) || (value[1] != 2) || (value[3] != 0) ||
-	     (result < 0) ) {
+	if (value[0] != 0 || value[1] != 2 || value[3] != 0 || result < 0) {
 		printk(KERN_WARNING "wdrtas: could not get sp_spi watchdog "
 		       "timeout (%li). Continuing\n", result);
 		return fallback_value;
@@ -141,8 +139,7 @@ wdrtas_get_interval(int fallback_value)
  * wdrtas_timer_start starts the watchdog by calling the RTAS function
  * set-interval (surveillance)
  */
-static void
-wdrtas_timer_start(void)
+static void wdrtas_timer_start(void)
 {
 	wdrtas_set_interval(wdrtas_interval);
 }
@@ -153,8 +150,7 @@ wdrtas_timer_start(void)
  * wdrtas_timer_stop stops the watchdog timer by calling the RTAS function
  * set-interval (surveillance)
  */
-static void
-wdrtas_timer_stop(void)
+static void wdrtas_timer_stop(void)
 {
 	wdrtas_set_interval(0);
 }
@@ -165,8 +161,7 @@ wdrtas_timer_stop(void)
  * wdrtas_log_scanned_event prints a message to the log buffer dumping
  * the results of the last event-scan call
  */
-static void
-wdrtas_log_scanned_event(void)
+static void wdrtas_log_scanned_event(void)
 {
 	int i;
 
@@ -175,13 +170,13 @@ wdrtas_log_scanned_event(void)
 		       "%02x %02x %02x %02x  %02x %02x %02x %02x   "
 		       "%02x %02x %02x %02x  %02x %02x %02x %02x\n",
 		       (i / 16) + 1, (WDRTAS_LOGBUFFER_LEN / 16),
-		       wdrtas_logbuffer[i + 0], wdrtas_logbuffer[i + 1], 
-		       wdrtas_logbuffer[i + 2], wdrtas_logbuffer[i + 3], 
-		       wdrtas_logbuffer[i + 4], wdrtas_logbuffer[i + 5], 
-		       wdrtas_logbuffer[i + 6], wdrtas_logbuffer[i + 7], 
-		       wdrtas_logbuffer[i + 8], wdrtas_logbuffer[i + 9], 
-		       wdrtas_logbuffer[i + 10], wdrtas_logbuffer[i + 11], 
-		       wdrtas_logbuffer[i + 12], wdrtas_logbuffer[i + 13], 
+		       wdrtas_logbuffer[i + 0], wdrtas_logbuffer[i + 1],
+		       wdrtas_logbuffer[i + 2], wdrtas_logbuffer[i + 3],
+		       wdrtas_logbuffer[i + 4], wdrtas_logbuffer[i + 5],
+		       wdrtas_logbuffer[i + 6], wdrtas_logbuffer[i + 7],
+		       wdrtas_logbuffer[i + 8], wdrtas_logbuffer[i + 9],
+		       wdrtas_logbuffer[i + 10], wdrtas_logbuffer[i + 11],
+		       wdrtas_logbuffer[i + 12], wdrtas_logbuffer[i + 13],
 		       wdrtas_logbuffer[i + 14], wdrtas_logbuffer[i + 15]);
 }
 
@@ -192,8 +187,7 @@ wdrtas_log_scanned_event(void)
  * RTAS function event-scan and repeats these calls as long as there are
  * events available. All events will be dumped.
  */
-static void
-wdrtas_timer_keepalive(void)
+static void wdrtas_timer_keepalive(void)
 {
 	long result;
 
@@ -218,8 +212,7 @@ wdrtas_timer_keepalive(void)
  * wdrtas_get_temperature returns the current temperature in Fahrenheit. It
  * uses the RTAS call get-sensor-state, token 3 to do so
  */
-static int
-wdrtas_get_temperature(void)
+static int wdrtas_get_temperature(void)
 {
 	long result;
 	int temperature = 0;
@@ -243,8 +236,7 @@ wdrtas_get_temperature(void)
  * returns a bitmask of defines WDIOF_... as defined in
  * include/linux/watchdog.h
  */
-static int
-wdrtas_get_status(void)
+static int wdrtas_get_status(void)
 {
 	return 0; /* TODO */
 }
@@ -255,8 +247,7 @@ wdrtas_get_status(void)
  * returns a bitmask of defines WDIOF_... as defined in
  * include/linux/watchdog.h, indicating why the watchdog rebooted the system
  */
-static int
-wdrtas_get_boot_status(void)
+static int wdrtas_get_boot_status(void)
 {
 	return 0; /* TODO */
 }
@@ -276,8 +267,7 @@ wdrtas_get_boot_status(void)
  * character 'V'. This character allows the watchdog device to be closed
  * properly.
  */
-static ssize_t
-wdrtas_write(struct file *file, const char __user *buf,
+static ssize_t wdrtas_write(struct file *file, const char __user *buf,
 	     size_t len, loff_t *ppos)
 {
 	int i;
@@ -306,7 +296,6 @@ out:
 
 /**
  * wdrtas_ioctl - ioctl function for the watchdog device
- * @inode: inode structure
  * @file: file structure
  * @cmd: command for ioctl
  * @arg: argument pointer
@@ -315,9 +304,9 @@ out:
  *
  * wdrtas_ioctl implements the watchdog API ioctls
  */
-static int
-wdrtas_ioctl(struct inode *inode, struct file *file,
-	     unsigned int cmd, unsigned long arg)
+
+static long wdrtas_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
 	int __user *argp = (void __user *)arg;
 	int i;
@@ -357,9 +346,9 @@ wdrtas_ioctl(struct inode *inode, struct file *file,
 			wdrtas_timer_keepalive();
 			wdrtas_timer_start();
 		}
+		/* not implemented. Done by H8
 		if (i & WDIOS_TEMPPANIC) {
-			/* not implemented. Done by H8 */
-		}
+		} */
 		return 0;
 
 	case WDIOC_KEEPALIVE:
@@ -399,8 +388,7 @@ wdrtas_ioctl(struct inode *inode, struct file *file,
  *
  * function called when watchdog device is opened
  */
-static int
-wdrtas_open(struct inode *inode, struct file *file)
+static int wdrtas_open(struct inode *inode, struct file *file)
 {
 	/* only open once */
 	if (atomic_inc_return(&wdrtas_miscdev_open) > 1) {
@@ -423,8 +411,7 @@ wdrtas_open(struct inode *inode, struct file *file)
  *
  * close function. Always succeeds
  */
-static int
-wdrtas_close(struct inode *inode, struct file *file)
+static int wdrtas_close(struct inode *inode, struct file *file)
 {
 	/* only stop watchdog, if this was announced using 'V' before */
 	if (wdrtas_expect_close == WDRTAS_MAGIC_CHAR)
@@ -453,8 +440,7 @@ wdrtas_close(struct inode *inode, struct file *file)
  * wdrtas_temp_read gives the temperature to the users by copying this
  * value as one byte into the user space buffer. The unit is Fahrenheit...
  */
-static ssize_t
-wdrtas_temp_read(struct file *file, char __user *buf,
+static ssize_t wdrtas_temp_read(struct file *file, char __user *buf,
 		 size_t count, loff_t *ppos)
 {
 	int temperature = 0;
@@ -478,8 +464,7 @@ wdrtas_temp_read(struct file *file, char __user *buf,
  *
  * function called when temperature device is opened
  */
-static int
-wdrtas_temp_open(struct inode *inode, struct file *file)
+static int wdrtas_temp_open(struct inode *inode, struct file *file)
 {
 	return nonseekable_open(inode, file);
 }
@@ -493,8 +478,7 @@ wdrtas_temp_open(struct inode *inode, struct file *file)
  *
  * close function. Always succeeds
  */
-static int
-wdrtas_temp_close(struct inode *inode, struct file *file)
+static int wdrtas_temp_close(struct inode *inode, struct file *file)
 {
 	return 0;
 }
@@ -509,10 +493,10 @@ wdrtas_temp_close(struct inode *inode, struct file *file)
  *
  * wdrtas_reboot stops the watchdog in case of a reboot
  */
-static int
-wdrtas_reboot(struct notifier_block *this, unsigned long code, void *ptr)
+static int wdrtas_reboot(struct notifier_block *this,
+					unsigned long code, void *ptr)
 {
-	if ( (code==SYS_DOWN) || (code==SYS_HALT) )
+	if (code == SYS_DOWN || code == SYS_HALT)
 		wdrtas_timer_stop();
 
 	return NOTIFY_DONE;
@@ -524,7 +508,7 @@ static const struct file_operations wdrtas_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= wdrtas_write,
-	.ioctl		= wdrtas_ioctl,
+	.unlocked_ioctl	= wdrtas_ioctl,
 	.open		= wdrtas_open,
 	.release	= wdrtas_close,
 };
@@ -562,8 +546,7 @@ static struct notifier_block wdrtas_notifier = {
  * this watchdog driver. It tolerates, if "get-sensor-state" and
  * "ibm,get-system-parameter" are not available.
  */
-static int
-wdrtas_get_tokens(void)
+static int wdrtas_get_tokens(void)
 {
 	wdrtas_token_get_sensor_state = rtas_token("get-sensor-state");
 	if (wdrtas_token_get_sensor_state == RTAS_UNKNOWN_SERVICE) {
@@ -603,8 +586,7 @@ wdrtas_get_tokens(void)
  * wdrtas_register_devs unregisters the watchdog and temperature watchdog
  * misc devs
  */
-static void
-wdrtas_unregister_devs(void)
+static void wdrtas_unregister_devs(void)
 {
 	misc_deregister(&wdrtas_miscdev);
 	if (wdrtas_token_get_sensor_state != RTAS_UNKNOWN_SERVICE)
@@ -619,8 +601,7 @@ wdrtas_unregister_devs(void)
  * wdrtas_register_devs registers the watchdog and temperature watchdog
  * misc devs
  */
-static int
-wdrtas_register_devs(void)
+static int wdrtas_register_devs(void)
 {
 	int result;
 
@@ -651,8 +632,7 @@ wdrtas_register_devs(void)
  *
  * registers the file handlers and the reboot notifier
  */
-static int __init
-wdrtas_init(void)
+static int __init wdrtas_init(void)
 {
 	if (wdrtas_get_tokens())
 		return -ENODEV;
@@ -680,8 +660,7 @@ wdrtas_init(void)
  *
  * unregisters the file handlers and the reboot notifier
  */
-static void __exit
-wdrtas_exit(void)
+static void __exit wdrtas_exit(void)
 {
 	if (!wdrtas_nowayout)
 		wdrtas_timer_stop();

