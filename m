Return-Path: <linux-kernel-owner+w=401wt.eu-S934620AbZLGDx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934620AbZLGDx2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 22:53:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934611AbZLGDx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 22:53:26 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51482 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934607AbZLGDxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 22:53:24 -0500
Date: Mon, 07 Dec 2009 03:53:30 +0000
To: linux-arch@vger.kernel.org
Subject: [PATCH 10/19] Kill ancient crap in s390 compat mmap
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1NHUfC-0007wf-QG@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We've had TASK_SIZE set to 1<<31 for 31bit tasks since May 2004.
Before that old32_mmap() had to deal with do_mmap_pgoff() giving
it an address out of range.  It had tried to do that by checking
return value and doing do_munmap() (at wrong address, BTW).

IOW, that code had been dead for 5.5 years (and bogus - for 8).
Kill.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/s390/kernel/compat_linux.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/arch/s390/kernel/compat_linux.c b/arch/s390/kernel/compat_linux.c
index 0debcec..c5a9fba 100644
--- a/arch/s390/kernel/compat_linux.c
+++ b/arch/s390/kernel/compat_linux.c
@@ -701,11 +701,6 @@ static inline long do_mmap2(
 
 	down_write(&current->mm->mmap_sem);
 	error = do_mmap_pgoff(file, addr, len, prot, flags, pgoff);
-	if (!IS_ERR((void *) error) && error + len >= 0x80000000ULL) {
-		/* Result is out of bounds.  */
-		do_munmap(current->mm, addr, len);
-		error = -ENOMEM;
-	}
 	up_write(&current->mm->mmap_sem);
 
 	if (file)
-- 
1.5.6.5


