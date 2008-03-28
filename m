Return-Path: <linux-kernel-owner+w=401wt.eu-S1754861AbYC1BKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861AbYC1BKA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 21:10:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754389AbYC1BJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 21:09:31 -0400
Received: from zrnetservice.com ([209.133.52.163]:58081 "EHLO
	www.zrnetservice.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754830AbYC1BJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 21:09:30 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 1 of 4] hotplug-memory: add add_memory_resource
X-Mercurial-Node: 56436b88c2e0702e1250faf352c35e4e10599d64
Message-Id: <56436b88c2e0702e1250.1206664117@localhost>
In-Reply-To: <patchbomb.1206664116@localhost>
Date: Thu, 27 Mar 2008 17:28:37 -0700
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

The Xen balloon driver uses hotplug memory to extend the amount of
pseudo-physical memory available to a virtual domain.  Since this memory
is virtual, it can go anywhere within the kernel's pseudo-physical
address space.

This patch adds a new hotplug memory call, add_memory_resource(), which
adds memory corresponding to a pre-constructed resource.  This allows
callers to use allocate_resource() to allocate a suitable chunk of
address space for the new memory (as well as cosmetic details, like a
descriptive name).

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
---
 include/linux/memory_hotplug.h |    3 +++
 mm/memory_hotplug.c            |   20 ++++++++++++++++----
 2 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -171,7 +171,10 @@
 
 #endif /* ! CONFIG_MEMORY_HOTPLUG */
 
+struct resource;
+
 extern int add_memory(int nid, u64 start, u64 size);
+extern int add_memory_resource(int nid, struct resource *res);
 extern int arch_add_memory(int nid, u64 start, u64 size);
 extern int remove_memory(u64 start, u64 size);
 extern int sparse_add_one_section(struct zone *zone, unsigned long start_pfn,
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -278,14 +278,28 @@
 
 int add_memory(int nid, u64 start, u64 size)
 {
-	pg_data_t *pgdat = NULL;
-	int new_pgdat = 0;
 	struct resource *res;
 	int ret;
 
 	res = register_memory_resource(start, size);
 	if (!res)
 		return -EEXIST;
+
+	ret = add_memory_resource(nid, res);
+
+	if (ret)
+		release_memory_resource(res);
+
+	return ret;
+}
+
+int add_memory_resource(int nid, struct resource *res)
+{
+	pg_data_t *pgdat = NULL;
+	int new_pgdat = 0;
+	int ret;
+	u64 start = res->start;
+	u64 size = res->end - res->start + 1;
 
 	if (!node_online(nid)) {
 		pgdat = hotadd_new_pgdat(nid, start);
@@ -320,8 +334,6 @@
 	/* rollback pgdat allocation and others */
 	if (new_pgdat)
 		rollback_node_hotadd(nid, pgdat);
-	if (res)
-		release_memory_resource(res);
 
 	return ret;
 }


