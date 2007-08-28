Return-Path: <linux-kernel-owner+w=401wt.eu-S1763680AbXH1T3L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763680AbXH1T3L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 15:29:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761967AbXH1TOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 15:14:48 -0400
Received: from cpe-70-113-91-236.austin.res.rr.com ([70.113.91.236]:52004 "EHLO
	ericvh.homeip.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762088AbXH1TOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 15:14:44 -0400
From: Eric Van Hensbergen <ericvh@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: lguest@ozlabs.org, v9fs-developer@lists.sourceforge.net,
       kvm-devel@lists.sourceforge.net,
       Eric Van Hensbergen <ericvh@opteron (none)>,
       Eric Van Hensbergen <ericvh@gmail.com>
Subject: [RFC] 9p: add lguest transport
Date: Tue, 28 Aug 2007 13:52:39 -0500
Message-Id: <11883271601888-git-send-email-ericvh@gmail.com>
X-Mailer: git-send-email 1.5.0.2.gfbe3d-dirty
In-Reply-To: <11883271602233-git-send-email-ericvh@gmail.com>
References: <11883271601857-git-send-email-ericvh@gmail.com> <11883271601227-git-send-email-ericvh@gmail.com> <11883271602233-git-send-email-ericvh@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Van Hensbergen <ericvh@opteron.(none)>

This adds a transport to 9p for communicating between guest and host
domains on lguest.  Currently, the host-side proxies the communication to a
socket connected to the actual server.  The transport is based heavily on
the existing console code.

A better integrated server component which eliminates some of the copy
overhead is in progress and will look less like the existing console code.

Signed-off-by: Eric Van Hensbergen <ericvh@gmail.com>
---
 Documentation/filesystems/9p.txt |    2 +
 Documentation/lguest/lguest.c    |  127 ++++++++++++++++
 fs/9p/v9fs.c                     |    2 +-
 include/linux/lguest_launcher.h  |    1 +
 net/9p/Kconfig                   |    7 +
 net/9p/Makefile                  |    4 +
 net/9p/trans_lg.c                |  303 ++++++++++++++++++++++++++++++++++++++
 7 files changed, 445 insertions(+), 1 deletions(-)
 create mode 100644 net/9p/trans_lg.c

diff --git a/Documentation/filesystems/9p.txt b/Documentation/filesystems/9p.txt
index e1879bd..1a3342f 100644
--- a/Documentation/filesystems/9p.txt
+++ b/Documentation/filesystems/9p.txt
@@ -48,6 +48,8 @@ OPTIONS
                                 (see rfdno and wfdno)
 			pci  - use a PCI pseudo device for 9p communication
 				over shared memory between a guest and host
+ 			lg   - use a lguest 9p channel for communication
+				over shared memory between a guest and host
 
   uname=name	user name to attempt mount as on the remote server.  The
   		server may override or ignore this value.  Certain user
diff --git a/Documentation/lguest/lguest.c b/Documentation/lguest/lguest.c
index f791840..adc50de 100644
--- a/Documentation/lguest/lguest.c
+++ b/Documentation/lguest/lguest.c
@@ -1318,6 +1318,128 @@ static void setup_tun_net(const char *arg, struct device_list *devices)
 }
 /* That's the end of device setup. */
 
