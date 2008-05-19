Return-Path: <linux-kernel-owner+w=401wt.eu-S1763866AbYESN2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763866AbYESN2m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 09:28:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760020AbYESNTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 09:19:37 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45917 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760710AbYESNTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 09:19:35 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 32/57] pcwd: clean up, unlocked_ioctl usage
To: akpm@osdl.org, linux-kernel@vger.kernel.org, wim@iguana.be
Date: Mon, 19 May 2008 14:07:43 +0100
Message-ID: <20080519130743.31722.44630.stgit@core>
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

 drivers/watchdog/pcwd.c |  179 ++++++++++++++++++++++++++---------------------
 1 files changed, 100 insertions(+), 79 deletions(-)


diff --git a/drivers/watchdog/pcwd.c b/drivers/watchdog/pcwd.c
index 7b41434..e1259ad 100644
--- a/drivers/watchdog/pcwd.c
+++ b/drivers/watchdog/pcwd.c
@@ -40,13 +40,15 @@
  *		fairly useless proc entry.
  * 990610	removed said useless proc code for the merge <alan>
  * 000403	Removed last traces of proc code. <davej>
- * 011214	Added nowayout module option to override CONFIG_WATCHDOG_NOWAYOUT <Matt_Domsch@dell.com>
+ * 011214	Added nowayout module option to override
+ *		CONFIG_WATCHDOG_NOWAYOUT <Matt_Domsch@dell.com>
  *              Added timeout module option to override default
  */
 
 /*
  *	A bells and whistles driver is available from http://www.pcwd.de/
- *	More info available at http://www.berkprod.com/ or http://www.pcwatchdog.com/
+ *	More info available at http://www.berkprod.com/ or
+ *	http://www.pcwatchdog.com/
  */
 
 #include <linux/module.h>	/* For module specific items */
@@ -65,9 +67,8 @@
 #include <linux/isa.h>		/* For isa devices */
 #include <linux/ioport.h>	/* For io-port access */
 #include <linux/spinlock.h>	/* For spin_lock/spin_unlock/... */
-
-#include <asm/uaccess.h>	/* For copy_to_user/put_user/... */
-#include <asm/io.h>		/* For inb/outb/... */
+#include <linux/uaccess.h>	/* For copy_to_user/put_user/... */
+#include <linux/io.h>		/* For inb/outb/... */
 
 /* Module and version information */
 #define WATCHDOG_VERSION "1.20"
@@ -111,14 +112,16 @@ static int pcwd_ioports[] = { 0x270, 0x350, 0x370, 0x000 };
 #define WD_REVC_WTRP		0x01	/* Watchdog Trip status */
 #define WD_REVC_HRBT		0x02	/* Watchdog Heartbeat */
 #define WD_REVC_TTRP		0x04	/* Temperature Trip status */
-#define WD_REVC_RL2A		0x08	/* Relay 2 activated by on-board processor */
+#define WD_REVC_RL2A		0x08	/* Relay 2 activated by
+							on-board processor */
 #define WD_REVC_RL1A		0x10	/* Relay 1 active */
 #define WD_REVC_R2DS		0x40	/* Relay 2 disable */
 #define WD_REVC_RLY2		0x80	/* Relay 2 activated? */
 /* Port 2 : Control Status #2 */
 #define WD_WDIS			0x10	/* Watchdog Disabled */
 #define WD_ENTP			0x20	/* Watchdog Enable Temperature Trip */
-#define WD_SSEL			0x40	/* Watchdog Switch Select (1:SW1 <-> 0:SW2) */
+#define WD_SSEL			0x40	/* Watchdog Switch Select
+							(1:SW1 <-> 0:SW2) */
 #define WD_WCMD			0x80	/* Watchdog Command Mode */
 
 /* max. time we give an ISA watchdog card to process a command */
@@ -168,11 +171,15 @@ static int cards_found;
 static atomic_t open_allowed = ATOMIC_INIT(1);
 static char expect_close;
 static int temp_panic;
