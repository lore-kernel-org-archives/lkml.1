Return-Path: <linux-kernel-owner+w=401wt.eu-S1754281AbZKBJpN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281AbZKBJpN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 04:45:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754181AbZKBJpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 04:45:12 -0500
Received: from server1.wserver.cz ([82.113.45.157]:39035 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175AbZKBJpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 04:45:11 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>
Subject: [PATCH 1/1] MM: swapfile, fix crash on double swapon
Date: Mon,  2 Nov 2009 10:45:03 +0100
Message-Id: <1257155103-9189-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Double swapon on a device causes a crash:
BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<ffffffff810af160>] sys_swapon+0x1f0/0xc60
PGD 1dc0b067 PUD 1dc09067 PMD 0
Oops: 0000 [#1] SMP
last sysfs file:
CPU 1
Modules linked in:
Pid: 562, comm: swapon Tainted: G        W  2.6.32-rc5-mm1_64 #867
RIP: 0010:[<ffffffff810af160>]  [<ffffffff810af160>] sys_swapon+0x1f0/0xc60
...

It is due to swap_info_struct->first_swap_extent.list not being
initialized. ->next is NULL in such a situation and
destroy_swap_extents fails to iterate over the list with the BUG
above.

Introduced by swap_info-include-first_swap_extent.patch. Revert the
INIT_LIST_HEAD move.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
---
 mm/swapfile.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 93e71cf..26ef6a2 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1313,7 +1313,6 @@ add_swap_extent(struct swap_info_struct *sis, unsigned long start_page,
 	if (start_page == 0) {
 		se = &sis->first_swap_extent;
 		sis->curr_swap_extent = se;
-		INIT_LIST_HEAD(&se->list);
 		se->start_page = 0;
 		se->nr_pages = nr_pages;
 		se->start_block = start_block;
@@ -1769,6 +1768,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		kfree(p);
 		goto out;
 	}
+	INIT_LIST_HEAD(&p->first_swap_extent.list);
 	if (type >= nr_swapfiles) {
 		p->type = type;
 		swap_info[type] = p;
-- 
1.6.4.2

