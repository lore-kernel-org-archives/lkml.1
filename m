Return-Path: <linux-kernel-owner+w=401wt.eu-S965250AbXA3FXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965250AbXA3FXp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 00:23:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965398AbXA3FXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 00:23:45 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:8036 "EHLO
	pd5mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965250AbXA3FXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 00:23:44 -0500
Date: Mon, 29 Jan 2007 21:20:31 -0800 (PST)
From: Zwane Mwaikambo <zwane@infradead.org>
Subject: Re: [PATCH] AGPGART compat ioctl
In-reply-to: <20070128083644.GA8677@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Message-id: <Pine.LNX.4.64.0701280041250.5046@montezuma.fsmlabs.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <Pine.LNX.4.64.0701271403420.1379@montezuma.fsmlabs.com>
 <20070128083644.GA8677@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,
	Thanks for the input. The following has your recommendations;

drivers/char/agp/Makefile       |    1
drivers/char/agp/agp.h          |    2
drivers/char/agp/compat_ioctl.c |  282 ++++++++++++++++++++++++++++++++++++++++
drivers/char/agp/compat_ioctl.h |  105 ++++++++++++++
drivers/char/agp/frontend.c     |   31 ++--
5 files changed, 407 insertions(+), 14 deletions(-)

Index: linux-2.6.20-rc4-mm1/drivers/char/agp/Makefile
===================================================================
RCS file: /home/cvsroot/linux-2.6.20-rc4-mm1/drivers/char/agp/Makefile,v
retrieving revision 1.1.1.1
diff -u -p -B -r1.1.1.1 Makefile
--- linux-2.6.20-rc4-mm1/drivers/char/agp/Makefile	27 Jan 2007 22:03:38 -0000	1.1.1.1
+++ linux-2.6.20-rc4-mm1/drivers/char/agp/Makefile	30 Jan 2007 04:42:21 -0000
@@ -1,6 +1,7 @@
 agpgart-y := backend.o frontend.o generic.o isoch.o
 
 obj-$(CONFIG_AGP)		+= agpgart.o
+obj-$(CONFIG_COMPAT)		+= compat_ioctl.o
 obj-$(CONFIG_AGP_ALI)		+= ali-agp.o
 obj-$(CONFIG_AGP_ATI)		+= ati-agp.o
 obj-$(CONFIG_AGP_AMD)		+= amd-k7-agp.o
Index: linux-2.6.20-rc4-mm1/drivers/char/agp/agp.h
===================================================================
RCS file: /home/cvsroot/linux-2.6.20-rc4-mm1/drivers/char/agp/agp.h,v
retrieving revision 1.1.1.1
diff -u -p -B -r1.1.1.1 agp.h
--- linux-2.6.20-rc4-mm1/drivers/char/agp/agp.h	27 Jan 2007 22:03:38 -0000	1.1.1.1
+++ linux-2.6.20-rc4-mm1/drivers/char/agp/agp.h	30 Jan 2007 04:05:33 -0000
@@ -298,6 +298,8 @@ extern struct aper_size_info_16 agp3_gen
 extern int agp_off;
 extern int agp_try_unsupported_boot;
 
+long compat_agp_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
+
 /* Chipset independant registers (from AGP Spec) */
 #define AGP_APBASE	0x10
 
