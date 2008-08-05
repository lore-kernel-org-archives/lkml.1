Return-Path: <linux-kernel-owner+w=401wt.eu-S1760148AbYHEXHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760148AbYHEXHk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 19:07:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755376AbYHEXGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 19:06:40 -0400
Received: from relay1.sgi.com ([192.48.171.29]:59716 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751525AbYHEXGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 19:06:38 -0400
Date: Tue, 5 Aug 2008 18:06:37 -0500
From: Russ Anderson <rja@sgi.com>
To: Greg KH <greg@kroah.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, mingo@elte.hu, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, Jack Steiner <steiner@sgi.com>,
       Russ Anderson <rja@sgi.com>
Subject: Re: x86 BIOS interface for partitioning and system serial number on SGI UV
Message-ID: <20080805230635.GA39566@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <20080731195753.GB25715@sgi.com> <48934926.2010200@zytor.com> <20080804221951.GA252105@sgi.com> <4897A5FE.9070703@zytor.com> <20080805035450.GA11810@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080805035450.GA11810@kroah.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2008 at 08:54:50PM -0700, Greg KH wrote:
> On Mon, Aug 04, 2008 at 05:59:42PM -0700, H. Peter Anvin wrote:
> > Russ Anderson wrote:
> >>> This really seems more that it should belong in sysfs -- 
> >>> /sys/class/firmware presumably.
> >> /proc/sgi_uv already exists, similar to /proc/sgi_sn on Itanium systems.
> >> Would it be /sys/class/firmware?  Reading Documentation/sysfs-rules.txt
> >> seems to indicate somewhere under /sys/devices, such as 
> >> /sys/devices/system/,
> >> but I may be wrong.
> >
> > /sys/class/firmware is usually where firmware-related things end up, but 
> > gregkh is the authority on sysfs organization.
> 
> /sys/class/firmware has a few users, but perhaps you are thinking of
> /sys/firmware instead?  That's probably the better place for something
> that is not using the firmware class itself.
> 
> thanks,
> 
> greg k-h

Here is an updated patch using /sys/firmware/sgi_uv/, to see 
if it resolves concerns in that area.  This patch does not
address the stubs issue.  Still working that.

Thanks,
Russ

---------------------------------------------------------------------

SGI UV support for partitioning and system serial number.

Signed-off-by: Russ Anderson <rja@sgi.com>

---
 arch/x86/kernel/Makefile         |    2 
 arch/x86/kernel/bios_uv.c        |   87 +++++++++++++++++++++++++-
 arch/x86/kernel/genx2apic_uv_x.c |    8 +-
 arch/x86/kernel/uv_sysfs.c       |   84 ++++++++++++++++++++++++++
 include/asm-x86/uv/bios.h        |  126 ++++++++++++++++++++++++++++++++++-----
 5 files changed, 283 insertions(+), 24 deletions(-)

Index: linux/arch/x86/kernel/uv_sysfs.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux/arch/x86/kernel/uv_sysfs.c	2008-08-05 17:07:16.000000000 -0500
@@ -0,0 +1,84 @@
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
+/* #include <linux/seq_file.h> */
+/* #include <asm/genapic.h> */
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
+static ssize_t system_serial_number_show(struct kobject *kobj,
+			struct kobj_attribute *attr, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%s\n", sn_system_serial_number());
+}
+
+static ssize_t licenseID_show(struct kobject *kobj,
+			struct kobj_attribute *attr, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "0x%llx\n",
+			sn_partition_serial_number_val());
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
+static struct kobj_attribute system_sn_attr =
+	__ATTR(system_serial_number, S_IRUGO, system_serial_number_show, NULL);
+
+static struct kobj_attribute license_id_attr =
+	__ATTR(licenseID, S_IRUGO, licenseID_show, NULL);
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
+	sysfs_create_file(sgi_uv_kobj, &system_sn_attr.attr);
+	sysfs_create_file(sgi_uv_kobj, &license_id_attr.attr);
+	sysfs_create_file(sgi_uv_kobj, &coherence_id_attr.attr);
+
+	return 0;
+}
+
+device_initcall(sgi_uv_sysfs_init);
Index: linux/arch/x86/kernel/Makefile
===================================================================
--- linux.orig/arch/x86/kernel/Makefile	2008-08-05 17:07:01.000000000 -0500
+++ linux/arch/x86/kernel/Makefile	2008-08-05 17:07:16.000000000 -0500
@@ -104,7 +104,7 @@ obj-$(CONFIG_OLPC)		+= olpc.o
 # 64 bit specific files
 ifeq ($(CONFIG_X86_64),y)
         obj-y				+= genapic_64.o genapic_flat_64.o genx2apic_uv_x.o tlb_uv.o
