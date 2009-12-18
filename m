Return-Path: <linux-kernel-owner+w=401wt.eu-S1754346AbZLRAkL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346AbZLRAkL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 19:40:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752043AbZLRAj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 19:39:57 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:53533 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259AbZLRAjv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 19:39:51 -0500
MIME-Version: 1.0
Message-ID: <5076ccb7-89d1-4837-bd48-7fff3b765bd0@default>
Date: Thu, 17 Dec 2009 16:38:40 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: dan.magenheimer@oracle.com, npiggin@suse.de, akpm@osdl.org,
       jeremy@goop.org, xen-devel@lists.xensource.com,
       tmem-devel@oss.oracle.com, kurt.hackel@oracle.com,
       Russell <rusty@rustcorp.com.au>, Rik van Riel <riel@redhat.com>,
       dave.mccracken@oracle.com, linux-mm@kvack.org,
       Rusty@rcsinet15.oracle.com, sunil.mushran@oracle.com,
       Avi Kivity <avi@redhat.com>, Schwidefsky <schwidefsky@de.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Marcelo Tosatti <mtosatti@redhat.com>, alan@lxorguk.ukuu.org.uk,
       chris.mason@oracle.com, Pavel Machek <pavel@ucw.cz>
Subject: Tmem [PATCH 5/5] (Take 3): Build Xen interface under tmem layer
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.4  (308245) [OL
 9.0.0.6627]
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4B2ACF1C.0099:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tmem [PATCH 5/5] (Take 3): Build Xen interface under tmem layer.

Interface kernel tmem API to a Xen hypercall implementation of tmem
that conforms to the published Transcendent Memory API.

Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>


 arch/x86/include/asm/xen/hypercall.h     |    8 +
 drivers/xen/Makefile                     |    1 
 drivers/xen/tmem.c                       |   97 +++++++++++++++++++++
 include/xen/interface/tmem.h             |   43 +++++++++
 include/xen/interface/xen.h              |   22 ++++
 5 files changed, 171 insertions(+)

--- linux-2.6.32/arch/x86/include/asm/xen/hypercall.h	2009-12-02 20:51:21.000000000 -0700
+++ linux-2.6.32-tmem/arch/x86/include/asm/xen/hypercall.h	2009-12-10 11:10:17.000000000 -0700
@@ -45,6 +45,7 @@
 #include <xen/interface/xen.h>
 #include <xen/interface/sched.h>
 #include <xen/interface/physdev.h>
+#include <xen/interface/tmem.h>
 
 /*
  * The hypercall asms have to meet several constraints:
@@ -417,6 +418,13 @@ HYPERVISOR_nmi_op(unsigned long op, unsi
 	return _hypercall2(int, nmi_op, op, arg);
 }
 
+static inline int
+HYPERVISOR_tmem_op(
+	struct tmem_op *op)
+{
+	return _hypercall1(int, tmem_op, op);
+}
+
 static inline void
 MULTI_fpu_taskswitch(struct multicall_entry *mcl, int set)
 {
--- linux-2.6.32/drivers/xen/Makefile	2009-12-02 20:51:21.000000000 -0700
+++ linux-2.6.32-tmem/drivers/xen/Makefile	2009-12-10 11:10:17.000000000 -0700
@@ -6,6 +6,7 @@ CFLAGS_features.o			:= $(nostackp)
 
 obj-$(CONFIG_HOTPLUG_CPU)	+= cpu_hotplug.o
 obj-$(CONFIG_XEN_XENCOMM)	+= xencomm.o
+obj-$(CONFIG_TMEM)		+= tmem.o
 obj-$(CONFIG_XEN_BALLOON)	+= balloon.o
 obj-$(CONFIG_XEN_DEV_EVTCHN)	+= evtchn.o
 obj-$(CONFIG_XENFS)		+= xenfs/
--- linux-2.6.32/include/xen/interface/tmem.h	1969-12-31 17:00:00.000000000 -0700
+++ linux-2.6.32-tmem/include/xen/interface/tmem.h	2009-12-10 11:10:17.000000000 -0700
@@ -0,0 +1,43 @@
+/*
+ * include/xen/interface/tmem.h
+ *
+ * Interface to Xen implementation of transcendent memory
+ *
+ * Copyright (C) 2009 Dan Magenheimer, Oracle Corp.
+ */
+
+#include <xen/interface/xen.h>
+
+#define TMEM_CONTROL               0
+#define TMEM_NEW_POOL              1
+#define TMEM_DESTROY_POOL          2
+#define TMEM_NEW_PAGE              3
+#define TMEM_PUT_PAGE              4
+#define TMEM_GET_PAGE              5
+#define TMEM_FLUSH_PAGE            6
+#define TMEM_FLUSH_OBJECT          7
+#define TMEM_READ                  8
+#define TMEM_WRITE                 9
+#define TMEM_XCHG                 10
+
+/* Subops for HYPERVISOR_tmem_op(TMEM_CONTROL) */
+#define TMEMC_THAW                 0
+#define TMEMC_FREEZE               1
+#define TMEMC_FLUSH                2
+#define TMEMC_DESTROY              3
+#define TMEMC_LIST                 4
+#define TMEMC_SET_WEIGHT           5
+#define TMEMC_SET_CAP              6
+#define TMEMC_SET_COMPRESS         7
+
+/* Bits for HYPERVISOR_tmem_op(TMEM_NEW_POOL) */
+#define TMEM_POOL_PERSIST          1
+#define TMEM_POOL_SHARED           2
+#define TMEM_POOL_PAGESIZE_SHIFT   4
+#define TMEM_POOL_PAGESIZE_MASK  0xf
+#define TMEM_POOL_VERSION_SHIFT   24
+#define TMEM_POOL_VERSION_MASK  0xff
+
+/* Special errno values */
+#define EFROZEN                 1000
+#define EEMPTY                  1001
--- linux-2.6.32/include/xen/interface/xen.h	2009-12-02 20:51:21.000000000 -0700
+++ linux-2.6.32-tmem/include/xen/interface/xen.h	2009-12-10 11:10:17.000000000 -0700
@@ -58,6 +58,7 @@
 #define __HYPERVISOR_event_channel_op     32
 #define __HYPERVISOR_physdev_op           33
 #define __HYPERVISOR_hvm_op               34
