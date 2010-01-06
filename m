Return-Path: <linux-kernel-owner+w=401wt.eu-S932164Ab0AFQ0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932164Ab0AFQ0P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 11:26:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932236Ab0AFQ0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 11:26:13 -0500
Received: from gir.skynet.ie ([193.1.99.77]:55695 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932165Ab0AFQ0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 11:26:12 -0500
From: Mel Gorman <mel@csn.ul.ie>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christoph Lameter <cl@linux-foundation.org>, Adam Litke <agl@us.ibm.com>,
       Avi Kivity <avi@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 1/7] Allow CONFIG_MIGRATION to be set without CONFIG_NUMA
Date: Wed,  6 Jan 2010 16:26:03 +0000
Message-Id: <1262795169-9095-2-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1262795169-9095-1-git-send-email-mel@csn.ul.ie>
References: <1262795169-9095-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_MIGRATION currently depends on CONFIG_NUMA. The current users of
page migration such as sys_move_pages(), sys_migrate_pages() and cpuset
process migration are ordinarily only beneficial on NUMA.

As memory compaction will operate within a zone and is useful on both NUMA
and non-NUMA systems, this patch allows CONFIG_MIGRATION to be set if the
user selects CONFIG_COMPACTION as an option.

TODO
  o After this patch is applied, the migration core is available but it
    also makes NUMA-specific features available. This is too much
    exposure so revisit this.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 mm/Kconfig |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index 17b8947..1d8e2b2 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -168,12 +168,22 @@ config SPLIT_PTLOCK_CPUS
 	default "4"
 
 #
+# support for memory compaction
+config COMPACTION
+	bool "Allow for memory compaction"
+	def_bool y
+	select MIGRATION
+	depends on EXPERIMENTAL && HUGETLBFS
+	help
+	  Allows the compaction of memory for the allocation of huge pages.
+
+#
 # support for page migration
 #
 config MIGRATION
 	bool "Page migration"
 	def_bool y
-	depends on NUMA || ARCH_ENABLE_MEMORY_HOTREMOVE
+	depends on NUMA || ARCH_ENABLE_MEMORY_HOTREMOVE || COMPACTION
 	help
 	  Allows the migration of the physical location of pages of processes
 	  while the virtual addresses are not changed. This is useful for
-- 
1.6.5

