Return-Path: <linux-kernel-owner+w=401wt.eu-S1758177AbYD3Kcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758177AbYD3Kcw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 06:32:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755750AbYD3Kcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 06:32:42 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:58603 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753350AbYD3Kcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 06:32:42 -0400
Date: Wed, 30 Apr 2008 11:24:53 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sami Farin <safari-kernel@safari.iki.fi>
Cc: Linux kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.24.4+mmap with overcommit >= 1
Message-ID: <20080430112453.406b243a@core>
In-Reply-To: <20080430011953.c5ftilonkabvwmkp@m.safari.iki.fi>
References: <20080430011953.c5ftilonkabvwmkp@m.safari.iki.fi>
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

On Wed, 30 Apr 2008 04:19:54 +0300
Sami Farin <safari-kernel@safari.iki.fi> wrote:

> I have arch x86_64, glibc-2.7.90-7 from Fedora.
> When I have vm.overcommit_memory == 1 or 2,
> mmap succeeds for really huge values.
> These ranges succeed (approximate):
>  8793870000000 - 17500387000000
> 26390387000000 - 35180387000000

Fun fun fun

This should fix strict overcommit (== 2) I think


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
