Return-Path: <linux-kernel-owner+w=401wt.eu-S1760742AbZFTBh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760742AbZFTBh3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 21:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755738AbZFTBhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 21:37:17 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:48471 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248AbZFTBhP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 21:37:15 -0400
MIME-Version: 1.0
Message-ID: <40041226-a4c8-466f-bf07-a8a68319e754@default>
Date: Fri, 19 Jun 2009 18:36:28 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: dan.magenheimer@oracle.com, linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, npiggin@suse.de, chris.mason@oracle.com,
       kurt.hackel@oracle.com, dave.mccracken@oracle.com,
       Avi Kivity <avi@redhat.com>, jeremy@goop.org,
       Rik van Riel <riel@redhat.com>, alan@lxorguk.ukuu.org.uk,
       Rusty Russell <rusty@rustcorp.com.au>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, akpm@osdl.org,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, tmem-devel@oss.oracle.com,
       sunil.mushran@oracle.com, linux-mm@kvack.org
Subject: [RFC PATCH 4/4] tmem: interface code for tmem on top of xen
In-Reply-To: <cd40cd91-66e9-469d-b079-3a899a3ccadb@default>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1 (304090) [OL 9.0.0.6627]
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Source-IP: abhmt009.oracle.com [141.146.116.18]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010206.4A3C3D1F.0235:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- linux-2.6.30/arch/x86/include/asm/xen/hypercall.h	2009-06-09 21:05:27.000000000 -0600
+++ linux-2.6.30-tmem/arch/x86/include/asm/xen/hypercall.h	2009-06-19 13:49:04.000000000 -0600
@@ -45,6 +45,7 @@
 #include <xen/interface/xen.h>
 #include <xen/interface/sched.h>
 #include <xen/interface/physdev.h>
+#include <xen/interface/tmem.h>
 
 /*
  * The hypercall asms have to meet several constraints:
@@ -417,6 +418,13 @@
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
--- linux-2.6.30/drivers/xen/Makefile	2009-06-09 21:05:27.000000000 -0600
+++ linux-2.6.30-tmem/drivers/xen/Makefile	2009-06-19 09:33:59.000000000 -0600
@@ -3,5 +3,6 @@
 
 obj-$(CONFIG_HOTPLUG_CPU)	+= cpu_hotplug.o
 obj-$(CONFIG_XEN_XENCOMM)	+= xencomm.o
+obj-$(CONFIG_TMEM)		+= tmem.o
 obj-$(CONFIG_XEN_BALLOON)	+= balloon.o
 obj-$(CONFIG_XENFS)		+= xenfs/
\ No newline at end of file
--- linux-2.6.30/include/xen/interface/tmem.h	1969-12-31 17:00:00.000000000 -0700
+++ linux-2.6.30-tmem/include/xen/interface/tmem.h	2009-06-19 11:21:24.000000000 -0600
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
--- linux-2.6.30/include/xen/interface/xen.h	2009-06-09 21:05:27.000000000 -0600
+++ linux-2.6.30-tmem/include/xen/interface/xen.h	2009-06-19 14:39:15.000000000 -0600
@@ -58,6 +58,7 @@
 #define __HYPERVISOR_event_channel_op     32
 #define __HYPERVISOR_physdev_op           33
 #define __HYPERVISOR_hvm_op               34
+#define __HYPERVISOR_tmem_op              38
 
 /* Architecture-specific hypercall definitions. */
 #define __HYPERVISOR_arch_0               48
@@ -461,6 +462,27 @@
 #define __mk_unsigned_long(x) x ## UL
 #define mk_unsigned_long(x) __mk_unsigned_long(x)
 
+struct tmem_op {
+	uint32_t cmd;
+	int32_t pool_id; /* private > 0; shared < 0; 0 is invalid */
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
--- linux-2.6.30/drivers/xen/tmem.c	1969-12-31 17:00:00.000000000 -0700
+++ linux-2.6.30-tmem/drivers/xen/tmem.c	2009-06-19 14:54:53.000000000 -0600
@@ -0,0 +1,106 @@
+/*
+ * Xen implementation for transcendent memory (tmem)
+ *
+ * Dan Magenheimer <dan.magenheimer@oracle.com> 2009
+ */
+
+#include <linux/types.h>
+#include <linux/tmem.h>
+#include <xen/interface/xen.h>
+#include <xen/interface/tmem.h>
+#include <asm/xen/hypercall.h>
+#include <asm/xen/page.h>
+
+struct tmem_ops *tmem_ops = NULL;
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
+static inline int xen_tmem_new_pool(uint32_t tmem_cmd, uint64_t uuid_lo,
+	uint64_t uuid_hi, uint32_t flags)
+{
+	struct tmem_op op;
+	int rc = 0;
+
+	op.cmd = tmem_cmd;
+	op.u.new.uuid[0] = uuid_lo;
+	op.u.new.uuid[1] = uuid_hi;
+	op.u.new.flags = flags;
+	rc = HYPERVISOR_tmem_op(&op);
+	return rc;
+}
+
+static int tmem_put_page(u32 pool_id, u64 object, u32 index,
+	unsigned long pfn)
+{
+	unsigned long gmfn = pfn_to_mfn(pfn);
+
+	return xen_tmem_op(TMEM_PUT_PAGE, pool_id, object, index,
+		gmfn, 0, 0, 0);
+}
+
+static int tmem_get_page(u32 pool_id, u64 object, u32 index,
+	unsigned long pfn)
+{
+	unsigned long gmfn = pfn_to_mfn(pfn);
+
+	return xen_tmem_op(TMEM_GET_PAGE, pool_id, object, index,
+		gmfn, 0, 0, 0);
+}
+
+static int tmem_flush_page(u32 pool_id, u64 object, u32 index)
+{
+	return xen_tmem_op(TMEM_FLUSH_PAGE, pool_id, object, index,
+		0, 0, 0, 0);
+}
+
+static int tmem_flush_object(u32 pool_id, u64 object)
+{
+	return xen_tmem_op(TMEM_FLUSH_OBJECT, pool_id, object, 0, 0, 0, 0, 0);
+}
+
+static int tmem_new_pool(u64 uuid_lo, u64 uuid_hi, u32 flags)
+{
+	flags |= (PAGE_SHIFT - 12) << TMEM_POOL_PAGESIZE_SHIFT;
+	return xen_tmem_new_pool(TMEM_NEW_POOL, uuid_lo, uuid_hi, flags);
+}
+
+static int tmem_destroy_pool(u32 pool_id)
+{
+	return xen_tmem_op(TMEM_DESTROY_POOL, pool_id, 0, 0, 0, 0, 0, 0);
+}
+
+static int __init xen_tmem_init(void)
+{
+	if (tmem_ops != NULL)
+		printk(KERN_WARNING, "attempt to define multiple tmem_ops\n");
+	else
+		tmem_ops = kmalloc(sizeof(struct tmem_ops), GFP_KERNEL);
+
+	if (tmem_ops == NULL)
+		return -ENODEV;
+
+	tmem_ops->new_pool = tmem_new_pool;
+	tmem_ops->put_page = tmem_put_page;
+	tmem_ops->get_page = tmem_get_page;
+	tmem_ops->flush_page = tmem_flush_page;
+	tmem_ops->flush_object = tmem_flush_object;
+	tmem_ops->destroy_pool = tmem_destroy_pool;
+
+	return 0;
+}
