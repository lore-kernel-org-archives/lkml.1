Return-Path: <linux-kernel-owner+w=401wt.eu-S934446AbXGWTeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934446AbXGWTeS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 15:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764623AbXGWTdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 15:33:24 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:36997 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760317AbXGWTdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 15:33:22 -0400
Date: Mon, 23 Jul 2007 15:33:13 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 3/3] UML - More __init annotations
Message-ID: <20070723193313.GA12393@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-rc1 turned up another batch of references from non-__init code
to __init code.  In most cases, these were missing __init
annotations.  In one case (os_drop_memory), the annotation was present
but wrong.

init_maps is __init, but for some reason was being very careful about
the mechanism by which it allocated memory, checking whether it was OK
to use kmalloc (at this point in the boot, it definitely isn't) and
using either alloc_bootmem_low_pages or kmalloc/vmalloc.  So, the
kmalloc/vmalloc code is removed.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/drivers/mconsole_kern.c |    4 ++--
 arch/um/drivers/net_kern.c      |    2 +-
 arch/um/kernel/mem.c            |    2 +-
 arch/um/kernel/physmem.c        |   15 +++++----------
 arch/um/kernel/skas/process.c   |    4 ++--
 arch/um/os-Linux/process.c      |    2 +-
 6 files changed, 12 insertions(+), 17 deletions(-)

Index: linux-2.6.17/arch/um/drivers/mconsole_kern.c
===================================================================
--- linux-2.6.17.orig/arch/um/drivers/mconsole_kern.c	2007-07-23 15:00:21.000000000 -0400
+++ linux-2.6.17/arch/um/drivers/mconsole_kern.c	2007-07-23 15:00:34.000000000 -0400
@@ -499,7 +499,7 @@ static struct mc_device mem_mc = {
 	.remove		= mem_remove,
 };
 
-static int mem_mc_init(void)
+static int __init mem_mc_init(void)
 {
 	if(can_drop_memory())
 		mconsole_register_dev(&mem_mc);
@@ -798,7 +798,7 @@ void mconsole_stack(struct mc_request *r
  */
 static char *notify_socket = NULL;
 
-static int mconsole_init(void)
+static int __init mconsole_init(void)
 {
 	/* long to avoid size mismatch warnings from gcc */
 	long sock;
Index: linux-2.6.17/arch/um/drivers/net_kern.c
===================================================================
--- linux-2.6.17.orig/arch/um/drivers/net_kern.c	2007-07-23 15:00:21.000000000 -0400
+++ linux-2.6.17/arch/um/drivers/net_kern.c	2007-07-23 15:00:34.000000000 -0400
@@ -623,7 +623,7 @@ static int eth_setup_common(char *str, i
 	return found;
 }
 
-static int eth_setup(char *str)
+static int __init eth_setup(char *str)
 {
 	struct eth_init *new;
 	char *error;
Index: linux-2.6.17/arch/um/kernel/mem.c
===================================================================
--- linux-2.6.17.orig/arch/um/kernel/mem.c	2007-07-23 15:00:21.000000000 -0400
+++ linux-2.6.17/arch/um/kernel/mem.c	2007-07-23 15:00:34.000000000 -0400
@@ -62,7 +62,7 @@ static void setup_highmem(unsigned long 
 }
 #endif
 
-void mem_init(void)
+void __init mem_init(void)
 {
 	/* clear the zero-page */
 	memset((void *) empty_zero_page, 0, PAGE_SIZE);
Index: linux-2.6.17/arch/um/kernel/physmem.c
===================================================================
--- linux-2.6.17.orig/arch/um/kernel/physmem.c	2007-07-23 15:00:21.000000000 -0400
+++ linux-2.6.17/arch/um/kernel/physmem.c	2007-07-23 15:00:34.000000000 -0400
@@ -28,7 +28,8 @@ unsigned long high_physmem;
 
 extern unsigned long long physmem_size;
 
-int init_maps(unsigned long physmem, unsigned long iomem, unsigned long highmem)
+int __init init_maps(unsigned long physmem, unsigned long iomem,
+		     unsigned long highmem)
 {
 	struct page *p, *map;
 	unsigned long phys_len, phys_pages, highmem_len, highmem_pages;
@@ -47,13 +48,7 @@ int init_maps(unsigned long physmem, uns
 	total_pages = phys_pages + iomem_pages + highmem_pages;
 	total_len = phys_len + iomem_len + highmem_len;
 
-	if(kmalloc_ok){
-		map = kmalloc(total_len, GFP_KERNEL);
-		if(map == NULL)
-			map = vmalloc(total_len);
-	}
-	else map = alloc_bootmem_low_pages(total_len);
-
+	map = alloc_bootmem_low_pages(total_len);
 	if(map == NULL)
 		return -ENOMEM;
 
@@ -98,8 +93,8 @@ void map_memory(unsigned long virt, unsi
 
 extern int __syscall_stub_start;
 
-void setup_physmem(unsigned long start, unsigned long reserve_end,
-		   unsigned long len, unsigned long long highmem)
+void __init setup_physmem(unsigned long start, unsigned long reserve_end,
+			  unsigned long len, unsigned long long highmem)
 {
 	unsigned long reserve = reserve_end - start;
 	int pfn = PFN_UP(__pa(reserve_end));
Index: linux-2.6.17/arch/um/os-Linux/process.c
===================================================================
--- linux-2.6.17.orig/arch/um/os-Linux/process.c	2007-07-23 15:00:21.000000000 -0400
+++ linux-2.6.17/arch/um/os-Linux/process.c	2007-07-23 15:00:34.000000000 -0400
@@ -194,7 +194,7 @@ int os_unmap_memory(void *addr, int len)
 #define MADV_REMOVE KERNEL_MADV_REMOVE
 #endif
 
-int __init os_drop_memory(void *addr, int length)
+int os_drop_memory(void *addr, int length)
 {
 	int err;
 
Index: linux-2.6.17/arch/um/kernel/skas/process.c
===================================================================
--- linux-2.6.17.orig/arch/um/kernel/skas/process.c	2007-07-23 15:00:21.000000000 -0400
+++ linux-2.6.17/arch/um/kernel/skas/process.c	2007-07-23 15:00:34.000000000 -0400
@@ -145,7 +145,7 @@ void init_idle_skas(void)
 
 extern void start_kernel(void);
 
-static int start_kernel_proc(void *unused)
+static int __init start_kernel_proc(void *unused)
 {
 	int pid;
 
@@ -165,7 +165,7 @@ extern int userspace_pid[];
 
 extern char cpu0_irqstack[];
 
-int start_uml_skas(void)
+int __init start_uml_skas(void)
 {
 	stack_protections((unsigned long) &cpu0_irqstack);
 	set_sigstack(cpu0_irqstack, THREAD_SIZE);
