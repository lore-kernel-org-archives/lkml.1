Return-Path: <linux-kernel-owner+w=401wt.eu-S1756983AbXFNU1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756983AbXFNU1u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 16:27:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753567AbXFNU1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 16:27:13 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:34104 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008AbXFNU1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 16:27:08 -0400
Date: Thu, 14 Jun 2007 16:26:51 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 5/5] UML - Eliminate kernel allocator wrappers
Message-ID: <20070614202651.GA9652@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

UML had two wrapper procedures for kmalloc, um_kmalloc and
um_kmalloc_atomic because the flag constants weren't available in
userspace code.  kern_constants.h had made kernel constants available
for a long time, so there is no need for these wrappers any more.
Rather, userspace code calls kmalloc directly with the userspace
versions of the gfp flags.

kmalloc isn't a real procedure, so I had to essentially copy the
inline wrapper around __kmalloc.

vmalloc also had its own wrapper for no good reason.  This is now gone.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/drivers/cow_sys.h                |    2 +-
 arch/um/drivers/daemon_user.c            |    4 ++--
 arch/um/drivers/fd.c                     |    2 +-
 arch/um/drivers/mcast_user.c             |    2 +-
 arch/um/drivers/net_user.c               |    2 +-
 arch/um/drivers/port_user.c              |    2 +-
 arch/um/drivers/pty.c                    |    2 +-
 arch/um/drivers/slip_user.c              |    2 +-
 arch/um/drivers/tty.c                    |    2 +-
 arch/um/include/common-offsets.h         |    3 +++
 arch/um/include/um_malloc.h              |   12 +++++++++---
 arch/um/kernel/irq.c                     |    1 -
 arch/um/kernel/process.c                 |   16 ----------------
 arch/um/os-Linux/drivers/ethertap_user.c |    4 ++--
 arch/um/os-Linux/helper.c                |    4 ++--
 arch/um/os-Linux/main.c                  |    4 ++--
 arch/um/os-Linux/sigio.c                 |    4 ++--
 17 files changed, 30 insertions(+), 38 deletions(-)

Index: linux-2.6.21-mm/arch/um/drivers/cow_sys.h
===================================================================
--- linux-2.6.21-mm.orig/arch/um/drivers/cow_sys.h	2007-06-14 15:33:34.000000000 -0400
+++ linux-2.6.21-mm/arch/um/drivers/cow_sys.h	2007-06-14 16:08:07.000000000 -0400
@@ -8,7 +8,7 @@
 
 static inline void *cow_malloc(int size)
 {
-	return um_kmalloc(size);
+	return kmalloc(size, UM_GFP_KERNEL);
 }
 
 static inline void cow_free(void *ptr)
