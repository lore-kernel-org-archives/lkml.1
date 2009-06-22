Return-Path: <linux-kernel-owner+w=401wt.eu-S1752437AbZFVNhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437AbZFVNhy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 09:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752003AbZFVNhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 09:37:47 -0400
Received: from edb171.neoplus.adsl.tpnet.pl ([83.22.243.171]:54206 "EHLO
	krzysiek.podlesie.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751994AbZFVNhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 09:37:47 -0400
X-Greylist: delayed 1038 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Jun 2009 09:37:46 EDT
From: Krzysztof Mazur <krzysiek@podlesie.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Krzysztof Mazur <krzysiek@podlesie.net>
Subject: [PATCH] generic arch_get_unmapped_area(): make sure that addr >= TASK_UNMAPPED_BASE
Date: Mon, 22 Jun 2009 15:20:29 +0200
Message-Id: <12456768291898-git-send-email-krzysiek@podlesie.net>
X-Mailer: git-send-email 1.5.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Generic arch_get_unmapped_area() use mm->free_area_cache for start_addr
and addr even when it's smaller that TASK_UNMAPPED_BASE.

	if (len > mm->cached_hole_size) {
	        start_addr = addr = mm->free_area_cache;
	} else {
	        start_addr = addr = TASK_UNMAPPED_BASE;
 	        mm->cached_hole_size = 0;
 	}

I don't know how it should work (maybe mm->free_area_cache should be
never smaller than TASK_UNMAPPED_BASE, but it was 0 when I took strace
below), but I copied code from x86-64's arch_get_unmapped_area(),
there is:

	if (((flags & MAP_32BIT) || test_thread_flag(TIF_IA32))
	    && len <= mm->cached_hole_size) {
		mm->cached_hole_size = 0;
		mm->free_area_cache = begin;
	}
	addr = mm->free_area_cache;
	if (addr < begin)
		addr = begin;
	start_addr = addr;

Now with check for begin (TASK_UNMAPPED_BASE in generic code) it seems
to be ok.

Previously I had -EACCESS when process used legacy VA layout (for instance
because of no RLIMIT_STACK limit):

setrlimit(RLIMIT_STACK, {rlim_cur=RLIM_INFINITY, rlim_max=RLIM_INFINITY}) = 0
...
vfork(Process 1819 attached (waiting for parent)
Process 1819 resumed (parent 1818 ready)
)                                 = 1819
[pid  1819] rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
[pid  1819] execve("/bin/sh", ["/bin/sh", "-c", "if test ! -f config.h; then \\\n  "...], [/* 26 vars */]) = 0
[pid  1819] brk(0)                      = 0x8a01000
[pid  1819] uname({sys="Linux", node="geronimo", ...}) = 0
[pid  1819] access("/etc/ld.so.preload", R_OK) = -1 ENOENT (No such file or directory)
[pid  1819] open("/etc/ld.so.cache", O_RDONLY) = 3
[pid  1819] fstat64(3, {st_mode=S_IFREG|0644, st_size=105204, ...}) = 0
[pid  1819] mmap2(NULL, 105204, PROT_READ, MAP_PRIVATE, 3, 0) = -1 EACCES (Permission denied)

Signed-off-by: Krzysztof Mazur <krzysiek@podlesie.net>
---
 mm/mmap.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 34579b2..577cfc0 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1289,12 +1289,15 @@ arch_get_unmapped_area(struct file *filp, unsigned long addr,
 		    (!vma || addr + len <= vma->vm_start))
 			return addr;
 	}
-	if (len > mm->cached_hole_size) {
-	        start_addr = addr = mm->free_area_cache;
-	} else {
-	        start_addr = addr = TASK_UNMAPPED_BASE;
-	        mm->cached_hole_size = 0;
+
+	if (len <= mm->cached_hole_size) {
+		mm->free_area_cache = TASK_UNMAPPED_BASE;
+		mm->cached_hole_size = 0;
 	}
+	addr = mm->free_area_cache;
+	if (addr < TASK_UNMAPPED_BASE)
+		addr = TASK_UNMAPPED_BASE;
+	start_addr = addr;
 
 full_search:
 	for (vma = find_vma(mm, addr); ; vma = vma->vm_next) {
-- 
1.5.1.3

