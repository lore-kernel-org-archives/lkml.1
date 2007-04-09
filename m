Return-Path: <linux-kernel-owner+w=401wt.eu-S1753324AbXDISUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324AbXDISUR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 14:20:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753370AbXDISUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 14:20:13 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:38300 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875AbXDISTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 14:19:50 -0400
Date: Mon, 9 Apr 2007 14:14:41 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 2/4] UML - Start fixing os_read_file and os_write_file
Message-ID: <20070409181441.GA7267@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch starts the removal of a very old, very broken piece of
code.  This stems from the problem of passing a userspace buffer into
read() or write() on the host.  If that buffer had not yet been faulted
in, read and write will return -EFAULT.

To avoid this problem, the solution was to fault the buffer in before
the system call by touching the pages that hold the buffer by doing a
copy-user of a byte to each page.  This is obviously bogus, but it
does usually work, in tt mode, since the kernel and process are in the
same address space and userspace addresses can be accessed directly in
the kernel.

In skas mode, where the kernel and process are in separate address
spaces, it is completely bogus because the userspace address, which is
invalid in the kernel, is passed into the system call instead of the
corresponding physical address, which would be valid.  Here, it
appears that this code, on every host read() or write(), tries to
fault in a random process page.  This doesn't seem to cause any
correctness problems, but there is a performance impact.  This patch,
and the ones following, result in a 10-15% performance gain on a
kernel build.

This code can't be immediately tossed out because when it is, you
can't log in.  Apparently, there is some code in the console driver
which depends on this somehow.

However, we can start removing it by switching the code which does I/O
using kernel addresses to using plain read() and write().  This patch
introduces os_read_file_k and os_write_file_k for use with kernel
buffers and converts all call locations which use obvious kernel
buffers to use them.  These include I/O using buffers which are local
variables which are on the stack or kmalloc-ed.  Later patches will
handle the less obvious cases, followed by a mass conversion back to
the original interface.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/drivers/chan_user.c       |   10 +++++-----
 arch/um/drivers/daemon_user.c     |    4 ++--
 arch/um/drivers/harddog_user.c    |    4 ++--
 arch/um/drivers/hostaudio_kern.c  |    4 ++--
 arch/um/drivers/net_user.c        |    2 +-
 arch/um/drivers/port_kern.c       |    2 +-
 arch/um/drivers/random.c          |    2 +-
 arch/um/drivers/ubd_kern.c        |   17 ++++++++---------
 arch/um/include/os.h              |    2 ++
 arch/um/kernel/ksyms.c            |    2 ++
 arch/um/kernel/physmem.c          |    2 +-
 arch/um/kernel/sigio.c            |    2 +-
 arch/um/kernel/smp.c              |   12 ++++++------
 arch/um/kernel/tt/process_kern.c  |    7 ++++---
 arch/um/kernel/tt/ptproxy/proxy.c |    9 +++++----
 arch/um/kernel/tt/tracer.c        |    2 +-
 arch/um/os-Linux/file.c           |   10 ++++++++++
 arch/um/sys-i386/bugs.c           |    2 +-
 arch/um/sys-i386/ldt.c            |    2 +-
 19 files changed, 56 insertions(+), 41 deletions(-)

Index: linux-2.6.21-mm/arch/um/drivers/ubd_kern.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/drivers/ubd_kern.c	2007-04-09 13:03:08.000000000 -0400
+++ linux-2.6.21-mm/arch/um/drivers/ubd_kern.c	2007-04-09 13:10:41.000000000 -0400
@@ -504,7 +504,7 @@ static void ubd_handler(void)
 	struct ubd *dev;
 	int n;
 
