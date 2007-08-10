Return-Path: <linux-kernel-owner+w=401wt.eu-S936118AbXHJMcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936118AbXHJMcX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 08:32:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762589AbXHJMcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 08:32:12 -0400
Received: from cluster-g.mailcontrol.com ([85.115.41.190]:54595 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762562AbXHJMcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 08:32:11 -0400
Message-ID: <46BC5A3A.2030301@csr.com>
Date: Fri, 10 Aug 2007 13:29:46 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Pierre Ossman <drzeus-list@drzeus.cx>,
       Marcel Holtmann <marcel@holtmann.org>
Subject: [patch 5/5] sdio: add sdio_f0_readb() and sdio_f0_writeb()
References: <46BC58E8.50300@csr.com>
In-Reply-To: <46BC58E8.50300@csr.com>
Content-Type: multipart/mixed;
 boundary="------------020807050505070607000805"
X-OriginalArrivalTime: 10 Aug 2007 12:29:58.0679 (UTC) FILETIME=[2A484270:01C7DB4A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020807050505070607000805
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

-- 
David Vrabel, Software Engineer, Drivers group  Tel: +44 (0)1223 692562
CSR plc, Churchill House, Cambridge Business Park, Cowley Road, CB4 0WZ


.

--------------020807050505070607000805
Content-Type: text/x-patch;
 name="sdio-f0-read-write.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="sdio-f0-read-write.patch"

sdio: add sdio_f0_readb() and sdio_f0_writeb()

Add sdio_f0_readb() and sdio_f0_writeb() functions to reading and
writing function 0 registers.  Writes outside the vendor specific CCCR
registers (0xF0 - 0xFF) are not permitted.

Signed-off-by: David Vrabel <david.vrabel@csr.com>
---
Index: mmc/drivers/mmc/core/sdio_io.c
===================================================================
--- mmc.orig/drivers/mmc/core/sdio_io.c	2007-08-10 01:15:54.000000000 +0100
+++ mmc/drivers/mmc/core/sdio_io.c	2007-08-10 01:20:24.000000000 +0100
@@ -493,3 +493,69 @@
 
 EXPORT_SYMBOL_GPL(sdio_writel);
 
+/**
+ *	sdio_f0_readb - read a single byte from SDIO function 0
+ *	@func: an SDIO function of the card
+ *	@addr: address to read
+ *	@err_ret: optional status value from transfer
+ *
+ *	Reads a single byte from the address space of SDIO function 0.
+ *	If there is a problem reading the address, 0xff is returned
+ *	and @err_ret will contain the error code.
+ */
+unsigned char sdio_f0_readb(struct sdio_func *func, unsigned int addr,
+	int *err_ret)
+{
+	int ret;
+	unsigned char val;
+
+	BUG_ON(!func);
+
+	if (err_ret)
+		*err_ret = 0;
+
+	ret = mmc_io_rw_direct(func->card, 0, 0, addr, 0, &val);
+	if (ret) {
+		if (err_ret)
+			*err_ret = ret;
+		return 0xFF;
+	}
+
+	return val;
+}
+
+EXPORT_SYMBOL_GPL(sdio_f0_readb);
+
+/**
+ *	sdio_f0_writeb - write a single byte to SDIO function 0
+ *	@func: an SDIO function of the card
+ *	@b: byte to write
+ *	@addr: address to write to
+ *	@err_ret: optional status value from transfer
+ *
+ *	Writes a single byte to the address space of SDIO function 0.
+ *	@err_ret will contain the status of the actual transfer.
+ *
+ *	Only writes to the vendor specific CCCR registers (0xF0 -
+ *	0xFF) are permiited; @err_ret will be set to -EINVAL for *
+ *	writes outside this range.
+ */
+void sdio_f0_writeb(struct sdio_func *func, unsigned char b, unsigned int addr,
+	int *err_ret)
+{
+	int ret;
+
+	BUG_ON(!func);
+
+	if (addr < 0xF0 || addr > 0xFF) {
+		if (err_ret)
+			*err_ret = -EINVAL;
+		return;
+	}
+
+	ret = mmc_io_rw_direct(func->card, 1, 0, addr, b, NULL);
+	if (err_ret)
+		*err_ret = ret;
+}
+
+EXPORT_SYMBOL_GPL(sdio_f0_writeb);
Index: mmc/include/linux/mmc/sdio_func.h
===================================================================
--- mmc.orig/include/linux/mmc/sdio_func.h	2007-08-10 01:15:54.000000000 +0100
+++ mmc/include/linux/mmc/sdio_func.h	2007-08-10 01:16:09.000000000 +0100
@@ -141,5 +141,10 @@
 extern int sdio_writesb(struct sdio_func *func, unsigned int addr,
 	void *src, int count);
 
+extern unsigned char sdio_f0_readb(struct sdio_func *func,
+	unsigned int addr, int *err_ret);
+extern void sdio_f0_writeb(struct sdio_func *func, unsigned char b,
+	unsigned int addr, int *err_ret);
+
 #endif
 

--------------020807050505070607000805--