-static struct {				/* this is private data for each ISA-PC watchdog card */
+
+/* this is private data for each ISA-PC watchdog card */
+static struct {
 	char fw_ver_str[6];		/* The cards firmware version */
 	int revision;			/* The card's revision */
-	int supports_temp;		/* Wether or not the card has a temperature device */
-	int command_mode;		/* Wether or not the card is in command mode */
+	int supports_temp;		/* Whether or not the card has
+						a temperature device */
+	int command_mode;		/* Whether or not the card is in
+						command mode */
 	int boot_status;		/* The card's boot status */
 	int io_addr;			/* The cards I/O address */
 	spinlock_t io_lock;		/* the lock for io operations */
@@ -186,16 +193,20 @@ static struct {				/* this is private data for each ISA-PC watchdog card */
 #define DEBUG	2	/* print fancy stuff too */
 static int debug = QUIET;
 module_param(debug, int, 0);
-MODULE_PARM_DESC(debug, "Debug level: 0=Quiet, 1=Verbose, 2=Debug (default=0)");
+MODULE_PARM_DESC(debug,
+		"Debug level: 0=Quiet, 1=Verbose, 2=Debug (default=0)");
 
-#define WATCHDOG_HEARTBEAT 0		/* default heartbeat = delay-time from dip-switches */
+/* default heartbeat = delay-time from dip-switches */
+#define WATCHDOG_HEARTBEAT 0
 static int heartbeat = WATCHDOG_HEARTBEAT;
 module_param(heartbeat, int, 0);
-MODULE_PARM_DESC(heartbeat, "Watchdog heartbeat in seconds. (2<=heartbeat<=7200 or 0=delay-time from dip-switches, default=" __MODULE_STRING(WATCHDOG_HEARTBEAT) ")");
+MODULE_PARM_DESC(heartbeat, "Watchdog heartbeat in seconds. (2 <= heartbeat <= 7200 or 0=delay-time from dip-switches, default=" __MODULE_STRING(WATCHDOG_HEARTBEAT) ")");
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+		"Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 /*
  *	Internal functions
@@ -224,7 +235,7 @@ static int send_isa_command(int cmd)
 		if (port0 == last_port0)
 			break;	/* Data is stable */
 
-		udelay (250);
+		udelay(250);
 	}
 
 	if (debug >= DEBUG)
@@ -236,7 +247,7 @@ static int send_isa_command(int cmd)
 
 static int set_command_mode(void)
 {
-	int i, found=0, count=0;
+	int i, found = 0, count = 0;
 
 	/* Set the card into command mode */
 	spin_lock(&pcwd_private.io_lock);
@@ -296,7 +307,8 @@ static inline void pcwd_get_firmware(void)
 		ten = send_isa_command(CMD_ISA_VERSION_TENTH);
 		hund = send_isa_command(CMD_ISA_VERSION_HUNDRETH);
 		minor = send_isa_command(CMD_ISA_VERSION_MINOR);
-		sprintf(pcwd_private.fw_ver_str, "%c.%c%c%c", one, ten, hund, minor);
+		sprintf(pcwd_private.fw_ver_str, "%c.%c%c%c",
+					one, ten, hund, minor);
 	}
 	unset_command_mode();
 
@@ -305,7 +317,7 @@ static inline void pcwd_get_firmware(void)
 
 static inline int pcwd_get_option_switches(void)
 {
-	int option_switches=0;
+	int option_switches = 0;
 
 	if (set_command_mode()) {
 		/* Get switch settings */
@@ -322,7 +334,9 @@ static void pcwd_show_card_info(void)
 
 	/* Get some extra info from the hardware (in command/debug/diag mode) */
 	if (pcwd_private.revision == PCWD_REVISION_A)
-		printk(KERN_INFO PFX "ISA-PC Watchdog (REV.A) detected at port 0x%04x\n", pcwd_private.io_addr);
+		printk(KERN_INFO PFX
+			"ISA-PC Watchdog (REV.A) detected at port 0x%04x\n",
+							pcwd_private.io_addr);
 	else if (pcwd_private.revision == PCWD_REVISION_C) {
 		pcwd_get_firmware();
 		printk(KERN_INFO PFX "ISA-PC Watchdog (REV.C) detected at port 0x%04x (Firmware version: %s)\n",
@@ -347,12 +361,15 @@ static void pcwd_show_card_info(void)
 		printk(KERN_INFO PFX "Previous reboot was caused by the card\n");
 
 	if (pcwd_private.boot_status & WDIOF_OVERHEAT) {
-		printk(KERN_EMERG PFX "Card senses a CPU Overheat. Panicking!\n");
-		printk(KERN_EMERG PFX "CPU Overheat\n");
+		printk(KERN_EMERG PFX
+			"Card senses a CPU Overheat. Panicking!\n");
+		printk(KERN_EMERG PFX
+			"CPU Overheat\n");
 	}
 
 	if (pcwd_private.boot_status == 0)
-		printk(KERN_INFO PFX "No previous trip detected - Cold boot or reset\n");
+		printk(KERN_INFO PFX
+			"No previous trip detected - Cold boot or reset\n");
 }
 
 static void pcwd_timer_ping(unsigned long data)
@@ -361,11 +378,12 @@ static void pcwd_timer_ping(unsigned long data)
 
 	/* If we got a heartbeat pulse within the WDT_INTERVAL
 	 * we agree to ping the WDT */
-	if(time_before(jiffies, pcwd_private.next_heartbeat)) {
+	if (time_before(jiffies, pcwd_private.next_heartbeat)) {
 		/* Ping the watchdog */
 		spin_lock(&pcwd_private.io_lock);
 		if (pcwd_private.revision == PCWD_REVISION_A) {
-			/*  Rev A cards are reset by setting the WD_WDRST bit in register 1 */
+			/*  Rev A cards are reset by setting the
+			    WD_WDRST bit in register 1 */
 			wdrst_stat = inb_p(pcwd_private.io_addr);
 			wdrst_stat &= 0x0F;
 			wdrst_stat |= WD_WDRST;
@@ -381,7 +399,8 @@ static void pcwd_timer_ping(unsigned long data)
 
 		spin_unlock(&pcwd_private.io_lock);
 	} else {
-		printk(KERN_WARNING PFX "Heartbeat lost! Will not ping the watchdog\n");
+		printk(KERN_WARNING PFX
+			"Heartbeat lost! Will not ping the watchdog\n");
 	}
 }
 
@@ -454,7 +473,7 @@ static int pcwd_keepalive(void)
 
 static int pcwd_set_heartbeat(int t)
 {
-	if ((t < 2) || (t > 7200)) /* arbitrary upper limit */
+	if (t < 2 || t > 7200) /* arbitrary upper limit */
 		return -EINVAL;
 
 	heartbeat = t;
@@ -470,7 +489,7 @@ static int pcwd_get_status(int *status)
 {
 	int control_status;
 
-	*status=0;
+	*status = 0;
 	spin_lock(&pcwd_private.io_lock);
 	if (pcwd_private.revision == PCWD_REVISION_A)
 		/* Rev A cards return status information from
@@ -494,9 +513,9 @@ static int pcwd_get_status(int *status)
 		if (control_status & WD_T110) {
 			*status |= WDIOF_OVERHEAT;
 			if (temp_panic) {
-				printk(KERN_INFO PFX "Temperature overheat trip!\n");
+				printk(KERN_INFO PFX
+					"Temperature overheat trip!\n");
 				kernel_power_off();
-				/* or should we just do a: panic(PFX "Temperature overheat trip!\n"); */
 			}
 		}
 	} else {
@@ -506,9 +525,9 @@ static int pcwd_get_status(int *status)
 		if (control_status & WD_REVC_TTRP) {
 			*status |= WDIOF_OVERHEAT;
 			if (temp_panic) {
-				printk(KERN_INFO PFX "Temperature overheat trip!\n");
+				printk(KERN_INFO PFX
+					"Temperature overheat trip!\n");
 				kernel_power_off();
-				/* or should we just do a: panic(PFX "Temperature overheat trip!\n"); */
 			}
 		}
 	}
@@ -524,18 +543,21 @@ static int pcwd_clear_status(void)
 		spin_lock(&pcwd_private.io_lock);
 
 		if (debug >= VERBOSE)
-			printk(KERN_INFO PFX "clearing watchdog trip status\n");
+			printk(KERN_INFO PFX
+					"clearing watchdog trip status\n");
 
 		control_status = inb_p(pcwd_private.io_addr + 1);
 
 		if (debug >= DEBUG) {
-			printk(KERN_DEBUG PFX "status was: 0x%02x\n", control_status);
+			printk(KERN_DEBUG PFX "status was: 0x%02x\n",
+				control_status);
 			printk(KERN_DEBUG PFX "sending: 0x%02x\n",
 				(control_status & WD_REVC_R2DS));
 		}
 
 		/* clear reset status & Keep Relay 2 disable state as it is */
-		outb_p((control_status & WD_REVC_R2DS), pcwd_private.io_addr + 1);
+		outb_p((control_status & WD_REVC_R2DS),
+						pcwd_private.io_addr + 1);
 
 		spin_unlock(&pcwd_private.io_lock);
 	}
@@ -572,8 +594,7 @@ static int pcwd_get_temperature(int *temperature)
  *	/dev/watchdog handling
  */
 
-static int pcwd_ioctl(struct inode *inode, struct file *file,
-		      unsigned int cmd, unsigned long arg)
+static long pcwd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	int rv;
 	int status;
@@ -590,12 +611,12 @@ static int pcwd_ioctl(struct inode *inode, struct file *file,
 		.identity =		"PCWD",
 	};
 
-	switch(cmd) {
+	switch (cmd) {
 	default:
 		return -ENOTTY;
 
 	case WDIOC_GETSUPPORT:
-		if(copy_to_user(argp, &ident, sizeof(ident)))
+		if (copy_to_user(argp, &ident, sizeof(ident)))
 			return -EFAULT;
 		return 0;
 
@@ -613,25 +634,22 @@ static int pcwd_ioctl(struct inode *inode, struct file *file,
 		return put_user(temperature, argp);
 
 	case WDIOC_SETOPTIONS:
-		if (pcwd_private.revision == PCWD_REVISION_C)
-		{
-			if(copy_from_user(&rv, argp, sizeof(int)))
+		if (pcwd_private.revision == PCWD_REVISION_C) {
+			if (get_user(rv, argp))
 				return -EFAULT;
 
-			if (rv & WDIOS_DISABLECARD)
-			{
-				return pcwd_stop();
+			if (rv & WDIOS_DISABLECARD) {
+				status = pcwd_stop();
+				if (status < 0)
+					return status;
 			}
-
-			if (rv & WDIOS_ENABLECARD)
-			{
-				return pcwd_start();
+			if (rv & WDIOS_ENABLECARD) {
+				status = pcwd_start();
+				if (status < 0)
+					return status;
 			}
-
 			if (rv & WDIOS_TEMPPANIC)
-			{
 				temp_panic = 1;
-			}
 		}
 		return -EINVAL;
 
@@ -682,16 +700,10 @@ static ssize_t pcwd_write(struct file *file, const char __user *buf, size_t len,
 
 static int pcwd_open(struct inode *inode, struct file *file)
 {
-	if (!atomic_dec_and_test(&open_allowed) ) {
-		if (debug >= VERBOSE)
-			printk(KERN_ERR PFX "Attempt to open already opened device.\n");
-		atomic_inc( &open_allowed );
+	if (test_and_set_bit(0, &open_allowed))
 		return -EBUSY;
-	}
-
 	if (nowayout)
 		__module_get(THIS_MODULE);
-
 	/* Activate */
 	pcwd_start();
 	pcwd_keepalive();
@@ -700,14 +712,15 @@ static int pcwd_open(struct inode *inode, struct file *file)
 
 static int pcwd_close(struct inode *inode, struct file *file)
 {
-	if (expect_close == 42) {
+	if (expect_close == 42)
 		pcwd_stop();
-	} else {
-		printk(KERN_CRIT PFX "Unexpected close, not stopping watchdog!\n");
+	else {
+		printk(KERN_CRIT PFX
+			"Unexpected close, not stopping watchdog!\n");
 		pcwd_keepalive();
 	}
 	expect_close = 0;
-	atomic_inc( &open_allowed );
+	clear_bit(0, &open_allowed);
 	return 0;
 }
 
@@ -750,7 +763,7 @@ static const struct file_operations pcwd_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= pcwd_write,
-	.ioctl		= pcwd_ioctl,
+	.unlocked_ioctl	= pcwd_ioctl,
 	.open		= pcwd_open,
 	.release	= pcwd_close,
 };
@@ -788,7 +801,7 @@ static inline int get_revision(void)
 	 * presumes a floating bus reads as 0xff. */
 	if ((inb(pcwd_private.io_addr + 2) == 0xFF) ||
 	    (inb(pcwd_private.io_addr + 3) == 0xFF))
-		r=PCWD_REVISION_A;
+		r = PCWD_REVISION_A;
 	spin_unlock(&pcwd_private.io_lock);
 
 	return r;
@@ -803,7 +816,7 @@ static inline int get_revision(void)
  */
 static int __devinit pcwd_isa_match(struct device *dev, unsigned int id)
 {
-	int base_addr=pcwd_ioports[id];
+	int base_addr = pcwd_ioports[id];
 	int port0, last_port0;	/* Reg 0, in case it's REV A */
 	int port1, last_port1;	/* Register 1 for REV C cards */
 	int i;
@@ -813,7 +826,7 @@ static int __devinit pcwd_isa_match(struct device *dev, unsigned int id)
 		printk(KERN_DEBUG PFX "pcwd_isa_match id=%d\n",
 			id);
 
-	if (!request_region (base_addr, 4, "PCWD")) {
+	if (!request_region(base_addr, 4, "PCWD")) {
 		printk(KERN_INFO PFX "Port 0x%04x unavailable\n", base_addr);
 		return 0;
 	}
@@ -842,7 +855,7 @@ static int __devinit pcwd_isa_match(struct device *dev, unsigned int id)
 			}
 		}
 	}
-	release_region (base_addr, 4);
+	release_region(base_addr, 4);
 
 	return retval;
 }
@@ -857,7 +870,8 @@ static int __devinit pcwd_isa_probe(struct device *dev, unsigned int id)
 
 	cards_found++;
 	if (cards_found == 1)
-		printk(KERN_INFO PFX "v%s Ken Hollis (kenji@bitgate.com)\n", WD_VER);
+		printk(KERN_INFO PFX "v%s Ken Hollis (kenji@bitgate.com)\n",
+								WD_VER);
 
 	if (cards_found > 1) {
 		printk(KERN_ERR PFX "This driver only supports 1 device\n");
@@ -875,10 +889,11 @@ static int __devinit pcwd_isa_probe(struct device *dev, unsigned int id)
 	/* Check card's revision */
 	pcwd_private.revision = get_revision();
 
-	if (!request_region(pcwd_private.io_addr, (pcwd_private.revision == PCWD_REVISION_A) ? 2 : 4, "PCWD")) {
+	if (!request_region(pcwd_private.io_addr,
+		(pcwd_private.revision == PCWD_REVISION_A) ? 2 : 4, "PCWD")) {
 		printk(KERN_ERR PFX "I/O address 0x%04x already in use\n",
 			pcwd_private.io_addr);
-		ret=-EIO;
+		ret = -EIO;
 		goto error_request_region;
 	}
 
@@ -908,26 +923,30 @@ static int __devinit pcwd_isa_probe(struct device *dev, unsigned int id)
 	if (heartbeat == 0)
 		heartbeat = heartbeat_tbl[(pcwd_get_option_switches() & 0x07)];
 
-	/* Check that the heartbeat value is within it's range ; if not reset to the default */
+	/* Check that the heartbeat value is within it's range;
+	   if not reset to the default */
 	if (pcwd_set_heartbeat(heartbeat)) {
 		pcwd_set_heartbeat(WATCHDOG_HEARTBEAT);
-		printk(KERN_INFO PFX "heartbeat value must be 2<=heartbeat<=7200, using %d\n",
-			WATCHDOG_HEARTBEAT);
+		printk(KERN_INFO PFX
+		  "heartbeat value must be 2 <= heartbeat <= 7200, using %d\n",
+							WATCHDOG_HEARTBEAT);
 	}
 
 	if (pcwd_private.supports_temp) {
 		ret = misc_register(&temp_miscdev);
 		if (ret) {
-			printk(KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
-				TEMP_MINOR, ret);
+			printk(KERN_ERR PFX
+			    "cannot register miscdev on minor=%d (err=%d)\n",
+							TEMP_MINOR, ret);
 			goto error_misc_register_temp;
 		}
 	}
 
 	ret = misc_register(&pcwd_miscdev);
 	if (ret) {
-		printk(KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
-			WATCHDOG_MINOR, ret);
+		printk(KERN_ERR PFX
+			"cannot register miscdev on minor=%d (err=%d)\n",
+					WATCHDOG_MINOR, ret);
 		goto error_misc_register_watchdog;
 	}
 
@@ -940,7 +959,8 @@ error_misc_register_watchdog:
 	if (pcwd_private.supports_temp)
 		misc_deregister(&temp_miscdev);
 error_misc_register_temp:
-	release_region(pcwd_private.io_addr, (pcwd_private.revision == PCWD_REVISION_A) ? 2 : 4);
+	release_region(pcwd_private.io_addr,
+			(pcwd_private.revision == PCWD_REVISION_A) ? 2 : 4);
 error_request_region:
 	pcwd_private.io_addr = 0x0000;
 	cards_found--;
@@ -964,7 +984,8 @@ static int __devexit pcwd_isa_remove(struct device *dev, unsigned int id)
 	misc_deregister(&pcwd_miscdev);
 	if (pcwd_private.supports_temp)
 		misc_deregister(&temp_miscdev);
-	release_region(pcwd_private.io_addr, (pcwd_private.revision == PCWD_REVISION_A) ? 2 : 4);
+	release_region(pcwd_private.io_addr,
+			(pcwd_private.revision == PCWD_REVISION_A) ? 2 : 4);
 	pcwd_private.io_addr = 0x0000;
 	cards_found--;
 

