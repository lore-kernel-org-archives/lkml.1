Return-Path: <linux-kernel-owner+w=401wt.eu-S1754175AbYEPFk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175AbYEPFk0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 01:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750826AbYEPFkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 01:40:13 -0400
Received: from ozlabs.org ([203.10.76.45]:44055 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789AbYEPFkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 01:40:11 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: virtualization@lists.linux-foundation.org
Subject: [PATCH 2/2] lguest: virtio-rng support
Date: Fri, 16 May 2008 15:39:59 +1000
User-Agent: KMail/1.9.9
Cc: Jeff Garzik <jeff@garzik.org>, Herbert Xu <herbert@gondor.apana.org.au>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, "H. Anvin" <hpa@zytor.com>
References: <482C8595.5030509@garzik.org> <200805160943.08788.rusty@rustcorp.com.au> <200805161531.44725.rusty@rustcorp.com.au>
In-Reply-To: <200805161531.44725.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805161539.59739.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a simple patch to add support for the virtio "hardware random
generator" to lguest.  It gets about 1.2 MB/sec reading from /dev/hwrng
in the guest.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 Documentation/lguest/lguest.c |   90 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 90 insertions(+)

diff --git a/Documentation/lguest/lguest.c b/Documentation/lguest/lguest.c
--- a/Documentation/lguest/lguest.c
+++ b/Documentation/lguest/lguest.c
@@ -41,6 +41,7 @@
 #include "linux/virtio_net.h"
 #include "linux/virtio_blk.h"
 #include "linux/virtio_console.h"
+#include "linux/virtio_rng.h"
 #include "linux/virtio_ring.h"
 #include "asm-x86/bootparam.h"
 /*L:110 We can ignore the 39 include files we need for this program, but I do
@@ -195,6 +196,33 @@ static void *_convert(struct iovec *iov,
 #define le16_to_cpu(v16) (v16)
 #define le32_to_cpu(v32) (v32)
 #define le64_to_cpu(v64) (v64)
+
+/* Is this iovec empty? */
+static bool iov_empty(const struct iovec iov[], unsigned int num_iov)
+{
+	unsigned int i;
+
+	for (i = 0; i < num_iov; i++)
+		if (iov[i].iov_len)
+			return false;
+	return true;
+}
+
+/* Take len bytes from the front of this iovec. */
+static void iov_consume(struct iovec iov[], unsigned num_iov, unsigned len)
+{
+	unsigned int i;
+
+	for (i = 0; i < num_iov; i++) {
+		unsigned int used;
+
+		used = iov[i].iov_len < len ? iov[i].iov_len : len;
+		iov[i].iov_base += used;
+		iov[i].iov_len -= used;
+		len -= used;
+	}
+	assert(len == 0);
+}
 
 /* The device virtqueue descriptors are followed by feature bitmasks. */
 static u8 *get_feature_bits(struct device *dev)
@@ -1613,6 +1641,64 @@ static void setup_block_file(const char 
 	verbose("device %u: virtblock %llu sectors\n",
 		devices.device_num, le64_to_cpu(conf.capacity));
 }
+
+/* Our random number generator device reads from /dev/urandom into the Guest's
+ * input buffers.  The usual case is that the Guest doesn't want random numbers
+ * and so has no buffers although /dev/urandom is still readable, whereas
+ * console is the reverse.
+ *
+ * The same logic applies, however. */
+static bool handle_rng_input(int fd, struct device *dev)
+{
+	int len;
+	unsigned int head, in_num, out_num, totlen = 0;
+	struct iovec iov[dev->vq->vring.num];
+
+	/* First we need a buffer from the Guests's virtqueue. */
+	head = get_vq_desc(dev->vq, iov, &out_num, &in_num);
+
+	/* If they're not ready for input, stop listening to this file
+	 * descriptor.  We'll start again once they add an input buffer. */
+	if (head == dev->vq->vring.num)
+		return false;
+
+	if (out_num)
+		errx(1, "Output buffers in rng?");
+
+	/* This is why we convert to iovecs: the readv() call uses them, and so
+	 * it reads straight into the Guest's buffer.  We loop to make sure we
+	 * fill it. */
+	while (!iov_empty(iov, in_num)) {
+		len = readv(dev->fd, iov, in_num);
+		if (len <= 0)
+			err(1, "Read from /dev/urandom gave %i", len);
+		iov_consume(iov, in_num, len);
+		totlen += len;
+	}
+
+	/* Tell the Guest about the new input. */
+	add_used_and_trigger(fd, dev->vq, head, totlen);
+
+	/* Everything went OK! */
+	return true;
+}
+
+/* And this creates a "hardware" random number device for the Guest. */
+static void setup_rng(void)
+{
+	struct device *dev;
+	int fd;
+
+	fd = open_or_die("/dev/urandom", O_RDONLY);
+
+	/* The device responds to return from I/O thread. */
+	dev = new_device("rng", VIRTIO_ID_RNG, fd, handle_rng_input);
+
+	/* The device has one virtqueue, where the Guest places inbufs. */
+	add_virtqueue(dev, VIRTQUEUE_NUM, enable_fd);
+
+	verbose("device %u: rng\n", devices.device_num++);
+}
 /* That's the end of device setup. */
 
 /*L:230 Reboot is pretty easy: clean up and exec() the Launcher afresh. */
@@ -1683,6 +1769,7 @@ static struct option opts[] = {
 	{ "verbose", 0, NULL, 'v' },
 	{ "tunnet", 1, NULL, 't' },
 	{ "block", 1, NULL, 'b' },
+	{ "rng", 0, NULL, 'r' },
 	{ "initrd", 1, NULL, 'i' },
 	{ NULL },
 };
@@ -1756,6 +1843,9 @@ int main(int argc, char *argv[])
 			break;
 		case 'b':
 			setup_block_file(optarg);
+			break;
+		case 'r':
+			setup_rng();
 			break;
 		case 'i':
 			initrd_name = optarg;
