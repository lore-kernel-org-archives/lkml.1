Return-Path: <linux-kernel-owner+w=401wt.eu-S932940AbZLEUTK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932940AbZLEUTK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 15:19:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757735AbZLEUTD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 15:19:03 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:41330 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756743AbZLEUQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 15:16:46 -0500
Date: Sat, 05 Dec 2009 19:08:50 +0000
To: linux-arch@vger.kernel.org
Subject: [RFC][PATCH 8/18] file ->get_unmapped_area() shouldn't duplicate
 work of get_unmapped_area()
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1NGzzu-0008RX-VJ@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


... we should call mm ->get_unmapped_area() instead and let our caller
do the final checks.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/sparc/kernel/sys_sparc_64.c |   10 +++++++---
 ipc/shm.c                        |    2 +-
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/sparc/kernel/sys_sparc_64.c b/arch/sparc/kernel/sys_sparc_64.c
index ddda12f..d498b32 100644
--- a/arch/sparc/kernel/sys_sparc_64.c
+++ b/arch/sparc/kernel/sys_sparc_64.c
@@ -317,10 +317,14 @@ bottomup:
 unsigned long get_fb_unmapped_area(struct file *filp, unsigned long orig_addr, unsigned long len, unsigned long pgoff, unsigned long flags)
 {
 	unsigned long align_goal, addr = -ENOMEM;
+	unsigned long (*get_area)(struct file *, unsigned long,
+				  unsigned long, unsigned long, unsigned long);
+
+	get_area = current->mm->get_unmapped_area;
 
 	if (flags & MAP_FIXED) {
 		/* Ok, don't mess with it. */
-		return get_unmapped_area(NULL, orig_addr, len, pgoff, flags);
+		return get_area(NULL, orig_addr, len, pgoff, flags);
 	}
 	flags &= ~MAP_SHARED;
 
@@ -333,7 +337,7 @@ unsigned long get_fb_unmapped_area(struct file *filp, unsigned long orig_addr, u
 		align_goal = (64UL * 1024);
 
 	do {
-		addr = get_unmapped_area(NULL, orig_addr, len + (align_goal - PAGE_SIZE), pgoff, flags);
+		addr = get_area(NULL, orig_addr, len + (align_goal - PAGE_SIZE), pgoff, flags);
 		if (!(addr & ~PAGE_MASK)) {
 			addr = (addr + (align_goal - 1UL)) & ~(align_goal - 1UL);
 			break;
@@ -351,7 +355,7 @@ unsigned long get_fb_unmapped_area(struct file *filp, unsigned long orig_addr, u
 	 * be obtained.
 	 */
 	if (addr & ~PAGE_MASK)
-		addr = get_unmapped_area(NULL, orig_addr, len, pgoff, flags);
+		addr = get_area(NULL, orig_addr, len, pgoff, flags);
 
 	return addr;
 }
diff --git a/ipc/shm.c b/ipc/shm.c
index 464694e..7e50727 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -290,7 +290,7 @@ static unsigned long shm_get_unmapped_area(struct file *file,
 	unsigned long flags)
 {
 	struct shm_file_data *sfd = shm_file_data(file);
-	return get_unmapped_area(sfd->file, addr, len, pgoff, flags);
+	return current->mm->get_unmapped_area(sfd->file, addr, len, pgoff, flags);
 }
 
 int is_file_shm_hugepages(struct file *file)
-- 
1.5.6.5


