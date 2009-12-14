Return-Path: <linux-kernel-owner+w=401wt.eu-S1756736AbZLNKxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736AbZLNKxq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 05:53:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756628AbZLNKxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 05:53:45 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:34309 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073AbZLNKxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 05:53:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Hep/+Bsv4ehzRoQwWjGcNpZiL/QW6Zd040E5MzMe6YjSC73A0QCR5OnAGG6iXK1NU8
         lhA6O9uTy4D9L+KigRLQQsjK4EYozJGyavtkSx7/nxfHVMVC5/TYXFf0xDXYC/czuNKh
         Sdh6uJ3flpA4nWtodIXh8gU+CAX1Byt70/NYE=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Chris Mason <chris.mason@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 1/2] reiserfs: Fix possible recursive lock
Date: Mon, 14 Dec 2009 11:53:36 +0100
Message-Id: <1260788016-5468-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <a4423d670912111406g5967eb1fw93e49de242fbf54@mail.gmail.com>
References: <a4423d670912111406g5967eb1fw93e49de242fbf54@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While allocating the bitmap using vmalloc, we hold the reiserfs lock,
which makes lockdep later reporting a possible deadlock as we may
swap out pages to allocate memory and then take the reiserfs lock
recursively:

inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
kswapd0/312 [HC0[0]:SC0[0]:HE1:SE1] takes:
 (&REISERFS_SB(s)->lock){+.+.?.}, at: [<c11108a8>] reiserfs_write_lock+0x28/0x40
{RECLAIM_FS-ON-W} state was registered at:
  [<c104e1c2>] mark_held_locks+0x62/0x90
  [<c104e28a>] lockdep_trace_alloc+0x9a/0xc0
  [<c108e396>] kmem_cache_alloc+0x26/0xf0
  [<c10850ec>] __get_vm_area_node+0x6c/0xf0
  [<c10857de>] __vmalloc_node+0x7e/0xa0
  [<c108597b>] vmalloc+0x2b/0x30
  [<c10e00b9>] reiserfs_init_bitmap_cache+0x39/0x70
  [<c10f8178>] reiserfs_fill_super+0x2e8/0xb90
  [<c1094345>] get_sb_bdev+0x145/0x180
  [<c10f5a11>] get_super_block+0x21/0x30
  [<c10931f0>] vfs_kern_mount+0x40/0xd0
  [<c10932d9>] do_kern_mount+0x39/0xd0
  [<c10a9857>] do_mount+0x2c7/0x6b0
  [<c10a9ca6>] sys_mount+0x66/0xa0
  [<c161589b>] mount_block_root+0xc4/0x245
  [<c1615a75>] mount_root+0x59/0x5f
  [<c1615b8c>] prepare_namespace+0x111/0x14b
  [<c1615269>] kernel_init+0xcf/0xdb
  [<c10031fb>] kernel_thread_helper+0x7/0x1c

This is actually fine for two reasons: we call vmalloc at mount time
then it's not in the swapping out path. Also the reiserfs lock can be
acquired recursively, but since its implementation depends on a mutex,
it's hard and not necessary worth it to teach that to lockdep.

The lock is useless at mount time anyway, at least until we replay the
journal. But let's remove it from this path later as this needs
more thinking and is a sensible change.

For now we can just relax the lock around vmalloc,

Reported-by: Alexander Beregalov <a.beregalov@gmail.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 fs/reiserfs/bitmap.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/reiserfs/bitmap.c b/fs/reiserfs/bitmap.c
index 6854957..65c8727 100644
--- a/fs/reiserfs/bitmap.c
+++ b/fs/reiserfs/bitmap.c
@@ -1277,7 +1277,10 @@ int reiserfs_init_bitmap_cache(struct super_block *sb)
 	struct reiserfs_bitmap_info *bitmap;
 	unsigned int bmap_nr = reiserfs_bmap_count(sb);
 
+	/* Avoid lock recursion in fault case */
+	reiserfs_write_unlock(sb);
 	bitmap = vmalloc(sizeof(*bitmap) * bmap_nr);
+	reiserfs_write_lock(sb);
 	if (bitmap == NULL)
 		return -ENOMEM;
 
-- 
1.6.2.3

