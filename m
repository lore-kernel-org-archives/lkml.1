Return-Path: <linux-kernel-owner+w=401wt.eu-S1754194AbZKVCFJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194AbZKVCFJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 21:05:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754126AbZKVCFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 21:05:08 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:30896 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754111AbZKVCFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 21:05:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=B/WVNgGJw6ITyq/QO8FCYS5qjA+9Z4D6yCnBUsrUUg83awC1Wl8nj1Rzs4OiYYLTW6
         N/DM2SOq3IqVKVAeHnPG40FENvarOCOiZuDMChYpn/u1Z4aWGRf81F/ottqrPO8iOIzt
         0vpcg63WUfNOh85FmrHYnlUFiSL3EmJK9G1mM=
Subject: RFC: Put printk buffer in video ram
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 22 Nov 2009 04:05:06 +0200
Message-ID: <1258855506.3153.1.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After doing some successful debugging by placing printk buffer in video
ram, here I publish cleaned version of it.

I discovered that on my system video ram isn't cleared on reboot, and I
took advantage of that by placing printk buffer directly there.
This allows to capture oopses/panicks almost from everywhere.
It is also very simple to setup.


Best regards,
Maxim Levitsky

---

>From 77e0f4ffc531417d54ce928ade8481d82192b012 Mon Sep 17 00:00:00 2001
From: Maxim Levitsky <maximlevitsky@gmail.com>
Date: Sun, 22 Nov 2009 03:49:04 +0200
Subject: [PATCH] printk: Allow to store log buffer into video memory

This patch adds new kernel parameter printk_address=
that will allow it to store the printk buffer in arbitary
(I/O) memory address.

If you own a system that has discrete video ram, and it
isn't cleared automatically by BIOS on reboot, you
can use this as a black box recorder of crashes.

If debugfs is enabled, log of last boot is copied into
system ram, and can be accessed via debugfs, for example
cat /sys/kernel/debug/printk/crash_dmesg

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 kernel/printk.c   |  102 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 lib/Kconfig.debug |   31 ++++++++++++++++
 2 files changed, 133 insertions(+), 0 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index f38b07f..c6a6f6a 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -33,6 +33,7 @@
 #include <linux/bootmem.h>
 #include <linux/syscalls.h>
 #include <linux/kexec.h>
+#include <linux/debugfs.h>
 
 #include <asm/uaccess.h>
 
@@ -143,6 +144,7 @@ static char __log_buf[__LOG_BUF_LEN];
 static char *log_buf = __log_buf;
 static int log_buf_len = __LOG_BUF_LEN;
 static unsigned logged_chars; /* Number of chars produced since last read+clear operation */
