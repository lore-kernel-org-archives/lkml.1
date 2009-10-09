Return-Path: <linux-kernel-owner+w=401wt.eu-S1752911AbZJILUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911AbZJILUR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 07:20:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752081AbZJILUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 07:20:16 -0400
Received: from mtagate6.de.ibm.com ([195.212.17.166]:58932 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbZJILUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 07:20:14 -0400
From: Ehrhardt Christian <ehrhardt@linux.vnet.ibm.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Subject: [PATCH] mm: make VM_MAX_READAHEAD configurable
Date: Fri,  9 Oct 2009 13:19:35 +0200
Message-Id: <1255087175-21200-1-git-send-email-ehrhardt@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>

On one hand the define VM_MAX_READAHEAD in include/linux/mm.h is just a default
and can be configured per block device queue.
On the other hand a lot of admins do not use it, therefore it is reasonable to
set a wise default.

This path allows to configure the value via Kconfig mechanisms and therefore
allow the assignment of different defaults dependent on other Kconfig symbols.

Using this, the patch increases the default max readahead for s390 improving
sequential throughput in a lot of scenarios with almost no drawbacks (only
theoretical workloads with a lot concurrent sequential read patterns on a very
low memory system suffer due to page cache trashing as expected).

Signed-off-by: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
---

[diffstat]
 include/linux/mm.h |    2 +-
 mm/Kconfig         |   19 +++++++++++++++++++
 2 files changed, 20 insertions(+), 1 deletion(-)

[diff]
Index: linux-2.6/include/linux/mm.h
===================================================================
--- linux-2.6.orig/include/linux/mm.h
+++ linux-2.6/include/linux/mm.h
@@ -1169,7 +1169,7 @@ int write_one_page(struct page *page, in
 void task_dirty_inc(struct task_struct *tsk);
 
 /* readahead.c */
-#define VM_MAX_READAHEAD	128	/* kbytes */
+#define VM_MAX_READAHEAD	CONFIG_VM_MAX_READAHEAD	/* kbytes */
 #define VM_MIN_READAHEAD	16	/* kbytes (includes current page) */
 
 int force_page_cache_readahead(struct address_space *mapping, struct file *filp,
Index: linux-2.6/mm/Kconfig
===================================================================
--- linux-2.6.orig/mm/Kconfig
+++ linux-2.6/mm/Kconfig
@@ -288,3 +288,22 @@ config NOMMU_INITIAL_TRIM_EXCESS
 	  of 1 says that all excess pages should be trimmed.
 
 	  See Documentation/nommu-mmap.txt for more information.
+
+config VM_MAX_READAHEAD
+	int "Default max vm readahead size (16-4096 kbytes)"
+	default "512" if S390
+	default "128"
+	range 16 4096
+	help
+	  This entry specifies the default max size used to read ahead
+	  sequential access patterns in kilobytes.
+
+	  The value can be configured per device queue in /dev, this setting
+	  just defines the default.
+
+	  The default is 128 which it used to be for years and should suit all
+	  kind of linux targets.
+
+	  Smaller values might be useful for very memory constrained systems
+	  like some embedded systems to avoid page cache trashing, while larger
+	  values can be beneficial to server installations.