Index: linux-2.6.21-mm/arch/um/drivers/daemon_user.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/drivers/daemon_user.c	2007-06-14 15:33:34.000000000 -0400
+++ linux-2.6.21-mm/arch/um/drivers/daemon_user.c	2007-06-14 16:08:07.000000000 -0400
@@ -35,7 +35,7 @@ static struct sockaddr_un *new_addr(void
 {
 	struct sockaddr_un *sun;
 
-	sun = um_kmalloc(sizeof(struct sockaddr_un));
+	sun = kmalloc(sizeof(struct sockaddr_un), UM_GFP_KERNEL);
 	if(sun == NULL){
 		printk("new_addr: allocation of sockaddr_un failed\n");
 		return NULL;
@@ -83,7 +83,7 @@ static int connect_to_switch(struct daem
 		goto out_close;
 	}
 
-	sun = um_kmalloc(sizeof(struct sockaddr_un));
+	sun = kmalloc(sizeof(struct sockaddr_un), UM_GFP_KERNEL);
 	if(sun == NULL){
 		printk("new_addr: allocation of sockaddr_un failed\n");
 		err = -ENOMEM;
Index: linux-2.6.21-mm/arch/um/drivers/fd.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/drivers/fd.c	2007-06-14 15:33:34.000000000 -0400
+++ linux-2.6.21-mm/arch/um/drivers/fd.c	2007-06-14 16:08:07.000000000 -0400
@@ -37,7 +37,7 @@ static void *fd_init(char *str, int devi
 		printk("fd_init : couldn't parse file descriptor '%s'\n", str);
 		return(NULL);
 	}
-	data = um_kmalloc(sizeof(*data));
+	data = kmalloc(sizeof(*data), UM_GFP_KERNEL);
 	if(data == NULL) return(NULL);
 	*data = ((struct fd_chan) { .fd  	= n,
 				    .raw  	= opts->raw });
Index: linux-2.6.21-mm/arch/um/drivers/mcast_user.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/drivers/mcast_user.c	2007-06-14 15:33:34.000000000 -0400
+++ linux-2.6.21-mm/arch/um/drivers/mcast_user.c	2007-06-14 16:08:07.000000000 -0400
@@ -30,7 +30,7 @@ static struct sockaddr_in *new_addr(char
 {
 	struct sockaddr_in *sin;
 
-	sin = um_kmalloc(sizeof(struct sockaddr_in));
+	sin = kmalloc(sizeof(struct sockaddr_in), UM_GFP_KERNEL);
 	if(sin == NULL){
 		printk("new_addr: allocation of sockaddr_in failed\n");
 		return NULL;
Index: linux-2.6.21-mm/arch/um/drivers/net_user.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/drivers/net_user.c	2007-06-14 16:07:30.000000000 -0400
+++ linux-2.6.21-mm/arch/um/drivers/net_user.c	2007-06-14 16:08:07.000000000 -0400
@@ -217,7 +217,7 @@ static void change(char *dev, char *what
 		netmask[2], netmask[3]);
 
 	output_len = UM_KERN_PAGE_SIZE;
-	output = um_kmalloc(output_len);
+	output = kmalloc(output_len, UM_GFP_KERNEL);
 	if(output == NULL)
 		printk("change : failed to allocate output buffer\n");
 
Index: linux-2.6.21-mm/arch/um/drivers/pty.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/drivers/pty.c	2007-06-14 15:35:13.000000000 -0400
+++ linux-2.6.21-mm/arch/um/drivers/pty.c	2007-06-14 16:08:07.000000000 -0400
@@ -29,7 +29,7 @@ static void *pty_chan_init(char *str, in
 {
 	struct pty_chan *data;
 
-	data = um_kmalloc(sizeof(*data));
+	data = kmalloc(sizeof(*data), UM_GFP_KERNEL);
 	if (data == NULL)
 		return NULL;
 
Index: linux-2.6.21-mm/arch/um/drivers/slip_user.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/drivers/slip_user.c	2007-06-14 16:07:30.000000000 -0400
+++ linux-2.6.21-mm/arch/um/drivers/slip_user.c	2007-06-14 16:08:07.000000000 -0400
@@ -91,7 +91,7 @@ static int slip_tramp(char **argv, int f
 	pid = err;
 
 	output_len = UM_KERN_PAGE_SIZE;
-	output = um_kmalloc(output_len);
+	output = kmalloc(output_len, UM_GFP_KERNEL);
 	if(output == NULL){
 		printk("slip_tramp : failed to allocate output buffer\n");
 		os_kill_process(pid, 1);
Index: linux-2.6.21-mm/arch/um/drivers/tty.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/drivers/tty.c	2007-06-14 15:33:34.000000000 -0400
+++ linux-2.6.21-mm/arch/um/drivers/tty.c	2007-06-14 16:08:07.000000000 -0400
@@ -29,7 +29,7 @@ static void *tty_chan_init(char *str, in
 	}
 	str++;
 
-	data = um_kmalloc(sizeof(*data));
+	data = kmalloc(sizeof(*data), UM_GFP_KERNEL);
 	if(data == NULL)
 		return NULL;
 	*data = ((struct tty_chan) { .dev 	= str,
Index: linux-2.6.21-mm/arch/um/include/common-offsets.h
===================================================================
--- linux-2.6.21-mm.orig/arch/um/include/common-offsets.h	2007-06-14 16:00:19.000000000 -0400
+++ linux-2.6.21-mm/arch/um/include/common-offsets.h	2007-06-14 16:08:07.000000000 -0400
@@ -27,6 +27,9 @@ DEFINE(UM_ELFCLASS64, ELFCLASS64);
 
 DEFINE(UM_NR_CPUS, NR_CPUS);
 
+DEFINE(UM_GFP_KERNEL, GFP_KERNEL);
+DEFINE(UM_GFP_ATOMIC, GFP_ATOMIC);
+
 /* For crypto assembler code. */
 DEFINE(crypto_tfm_ctx_offset, offsetof(struct crypto_tfm, __crt_ctx));
 
Index: linux-2.6.21-mm/arch/um/include/um_malloc.h
===================================================================
--- linux-2.6.21-mm.orig/arch/um/include/um_malloc.h	2007-06-14 15:33:34.000000000 -0400
+++ linux-2.6.21-mm/arch/um/include/um_malloc.h	2007-06-14 16:08:07.000000000 -0400
@@ -6,11 +6,17 @@
 #ifndef __UM_MALLOC_H__
 #define __UM_MALLOC_H__
 
-extern void *um_kmalloc(int size);
-extern void *um_kmalloc_atomic(int size);
+#include "kern_constants.h"
+
+extern void *__kmalloc(int size, int flags);
+static inline void *kmalloc(int size, int flags)
+{
+	return __kmalloc(size, flags);
+}
+
 extern void kfree(const void *ptr);
 
-extern void *um_vmalloc(int size);
+extern void *vmalloc(unsigned long size);
 extern void vfree(void *ptr);
 
 #endif /* __UM_MALLOC_H__ */
Index: linux-2.6.21-mm/arch/um/kernel/irq.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/irq.c	2007-06-14 15:33:34.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/irq.c	2007-06-14 16:08:07.000000000 -0400
@@ -30,7 +30,6 @@
 #include "irq_kern.h"
 #include "os.h"
 #include "sigio.h"
-#include "um_malloc.h"
 #include "misc_constants.h"
 #include "as-layout.h"
 
Index: linux-2.6.21-mm/arch/um/kernel/process.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/process.c	2007-06-14 15:33:34.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/process.c	2007-06-14 16:08:07.000000000 -0400
@@ -46,7 +46,6 @@
 #include "mode.h"
 #include "mode_kern.h"
 #include "choose-mode.h"
-#include "um_malloc.h"
 
 /* This is a per-cpu array.  A processor only modifies its entry and it only
  * cares about its entry, so it's OK if another processor is modifying its
@@ -262,21 +261,6 @@ void dump_thread(struct pt_regs *regs, s
 {
 }
 
-void *um_kmalloc(int size)
-{
-	return kmalloc(size, GFP_KERNEL);
-}
-
-void *um_kmalloc_atomic(int size)
-{
-	return kmalloc(size, GFP_ATOMIC);
-}
-
-void *um_vmalloc(int size)
-{
-	return vmalloc(size);
-}
-
 int __cant_sleep(void) {
 	return in_atomic() || irqs_disabled() || in_interrupt();
 	/* Is in_interrupt() really needed? */
Index: linux-2.6.21-mm/arch/um/os-Linux/drivers/ethertap_user.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/os-Linux/drivers/ethertap_user.c	2007-06-14 16:07:30.000000000 -0400
+++ linux-2.6.21-mm/arch/um/os-Linux/drivers/ethertap_user.c	2007-06-14 16:08:07.000000000 -0400
@@ -54,7 +54,7 @@ static void etap_change(int op, unsigned
 		return;
 	}
 
-	output = um_kmalloc(UM_KERN_PAGE_SIZE);
+	output = kmalloc(UM_KERN_PAGE_SIZE, UM_GFP_KERNEL);
 	if(output == NULL)
 		printk("etap_change : Failed to allocate output buffer\n");
 	read_output(fd, output, UM_KERN_PAGE_SIZE);
@@ -166,7 +166,7 @@ static int etap_open(void *data)
 	err = etap_tramp(pri->dev_name, pri->gate_addr, control_fds[0], 
 			 control_fds[1], data_fds[0], data_fds[1]);
 	output_len = UM_KERN_PAGE_SIZE;
-	output = um_kmalloc(output_len);
+	output = kmalloc(output_len, UM_GFP_KERNEL);
 	read_output(control_fds[0], output, output_len);
 
 	if(output == NULL)
Index: linux-2.6.21-mm/arch/um/os-Linux/helper.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/os-Linux/helper.c	2007-06-14 16:07:30.000000000 -0400
+++ linux-2.6.21-mm/arch/um/os-Linux/helper.c	2007-06-14 16:08:07.000000000 -0400
@@ -72,8 +72,8 @@ int run_helper(void (*pre_exec)(void *),
 	data.pre_data = pre_data;
 	data.argv = argv;
 	data.fd = fds[1];
-	data.buf = __cant_sleep() ? um_kmalloc_atomic(PATH_MAX) :
-					um_kmalloc(PATH_MAX);
+	data.buf = __cant_sleep() ? kmalloc(PATH_MAX, UM_GFP_ATOMIC) :
+					kmalloc(PATH_MAX, UM_GFP_KERNEL);
 	pid = clone(helper_child, (void *) sp, CLONE_VM | SIGCHLD, &data);
 	if (pid < 0) {
 		ret = -errno;
Index: linux-2.6.21-mm/arch/um/os-Linux/main.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/os-Linux/main.c	2007-06-14 16:00:19.000000000 -0400
+++ linux-2.6.21-mm/arch/um/os-Linux/main.c	2007-06-14 16:08:07.000000000 -0400
@@ -235,8 +235,8 @@ void *__wrap_malloc(int size)
 		return __real_malloc(size);
 	else if(size <= UM_KERN_PAGE_SIZE)
 		/* finding contiguous pages can be hard*/
-		ret = um_kmalloc(size);
-	else ret = um_vmalloc(size);
+		ret = kmalloc(size, UM_GFP_KERNEL);
+	else ret = vmalloc(size);
 
 	/* glibc people insist that if malloc fails, errno should be
 	 * set by malloc as well. So we do.
Index: linux-2.6.21-mm/arch/um/os-Linux/sigio.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/os-Linux/sigio.c	2007-06-14 16:07:30.000000000 -0400
+++ linux-2.6.21-mm/arch/um/os-Linux/sigio.c	2007-06-14 16:08:07.000000000 -0400
@@ -105,7 +105,7 @@ static int need_poll(struct pollfds *pol
 	if(n <= polls->size)
 		return 0;
 
-	new = um_kmalloc_atomic(n * sizeof(struct pollfd));
+	new = kmalloc(n * sizeof(struct pollfd), UM_GFP_ATOMIC);
 	if(new == NULL){
 		printk("need_poll : failed to allocate new pollfds\n");
 		return -ENOMEM;
@@ -233,7 +233,7 @@ static struct pollfd *setup_initial_poll
 {
 	struct pollfd *p;
 
-	p = um_kmalloc(sizeof(struct pollfd));
+	p = kmalloc(sizeof(struct pollfd), UM_GFP_KERNEL);
 	if (p == NULL) {
 		printk("setup_initial_poll : failed to allocate poll\n");
 		return NULL;
Index: linux-2.6.21-mm/arch/um/drivers/port_user.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/drivers/port_user.c	2007-06-14 16:07:30.000000000 -0400
+++ linux-2.6.21-mm/arch/um/drivers/port_user.c	2007-06-14 16:08:07.000000000 -0400
@@ -50,7 +50,7 @@ static void *port_init(char *str, int de
 	if(kern_data == NULL)
 		return NULL;
 
-	data = um_kmalloc(sizeof(*data));
+	data = kmalloc(sizeof(*data), UM_GFP_KERNEL);
 	if(data == NULL)
 		goto err;
 
