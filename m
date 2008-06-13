Return-Path: <linux-kernel-owner+w=401wt.eu-S1755026AbYFMSCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026AbYFMSCd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 14:02:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754566AbYFMSCV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 14:02:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37464 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754525AbYFMSCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 14:02:19 -0400
Date: Fri, 13 Jun 2008 14:02:09 -0400
From: Rik van Riel <riel@redhat.com>
To: Benjamin Kidwell <benjkidwell@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       benjkidwell@yahoo.com, Nick Piggin <nickpiggin@yahoo.com.au>
Subject: [PATCH] fix UNEVICTABLE_LRU + !PROC_PAGE_MONITOR build
Message-ID: <20080613140209.044ecfef@cuia.bos.redhat.com>
In-Reply-To: <636055.3698.qm@web53712.mail.re2.yahoo.com>
References: <20080612180642.f92c3538.akpm@linux-foundation.org>
	<636055.3698.qm@web53712.mail.re2.yahoo.com>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both CONFIG_PROC_PAGE_MONITOR and CONFIG_UNEVICTABLE_LRU depend on
mm/pagewalk.c being built.  Create a CONFIG_PAGE_WALKER Kconfig
variable that is automatically selected if needed.

Debugged-by: Benjamin Kidwell <benjkidwell@yahoo.com>
Signed-off-by: Rik van Riel <riel@redhat.com>

---
 init/Kconfig |    1 +
 mm/Kconfig   |    5 +++++
 mm/Makefile  |    2 +-
 3 files changed, 7 insertions(+), 1 deletion(-)

Index: linux-2.6.26-rc5-mm2/init/Kconfig
===================================================================
--- linux-2.6.26-rc5-mm2.orig/init/Kconfig	2008-06-10 10:46:29.000000000 -0400
+++ linux-2.6.26-rc5-mm2/init/Kconfig	2008-06-13 13:57:11.000000000 -0400
@@ -803,6 +803,7 @@ source "arch/Kconfig"
 config PROC_PAGE_MONITOR
  	default y
 	depends on PROC_FS && MMU
+	select PAGE_WALKER
 	bool "Enable /proc page monitoring" if EMBEDDED
  	help
 	  Various /proc files exist to monitor process memory utilization:
Index: linux-2.6.26-rc5-mm2/mm/Kconfig
===================================================================
--- linux-2.6.26-rc5-mm2.orig/mm/Kconfig	2008-06-11 14:39:43.000000000 -0400
+++ linux-2.6.26-rc5-mm2/mm/Kconfig	2008-06-13 13:58:24.000000000 -0400
@@ -206,9 +206,14 @@ config VIRT_TO_BUS
 	def_bool y
 	depends on !ARCH_NO_VIRT_TO_BUS
 
+# automatically selected by UNEVICTABLE_LRU or PROC_PAGE_MONITOR
+config PAGE_WALKER
+	def_bool n
+
 config UNEVICTABLE_LRU
 	bool "Add LRU list to track non-evictable pages"
 	default y
+	select PAGE_WALKER
 	help
 	  Keeps unevictable pages off of the active and inactive pageout
 	  lists, so kswapd will not waste CPU time or have its balancing
Index: linux-2.6.26-rc5-mm2/mm/Makefile
===================================================================
--- linux-2.6.26-rc5-mm2.orig/mm/Makefile	2008-06-10 10:46:29.000000000 -0400
+++ linux-2.6.26-rc5-mm2/mm/Makefile	2008-06-13 13:58:42.000000000 -0400
@@ -13,7 +13,7 @@ obj-y			:= bootmem.o filemap.o mempool.o
 			   prio_tree.o util.o mmzone.o vmstat.o backing-dev.o \
 			   page_isolation.o $(mmu-y)
 
-obj-$(CONFIG_PROC_PAGE_MONITOR) += pagewalk.o
+obj-$(CONFIG_PAGE_WALKER) += pagewalk.o
 obj-$(CONFIG_BOUNCE)	+= bounce.o
 obj-$(CONFIG_SWAP)	+= page_io.o swap_state.o swapfile.o thrash.o
 obj-$(CONFIG_HAS_DMA)	+= dmapool.o