Index: linux-2.6.20-rc4-mm1/drivers/char/agp/compat_ioctl.c
===================================================================
RCS file: linux-2.6.20-rc4-mm1/drivers/char/agp/compat_ioctl.c
diff -N linux-2.6.20-rc4-mm1/drivers/char/agp/compat_ioctl.c
--- /dev/null	1 Jan 1970 00:00:00 -0000
+++ linux-2.6.20-rc4-mm1/drivers/char/agp/compat_ioctl.c	30 Jan 2007 05:15:44 -0000
@@ -0,0 +1,282 @@
+/*
+ * AGPGART driver frontend compatibility ioctls
+ * Copyright (C) 2004 Silicon Graphics, Inc.
+ * Copyright (C) 2002-2003 Dave Jones
+ * Copyright (C) 1999 Jeff Hartmann
+ * Copyright (C) 1999 Precision Insight, Inc.
+ * Copyright (C) 1999 Xi Graphics, Inc.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included
+ * in all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
+ * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * JEFF HARTMANN, OR ANY OTHER CONTRIBUTORS BE LIABLE FOR ANY CLAIM,
+ * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
+ * OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
+ * OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/pci.h>
+#include <linux/agpgart.h>
+#include <asm/uaccess.h>
+#include "agp.h"
+#include "compat_ioctl.h"
+
+static int compat_agpioc_info_wrap(struct agp_file_private *priv, void __user *arg)
+{
+	struct agp_info32 userinfo;
+	struct agp_kern_info kerninfo;
+
+	agp_copy_info(agp_bridge, &kerninfo);
+
+	userinfo.version.major = kerninfo.version.major;
+	userinfo.version.minor = kerninfo.version.minor;
+	userinfo.bridge_id = kerninfo.device->vendor |
+	    (kerninfo.device->device << 16);
+	userinfo.agp_mode = kerninfo.mode;
+	userinfo.aper_base = (compat_long_t)kerninfo.aper_base;
+	userinfo.aper_size = kerninfo.aper_size;
+	userinfo.pg_total = userinfo.pg_system = kerninfo.max_memory;
+	userinfo.pg_used = kerninfo.current_memory;
+
+	if (copy_to_user(arg, &userinfo, sizeof(userinfo)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int compat_agpioc_reserve_wrap(struct agp_file_private *priv, void __user *arg)
+{
+	struct agp_region32 ureserve;
+	struct agp_region kreserve;
+	struct agp_client *client;
+	struct agp_file_private *client_priv;
+
+	DBG("");
+	if (copy_from_user(&ureserve, arg, sizeof(ureserve)))
+		return -EFAULT;
+
+	if ((unsigned) ureserve.seg_count >= ~0U/sizeof(struct agp_segment32))
+		return -EFAULT;
+
+	kreserve.pid = ureserve.pid;
+	kreserve.seg_count = ureserve.seg_count;
+
+	client = agp_find_client_by_pid(kreserve.pid);
+
+	if (kreserve.seg_count == 0) {
+		/* remove a client */
+		client_priv = agp_find_private(kreserve.pid);
+
+		if (client_priv != NULL) {
+			set_bit(AGP_FF_IS_CLIENT, &client_priv->access_flags);
+			set_bit(AGP_FF_IS_VALID, &client_priv->access_flags);
+		}
+		if (client == NULL) {
+			/* client is already removed */
+			return 0;
+		}
+		return agp_remove_client(kreserve.pid);
+	} else {
+		struct agp_segment32 *usegment;
+		struct agp_segment *ksegment;
+		int seg;
+
+		if (ureserve.seg_count >= 16384)
+			return -EINVAL;
+
+		usegment = kmalloc(sizeof(*usegment) * ureserve.seg_count, GFP_KERNEL);
+		if (!usegment)
+			return -ENOMEM;
+
+		ksegment = kmalloc(sizeof(*ksegment) * kreserve.seg_count, GFP_KERNEL);
+		if (!ksegment) {
+			kfree(usegment);
+			return -ENOMEM;
+		}
+
+		if (copy_from_user(usegment, (void __user *) ureserve.seg_list,
+				   sizeof(*usegment) * ureserve.seg_count)) {
+			kfree(usegment);
+			kfree(ksegment);
+			return -EFAULT;
+		}
+
+		for (seg = 0; seg < ureserve.seg_count; seg++) {
+			ksegment[seg].pg_start = usegment[seg].pg_start;
+			ksegment[seg].pg_count = usegment[seg].pg_count;
+			ksegment[seg].prot = usegment[seg].prot;
+		}
+
+		kfree(usegment);
+		kreserve.seg_list = ksegment;
+
+		if (client == NULL) {
+			/* Create the client and add the segment */
+			client = agp_create_client(kreserve.pid);
+
+			if (client == NULL) {
+				kfree(ksegment);
+				return -ENOMEM;
+			}
+			client_priv = agp_find_private(kreserve.pid);
+
+			if (client_priv != NULL) {
+				set_bit(AGP_FF_IS_CLIENT, &client_priv->access_flags);
+				set_bit(AGP_FF_IS_VALID, &client_priv->access_flags);
+			}
+		}
+		return agp_create_segment(client, &kreserve);
+	}
+	/* Will never really happen */
+	return -EINVAL;
+}
+
+static int compat_agpioc_allocate_wrap(struct agp_file_private *priv, void __user *arg)
+{
+	struct agp_memory *memory;
+	struct agp_allocate32 alloc;
+
+	DBG("");
+	if (copy_from_user(&alloc, arg, sizeof(alloc)))
+		return -EFAULT;
+
+	memory = agp_allocate_memory_wrap(alloc.pg_count, alloc.type);
+
+	if (memory == NULL)
+		return -ENOMEM;
+
+	alloc.key = memory->key;
+	alloc.physical = memory->physical;
+
+	if (copy_to_user(arg, &alloc, sizeof(alloc))) {
+		agp_free_memory_wrap(memory);
+		return -EFAULT;
+	}
+	return 0;
+}
+
+static int compat_agpioc_bind_wrap(struct agp_file_private *priv, void __user *arg)
+{
+	struct agp_bind32 bind_info;
+	struct agp_memory *memory;
+
+	DBG("");
+	if (copy_from_user(&bind_info, arg, sizeof(bind_info)))
+		return -EFAULT;
+
+	memory = agp_find_mem_by_key(bind_info.key);
+
+	if (memory == NULL)
+		return -EINVAL;
+
+	return agp_bind_memory(memory, bind_info.pg_start);
+}
+
+static int compat_agpioc_unbind_wrap(struct agp_file_private *priv, void __user *arg)
+{
+	struct agp_memory *memory;
+	struct agp_unbind32 unbind;
+
+	DBG("");
+	if (copy_from_user(&unbind, arg, sizeof(unbind)))
+		return -EFAULT;
+
+	memory = agp_find_mem_by_key(unbind.key);
+
+	if (memory == NULL)
+		return -EINVAL;
+
+	return agp_unbind_memory(memory);
+}
+
+long compat_agp_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	struct agp_file_private *curr_priv = file->private_data;
+	int ret_val = -ENOTTY;
+
+	mutex_lock(&(agp_fe.agp_mutex));
+
+	if ((agp_fe.current_controller == NULL) &&
+	    (cmd != AGPIOC_ACQUIRE32)) {
+		ret_val = -EINVAL;
+		goto ioctl_out;
+	}
+	if ((agp_fe.backend_acquired != TRUE) &&
+	    (cmd != AGPIOC_ACQUIRE32)) {
+		ret_val = -EBUSY;
+		goto ioctl_out;
+	}
+	if (cmd != AGPIOC_ACQUIRE32) {
+		if (!(test_bit(AGP_FF_IS_CONTROLLER, &curr_priv->access_flags))) {
+			ret_val = -EPERM;
+			goto ioctl_out;
+		}
+		/* Use the original pid of the controller,
+		 * in case it's threaded */
+
+		if (agp_fe.current_controller->pid != curr_priv->my_pid) {
+			ret_val = -EBUSY;
+			goto ioctl_out;
+		}
+	}
+
+	switch (cmd) {
+	case AGPIOC_INFO32:
+		ret_val = compat_agpioc_info_wrap(curr_priv, (void __user *) arg);
+		break;
+
+	case AGPIOC_ACQUIRE32:
+		ret_val = agpioc_acquire_wrap(curr_priv);
+		break;
+
+	case AGPIOC_RELEASE32:
+		ret_val = agpioc_release_wrap(curr_priv);
+		break;
+
+	case AGPIOC_SETUP32:
+		ret_val = agpioc_setup_wrap(curr_priv, (void __user *) arg);
+		break;
+
+	case AGPIOC_RESERVE32:
+		ret_val = compat_agpioc_reserve_wrap(curr_priv, (void __user *) arg);
+		break;
+
+	case AGPIOC_PROTECT32:
+		ret_val = agpioc_protect_wrap(curr_priv);
+		break;
+
+	case AGPIOC_ALLOCATE32:
+		ret_val = compat_agpioc_allocate_wrap(curr_priv, (void __user *) arg);
+		break;
+
+	case AGPIOC_DEALLOCATE32:
+		ret_val = agpioc_deallocate_wrap(curr_priv, (int) arg);
+		break;
+
+	case AGPIOC_BIND32:
+		ret_val = compat_agpioc_bind_wrap(curr_priv, (void __user *) arg);
+		break;
+
+	case AGPIOC_UNBIND32:
+		ret_val = compat_agpioc_unbind_wrap(curr_priv, (void __user *) arg);
+		break;
+	}
+
+ioctl_out:
+	DBG("ioctl returns %d\n", ret_val);
+	mutex_unlock(&(agp_fe.agp_mutex));
+	return ret_val;
+}
+
Index: linux-2.6.20-rc4-mm1/drivers/char/agp/compat_ioctl.h
===================================================================
RCS file: linux-2.6.20-rc4-mm1/drivers/char/agp/compat_ioctl.h
diff -N linux-2.6.20-rc4-mm1/drivers/char/agp/compat_ioctl.h
--- /dev/null	1 Jan 1970 00:00:00 -0000
+++ linux-2.6.20-rc4-mm1/drivers/char/agp/compat_ioctl.h	30 Jan 2007 04:34:51 -0000
@@ -0,0 +1,105 @@
+/*
+ * Copyright (C) 1999 Jeff Hartmann
+ * Copyright (C) 1999 Precision Insight, Inc.
+ * Copyright (C) 1999 Xi Graphics, Inc.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included
+ * in all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
+ * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * JEFF HARTMANN, OR ANY OTHER CONTRIBUTORS BE LIABLE FOR ANY CLAIM, 
+ * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
+ * OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE 
+ * OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
+ *
+ */
+
+#ifndef _AGP_COMPAT_IOCTL_H
+#define _AGP_COMPAT_IOCTL_H
+
+#include <linux/compat.h>
+#include <linux/agpgart.h>
+
+#define AGPIOC_INFO32       _IOR (AGPIOC_BASE, 0, compat_uptr_t)
+#define AGPIOC_ACQUIRE32    _IO  (AGPIOC_BASE, 1)
+#define AGPIOC_RELEASE32    _IO  (AGPIOC_BASE, 2)
+#define AGPIOC_SETUP32      _IOW (AGPIOC_BASE, 3, compat_uptr_t)
+#define AGPIOC_RESERVE32    _IOW (AGPIOC_BASE, 4, compat_uptr_t)
+#define AGPIOC_PROTECT32    _IOW (AGPIOC_BASE, 5, compat_uptr_t)
+#define AGPIOC_ALLOCATE32   _IOWR(AGPIOC_BASE, 6, compat_uptr_t)
+#define AGPIOC_DEALLOCATE32 _IOW (AGPIOC_BASE, 7, compat_int_t)
+#define AGPIOC_BIND32       _IOW (AGPIOC_BASE, 8, compat_uptr_t)
+#define AGPIOC_UNBIND32     _IOW (AGPIOC_BASE, 9, compat_uptr_t)
+
+struct agp_info32 {
+	struct agp_version version;	/* version of the driver        */
+	u32 bridge_id;		/* bridge vendor/device         */
+	u32 agp_mode;		/* mode info of bridge          */
+	compat_long_t aper_base;	/* base of aperture             */
+	compat_size_t aper_size;	/* size of aperture             */
+	compat_size_t pg_total;	/* max pages (swap + system)    */
+	compat_size_t pg_system;	/* max pages (system)           */
+	compat_size_t pg_used;		/* current pages used           */
+};
+
+/*
+ * The "prot" down below needs still a "sleep" flag somehow ...
+ */
+struct agp_segment32 {
+	compat_off_t pg_start;		/* starting page to populate    */
+	compat_size_t pg_count;	/* number of pages              */
+	compat_int_t prot;		/* prot flags for mmap          */
+};
+
+struct agp_region32 {
+	compat_pid_t pid;		/* pid of process               */
+	compat_size_t seg_count;	/* number of segments           */
+	struct agp_segment32 *seg_list;
+};
+
+struct agp_allocate32 {
+	compat_int_t key;		/* tag of allocation            */
+	compat_size_t pg_count;	/* number of pages              */
+	u32 type;		/* 0 == normal, other devspec   */
+	u32 physical;           /* device specific (some devices  
+				 * need a phys address of the     
+				 * actual page behind the gatt    
+				 * table)                        */
+};
+
+struct agp_bind32 {
+	compat_int_t key;		/* tag of allocation            */
+	compat_off_t pg_start;		/* starting page to populate    */
+};
+
+struct agp_unbind32 {
+	compat_int_t key;		/* tag of allocation            */
+	u32 priority;		/* priority for paging out      */
+};
+
+extern struct agp_front_data agp_fe;
+
+int agpioc_acquire_wrap(struct agp_file_private *priv);
+int agpioc_release_wrap(struct agp_file_private *priv);
+int agpioc_protect_wrap(struct agp_file_private *priv);
+int agpioc_setup_wrap(struct agp_file_private *priv, void __user *arg);
+int agpioc_deallocate_wrap(struct agp_file_private *priv, int arg);
+struct agp_file_private *agp_find_private(pid_t pid);
+struct agp_client *agp_create_client(pid_t id);
+int agp_remove_client(pid_t id);
+int agp_create_segment(struct agp_client *client, struct agp_region *region);
+void agp_free_memory_wrap(struct agp_memory *memory);
+struct agp_memory *agp_allocate_memory_wrap(size_t pg_count, u32 type);
+struct agp_memory *agp_find_mem_by_key(int key);
+struct agp_client *agp_find_client_by_pid(pid_t id);
+
+#endif /* _AGP_COMPAT_H */
Index: linux-2.6.20-rc4-mm1/drivers/char/agp/frontend.c
===================================================================
RCS file: /home/cvsroot/linux-2.6.20-rc4-mm1/drivers/char/agp/frontend.c,v
retrieving revision 1.1.1.1
diff -u -p -B -r1.1.1.1 frontend.c
--- linux-2.6.20-rc4-mm1/drivers/char/agp/frontend.c	27 Jan 2007 22:03:38 -0000	1.1.1.1
+++ linux-2.6.20-rc4-mm1/drivers/char/agp/frontend.c	30 Jan 2007 04:44:23 -0000
@@ -41,9 +41,9 @@
 #include <asm/pgtable.h>
 #include "agp.h"
 
