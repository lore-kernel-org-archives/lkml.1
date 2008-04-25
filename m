Return-Path: <linux-kernel-owner+w=401wt.eu-S1761168AbYDYSGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761168AbYDYSGv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 14:06:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764729AbYDYR5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 13:57:36 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:53144 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764351AbYDYR5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 13:57:24 -0400
Date: Fri, 25 Apr 2008 13:56:13 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [PATCH 12/19] UML - Fix build when SLOB is enabled
Message-ID: <20080425175613.GA11194@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reintroduce uml_kmalloc for the benefit of UML libc code.  The
previous tactic of declaring __kmalloc so it could be called directly
from the libc side of the house turned out to be getting too intimate
with slab, and it doesn't work with slob.

So, the uml_kmalloc wrapper is back.  It calls kmalloc or whatever
that translates into, and libc code calls it.

kfree is left alone since that still works, leaving a somewhat
inconsistent API.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/drivers/chan_user.c              |    1 +
 arch/um/drivers/cow_sys.h                |    2 +-
 arch/um/drivers/daemon_user.c            |    4 ++--
 arch/um/drivers/fd.c                     |    2 +-
 arch/um/drivers/mcast_user.c             |    3 ++-
 arch/um/drivers/net_user.c               |    2 +-
 arch/um/drivers/port_user.c              |    2 +-
 arch/um/drivers/pty.c                    |    2 +-
 arch/um/drivers/slip_user.c              |    2 +-
 arch/um/drivers/tty.c                    |    2 +-
 arch/um/drivers/xterm.c                  |    2 +-
 arch/um/include/um_malloc.h              |    9 +++------
 arch/um/kernel/mem.c                     |    5 +++++
 arch/um/os-Linux/drivers/ethertap_user.c |    4 ++--
 arch/um/os-Linux/helper.c                |    4 ++--
 arch/um/os-Linux/main.c                  |    2 +-
 arch/um/os-Linux/sigio.c                 |    4 ++--
 17 files changed, 28 insertions(+), 24 deletions(-)

Index: linux-2.6-git/arch/um/drivers/chan_user.c
===================================================================
--- linux-2.6-git.orig/arch/um/drivers/chan_user.c	2008-04-25 10:42:12.000000000 -0400
+++ linux-2.6-git/arch/um/drivers/chan_user.c	2008-04-25 11:20:31.000000000 -0400
@@ -11,6 +11,7 @@
 #include <termios.h>
 #include <sys/ioctl.h>
 #include "chan_user.h"
+#include "kern_constants.h"
 #include "os.h"
 #include "um_malloc.h"
 #include "user.h"
Index: linux-2.6-git/arch/um/drivers/cow_sys.h
===================================================================
--- linux-2.6-git.orig/arch/um/drivers/cow_sys.h	2008-04-25 10:42:12.000000000 -0400
+++ linux-2.6-git/arch/um/drivers/cow_sys.h	2008-04-25 11:20:31.000000000 -0400
@@ -8,7 +8,7 @@
 
 static inline void *cow_malloc(int size)
 {
-	return kmalloc(size, UM_GFP_KERNEL);
+	return uml_kmalloc(size, UM_GFP_KERNEL);
 }
 
 static inline void cow_free(void *ptr)
