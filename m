Return-Path: <linux-kernel-owner+w=401wt.eu-S1760007AbYFRBIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760007AbYFRBIx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 21:08:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758793AbYFRBIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 21:08:44 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:40339 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758516AbYFRBIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 21:08:43 -0400
Date: Wed, 18 Jun 2008 10:13:49 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       "hugh@veritas.com" <hugh@veritas.com>
Subject: Re: [PATCH][RFC] fix kernel BUG at mm/migrate.c:719! in
 2.6.26-rc5-mm3
Message-Id: <20080618101349.db4d5205.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080617163501.7cf411ee.nishimura@mxp.nes.nec.co.jp>
References: <20080611225945.4da7bb7f.akpm@linux-foundation.org>
	<20080617163501.7cf411ee.nishimura@mxp.nes.nec.co.jp>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jun 2008 16:35:01 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> This patch also fixes a race between migrate_entry_wait and
> page_freeze_refs in migrate_page_move_mapping.
> 
Ok, let's fix one by one. please add your Signed-off-by if ok.

This is a fix for page migration under speculative page lookup protocol.
-Kame
==
In speculative page cache lookup protocol, page_count(page) is set to 0
while radix-tree midification is going on, truncation, migration, etc...

While page migration, a page fault to page under migration should wait
unlock_page() and migration_entry_wait() waits for the page from its
pte entry. It does get_page() -> wait_on_page_locked() -> put_page() now.

In page migration, page_freeze_refs() -> page_unfreeze_refs() is called.

Here, page_unfreeze_refs() expects page_count(page) == 0 and panics
if page_count(page) != 0. To avoid this, we shouldn't touch page_count()
if it is zero. This patch uses page_cache_get_speculative() to avoid
the panic.

From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/migrate.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: test-2.6.26-rc5-mm3/mm/migrate.c
===================================================================
--- test-2.6.26-rc5-mm3.orig/mm/migrate.c
+++ test-2.6.26-rc5-mm3/mm/migrate.c
@@ -243,7 +243,8 @@ void migration_entry_wait(struct mm_stru
 
 	page = migration_entry_to_page(entry);
 
-	get_page(page);
+	if (!page_cache_get_speculative())
+		goto out;
 	pte_unmap_unlock(ptep, ptl);
 	wait_on_page_locked(page);
 	put_page(page);


