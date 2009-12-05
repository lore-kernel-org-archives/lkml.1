Return-Path: <linux-kernel-owner+w=401wt.eu-S932934AbZLEUSO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932934AbZLEUSO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 15:18:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757679AbZLEUSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 15:18:12 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:41338 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756427AbZLEURB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 15:17:01 -0500
Date: Sat, 05 Dec 2009 19:08:50 +0000
To: linux-arch@vger.kernel.org
Subject: [RFC][PATCH 5/18] fix the arch checks in MREMAP_FIXED case
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1NGzzu-0008RR-UD@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 mm/mremap.c |   19 +++++++++++++++++--
 1 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index 9d07539..84efffb 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -325,6 +325,7 @@ static unsigned long mremap_to(unsigned long addr,
 	struct vm_area_struct *vma;
 	unsigned long ret = -EINVAL;
 	unsigned long charged = 0;
+	unsigned long map_flags;
 
 	if (new_addr & ~PAGE_MASK)
 		goto out;
@@ -362,9 +363,23 @@ static unsigned long mremap_to(unsigned long addr,
 		goto out;
 	}
 
-	ret = move_vma(vma, addr, old_len, new_len, new_addr);
+	map_flags = MAP_FIXED;
+	if (vma->vm_flags & VM_MAYSHARE)
+		map_flags |= MAP_SHARED;
+	ret = arch_mmap_check(new_addr, new_len, map_flags);
+	if (ret)
+		goto out1;
+	ret = get_unmapped_area(vma->vm_file, new_addr, new_len, vma->vm_pgoff +
+				((addr - vma->vm_start) >> PAGE_SHIFT),
+				map_flags);
 	if (ret & ~PAGE_MASK)
-		vm_unacct_memory(charged);
+		goto out1;
+
+	ret = move_vma(vma, addr, old_len, new_len, new_addr);
+	if (!(ret & ~PAGE_MASK))
+		goto out;
+out1:
+	vm_unacct_memory(charged);
 
 out:
 	return ret;
-- 
1.5.6.5


