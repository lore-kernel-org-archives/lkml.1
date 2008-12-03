Return-Path: <linux-kernel-owner+w=401wt.eu-S1754611AbYLCVZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611AbYLCVZn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 16:25:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751975AbYLCVZf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 16:25:35 -0500
Received: from mtagate7.de.ibm.com ([195.212.29.156]:61859 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320AbYLCVZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 16:25:34 -0500
Subject: [PATCH] memory hotplug: run lru_add_drain_all() on each cpu
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Reply-To: gerald.schaefer@de.ibm.com
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com, kamezawa.hiroyu@jp.fujitsu.com,
       y-goto@jp.fujitsu.com, npiggin@suse.de
Content-Type: text/plain
Date: Wed, 03 Dec 2008 22:25:24 +0100
Message-Id: <1228339524.6598.11.camel@t60p>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gerald Schaefer <gerald.schaefer@de.ibm.com>

offline_pages() calls lru_add_drain_all() followed by drain_all_pages().
While drain_all_pages() works on each cpu, lru_add_drain_all() only runs
on the current cpu for architectures w/o CONFIG_NUMA. This let us run
into the BUG_ON(!PageBuddy(page)) in __offline_isolated_pages() during
memory hotplug stress test on s390. The page in question was still on the
pcp list, because of a race with lru_add_drain_all() and drain_all_pages()
on different cpus.

This is fixed with this patch by adding CONFIG_MEMORY_HOTREMOVE to the
lru_add_drain_all() #ifdef, to let it run on each cpu.

Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>

---
 mm/swap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6/mm/swap.c
===================================================================
--- linux-2.6.orig/mm/swap.c
+++ linux-2.6/mm/swap.c
@@ -299,7 +299,8 @@ void lru_add_drain(void)
 	put_cpu();
 }
 
-#if defined(CONFIG_NUMA) || defined(CONFIG_UNEVICTABLE_LRU)
+#if defined(CONFIG_NUMA) || defined(CONFIG_UNEVICTABLE_LRU) || \
+    defined(CONFIG_MEMORY_HOTREMOVE)
 static void lru_add_drain_per_cpu(struct work_struct *dummy)
 {
 	lru_add_drain();

