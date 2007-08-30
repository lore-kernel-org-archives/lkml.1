Return-Path: <linux-kernel-owner+w=401wt.eu-S964827AbXH3Siu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964827AbXH3Siu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 14:38:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933108AbXH3SiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 14:38:19 -0400
Received: from cpe-70-113-91-236.austin.res.rr.com ([70.113.91.236]:51507 "EHLO
	ericvh.homeip.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933081AbXH3SiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 14:38:16 -0400
From: Eric Van Hensbergen <ericvh@ericvh.homeip.net>
To: lguest@ozlabs.org, linux-kernel@vger.kernel.org
Cc: Eric Van Hensbergen <ericvh@ericvh-desktop.austin.ibm.com>,
       Eric Van Hensbergen <ericvh@gmail.com>
Subject: [PATCH] modify lguest console to support multiple hvc's
Date: Thu, 30 Aug 2007 13:38:43 -0500
Message-Id: <11884991234068-git-send-email-ericvh@opteron.9grid.us>
X-Mailer: git-send-email 1.5.0.2.gfbe3d-dirty
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Van Hensbergen <ericvh@ericvh-desktop.austin.ibm.com>

This was a quick modification I did of lguest to be able to support multiple
HVC channels for some experiements I was doing.  I'm not sure if this is more
generally useful, so I'm posting it to the list in case someone else has a
need for it.

Signed-off-by: Eric Van Hensbergen <ericvh@gmail.com>
---
 Documentation/lguest/lguest.c |  161 ++++++++++++++++++++++++-----------------
 drivers/char/hvc_lguest.c     |   57 +++++++++------
 2 files changed, 129 insertions(+), 89 deletions(-)

diff --git a/Documentation/lguest/lguest.c b/Documentation/lguest/lguest.c
index f791840..c6a3e4d 100644
--- a/Documentation/lguest/lguest.c
+++ b/Documentation/lguest/lguest.c
@@ -690,12 +690,14 @@ static void restore_term(void)
 }
 
 /* We associate some data with the console for our exit hack. */
-struct console_abort
+struct console_priv
 {
+	/* which console we are */
+	int index;
 	/* How many times have they hit ^C? */
-	int count;
+	int a_count;
 	/* When did they start? */
-	struct timeval start;
+	struct timeval a_start;
 };
 
 /* This is the routine which handles console input (ie. stdin). */
@@ -705,11 +707,12 @@ static bool handle_console_input(int fd, struct device *dev)
 	int len;
 	unsigned int num;
 	struct iovec iov[LGUEST_MAX_DMA_SECTIONS];
-	struct console_abort *abort = dev->priv;
+	struct console_priv *cons = dev->priv;
 
 	/* First we get the console buffer from the Guest.  The key is dev->mem
-	 * which was set to 0 in setup_console(). */
-	lenp = get_dma_buffer(fd, dev->mem, iov, &num, &irq);
+	 * plus the console index adjusted to be a multiple of 4 because lguest
+	 * wants keys to be a multiple of 4 */
+	lenp = get_dma_buffer(fd, dev->mem+(cons->index*4), iov, &num, &irq);
 	if (!lenp) {
 		/* If it's not ready for input, warn and set up to discard. */
 		warn("console: no dma buffer!");
@@ -734,39 +737,44 @@ static bool handle_console_input(int fd, struct device *dev)
 		trigger_irq(fd, irq);
 	}
 
