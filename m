Return-Path: <linux-kernel-owner+w=401wt.eu-S934703AbZLGDzE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934703AbZLGDzE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 22:55:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934663AbZLGDy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 22:54:59 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51502 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934634AbZLGDy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 22:54:56 -0500
Date: Mon, 07 Dec 2009 03:55:01 +0000
To: linux-arch@vger.kernel.org
Subject: [PATCH 19/19] fix broken aliasing checks for MAP_FIXED on
 sparc32, mips, arm and sh
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1NHUgf-0007zS-3C@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We want addr - (pgoff << PAGE_SHIFT) consistently coloured...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
[MIPS part is in arch tree already]
 arch/arm/mm/mmap.c               |    3 ++-
 arch/mips/kernel/syscall.c       |    3 ++-
 arch/sh/mm/mmap.c                |    3 ++-
 arch/sparc/kernel/sys_sparc_32.c |    3 ++-
 4 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mm/mmap.c b/arch/arm/mm/mmap.c
index 2b79964..f5abc51 100644
--- a/arch/arm/mm/mmap.c
+++ b/arch/arm/mm/mmap.c
@@ -54,7 +54,8 @@ arch_get_unmapped_area(struct file *filp, unsigned long addr,
 	 * We enforce the MAP_FIXED case.
 	 */
 	if (flags & MAP_FIXED) {
-		if (aliasing && flags & MAP_SHARED && addr & (SHMLBA - 1))
+		if (aliasing && flags & MAP_SHARED &&
+		    (addr - (pgoff << PAGE_SHIFT)) & (SHMLBA - 1))
 			return -EINVAL;
 		return addr;
 	}
diff --git a/arch/mips/kernel/syscall.c b/arch/mips/kernel/syscall.c
index c25b2e7..3f7f466 100644
--- a/arch/mips/kernel/syscall.c
+++ b/arch/mips/kernel/syscall.c
@@ -93,7 +93,8 @@ unsigned long arch_get_unmapped_area(struct file *filp, unsigned long addr,
 		 * We do not accept a shared mapping if it would violate
 		 * cache aliasing constraints.
 		 */
-		if ((flags & MAP_SHARED) && (addr & shm_align_mask))
+		if ((flags & MAP_SHARED) &&
+		    ((addr - (pgoff << PAGE_SHIFT)) & shm_align_mask))
 			return -EINVAL;
 		return addr;
 	}
diff --git a/arch/sh/mm/mmap.c b/arch/sh/mm/mmap.c
index d2984fa..afeb710 100644
--- a/arch/sh/mm/mmap.c
+++ b/arch/sh/mm/mmap.c
@@ -54,7 +54,8 @@ unsigned long arch_get_unmapped_area(struct file *filp, unsigned long addr,
 		/* We do not accept a shared mapping if it would violate
 		 * cache aliasing constraints.
 		 */
-		if ((flags & MAP_SHARED) && (addr & shm_align_mask))
+		if ((flags & MAP_SHARED) &&
+		    ((addr - (pgoff << PAGE_SHIFT)) & shm_align_mask))
 			return -EINVAL;
 		return addr;
 	}
diff --git a/arch/sparc/kernel/sys_sparc_32.c b/arch/sparc/kernel/sys_sparc_32.c
index 997bdd0..3a82e65 100644
--- a/arch/sparc/kernel/sys_sparc_32.c
+++ b/arch/sparc/kernel/sys_sparc_32.c
@@ -45,7 +45,8 @@ unsigned long arch_get_unmapped_area(struct file *filp, unsigned long addr, unsi
 		/* We do not accept a shared mapping if it would violate
 		 * cache aliasing constraints.
 		 */
-		if ((flags & MAP_SHARED) && (addr & (SHMLBA - 1)))
+		if ((flags & MAP_SHARED) &&
+		    ((addr - (pgoff << PAGE_SHIFT)) & (SHMLBA - 1)))
 			return -EINVAL;
 		return addr;
 	}
-- 
1.5.6.5

