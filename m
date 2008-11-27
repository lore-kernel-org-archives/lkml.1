Return-Path: <linux-kernel-owner+w=401wt.eu-S1753417AbYK0OZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417AbYK0OZi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 09:25:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751904AbYK0OZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 09:25:28 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:53413 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045AbYK0OZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 09:25:27 -0500
Date: Thu, 27 Nov 2008 15:25:24 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH] arch/frv/kernel/sys_frv.c: add missing fput
Message-ID: <Pine.LNX.4.64.0811271524340.15160@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

fget increments a reference count, so fput is needed to decrement it.  I
have added a goto to the end of the function where there was already such a
call.

The semantic patch that finds this problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@
local idexpression x;
statement S;
position p1,p2;
identifier f;
expression E;
expression *ptr != NULL;
@@

 x@p1 = fget(...);
 ... when != x
 if (x == NULL) S
 <... when != x
      when != if (...) { <+...x...+> }
  x->f = E
 ...>
(
 return \(0\|<+...x...+>\|ptr\);
|
 return@p2 ...;
)

@ script:python @
p1 << r.p1;
p2 << r.p2;
@@
print "%s: call: %s return: %s" % (p1[0].file,p1[0].line,p2[0].line)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 arch/frv/kernel/sys_frv.c           |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/frv/kernel/sys_frv.c b/arch/frv/kernel/sys_frv.c
index 49b2cf2..70c87fb 100644
--- a/arch/frv/kernel/sys_frv.c
+++ b/arch/frv/kernel/sys_frv.c
@@ -47,8 +47,10 @@ asmlinkage long sys_mmap2(unsigned long addr, unsigned long len,
 
 	/* But unlike sparc32, don't just silently break if we're
 	   trying to map something we can't */
-	if (pgoff & ((1<<(PAGE_SHIFT-12))-1))
-		return -EINVAL;
+	if (pgoff & ((1<<(PAGE_SHIFT-12))-1)) {
+		error = -EINVAL;
+		goto out_file;
+	}
 
 	pgoff >>= (PAGE_SHIFT - 12);
 
@@ -56,6 +58,7 @@ asmlinkage long sys_mmap2(unsigned long addr, unsigned long len,
 	error = do_mmap_pgoff(file, addr, len, prot, flags, pgoff);
 	up_write(&current->mm->mmap_sem);
 
+out_file:
 	if (file)
 		fput(file);
 out:
