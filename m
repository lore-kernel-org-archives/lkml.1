Return-Path: <linux-kernel-owner+w=401wt.eu-S1766915AbXDSTAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766915AbXDSTAw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 15:00:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766928AbXDSTAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 15:00:52 -0400
Received: from outmx023.isp.belgacom.be ([195.238.4.204]:52604 "EHLO
	outmx023.isp.belgacom.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766915AbXDSTA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 15:00:29 -0400
Date: Thu, 19 Apr 2007 21:00:55 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, holger@eiboeck.de
Subject: Re: RFC: drivers/char/watchdog/pcwd.c + drivers/char/watchdog/pcwd_pci.c
Message-ID: <20070419190055.GA31632@infomag.infomag.iguana.be>
References: <20070417185849.GA2632@infomag.infomag.iguana.be> <20070417131624.5ae58d63.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070417131624.5ae58d63.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

> > On Tue, 17 Apr 2007 20:58:49 +0200 Wim Van Sebroeck <wim@iguana.be> wrote:
> > Would anyone object if we would merge the "full bells and whistles" drivers for
> > the pcwd isa and pci cards in the kernel tree. (It basically only adds some extra
> > /proc routines). This would make it easier to maintain the "full bells and whistles"
> > driver.
> 
> It's hard to answer that question.  Please send the patches out in the
> usual manner for review and comment.

for the pcwd.c driver the patch would be as follows (see below).
I'll create the patch for pcwd_pci.c later this week.

Greetings,
Wim.

---------------------------------------------------------------------------------------
--- pcwd.c	2007-03-26 20:11:29.000000000 +0000
+++ pcwd.c	2007-04-19 18:40:04.000000000 +0000
@@ -1,9 +1,18 @@
 /*
- * PC Watchdog Driver
- * by Ken Hollis (khollis@bitgate.com)
+ *	Berkshire ISA-PC Watchdog Card Driver
+ *	by Ken Hollis (khollis@bitgate.com)
  *
- * Permission granted from Simon Machell (smachell@berkprod.com)
- * Written for the Linux Kernel, and GPLed by Ken Hollis
+ *	Permission granted from Simon Machell (smachell@berkprod.com)
+ *	Written for the Linux Kernel, and GPLed by Ken Hollis
+ *
+ *	More info available at http://www.berkprod.com/ or http://www.pcwatchdog.com/
+ *
+ *	Copyright (c) 1998-2002 Holger Eiboeck  <holger@eiboeck.de>,
+ *				  All Rights Reserved.
+ *
+ *	http://www.pcwd.de/
+ *
+ *	(c) Copyright 2005-2007 Wim Van Sebroeck <wim@iguana.be>.
  *
  * 960107	Added request_region routines, modulized the whole thing.
  * 960108	Fixed end-of-file pointer (Thanks to Dan Hollis), added
@@ -45,8 +54,7 @@
  */
 
 /*
- *	A bells and whistles driver is available from http://www.pcwd.de/
- *	More info available at http://www.berkprod.com/ or http://www.pcwatchdog.com/
+ *      Includes, defines, variables, module parameters, ...
  */
 
 #include <linux/module.h>	/* For module specific items */
@@ -65,13 +73,18 @@
 #include <linux/fs.h>		/* For file operations */
 #include <linux/ioport.h>	/* For io-port access */
 #include <linux/spinlock.h>	/* For spin_lock/spin_unlock/... */
+#include <linux/string.h>	/* For string manipulations */
+#ifdef CONFIG_PROC_FS
+#include <linux/stat.h>		/* For S_IFREG/S_IRUGO/S_IWUSR */
+#include <linux/proc_fs.h>	/* For create_proc_entry/remove_proc_entry/ ... */
+#endif
 
 #include <asm/uaccess.h>	/* For copy_to_user/put_user/... */
 #include <asm/io.h>		/* For inb/outb/... */
 
 /* Module and version information */
-#define WATCHDOG_VERSION "1.18"
-#define WATCHDOG_DATE "21 Jan 2007"
+#define WATCHDOG_VERSION "1.52"
+#define WATCHDOG_DATE "18 Apr 2007"
 #define WATCHDOG_DRIVER_NAME "ISA-PC Watchdog"
 #define WATCHDOG_NAME "pcwd"
 #define PFX WATCHDOG_NAME ": "
@@ -155,6 +168,10 @@
 /* We can only use 1 card due to the /dev/watchdog restriction */
 static int cards_found;
 
+/* pcwd_private.card_status */
+#define DISABLED                0
+#define ENABLED                 1
+
 /* internal variables */
 static atomic_t open_allowed = ATOMIC_INIT(1);
 static char expect_close;
@@ -169,9 +186,21 @@
 	spinlock_t io_lock;		/* the lock for io operations */
 	struct timer_list timer;	/* The timer that pings the watchdog */
 	unsigned long next_heartbeat;	/* the next_heartbeat for the timer */
+	int card_status;		/* The card's status */
+	unsigned int ping_counter;	/* A counter to keep track how many times the watchdog was tickled */
+#ifdef CONFIG_PROC_FS
+	spinlock_t proc_lock;		/* the lock for /proc/ operations */
+	struct proc_dir_entry *proc_pcwd;	/* the /proc/ entry */
+#endif
 } pcwd_private;
 
 /* module parameters */
