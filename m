Return-Path: <linux-kernel-owner+w=401wt.eu-S1754812AbZGBPW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812AbZGBPW7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 11:22:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751128AbZGBPWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 11:22:49 -0400
Received: from ey-out-1920.google.com ([74.125.78.144]:57513 "EHLO
	ey-out-1920.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbZGBPWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 11:22:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=o156H0MWR8PR57JVkNS3XpA8ud2r+wx13W9Kuoc+384Db3t71i1pqjMOy2pA4kKKyE
         W24+7FzaZUZNKNUUEDfgqlQ71Is3+xEDrVD8HkoPk0BvOvkrC4EEqFMQoR4zuw2cYDer
         8MnbrLPlIQVTQIZm7wInAzVCNSgekym85JTcA=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
       ralf@linux-mips.org
Cc: Wu Zhangjin <wuzj@lemote.com>, Yan Hua <yanh@lemote.com>,
       Philippe Vachon <philippe@cowpig.ca>, Zhang Le <r0bertz@gentoo.org>,
       Zhang Fuxin <zhangfx@lemote.com>,
       loongson-dev <loongson-dev@googlegroups.com>,
       Liu Junliang <liujl@lemote.com>, Erwan Lerale <erwan@thiscow.com>,
       Arnaud Patard <apatard@mandriva.com>
Subject: [PATCH v4 07/16] [loongson] split the implementation of prom,setup parts
Date: Thu,  2 Jul 2009 23:22:36 +0800
Message-Id: <f458e31055182d8bea4b46d55c14922949e865f5.1246546684.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <cover.1246546684.git.wuzhangjin@gmail.com>
References: <cover.1246546684.git.wuzhangjin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzj@lemote.com>

This patch split the old initilization and setup implementation to
several file, one file one logic function.

the other main changes include:

	1. as the script/checkpatch.pl suggests, use strict_strtol instead
	of simple_strtol in arch/mips/lemote/lm2e/cmdline.c

	2. use the existed macros in asm/mips-boards/bonito64.h as the
	arguments of set_io_port_base() and remove the un-needed ones in
	asm/mach-lemote/pci.h

Signed-off-by: Wu Zhangjin <wuzj@lemote.com>
---
 arch/mips/include/asm/mach-lemote/pci.h |    1 -
 arch/mips/lemote/lm2e/Makefile          |    3 +-
 arch/mips/lemote/lm2e/cmdline.c         |   53 ++++++++++++++++++
 arch/mips/lemote/lm2e/env.c             |   60 ++++++++++++++++++++
 arch/mips/lemote/lm2e/init.c            |   34 ++++++++++++
 arch/mips/lemote/lm2e/machtype.c        |   15 +++++
 arch/mips/lemote/lm2e/mem.c             |   13 +++++
 arch/mips/lemote/lm2e/prom.c            |   91 -------------------------------
 arch/mips/lemote/lm2e/setup.c           |   33 +-----------
 arch/mips/lemote/lm2e/time.c            |   30 ++++++++++
 10 files changed, 208 insertions(+), 125 deletions(-)
 create mode 100644 arch/mips/lemote/lm2e/cmdline.c
 create mode 100644 arch/mips/lemote/lm2e/env.c
 create mode 100644 arch/mips/lemote/lm2e/init.c
 create mode 100644 arch/mips/lemote/lm2e/machtype.c
 delete mode 100644 arch/mips/lemote/lm2e/prom.c
 create mode 100644 arch/mips/lemote/lm2e/time.c

diff --git a/arch/mips/include/asm/mach-lemote/pci.h b/arch/mips/include/asm/mach-lemote/pci.h
index ea6aa14..0307e49 100644
--- a/arch/mips/include/asm/mach-lemote/pci.h
+++ b/arch/mips/include/asm/mach-lemote/pci.h
@@ -25,6 +25,5 @@
 #define LOONGSON2E_PCI_MEM_START	0x14000000UL
 #define LOONGSON2E_PCI_MEM_END		0x1fffffffUL
 #define LOONGSON2E_PCI_IO_START		0x00004000UL
-#define LOONGSON2E_IO_PORT_BASE		0x1fd00000UL
 
 #endif /* !_LEMOTE_PCI_H_ */
diff --git a/arch/mips/lemote/lm2e/Makefile b/arch/mips/lemote/lm2e/Makefile
index f191732..a5bc1ef 100644
--- a/arch/mips/lemote/lm2e/Makefile
+++ b/arch/mips/lemote/lm2e/Makefile
@@ -2,7 +2,8 @@
 # Makefile for Lemote Fulong mini-PC board.
 #
 
-obj-y += setup.o prom.o reset.o irq.o pci.o bonito-irq.o mem.o
+obj-y += setup.o init.o reset.o irq.o pci.o bonito-irq.o mem.o \
+		env.o cmdline.o time.o machtype.o
 
 #
 # Early printk support
diff --git a/arch/mips/lemote/lm2e/cmdline.c b/arch/mips/lemote/lm2e/cmdline.c
new file mode 100644
index 0000000..442b935
--- /dev/null
+++ b/arch/mips/lemote/lm2e/cmdline.c
@@ -0,0 +1,53 @@
+/*
+ * Based on Ocelot Linux port, which is
+ * Copyright 2001 MontaVista Software Inc.
+ * Author: jsun@mvista.com or jsun@junsun.net
+ *
+ * Copyright 2003 ICT CAS
+ * Author: Michael Guo <guoyi@ict.ac.cn>
+ *
+ * Copyright (C) 2007 Lemote Inc. & Insititute of Computing Technology
+ * Author: Fuxin Zhang, zhangfx@lemote.com
+ *
+ * Copyright (C) 2009 Lemote Inc. & Insititute of Computing Technology
+ * Author: Wu Zhangjin, wuzj@lemote.com
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+#include <linux/io.h>
+#include <linux/init.h>
+
+#include <asm/bootinfo.h>
+
+int prom_argc;
+/* pmon passes arguments in 32bit pointers */
+int *_prom_argv;
+
+void __init prom_init_cmdline(void)
+{
+	int i;
+	long l;
+
+	/* firmware arguments are initialized in head.S */
+	prom_argc = fw_arg0;
+	_prom_argv = (int *)fw_arg1;
+
+	/* arg[0] is "g", the rest is boot parameters */
+	arcs_cmdline[0] = '\0';
+	for (i = 1; i < prom_argc; i++) {
+		l = (long)_prom_argv[i];
+		if (strlen(arcs_cmdline) + strlen(((char *)l) + 1)
+		    >= sizeof(arcs_cmdline))
+			break;
+		strcat(arcs_cmdline, ((char *)l));
+		strcat(arcs_cmdline, " ");
+	}
+
+	if ((strstr(arcs_cmdline, "console=")) == NULL)
+		strcat(arcs_cmdline, " console=ttyS0,115200");
+	if ((strstr(arcs_cmdline, "root=")) == NULL)
+		strcat(arcs_cmdline, " root=/dev/hda1");
+}
diff --git a/arch/mips/lemote/lm2e/env.c b/arch/mips/lemote/lm2e/env.c
new file mode 100644
index 0000000..9e88409
--- /dev/null
+++ b/arch/mips/lemote/lm2e/env.c
@@ -0,0 +1,60 @@
+/*
+ * Based on Ocelot Linux port, which is
+ * Copyright 2001 MontaVista Software Inc.
+ * Author: jsun@mvista.com or jsun@junsun.net
+ *
+ * Copyright 2003 ICT CAS
+ * Author: Michael Guo <guoyi@ict.ac.cn>
+ *
+ * Copyright (C) 2007 Lemote Inc. & Insititute of Computing Technology
+ * Author: Fuxin Zhang, zhangfx@lemote.com
+ *
+ * Copyright (C) 2009 Lemote Inc. & Insititute of Computing Technology
+ * Author: Wu Zhangjin, wuzj@lemote.com
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/io.h>
+#include <linux/init.h>
+
+#include <asm/bootinfo.h>
+
+unsigned long bus_clock, cpu_clock_freq;
+unsigned long memsize, highmemsize;
+
+/* pmon passes arguments in 32bit pointers */
+int *_prom_envp;
+
+#define parse_even_earlier(res, option, p)				\
+do {									\
+	if (strncmp(option, (char *)p, strlen(option)) == 0)		\
+			strict_strtol((char *)p + strlen(option"="),	\
+					10, &res);			\
+} while (0)
+
+void __init prom_init_env(void)
+{
+	long l;
+
+	/* firmware arguments are initialized in head.S */
+	_prom_envp = (int *)fw_arg2;
+
+	l = (long)*_prom_envp;
+	while (l != 0) {
+		parse_even_earlier(bus_clock, "busclock", l);
+		parse_even_earlier(cpu_clock_freq, "cpuclock", l);
+		parse_even_earlier(memsize, "memsize", l);
+		parse_even_earlier(highmemsize, "highmemsize", l);
+		_prom_envp++;
+		l = (long)*_prom_envp;
+	}
+	if (memsize == 0)
+		memsize = 256;
+
+	pr_info("busclock=%ld, cpuclock=%ld, memsize=%ld, highmemsize=%ld\n",
+		bus_clock, cpu_clock_freq, memsize, highmemsize);
+}
diff --git a/arch/mips/lemote/lm2e/init.c b/arch/mips/lemote/lm2e/init.c
new file mode 100644
index 0000000..6fe624d
--- /dev/null
+++ b/arch/mips/lemote/lm2e/init.c
@@ -0,0 +1,34 @@
+/*
+ * Copyright (C) 2009 Lemote Inc. & Insititute of Computing Technology
+ * Author: Wu Zhangjin, wuzj@lemote.com
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/init.h>
+#include <linux/bootmem.h>
+
+#include <asm/bootinfo.h>
+#include <asm/mips-boards/bonito64.h>
+
+extern void __init prom_init_cmdline(void);
+extern void __init prom_init_env(void);
+extern void __init prom_init_memory(void);
+
+void __init prom_init(void)
+{
+    /* init base address of io space */
+	set_io_port_base((unsigned long)
+		ioremap(BONITO_PCIIO_BASE, BONITO_PCIIO_SIZE));
+
+	prom_init_cmdline();
+	prom_init_env();
+	prom_init_memory();
+}
+
+void __init prom_free_prom_memory(void)
+{
+}
diff --git a/arch/mips/lemote/lm2e/machtype.c b/arch/mips/lemote/lm2e/machtype.c
new file mode 100644
index 0000000..8d803ee
--- /dev/null
+++ b/arch/mips/lemote/lm2e/machtype.c
@@ -0,0 +1,15 @@
+/*
+ * Copyright (C) 2009 Lemote Inc. & Insititute of Computing Technology
+ * Author: Wu Zhangjin, wuzj@lemote.com
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+const char *get_system_type(void)
+{
+	return "lemote-fulong";
+}
+
diff --git a/arch/mips/lemote/lm2e/mem.c b/arch/mips/lemote/lm2e/mem.c
index 16cd215..f24af70 100644
--- a/arch/mips/lemote/lm2e/mem.c
+++ b/arch/mips/lemote/lm2e/mem.c
@@ -8,6 +8,19 @@
 #include <linux/fcntl.h>
 #include <linux/mm.h>
 
+#include <asm/bootinfo.h>
+
+extern unsigned long memsize, highmemsize;
+
+void __init prom_init_memory(void)
+{
+    add_memory_region(0x0, (memsize << 20), BOOT_MEM_RAM);
+#ifdef CONFIG_64BIT
+    if (highmemsize > 0)
+		add_memory_region(0x20000000, highmemsize << 20, BOOT_MEM_RAM);
+#endif /* CONFIG_64BIT */
+}
+
 /* override of arch/mips/mm/cache.c: __uncached_access */
 int __uncached_access(struct file *file, unsigned long addr)
 {
diff --git a/arch/mips/lemote/lm2e/prom.c b/arch/mips/lemote/lm2e/prom.c
deleted file mode 100644
index d78cedf..0000000
--- a/arch/mips/lemote/lm2e/prom.c
+++ /dev/null
@@ -1,91 +0,0 @@
-/*
- * Based on Ocelot Linux port, which is
- * Copyright 2001 MontaVista Software Inc.
- * Author: jsun@mvista.com or jsun@junsun.net
- *
- * Copyright 2003 ICT CAS
- * Author: Michael Guo <guoyi@ict.ac.cn>
- *
- * Copyright (C) 2007 Lemote Inc. & Insititute of Computing Technology
- * Author: Fuxin Zhang, zhangfx@lemote.com
- *
- * This program is free software; you can redistribute  it and/or modify it
- * under  the terms of  the GNU General  Public License as published by the
- * Free Software Foundation;  either version 2 of the  License, or (at your
- * option) any later version.
- */
-#include <linux/init.h>
-#include <linux/bootmem.h>
-#include <asm/bootinfo.h>
-
-extern unsigned long bus_clock;
-extern unsigned long cpu_clock_freq;
-extern unsigned int memsize, highmemsize;
-
-static int argc;
-/* pmon passes arguments in 32bit pointers */
-static int *arg;
-static int *env;
-
-const char *get_system_type(void)
-{
-	return "lemote-fulong";
-}
-
-void __init prom_init_cmdline(void)
-{
-	int i;
-	long l;
-
-	/* arg[0] is "g", the rest is boot parameters */
-	arcs_cmdline[0] = '\0';
-	for (i = 1; i < argc; i++) {
-		l = (long)arg[i];
-		if (strlen(arcs_cmdline) + strlen(((char *)l) + 1)
-		    >= sizeof(arcs_cmdline))
-			break;
-		strcat(arcs_cmdline, ((char *)l));
-		strcat(arcs_cmdline, " ");
-	}
-}
-
-void __init prom_init(void)
-{
-	long l;
-	argc = fw_arg0;
-	arg = (int *)fw_arg1;
-	env = (int *)fw_arg2;
-
-	prom_init_cmdline();
-
-	if ((strstr(arcs_cmdline, "console=")) == NULL)
-		strcat(arcs_cmdline, " console=ttyS0,115200");
-	if ((strstr(arcs_cmdline, "root=")) == NULL)
-		strcat(arcs_cmdline, " root=/dev/hda1");
-
-#define parse_even_earlier(res, option, p)				\
-do {									\
-	if (strncmp(option, (char *)p, strlen(option)) == 0)		\
-		res = simple_strtol((char *)p + strlen(option"="),	\
-				    NULL, 10);				\
-} while (0)
-
-	l = (long)*env;
-	while (l != 0) {
-		parse_even_earlier(bus_clock, "busclock", l);
-		parse_even_earlier(cpu_clock_freq, "cpuclock", l);
-		parse_even_earlier(memsize, "memsize", l);
-		parse_even_earlier(highmemsize, "highmemsize", l);
-		env++;
-		l = (long)*env;
-	}
-	if (memsize == 0)
-		memsize = 256;
-
-	pr_info("busclock=%ld, cpuclock=%ld,memsize=%d,highmemsize=%d\n",
-	       bus_clock, cpu_clock_freq, memsize, highmemsize);
-}
-
-void __init prom_free_prom_memory(void)
-{
-}
diff --git a/arch/mips/lemote/lm2e/setup.c b/arch/mips/lemote/lm2e/setup.c
index ebd6cea..1c4968f 100644
--- a/arch/mips/lemote/lm2e/setup.c
+++ b/arch/mips/lemote/lm2e/setup.c
@@ -26,15 +26,10 @@
  *  675 Mass Ave, Cambridge, MA 02139, USA.
  *
  */
-#include <linux/bootmem.h>
 #include <linux/init.h>
-#include <linux/irq.h>
+#include <linux/module.h>
 
-#include <asm/bootinfo.h>
-#include <asm/mc146818-time.h>
-#include <asm/time.h>
 #include <asm/wbflush.h>
-#include <asm/mach-lemote/pci.h>
 
 #ifdef CONFIG_VT
 #include <linux/console.h>
@@ -43,22 +38,6 @@
 
 extern void mips_reboot_setup(void);
 
-unsigned long cpu_clock_freq;
-unsigned long bus_clock;
-unsigned int memsize;
-unsigned int highmemsize = 0;
-
-void __init plat_time_init(void)
-{
-	/* setup mips r4k timer */
-	mips_hpt_frequency = cpu_clock_freq / 2;
-}
-
-unsigned long read_persistent_clock(void)
-{
-	return mc146818_get_cmos_time();
-}
-
 void (*__wbflush)(void);
 EXPORT_SYMBOL(__wbflush);
 
@@ -75,19 +54,10 @@ static void wbflush_loongson2e(void)
 
 void __init plat_mem_setup(void)
 {
-	set_io_port_base((unsigned long)ioremap(LOONGSON2E_IO_PORT_BASE,
-				IO_SPACE_LIMIT - LOONGSON2E_PCI_IO_START + 1));
 	mips_reboot_setup();
 
 	__wbflush = wbflush_loongson2e;
 
-	add_memory_region(0x0, (memsize << 20), BOOT_MEM_RAM);
-#ifdef CONFIG_64BIT
-	if (highmemsize > 0) {
-		add_memory_region(0x20000000, highmemsize << 20, BOOT_MEM_RAM);
-	}
-#endif
-
 #ifdef CONFIG_VT
 #if defined(CONFIG_VGA_CONSOLE)
 	conswitchp = &vga_con;
@@ -107,5 +77,4 @@ void __init plat_mem_setup(void)
 	conswitchp = &dummy_con;
 #endif
 #endif
-
 }
diff --git a/arch/mips/lemote/lm2e/time.c b/arch/mips/lemote/lm2e/time.c
new file mode 100644
index 0000000..b9d3f11
--- /dev/null
+++ b/arch/mips/lemote/lm2e/time.c
@@ -0,0 +1,30 @@
+/*
+ * Copyright (C) 2007 Lemote, Inc. & Institute of Computing Technology
+ * Author: Fuxin Zhang, zhangfx@lemote.com
+ *
+ * Copyright (C) 2009 Lemote Inc. & Insititute of Computing Technology
+ * Author: Wu Zhangjin, wuzj@lemote.com
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ */
+
+#include <linux/init.h>
+
+#include <asm/mc146818-time.h>
+#include <asm/time.h>
+
+extern unsigned long cpu_clock_freq;
+
+void __init plat_time_init(void)
+{
+	/* setup mips r4k timer */
+	mips_hpt_frequency = cpu_clock_freq / 2;
+}
+
+unsigned long read_persistent_clock(void)
+{
+	return mc146818_get_cmos_time();
+}
-- 
1.6.2.1

