Return-Path: <linux-kernel-owner+w=401wt.eu-S1755904AbYFYKDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904AbYFYKDY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 06:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754532AbYFYKDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 06:03:16 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42473 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754490AbYFYKDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 06:03:15 -0400
Date: Wed, 25 Jun 2008 19:01:40 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Rik van Riel <riel@redhat.com>,
       Benjamin Kidwell <benjkidwell@yahoo.com>
Subject: [-mm][PATCH 1/10] fix UNEVICTABLE_LRU and !PROC_PAGE_MONITOR build 
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20080625185717.D84C.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080625185717.D84C.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-Id: <20080625185950.D84F.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


=
From: Rik van Riel <riel@redhat.com>

Both CONFIG_PROC_PAGE_MONITOR and CONFIG_UNEVICTABLE_LRU depend on
mm/pagewalk.c being built.  Create a CONFIG_PAGE_WALKER Kconfig
variable that is automatically selected if needed.

Debugged-by: Benjamin Kidwell <benjkidwell@yahoo.com>
Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: KOSAKI Motohiro <kosaki@jp.fujitsu.com>

---
 init/Kconfig |    1 +
 mm/Kconfig   |    5 +++++
 mm/Makefile  |    2 +-
 3 files changed, 7 insertions(+), 1 deletion(-)

Index: b/init/Kconfig
===================================================================
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -803,6 +803,7 @@ source "arch/Kconfig"
 config PROC_PAGE_MONITOR
  	default y
 	depends on PROC_FS && MMU
+	select PAGE_WALKER
 	bool "Enable /proc page monitoring" if EMBEDDED
  	help
 	  Various /proc files exist to monitor process memory utilization:
Index: b/mm/Kconfig
===================================================================
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -209,9 +209,14 @@ config VIRT_TO_BUS
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
Index: b/mm/Makefile
===================================================================
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -13,7 +13,7 @@ obj-y			:= bootmem.o filemap.o mempool.o
 			   prio_tree.o util.o mmzone.o vmstat.o backing-dev.o \
 			   page_isolation.o $(mmu-y)
 
-obj-$(CONFIG_PROC_PAGE_MONITOR) += pagewalk.o
+obj-$(CONFIG_PAGE_WALKER) += pagewalk.o
 obj-$(CONFIG_BOUNCE)	+= bounce.o
 obj-$(CONFIG_SWAP)	+= page_io.o swap_state.o swapfile.o thrash.o
 obj-$(CONFIG_HAS_DMA)	+= dmapool.o