+#define CELSIUS		0
+#define FAHRENHEIT	1
+static int proc_temp_mode = CELSIUS;
+module_param(proc_temp_mode, int, 0);
+MODULE_PARM_DESC(proc_temp_mode, "which temperature mode to use in /proc/ 0=Celsius, 1=Fahrenheit (default=0)");
+
 #define QUIET	0	/* Default */
 #define VERBOSE	1	/* Verbose */
 #define DEBUG	2	/* print fancy stuff too */
@@ -398,6 +427,7 @@
 		}
 	}
 
+	pcwd_private.card_status=ENABLED;
 	if (debug >= VERBOSE)
 		printk(KERN_DEBUG PFX "Watchdog started\n");
 
@@ -426,6 +456,7 @@
 		}
 	}
 
+	pcwd_private.card_status=DISABLED;
 	if (debug >= VERBOSE)
 		printk(KERN_DEBUG PFX "Watchdog stopped\n");
 
@@ -437,6 +468,9 @@
 	/* user land ping */
 	pcwd_private.next_heartbeat = jiffies + (heartbeat * HZ);
 
+	if (pcwd_private.card_status == ENABLED)
+		pcwd_private.ping_counter++;
+
 	if (debug >= DEBUG)
 		printk(KERN_DEBUG PFX "Watchdog keepalive signal send\n");
 
@@ -533,7 +567,7 @@
 	return 0;
 }
 
-static int pcwd_get_temperature(int *temperature)
+static int pcwd_get_temperature(int *temperature, int temp_mode)
 {
 	/* check that port 0 gives temperature info and no command results */
 	if (pcwd_private.command_mode)
@@ -543,22 +577,358 @@
 	if (!pcwd_private.supports_temp)
 		return -ENODEV;
 
+	spin_lock(&pcwd_private.io_lock);
+	*temperature = inb(pcwd_private.io_addr);
+	spin_unlock(&pcwd_private.io_lock);
+
 	/*
-	 * Convert celsius to fahrenheit, since this was
+	 * Convert celsius to fahrenheit, this is normally
 	 * the decided 'standard' for this return value.
 	 */
-	spin_lock(&pcwd_private.io_lock);
-	*temperature = ((inb(pcwd_private.io_addr)) * 9 / 5) + 32;
-	spin_unlock(&pcwd_private.io_lock);
+	if (temp_mode == FAHRENHEIT)
+		*temperature = (*temperature * 9 / 5) + 32;
 
 	if (debug >= DEBUG) {
-		printk(KERN_DEBUG PFX "temperature is: %d F\n",
-			*temperature);
+		printk(KERN_DEBUG PFX "temperature is: %d %s\n",
+			*temperature, (temp_mode == CELSIUS) ? "C" :"F");
 	}
 
 	return 0;
 }
 