+/* 9p transport code.
+ * This code implements the host side of the 9p transport.  Right now
+ * this is heavily based on the console code and just proxies data to
+ * a socket connected to an external server.  Eventually we'll hook the
+ * server code in more directly like we do with lguest to avoid the
+ * socket overhead.
+ */
+/* This is the routine proxies 9p channel input */
+static bool handle_9p_input(int fd, struct device *dev)
+{
+	u32 irq = 0;
+	u32 *lenp;
+	int len = 0;
+	unsigned int num = 0;
+	struct iovec iov[LGUEST_MAX_DMA_SECTIONS];
+
+	/* First we get the console buffer from the Guest.  The key is dev->mem
+	 * which was set in setup_9p(). */
+
+	lenp = get_dma_buffer(fd, dev->mem, iov, &num, &irq);
+	if (!lenp) {
+		/* If it's not ready for input, warn and set up to discard. */
+		warn("9p: no dma buffer!");
+		discard_iovec(iov, &num);
+	}
+
+	/* This is why we convert to iovecs: the readv() call uses them, and so
+	 * it reads straight into the Guest's buffer. */
+	len = readv(dev->fd, iov, num);
+	if (len == 0) {
+		/*
+		 * BUG: When using msize > 1k we get zero length reads
+		 * and I'm not sure why.
+		 */
+		err(1, "9p: zero length read!");
+	}
+
+	if (len < 0) /* Something has gone horribly wrong */
+		errx(1, "9p: input readv returned %d", len);
+
+	/* If we read the data into the Guest, fill in the length and send the
+	 * interrupt. */
+	if (lenp) {
+		*lenp = len;
+		trigger_irq(fd, irq);
+	}
+
+	/* Now, if we didn't read anything, return failure */
+	if (!len)
+		return false;
+
+	/* Everything went OK! */
+	return true;
+}
+
+/*  Proxy output to socket. */
+static u32 handle_9p_output(int fd, const struct iovec *iov,
+				 unsigned num, struct device*dev)
+{
+	/* Whatever the Guest sends, write it to the fd.  Return the
+	 * number of bytes written. */
+	return writev(dev->fd, iov, num);
+}
+
+/* Connect to 9p server (stolen from spfsclient by Lucho Ionkov) */
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
+static void setup_9p(const char *addr, struct device_list *devices)
+{
+	struct device *dev;
+	int fd = connect_9p(addr);
+
+	/* We allocate a page to store or channel info and
+	   give a unique offset for our dma key */
+	dev = new_device(devices, LGUEST_DEVICE_T_9P, 1, 0, fd,
+			 handle_9p_input, 0, handle_9p_output);
+
+	verbose("device %p: 9p transport\n",
+		(void *)(dev->desc->pfn * getpagesize()));
+}
+/* End 9p Additions */
+
 /*L:220 Finally we reach the core of the Launcher, which runs the Guest, serves
  * its input and output, and finally, lays it to rest. */
 static void __attribute__((noreturn))
@@ -1369,6 +1491,7 @@ static struct option opts[] = {
 	{ "tunnet", 1, NULL, 't' },
 	{ "block", 1, NULL, 'b' },
 	{ "initrd", 1, NULL, 'i' },
+	{ "9p", 1, NULL, '9'},
 	{ NULL },
 };
 static void usage(void)
@@ -1376,6 +1499,7 @@ static void usage(void)
 	errx(1, "Usage: lguest [--verbose] "
 	     "[--sharenet=<filename>|--tunnet=(<ipaddr>|bridge:<bridgename>)\n"
 	     "|--block=<filename>|--initrd=<filename>]...\n"
+	     "[--9p=(<ipaddr>:<port>)] "
 	     "<mem-in-mb> vmlinux [args...]");
 }
 
@@ -1449,6 +1573,9 @@ int main(int argc, char *argv[])
 		case 'i':
 			initrd_name = optarg;
 			break;
+		case '9':
+			setup_9p(optarg, &device_list);
+			break;
 		default:
 			warnx("Unknown argument %s", argv[optind]);
 			usage();
