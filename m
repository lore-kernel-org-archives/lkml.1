Return-Path: <linux-kernel-owner+w=401wt.eu-S934588AbZLGAcD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934588AbZLGAcD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:32:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934574AbZLGAbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:31:46 -0500
Received: from kroah.org ([198.145.64.141]:34320 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758393AbZLGAMy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:12:54 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:46 2009
Message-Id: <20091207000646.002713921@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:00:11 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Balbir Singh <balbir@in.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [035/119] memcg: fix wrong pointer initialization at page migration when memcg is disabled.
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=memcg-fix-wrong-pointer-initialization-at-page-migration-when-memcg-is-disabled.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

commit e00e431612c3a6e437a01f2129fd3843da0c982a upstream.

Lee Schermerhorn reported that he saw bad pointer dereference in
mem_cgroup_end_migration() when he disabled memcg by boot option.

memcg's page migration logic works as

	mem_cgroup_prepare_migration(page, &ptr);
	do page migration
	mem_cgroup_end_migration(page, ptr);

Now, ptr is not initialized in prepare_migration when memcg is disabled
by boot option. This causes panic in end_migration. This patch fixes it.

Reported-by: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -597,7 +597,7 @@ static int unmap_and_move(new_page_t get
 	struct page *newpage = get_new_page(page, private, &result);
 	int rcu_locked = 0;
 	int charge = 0;
-	struct mem_cgroup *mem;
+	struct mem_cgroup *mem = NULL;
 
 	if (!newpage)
 		return -ENOMEM;


