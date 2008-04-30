Return-Path: <linux-kernel-owner+w=401wt.eu-S932760AbYD3Uv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932760AbYD3Uv0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 16:51:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760849AbYD3Uuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 16:50:55 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:44597 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758830AbYD3Uuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 16:50:54 -0400
Date: Wed, 30 Apr 2008 21:42:41 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org
Subject: [PATCH 1/2] mm: Fix overcommit overflow
Message-ID: <20080430214241.4313e9ca@core>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sami Farin reported an overflow in the overcommit handling on 64bit boxes.

We use atomic_t for page counting which is fine on 32bit but on 64bit
overflows. We can use atomic64_t but there is a problem - most heavy
users of zero overcommit are embedded people whose 64bit atomics are
really slow and expensive operations. Thus we use a few defines to flip
32 or 64bit according to the size of a long

(Split into two diffs to keep ownership correct)

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-mm1/include/linux/mman.h linux-2.6.25-mm1/include/linux/mman.h
--- linux.vanilla-2.6.25-mm1/include/linux/mman.h	2008-04-28 11:35:21.000000000 +0100
+++ linux-2.6.25-mm1/include/linux/mman.h	2008-04-30 11:21:10.000000000 +0100
@@ -15,16 +15,31 @@
 
 #include <asm/atomic.h>
 
+/* 32bit platforms have a virtual address space in pages we
+   can fit into an atomic_t. We want to avoid atomic64_t on
+   such boxes as it is often expensive and most strict overcommit
+   users turn out to be embedded low power processors */
+
+#if (BITS_PER_LONG == 32)
+#define vm_atomic_t atomic_t
+#define vm_atomic_read atomic_read
+#define vm_atomic_add atomic_add
+#else
+#define vm_atomic_t atomic64_t
+#define vm_atomic_read atomic64_read
+#define vm_atomic_add atomic64_add
+#endif
+
 extern int sysctl_overcommit_memory;
 extern int sysctl_overcommit_ratio;
-extern atomic_t vm_committed_space;
+extern vm_atomic_t vm_committed_space;
 
 #ifdef CONFIG_SMP
 extern void vm_acct_memory(long pages);
 #else
 static inline void vm_acct_memory(long pages)
 {
-	atomic_add(pages, &vm_committed_space);
+	vm_atomic_add(pages, &vm_committed_space);
 }
 #endif
 
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-mm1/mm/mmap.c linux-2.6.25-mm1/mm/mmap.c
--- linux.vanilla-2.6.25-mm1/mm/mmap.c	2008-04-28 11:36:52.000000000 +0100
+++ linux-2.6.25-mm1/mm/mmap.c	2008-04-30 11:17:03.000000000 +0100
@@ -80,7 +80,7 @@
 int sysctl_overcommit_memory = OVERCOMMIT_GUESS;  /* heuristic overcommit */
 int sysctl_overcommit_ratio = 50;	/* default is 50% */
 int sysctl_max_map_count __read_mostly = DEFAULT_MAX_MAP_COUNT;
-atomic_t vm_committed_space = ATOMIC_INIT(0);
+vm_atomic_t vm_committed_space = ATOMIC_INIT(0);
 
 /*
  * Check that a process has enough memory to allocate a new virtual
@@ -177,7 +177,7 @@
 	 * cast `allowed' as a signed long because vm_committed_space
 	 * sometimes has a negative value
 	 */
-	if (atomic_read(&vm_committed_space) < (long)allowed)
+	if (vm_atomic_read(&vm_committed_space) < (long)allowed)
 		return 0;
 error:
 	vm_unacct_memory(pages);
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-mm1/mm/swap.c linux-2.6.25-mm1/mm/swap.c
--- linux.vanilla-2.6.25-mm1/mm/swap.c	2008-04-28 11:36:52.000000000 +0100
+++ linux-2.6.25-mm1/mm/swap.c	2008-04-30 11:18:05.000000000 +0100
@@ -503,7 +503,7 @@
 	local = &__get_cpu_var(committed_space);
 	*local += pages;
 	if (*local > ACCT_THRESHOLD || *local < -ACCT_THRESHOLD) {
-		atomic_add(*local, &vm_committed_space);
+		vm_atomic_add(*local, &vm_committed_space);
 		*local = 0;
 	}
 	preempt_enable();