-static struct agp_front_data agp_fe;
+struct agp_front_data agp_fe;
 
-static struct agp_memory *agp_find_mem_by_key(int key)
+struct agp_memory *agp_find_mem_by_key(int key)
 {
 	struct agp_memory *curr;
 
@@ -159,7 +159,7 @@ static pgprot_t agp_convert_mmap_flags(i
 	return vm_get_page_prot(prot_bits);
 }
 
-static int agp_create_segment(struct agp_client *client, struct agp_region *region)
+int agp_create_segment(struct agp_client *client, struct agp_region *region)
 {
 	struct agp_segment_priv **ret_seg;
 	struct agp_segment_priv *seg;
@@ -211,7 +211,7 @@ static void agp_insert_into_pool(struct 
 
 /* File private list routines */
 
-static struct agp_file_private *agp_find_private(pid_t pid)
+struct agp_file_private *agp_find_private(pid_t pid)
 {
 	struct agp_file_private *curr;
 
@@ -266,13 +266,13 @@ static void agp_remove_file_private(stru
  * Wrappers for agp_free_memory & agp_allocate_memory
  * These make sure that internal lists are kept updated.
  */
-static void agp_free_memory_wrap(struct agp_memory *memory)
+void agp_free_memory_wrap(struct agp_memory *memory)
 {
 	agp_remove_from_pool(memory);
 	agp_free_memory(memory);
 }
 
-static struct agp_memory *agp_allocate_memory_wrap(size_t pg_count, u32 type)
+struct agp_memory *agp_allocate_memory_wrap(size_t pg_count, u32 type)
 {
 	struct agp_memory *memory;
 
@@ -484,7 +484,7 @@ static struct agp_controller *agp_find_c
 	return NULL;
 }
 
-static struct agp_client *agp_find_client_by_pid(pid_t id)
+struct agp_client *agp_find_client_by_pid(pid_t id)
 {
 	struct agp_client *temp;
 
@@ -509,7 +509,7 @@ static void agp_insert_client(struct agp
 	agp_fe.current_controller->num_clients++;
 }
 
-static struct agp_client *agp_create_client(pid_t id)
+struct agp_client *agp_create_client(pid_t id)
 {
 	struct agp_client *new_client;
 
@@ -522,7 +522,7 @@ static struct agp_client *agp_create_cli
 	return new_client;
 }
 
-static int agp_remove_client(pid_t id)
+int agp_remove_client(pid_t id)
 {
 	struct agp_client *client;
 	struct agp_client *prev_client;
@@ -746,7 +746,7 @@ static int agpioc_info_wrap(struct agp_f
 	return 0;
 }
 
-static int agpioc_acquire_wrap(struct agp_file_private *priv)
+int agpioc_acquire_wrap(struct agp_file_private *priv)
 {
 	struct agp_controller *controller;
 
@@ -789,14 +789,14 @@ static int agpioc_acquire_wrap(struct ag
 	return 0;
 }
 
-static int agpioc_release_wrap(struct agp_file_private *priv)
+int agpioc_release_wrap(struct agp_file_private *priv)
 {
 	DBG("");
 	agp_controller_release_current(agp_fe.current_controller, priv);
 	return 0;
 }
 
-static int agpioc_setup_wrap(struct agp_file_private *priv, void __user *arg)
+int agpioc_setup_wrap(struct agp_file_private *priv, void __user *arg)
 {
 	struct agp_setup mode;
 
@@ -876,7 +876,7 @@ static int agpioc_reserve_wrap(struct ag
 	return -EINVAL;
 }
 
-static int agpioc_protect_wrap(struct agp_file_private *priv)
+int agpioc_protect_wrap(struct agp_file_private *priv)
 {
 	DBG("");
 	/* This function is not currently implemented */
@@ -910,7 +910,7 @@ static int agpioc_allocate_wrap(struct a
 	return 0;
 }
 
-static int agpioc_deallocate_wrap(struct agp_file_private *priv, int arg)
+int agpioc_deallocate_wrap(struct agp_file_private *priv, int arg)
 {
 	struct agp_memory *memory;
 
@@ -1046,6 +1046,9 @@ static const struct file_operations agp_
 	.read		= agp_read,
 	.write		= agp_write,
 	.ioctl		= agp_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl	= compat_agp_ioctl,
+#endif
 	.mmap		= agp_mmap,
 	.open		= agp_open,
 	.release	= agp_release,