diff --git a/fs/9p/v9fs.c b/fs/9p/v9fs.c
index 08d880f..b39123b 100644
--- a/fs/9p/v9fs.c
+++ b/fs/9p/v9fs.c
@@ -244,7 +244,7 @@ struct p9_fid *v9fs_session_init(struct v9fs_session_info *v9ses,
 		v9ses->maxdata = v9ses->trans->maxsize-P9_IOHDRSZ;
 
 	v9ses->clnt = p9_client_create(trans, v9ses->maxdata+P9_IOHDRSZ,
-		v9ses->extended);
+							v9ses->extended);
 
 	if (IS_ERR(v9ses->clnt)) {
 		retval = PTR_ERR(v9ses->clnt);
diff --git a/include/linux/lguest_launcher.h b/include/linux/lguest_launcher.h
index 6416705..9170046 100644
--- a/include/linux/lguest_launcher.h
+++ b/include/linux/lguest_launcher.h
@@ -90,6 +90,7 @@ struct lguest_device_desc {
 #define LGUEST_DEVICE_T_CONSOLE	1
 #define LGUEST_DEVICE_T_NET	2
 #define LGUEST_DEVICE_T_BLOCK	3
+#define LGUEST_DEVICE_T_9P	9
 
 	/* The specific features of this device: these depends on device type
 	 * except for LGUEST_DEVICE_F_RANDOMNESS. */
diff --git a/net/9p/Kconfig b/net/9p/Kconfig
index 8517560..fab7bb9 100644
--- a/net/9p/Kconfig
+++ b/net/9p/Kconfig
@@ -31,6 +31,13 @@ config NET_9P_PCI
 	  under KVM/QEMU which allows for 9p transactions over shared
 	  memory between the guest and the host.
 
+config NET_9P_LG
+	depends on NET_9P
+	tristate "9p Lguest Transport (Experimental)"
+	help
+	  This builds support for a transport between an Lguest
+	  guest partition and the host partition.
+
 config NET_9P_DEBUG
 	bool "Debug information"
 	depends on NET_9P
diff --git a/net/9p/Makefile b/net/9p/Makefile
index 26ce89d..80a4227 100644
--- a/net/9p/Makefile
+++ b/net/9p/Makefile
@@ -1,6 +1,7 @@
 obj-$(CONFIG_NET_9P) := 9pnet.o
 obj-$(CONFIG_NET_9P_FD) += 9pnet_fd.o
 obj-$(CONFIG_NET_9P_PCI) += 9pnet_pci.o
+obj-$(CONFIG_NET_9P_LG) += 9pnet_lg.o
 
 9pnet-objs := \
 	mod.o \
@@ -18,3 +19,6 @@ obj-$(CONFIG_NET_9P_PCI) += 9pnet_pci.o
 
 9pnet_pci-objs := \
 	trans_pci.o \
+
+9pnet_lg-objs := \
+	trans_lg.o \
diff --git a/net/9p/trans_lg.c b/net/9p/trans_lg.c
new file mode 100644
index 0000000..146ed01
--- /dev/null
+++ b/net/9p/trans_lg.c
@@ -0,0 +1,303 @@
+/*
+ * The Guest 9p transport driver
+ *
+ * This is a trivial pipe-based transport driver based on the lguest console
+ * code: we use lguest's DMA mechanism to send bytes out, and register a
+ * DMA buffer to receive bytes in.  It is assumed to be present and available
+ * from the very beginning of boot.
+ *
+ * This may be have been done by just instaniating another HVC console,
+ * but HVC's blocksize of 16 bytes is annoying and painful to performance.
+ *
+ */
+/*
+ *  Copyright (C) 2007 Eric Van Hensbergen, IBM Corporation
+ *
+ *  Based on lguest console driver
+ *  Copyright (C) 2006 Rusty Russel, IBM Corporation
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2
+ *  as published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to:
+ *  Free Software Foundation
+ *  51 Franklin Street, Fifth Floor
+ *  Boston, MA  02111-1301  USA
+ *
+ */
+
+#include <linux/in.h>
+#include <linux/module.h>
+#include <linux/net.h>
+#include <linux/ipv6.h>
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/un.h>
+#include <linux/uaccess.h>
+#include <linux/inet.h>
+#include <linux/idr.h>
+#include <linux/file.h>
+#include <linux/lguest_bus.h>
+#include <net/9p/9p.h>
+#include <net/9p/transport.h>
+
+/* 9p Buffer Size in Pages */
+#define P9_BUF_PAGES 16
+/* 9p Buffer Size as 2^x */
+#define P9_BUF_SHIFT 4
+/* only support a single channel for now */
+#define MAX_9P_CHAN 1
+/* for channel names */
+#define NAMELEN 256
+
+/* We keep all per-channel information in a structure.
+ * This structure is allocated within the devices dev->mem space.
+ * A pointer to the structure will get put in the transport private.
+ */
+static struct lg_chan {
+	struct lguest_dma input;	/* input structure for channel */
+	unsigned long offset;		/* input offset */
+	unsigned long key;		/* dma key */
+	char *buf;			/* input buffer */
+	wait_queue_head_t wq;		/* waitq for buffer */
+	struct lguest_device *dev;	/* back pointer to device */
+} channels[MAX_9P_CHAN];
+
+/* How many bytes left in this page. */
+static unsigned int rest_of_page(void *data)
+{
+	return PAGE_SIZE - ((unsigned long)data % PAGE_SIZE);
+}
+
+/* this breaks up any dma requests along page size boundries */
+static void p9_lg_setup_dma(struct lguest_dma *i, void *buf, int len)
+{
+	int index;
+
+	/* setup first buffer to page align subsequent buffers */
+	i->addr[0] = __pa(buf);
+	if (len > PAGE_SIZE)
+		i->len[0] = rest_of_page(buf);
+	else
+		i->len[0] = len;
+	buf += i->len[0];
+	len -= i->len[0];
+
+	for (index = 1; index < LGUEST_MAX_DMA_SECTIONS; index++) {
+		if (len == 0) {
+			if (index < LGUEST_MAX_DMA_SECTIONS)
+				i->len[index] = 0;
+			break;
+		}
+		i->addr[index] = __pa(buf);
+		if (len > PAGE_SIZE)
+			i->len[index] = PAGE_SIZE;
+		else
+			i->len[index] = len;
+
+		buf += i->len[index];
+		len -= i->len[index];
+	}
+
+	if (len) {
+		printk(KERN_ERR "9p: lg: buffer didn't fit in dma %d by %d\n",
+			index, len);
+		BUG();
+	}
+}
+
+/* Since we are likely to have multi-page data and data which crosses
+ * page boundries, we need to split things up properly.
+ */
+static int p9_lg_write(struct p9_trans *trans, void *buf, int count)
+{
+	struct lguest_dma dma;
+	struct lg_chan *chan = (struct lg_chan *)trans->priv;
+
+	p9_lg_setup_dma(&dma, buf, count);
+	lguest_send_dma(chan->key, &dma);
+
+	return count;
+}
+
+/* We have started with a naive read implementation that will
+ * require an extra copy.  In the near future we'll be modifying the
+ * v9fs transport infrastructure to better support zero-copy readv/writev
+ * style implementations.
+ */ static int p9_lg_read(struct p9_trans *trans, void *buf, int count)
+{
+	struct lg_chan *chan = (struct lg_chan *)trans->priv;
+
+	if (!chan->input.used_len)
+		return 0;
+
+	/* You want more than we have to give?  Well, try wanting less! */
+	if (chan->input.used_len - chan->offset < count)
+		count = chan->input.used_len - chan->offset;
+
+	/* Copy across to their buffer and increment offset. */
+	memcpy(buf, chan->buf + chan->offset, count);
+	chan->offset += count;
+
+	/* Finished?  Zero offset, and reset p9_lg_input so Host will use it
+	 * again. */
+	if (chan->offset == chan->input.used_len) {
+		chan->input.used_len = 0;
+		chan->offset = 0;
+	}
+
+	return count;
+}
+
+/* The poll function is used by 9p transports to determine if there
+ * is there is activity available on a particular channel.  In our case
+ * we use it to wait for an interrupt.
+ */
+static unsigned int
+p9_lg_poll(struct p9_trans *trans, struct poll_table_struct *pt)
+{
+	struct lg_chan *chan = (struct lg_chan *)trans->priv;
+	int ret = POLLOUT; /* we can always handle more output */
+
+	poll_wait(NULL, &chan->wq, pt);
+
+	if (chan->input.used_len)
+		ret |= POLLIN;
+
+	return ret;
+}
+
+static void p9_lg_close(struct p9_trans *trans)
+{
+	kfree(trans);
+}
+
+static irqreturn_t
+p9_lg_intr(int irq, void *arg)
+{
+	wait_queue_head_t *w = (wait_queue_head_t *) arg;
+
+	wake_up_interruptible(w);
+
+	return IRQ_HANDLED;
+}
+
+/* This registers available probe devices with the kernel.  Right now
+ * we really only support a single channel -- but things are setup to allow
+ * for multiple channels */
+static int p9_lg_probe(struct lguest_device *lgdev)
+{
+	static int chan_index;
+	struct lg_chan *chan = &channels[chan_index++];
+	int err;
+
+	if (chan_index > MAX_9P_CHAN) {
+		printk(KERN_ERR "9p: lg: Maximum channels exceeded\n");
+		BUG();
+	}
+
+	lgdev->private = (void *) chan;
+	chan->key = (lguest_devices[lgdev->index].pfn << PAGE_SHIFT);
+
+	/* Allocate 16 pages */
+	chan->buf = (char *)__get_free_pages(GFP_KERNEL|__GFP_ZERO,
+								P9_BUF_SHIFT);
+	if (chan->buf == 0)
+		BUG();
+
+	p9_lg_setup_dma(&chan->input, chan->buf, PAGE_SIZE*P9_BUF_PAGES);
+
+	chan->input.used_len = 0;
+
+	/* We bind a single DMA buffer using the channel's key which is set
+	 * to dev->mem, and we also give the interrupt we want. */
+	err = lguest_bind_dma(chan->key, &chan->input, P9_BUF_PAGES,
+							lgdev_irq(lgdev));
+	if (err) {
+		printk(KERN_ERR "9p: lg: failed to bind buffer.\n");
+		BUG();
+	}
+
+	init_waitqueue_head(&chan->wq);
+	err = request_irq(lgdev_irq(lgdev), &p9_lg_intr, 0, "p9_lg",
+								&chan->wq);
+	if (err) {
+		printk(KERN_ERR "9p: lg: failed to obtain irq.\n");
+		BUG();
+	}
+
+	return 0;
+}
+
+/* The standard "struct lguest_driver": */
+static struct lguest_driver p9_lg_drv = {
+	.name = "9p_lg",
+	.owner = THIS_MODULE,
+	.device_type = LGUEST_DEVICE_T_9P,
+	.probe = p9_lg_probe,
+};
+
+/* This sets up a transport channel for 9p communication.  Right now
+ * we only match the first channel, but eventually we'll be able to look up
+ * alternate channels by matching devname versus chan->name.  We use a simple
+ * reference count mechanism to ensure that only a single mount has a
+ * channel open at a time. */
+static struct p9_trans *p9_lg_create(const char *devname, char *args)
+{
+	struct p9_trans *trans;
+	struct lg_chan *chan = channels; /* don't bother w/match now */
+
+	if (strcmp(paravirt_ops.name, "lguest") != 0) {
+		printk(KERN_ERR "9p: not running on lguest, no lg possible\n");
+		return ERR_PTR(-ENODEV);
+	}
+
+	trans = kmalloc(sizeof(struct p9_trans), GFP_KERNEL);
+	if (!trans) {
+		printk(KERN_ERR "9p: couldn't allocate transport\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	trans->write = p9_lg_write;
+	trans->read = p9_lg_read;
+	trans->close = p9_lg_close;
+	trans->poll = p9_lg_poll;
+	trans->priv = chan;
+
+	return trans;
+}
+
+static struct p9_trans_module p9_lg_trans = {
+	.name = "lg",
+	.create = p9_lg_create,
+	.maxsize = 1024,
+	.def = 0,
+};
+
+/* The standard init function */
+static int __init p9_lg_init(void)
+{
+	v9fs_register_trans(&p9_lg_trans);
+	return register_lguest_driver(&p9_lg_drv);
+}
+
+static void __exit p9_lg_cleanup(void)
+{
+	printk(KERN_ERR "Removal of 9p transports not implemented\n");
+	BUG();
+}
+
+module_init(p9_lg_init);
+module_exit(p9_lg_cleanup);
+
+MODULE_AUTHOR("Eric Van Hensbergen <ericvh@gmail.com>");
+MODULE_DESCRIPTION("9p Lguest Pipe");
+MODULE_LICENSE("GPL");
+
-- 
1.5.0.2.gfbe3d-dirty

