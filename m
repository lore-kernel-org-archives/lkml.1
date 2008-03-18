Return-Path: <linux-kernel-owner+w=401wt.eu-S1761971AbYCSUqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761971AbYCSUqd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:46:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754315AbYCSToN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:44:13 -0400
Received: from mfo32.po.2iij.NET ([210.128.50.15]:13237 "EHLO
	mfo32.po.2iij.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755556AbYCSToA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:44:00 -0400
Message-Id: <200803182251.m2IMphMF024820@po-mbox303.hop.2iij.net>
Date: Wed, 19 Mar 2008 07:51:01 +0900
From: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: yoichi_yuasa@tripeaks.co.jp, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mips <linux-mips@linux-mips.org>
Subject: [PATCH 2/2] add  VR41xx SIU setup for serial console
Organization: TriPeaks Corporation
X-Mailer: Sylpheed version 2.3.0beta5 (GTK+ 2.8.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add VR41xx SIU setup for serial console.

Signed-off-by: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>

diff -pruN -X /home/yuasa/Memo/dontdiff linux-orig/arch/mips/vr41xx/common/init.c linux/arch/mips/vr41xx/common/init.c
--- linux-orig/arch/mips/vr41xx/common/init.c	2008-03-12 17:03:15.200969168 +0900
+++ linux/arch/mips/vr41xx/common/init.c	2008-03-12 17:03:38.574609820 +0900
@@ -1,7 +1,7 @@
 /*
  *  init.c, Common initialization routines for NEC VR4100 series.
  *
- *  Copyright (C) 2003-2005  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ *  Copyright (C) 2003-2008  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
@@ -53,6 +53,8 @@ void __init plat_time_init(void)
 void __init plat_mem_setup(void)
 {
 	iomem_resource_init();
+
+	vr41xx_siu_setup();
 }
 
 void __init prom_init(void)
diff -pruN -X /home/yuasa/Memo/dontdiff linux-orig/arch/mips/vr41xx/common/siu.c linux/arch/mips/vr41xx/common/siu.c
--- linux-orig/arch/mips/vr41xx/common/siu.c	2008-03-12 17:03:15.200969168 +0900
+++ linux/arch/mips/vr41xx/common/siu.c	2008-03-12 17:05:49.337802432 +0900
@@ -1,7 +1,7 @@
 /*
  *  NEC VR4100 series SIU platform device.
  *
- *  Copyright (C) 2007  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ *  Copyright (C) 2007-2008  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
@@ -118,3 +118,37 @@ err_free_device:
 	return retval;
 }
 device_initcall(vr41xx_siu_add);
+
+void __init vr41xx_siu_setup(void)
+{
+	struct uart_port port;
+	struct resource *res;
+	unsigned int *type;
+	int i;
+
+	switch (current_cpu_type()) {
+	case CPU_VR4111:
+	case CPU_VR4121:
+		type = siu_type1_ports;
+		res = siu_type1_resource;
+		break;
+	case CPU_VR4122:
+	case CPU_VR4131:
+	case CPU_VR4133:
+		type = siu_type2_ports;
+		res = siu_type2_resource;
+		break;
+	default:
+		return;
+	}
+
+	for (i = 0; i < SIU_PORTS_MAX; i++) {
+		port.line = i;
+		port.type = type[i];
+		if (port.type == PORT_UNKNOWN)
+			break;
+		port.mapbase = res[i].start;
+		port.membase = (unsigned char __iomem *)KSEG1ADDR(res[i].start);
+		vr41xx_siu_early_setup(&port);
+	}
+}
diff -pruN -X /home/yuasa/Memo/dontdiff linux-orig/include/asm-mips/vr41xx/vr41xx.h linux/include/asm-mips/vr41xx/vr41xx.h
--- linux-orig/include/asm-mips/vr41xx/vr41xx.h	2008-03-12 17:04:01.248560582 +0900
+++ linux/include/asm-mips/vr41xx/vr41xx.h	2008-03-12 17:03:38.730540709 +0900
@@ -7,7 +7,7 @@
  * Copyright (C) 2001, 2002 Paul Mundt
  * Copyright (C) 2002 MontaVista Software, Inc.
  * Copyright (C) 2002 TimeSys Corp.
- * Copyright (C) 2003-2005 Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ * Copyright (C) 2003-2008 Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the
@@ -143,4 +143,10 @@ extern void vr41xx_disable_csiint(uint16
 extern void vr41xx_enable_bcuint(void);
 extern void vr41xx_disable_bcuint(void);
 
+#ifdef CONFIG_SERIAL_VR41XX_CONSOLE
+extern void vr41xx_siu_setup(void);
+#else
+static inline void vr41xx_siu_setup(void) {}
+#endif
+
 #endif /* __NEC_VR41XX_H */
diff -pruN -X /home/yuasa/Memo/dontdiff linux-orig/include/asm-mips/vr41xx/siu.h linux/include/asm-mips/vr41xx/siu.h
--- linux-orig/include/asm-mips/vr41xx/siu.h	2008-03-12 17:04:01.248560582 +0900
+++ linux/include/asm-mips/vr41xx/siu.h	2008-03-12 17:03:38.730540709 +0900
@@ -1,7 +1,7 @@
 /*
  *  Include file for NEC VR4100 series Serial Interface Unit.
  *
- *  Copyright (C) 2005  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ *  Copyright (C) 2005-2008  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
@@ -49,4 +49,10 @@ typedef enum {
 
 extern void vr41xx_select_irda_module(irda_module_t module, irda_speed_t speed);
 
+#ifdef CONFIG_SERIAL_VR41XX_CONSOLE
+extern void vr41xx_siu_early_setup(struct uart_port *port);
+#else
+static inline void vr41xx_siu_early_setup(struct uart_port *port) {}
+#endif
+
 #endif /* __NEC_VR41XX_SIU_H */
