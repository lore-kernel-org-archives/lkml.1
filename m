Return-Path: <linux-kernel-owner+w=401wt.eu-S933500AbYBTUY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933500AbYBTUY0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 15:24:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752994AbYBTUYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 15:24:15 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:44379 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753900AbYBTUYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 15:24:13 -0500
Date: Wed, 20 Feb 2008 20:14:41 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] esp: lock_kernel push down
Message-ID: <20080220201441.6e84292b@core>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Push the BKL down into a few internal bits of code in this driver.

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc2-mm1/drivers/char/esp.c linux-2.6.25-rc2-mm1/drivers/char/esp.c
--- linux.vanilla-2.6.25-rc2-mm1/drivers/char/esp.c	2008-02-19 11:03:00.000000000 +0000
+++ linux-2.6.25-rc2-mm1/drivers/char/esp.c	2008-02-20 11:45:43.000000000 +0000
@@ -1355,6 +1355,7 @@
 {
 	struct serial_struct tmp;
   
+	lock_kernel();
 	memset(&tmp, 0, sizeof(tmp));
 	tmp.type = PORT_16550A;
 	tmp.line = info->line;
@@ -1367,6 +1368,7 @@
 	tmp.closing_wait = info->closing_wait;
 	tmp.custom_divisor = info->custom_divisor;
 	tmp.hub6 = 0;
+	unlock_kernel();
 	if (copy_to_user(retinfo,&tmp,sizeof(*retinfo)))
 		return -EFAULT;
 	return 0;
@@ -1381,6 +1383,7 @@
 		return -EFAULT;
 
 	memset(&tmp, 0, sizeof(tmp));
+	lock_kernel();
 	tmp.rx_timeout = info->config.rx_timeout;
 	tmp.rx_trigger = info->config.rx_trigger;
 	tmp.tx_trigger = info->config.tx_trigger;
@@ -1388,7 +1391,8 @@
 	tmp.flow_on = info->config.flow_on;
 	tmp.pio_threshold = info->config.pio_threshold;
 	tmp.dma_channel = (info->stat_flags & ESP_STAT_NEVER_DMA ? 0 : dma);
-
+	unlock_kernel();
+	
 	return copy_to_user(retinfo, &tmp, sizeof(*retinfo)) ? -EFAULT : 0;
 }
 
@@ -1766,6 +1770,7 @@
 	struct serial_icounter_struct __user *p_cuser;	/* user space */
 	void __user *argp = (void __user *)arg;
 	unsigned long flags;
+	int ret;
 
 	if (serial_paranoia_check(info, tty->name, "rs_ioctl"))
 		return -ENODEV;
@@ -1783,7 +1788,10 @@
 		case TIOCGSERIAL:
 			return get_serial_info(info, argp);
 		case TIOCSSERIAL:
-			return set_serial_info(info, argp);
+			lock_kernel();
+			ret = set_serial_info(info, argp);
+			unlock_kernel();
+			return ret;
 		case TIOCSERCONFIG:
 			/* do not reconfigure after initial configuration */
 			return 0;
@@ -1855,11 +1863,13 @@
 				return -EFAULT;
 
 			return 0;
-	case TIOCGHAYESESP:
-		return get_esp_config(info, argp);
-	case TIOCSHAYESESP:
-		return set_esp_config(info, argp);
-
+		case TIOCGHAYESESP:
+			return get_esp_config(info, argp);
+		case TIOCSHAYESESP:
+			lock_kernel();
+			ret = set_esp_config(info, argp);
+			unlock_kernel();
+			return ret;
 		default:
 			return -ENOIOCTLCMD;
 		}
