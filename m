Return-Path: <linux-kernel-owner+w=401wt.eu-S1758761AbXFMOoB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758761AbXFMOoB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 10:44:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758504AbXFMOnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 10:43:35 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:55902 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758179AbXFMOne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 10:43:34 -0400
Date: Wed, 13 Jun 2007 10:42:45 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Eduard-Gabriel Munteanu <maxdamage@aladin.ro>,
       LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 1/2] UML - DEBUG_SHIRQ fixes
Message-ID: <20070613144245.GA5777@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eduard-Gabriel Munteanu <maxdamage@aladin.ro>

DEBUG_SHIRQ generates spurious interrupts, triggering handlers such as
mconsole_interrupt() or line_interrupt(). They expect data to be
available to be read from their sockets/pipes, but in the case of
spurious interrupts, the host didn't actually send anything, so UML  
hangs in read() and friends. Setting those fd's as O_NONBLOCK makes 
DEBUG_SHIRQ-enabled UML kernels boot and run correctly.

The patch was written and tested on Linux 2.6.22-rc2-mm1.

I have also included a couple of short/minor fixes for potential
problems.

Signed-off-by: Eduard-Gabriel Munteanu <maxdamage@aladin.ro>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/drivers/chan_user.c     |    8 +++++++-
 arch/um/drivers/mconsole_user.c |    5 +++--
 arch/um/drivers/ubd_user.c      |    6 ++++++
 arch/um/drivers/xterm.c         |    7 +++++++
 4 files changed, 23 insertions(+), 3 deletions(-)

Index: linux-2.6.21-mm/arch/um/drivers/chan_user.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/drivers/chan_user.c	2007-06-06 09:28:13.000000000 -0400
+++ linux-2.6.21-mm/arch/um/drivers/chan_user.c	2007-06-11 13:51:29.000000000 -0400
@@ -170,7 +170,13 @@ static int winch_tramp(int fd, struct tt
                 err = -EINVAL;
 		goto out_close;
 	}
-	return err ;
+
+	if (os_set_fd_block(*fd_out, 0)) {
+		printk("winch_tramp: failed to set thread_fd non-blocking.\n");
+		goto out_close;
+	}
+
+	return err;
 
  out_close:
 	os_close_file(fds[1]);
Index: linux-2.6.21-mm/arch/um/drivers/mconsole_user.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/drivers/mconsole_user.c	2007-06-06 09:28:13.000000000 -0400
+++ linux-2.6.21-mm/arch/um/drivers/mconsole_user.c	2007-06-11 13:38:19.000000000 -0400
@@ -86,8 +86,9 @@ int mconsole_get_request(int fd, struct 
 	int len;
 
 	req->originlen = sizeof(req->origin);
-	req->len = recvfrom(fd, &req->request, sizeof(req->request), 0,
-			    (struct sockaddr *) req->origin, &req->originlen);
+	req->len = recvfrom(fd, &req->request, sizeof(req->request),
+			    MSG_DONTWAIT, (struct sockaddr *) req->origin,
+			    &req->originlen);
 	if (req->len < 0)
 		return 0;
 
Index: linux-2.6.21-mm/arch/um/drivers/ubd_user.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/drivers/ubd_user.c	2007-06-06 09:28:13.000000000 -0400
+++ linux-2.6.21-mm/arch/um/drivers/ubd_user.c	2007-06-11 13:44:56.000000000 -0400
@@ -43,6 +43,12 @@ int start_io_thread(unsigned long sp, in
 	kernel_fd = fds[0];
 	*fd_out = fds[1];
 
+	err = os_set_fd_block(*fd_out, 0);
+	if (err) {
+		printk("start_io_thread - failed to set nonblocking I/O.\n");
+		goto out_close;
+	}
+
 	pid = clone(io_thread, (void *) sp, CLONE_FILES | CLONE_VM | SIGCHLD,
 		    NULL);
 	if(pid < 0){
Index: linux-2.6.21-mm/arch/um/drivers/xterm.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/drivers/xterm.c	2007-06-06 09:28:13.000000000 -0400
+++ linux-2.6.21-mm/arch/um/drivers/xterm.c	2007-06-12 12:25:44.000000000 -0400
@@ -151,6 +151,13 @@ int xterm_open(int input, int output, in
 		goto out;
 	}
 
+	err = os_set_fd_block(new, 0);
+	if (err) {
+		printk("xterm_open : failed to set xterm descriptor "
+		       "non-blocking, err = %d\n", -err);
+		goto out;
+	}
+
 	CATCH_EINTR(err = tcgetattr(new, &data->tt));
 	if(err){
 		new = err;
