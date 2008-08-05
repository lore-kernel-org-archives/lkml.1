Return-Path: <linux-kernel-owner+w=401wt.eu-S1764430AbYHEURf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764430AbYHEURf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 16:17:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763613AbYHEUOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 16:14:36 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:48081 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763588AbYHEUOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 16:14:34 -0400
Date: Tue, 5 Aug 2008 16:14:03 -0400
From: Jeff Dike <jdike@addtoit.com>
To: stable@kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 1/14] uml: fix build when SLOB is enabled
Message-ID: <20080805201403.GA11778@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 43f5b3085fdd27c4edf535d938b2cb0ccead4f75

Reintroduce uml_kmalloc for the benefit of UML libc code.  The
previous tactic of declaring __kmalloc so it could be called directly
from the libc side of the house turned out to be getting too intimate
with slab, and it doesn't work with slob.

So, the uml_kmalloc wrapper is back.  It calls kmalloc or whatever
that translates into, and libc code calls it.

kfree is left alone since that still works, leaving a somewhat
inconsistent API.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
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

diff --git a/arch/um/drivers/chan_user.c b/arch/um/drivers/chan_user.c
index 0257640..cfeb3f4 100644
--- a/arch/um/drivers/chan_user.c
+++ b/arch/um/drivers/chan_user.c
@@ -11,6 +11,7 @@
 #include <termios.h>
 #include <sys/ioctl.h>
 #include "chan_user.h"
+#include "kern_constants.h"
 #include "os.h"
 #include "um_malloc.h"
 #include "user.h"
diff --git a/arch/um/drivers/cow_sys.h b/arch/um/drivers/cow_sys.h
index ca8c9e1..f5701fd 100644
--- a/arch/um/drivers/cow_sys.h
+++ b/arch/um/drivers/cow_sys.h
@@ -8,7 +8,7 @@
 
 static inline void *cow_malloc(int size)
 {
-	return kmalloc(size, UM_GFP_KERNEL);
+	return uml_kmalloc(size, UM_GFP_KERNEL);
 }
 
 static inline void cow_free(void *ptr)
