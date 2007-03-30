Return-Path: <linux-kernel-owner+w=401wt.eu-S1945973AbXC3LnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945973AbXC3LnX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 07:43:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945975AbXC3LnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 07:43:23 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:2897 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945973AbXC3LnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 07:43:22 -0400
Date: Fri, 30 Mar 2007 12:43:14 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH:cleanup] Make /dev/port conditional on config symbol
Message-ID: <20070330114313.GC21653@flint.arm.linux.org.uk>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of having /dev/port support dependent in multiple places on
a string of preprocessor symbols, define a new configuration directive
for it.  This ensures that all four places remain consistent with
each other.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/char/Kconfig |    6 ++++++
 drivers/char/mem.c   |    8 ++++----
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 3429ece..a754603 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -1038,5 +1038,11 @@ config TELCLOCK
 	  /sys/devices/platform/telco_clock, with a number of files for
 	  controlling the behavior of this hardware.
 
+config DEVPORT
+	bool
+	depends on !M68K
+	depends on ISA || PCI
+	default y
+
 endmenu
 
diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index f5c160c..8bca2f1 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -552,7 +552,7 @@ static ssize_t write_kmem(struct file * file, const char __user * buf,
  	return virtr + wrote;
 }
 
-#if (defined(CONFIG_ISA) || defined(CONFIG_PCI)) && !defined(__mc68000__)
+#ifdef CONFIG_DEVPORT
 static ssize_t read_port(struct file * file, char __user * buf,
 			 size_t count, loff_t *ppos)
 {
@@ -835,7 +835,7 @@ static const struct file_operations null_fops = {
 	.splice_write	= splice_write_null,
 };
 
-#if (defined(CONFIG_ISA) || defined(CONFIG_PCI)) && !defined(__mc68000__)
+#ifdef CONFIG_DEVPORT
 static const struct file_operations port_fops = {
 	.llseek		= memory_lseek,
 	.read		= read_port,
@@ -913,7 +913,7 @@ static int memory_open(struct inode * inode, struct file * filp)
 		case 3:
 			filp->f_op = &null_fops;
 			break;
-#if (defined(CONFIG_ISA) || defined(CONFIG_PCI)) && !defined(__mc68000__)
+#ifdef CONFIG_DEVPORT
 		case 4:
 			filp->f_op = &port_fops;
 			break;
@@ -960,7 +960,7 @@ static const struct {
 	{1, "mem",     S_IRUSR | S_IWUSR | S_IRGRP, &mem_fops},
 	{2, "kmem",    S_IRUSR | S_IWUSR | S_IRGRP, &kmem_fops},
 	{3, "null",    S_IRUGO | S_IWUGO,           &null_fops},
-#if (defined(CONFIG_ISA) || defined(CONFIG_PCI)) && !defined(__mc68000__)
+#ifdef CONFIG_DEVPORT
 	{4, "port",    S_IRUSR | S_IWUSR | S_IRGRP, &port_fops},
 #endif
 	{5, "zero",    S_IRUGO | S_IWUGO,           &zero_fops},

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
