Return-Path: <linux-kernel-owner+w=401wt.eu-S1758819AbYG3UN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758819AbYG3UN3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 16:13:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754535AbYG3UMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 16:12:39 -0400
Received: from ns1.suse.de ([195.135.220.2]:47286 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754399AbYG3UMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 16:12:38 -0400
From: Bernhard Walle <bwalle@suse.de>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, vgoyal@redhat.com,
       x86@kernel.org, Bernhard Walle <bwalle@suse.de>
Subject: [PATCH 2/2] firmware/memmap: Move kobject initialisation before kobject_add()
Date: Wed, 30 Jul 2008 22:12:32 +0200
Message-Id: <1217448752-13859-3-git-send-email-bwalle@suse.de>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1217448752-13859-1-git-send-email-bwalle@suse.de>
References: <1217448752-13859-1-git-send-email-bwalle@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because kobject_init() call could be done from firmware_map_add_entry()
which is called before kmalloc() can be used (we use the early bootmem allocator
here), move that call to memmap_init() which is a late_initcall.

This fixes following regression in linux-next tree:

    BUG: Int 14: CR2 b004254c
         EDI 00000000  ESI 00000082  EBP c0725ed8  ESP c0725eb4
         EBX f0002800  EDX 0000000e  ECX c071e070  EAX f000ff53
         err 00000000  EIP c0278e3f   CS 00000060  flg 00010086
    Stack: 000080d0 c071e070 c000e1dc c000e1c0 c06e1bf8 c0725eec c0313d59 c000e1d4
           c000e1c0 00000000 c0725f08 c074c7b8 00000000 0009cbff 00000000 c077b400
           00000001 c0725f34 c0732e06 0009cbff 00000000 c063af02 01000000 00000000
    Pid: 0, comm: swapper Not tainted 2.6.26-rc9-next-20080711 #4
     [<c0234266>] ? up+0x2b/0x2f
     [<c0278e3f>] ? kmem_cache_alloc+0x2e/0x7d
     [<c0313d59>] ? kobject_init+0x46/0xd0
     [<c074c7b8>] ? firmware_map_add_early+0x83/0xa3
     [<c0732e06>] ? e820_reserve_resources+0x10b/0x11e
     [<c07314d5>] ? setup_arch+0x871/0x8d7
     [<c0220f63>] ? release_console_sem+0x177/0x17f
     [<c07331ca>] ? __reserve_early+0xe4/0xf8
     [<c055e14e>] ? printk+0xf/0x11
     [<c072b67a>] ? start_kernel+0x5b/0x2d1
     [<c072b080>] ? __init_begin+0x80/0x88
     =======================


Signed-off-by: Bernhard Walle <bwalle@suse.de>
---
 drivers/firmware/memmap.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/firmware/memmap.c b/drivers/firmware/memmap.c
index 3bf8ee1..c8d787a 100644
--- a/drivers/firmware/memmap.c
+++ b/drivers/firmware/memmap.c
@@ -111,7 +111,12 @@ static int firmware_map_add_entry(resource_size_t start, resource_size_t end,
 	entry->end = end;
 	entry->type = type;
 	INIT_LIST_HEAD(&entry->list);
-	kobject_init(&entry->kobj, &memmap_ktype);
+	/*
+	 * don't init the kobject here since it calls kmalloc() internally
+	 * which we are not ready to do in firmware_map_add_early() case
+	 * Instead, do that before kobject_add() in memmap_init()
+	 */
+	memset(&entry->kobj, 0, sizeof(struct kobject));
 
 	list_add_tail(&entry->list, &map_entries);
 
@@ -221,6 +226,7 @@ static int __init memmap_init(void)
 		return -ENOMEM;
 
 	list_for_each_entry(entry, &map_entries, list) {
+		kobject_init(&entry->kobj, &memmap_ktype);
 		entry->kobj.kset = memmap_kset;
 		if (kobject_add(&entry->kobj, NULL, "%d", i++))
 			kobject_put(&entry->kobj);
-- 
1.5.6.4