+static unsigned int printk_address;
 
 #ifdef CONFIG_KEXEC
 /*
@@ -167,6 +169,9 @@ static int __init log_buf_len_setup(char *str)
 	unsigned size = memparse(str, &str);
 	unsigned long flags;
 
+	if (printk_address)
+		return 1;
+
 	if (size)
 		size = roundup_pow_of_two(size);
 	if (size > log_buf_len) {
@@ -203,6 +208,103 @@ out:
 
 __setup("log_buf_len=", log_buf_len_setup);
 
+
+#ifdef CONFIG_HWMEM_PRINTK
+
+#define EARLY_LOG_PAGES (8 * PAGE_SIZE)
+char *old_log_buf;
+struct debugfs_blob_wrapper crash_dmesg_wrapper;
+
+static int __init printk_address_setup(char *str)
+{
+	unsigned long flags;
+	void *mem_address;
+
+	get_option(&str, &printk_address);
+	if (!printk_address)
+		return 0;
+
+	/* temporarly map first few pages of log memory */
+	mem_address = early_ioremap(printk_address,  EARLY_LOG_PAGES);
+	if (!mem_address)
+		return 0;
+
+	printk(KERN_INFO "Logging kernel messages into HW memory at %08x\n",
+								printk_address);
+	/* allocate saved log buffer, and save the log memory that we
+	  will otherwise overwrite */
+	old_log_buf = alloc_bootmem(__LOG_BUF_LEN);
+	if (old_log_buf)
+		memcpy(old_log_buf, mem_address, EARLY_LOG_PAGES);
+
+	/* clear log memory now */
+	memset(mem_address, 0, EARLY_LOG_PAGES);
+
+	/* copy current printk buffer to log memory, and switch to new buffer */
+	spin_lock_irqsave(&logbuf_lock, flags);
+	memcpy(mem_address, log_buf, EARLY_LOG_PAGES);
+	log_buf = mem_address;
+	log_buf_len = EARLY_LOG_PAGES;
+	spin_unlock_irqrestore(&logbuf_lock, flags);
+
+	return 1;
+}
+__setup("printk_address=", printk_address_setup);
+
+static int printk_address_late(void)
+{
+
+	char *mem_address, *early_mem_address;
+	unsigned long flags;
+	struct dentry *dbgfs_dir;
+
+	if (!printk_address)
+		return 0;
+
+	/* now do late initialization */
+	mem_address = ioremap(printk_address,  __LOG_BUF_LEN);
+
+	if (!mem_address) {
+		printk(KERN_ALERT "Can't fully map hardware kernel log memory."
+			" Log buffer limited to %lu KB\n", EARLY_LOG_PAGES);
+		return  0;
+	}
+
+	/* save the rest of log memory, and publish it */
+	if (old_log_buf) {
+		memcpy(old_log_buf + EARLY_LOG_PAGES,
+			mem_address + EARLY_LOG_PAGES,
+				__LOG_BUF_LEN - EARLY_LOG_PAGES);
+
+		crash_dmesg_wrapper.data = old_log_buf;
+		crash_dmesg_wrapper.size = __LOG_BUF_LEN;
+
+		dbgfs_dir = debugfs_create_dir("printk", NULL);
+
+		if (dbgfs_dir > 0)
+			debugfs_create_blob("crash_dmesg", S_IRUSR, dbgfs_dir,
+				&crash_dmesg_wrapper);
+	}
+
+	/* clear rest of the log memory now */
+	memset(mem_address + EARLY_LOG_PAGES , 0,
+		__LOG_BUF_LEN - EARLY_LOG_PAGES);
+
+
+	/* switch to the full log memory now */
+	spin_lock_irqsave(&logbuf_lock, flags);
+	early_mem_address = log_buf;
+	log_buf = mem_address;
+	log_buf_len = __LOG_BUF_LEN;
+	spin_unlock_irqrestore(&logbuf_lock, flags);
+
+	/* free temp mapping of the log memory */
+	early_iounmap(early_mem_address, EARLY_LOG_PAGES);
+	return 1;
+}
+postcore_initcall(printk_address_late);
+#endif
+
 #ifdef CONFIG_BOOT_PRINTK_DELAY
 
 static unsigned int boot_delay; /* msecs delay after each printk during bootup */
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 234ceb1..e5788b1 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -716,6 +716,37 @@ config BOOT_PRINTK_DELAY
 	  BOOT_PRINTK_DELAY also may cause DETECT_SOFTLOCKUP to detect
 	  what it believes to be lockup conditions.
 
+config HWMEM_PRINTK
+	bool "Log printk message buffer into video ram (DANGEROUS)"
+	depends on DEBUG_KERNEL && PRINTK
+	help
+	  This option allows to place kernel log buffer into pre-defined
+	  area, somewhere in memory space.
+	  It is intended to place this buffer into video ram assuming it
+	  isn't cleared on reboot.
+	  This creates some sort of black box recorder and can be very useful
+	  to debug several problems, especially 'panics' that happen while you
+	  use the X window system.
+
+	  To use, first ensure that you aren't using X, or that you tell video
+	  driver not to use all the video ram
+	  (easy way is to use the 'vesa' X driver)
+
+	  Then, pick an address within the video memory,
+	  (best somewhere in middle), and boot kernel with
+	  printk_address=$ADDRESS
+
+	  If you also select debugfs support, you can easily look at
+	  kernel log of failed boot at:
+	  /sys/kernel/debug/printk/crash_dmesg
+
+	  (Assuming you mounted debugfs on /sys/kernel/debug)
+
+	  Misuse of this option can be DANGEROUS, as it makes kernel write at
+	  arbitrary (selected by you) hardware memory range.
+
+	  It is only intended for debugging, so say 'no' if not sure
+
 config RCU_TORTURE_TEST
 	tristate "torture tests for RCU"
 	depends on DEBUG_KERNEL
-- 
1.6.3.3