diff --git a/arch/um/drivers/daemon_user.c b/arch/um/drivers/daemon_user.c
index f23c109..f8e85e0 100644
--- a/arch/um/drivers/daemon_user.c
+++ b/arch/um/drivers/daemon_user.c
@@ -34,7 +34,7 @@ static struct sockaddr_un *new_addr(void *name, int len)
 {
 	struct sockaddr_un *sun;
 
-	sun = kmalloc(sizeof(struct sockaddr_un), UM_GFP_KERNEL);
+	sun = uml_kmalloc(sizeof(struct sockaddr_un), UM_GFP_KERNEL);
 	if (sun == NULL) {
 		printk(UM_KERN_ERR "new_addr: allocation of sockaddr_un "
 		       "failed\n");
@@ -83,7 +83,7 @@ static int connect_to_switch(struct daemon_data *pri)
 		goto out_close;
 	}
 
-	sun = kmalloc(sizeof(struct sockaddr_un), UM_GFP_KERNEL);
+	sun = uml_kmalloc(sizeof(struct sockaddr_un), UM_GFP_KERNEL);
 	if (sun == NULL) {
 		printk(UM_KERN_ERR "new_addr: allocation of sockaddr_un "
 		       "failed\n");
diff --git a/arch/um/drivers/fd.c b/arch/um/drivers/fd.c
index 0a2bb5b..f5a981a 100644
--- a/arch/um/drivers/fd.c
+++ b/arch/um/drivers/fd.c
@@ -40,7 +40,7 @@ static void *fd_init(char *str, int device, const struct chan_opts *opts)
 		return NULL;
 	}
 
-	data = kmalloc(sizeof(*data), UM_GFP_KERNEL);
+	data = uml_kmalloc(sizeof(*data), UM_GFP_KERNEL);
 	if (data == NULL)
 		return NULL;
 
diff --git a/arch/um/drivers/mcast_user.c b/arch/um/drivers/mcast_user.c
index 5f647d7..ee19e91 100644
--- a/arch/um/drivers/mcast_user.c
+++ b/arch/um/drivers/mcast_user.c
@@ -15,6 +15,7 @@
 #include <unistd.h>
 #include <errno.h>
 #include <netinet/in.h>
+#include "kern_constants.h"
 #include "mcast.h"
 #include "net_user.h"
 #include "um_malloc.h"
@@ -24,7 +25,7 @@ static struct sockaddr_in *new_addr(char *addr, unsigned short port)
 {
 	struct sockaddr_in *sin;
 
-	sin = kmalloc(sizeof(struct sockaddr_in), UM_GFP_KERNEL);
+	sin = uml_kmalloc(sizeof(struct sockaddr_in), UM_GFP_KERNEL);
 	if (sin == NULL) {
 		printk(UM_KERN_ERR "new_addr: allocation of sockaddr_in "
 		       "failed\n");
diff --git a/arch/um/drivers/net_user.c b/arch/um/drivers/net_user.c
index abf2653..9415dd9 100644
--- a/arch/um/drivers/net_user.c
+++ b/arch/um/drivers/net_user.c
@@ -222,7 +222,7 @@ static void change(char *dev, char *what, unsigned char *addr,
 		netmask[2], netmask[3]);
 
 	output_len = UM_KERN_PAGE_SIZE;
-	output = kmalloc(output_len, UM_GFP_KERNEL);
+	output = uml_kmalloc(output_len, UM_GFP_KERNEL);
 	if (output == NULL)
 		printk(UM_KERN_ERR "change : failed to allocate output "
 		       "buffer\n");
diff --git a/arch/um/drivers/port_user.c b/arch/um/drivers/port_user.c
index addd759..8a191f1 100644
--- a/arch/um/drivers/port_user.c
+++ b/arch/um/drivers/port_user.c
@@ -47,7 +47,7 @@ static void *port_init(char *str, int device, const struct chan_opts *opts)
 	if (kern_data == NULL)
 		return NULL;
 
-	data = kmalloc(sizeof(*data), UM_GFP_KERNEL);
+	data = uml_kmalloc(sizeof(*data), UM_GFP_KERNEL);
 	if (data == NULL)
 		goto err;
 
diff --git a/arch/um/drivers/pty.c b/arch/um/drivers/pty.c
index 49c79dd..1113911 100644
--- a/arch/um/drivers/pty.c
+++ b/arch/um/drivers/pty.c
@@ -29,7 +29,7 @@ static void *pty_chan_init(char *str, int device, const struct chan_opts *opts)
 {
 	struct pty_chan *data;
 
-	data = kmalloc(sizeof(*data), UM_GFP_KERNEL);
+	data = uml_kmalloc(sizeof(*data), UM_GFP_KERNEL);
 	if (data == NULL)
 		return NULL;
 
diff --git a/arch/um/drivers/slip_user.c b/arch/um/drivers/slip_user.c
index 8b80505..a1c2d2c 100644
--- a/arch/um/drivers/slip_user.c
+++ b/arch/um/drivers/slip_user.c
@@ -96,7 +96,7 @@ static int slip_tramp(char **argv, int fd)
 	pid = err;
 
 	output_len = UM_KERN_PAGE_SIZE;
-	output = kmalloc(output_len, UM_GFP_KERNEL);
+	output = uml_kmalloc(output_len, UM_GFP_KERNEL);
 	if (output == NULL) {
 		printk(UM_KERN_ERR "slip_tramp : failed to allocate output "
 		       "buffer\n");
diff --git a/arch/um/drivers/tty.c b/arch/um/drivers/tty.c
index c930fed..495858a 100644
--- a/arch/um/drivers/tty.c
+++ b/arch/um/drivers/tty.c
@@ -29,7 +29,7 @@ static void *tty_chan_init(char *str, int device, const struct chan_opts *opts)
 	}
 	str++;
 
-	data = kmalloc(sizeof(*data), UM_GFP_KERNEL);
+	data = uml_kmalloc(sizeof(*data), UM_GFP_KERNEL);
 	if (data == NULL)
 		return NULL;
 	*data = ((struct tty_chan) { .dev 	= str,
diff --git a/arch/um/drivers/xterm.c b/arch/um/drivers/xterm.c
index 8a1c18a..da2caa5 100644
--- a/arch/um/drivers/xterm.c
+++ b/arch/um/drivers/xterm.c
@@ -30,7 +30,7 @@ static void *xterm_init(char *str, int device, const struct chan_opts *opts)
 {
 	struct xterm_chan *data;
 
-	data = kmalloc(sizeof(*data), UM_GFP_KERNEL);
+	data = uml_kmalloc(sizeof(*data), UM_GFP_KERNEL);
 	if (data == NULL)
 		return NULL;
 	*data = ((struct xterm_chan) { .pid 		= -1,
diff --git a/arch/um/include/um_malloc.h b/arch/um/include/um_malloc.h
index 0ad17cb..c554d70 100644
--- a/arch/um/include/um_malloc.h
+++ b/arch/um/include/um_malloc.h
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
diff --git a/arch/um/kernel/mem.c b/arch/um/kernel/mem.c
index 2eea1ff..b0ee646 100644
--- a/arch/um/kernel/mem.c
+++ b/arch/um/kernel/mem.c
@@ -375,3 +375,8 @@ pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address)
 	return pmd;
 }
 #endif
+
+void *uml_kmalloc(int size, int flags)
+{
+	return kmalloc(size, flags);
+}
diff --git a/arch/um/os-Linux/drivers/ethertap_user.c b/arch/um/os-Linux/drivers/ethertap_user.c
index 6fb0b17..cc72cb2 100644
--- a/arch/um/os-Linux/drivers/ethertap_user.c
+++ b/arch/um/os-Linux/drivers/ethertap_user.c
@@ -52,7 +52,7 @@ static void etap_change(int op, unsigned char *addr, unsigned char *netmask,
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
diff --git a/arch/um/os-Linux/helper.c b/arch/um/os-Linux/helper.c
index f4bd349..679acce 100644
--- a/arch/um/os-Linux/helper.c
+++ b/arch/um/os-Linux/helper.c
@@ -70,8 +70,8 @@ int run_helper(void (*pre_exec)(void *), void *pre_data, char **argv)
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
diff --git a/arch/um/os-Linux/main.c b/arch/um/os-Linux/main.c
index abb9b0f..eee69b9 100644
--- a/arch/um/os-Linux/main.c
+++ b/arch/um/os-Linux/main.c
@@ -199,7 +199,7 @@ void *__wrap_malloc(int size)
 		return __real_malloc(size);
 	else if (size <= UM_KERN_PAGE_SIZE)
 		/* finding contiguous pages can be hard*/
-		ret = kmalloc(size, UM_GFP_KERNEL);
+		ret = uml_kmalloc(size, UM_GFP_KERNEL);
 	else ret = vmalloc(size);
 
 	/*
diff --git a/arch/um/os-Linux/sigio.c b/arch/um/os-Linux/sigio.c
index abf47a7..0578481 100644
--- a/arch/um/os-Linux/sigio.c
+++ b/arch/um/os-Linux/sigio.c
@@ -109,7 +109,7 @@ static int need_poll(struct pollfds *polls, int n)
 	if (n <= polls->size)
 		return 0;
 
-	new = kmalloc(n * sizeof(struct pollfd), UM_GFP_ATOMIC);
+	new = uml_kmalloc(n * sizeof(struct pollfd), UM_GFP_ATOMIC);
 	if (new == NULL) {
 		printk(UM_KERN_ERR "need_poll : failed to allocate new "
 		       "pollfds\n");
@@ -243,7 +243,7 @@ static struct pollfd *setup_initial_poll(int fd)
 {
 	struct pollfd *p;
 
-	p = kmalloc(sizeof(struct pollfd), UM_GFP_KERNEL);
+	p = uml_kmalloc(sizeof(struct pollfd), UM_GFP_KERNEL);
 	if (p == NULL) {
 		printk(UM_KERN_ERR "setup_initial_poll : failed to allocate "
 		       "poll\n");
-- 
1.5.5.1