-	obj-y				+= bios_uv.o
+	obj-y				+= bios_uv.o uv_sysfs.o
         obj-y				+= genx2apic_cluster.o
         obj-y				+= genx2apic_phys.o
         obj-$(CONFIG_X86_PM_TIMER)	+= pmtimer_64.o
Index: linux/arch/x86/kernel/bios_uv.c
===================================================================
--- linux.orig/arch/x86/kernel/bios_uv.c	2008-08-05 17:07:01.000000000 -0500
+++ linux/arch/x86/kernel/bios_uv.c	2008-08-05 17:07:16.000000000 -0500
@@ -1,8 +1,6 @@
 /*
  * BIOS run time interface routines.
  *
- *  Copyright (c) 2008 Silicon Graphics, Inc.  All Rights Reserved.
- *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
  *  the Free Software Foundation; either version 2 of the License, or
@@ -16,12 +14,37 @@
  *  You should have received a copy of the GNU General Public License
  *  along with this program; if not, write to the Free Software
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ *
+ *  Copyright (c) 2008 Silicon Graphics, Inc.  All Rights Reserved.
+ *  Copyright (c) Russ Anderson
  */
 
 #include <asm/uv/bios.h>
 
+char sn_system_serial_number_string[128];
+EXPORT_SYMBOL(sn_system_serial_number_string);
+u64 sn_partition_serial_number;
+EXPORT_SYMBOL(sn_partition_serial_number);
+u8 sn_partition_id;
+EXPORT_SYMBOL(sn_partition_id);
+u8 uv_type;
+EXPORT_SYMBOL(uv_type);
+u16 uv_nasid_bitmask;
+EXPORT_SYMBOL(uv_nasid_bitmask);
+u8 uv_nasid_shift;
+EXPORT_SYMBOL(uv_nasid_shift);
+u8 uv_system_size;
+EXPORT_SYMBOL(uv_system_size);
+u8 uv_sharing_domain_size;
+EXPORT_SYMBOL(uv_sharing_domain_size);
+u8 uv_coherency_id;
+EXPORT_SYMBOL(uv_coherency_id);
+u8 uv_region_size;
+EXPORT_SYMBOL(uv_region_size);
+
+
 const char *