-	n = os_read_file(thread_fd, &req, sizeof(req));
+	n = os_read_file_k(thread_fd, &req, sizeof(req));
 	if(n != sizeof(req)){
 		printk(KERN_ERR "Pid %d - spurious interrupt in ubd_handler, "
 		       "err = %d\n", os_getpid(), -n);
@@ -1092,8 +1092,7 @@ static void do_ubd_request(request_queue
 		err = prepare_request(req, &io_req);
 		if(!err){
 			dev->active = 1;
-			n = os_write_file(thread_fd, (char *) &io_req,
-					 sizeof(io_req));
+			n = os_write_file_k(thread_fd, &io_req, sizeof(io_req));
 			if(n != sizeof(io_req))
 				printk("write to io thread failed, "
 				       "errno = %d\n", -n);
@@ -1336,8 +1335,8 @@ static int update_bitmap(struct io_threa
 		return(1);
 	}
 
-	n = os_write_file(req->fds[1], &req->bitmap_words,
-		          sizeof(req->bitmap_words));
+	n = os_write_file_k(req->fds[1], &req->bitmap_words,
+			    sizeof(req->bitmap_words));
 	if(n != sizeof(req->bitmap_words)){
 		printk("do_io - bitmap update failed, err = %d fd = %d\n", -n,
 		       req->fds[1]);
@@ -1381,7 +1380,7 @@ void do_io(struct io_thread_req *req)
 			do {
 				buf = &buf[n];
 				len -= n;
-				n = os_read_file(req->fds[bit], buf, len);
+				n = os_read_file_k(req->fds[bit], buf, len);
 				if (n < 0) {
 					printk("do_io - read failed, err = %d "
 					       "fd = %d\n", -n, req->fds[bit]);
@@ -1391,7 +1390,7 @@ void do_io(struct io_thread_req *req)
 			} while((n < len) && (n != 0));
 			if (n < len) memset(&buf[n], 0, len - n);
 		} else {
-			n = os_write_file(req->fds[bit], buf, len);
+			n = os_write_file_k(req->fds[bit], buf, len);
 			if(n != len){
 				printk("do_io - write failed err = %d "
 				       "fd = %d\n", -n, req->fds[bit]);
@@ -1421,7 +1420,7 @@ int io_thread(void *arg)
 
 	ignore_sigwinch_sig();
 	while(1){
-		n = os_read_file(kernel_fd, &req, sizeof(req));
+		n = os_read_file_k(kernel_fd, &req, sizeof(req));
 		if(n != sizeof(req)){
 			if(n < 0)
 				printk("io_thread - read failed, fd = %d, "
@@ -1434,7 +1433,7 @@ int io_thread(void *arg)
 		}
 		io_count++;
 		do_io(&req);
-		n = os_write_file(kernel_fd, &req, sizeof(req));
+		n = os_write_file_k(kernel_fd, &req, sizeof(req));
 		if(n != sizeof(req))
 			printk("io_thread - write failed, fd = %d, err = %d\n",
 			       kernel_fd, -n);
Index: linux-2.6.21-mm/arch/um/include/os.h
===================================================================
--- linux-2.6.21-mm.orig/arch/um/include/os.h	2007-04-09 13:03:08.000000000 -0400
+++ linux-2.6.21-mm/arch/um/include/os.h	2007-04-09 13:10:41.000000000 -0400
@@ -145,7 +145,9 @@ extern int os_mode_fd(int fd, int mode);
 extern int os_seek_file(int fd, __u64 offset);
 extern int os_open_file(char *file, struct openflags flags, int mode);
 extern int os_read_file(int fd, void *buf, int len);
+extern int os_read_file_k(int fd, void *buf, int len);
 extern int os_write_file(int fd, const void *buf, int count);
+extern int os_write_file_k(int fd, const void *buf, int len);
 extern int os_file_size(char *file, unsigned long long *size_out);
 extern int os_file_modtime(char *file, unsigned long *modtime);
 extern int os_pipe(int *fd, int stream, int close_on_exec);
Index: linux-2.6.21-mm/arch/um/os-Linux/file.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/os-Linux/file.c	2007-04-09 13:03:08.000000000 -0400
+++ linux-2.6.21-mm/arch/um/os-Linux/file.c	2007-04-09 13:16:24.000000000 -0400
@@ -334,12 +334,30 @@ int os_read_file(int fd, void *buf, int 
 		       copy_from_user_proc);
 }
 
+int os_read_file_k(int fd, void *buf, int len)
+{
+	int n = read(fd, buf, len);
+
+	if(n < 0)
+		return -errno;
+	return n;
+}
+
 int os_write_file(int fd, const void *buf, int len)
 {
 	return file_io(fd, (void *) buf, len,
 		       (int (*)(int, void *, int)) write, copy_to_user_proc);
 }
 
+int os_write_file_k(int fd, const void *buf, int len)
+{
+	int n = write(fd, (void *) buf, len);
+
+	if(n < 0)
+		return -errno;
+	return n;
+}
+
 int os_file_size(char *file, unsigned long long *size_out)
 {
 	struct uml_stat buf;
Index: linux-2.6.21-mm/arch/um/drivers/chan_user.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/drivers/chan_user.c	2007-04-09 13:03:08.000000000 -0400
+++ linux-2.6.21-mm/arch/um/drivers/chan_user.c	2007-04-09 13:10:41.000000000 -0400
@@ -85,7 +85,7 @@ static int winch_thread(void *arg)
 
 	pty_fd = data->pty_fd;
 	pipe_fd = data->pipe_fd;
-	count = os_write_file(pipe_fd, &c, sizeof(c));
+	count = os_write_file_k(pipe_fd, &c, sizeof(c));
 	if(count != sizeof(c))
 		printk("winch_thread : failed to write synchronization "
 		       "byte, err = %d\n", -count);
@@ -120,7 +120,7 @@ static int winch_thread(void *arg)
 	 * host - since they are not different kernel threads, we cannot use
 	 * kernel semaphores. We don't use SysV semaphores because they are
 	 * persistent. */
-	count = os_read_file(pipe_fd, &c, sizeof(c));
+	count = os_read_file_k(pipe_fd, &c, sizeof(c));
 	if(count != sizeof(c))
 		printk("winch_thread : failed to read synchronization byte, "
 		       "err = %d\n", -count);
@@ -130,7 +130,7 @@ static int winch_thread(void *arg)
 		 * are blocked.*/
 		sigsuspend(&sigs);
 
-		count = os_write_file(pipe_fd, &c, sizeof(c));
+		count = os_write_file_k(pipe_fd, &c, sizeof(c));
 		if(count != sizeof(c))
 			printk("winch_thread : write failed, err = %d\n",
 			       -count);
@@ -162,7 +162,7 @@ static int winch_tramp(int fd, struct tt
 	}
 
 	*fd_out = fds[0];
-	n = os_read_file(fds[0], &c, sizeof(c));
+	n = os_read_file_k(fds[0], &c, sizeof(c));
 	if(n != sizeof(c)){
 		printk("winch_tramp : failed to read synchronization byte\n");
 		printk("read failed, err = %d\n", -n);
@@ -195,7 +195,7 @@ void register_winch(int fd, struct tty_s
 		if(thread > 0){
 			register_winch_irq(thread_fd, fd, thread, tty);
 
-			count = os_write_file(thread_fd, &c, sizeof(c));
+			count = os_write_file_k(thread_fd, &c, sizeof(c));
 			if(count != sizeof(c))
 				printk("register_winch : failed to write "
 				       "synchronization byte, err = %d\n",
Index: linux-2.6.21-mm/arch/um/drivers/daemon_user.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/drivers/daemon_user.c	2007-04-09 13:03:08.000000000 -0400
+++ linux-2.6.21-mm/arch/um/drivers/daemon_user.c	2007-04-09 13:10:41.000000000 -0400
@@ -94,7 +94,7 @@ static int connect_to_switch(struct daem
 	req.version = SWITCH_VERSION;
 	req.type = REQ_NEW_CONTROL;
 	req.sock = *local_addr;
-	n = os_write_file(pri->control, &req, sizeof(req));
+	n = os_write_file_k(pri->control, &req, sizeof(req));
 	if(n != sizeof(req)){
 		printk("daemon_open : control setup request failed, err = %d\n",
 		       -n);
@@ -102,7 +102,7 @@ static int connect_to_switch(struct daem
 		goto out_free;
 	}
 
-	n = os_read_file(pri->control, sun, sizeof(*sun));
+	n = os_read_file_k(pri->control, sun, sizeof(*sun));
 	if(n != sizeof(*sun)){
 		printk("daemon_open : read of data socket failed, err = %d\n",
 		       -n);
Index: linux-2.6.21-mm/arch/um/drivers/harddog_user.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/drivers/harddog_user.c	2007-04-09 13:03:08.000000000 -0400
+++ linux-2.6.21-mm/arch/um/drivers/harddog_user.c	2007-04-09 13:10:41.000000000 -0400
@@ -79,7 +79,7 @@ int start_watchdog(int *in_fd_ret, int *
 		goto out_close_out;
 	}
 
-	n = os_read_file(in_fds[0], &c, sizeof(c));
+	n = os_read_file_k(in_fds[0], &c, sizeof(c));
 	if(n == 0){
 		printk("harddog_open - EOF on watchdog pipe\n");
 		helper_wait(pid);
@@ -118,7 +118,7 @@ int ping_watchdog(int fd)
 	int n;
 	char c = '\n';
 
-	n = os_write_file(fd, &c, sizeof(c));
+	n = os_write_file_k(fd, &c, sizeof(c));
 	if(n != sizeof(c)){
 		printk("ping_watchdog - write failed, err = %d\n", -n);
 		if(n < 0)
Index: linux-2.6.21-mm/arch/um/drivers/hostaudio_kern.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/drivers/hostaudio_kern.c	2007-04-09 13:03:08.000000000 -0400
+++ linux-2.6.21-mm/arch/um/drivers/hostaudio_kern.c	2007-04-09 13:10:41.000000000 -0400
@@ -84,7 +84,7 @@ static ssize_t hostaudio_read(struct fil
 	if(kbuf == NULL)
 		return(-ENOMEM);
 
-	err = os_read_file(state->fd, kbuf, count);
+	err = os_read_file_k(state->fd, kbuf, count);
 	if(err < 0)
 		goto out;
 
@@ -115,7 +115,7 @@ static ssize_t hostaudio_write(struct fi
 	if(copy_from_user(kbuf, buffer, count))
 		goto out;
 
-	err = os_write_file(state->fd, kbuf, count);
+	err = os_write_file_k(state->fd, kbuf, count);
 	if(err < 0)
 		goto out;
 	*ppos += err;
Index: linux-2.6.21-mm/arch/um/drivers/net_user.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/drivers/net_user.c	2007-04-09 13:03:08.000000000 -0400
+++ linux-2.6.21-mm/arch/um/drivers/net_user.c	2007-04-09 13:10:41.000000000 -0400
@@ -63,7 +63,7 @@ void read_output(int fd, char *output, i
 	}
 		
 	*output = '\0';
-	ret = os_read_file(fd, &remain, sizeof(remain));
+	ret = os_read_file_k(fd, &remain, sizeof(remain));
 
 	if (ret != sizeof(remain)) {
 		expected = sizeof(remain);
Index: linux-2.6.21-mm/arch/um/drivers/port_kern.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/drivers/port_kern.c	2007-04-09 13:03:08.000000000 -0400
+++ linux-2.6.21-mm/arch/um/drivers/port_kern.c	2007-04-09 13:10:41.000000000 -0400
@@ -113,7 +113,7 @@ static int port_accept(struct port_list 
 	}
 
 	if(atomic_read(&port->wait_count) == 0){
-		os_write_file(fd, NO_WAITER_MSG, sizeof(NO_WAITER_MSG));
+		os_write_file_k(fd, NO_WAITER_MSG, sizeof(NO_WAITER_MSG));
 		printk("No one waiting for port\n");
 	}
 	list_add(&conn->list, &port->pending);
Index: linux-2.6.21-mm/arch/um/drivers/random.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/drivers/random.c	2007-04-09 13:03:08.000000000 -0400
+++ linux-2.6.21-mm/arch/um/drivers/random.c	2007-04-09 13:10:41.000000000 -0400
@@ -44,7 +44,7 @@ static ssize_t rng_dev_read (struct file
         int n, ret = 0, have_data;
 
         while(size){
-                n = os_read_file(random_fd, &data, sizeof(data));
+                n = os_read_file_k(random_fd, &data, sizeof(data));
                 if(n > 0){
                         have_data = n;
                         while (have_data && size) {
Index: linux-2.6.21-mm/arch/um/kernel/ksyms.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/ksyms.c	2007-04-09 13:03:08.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/ksyms.c	2007-04-09 13:10:41.000000000 -0400
@@ -62,7 +62,9 @@ EXPORT_SYMBOL(os_get_exec_close);
 EXPORT_SYMBOL(os_set_exec_close);
 EXPORT_SYMBOL(os_getpid);
 EXPORT_SYMBOL(os_open_file);
+EXPORT_SYMBOL(os_read_file_k);
 EXPORT_SYMBOL(os_read_file);
+EXPORT_SYMBOL(os_write_file_k);
 EXPORT_SYMBOL(os_write_file);
 EXPORT_SYMBOL(os_seek_file);
 EXPORT_SYMBOL(os_lock_file);
Index: linux-2.6.21-mm/arch/um/kernel/physmem.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/physmem.c	2007-04-09 13:03:08.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/physmem.c	2007-04-09 13:10:41.000000000 -0400
@@ -341,7 +341,7 @@ void setup_physmem(unsigned long start, 
 	 * from physmem_fd, so it needs to be written out there.
 	 */
 	os_seek_file(physmem_fd, __pa(&__syscall_stub_start));
-	os_write_file(physmem_fd, &__syscall_stub_start, PAGE_SIZE);
+	os_write_file_k(physmem_fd, &__syscall_stub_start, PAGE_SIZE);
 
 	bootmap_size = init_bootmem(pfn, pfn + delta);
 	free_bootmem(__pa(reserve_end) + bootmap_size,
Index: linux-2.6.21-mm/arch/um/kernel/sigio.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/sigio.c	2007-04-09 13:03:08.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/sigio.c	2007-04-09 13:10:41.000000000 -0400
@@ -21,7 +21,7 @@ static irqreturn_t sigio_interrupt(int i
 {
 	char c;
 
-	os_read_file(sigio_irq_fd, &c, sizeof(c));
+	os_read_file_k(sigio_irq_fd, &c, sizeof(c));
 	reactivate_fd(sigio_irq_fd, SIGIO_WRITE_IRQ);
 	return IRQ_HANDLED;
 }
Index: linux-2.6.21-mm/arch/um/kernel/smp.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/smp.c	2007-04-09 13:03:08.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/smp.c	2007-04-09 13:10:41.000000000 -0400
@@ -47,7 +47,7 @@ struct task_struct *idle_threads[NR_CPUS
 
 void smp_send_reschedule(int cpu)
 {
-	os_write_file(cpu_data[cpu].ipi_pipe[1], "R", 1);
+	os_write_file_k(cpu_data[cpu].ipi_pipe[1], "R", 1);
 	num_reschedules_sent++;
 }
 
@@ -59,7 +59,7 @@ void smp_send_stop(void)
 	for(i = 0; i < num_online_cpus(); i++){
 		if(i == current_thread->cpu)
 			continue;
-		os_write_file(cpu_data[i].ipi_pipe[1], "S", 1);
+		os_write_file_k(cpu_data[i].ipi_pipe[1], "S", 1);
 	}
 	printk("done\n");
 }
@@ -108,8 +108,8 @@ static struct task_struct *idle_thread(i
 		          { .pid = 	new_task->thread.mode.tt.extern_pid,
 			    .task = 	new_task } );
 	idle_threads[cpu] = new_task;
-	CHOOSE_MODE(os_write_file(new_task->thread.mode.tt.switch_pipe[1], &c,
-			  sizeof(c)),
+	CHOOSE_MODE(os_write_file_k(new_task->thread.mode.tt.switch_pipe[1], &c,
+				    sizeof(c)),
 		    ({ panic("skas mode doesn't support SMP"); }));
 	return(new_task);
 }
@@ -179,7 +179,7 @@ void IPI_handler(int cpu)
 	int fd;
 
 	fd = cpu_data[cpu].ipi_pipe[0];
-	while (os_read_file(fd, &c, 1) == 1) {
+	while (os_read_file_k(fd, &c, 1) == 1) {
 		switch (c) {
 		case 'C':
 			smp_call_function_slave(cpu);
@@ -239,7 +239,7 @@ int smp_call_function(void (*_func)(void
 	info = _info;
 
 	for_each_online_cpu(i)
-		os_write_file(cpu_data[i].ipi_pipe[1], "C", 1);
+		os_write_file_k(cpu_data[i].ipi_pipe[1], "C", 1);
 
 	while (atomic_read(&scf_started) != cpus)
 		barrier();
Index: linux-2.6.21-mm/arch/um/kernel/tt/process_kern.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/tt/process_kern.c	2007-04-09 13:03:08.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/tt/process_kern.c	2007-04-09 13:10:41.000000000 -0400
@@ -57,14 +57,15 @@ void switch_to_tt(void *prev, void *next
 	 * nor the value in "to" (since it was the task which stole us the CPU,
 	 * which we don't care about). */
 
-	err = os_write_file(to->thread.mode.tt.switch_pipe[1], &c, sizeof(c));
+	err = os_write_file_k(to->thread.mode.tt.switch_pipe[1], &c, sizeof(c));
 	if(err != sizeof(c))
 		panic("write of switch_pipe failed, err = %d", -err);
 
 	if(from->thread.mode.tt.switch_pipe[0] == -1)
 		os_kill_process(os_getpid(), 0);
 
-	err = os_read_file(from->thread.mode.tt.switch_pipe[0], &c, sizeof(c));
+	err = os_read_file_k(from->thread.mode.tt.switch_pipe[0], &c,
+			     sizeof(c));
 	if(err != sizeof(c))
 		panic("read of switch_pipe failed, errno = %d", -err);
 
@@ -113,7 +114,7 @@ void suspend_new_thread(int fd)
 	char c;
 
 	os_stop_process(os_getpid());
-	err = os_read_file(fd, &c, sizeof(c));
+	err = os_read_file_k(fd, &c, sizeof(c));
 	if(err != sizeof(c))
 		panic("read failed in suspend_new_thread, err = %d", -err);
 }
Index: linux-2.6.21-mm/arch/um/kernel/tt/ptproxy/proxy.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/tt/ptproxy/proxy.c	2007-04-09 13:03:08.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/tt/ptproxy/proxy.c	2007-04-09 13:10:41.000000000 -0400
@@ -338,13 +338,14 @@ int start_debugger(char *prog, int start
 			       "err = %d\n", -fd);
 			exit(1);
 		}
-		os_write_file(fd, gdb_init_string, sizeof(gdb_init_string) - 1);
+		os_write_file_k(fd, gdb_init_string,
+				sizeof(gdb_init_string) - 1);
 		if(startup){
 			if(stop){
-				os_write_file(fd, "b start_kernel\n",
-				      strlen("b start_kernel\n"));
+				os_write_file_k(fd, "b start_kernel\n",
+						strlen("b start_kernel\n"));
 			}
-			os_write_file(fd, "c\n", strlen("c\n"));
+			os_write_file_k(fd, "c\n", strlen("c\n"));
 		}
 		if(ptrace(PTRACE_TRACEME, 0, 0, 0) < 0){
 			printk("start_debugger :  PTRACE_TRACEME failed, "
Index: linux-2.6.21-mm/arch/um/kernel/tt/tracer.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/tt/tracer.c	2007-04-09 13:03:08.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/tt/tracer.c	2007-04-09 13:10:41.000000000 -0400
@@ -44,7 +44,7 @@ static void tracer_winch_handler(int sig
 	int n;
 	char c = 1;
 
-	n = os_write_file(tracer_winch[1], &c, sizeof(c));
+	n = os_write_file_k(tracer_winch[1], &c, sizeof(c));
 	if(n != sizeof(c))
 		printk("tracer_winch_handler - write failed, err = %d\n", -n);
 }
Index: linux-2.6.21-mm/arch/um/sys-i386/bugs.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/sys-i386/bugs.c	2007-04-09 13:03:08.000000000 -0400
+++ linux-2.6.21-mm/arch/um/sys-i386/bugs.c	2007-04-09 13:10:41.000000000 -0400
@@ -67,7 +67,7 @@ static int find_cpuinfo_line(int fd, cha
 			return 1;
 
 		do {
-			n = os_read_file(fd, &c, sizeof(c));
+			n = os_read_file_k(fd, &c, sizeof(c));
 			if(n != sizeof(c)){
 				printk("Failed to find newline in "
 				       "/proc/cpuinfo, err = %d\n", -n);
Index: linux-2.6.21-mm/arch/um/sys-i386/ldt.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/sys-i386/ldt.c	2007-04-09 13:03:08.000000000 -0400
+++ linux-2.6.21-mm/arch/um/sys-i386/ldt.c	2007-04-09 13:10:41.000000000 -0400
@@ -517,7 +517,7 @@ long init_new_ldt(struct mmu_context_ska
 					      .u 	=
 					      { .copy_segments =
 							from_mm->id.u.mm_fd } } );
-		i = os_write_file(new_mm->id.u.mm_fd, &copy, sizeof(copy));
+		i = os_write_file_k(new_mm->id.u.mm_fd, &copy, sizeof(copy));
 		if(i != sizeof(copy))
 			printk("new_mm : /proc/mm copy_segments failed, "
 			       "err = %d\n", -i);