Index: linux-2.6-git/arch/um/drivers/daemon_user.c
===================================================================
--- linux-2.6-git.orig/arch/um/drivers/daemon_user.c	2008-04-25 10:42:12.000000000 -0400
+++ linux-2.6-git/arch/um/drivers/daemon_user.c	2008-04-25 11:20:31.000000000 -0400
@@ -34,7 +34,7 @@ static struct sockaddr_un *new_addr(void
 {
 	struct sockaddr_un *sun;
 
-	sun = kmalloc(sizeof(struct sockaddr_un), UM_GFP_KERNEL);
+	sun = uml_kmalloc(sizeof(struct sockaddr_un), UM_GFP_KERNEL);
 	if (sun == NULL) {
 		printk(UM_KERN_ERR "new_addr: allocation of sockaddr_un "
 		       "failed\n");
@@ -83,7 +83,7 @@ static int connect_to_switch(struct daem
 		goto out_close;
 	}
 
-	sun = kmalloc(sizeof(struct sockaddr_un), UM_GFP_KERNEL);
+	sun = uml_kmalloc(sizeof(struct sockaddr_un), UM_GFP_KERNEL);
 	if (sun == NULL) {
 		printk(UM_KERN_ERR "new_addr: allocation of sockaddr_un "
 		       "failed\n");
Index: linux-2.6-git/arch/um/drivers/fd.c
===================================================================
--- linux-2.6-git.orig/arch/um/drivers/fd.c	2008-04-25 10:42:12.000000000 -0400
+++ linux-2.6-git/arch/um/drivers/fd.c	2008-04-25 11:20:31.000000000 -0400
@@ -40,7 +40,7 @@ static void *fd_init(char *str, int devi
 		return NULL;
 	}
 
-	data = kmalloc(sizeof(*data), UM_GFP_KERNEL);
+	data = uml_kmalloc(sizeof(*data), UM_GFP_KERNEL);
 	if (data == NULL)
 		return NULL;
 
Index: linux-2.6-git/arch/um/drivers/mcast_user.c
===================================================================
--- linux-2.6-git.orig/arch/um/drivers/mcast_user.c	2008-04-25 10:42:12.000000000 -0400
+++ linux-2.6-git/arch/um/drivers/mcast_user.c	2008-04-25 11:20:31.000000000 -0400
@@ -15,6 +15,7 @@
 #include <unistd.h>
 #include <errno.h>
 #include <netinet/in.h>
+#include "kern_constants.h"
 #include "mcast.h"
 #include "net_user.h"
 #include "um_malloc.h"
@@ -24,7 +25,7 @@ static struct sockaddr_in *new_addr(char
 {
 	struct sockaddr_in *sin;
 
-	sin = kmalloc(sizeof(struct sockaddr_in), UM_GFP_KERNEL);
+	sin = uml_kmalloc(sizeof(struct sockaddr_in), UM_GFP_KERNEL);
 	if (sin == NULL) {
 		printk(UM_KERN_ERR "new_addr: allocation of sockaddr_in "
 		       "failed\n");
Index: linux-2.6-git/arch/um/drivers/net_user.c
===================================================================
--- linux-2.6-git.orig/arch/um/drivers/net_user.c	2008-04-25 10:42:12.000000000 -0400
+++ linux-2.6-git/arch/um/drivers/net_user.c	2008-04-25 11:20:31.000000000 -0400
@@ -222,7 +222,7 @@ static void change(char *dev, char *what
 		netmask[2], netmask[3]);
 
 	output_len = UM_KERN_PAGE_SIZE;
-	output = kmalloc(output_len, UM_GFP_KERNEL);
+	output = uml_kmalloc(output_len, UM_GFP_KERNEL);
 	if (output == NULL)
 		printk(UM_KERN_ERR "change : failed to allocate output "
 		       "buffer\n");
Index: linux-2.6-git/arch/um/drivers/port_user.c
===================================================================
--- linux-2.6-git.orig/arch/um/drivers/port_user.c	2008-04-25 10:42:12.000000000 -0400
+++ linux-2.6-git/arch/um/drivers/port_user.c	2008-04-25 11:20:31.000000000 -0400
@@ -47,7 +47,7 @@ static void *port_init(char *str, int de
 	if (kern_data == NULL)
 		return NULL;
 
-	data = kmalloc(sizeof(*data), UM_GFP_KERNEL);
+	data = uml_kmalloc(sizeof(*data), UM_GFP_KERNEL);
 	if (data == NULL)
 		goto err;
 
Index: linux-2.6-git/arch/um/drivers/pty.c
===================================================================
--- linux-2.6-git.orig/arch/um/drivers/pty.c	2008-04-25 10:42:12.000000000 -0400
+++ linux-2.6-git/arch/um/drivers/pty.c	2008-04-25 11:20:31.000000000 -0400
@@ -29,7 +29,7 @@ static void *pty_chan_init(char *str, in
 {
 	struct pty_chan *data;
 
-	data = kmalloc(sizeof(*data), UM_GFP_KERNEL);
+	data = uml_kmalloc(sizeof(*data), UM_GFP_KERNEL);
 	if (data == NULL)
 		return NULL;
 
Index: linux-2.6-git/arch/um/drivers/slip_user.c
===================================================================
--- linux-2.6-git.orig/arch/um/drivers/slip_user.c	2008-04-25 10:42:12.000000000 -0400
+++ linux-2.6-git/arch/um/drivers/slip_user.c	2008-04-25 11:20:31.000000000 -0400
@@ -96,7 +96,7 @@ static int slip_tramp(char **argv, int f
 	pid = err;
 
 	output_len = UM_KERN_PAGE_SIZE;
-	output = kmalloc(output_len, UM_GFP_KERNEL);
+	output = uml_kmalloc(output_len, UM_GFP_KERNEL);
 	if (output == NULL) {
 		printk(UM_KERN_ERR "slip_tramp : failed to allocate output "
 		       "buffer\n");
Index: linux-2.6-git/arch/um/drivers/tty.c
===================================================================
--- linux-2.6-git.orig/arch/um/drivers/tty.c	2008-04-25 10:42:12.000000000 -0400
+++ linux-2.6-git/arch/um/drivers/tty.c	2008-04-25 11:20:31.000000000 -0400
@@ -29,7 +29,7 @@ static void *tty_chan_init(char *str, in
 	}
 	str++;
 
-	data = kmalloc(sizeof(*data), UM_GFP_KERNEL);
+	data = uml_kmalloc(sizeof(*data), UM_GFP_KERNEL);
 	if (data == NULL)
 		return NULL;
 	*data = ((struct tty_chan) { .dev 	= str,
Index: linux-2.6-git/arch/um/drivers/xterm.c
===================================================================
--- linux-2.6-git.orig/arch/um/drivers/xterm.c	2008-04-25 10:42:12.000000000 -0400
+++ linux-2.6-git/arch/um/drivers/xterm.c	2008-04-25 11:20:31.000000000 -0400
@@ -30,7 +30,7 @@ static void *xterm_init(char *str, int d
 {
 	struct xterm_chan *data;
 
-	data = kmalloc(sizeof(*data), UM_GFP_KERNEL);
+	data = uml_kmalloc(sizeof(*data), UM_GFP_KERNEL);
 	if (data == NULL)
 		return NULL;
 	*data = ((struct xterm_chan) { .pid 		= -1,
Index: linux-2.6-git/arch/um/include/um_malloc.h
===================================================================
--- linux-2.6-git.orig/arch/um/include/um_malloc.h	2008-04-25 10:42:12.000000000 -0400
+++ linux-2.6-git/arch/um/include/um_malloc.h	2008-04-25 11:20:31.000000000 -0400
@@ -8,15 +8,12 @@
 
 #include "kern_constants.h"
 
-extern void *__kmalloc(int size, int flags);
-static inline void *kmalloc(int size, int flags)
-{
-	return __kmalloc(size, flags);
-}
-
+extern void *uml_kmalloc(int size, int flags);
 extern void kfree(const void *ptr);
 
 extern void *vmalloc(unsigned long size);
 extern void vfree(void *ptr);
 
 #endif /* __UM_MALLOC_H__ */
+
+
Index: linux-2.6-git/arch/um/kernel/mem.c
===================================================================
--- linux-2.6-git.orig/arch/um/kernel/mem.c	2008-04-25 10:42:12.000000000 -0400
+++ linux-2.6-git/arch/um/kernel/mem.c	2008-04-25 11:20:31.000000000 -0400
@@ -375,3 +375,8 @@ pmd_t *pmd_alloc_one(struct mm_struct *m
 	return pmd;
 }
 #endif
+
+void *uml_kmalloc(int size, int flags)
+{
+	return kmalloc(size, flags);
+}
Index: linux-2.6-git/arch/um/os-Linux/drivers/ethertap_user.c
===================================================================
--- linux-2.6-git.orig/arch/um/os-Linux/drivers/ethertap_user.c	2008-04-25 10:42:12.000000000 -0400
+++ linux-2.6-git/arch/um/os-Linux/drivers/ethertap_user.c	2008-04-25 11:20:31.000000000 -0400
@@ -52,7 +52,7 @@ static void etap_change(int op, unsigned
 		return;
 	}
 
-	output = kmalloc(UM_KERN_PAGE_SIZE, UM_GFP_KERNEL);
+	output = uml_kmalloc(UM_KERN_PAGE_SIZE, UM_GFP_KERNEL);
 	if (output == NULL)
 		printk(UM_KERN_ERR "etap_change : Failed to allocate output "
 		       "buffer\n");
@@ -165,7 +165,7 @@ static int etap_open(void *data)
 	err = etap_tramp(pri->dev_name, pri->gate_addr, control_fds[0],
 			 control_fds[1], data_fds[0], data_fds[1]);
 	output_len = UM_KERN_PAGE_SIZE;
-	output = kmalloc(output_len, UM_GFP_KERNEL);
+	output = uml_kmalloc(output_len, UM_GFP_KERNEL);
 	read_output(control_fds[0], output, output_len);
 
 	if (output == NULL)
Index: linux-2.6-git/arch/um/os-Linux/helper.c
===================================================================
--- linux-2.6-git.orig/arch/um/os-Linux/helper.c	2008-04-25 10:42:12.000000000 -0400
+++ linux-2.6-git/arch/um/os-Linux/helper.c	2008-04-25 11:20:31.000000000 -0400
@@ -70,8 +70,8 @@ int run_helper(void (*pre_exec)(void *),
 	data.pre_data = pre_data;
 	data.argv = argv;
 	data.fd = fds[1];
-	data.buf = __cant_sleep() ? kmalloc(PATH_MAX, UM_GFP_ATOMIC) :
-					kmalloc(PATH_MAX, UM_GFP_KERNEL);
+	data.buf = __cant_sleep() ? uml_kmalloc(PATH_MAX, UM_GFP_ATOMIC) :
+					uml_kmalloc(PATH_MAX, UM_GFP_KERNEL);
 	pid = clone(helper_child, (void *) sp, CLONE_VM, &data);
 	if (pid < 0) {
 		ret = -errno;
Index: linux-2.6-git/arch/um/os-Linux/main.c
===================================================================
--- linux-2.6-git.orig/arch/um/os-Linux/main.c	2008-04-25 10:42:12.000000000 -0400
+++ linux-2.6-git/arch/um/os-Linux/main.c	2008-04-25 11:20:31.000000000 -0400
@@ -199,7 +199,7 @@ void *__wrap_malloc(int size)
 		return __real_malloc(size);
 	else if (size <= UM_KERN_PAGE_SIZE)
 		/* finding contiguous pages can be hard*/
-		ret = kmalloc(size, UM_GFP_KERNEL);
+		ret = uml_kmalloc(size, UM_GFP_KERNEL);
 	else ret = vmalloc(size);
 
 	/*
Index: linux-2.6-git/arch/um/os-Linux/sigio.c
===================================================================
--- linux-2.6-git.orig/arch/um/os-Linux/sigio.c	2008-04-25 11:19:11.000000000 -0400
+++ linux-2.6-git/arch/um/os-Linux/sigio.c	2008-04-25 11:20:31.000000000 -0400
@@ -110,7 +110,7 @@ static int need_poll(struct pollfds *pol
 	if (n <= polls->size)
 		return 0;
 
-	new = kmalloc(n * sizeof(struct pollfd), UM_GFP_ATOMIC);
+	new = uml_kmalloc(n * sizeof(struct pollfd), UM_GFP_ATOMIC);
 	if (new == NULL) {
 		printk(UM_KERN_ERR "need_poll : failed to allocate new "
 		       "pollfds\n");
@@ -244,7 +244,7 @@ static struct pollfd *setup_initial_poll
 {
 	struct pollfd *p;
 
-	p = kmalloc(sizeof(struct pollfd), UM_GFP_KERNEL);
+	p = uml_kmalloc(sizeof(struct pollfd), UM_GFP_KERNEL);
 	if (p == NULL) {
 		printk(UM_KERN_ERR "setup_initial_poll : failed to allocate "
 		       "poll\n");
