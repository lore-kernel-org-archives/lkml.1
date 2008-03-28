Return-Path: <linux-kernel-owner+w=401wt.eu-S1756627AbYC1BK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627AbYC1BK2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 21:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755312AbYC1BJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 21:09:32 -0400
Received: from zrnetservice.com ([209.133.52.163]:58082 "EHLO
	www.zrnetservice.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754569AbYC1BJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 21:09:31 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 2 of 4] hotplug-memory: adding non-section-aligned memory is
	bad
X-Mercurial-Node: e0b16cc8349b38a5f3f99517d03f3964114260cd
Message-Id: <e0b16cc8349b38a5f3f9.1206664118@localhost>
In-Reply-To: <patchbomb.1206664116@localhost>
Date: Thu, 27 Mar 2008 17:28:38 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Christoph Lameter <clameter@sgi.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding non-section-aligned memory will cause bad results, because page
structures are only built on section-aligned boundaries.  Also, memory
whose size isn't a multiple of the section size is silently ignored.

This patch adds a couple of WARN_ONs to help confused programmers work
out what's going wrong when they hotplug memory without being aware of
these constraints.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -784,6 +784,9 @@
 #define PAGES_PER_SECTION       (1UL << PFN_SECTION_SHIFT)
 #define PAGE_SECTION_MASK	(~(PAGES_PER_SECTION-1))
 
+#define SECTION_SIZE		(1UL << SECTION_SIZE_BITS)
+#define SECTION_SIZE_MASK	(SECTION_SIZE - 1)
+
 #define SECTION_BLOCKFLAGS_BITS \
 	((1UL << (PFN_SECTION_SHIFT - pageblock_order)) * NR_PAGEBLOCK_BITS)
 
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -300,6 +300,11 @@
 	int ret;
 	u64 start = res->start;
 	u64 size = res->end - res->start + 1;
+
+	/* Adding non-section-aligned memory will give unexpected
+	   and unintuitive results. */
+	WARN_ON((start & SECTION_SIZE_MASK) != 0);
+	WARN_ON((size & SECTION_SIZE_MASK) != 0);
 
 	if (!node_online(nid)) {
 		pgdat = hotadd_new_pgdat(nid, start);


