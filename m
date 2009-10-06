Return-Path: <linux-kernel-owner+w=401wt.eu-S1756836AbZJFJvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836AbZJFJvl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 05:51:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756732AbZJFJvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 05:51:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49652 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756643AbZJFJvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 05:51:39 -0400
Date: Tue, 6 Oct 2009 11:51:11 +0200
From: Gleb Natapov <gleb@redhat.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Subject: [PATCH][RFC] add MAP_UNLOCKED mmap flag
Message-ID: <20091006095111.GG9832@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If application does mlockall(MCL_FUTURE) it is no longer possible to
mmap file bigger than main memory or allocate big area of anonymous
memory. Sometimes it is desirable to lock everything related to program
execution into memory, but still be able to mmap big file or allocate
huge amount of memory and allow OS to swap them on demand. MAP_UNLOCKED
allows to do that.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
diff --git a/include/asm-generic/mman.h b/include/asm-generic/mman.h
index 32c8bd6..0ab4c74 100644
--- a/include/asm-generic/mman.h
+++ b/include/asm-generic/mman.h
@@ -12,6 +12,7 @@
 #define MAP_NONBLOCK	0x10000		/* do not block on IO */
 #define MAP_STACK	0x20000		/* give out an address that is best suited for process/thread stacks */
 #define MAP_HUGETLB	0x40000		/* create a huge page mapping */
+#define MAP_UNLOKED	0x80000         /* pages are unlocked */
 
 #define MCL_CURRENT	1		/* lock all current mappings */
 #define MCL_FUTURE	2		/* lock all future mappings */
diff --git a/mm/mmap.c b/mm/mmap.c
index 73f5e4b..7c2abdb 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -985,6 +985,9 @@ unsigned long do_mmap_pgoff(struct file *file, unsigned long addr,
 		if (!can_do_mlock())
 			return -EPERM;
 
+        if (flags & MAP_UNLOKED)
+                vm_flags &= ~VM_LOCKED;
+
 	/* mlock MCL_FUTURE? */
 	if (vm_flags & VM_LOCKED) {
 		unsigned long locked, lock_limit;
--
			Gleb.