-	/* Three ^C within one second?  Exit.
-	 *
-	 * This is such a hack, but works surprisingly well.  Each ^C has to be
-	 * in a buffer by itself, so they can't be too fast.  But we check that
-	 * we get three within about a second, so they can't be too slow. */
-	if (len == 1 && ((char *)iov[0].iov_base)[0] == 3) {
-		if (!abort->count++)
-			gettimeofday(&abort->start, NULL);
-		else if (abort->count == 3) {
-			struct timeval now;
-			gettimeofday(&now, NULL);
-			if (now.tv_sec <= abort->start.tv_sec+1) {
-				u32 args[] = { LHREQ_BREAK, 0 };
-				/* Close the fd so Waker will know it has to
-				 * exit. */
-				close(waker_fd);
-				/* Just in case waker is blocked in BREAK, send
-				 * unbreak now. */
-				write(fd, args, sizeof(args));
-				exit(2);
+	/* Only do interrupt hack and restore_term() on initial console */
+	if (cons->index == 0) {
+		/* Three ^C within one second?  Exit.
+		 *
+		 * This is such a hack, but works surprisingly well.  Each ^C
+		 * has to be in a buffer by itself, so they can't be too fast.
+		 * But we check that we get three within about a second, so
+		 * they can't be too slow. */
+		if (len == 1 && ((char *)iov[0].iov_base)[0] == 3) {
+			if (!cons->a_count++)
+				gettimeofday(&cons->a_start, NULL);
+			else if (cons->a_count == 3) {
+				struct timeval now;
+				gettimeofday(&now, NULL);
+				if (now.tv_sec <= cons->a_start.tv_sec+1) {
+					u32 args[] = { LHREQ_BREAK, 0 };
+					/* Close the fd so Waker will know it
+					 * has to exit. */
+					close(waker_fd);
+					/* Just in case waker is blocked in
+					 * BREAK, send unbreak now. */
+					write(fd, args, sizeof(args));
+					exit(2);
+				}
+				cons->a_count = 0;
 			}
-			abort->count = 0;
+		} else
+			/* Any other key resets the abort counter. */
+			cons->a_count = 0;
+
+		/* Now, if we didn't read anything, put the input terminal
+		 * back and return failure (meaning, don't call us again). */
+		if (!len) {
+			restore_term();
+			return false;
 		}
-	} else
-		/* Any other key resets the abort counter. */
-		abort->count = 0;
-
-	/* Now, if we didn't read anything, put the input terminal back and
-	 * return failure (meaning, don't call us again). */
-	if (!len) {
-		restore_term();
-		return false;
 	}
+
 	/* Everything went OK! */
 	return true;
 }
@@ -777,7 +785,7 @@ static u32 handle_console_output(int fd, const struct iovec *iov,
 {
 	/* Whatever the Guest sends, write it to standard output.  Return the
 	 * number of bytes written. */
-	return writev(STDOUT_FILENO, iov, num);
+	return writev(dev->fd, iov, num);
 }
 
 /* Guest->Host network output is also pretty easy. */
@@ -1044,34 +1052,56 @@ static struct device *new_device(struct device_list *devices,
 	return dev;
 }
 
+static u32 str2ip(const char *ipaddr)
+{
+	unsigned int byte[4];
+
+	sscanf(ipaddr, "%u.%u.%u.%u", &byte[0], &byte[1], &byte[2], &byte[3]);
+	return (byte[0] << 24) | (byte[1] << 16) | (byte[2] << 8) | byte[3];
+}
+
 /* Our first setup routine is the console.  It's a fairly simple device, but
  * UNIX tty handling makes it uglier than it could be. */
-static void setup_console(struct device_list *devices)
+static void setup_console(char *arg, struct device_list *devices)
 {
 	struct device *dev;
-
-	/* If we can save the initial standard input settings... */
-	if (tcgetattr(STDIN_FILENO, &orig_term) == 0) {
-		struct termios term = orig_term;
-		/* Then we turn off echo, line buffering and ^C etc.  We want a
-		 * raw input stream to the Guest. */
-		term.c_lflag &= ~(ISIG|ICANON|ECHO);
-		tcsetattr(STDIN_FILENO, TCSANOW, &term);
-		/* If we exit gracefully, the original settings will be
-		 * restored so the user can see what they're typing. */
-		atexit(restore_term);
+	int fd;
+	static int hvcs_index;
+	struct console_priv *cons;
+
+	if (arg == NULL) {	/* default console - do the tty stuff */
+		/* If we can save the initial standard input settings... */
+		if (tcgetattr(STDIN_FILENO, &orig_term) == 0) {
+			struct termios term = orig_term;
+			/* Then we turn off echo, line buffering and ^C etc.
+			 * We want a raw input stream to the Guest. */
+			term.c_lflag &= ~(ISIG|ICANON|ECHO);
+			tcsetattr(STDIN_FILENO, TCSANOW, &term);
+			/* If we exit gracefully, the original settings will be
+			 * restored so the user can see what they're typing. */
+			atexit(restore_term);
+		}
+		fd = STDIN_FILENO;
+	} else {
+		/* create or open an exisitng fifo */
+		mkfifo(arg, S_IWUSR | S_IRUSR);
+		fd = open_or_die(arg, O_RDWR);
 	}
 
 	/* We don't currently require any memory for the console, so we ask for
 	 * 0 pages. */
 	dev = new_device(devices, LGUEST_DEVICE_T_CONSOLE, 0, 0,
-			 STDIN_FILENO, handle_console_input,
-			 LGUEST_CONSOLE_DMA_KEY, handle_console_output);
-	/* We store the console state in dev->priv, and initialize it. */
-	dev->priv = malloc(sizeof(struct console_abort));
-	((struct console_abort *)dev->priv)->count = 0;
-	verbose("device %p: console\n",
-		(void *)(dev->desc->pfn * getpagesize()));
+			 fd, handle_console_input,
+			 LGUEST_CONSOLE_DMA_KEY+(hvcs_index*4),
+			 handle_console_output);
+	dev->fd = fd;
+	/* We store the console state in dev->priv, and initialize */
+	dev->priv = malloc(sizeof(struct console_priv));
+	cons = dev->priv;
+	cons->a_count = 0;
+	cons->index = hvcs_index++;
+	verbose("device %p: console %d\n",
+		(void *)(dev->desc->pfn * getpagesize()), cons->index);
 }
 
 /* Setting up a block file is also fairly straightforward. */
@@ -1184,14 +1214,6 @@ static void setup_net_file(const char *filename,
 }
 /*:*/
 
-static u32 str2ip(const char *ipaddr)
-{
-	unsigned int byte[4];
-
-	sscanf(ipaddr, "%u.%u.%u.%u", &byte[0], &byte[1], &byte[2], &byte[3]);
-	return (byte[0] << 24) | (byte[1] << 16) | (byte[2] << 8) | byte[3];
-}
-
 /* This code is "adapted" from libbridge: it attaches the Host end of the
  * network device to the bridge device specified by the command line.
  *
@@ -1369,12 +1391,14 @@ static struct option opts[] = {
 	{ "tunnet", 1, NULL, 't' },
 	{ "block", 1, NULL, 'b' },
 	{ "initrd", 1, NULL, 'i' },
+	{ "console", 1, NULL, 'c' },
 	{ NULL },
 };
 static void usage(void)
 {
 	errx(1, "Usage: lguest [--verbose] "
 	     "[--sharenet=<filename>|--tunnet=(<ipaddr>|bridge:<bridgename>)\n"
+	     "|--console=<fifopath>...\n"
 	     "|--block=<filename>|--initrd=<filename>]...\n"
 	     "<mem-in-mb> vmlinux [args...]");
 }
@@ -1431,6 +1455,9 @@ int main(int argc, char *argv[])
 		}
 	}
 
+	/* We always have at least one console device */
+	setup_console(NULL, &device_list);
+
 	/* The options are fairly straight-forward */
 	while ((c = getopt_long(argc, argv, "v", opts, NULL)) != EOF) {
 		switch (c) {
@@ -1446,6 +1473,9 @@ int main(int argc, char *argv[])
 		case 'b':
 			setup_block_file(optarg, &device_list);
 			break;
+		case 'c':
+			setup_console(optarg, &device_list);
+			break;
 		case 'i':
 			initrd_name = optarg;
 			break;
@@ -1459,9 +1489,6 @@ int main(int argc, char *argv[])
 	if (optind + 2 > argc)
 		usage();
 
-	/* We always have a console device */
-	setup_console(&device_list);
-
 	/* We start by mapping anonymous pages over all of guest-physical
 	 * memory range.  This fills it with 0, and ensures that the Guest
 	 * won't be killed when it tries to access it. */
diff --git a/drivers/char/hvc_lguest.c b/drivers/char/hvc_lguest.c
index 3d6bd0b..b8b026a 100644
--- a/drivers/char/hvc_lguest.c
+++ b/drivers/char/hvc_lguest.c
@@ -38,14 +38,15 @@
 #include <asm/paravirt.h>
 #include "hvc_console.h"
 
-/*D:340 This is our single console input buffer, with associated "struct
- * lguest_dma" referring to it.  Note the 0-terminated length array, and the
- * use of physical address for the buffer itself. */
-static char inbuf[256];
-static struct lguest_dma cons_input = { .used_len = 0,
-					.addr[0] = __pa(inbuf),
-					.len[0] = sizeof(inbuf),
-					.len[1] = 0 };
+#define MAX_LGUEST_CONS 2
+
+/*D:340 Each console instance has an input buffer and associated offset
+associated with it.  Uck -- still static, can't we fix this? */
+static struct lguest_console {
+	struct lguest_dma cons_input;
+	int cons_offset;
+	void *inbuf;
+} lguest_con[MAX_LGUEST_CONS];
 
 /*D:310 The put_chars() callback is pretty straightforward.
  *
@@ -54,7 +55,8 @@ static struct lguest_dma cons_input = { .used_len = 0,
  * the data to (Host) buffers attached to the console key.  Usually a device's
  * key is a physical address within the device's memory, but because the
  * console device doesn't have any associated physical memory, we use the
- * LGUEST_CONSOLE_DMA_KEY constant (aka 0). */
+ * LGUEST_CONSOLE_DMA_KEY constant (aka 0) plus the console index multiplied
+ * by 4 (because keys must be aligned along 32-bit addresses). */
 static int put_chars(u32 vtermno, const char *buf, int count)
 {
 	struct lguest_dma dma;
@@ -66,7 +68,7 @@ static int put_chars(u32 vtermno, const char *buf, int count)
 	dma.len[1] = 0;
 	dma.addr[0] = __pa(buf);
 
-	lguest_send_dma(LGUEST_CONSOLE_DMA_KEY, &dma);
+	lguest_send_dma(LGUEST_CONSOLE_DMA_KEY+(vtermno*4), &dma);
 	/* We're expected to return the amount of data we wrote: all of it. */
 	return count;
 }
@@ -80,26 +82,27 @@ static int put_chars(u32 vtermno, const char *buf, int count)
  * partially-read buffers. */
 static int get_chars(u32 vtermno, char *buf, int count)
 {
-	static int cons_offset;
+	struct lguest_console *lgc = &lguest_con[vtermno];
 
 	/* Nothing left to see here... */
-	if (!cons_input.used_len)
+	if (!lgc->cons_input.used_len)
 		return 0;
 
 	/* You want more than we have to give?  Well, try wanting less! */
-	if (cons_input.used_len - cons_offset < count)
-		count = cons_input.used_len - cons_offset;
+	if (lgc->cons_input.used_len - lgc->cons_offset < count)
+		count = lgc->cons_input.used_len - lgc->cons_offset;
 
 	/* Copy across to their buffer and increment offset. */
-	memcpy(buf, inbuf + cons_offset, count);
-	cons_offset += count;
+	memcpy(buf, lgc->inbuf + lgc->cons_offset, count);
+	lgc->cons_offset += count;
 
 	/* Finished?  Zero offset, and reset cons_input so Host will use it
 	 * again. */
-	if (cons_offset == cons_input.used_len) {
-		cons_offset = 0;
-		cons_input.used_len = 0;
+	if (lgc->cons_offset == lgc->cons_input.used_len) {
+		lgc->cons_offset = 0;
+		lgc->cons_input.used_len = 0;
 	}
+
 	return count;
 }
 /*:*/
@@ -132,6 +135,14 @@ console_initcall(cons_init);
 static int lguestcons_probe(struct lguest_device *lgdev)
 {
 	int err;
+	static int index;
+	struct lguest_console *lgc = &lguest_con[index];
+
+	lgc->inbuf = (void *) get_zeroed_page(GFP_KERNEL);
+	lgc->cons_input.used_len = 0;
+	lgc->cons_input.addr[0] = (unsigned long) __pa(lgc->inbuf);
+	lgc->cons_input.len[0] = PAGE_SIZE;
+	lgc->cons_input.len[1] = 0;
 
 	/* The first argument of hvc_alloc() is the virtual console number, so
 	 * we use zero.  The second argument is the interrupt number.
@@ -140,17 +151,19 @@ static int lguestcons_probe(struct lguest_device *lgdev)
 	 * and get_chars() pointers.  The final argument is the output buffer
 	 * size: we use 256 and expect the Host to have room for us to send
 	 * that much. */
-	lgdev->private = hvc_alloc(0, lgdev_irq(lgdev), &lguest_cons, 256);
+	lgdev->private = hvc_alloc(index, lgdev_irq(lgdev), &lguest_cons,
+		PAGE_SIZE);
 	if (IS_ERR(lgdev->private))
 		return PTR_ERR(lgdev->private);
 
 	/* We bind a single DMA buffer at key LGUEST_CONSOLE_DMA_KEY.
 	 * "cons_input" is that statically-initialized global DMA buffer we saw
 	 * above, and we also give the interrupt we want. */
-	err = lguest_bind_dma(LGUEST_CONSOLE_DMA_KEY, &cons_input, 1,
-			      lgdev_irq(lgdev));
+	err = lguest_bind_dma(LGUEST_CONSOLE_DMA_KEY+(index*4),
+			      &lgc->cons_input, 1, lgdev_irq(lgdev));
 	if (err)
 		printk("lguest console: failed to bind buffer.\n");
+	index++;
 	return err;
 }
 /* Note the use of lgdev_irq() for the interrupt number.  We tell hvc_alloc()
-- 
1.5.0.gddff-dirty

