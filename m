Return-Path: <linux-kernel-owner+w=401wt.eu-S1755871AbYFSJNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871AbYFSJNr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 05:13:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752430AbYFSJNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 05:13:40 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39079 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbYFSJNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 05:13:39 -0400
Date: Thu, 19 Jun 2008 18:13:59 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>
Subject: [-mm][PATCH 2/5] migration_entry_wait fix.
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20080619172241.E7FC.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080619172241.E7FC.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-Id: <20080619180856.E805.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

In speculative page cache lookup protocol, page_count(page) is set to 0
while radix-tree modification is going on, truncation, migration, etc...

While page migration, a page fault to page under migration should wait
unlock_page() and migration_entry_wait() waits for the page from its
pte entry. It does get_page() -> wait_on_page_locked() -> put_page() now.

In page migration, page_freeze_refs() -> page_unfreeze_refs() is called.

Here, page_unfreeze_refs() expects page_count(page) == 0 and panics
if page_count(page) != 0. To avoid this, we shouldn't touch page_count()
if it is zero. This patch uses page_cache_get_speculative() to avoid
the panic.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Nick Piggin <npiggin@suse.de>

---
 mm/migrate.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

Index: b/mm/migrate.c
===================================================================
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -243,7 +243,15 @@ void migration_entry_wait(struct mm_stru
 
 	page = migration_entry_to_page(entry);
 
-	get_page(page);
+	/*
+	 * Once radix-tree replacement of page migration started, page_count
+	 * *must* be zero. And, we don't want to call wait_on_page_locked()
+	 * against a page without get_page().
+	 * So, we use get_page_unless_zero(), here. Even failed, page fault
+	 * will occur again.
+	 */
+	if (!get_page_unless_zero(page))
+		goto out;
 	pte_unmap_unlock(ptep, ptl);
 	wait_on_page_locked(page);
 	put_page(page);


