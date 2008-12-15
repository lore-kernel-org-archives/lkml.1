Return-Path: <linux-kernel-owner+w=401wt.eu-S1752626AbYLOAbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626AbYLOAbb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 19:31:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751612AbYLOAbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 19:31:21 -0500
Received: from ozlabs.org ([203.10.76.45]:46621 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751606AbYLOAbU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 19:31:20 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: lguest@ozlabs.org
Subject: Re: [Lguest] lguest, virtio_blk, id is not a head!
Date: Mon, 15 Dec 2008 11:01:08 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: Andre Grueneberg <list.lguest@grueneberg.de>, linux-kernel@vger.kernel.org
References: <20081212194728.GE29143@leela.home.grueneberg.de>
In-Reply-To: <20081212194728.GE29143@leela.home.grueneberg.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812151101.08670.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 13 December 2008 06:17:28 Andre Grueneberg wrote:
> Lately I upgraded my host and guest from kernel 2.6.25 (Debian) to
> vanilla 2.6.27.8. I have two virtual machines and in both I recognised
> the same issue after a while.
> 
> After running for some hours the first guest showed the following
> message on the console:
> virtio_blk virtio1: id 1 is not a head!

Hi Andre,

   This is interesting.  There hasn't been a great deal of change between
those versions on the lguest side.  This sounds like a race, and the only
thing I can see which would have introduced this is the change below.

You can apply this with patch -R (a bit of fuzz, but should be fine), then
see if the problem goes away?

Thanks,
Rusty.

commit 8c79873da0d2bedf4ad6b868c54e426bb0a2fe38
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Tue Jul 29 09:58:38 2008 -0500

    lguest: turn Waker into a thread, not a process
    
    lguest uses a Waker process to break it out of the kernel (ie.
    actually running the guest) when file descriptor needs attention.
    
    Changing this from a process to a thread somewhat simplifies things:
    it can directly access the fd_set of things to watch.  More
    importantly, it means that the Waker can see Guest memory correctly,
    so /dev/vring file descriptors will work as anticipated (the
    alternative is to actually mmap MAP_SHARED, but you can't do that with
    /dev/zero).
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/Documentation/lguest/lguest.c b/Documentation/lguest/lguest.c
index f9bba2d..b88b0ea 100644
--- a/Documentation/lguest/lguest.c
+++ b/Documentation/lguest/lguest.c
@@ -76,8 +76,12 @@ static bool verbose;
 	do { if (verbose) printf(args); } while(0)
 /*:*/
 
-/* The pipe to send commands to the waker process */
-static int waker_fd;
+/* File descriptors for the Waker. */
+struct {
+	int pipe[2];
+	int lguest_fd;
+} waker_fds;
+
 /* The pointer to the start of guest memory. */
 static void *guest_base;
 /* The maximum guest physical address allowed, and maximum possible. */
@@ -579,69 +583,64 @@ static void add_device_fd(int fd)
  * watch, but handing a file descriptor mask through to the kernel is fairly
  * icky.
  *
- * Instead, we fork off a process which watches the file descriptors and writes
+ * Instead, we clone off a thread which watches the file descriptors and writes
  * the LHREQ_BREAK command to the /dev/lguest file descriptor to tell the Host
  * stop running the Guest.  This causes the Launcher to return from the
  * /dev/lguest read with -EAGAIN, where it will write to /dev/lguest to reset
  * the LHREQ_BREAK and wake us up again.
  *
  * This, of course, is merely a different *kind* of icky.
+ *
+ * Given my well-known antipathy to threads, I'd prefer to use processes.  But
+ * it's easier to share Guest memory with threads, and trivial to share the
+ * devices.infds as the Launcher changes it.
  */
-static void wake_parent(int pipefd, int lguest_fd)
+static int waker(void *unused)
 {
-	/* Add the pipe from the Launcher to the fdset in the device_list, so
-	 * we watch it, too. */
-	add_device_fd(pipefd);
+	/* Close the write end of the pipe: only the Launcher has it open. */
+	close(waker_fds.pipe[1]);
 
 	for (;;) {
 		fd_set rfds = devices.infds;
 		unsigned long args[] = { LHREQ_BREAK, 1 };
+		unsigned int maxfd = devices.max_infd;
+
+		/* We also listen to the pipe from the Launcher. */
+		FD_SET(waker_fds.pipe[0], &rfds);
+		if (waker_fds.pipe[0] > maxfd)
+			maxfd = waker_fds.pipe[0];
 
 		/* Wait until input is ready from one of the devices. */
-		select(devices.max_infd+1, &rfds, NULL, NULL, NULL);
-		/* Is it a message from the Launcher? */
-		if (FD_ISSET(pipefd, &rfds)) {
-			int fd;
-			/* If read() returns 0, it means the Launcher has
-			 * exited.  We silently follow. */
-			if (read(pipefd, &fd, sizeof(fd)) == 0)
-				exit(0);
-			/* Otherwise it's telling us to change what file
-			 * descriptors we're to listen to.  Positive means
-			 * listen to a new one, negative means stop
-			 * listening. */
-			if (fd >= 0)
-				FD_SET(fd, &devices.infds);
-			else
-				FD_CLR(-fd - 1, &devices.infds);
-		} else /* Send LHREQ_BREAK command. */
-			pwrite(lguest_fd, args, sizeof(args), cpu_id);
+		select(maxfd+1, &rfds, NULL, NULL, NULL);
+
+		/* Message from Launcher? */
+		if (FD_ISSET(waker_fds.pipe[0], &rfds)) {
+			char c;
+			/* If this fails, then assume Launcher has exited.
+			 * Don't do anything on exit: we're just a thread! */
+			if (read(waker_fds.pipe[0], &c, 1) != 1)
+				_exit(0);
+			continue;
+		}
+
+		/* Send LHREQ_BREAK command to snap the Launcher out of it. */
+		pwrite(waker_fds.lguest_fd, args, sizeof(args), cpu_id);
 	}
+	return 0;
 }
 
 /* This routine just sets up a pipe to the Waker process. */
-static int setup_waker(int lguest_fd)
-{
-	int pipefd[2], child;
-
-	/* We create a pipe to talk to the Waker, and also so it knows when the
-	 * Launcher dies (and closes pipe). */
-	pipe(pipefd);
-	child = fork();
-	if (child == -1)
-		err(1, "forking");
-
-	if (child == 0) {
-		/* We are the Waker: close the "writing" end of our copy of the
-		 * pipe and start waiting for input. */
-		close(pipefd[1]);
-		wake_parent(pipefd[0], lguest_fd);
-	}
-	/* Close the reading end of our copy of the pipe. */
-	close(pipefd[0]);
+static void setup_waker(int lguest_fd)
+{
+	/* This pipe is closed when Launcher dies, telling Waker. */
+	if (pipe(waker_fds.pipe) != 0)
+		err(1, "Creating pipe for Waker");
 
-	/* Here is the fd used to talk to the waker. */
-	return pipefd[1];
+	/* Waker also needs to know the lguest fd */
+	waker_fds.lguest_fd = lguest_fd;
+
+	if (clone(waker, malloc(4096) + 4096, CLONE_VM | SIGCHLD, NULL) == -1)
+		err(1, "Creating Waker");
 }
 
 /*
@@ -863,8 +862,8 @@ static bool handle_console_input(int fd, struct device *dev)
 				unsigned long args[] = { LHREQ_BREAK, 0 };
 				/* Close the fd so Waker will know it has to
 				 * exit. */
-				close(waker_fd);
-				/* Just in case waker is blocked in BREAK, send
+				close(waker_fds.pipe[1]);
+				/* Just in case Waker is blocked in BREAK, send
 				 * unbreak now. */
 				write(fd, args, sizeof(args));
 				exit(2);
@@ -996,8 +995,8 @@ static bool handle_tun_input(int fd, struct device *dev)
 static void enable_fd(int fd, struct virtqueue *vq, bool timeout)
 {
 	add_device_fd(vq->dev->fd);
-	/* Tell waker to listen to it again */
-	write(waker_fd, &vq->dev->fd, sizeof(vq->dev->fd));
+	/* Snap the Waker out of its select loop. */
+	write(waker_fds.pipe[1], "", 1);
 }
 
 static void net_enable_fd(int fd, struct virtqueue *vq, bool timeout)
@@ -1134,7 +1133,6 @@ static void handle_input(int fd)
 		 * descriptors and a method of handling them.  */
 		for (i = devices.dev; i; i = i->next) {
 			if (i->handle_input && FD_ISSET(i->fd, &fds)) {
-				int dev_fd;
 				if (i->handle_input(fd, i))
 					continue;
 
@@ -1144,11 +1142,6 @@ static void handle_input(int fd)
 				 * buffers to deliver into.  Console also uses
 				 * it when it discovers that stdin is closed. */
 				FD_CLR(i->fd, &devices.infds);
-				/* Tell waker to ignore it too, by sending a
-				 * negative fd number (-1, since 0 is a valid
-				 * FD number). */
-				dev_fd = -i->fd - 1;
-				write(waker_fd, &dev_fd, sizeof(dev_fd));
 			}
 		}
 
@@ -1880,11 +1873,12 @@ static void __attribute__((noreturn)) restart_guest(void)
 {
 	unsigned int i;
 
-	/* Closing pipes causes the Waker thread and io_threads to die, and
-	 * closing /dev/lguest cleans up the Guest.  Since we don't track all
-	 * open fds, we simply close everything beyond stderr. */
+	/* Since we don't track all open fds, we simply close everything beyond
+	 * stderr. */
 	for (i = 3; i < FD_SETSIZE; i++)
 		close(i);
+
+	/* The exec automatically gets rid of the I/O and Waker threads. */
 	execv(main_args[0], main_args);
 	err(1, "Could not exec %s", main_args[0]);
 }
@@ -2085,10 +2079,10 @@ int main(int argc, char *argv[])
 	 * /dev/lguest file descriptor. */
 	lguest_fd = tell_kernel(pgdir, start);
 
-	/* We fork off a child process, which wakes the Launcher whenever one
-	 * of the input file descriptors needs attention.  We call this the
-	 * Waker, and we'll cover it in a moment. */
-	waker_fd = setup_waker(lguest_fd);
+	/* We clone off a thread, which wakes the Launcher whenever one of the
+	 * input file descriptors needs attention.  We call this the Waker, and
+	 * we'll cover it in a moment. */
+	setup_waker(lguest_fd);
 
 	/* Finally, run the Guest.  This doesn't return. */
 	run_guest(lguest_fd);
