Return-Path: <linux-kernel-owner+w=401wt.eu-S1753349AbZELFVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349AbZELFVt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 01:21:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752302AbZELFVk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 01:21:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57927 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752284AbZELFVj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 01:21:39 -0400
Date: Tue, 12 May 2009 07:21:39 +0200
From: Nick Piggin <npiggin@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [patch] mm: madvise correct return code
Message-ID: <20090512052139.GE32535@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a pretty obscure case, but it doesn't hurt to follow standards
if they're there. I can't imagine any real program relying on a 0 range
madvise call with invalid behaviour *not* failing... We have this in
SLES11 FWIW, and no problems reported.
--

mm: madvise correct return code

The posix_madvise() function succeeds (and does nothing) when called with
parameters (NULL, 0, -1); according to LSB tests, it should fail with EINVAL
because -1 is not a valid flag.

When called with a valid address and size, it correctly fails.

So perform an initial check for valid flags first.

Reported-by: Jiri Dluhos <jdluhos@novell.com>
Signed-off-by: Nick Piggin <npiggin@suse.de>
---
 mm/madvise.c |   23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

Index: linux-2.6/mm/madvise.c
===================================================================
--- linux-2.6.orig/mm/madvise.c
+++ linux-2.6/mm/madvise.c
@@ -247,12 +247,30 @@ madvise_vma(struct vm_area_struct *vma,
 		break;
 
 	default:
-		error = -EINVAL;
+		BUG();
 		break;
 	}
 	return error;
 }
 
+static int
+madvise_behavior_valid(int behavior)
+{
+	switch (behavior) {
+	case MADV_DOFORK:
+	case MADV_DONTFORK:
+	case MADV_NORMAL:
+	case MADV_SEQUENTIAL:
+	case MADV_RANDOM:
+	case MADV_REMOVE:
+	case MADV_WILLNEED:
+	case MADV_DONTNEED:
+		return 1;
+
+	default:
+		return 0;
+	}
+}
 /*
  * The madvise(2) system call.
  *
@@ -298,6 +316,9 @@ SYSCALL_DEFINE3(madvise, unsigned long,
 	int write;
 	size_t len;
 
+	if (!madvise_behavior_valid(behavior))
+		return error;
+
 	write = madvise_need_mmap_write(behavior);
 	if (write)
 		down_write(&current->mm->mmap_sem);
