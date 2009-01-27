Return-Path: <linux-kernel-owner+w=401wt.eu-S1754559AbZA0WrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559AbZA0WrT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 17:47:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbZA0WrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 17:47:09 -0500
Received: from host64.cybernetics.com ([98.174.209.230]:3716 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbZA0WrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 17:47:09 -0500
Message-ID: <497F8EE8.8070402@cybernetics.com>
Date: Tue, 27 Jan 2009 17:47:04 -0500
From: Tony Battersby <tonyb@cybernetics.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <olsajiri@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/2] fix shmctl(SHM_INFO) lockup with !CONFIG_SHMEM
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

shm_get_stat() assumes that the inode is a "struct
shmem_inode_info", which is incorrect for !CONFIG_SHMEM (see
fs/ramfs/inode.c::ramfs_get_inode() vs. mm/shmem.c::shmem_get_inode()).
This bad assumption can cause shmctl(SHM_INFO) to lockup when
shm_get_stat() tries to spin_lock(&info->lock).  Users of !CONFIG_SHMEM
may encounter this lockup simply by invoking the 'ipcs' command.

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
CC: <stable@kernel.org>
---

This bug was reported by Jiri Olsa back in February 2008; CC'ing the
people involved in the original discussion.
http://lkml.org/lkml/2008/2/29/74

--- linux-2.6.29-rc2-git3/ipc/shm.c.orig	2009-01-27 16:23:10.000000000 -0500
+++ linux-2.6.29-rc2-git3/ipc/shm.c	2009-01-27 16:23:32.000000000 -0500
@@ -565,11 +565,15 @@ static void shm_get_stat(struct ipc_name
 			struct hstate *h = hstate_file(shp->shm_file);
 			*rss += pages_per_huge_page(h) * mapping->nrpages;
 		} else {
+#ifdef CONFIG_SHMEM
 			struct shmem_inode_info *info = SHMEM_I(inode);
 			spin_lock(&info->lock);
 			*rss += inode->i_mapping->nrpages;
 			*swp += info->swapped;
 			spin_unlock(&info->lock);
+#else
+			*rss += inode->i_mapping->nrpages;
+#endif
 		}
 
 		total++;



