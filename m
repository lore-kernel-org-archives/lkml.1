Return-Path: <linux-kernel-owner+w=401wt.eu-S1755183AbXHVE7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183AbXHVE7o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 00:59:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751910AbXHVE7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 00:59:37 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:53540 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbXHVE7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 00:59:36 -0400
Date: Wed, 22 Aug 2007 14:00:58 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: clameter@sgi.com
Cc: lkml <linux-kernel@vger.kernel.org>, shaohua.li@intel.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC][PATCH][BUGFIX] fix rcu_read_lock in page migraton
Message-Id: <20070822140058.29677634.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1187751053.17976.2.camel@sli10-conroe.sh.intel.com>
References: <1187748489.8474.21.camel@sli10-conroe.sh.intel.com>
	<20070822115258.7d59aaa1.kamezawa.hiroyu@jp.fujitsu.com>
	<1187751053.17976.2.camel@sli10-conroe.sh.intel.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch against the problme Shaohua rported.
Just an idea for fix the problem.
How do you think ? dummy vma is better ? (I don't like dummy vma.)

-Kame
==
In migration fallback path, write_page() or lock_page() will be called.
This causes sleep with holding rcu_read_lock().
For avoding that, just do rcu_lock if the page is Anon.(this is enough.)

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


---
 mm/migrate.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

Index: linux-2.6.23-rc2-mm2/mm/migrate.c
===================================================================
--- linux-2.6.23-rc2-mm2.orig/mm/migrate.c
+++ linux-2.6.23-rc2-mm2/mm/migrate.c
@@ -611,6 +611,7 @@ static int unmap_and_move(new_page_t get
 	int rc = 0;
 	int *result = NULL;
 	struct page *newpage = get_new_page(page, private, &result);
+	int rcu_locked = 0;
 
 	if (!newpage)
 		return -ENOMEM;
@@ -636,8 +637,13 @@ static int unmap_and_move(new_page_t get
 	 * we cannot notice that anon_vma is freed while we migrates a page.
 	 * This rcu_read_lock() delays freeing anon_vma pointer until the end
 	 * of migration. File cache pages are no problem because of page_lock()
+	 * File Caches may use write_page() or lock_page() in migration, then,
+	 * just care Anon page here.
 	 */
-	rcu_read_lock();
+	if (PageAnon(page)) {
+		rcu_read_lock();
+		rcu_locked = 1;
+	}
 	/*
 	 * This is a corner case handling.
 	 * When a new swap-cache is read into, it is linked to LRU
@@ -656,7 +662,8 @@ static int unmap_and_move(new_page_t get
 	if (rc)
 		remove_migration_ptes(page, page);
 rcu_unlock:
-	rcu_read_unlock();
+	if (rcu_locked)
+		rcu_read_unlock();
 
 unlock:
 

