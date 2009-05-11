Return-Path: <linux-kernel-owner+w=401wt.eu-S1755810AbZEKI2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810AbZEKI2i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 04:28:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755494AbZEKI1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 04:27:37 -0400
Received: from mta-1.ms.rz.RWTH-Aachen.DE ([134.130.7.72]:62827 "EHLO
	mta-1.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755448AbZEKI1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 04:27:36 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
X-IronPort-AV: E=Sophos;i="4.40,327,1238968800";   d="scan'208";a="11399189"
From: Stefan Lankes <lankes@lfbs.rwth-aachen.de>
To: linux-kernel@vger.kernel.org
Subject: [RFC PATCH 4/4]: affinity-on-next-touch
Date: Mon, 11 May 2009 10:27:37 +0200
Organization: Chair for Operating Systems, RWTH Aachen University
Message-id: <001001c9d212$57d1eeb0$0775cc10$@rwth-aachen.de>
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AcnSEleCHNxZ7/U9SYGrgRVkr4eIkQ==
Content-language: de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Patch 4/4]: This part of the patch adds some counters to detect migration
errors and publishes these counters via /proc/vmstat. Besides this, the
Kconfig file is extend with the parameter CONFIG_AFFINITY_ON_NEXT_TOUCH.


include/linux/vmstat.h |    6 ++++++
mm/Kconfig             |    9 +++++++++
mm/vmstat.c            |    6 ++++++
3 files changed, 21 insertions(+), 0 deletions(-)


diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
index 524cd1b..64c8e66 100644
--- a/include/linux/vmstat.h
+++ b/include/linux/vmstat.h
@@ -51,6 +51,12 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
                UNEVICTABLE_PGSTRANDED, /* unable to isolate on unlock */
                UNEVICTABLE_MLOCKFREED,
 #endif
+#ifdef CONFIG_AFFINITY_ON_NEXT_TOUCH
+               AONT_INVALID_NODEMASK,
+               AONT_ISOLATE_BUSY,
+               AONT_ISOLATE_FAILED,
+               AONT_MIGRATION_FAILED,
+#endif
                NR_VM_EVENT_ITEMS
 };
 
diff --git a/mm/Kconfig b/mm/Kconfig
index c2b57d8..025c328 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -181,6 +181,15 @@ config MIGRATION
          example on NUMA systems to put pages nearer to the processors
accessing
          the page.
 
+config AFFINITY_ON_NEXT_TOUCH
+       bool "Affinity on next touch (EXPERIMENTAL)" if (EXPERIMENTAL)
+       def_bool y
+       depends on MIGRATION
+       help
+         Allows the migration of pages to the node, which has the next
access 
+         to the pages. This realized a page placement strategy, which is
called 
+         "affinity-on-next-touch".
+
 config PHYS_ADDR_T_64BIT
        def_bool 64BIT || ARCH_PHYS_ADDR_T_64BIT
 
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 66f6130..d0e9489 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -708,6 +708,12 @@ static const char * const vmstat_text[] = {
        "unevictable_pgs_stranded",
        "unevictable_pgs_mlockfreed",
 #endif
+#ifdef CONFIG_AFFINITY_ON_NEXT_TOUCH
+       "aont_invalid_nodemask",
+       "aont_isolate_busy",
+       "aont_isolate_failed",
+       "aont_migration_failed",
+#endif
 #endif
 };

