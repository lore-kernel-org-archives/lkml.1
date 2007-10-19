Return-Path: <linux-kernel-owner+w=401wt.eu-S1763895AbXJSO2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763895AbXJSO2S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 10:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759469AbXJSO2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 10:28:07 -0400
Received: from cpe-70-113-91-236.austin.res.rr.com ([70.113.91.236]:44990 "EHLO
	opteron.9grid.us" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758352AbXJSO2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 10:28:05 -0400
X-Greylist: delayed 447 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Oct 2007 10:28:05 EDT
From: ericvh@gmail.com
To: lguest@ozlabds.org, v9fs-developer@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Cc: Eric Van Hensbergen <ericvh@gmail.com>
Subject: [PATCH] lguest: add 9p socket gateway to launcher
Date: Fri, 19 Oct 2007 09:21:19 -0500
Message-Id: <11928036793399-git-send-email-ericvh@gmail.com>
X-Mailer: git-send-email 1.5.0.2.gfbe3d-dirty
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Van Hensbergen <ericvh@gmail.com>

This adds code to setup a gateway between virtio and a 9p server on the other
side of a TCP/IP socket.  I looked into trying to come up with more of a
"plug-in" model for such lguest launcher extensions, but wasn't happy with
any of the alternatives I had initially come up with.

Signed-off-by: Eric Van Hensbergen <ericvh@gmail.com>
---
 Documentation/lguest/lguest.c |  127 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 127 insertions(+), 0 deletions(-)

diff --git a/Documentation/lguest/lguest.c b/Documentation/lguest/lguest.c
index ea88188..eb3707f 100644
--- a/Documentation/lguest/lguest.c
+++ b/Documentation/lguest/lguest.c
@@ -51,6 +51,7 @@ typedef uint8_t u8;
 #include "linux/virtio_net.h"
 #include "linux/virtio_blk.h"
 #include "linux/virtio_console.h"
+#include "linux/virtio_9p.h"
 #include "linux/virtio_ring.h"
 #include "asm/e820.h"
 /*:*/
@@ -1466,6 +1467,127 @@ static void setup_block_file(const char *filename)
 }
 /* That's the end of device setup. */
 
+/* 9p transport code.
+ * This code implements the host side of the 9p transport.  Right now
+ * this is heavily based on the console code and just proxies data to
+ * a socket connected to an external server.
+ */
+/* This is the routine proxies 9p channel input */
+static bool handle_9p_input(int fd, struct device *dev)
+{
+	int len;
+	unsigned int head, in_num, out_num;
+	struct iovec iov[dev->vq->vring.num];
+
+	/* First we get the console buffer from the Guest. */
+	head = get_vq_desc(dev->vq, iov, &out_num, &in_num);
+
+	/* If they're not ready for input, stop listening to this file
+	 * descriptor.  We'll start again once they add an input buffer. */
+	if (head == dev->vq->vring.num)
+		return false;
+
+	if (out_num)
+		errx(1, "Output buffers in console in queue?");
+
+	/* This is why we convert to iovecs: the readv() call uses them, and so
+	 * it reads straight into the Guest's buffer. */
+	len = readv(dev->fd, iov, in_num);
+	if (len == 0)
+		err(1, "9p: zero length read!");
+
+	if (len < 0) /* Something has gone horribly wrong */
+		errx(1, "9p: input readv returned %d", len);
+
+	/* Now, if we didn't read anything, return failure */
+	if (!len)
+		return false;
+
+	/* Tell the Guest about the new input. */
+	add_used_and_trigger(fd, dev->vq, head, len);
+
+	/* Everything went OK! */
+	return true;
+}
+
+/*  Proxy output to socket - similar to console, without the hardcoded fd */
+static void handle_9p_output(int fd, struct virtqueue *vq)
+{
+	unsigned int head, out, in;
+	int len;
+	struct iovec iov[vq->vring.num];
+
+	/* Keep getting output buffers from the Guest until we run out. */
+	while ((head = get_vq_desc(vq, iov, &out, &in)) != vq->vring.num) {
+		if (in)
+			errx(1, "Input buffers in output queue?");
+		len = writev(vq->dev->fd, iov, out); /* FIXME: ??? */
+		add_used_and_trigger(fd, vq, head, len);
+	}
+}
+
+/* Connect to 9p server (based on spfsclient by Lucho Ionkov) */
+/* We can't use gethostbyname because it makes us link a shared library */
+static int connect_9p(const char *arg)
+{
+	int fd, port;
+	char *addr, *p, *s;
+	struct sockaddr_in saddr;
+	u32 ipaddr;
+
+	if (!arg)
+		err(1, "9p: problem with args");
+
+	addr = strdup(arg);
+	ipaddr = str2ip(addr);
+
+	port = 567;
+	p = strrchr(addr, ':');
+	if (p) {
+		*p = '\0';
+		p++;
+		port = strtol(p, &s, 10);
+		if (*s != '\0')
+			err(1, "9p: invalid port format");
+	}
+
+	fd = socket(PF_INET, SOCK_STREAM, 0);
+	if (fd < 0)
+		err(1, "9p: problem allocating socket");
+
+
+	saddr.sin_family = AF_INET;
+	saddr.sin_port = htons(port);
+	saddr.sin_addr.s_addr = htonl(ipaddr);
+
+	if (connect(fd, (struct sockaddr *) &saddr, sizeof(saddr)) < 0)
+		err(1, "9p: problem connecting to server");
+
+	free(addr);
+
+	return fd;
+}
+
+/* This sets up the 9p transport */
+static void setup_9p(const char *addr)
+{
+	struct device *dev;
+	int fd = connect_9p(addr);
+
+	/* We allocate a page to store or channel info and
+	   give a unique offset for our dma key */
+	dev = new_device("9p", VIRTIO_ID_9P,
+			 fd, handle_9p_input);
+
+	/* For the moment we use two virtqueues, although we should be able
+	 * to get by with one */
+	add_virtqueue(dev, VIRTQUEUE_NUM, enable_fd);
+	add_virtqueue(dev, VIRTQUEUE_NUM, handle_9p_output);
+
+	verbose("device %u: 9p transport\n", devices.device_num++);
+}
+/* End 9p Additions */
+
 /*L:220 Finally we reach the core of the Launcher, which runs the Guest, serves
  * its input and output, and finally, lays it to rest. */
 static void __attribute__((noreturn)) run_guest(int lguest_fd)
@@ -1512,6 +1634,7 @@ static struct option opts[] = {
 	{ "tunnet", 1, NULL, 't' },
 	{ "block", 1, NULL, 'b' },
 	{ "initrd", 1, NULL, 'i' },
+	{ "9p", 1, NULL, '9'},
 	{ NULL },
 };
 static void usage(void)
@@ -1519,6 +1642,7 @@ static void usage(void)
 	errx(1, "Usage: lguest [--verbose] "
 	     "[--tunnet=(<ipaddr>|bridge:<bridgename>)\n"
 	     "|--block=<filename>|--initrd=<filename>]...\n"
+	     "[--9p=(<ipaddr>:<port>)] "
 	     "<mem-in-mb> vmlinux [args...]");
 }
 
@@ -1581,6 +1705,9 @@ int main(int argc, char *argv[])
 		case 'i':
 			initrd_name = optarg;
 			break;
+		case '9':
+			setup_9p(optarg);
+			break;
 		default:
 			warnx("Unknown argument %s", argv[optind]);
 			usage();
-- 
1.5.0.2.gfbe3d-dirty

