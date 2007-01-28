Return-Path: <linux-kernel-owner+w=401wt.eu-S932088AbXA1Ecj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932088AbXA1Ecj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 23:32:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932258AbXA1Ecj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 23:32:39 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:13324 "EHLO
	pd4mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932088AbXA1Eci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 23:32:38 -0500
X-Greylist: delayed 3640 seconds by postgrey-1.27 at vger.kernel.org; Sat, 27 Jan 2007 23:32:38 EST
Date: Sat, 27 Jan 2007 19:28:07 -0800 (PST)
From: Zwane Mwaikambo <zwane@infradead.org>
Subject: [PATCH] AGPGART compat ioctl
To: Dave Jones <davej@redhat.com>
Cc: Andrew Morton <akpm@osdl.org>, Linux Kernel <linux-kernel@vger.kernel.org>
Message-id: <Pine.LNX.4.64.0701271403420.1379@montezuma.fsmlabs.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,
	The following video card requires the agpgart driver ioctl 
interface in order to detect video memory.

00:02.0 VGA compatible controller: Intel Corporation Mobile 
945GM/GMS/940GML Express Integrated Graphics Controller (rev 03)

Tested on a Thinkpad Z61t, Xorg.0.log from a 32bit debian Xorg is at;

http://montezuma.homeunix.net/Xorg.0.log

Cheers,

Signed-off-by: Zwane Mwaikambo <zwane@infradead.org>

drivers/char/agp/frontend.c |  253 ++++++++++++++++++++++++++++++++++++++++++++
include/linux/agpgart.h     |   61 ++++++++++
2 files changed, 314 insertions(+)

Index: linux-2.6.20-rc4-mm1/include/linux/agpgart.h
===================================================================
RCS file: /home/cvsroot/linux-2.6.20-rc4-mm1/include/linux/agpgart.h,v
retrieving revision 1.1.1.1
diff -u -p -B -r1.1.1.1 agpgart.h
--- linux-2.6.20-rc4-mm1/include/linux/agpgart.h	27 Jan 2007 22:04:06 -0000	1.1.1.1
+++ linux-2.6.20-rc4-mm1/include/linux/agpgart.h	27 Jan 2007 22:41:23 -0000
@@ -114,6 +114,67 @@ typedef struct _agp_unbind {
 
 #define AGPGART_MINOR 175
 
+#ifdef CONFIG_COMPAT
+#include <linux/compat.h>
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
+#endif /* CONFIG_COMPAT */
+
 struct agp_info {
 	struct agp_version version;	/* version of the driver        */
 	u32 bridge_id;		/* bridge vendor/device         */
Index: linux-2.6.20-rc4-mm1/drivers/char/agp/frontend.c
===================================================================
RCS file: /home/cvsroot/linux-2.6.20-rc4-mm1/drivers/char/agp/frontend.c,v
retrieving revision 1.1.1.1
diff -u -p -B -r1.1.1.1 frontend.c
--- linux-2.6.20-rc4-mm1/drivers/char/agp/frontend.c	27 Jan 2007 22:03:38 -0000	1.1.1.1
+++ linux-2.6.20-rc4-mm1/drivers/char/agp/frontend.c	27 Jan 2007 22:41:44 -0000
@@ -1039,6 +1039,256 @@ ioctl_out:
 	return ret_val;
 }
 
+#ifdef CONFIG_COMPAT
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
+#endif /* CONFIG_COMPAT */
+
 static const struct file_operations agp_fops =
 {
 	.owner		= THIS_MODULE,
@@ -1046,6 +1296,9 @@ static const struct file_operations agp_
 	.read		= agp_read,
 	.write		= agp_write,
 	.ioctl		= agp_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl	= compat_agp_ioctl,
+#endif
 	.mmap		= agp_mmap,
 	.open		= agp_open,
 	.release	= agp_release,
