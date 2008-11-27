Return-Path: <linux-kernel-owner+w=401wt.eu-S1754040AbYK0PMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040AbYK0PMz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 10:12:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751272AbYK0PMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 10:12:46 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43454 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045AbYK0PMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 10:12:45 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] FRV: Fix mmap2 error handling
To: torvalds@osdl.org, akpm@linux-foundation.org, julia@diku.dk
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Date: Thu, 27 Nov 2008 15:12:38 +0000
Message-ID: <20081127151238.13728.34704.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the error handling in sys_mmap2().  Currently, if the pgoff check fails,
fput() might have to be called (which it isn't), so do the pgoff check first,
before fget() is called.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/frv/kernel/sys_frv.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)


diff --git a/arch/frv/kernel/sys_frv.c b/arch/frv/kernel/sys_frv.c
index 49b2cf2..baadc97 100644
--- a/arch/frv/kernel/sys_frv.c
+++ b/arch/frv/kernel/sys_frv.c
@@ -35,22 +35,21 @@ asmlinkage long sys_mmap2(unsigned long addr, unsigned long len,
 	int error = -EBADF;
 	struct file * file = NULL;
 
-	flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);
-	if (!(flags & MAP_ANONYMOUS)) {
-		file = fget(fd);
-		if (!file)
-			goto out;
-	}
-
 	/* As with sparc32, make sure the shift for mmap2 is constant
 	   (12), no matter what PAGE_SIZE we have.... */
 
 	/* But unlike sparc32, don't just silently break if we're
 	   trying to map something we can't */
-	if (pgoff & ((1<<(PAGE_SHIFT-12))-1))
+	if (pgoff & ((1 << (PAGE_SHIFT - 12)) - 1))
 		return -EINVAL;
+	pgoff >>= PAGE_SHIFT - 12;
 
-	pgoff >>= (PAGE_SHIFT - 12);
+	flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);
+	if (!(flags & MAP_ANONYMOUS)) {
+		file = fget(fd);
+		if (!file)
+			goto out;
+	}
 
 	down_write(&current->mm->mmap_sem);
 	error = do_mmap_pgoff(file, addr, len, prot, flags, pgoff);

