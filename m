Return-Path: <linux-kernel-owner+w=401wt.eu-S1763599AbXFJWVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763599AbXFJWVP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 18:21:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759240AbXFJWVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 18:21:00 -0400
Received: from max.aladin.ro ([80.96.155.2]:58653 "EHLO aladin.ro"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759215AbXFJWVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 18:21:00 -0400
X-Greylist: delayed 1135 seconds by postgrey-1.27 at vger.kernel.org; Sun, 10 Jun 2007 18:20:59 EDT
Subject: [PATCH 1/1] UML: fix missing non-blocking I/O, now DEBUG_SHIRQ
	works
From: Eduard-Gabriel Munteanu <maxdamage@aladin.ro>
To: jdike@karaya.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Mon, 11 Jun 2007 01:20:48 +0300
Message-Id: <1181514048.3157.9.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

*This message was transferred with a trial version of CommuniGate(r) Pro*
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

---
 arch/um/drivers/chan_user.c     |    6 ++++++
 arch/um/drivers/mconsole_kern.c |   11 +++++------
 arch/um/drivers/mconsole_user.c |    5 +++--
 arch/um/drivers/ubd_user.c      |    6 ++++++
 arch/um/drivers/xterm.c         |    7 +++++++
 5 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/arch/um/drivers/chan_user.c b/arch/um/drivers/chan_user.c
index 13f0bf8..0a8b785 100644
--- a/arch/um/drivers/chan_user.c
+++ b/arch/um/drivers/chan_user.c
@@ -170,6 +170,12 @@ static int winch_tramp(int fd, struct tty_struct *tty, int *fd_out)
                 err = -EINVAL;
 		goto out_close;
 	}
+	
+	if (os_set_fd_block(*fd_out, 0)) {
+		printk("winch_tramp: failed to set thread_fd non-blocking.\n");
+		goto out_close;
+	}
+	
 	return err ;
 
  out_close:
diff --git a/arch/um/drivers/mconsole_kern.c b/arch/um/drivers/mconsole_kern.c
index 542c9ef..02d132e 100644
--- a/arch/um/drivers/mconsole_kern.c
+++ b/arch/um/drivers/mconsole_kern.c
@@ -74,12 +74,11 @@ static DECLARE_WORK(mconsole_work, mc_work_proc);
 
 static irqreturn_t mconsole_interrupt(int irq, void *dev_id)
 {
-	/* long to avoid size mismatch warnings from gcc */
-	long fd;
+	int fd;
 	struct mconsole_entry *new;
 	static struct mc_request req;	/* that's OK */
 
-	fd = (long) dev_id;
+	fd = *((int *) dev_id);
 	while (mconsole_get_request(fd, &req)){
 		if(req.cmd->context == MCONSOLE_INTR)
 			(*req.cmd->handler)(&req);
@@ -798,10 +797,10 @@ void mconsole_stack(struct mc_request *req)
  */
 static char *notify_socket = NULL;
 
+static int sock;
+
 static int mconsole_init(void)
 {
-	/* long to avoid size mismatch warnings from gcc */
-	long sock;
 	int err;
 	char file[256];
 
@@ -818,7 +817,7 @@ static int mconsole_init(void)
 
 	err = um_request_irq(MCONSOLE_IRQ, sock, IRQ_READ, mconsole_interrupt,
 			     IRQF_DISABLED | IRQF_SHARED | IRQF_SAMPLE_RANDOM,
-			     "mconsole", (void *)sock);
+			     "mconsole", &sock);
 	if (err){
 		printk("Failed to get IRQ for management console\n");
 		return(1);
diff --git a/arch/um/drivers/mconsole_user.c b/arch/um/drivers/mconsole_user.c
index 62e5ad6..f31e715 100644
--- a/arch/um/drivers/mconsole_user.c
+++ b/arch/um/drivers/mconsole_user.c
@@ -86,8 +86,9 @@ int mconsole_get_request(int fd, struct mc_request *req)
 	int len;
 
 	req->originlen = sizeof(req->origin);
-	req->len = recvfrom(fd, &req->request, sizeof(req->request), 0,
-			    (struct sockaddr *) req->origin, &req->originlen);
+	req->len = recvfrom(fd, &req->request, sizeof(req->request),
+			    MSG_DONTWAIT, (struct sockaddr *) req->origin,
+			    &req->originlen);
 	if (req->len < 0)
 		return 0;
 
diff --git a/arch/um/drivers/ubd_user.c b/arch/um/drivers/ubd_user.c
index 4707b3f..56f2c23 100644
--- a/arch/um/drivers/ubd_user.c
+++ b/arch/um/drivers/ubd_user.c
@@ -43,6 +43,12 @@ int start_io_thread(unsigned long sp, int *fd_out)
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
diff --git a/arch/um/drivers/xterm.c b/arch/um/drivers/xterm.c
index 571c2b3..2b65b57 100644
--- a/arch/um/drivers/xterm.c
+++ b/arch/um/drivers/xterm.c
@@ -151,6 +151,13 @@ int xterm_open(int input, int output, int primary, void *d,
 		goto out;
 	}
 
+	err = os_set_fd_block(new, 0);
+	if (err) {
+		printk("xterm_open : failed to set xterm descriptor "
+		       "non-blocking, err = %d\n", -err);
+		return(err);
+	}
+	
 	CATCH_EINTR(err = tcgetattr(new, &data->tt));
 	if(err){
 		new = err;


