Return-Path: <linux-kernel-owner+w=401wt.eu-S1754716AbYIVVLI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716AbYIVVLI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 17:11:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753225AbYIVVKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 17:10:52 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:39694 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752870AbYIVVKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 17:10:51 -0400
Date: Mon, 22 Sep 2008 16:10:51 -0500
From: Russ Anderson <rja@sgi.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       Russ Anderson <rja@sgi.com>
Subject: [PATCH 4/4] x86: Add sysfs entries for UV
Message-ID: <20080922211051.GG222374@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 4/4] Add sysfs entries for UV

Create /sys/firmware/sgi_uv sysfs entries for partition_id and coherence_id.

Signed-off-by: Russ Anderson <rja@sgi.com>

---
 arch/x86/kernel/Makefile   |    2 -
 arch/x86/kernel/uv_sysfs.c |   61 +++++++++++++++++++++++++++++++++++++++++++++
 include/asm-x86/uv/bios.h  |    2 +
 3 files changed, 64 insertions(+), 1 deletion(-)

Index: linux/arch/x86/kernel/Makefile
===================================================================
--- linux.orig/arch/x86/kernel/Makefile	2008-09-22 16:01:00.000000000 -0500
+++ linux/arch/x86/kernel/Makefile	2008-09-22 16:01:21.000000000 -0500
@@ -107,7 +107,7 @@ obj-$(CONFIG_OLPC)		+= olpc.o
 # 64 bit specific files
 ifeq ($(CONFIG_X86_64),y)
         obj-y				+= genapic_64.o genapic_flat_64.o genx2apic_uv_x.o tlb_uv.o
-	obj-y				+= bios_uv.o
+	obj-y				+= bios_uv.o uv_sysfs.o
         obj-y				+= genx2apic_cluster.o
         obj-y				+= genx2apic_phys.o
         obj-$(CONFIG_X86_PM_TIMER)	+= pmtimer_64.o
Index: linux/arch/x86/kernel/uv_sysfs.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux/arch/x86/kernel/uv_sysfs.c	2008-09-22 16:01:21.000000000 -0500
@@ -0,0 +1,61 @@
+/*
+ * This file supports the /sys/firmware/sgi_uv interfaces for SGI UV.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ *
+ *  Copyright (c) 2008 Silicon Graphics, Inc.  All Rights Reserved.
+ *  Copyright (c) Russ Anderson
+ */
+
+#include <linux/sysdev.h>
+#include <asm/uv/bios.h>
+
+struct kobject *sgi_uv_kobj;
+
+static ssize_t partition_id_show(struct kobject *kobj,
+			struct kobj_attribute *attr, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%d\n", sn_partition_id);
+}
+
+static ssize_t coherence_id_show(struct kobject *kobj,
+			struct kobj_attribute *attr, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%d\n", partition_coherence_id());
+}
+
+static struct kobj_attribute partition_id_attr =
+	__ATTR(partition_id, S_IRUGO, partition_id_show, NULL);
+
+static struct kobj_attribute coherence_id_attr =
+	__ATTR(coherence_id, S_IRUGO, coherence_id_show, NULL);
+
+
+static int __init sgi_uv_sysfs_init(void)
+{
+	if (!sgi_uv_kobj)
+		sgi_uv_kobj = kobject_create_and_add("sgi_uv", firmware_kobj);
+	if (!sgi_uv_kobj) {
+		printk(KERN_WARNING "kobject_create_and_add sgi_uv failed \n");
+		return -EINVAL;
+	}
+
+	sysfs_create_file(sgi_uv_kobj, &partition_id_attr.attr);
+	sysfs_create_file(sgi_uv_kobj, &coherence_id_attr.attr);
+
+	return 0;
+}
+
+device_initcall(sgi_uv_sysfs_init);
Index: linux/include/asm-x86/uv/bios.h
===================================================================
--- linux.orig/include/asm-x86/uv/bios.h	2008-09-22 16:01:16.000000000 -0500
+++ linux/include/asm-x86/uv/bios.h	2008-09-22 16:01:21.000000000 -0500
@@ -79,6 +79,8 @@ extern u8 uv_coherency_id;
 #define partition_coherence_id()	(uv_coherency_id)
 
 
+extern struct kobject *sgi_uv_kobj;	/* /sys/firmware/sgi_uv */
+
 #ifndef CONFIG_EFI
 extern u64 efi_call6(void *, u64, u64, u64, u64, u64, u64);
 #endif
-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