+#ifdef CONFIG_PROC_FS
+static int
+pcwd_reset_pc(void)
+{
+	int rv;
+
+	if (set_command_mode()) {
+		/* Reset PC */
+		printk(KERN_INFO PFX "reseting PC!\n");
+
+		rv = send_isa_command(CMD_ISA_RESET_PC);
+
+		if (!(rv == 0xAA)) {
+			printk(KERN_ERR PFX "Card did not acknowledge reset attempt.\n");
+			unset_command_mode();
+			return 0;
+		}
+
+		unset_command_mode();
+		printk(KERN_INFO PFX "reseting PC ACK!\n");
+
+		pcwd_private.card_status = DISABLED;
+		return 1;
+	}
+	return 0;
+}
+
+static int
+pcwd_set_timeout(char *sub_command)
+{
+	char *new_sub_command = sub_command;
+	int i;
+
+	while (*sub_command == ' ')
+		sub_command++;
+	if (sub_command == new_sub_command) {
+		printk(KERN_ERR PFX "illegal timeout argument '%s'\n", sub_command);
+		return 1;
+	}
+	i = simple_strtoul(sub_command, NULL, 0);
+	if (!pcwd_set_heartbeat(i)) {
+		if (debug >= VERBOSE)
+			printk(KERN_INFO PFX "timeout %d\n", heartbeat);
+	} else {
+		printk(KERN_ERR PFX
+			"illegal timeout argument '%s', should be a number between 2 and 7200\n",
+			sub_command);
+		return 1;
+	}
+	return 0;
+}
+
+static int
+pcwd_set_arm(char *sub_command)
+{
+	char *new_sub_command = sub_command;
+	int i = 0;
+
+	while (*sub_command == ' ')
+		sub_command++;
+	if (sub_command == new_sub_command) {
+		printk(KERN_ERR PFX
+		       "illegal arm argument '%s', should be 0, 30 or 60\n",
+		       sub_command);
+		return 1;
+	}
+
+	set_command_mode();
+
+	if ((strcmp(sub_command, "0") == 0)
+	    || (strcmp(sub_command, "immediately") == 0)) {
+		if ((i = send_isa_command(CMD_ISA_ARM_0)) == 0x87) {
+			if (debug >= VERBOSE)
+				printk(KERN_INFO PFX "arm immediately\n");
+			return 0;
+		}
+	} else if (strcmp(sub_command, "30") == 0) {
+		if ((i = send_isa_command(CMD_ISA_ARM_30)) == 0x88) {
+			if (debug >= VERBOSE)
+				printk(KERN_INFO PFX "arm after 30s more\n");
+			return 0;
+		}
+	} else if (strcmp(sub_command, "60") == 0) {
+		if ((i = send_isa_command(CMD_ISA_ARM_60)) != 0x89) {
+			if (debug >= VERBOSE)
+				printk(KERN_INFO PFX "arm after 60s more\n");
+			return 0;
+		}
+	} else {
+		printk(KERN_ERR PFX
+		       "illegal arm argument '%s', should be 0, 30 or 60\n",
+		       sub_command);
+		return 1;
+	}
+
+	if (i == 0xF5)
+		printk(KERN_INFO PFX "already armed\n");
+
+	unset_command_mode();
+	return 0;
+}
+
+static void
+pcwd_user_help(void)
+{
+	printk(" pcwd proc command interface help:\n");
+	printk("   ping, pong, tickle - tickle the timer\n");
+	printk("   hardreset - reset pc\n");
+	printk("   enable, start - start the watchdog\n");
+	printk("   disable, stop - stop the watchdog\n");
+	printk("   clear - clear trip status and led\n");
+	printk("   verbose, debug, quiet - command reponse\n");
+	printk("   fahrenheit, celsius - display temp in\n");
+	printk(" extended commands:\n");
+	printk("   arm [val] - isa [30,60,90]\n");
+	printk("   timeout [val]\n");
+}
+
+static int
+pcwd_user_command(char *user_command)
+{
+	if ((strcmp(user_command, "ping") == 0)
+	    || (strcmp(user_command, "pong") == 0)
+	    || (strcmp(user_command, "tickle") == 0)) {
+		pcwd_keepalive();
+		if (debug >= VERBOSE)
+			printk(KERN_INFO PFX "ping...\n");
+	} else if ((strcmp(user_command, "enable") == 0)
+	    || (strcmp(user_command, "start") == 0)) {
+		if (!pcwd_start()) {
+			if (debug >= VERBOSE)
+				printk(KERN_INFO PFX "watchdog enabled.\n");
+		}
+	} else if ((strcmp(user_command, "disable") == 0)
+	    || (strcmp(user_command, "stop") == 0)) {
+		if (!pcwd_stop()) {
+			if (debug >= VERBOSE)
+				printk(KERN_INFO PFX "watchdog disabled!\n");
+		}
+	} else if (strcmp(user_command, "clear") == 0) {
+		pcwd_clear_status();
+		if (debug >= VERBOSE)
+			printk(KERN_INFO PFX "cleared trip status\n");
+	} else if (strcmp(user_command, "hardreset") == 0) {
+		pcwd_reset_pc();
+		if (debug >= VERBOSE)
+			printk(KERN_INFO PFX "hardreset PC!\n");
+	} else if (strcmp(user_command, "quiet") == 0) {
+		debug = QUIET;
+	} else if (strcmp(user_command, "verbose") == 0) {
+		debug = VERBOSE;
+		printk(KERN_INFO PFX "verbose mode on.\n");
+	} else if (strcmp(user_command, "debug") == 0) {
+		debug = DEBUG;
+		printk(KERN_INFO PFX "debug mode on.\n");
+	} else if (strcmp(user_command, "celsius") == 0) {
+		proc_temp_mode = CELSIUS;
+		if (debug >= VERBOSE)
+			printk(KERN_INFO PFX "display temp in Celsius.\n");
+	} else if (strcmp(user_command, "fahrenheit") == 0) {
+		proc_temp_mode = FAHRENHEIT;
+		if (debug >= VERBOSE)
+			printk(KERN_INFO PFX "display temp in Fahrenheit.\n");
+	} else if (strcmp(user_command, "help") == 0) {
+		pcwd_user_help();
+	} else if (strncmp(user_command, "arm", 3) == 0) {
+		if ((pcwd_private.fw_ver_str[0] >= '1')
+		    && (pcwd_private.fw_ver_str[2] >= '2')) {
+			if (pcwd_set_arm(&user_command[3])) {
+				printk(KERN_ERR PFX "arm FAILED.\n");
+				return 0;
+			}
+		} else {
+			printk(KERN_ERR
+			       "pcwd: ISA Card and firmware > 1.20 needed.\n");
+			return 0;
+		}
+	} else if (strncmp(user_command, "timeout", 7) == 0) {
+		if (pcwd_set_timeout(&user_command[7])) {
+			printk(KERN_ERR PFX "timeout FAILED.\n");
+			return 0;
+		}
+	} else {
+		printk(KERN_ERR "illegal user command: '%s'\n", user_command);
+		pcwd_user_help();
+		return 0;
+	}
+	return 1;
+}
+
+static int
+pcwd_write_proc(struct file *file, const char *buffer,
+		unsigned long count, void *data)
+{
+	char command_buffer[80];
+	int rc, length;
+
+	/* write only allowed for root users */
+	if (current->euid != 0)
+		return -EACCES;
+
+	if (count > sizeof (command_buffer) - 1)
+		return -EINVAL;
+
+	if (copy_from_user(command_buffer, buffer, count))
+		return -EFAULT;
+
+	command_buffer[count] = '\0';
+	length = strlen(command_buffer);
+	if (command_buffer[length - 1] == '\n')
+		command_buffer[--length] = '\0';
+
+	spin_lock(&pcwd_private.proc_lock);
+	rc = pcwd_user_command(command_buffer);
+	spin_unlock(&pcwd_private.proc_lock);
+	return (rc ? count : -EBUSY);
+}
+
+/* This macro frees the machine specific function from bounds checking and
+ *  * this like that... [from nvram.c]*/
+#define PRINT_PROC(fmt,args...)                         \
+    do {                                                \
+        *len += sprintf( buffer+*len, fmt, ##args );    \
+        if (*begin + *len > offset + size)              \
+            return( 0 );                                \
+        if (*begin + *len < offset) {                   \
+            *begin += *len;                             \
+            *len = 0;                                   \
+        }                                               \
+    } while(0)
+
+static int
+pcwd_proc_info(unsigned char *buf, char *buffer, int *len,
+	       off_t * begin, off_t offset, int size)
+{
+	int sw, i;
+
+	PRINT_PROC("%s\n", DRIVER_VERSION);
+
+	if (pcwd_private.revision == PCWD_REVISION_C) {
+		PRINT_PROC("Firmware     : Version %s\n", pcwd_private.fw_ver_str);
+		PRINT_PROC("Option Switch: Delay Time ");
+		sw = pcwd_get_option_switches();
+		switch (sw & 0x07) {
+		case 0:
+			PRINT_PROC("20 s");
+			break;
+		case 1:
+			PRINT_PROC("40 s");
+			break;
+		case 2:
+			PRINT_PROC("1 min");
+			break;
+		case 3:
+			PRINT_PROC("5 min");
+			break;
+		case 4:
+			PRINT_PROC("10 min");
+			break;
+		case 5:
+			PRINT_PROC("30 min");
+			break;
+		case 6:
+			PRINT_PROC("1 h");
+			break;
+		case 7:
+			PRINT_PROC("2 h");
+			break;
+		}
+		PRINT_PROC((sw & 0x08) ? ", POD on" : ", POD off");
+		PRINT_PROC((sw & 0x10) ? ", TRE on" : ", TRE off");
+		PRINT_PROC((sw & 0x20) ? ", R2M on" : ", R2M off");
+		PRINT_PROC((sw & 0x40) ? ", R1M on" : ", R1M off");
+		PRINT_PROC((sw & 0x80) ? ", RTM on\n" : ", RTM off\n");
+	} else {
+		PRINT_PROC("Firmware ROM not present\n");
+	}
+
+	PRINT_PROC("Temperature  : ");
+	if (pcwd_private.supports_temp && (!pcwd_get_temperature(&i, proc_temp_mode))) {
+		PRINT_PROC("%d ", i);
+		PRINT_PROC((proc_temp_mode == CELSIUS) ? "°C\n" : "°F\n");
+	} else {
+		PRINT_PROC("Card without temp option\n");
+	}
+
+	if (pcwd_private.card_status == ENABLED)
+		PRINT_PROC("Card status  : Timer enabled\n");
+	else
+		PRINT_PROC("Card status  : Timer disabled\n");
+
+	spin_lock(&pcwd_private.io_lock);
+	if (pcwd_private.revision == PCWD_REVISION_A) {
+		sw = inb_p(pcwd_private.io_addr) & WD_WDRST;
+	} else {
+		sw = inb_p(pcwd_private.io_addr + 1) & WD_REVC_WTRP;
+	}
+	spin_unlock(&pcwd_private.io_lock);
+	PRINT_PROC("Reboot status: ");
+	PRINT_PROC(sw ? "Tripped\n" : "Not tripped\n");
+
+	if ((pcwd_private.boot_status & WDIOF_CARDRESET) && (pcwd_private.boot_status & WDIOF_OVERHEAT)) {
+		PRINT_PROC("Boot status  : CPU Overheat  + Watchdog caused reboot\n");
+	} else if (pcwd_private.boot_status & WDIOF_CARDRESET) {
+		PRINT_PROC("Boot status  : Watchdog caused reboot\n");
+	} else if (pcwd_private.boot_status & WDIOF_OVERHEAT) {
+		PRINT_PROC("Boot status  : CPU Overheat\n");
+	} else {
+		PRINT_PROC("Boot status  : Cold boot or reset\n");
+	}
+
+	// PRINT_PROC("Ping Count   : %d\n", ping_counter);
+	return 1;
+}
+
+static int
+pcwd_read_proc(char *buffer, char **start, off_t offset,
+	       int size, int *eof, void *data)
+{
+	int len = 0;
+	off_t begin = 0;
+
+	spin_lock(&pcwd_private.proc_lock);
+	*eof = pcwd_proc_info(NULL, buffer, &len, &begin, offset, size);
+	spin_unlock(&pcwd_private.proc_lock);
+
+	if (offset >= begin + len)
+		return (0);
+	*start = buffer + (offset - begin);	// CORRECTED !!!!
+	return (size < begin + len - offset ? size : begin + len - offset);
+}
+#endif				/* PROC_FS */
+
 /*
  *	/dev/watchdog handling
  */
@@ -598,7 +968,7 @@
 		return put_user(pcwd_private.boot_status, argp);
 
 	case WDIOC_GETTEMP:
-		if (pcwd_get_temperature(&temperature))
+		if (pcwd_get_temperature(&temperature, FAHRENHEIT))
 			return -EFAULT;
 
 		return put_user(temperature, argp);
@@ -711,7 +1081,7 @@
 {
 	int temperature;
 
-	if (pcwd_get_temperature(&temperature))
+	if (pcwd_get_temperature(&temperature, FAHRENHEIT))
 		return -EFAULT;
 
 	if (copy_to_user(buf, &temperature, 1))
@@ -809,7 +1179,8 @@
 
 	cards_found++;
 	if (cards_found == 1)
-		printk(KERN_INFO PFX "v%s Ken Hollis (kenji@bitgate.com)\n", WD_VER);
+		printk(KERN_INFO PFX "v%s by Ken Hollis <kenji@bitgate.com>, Holger Eiboeck <holger@eiboeck.de> & Wim Van Sebroeck <wim@iguana.be>\n",
+			WD_VER);
 
 	if (cards_found > 1) {
 		printk(KERN_ERR PFX "This driver only supports 1 device\n");
@@ -898,6 +1269,14 @@
 		return ret;
 	}
 
+#ifdef CONFIG_PROC_FS
+	if ((pcwd_private.proc_pcwd =
+	     create_proc_entry(WATCHDOG_NAME, S_IFREG | S_IRUGO | S_IWUSR, 0))) {
+		pcwd_private.proc_pcwd->read_proc = pcwd_read_proc;
+		pcwd_private.proc_pcwd->write_proc = pcwd_write_proc;
+	}
+#endif
+
 	printk(KERN_INFO PFX "initialized. heartbeat=%d sec (nowayout=%d)\n",
 		heartbeat, nowayout);
 
@@ -906,6 +1285,11 @@
 
 static void __devexit pcwatchdog_exit(void)
 {
+#ifdef CONFIG_PROC_FS
+	if (pcwd_private.proc_pcwd)
+		remove_proc_entry(WATCHDOG_NAME, 0);
+#endif
+
 	/*  Disable the board  */
 	if (!nowayout)
 		pcwd_stop();
@@ -981,6 +1365,12 @@
 	int i, found = 0;
 
 	spin_lock_init(&pcwd_private.io_lock);
+#ifdef CONFIG_PROC_FS
+	spin_lock_init(&pcwd_private.proc_lock);
+#endif
+
+	if (proc_temp_mode)
+		proc_temp_mode = FAHRENHEIT;
 
 	for (i = 0; pcwd_ioports[i] != 0; i++) {
 		if (pcwd_checkcard(pcwd_ioports[i])) {
@@ -1008,8 +1398,8 @@
 module_init(pcwd_init_module);
 module_exit(pcwd_cleanup_module);
 
-MODULE_AUTHOR("Ken Hollis <kenji@bitgate.com>");
-MODULE_DESCRIPTION("Berkshire ISA-PC Watchdog driver");
+MODULE_AUTHOR("Ken Hollis <kenji@bitgate.com>, Holger Eiboeck <holger@eiboeck.de>, Wim Van Sebroeck <wim@iguana.be>");
+MODULE_DESCRIPTION("Driver for the Berkshire ISA-PC watchdog cards");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
 MODULE_ALIAS_MISCDEV(TEMP_MINOR);
