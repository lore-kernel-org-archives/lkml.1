Return-Path: <linux-kernel-owner+w=401wt.eu-S1760001AbZFTBgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760001AbZFTBgf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 21:36:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759219AbZFTBgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 21:36:17 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:20830 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755679AbZFTBgQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 21:36:16 -0400
MIME-Version: 1.0
Message-ID: <b6ebd2d7-7bac-4aa0-8910-991304979fb9@default>
Date: Fri, 19 Jun 2009 18:35:31 -0700 (PDT)
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
Subject: [RFC PATCH 1/4] tmem: infrastructure for tmem layer
In-Reply-To: <cd40cd91-66e9-469d-b079-3a899a3ccadb@default>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1 (304090) [OL 9.0.0.6627]
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Source-IP: abhmt009.oracle.com [141.146.116.18]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010209.4A3C3CE7.0052:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- linux-2.6.30/mm/Kconfig	2009-06-09 21:05:27.000000000 -0600
+++ linux-2.6.30-tmem/mm/Kconfig	2009-06-19 09:36:41.000000000 -0600
@@ -253,3 +253,30 @@
 	  of 1 says that all excess pages should be trimmed.
 
 	  See Documentation/nommu-mmap.txt for more information.
+
+#
+# support for transcendent memory
+#
+config TMEM
+	bool "Transcendent memory support"
+	depends on XEN # but in future may work without XEN
+	help
+	  In a virtualized environment, allows unused and underutilized
+	  system physical memory to be made accessible through a narrow
+	  well-defined page-copy-based API.  If unsure, say Y.
+
+config PRECACHE
+	bool "Cache clean pages in transcendent memory"
+	depends on TMEM
+	help
+	  Allows the transcendent memory pool to be used to store clean
+	  page-cache pages which, under some circumstances, will greatly
+	  reduce paging and thus improve performance.  If unsure, say Y.
+
+config PRESWAP
+	bool "Swap pages to transcendent memory"
+	depends on TMEM
+	help
+	  Allows the transcendent memory pool to be used as a pseudo-swap
+	  device which, under some circumstances, will greatly reduce
+	  swapping and thus improve performance.  If unsure, say Y.
--- linux-2.6.30/mm/Makefile	2009-06-09 21:05:27.000000000 -0600
+++ linux-2.6.30-tmem/mm/Makefile	2009-06-19 09:33:59.000000000 -0600
@@ -16,6 +16,8 @@
 obj-$(CONFIG_PROC_PAGE_MONITOR) += pagewalk.o
 obj-$(CONFIG_BOUNCE)	+= bounce.o
 obj-$(CONFIG_SWAP)	+= page_io.o swap_state.o swapfile.o thrash.o
+obj-$(CONFIG_PRESWAP)	+= preswap.o
+obj-$(CONFIG_PRECACHE)	+= precache.o
 obj-$(CONFIG_HAS_DMA)	+= dmapool.o
 obj-$(CONFIG_HUGETLBFS)	+= hugetlb.o
 obj-$(CONFIG_NUMA) 	+= mempolicy.o
--- linux-2.6.30/include/linux/tmem.h	1969-12-31 17:00:00.000000000 -0700
+++ linux-2.6.30-tmem/include/linux/tmem.h	2009-06-19 11:21:58.000000000 -0600
@@ -0,0 +1,22 @@
+/*
+ * linux/tmem.h
+ *
+ * Interface to transcendent memory, used by mm/precache.c and mm/preswap.c
+ *
+ * Copyright (C) 2008,2009 Dan Magenheimer, Oracle Corp.
+ */
+
+struct tmem_ops {
+	int (*new_pool)(u64 uuid_lo, u64 uuid_hi, u32 flags);
+	int (*put_page)(u32 pool_id, u64 object, u32 index, unsigned long gmfn);
+	int (*get_page)(u32 pool_id, u64 object, u32 index, unsigned long gmfn);
+	int (*flush_page)(u32 pool_id, u64 object, u32 index);
+	int (*flush_object)(u32 pool_id, u64 object);
+	int (*destroy_pool)(u32 pool_id);
+};
+
+extern struct tmem_ops *tmem_ops;
+
+/* flags for tmem_ops.new_pool */
+#define TMEM_POOL_PERSIST          1
+#define TMEM_POOL_SHARED           2