+#define __HYPERVISOR_tmem_op              38
 
 /* Architecture-specific hypercall definitions. */
 #define __HYPERVISOR_arch_0               48
@@ -461,6 +462,27 @@ typedef uint8_t xen_domain_handle_t[16];
 #define __mk_unsigned_long(x) x ## UL
 #define mk_unsigned_long(x) __mk_unsigned_long(x)
 
+struct tmem_op {
+	uint32_t cmd;
+	int32_t pool_id;
+	union {
+		struct {  /* for cmd == TMEM_NEW_POOL */
+			uint64_t uuid[2];
+			uint32_t flags;
+		} new;
+		struct {
+			uint64_t object;
+			uint32_t index;
+			uint32_t tmem_offset;
+			uint32_t pfn_offset;
+			uint32_t len;
+			GUEST_HANDLE(void) gmfn; /* guest machine page frame */
+		} gen;
+	} u;
+};
+typedef struct tmem_op tmem_op_t;
+DEFINE_GUEST_HANDLE_STRUCT(tmem_op_t);
+
 #else /* __ASSEMBLY__ */
 
 /* In assembly code we cannot use C numeric constant suffixes. */
--- linux-2.6.32/drivers/xen/tmem.c	1969-12-31 17:00:00.000000000 -0700
+++ linux-2.6.32-tmem/drivers/xen/tmem.c	2009-12-10 11:10:17.000000000 -0700
@@ -0,0 +1,97 @@
+/*
+ * Xen implementation for transcendent memory (tmem)
+ *
+ * Dan Magenheimer <dan.magenheimer@oracle.com> 2009
+ */
+
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/tmem.h>
+#include <xen/interface/xen.h>
+#include <xen/interface/tmem.h>
+#include <asm/xen/hypercall.h>
+#include <asm/xen/page.h>
+
+static inline int xen_tmem_op(u32 tmem_cmd, u32 tmem_pool, u64 object,
+	u32 index, unsigned long gmfn, u32 tmem_offset, u32 pfn_offset, u32 len)
+{
+	struct tmem_op op;
+	int rc = 0;
+
+	op.cmd = tmem_cmd;
+	op.pool_id = tmem_pool;
+	op.u.gen.object = object;
+	op.u.gen.index = index;
+	op.u.gen.tmem_offset = tmem_offset;
+	op.u.gen.pfn_offset = pfn_offset;
+	op.u.gen.len = len;
+	set_xen_guest_handle(op.u.gen.gmfn, (void *)gmfn);
+	rc = HYPERVISOR_tmem_op(&op);
+	return rc;
+}
+
+static int xen_tmem_new_pool(struct tmem_pool_uuid uuid, u32 flags)
+{
+	struct tmem_op op;
+	int rc = 0;
+
+	flags |= (PAGE_SHIFT - 12) << TMEM_POOL_PAGESIZE_SHIFT;
+	op.cmd = TMEM_NEW_POOL;
+	op.u.new.uuid[0] = uuid.uuid_lo;
+	op.u.new.uuid[1] = uuid.uuid_hi;
+	op.u.new.flags = flags;
+	rc = HYPERVISOR_tmem_op(&op);
+	return rc;
+}
+
+static int xen_tmem_put_page(u32 pool_id, u64 object, u32 index,
+	unsigned long pfn)
+{
+	unsigned long gmfn = pfn_to_mfn(pfn);
+
+	return xen_tmem_op(TMEM_PUT_PAGE, pool_id, object, index,
+		gmfn, 0, 0, 0);
+}
+
+static int xen_tmem_get_page(u32 pool_id, u64 object, u32 index,
+	unsigned long pfn)
+{
+	unsigned long gmfn = pfn_to_mfn(pfn);
+
+	return xen_tmem_op(TMEM_GET_PAGE, pool_id, object, index,
+		gmfn, 0, 0, 0);
+}
+
+static int xen_tmem_flush_page(u32 pool_id, u64 object, u32 index)
+{
+	return xen_tmem_op(TMEM_FLUSH_PAGE, pool_id, object, index,
+		0, 0, 0, 0);
+}
+
+static int xen_tmem_flush_object(u32 pool_id, u64 object)
+{
+	return xen_tmem_op(TMEM_FLUSH_OBJECT, pool_id, object, 0, 0, 0, 0, 0);
+}
+
+static int xen_tmem_destroy_pool(u32 pool_id)
+{
+	return xen_tmem_op(TMEM_DESTROY_POOL, pool_id, 0, 0, 0, 0, 0, 0);
+}
+
+static struct tmem_ops xen_tmem_ops = {
+	.new_pool = xen_tmem_new_pool,
+	.put_page = xen_tmem_put_page,
+	.get_page = xen_tmem_get_page,
+	.flush_page = xen_tmem_flush_page,
+	.flush_object = xen_tmem_flush_object,
+	.destroy_pool = xen_tmem_destroy_pool
+};
+
+static int __init xen_tmem_init(void)
+{
+	tmem_set_ops(&xen_tmem_ops);
+	return 0;
+}
+core_initcall(xen_tmem_init);
