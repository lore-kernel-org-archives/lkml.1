Return-Path: <linux-kernel-owner+w=401wt.eu-S1752249AbXCEXJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249AbXCEXJl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 18:09:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752254AbXCEXJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 18:09:41 -0500
Received: from mbox.ssc.unict.it ([151.97.230.9]:47502 "EHLO ssc.unict.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752249AbXCEXJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 18:09:39 -0500
From: "Paolo 'Blaisorblade' Giarrusso" <blaisorblade@yahoo.it>
Subject: [PATCH 1/2] uml: make sigio_lock() irq-safe
Date: Tue, 06 Mar 2007 00:08:51 +0100
To: Jeff Dike <jdike@addtoit.com>
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
Message-Id: <20070305230851.30695.26417.stgit@americanbeauty.home.lan>
Content-Type: text/plain; charset=utf-8; format=fixed
User-Agent: StGIT/0.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by alpha.home.local id l25NB8ZJ009151

From: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>

sigio_lock is taken both from process context and from interrupt context. So we
*must* use irqsave.

Then, remove irq disabling from update_thread(), as it's called with
sigio_lock() held (yes, set_signals(0) is local_irq_save).

In fact, I've seen this causing frequent hangs with spinlock debugging enabled
(I've verified well that the cause was an interrupt causing re-acquiring of
this lock); however, now it's causing hangs as interrupt disabling causes
some sleep-inside-spinlock checks to trigger - and then printk deadlocks.

I've tested this for a long time and it is stable.
I've also verified that nothing can sleep within this lock; to this purpose,
I've had to verify everything inside um_request_irq; since it calls again
write_sigio_workaround(), I've had to make atomic the allocation inside
setup_initial_poll.

HOWEVER, request_irq() can sleep, and in write_sigio_irq() thanks to
IRQF_SAMPLE_RANDOM it _does_ sleep. So a separate patch makes write_sigio_irq()
be called outside of sigio_lock().

Actually, I'm also quite dubious that an interrupt caused by other interrupts is
a reliable entropy source, but that is another thing completely.

Signed-off-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
---

 arch/um/include/sigio.h  |    4 ++--
 arch/um/kernel/sigio.c   |   12 ++++++++----
 arch/um/os-Linux/sigio.c |   36 ++++++++++++++++++++----------------
 3 files changed, 30 insertions(+), 22 deletions(-)

diff --git a/arch/um/include/sigio.h b/arch/um/include/sigio.h
index 434f1a9..a58bc1d 100644
--- a/arch/um/include/sigio.h
+++ b/arch/um/include/sigio.h
@@ -8,7 +8,7 @@
 
 extern int write_sigio_irq(int fd);
 extern int register_sigio_fd(int fd);
-extern void sigio_lock(void);
-extern void sigio_unlock(void);
+extern unsigned long sigio_lock(void);
+extern void sigio_unlock(unsigned long flags);
 
 #endif
diff --git a/arch/um/kernel/sigio.c b/arch/um/kernel/sigio.c
index 89f9866..cc54db7 100644
--- a/arch/um/kernel/sigio.c
+++ b/arch/um/kernel/sigio.c
@@ -45,12 +45,16 @@ int write_sigio_irq(int fd)
 /* These are called from os-Linux/sigio.c to protect its pollfds arrays. */
 static DEFINE_SPINLOCK(sigio_spinlock);
 
-void sigio_lock(void)
+unsigned long sigio_lock(void)
 {
-	spin_lock(&sigio_spinlock);
+	unsigned long flags;
+
+	spin_lock_irqsave(&sigio_spinlock, flags);
+
+	return flags;
 }
 
-void sigio_unlock(void)
+void sigio_unlock(unsigned long flags)
 {
-	spin_unlock(&sigio_spinlock);
+	spin_unlock_irqrestore(&sigio_spinlock, flags);
 }
diff --git a/arch/um/os-Linux/sigio.c b/arch/um/os-Linux/sigio.c
index 3fc43b3..88988fb 100644
--- a/arch/um/os-Linux/sigio.c
+++ b/arch/um/os-Linux/sigio.c
@@ -21,6 +21,10 @@
 #include "os.h"
 #include "um_malloc.h"
 
+/* Nothing in this file can sleep. I've verified each and every function. The
+ * only "exception" is write_sigio_thread, which runs in a host thread, so it
+ * has no chance of sleeping. */
+
 /* Protected by sigio_lock(), also used by sigio_cleanup, which is an
  * exitcall.
  */
@@ -121,11 +125,9 @@ static int need_poll(struct pollfds *polls, int n)
  */
 static void update_thread(void)
 {
-	unsigned long flags;
 	int n;
 	char c;
 
-	flags = set_signals(0);
 	n = os_write_file(sigio_private[0], &c, sizeof(c));
 	if(n != sizeof(c)){
 		printk("update_thread : write failed, err = %d\n", -n);
@@ -138,7 +140,6 @@ static void update_thread(void)
 		goto fail;
 	}
 
-	set_signals(flags);
 	return;
  fail:
 	/* Critical section start */
@@ -150,15 +151,15 @@ static void update_thread(void)
 	close(write_sigio_fds[0]);
 	close(write_sigio_fds[1]);
 	/* Critical section end */
-	set_signals(flags);
 }
 
 int add_sigio_fd(int fd)
 {
 	struct pollfd *p;
 	int err = 0, i, n;
+	unsigned long flags;
 
-	sigio_lock();
+	flags = sigio_lock();
 	for(i = 0; i < all_sigio_fds.used; i++){
 		if(all_sigio_fds.poll[i].fd == fd)
 			break;
@@ -184,7 +185,7 @@ int add_sigio_fd(int fd)
 	next_poll.used = n + 1;
 	update_thread();
  out:
-	sigio_unlock();
+	sigio_unlock(flags);
 	return err;
 }
 
@@ -192,6 +193,7 @@ int ignore_sigio_fd(int fd)
 {
 	struct pollfd *p;
 	int err = 0, i, n = 0;
+	unsigned long flags;
 
 	/* This is called from exitcalls elsewhere in UML - if
 	 * sigio_cleanup has already run, then update_thread will hang
@@ -200,7 +202,7 @@ int ignore_sigio_fd(int fd)
 	if(write_sigio_pid == -1)
 		return -EIO;
 
-	sigio_lock();
+	flags = sigio_lock();
 	for(i = 0; i < current_poll.used; i++){
 		if(current_poll.poll[i].fd == fd) break;
 	}
@@ -220,7 +222,7 @@ int ignore_sigio_fd(int fd)
 
 	update_thread();
  out:
-	sigio_unlock();
+	sigio_unlock(flags);
 	return err;
 }
 
@@ -228,7 +230,7 @@ static struct pollfd *setup_initial_poll(int fd)
 {
 	struct pollfd *p;
 
-	p = um_kmalloc(sizeof(struct pollfd));
+	p = um_kmalloc_atomic(sizeof(struct pollfd));
 	if (p == NULL) {
 		printk("setup_initial_poll : failed to allocate poll\n");
 		return NULL;
@@ -247,11 +249,12 @@ static void write_sigio_workaround(void)
 	int l_write_sigio_fds[2];
 	int l_sigio_private[2];
 	int l_write_sigio_pid;
+	unsigned long flags;
 
 	/* We call this *tons* of times - and most ones we must just fail. */
-	sigio_lock();
+	flags = sigio_lock();
 	l_write_sigio_pid = write_sigio_pid;
-	sigio_unlock();
+	sigio_unlock(flags);
 
 	if (l_write_sigio_pid != -1)
 		return;
@@ -273,7 +276,7 @@ static void write_sigio_workaround(void)
 	if(!p)
 		goto out_close2;
 
-	sigio_lock();
+	flags = sigio_lock();
 
 	/* Did we race? Don't try to optimize this, please, it's not so likely
 	 * to happen, and no more than once at the boot. */
@@ -296,7 +299,7 @@ static void write_sigio_workaround(void)
 	if (write_sigio_pid < 0)
 		goto out_clear;
 
-	sigio_unlock();
+	sigio_unlock(flags);
 	return;
 
 out_clear:
@@ -310,7 +313,7 @@ out_clear_poll:
 					   .size	= 0,
 					   .used	= 0 });
 out_free:
-	sigio_unlock();
+	sigio_unlock(flags);
 	kfree(p);
 out_close2:
 	close(l_sigio_private[0]);
@@ -323,6 +326,7 @@ out_close1:
 void maybe_sigio_broken(int fd, int read)
 {
 	int err;
+	unsigned long flags;
 
 	if(!isatty(fd))
 		return;
@@ -332,7 +336,7 @@ void maybe_sigio_broken(int fd, int read)
 
 	write_sigio_workaround();
 
-	sigio_lock();
+	flags = sigio_lock();
 	err = need_poll(&all_sigio_fds, all_sigio_fds.used + 1);
 	if(err){
 		printk("maybe_sigio_broken - failed to add pollfd for "
@@ -345,7 +349,7 @@ void maybe_sigio_broken(int fd, int read)
 				   .events 	= read ? POLLIN : POLLOUT,
 				   .revents 	= 0 });
 out:
-	sigio_unlock();
+	sigio_unlock(flags);
 }
 
 static void sigio_cleanup(void)