-x86_bios_strerror(long status)
+uv_bios_strerror(long status)
 {
 	const char *str;
 	switch (status) {
@@ -35,7 +58,7 @@ x86_bios_strerror(long status)
 }
 
 long
-x86_bios_freq_base(unsigned long which, unsigned long *ticks_per_second,
+uv_bios_freq_base(unsigned long which, unsigned long *ticks_per_second,
 		   unsigned long *drift_info)
 {
 	struct uv_bios_retval isrv;
@@ -45,4 +68,58 @@ x86_bios_freq_base(unsigned long which, 
 	*drift_info = isrv.v1;
 	return isrv.status;
 }
-EXPORT_SYMBOL_GPL(x86_bios_freq_base);
+EXPORT_SYMBOL_GPL(uv_bios_freq_base);
+
+/*
+ * Returns information about the UV HUB.
+ *  In:
+ *      arg0 - BIOS_GET_SN_INFO
+ *      arg1 - 0 (other values reserved for future use)
+ *  Out:
+ *      v0
+ *		[7:0]   - uv hub version (0=hub1, 1=hub2)
+ *		[15:8]  - Log2 max number of nodes in entire system
+ *		[23:16] - Log2 of nodes per sharing domain
+ *		[31:24] - partition ID
+ *		[39:32] - coherency_id
+ *		[47:40] - regionsize
+ *      v1
+ *		[15:0]  - nasid mask (ex., 0x7ff for 11 bit nasid)
+ *		[23:15] - bit position of low nasid bit
+ */
+u64
+uv_bios_get_sn_info(int fc, u8 *uvtype, u16 *nasid_bitmask, u8 *nasid_shift,
+		    u8 *systemsize, u8 *sharing_domain_size, u8 *partid,
+		    u8 *coher, u8 *reg)
+{
+	struct uv_bios_retval ret_stuff;
+
+	ret_stuff.status = 0;
+	ret_stuff.v0 = 0;
+	ret_stuff.v1 = 0;
+	ret_stuff.v2 = 0;
+	BIOS_CALL_NOLOCK(ret_stuff, BIOS_GET_SN_INFO, fc, 0, 0, 0, 0, 0, 0);
+
+	if (ret_stuff.status < 0)
+		return ret_stuff.status;
+
+	if (uvtype)
+		*uvtype = ret_stuff.v0 & 0xff;
+	if (systemsize)
+		*systemsize = (ret_stuff.v0 >> 8) & 0xff;
+	if (sharing_domain_size)
+		*sharing_domain_size = (ret_stuff.v0 >> 16) & 0xff;
+	if (partid)
+		*partid = (ret_stuff.v0 >> 24) & 0xff;
+	if (coher)
+		*coher = (ret_stuff.v0 >> 32) & 0xff;
+	if (reg)
+		*reg = (ret_stuff.v0 >> 40) & 0xff;
+	if (nasid_bitmask)
+		*nasid_bitmask = (ret_stuff.v1 & 0xffff);
+	if (nasid_shift)
+		*nasid_shift = (ret_stuff.v1 >> 16) & 0xff;
+	return 0;
+}
+
+
Index: linux/arch/x86/kernel/genx2apic_uv_x.c
===================================================================
--- linux.orig/arch/x86/kernel/genx2apic_uv_x.c	2008-08-05 17:07:01.000000000 -0500
+++ linux/arch/x86/kernel/genx2apic_uv_x.c	2008-08-05 17:07:16.000000000 -0500
@@ -344,7 +344,7 @@ static __init void uv_rtc_init(void)
 	long status, ticks_per_sec, drift;
 
 	status =
-	    x86_bios_freq_base(BIOS_FREQ_BASE_REALTIME_CLOCK, &ticks_per_sec,
+	    uv_bios_freq_base(BIOS_FREQ_BASE_REALTIME_CLOCK, &ticks_per_sec,
 					&drift);
 	if (status != 0 || ticks_per_sec < 100000) {
 		printk(KERN_WARNING
@@ -410,6 +410,10 @@ static __init void uv_system_init(void)
 	gnode_upper = (((unsigned long)node_id.s.node_id) &
 		       ~((1 << n_val) - 1)) << m_val;
 
+	uv_bios_get_sn_info(0, &uv_type, &uv_nasid_bitmask,
+			    &uv_nasid_shift, &uv_system_size,
+			    &uv_sharing_domain_size, &sn_partition_id,
+			    &uv_coherency_id, &uv_region_size);
 	uv_rtc_init();
 
 	for_each_present_cpu(cpu) {
@@ -431,7 +435,7 @@ static __init void uv_system_init(void)
 		uv_cpu_hub_info(cpu)->gpa_mask = (1 << (m_val + n_val)) - 1;
 		uv_cpu_hub_info(cpu)->gnode_upper = gnode_upper;
 		uv_cpu_hub_info(cpu)->global_mmr_base = mmr_base;
-		uv_cpu_hub_info(cpu)->coherency_domain_number = 0;/* ZZZ */
+		uv_cpu_hub_info(cpu)->coherency_domain_number = uv_coherency_id;
 		uv_node_to_blade[nid] = blade;
 		uv_cpu_to_blade[cpu] = blade;
 		max_pnode = max(pnode, max_pnode);
Index: linux/include/asm-x86/uv/bios.h
===================================================================
--- linux.orig/include/asm-x86/uv/bios.h	2008-08-05 17:07:01.000000000 -0500
+++ linux/include/asm-x86/uv/bios.h	2008-08-05 17:07:16.000000000 -0500
@@ -1,11 +1,9 @@
-#ifndef _ASM_X86_BIOS_H
-#define _ASM_X86_BIOS_H
+#ifndef _ASM_UV_BIOS_H
+#define _ASM_UV_BIOS_H
 
 /*
  * BIOS layer definitions.
  *
- *  Copyright (c) 2008 Silicon Graphics, Inc.  All Rights Reserved.
- *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
  *  the Free Software Foundation; either version 2 of the License, or
@@ -19,11 +17,17 @@
  *  You should have received a copy of the GNU General Public License
  *  along with this program; if not, write to the Free Software
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ *
+ *  Copyright (c) 2008 Silicon Graphics, Inc.  All Rights Reserved.
+ *  Copyright (c) Russ Anderson
  */
 
 #include <linux/rtc.h>
 
-#define BIOS_FREQ_BASE			0x01000001
+#define BIOS_FREQ_BASE			0x01
+#define BIOS_GET_SN_INFO		0x02
+#define BIOS_SYS_SERIAL_GET		0x03
+#define BIOS_PARTITION_SERIAL_GET	0x04
 
 enum {
 	BIOS_FREQ_BASE_PLATFORM = 0,
@@ -31,14 +35,6 @@ enum {
 	BIOS_FREQ_BASE_REALTIME_CLOCK = 2
 };
 
-# define BIOS_CALL(result, a0, a1, a2, a3, a4, a5, a6, a7)		\
-	do {								\
-		/* XXX - the real call goes here */			\
-		result.status = BIOS_STATUS_UNIMPLEMENTED;		\
-		isrv.v0 = 0;						\
-		isrv.v1 = 0;						\
-	} while (0)
-
 enum {
 	BIOS_STATUS_SUCCESS		=  0,
 	BIOS_STATUS_UNIMPLEMENTED	= -1,
@@ -60,9 +56,107 @@ struct uv_bios_retval {
 	u64 v2;
 };
 
+
+# define BIOS_CALL(result, a0, a1, a2, a3, a4, a5, a6, a7)		\
+	do {								\
+		/* XXX - the real call goes here */			\
+		result.status = BIOS_STATUS_UNIMPLEMENTED;		\
+		result.v0 = 0;						\
+		result.v1 = 0;						\
+	} while (0)
+
+# define BIOS_CALL_NOLOCK(result, a0, a1, a2, a3, a4, a5, a6, a7)	\
+	do {								\
+		unsigned long __bios_flags;				\
+		local_irq_save(__bios_flags);				\
+		/* XXX - the real call goes here */			\
+		local_irq_restore(__bios_flags);			\
+		result.status = BIOS_STATUS_UNIMPLEMENTED;		\
+		result.v0 = 0;						\
+		result.v1 = 0;						\
+	} while (0)
+
+# define BIOS_CALL_REENTRANT(result, a0, a1, a2, a3, a4, a5, a6, a7)	\
+	do {								\
+		preempt_disable();					\
+		/* XXX - the real call goes here */			\
+		preempt_enable();					\
+		result.status = BIOS_STATUS_UNIMPLEMENTED;		\
+		result.v0 = 0;						\
+		result.v1 = 0;						\
+	} while (0)
+
+/*
+ * Retrieve the system serial number as an ASCII string.
+ */
+static inline u64
+uv_bios_sys_serial_get(char *buf)
+{
+	struct uv_bios_retval ret_stuff;
+
+	BIOS_CALL(ret_stuff, BIOS_SYS_SERIAL_GET, buf, 0, 0, 0, 0, 0, 0);
+
+	return ret_stuff.status;
+}
+
+
+extern char sn_system_serial_number_string[];
+extern u64 sn_partition_serial_number;
+
+static inline char *
+sn_system_serial_number(void)
+{
+	if (unlikely(!sn_system_serial_number_string[0]))
+		uv_bios_sys_serial_get(sn_system_serial_number_string);
+
+	return sn_system_serial_number_string;
+}
+/*
+ * Returns a unique id number for this system and partition (suitable for
+ * use with license managers), based in part on the system serial number.
+ */
+static inline u64
+bios_partition_serial_get(void)
+{
+	struct uv_bios_retval ret_stuff;
+	BIOS_CALL_REENTRANT(ret_stuff, BIOS_PARTITION_SERIAL_GET, 0,
+				0, 0, 0, 0, 0, 0);
+	if (ret_stuff.status != 0)
+		return 0;
+	return ret_stuff.v0;
+}
+
+static inline u64
+sn_partition_serial_number_val(void)
+{
+	if (unlikely(sn_partition_serial_number == 0))
+		sn_partition_serial_number = bios_partition_serial_get();
+
+	return sn_partition_serial_number;
+}
+
+
+extern struct kobject *sgi_uv_kobj;	/* /sys/firmware/sgi_uv */
+
+extern u8 uv_type;
+extern u16 uv_nasid_bitmask;
+extern u8 uv_nasid_shift;
+extern u8 sn_partition_id;
+extern u8 uv_system_size;
+extern u8 uv_sharing_domain_size;
+extern u8 uv_coherency_id;
+extern u8 uv_region_size;
+extern u8 uv_coherency_id;
+#define partition_coherence_id()	(uv_coherency_id)
+
 extern long
-x86_bios_freq_base(unsigned long which, unsigned long *ticks_per_second,
+uv_bios_freq_base(unsigned long which, unsigned long *ticks_per_second,
 		   unsigned long *drift_info);
-extern const char *x86_bios_strerror(long status);
+extern u64
+uv_bios_get_sn_info(int fc, u8 *uvtype, u16 *nasid_bitmask, u8 *nasid_shift,
+		    u8 *systemsize, u8 *sharing_domain_size, u8 *partid,
+		    u8 *coher, u8 *reg);
+
+extern const char *uv_bios_strerror(long status);
 
-#endif /* _ASM_X86_BIOS_H */
+#endif /* _ASM_UV_BIOS_H */
-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
