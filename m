Return-Path: <linux-kernel-owner+w=401wt.eu-S932195AbXGZXxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195AbXGZXxR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 19:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752240AbXGZXxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 19:53:08 -0400
Received: from smtp-out.google.com ([216.239.33.17]:42292 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755485AbXGZXxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 19:53:07 -0400
From: Suleiman Souhlal <ssouhlal@FreeBSD.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Suleiman Souhlal <ssouhlal@FreeBSD.org>,
       Suleiman Souhlal <suleiman@google.com>
Subject: [PATCH] Don't needlessly dirty mlocked pages when initially faulting them in.
Date: Thu, 26 Jul 2007 16:52:44 -0700
Message-Id: <11854939641916-git-send-email-ssouhlal@FreeBSD.org>
X-Mailer: git-send-email 1.4.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

make_pages_present() is dirtying mlocked pages if the VMA is writable, even
though it shouldn't, by telling get_user_pages() to simulate a write fault.

A simple way to test this is to mlock a multi-GB file, and then sync.
The sync will take a long time.

As far as I can see, it should be safe to just not simulate a write fault.

Signed-off-by: Suleiman Souhlal <suleiman@google.com>
---
 mm/memory.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index f64cbf9..f43c9e8 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2664,18 +2664,17 @@ #endif /* __PAGETABLE_PMD_FOLDED */
 
 int make_pages_present(unsigned long addr, unsigned long end)
 {
-	int ret, len, write;
+	int ret, len;
 	struct vm_area_struct * vma;
 
 	vma = find_vma(current->mm, addr);
 	if (!vma)
 		return -1;
-	write = (vma->vm_flags & VM_WRITE) != 0;
 	BUG_ON(addr >= end);
 	BUG_ON(end > vma->vm_end);
 	len = (end+PAGE_SIZE-1)/PAGE_SIZE-addr/PAGE_SIZE;
 	ret = get_user_pages(current, current->mm, addr,
-			len, write, 0, NULL, NULL);
+			len, 0, 0, NULL, NULL);
 	if (ret < 0)
 		return ret;
 	return ret == len ? 0 : -1;
-- 
1.4.2

