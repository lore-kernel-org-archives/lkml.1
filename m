Return-Path: <linux-kernel-owner+w=401wt.eu-S1764182AbXH1TbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764182AbXH1TbA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 15:31:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761881AbXH1TOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 15:14:53 -0400
Received: from cpe-70-113-91-236.austin.res.rr.com ([70.113.91.236]:52006 "EHLO
	ericvh.homeip.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762087AbXH1TOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 15:14:45 -0400
From: Eric Van Hensbergen <ericvh@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: lguest@ozlabs.org, v9fs-developer@lists.sourceforge.net,
       kvm-devel@lists.sourceforge.net,
       Eric Van Hensbergen <ericvh@opteron (none)>,
       Eric Van Hensbergen <ericvh@gmail.com>
Subject: [REFERENCE ONLY] 9p: add shared memory transport
Date: Tue, 28 Aug 2007 13:52:40 -0500
Message-Id: <1188327160315-git-send-email-ericvh@gmail.com>
X-Mailer: git-send-email 1.5.0.2.gfbe3d-dirty
In-Reply-To: <11883271601888-git-send-email-ericvh@gmail.com>
References: <11883271601857-git-send-email-ericvh@gmail.com> <11883271601227-git-send-email-ericvh@gmail.com> <11883271602233-git-send-email-ericvh@gmail.com> <11883271601888-git-send-email-ericvh@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Van Hensbergen <ericvh@opteron.(none)>

This adds a 9p generic shared memory transport which has been used to
communicate between Dom0 and DomU under Xen as part of the Libra and PROSE
projects (http://www.research.ibm.com/prose).

Parts of the code are a horrible hack, but may be useful as reference
for constructing (or how not to construct) a poll-driven shared-memory driver
for Xen (or other purposes).

Signed-off-by: Eric Van Hensbergen <ericvh@gmail.com>
---
 net/9p/Kconfig     |    7 +
 net/9p/Makefile    |    4 +
 net/9p/trans_shm.c |  378 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 389 insertions(+), 0 deletions(-)
 create mode 100644 net/9p/trans_shm.c

diff --git a/net/9p/Kconfig b/net/9p/Kconfig
index fab7bb9..a1b55e8 100644
--- a/net/9p/Kconfig
+++ b/net/9p/Kconfig
@@ -38,6 +38,13 @@ config NET_9P_LG
 	  This builds support for a transport between an Lguest
 	  guest partition and the host partition.
 
+config NET_9P_SHM
+	depends on NET_9P
+	tristate "9p Shared Memory Transport (Experimental)"
+	help
+	  This builds support for a shared memory transport which
+	  can be used on XenPPC to mount 9p between DomU and Dom0.
+
 config NET_9P_DEBUG
 	bool "Debug information"
 	depends on NET_9P
diff --git a/net/9p/Makefile b/net/9p/Makefile
index 80a4227..e7a036a 100644
--- a/net/9p/Makefile
+++ b/net/9p/Makefile
@@ -2,6 +2,7 @@ obj-$(CONFIG_NET_9P) := 9pnet.o
 obj-$(CONFIG_NET_9P_FD) += 9pnet_fd.o
 obj-$(CONFIG_NET_9P_PCI) += 9pnet_pci.o
 obj-$(CONFIG_NET_9P_LG) += 9pnet_lg.o
+obj-$(CONFIG_NET_9P_SHM) += 9pnet_shm.o
 
 9pnet-objs := \
 	mod.o \
@@ -22,3 +23,6 @@ obj-$(CONFIG_NET_9P_LG) += 9pnet_lg.o
 
 9pnet_lg-objs := \
 	trans_lg.o \
+
+9pnet_shm-objs := \
+	trans_shm.o \
diff --git a/net/9p/trans_shm.c b/net/9p/trans_shm.c
new file mode 100644
index 0000000..d7847fd
--- /dev/null
+++ b/net/9p/trans_shm.c
@@ -0,0 +1,378 @@
+/*
+ * linux/fs/9p/trans_shm.c
+ *
+ *  Shared memory transport layer.
+ *
+ *  This is the Linux version of shared memory transport hack used
+ *  in the Libra and PROSE projects to communicate between Dom0 and
+ *  DomU under Xen and rHype.
+ *
+ *  Certain aspects of this code (such as the BIG_UGLY_BUFFER) are
+ *  horrible hacks, but the rest of the code may provide a decent starting
+ *  point for someone wanting to write a proper shared-memory transport for
+ *  Xen (or other purposes).
+ *
+ *  The server side of this transport exists in inferno-tx branch of
+ *  inferno.  It can be grabbed from the txinferno branch of
+ *  http://git.9grid.us/git/inferno.git
+ *
+ *  Copyright (C) 2006,2007 by Eric Van Hensbergen <ericvh@gmail.com>
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
+#include <net/9p/9p.h>
+#include <net/9p/transport.h>
+
+enum
+{
+	Shm_Idle =		0,
+	Shm_Announcing = 	1,
+	Shm_Announced =		2,
+	Shm_Connecting =	3,
+	Shm_Connected =		4,
+	Shm_Hungup =		5,
+
+	Shmaddrlen = 		255,
+};
+
+enum
+{
+	S_USM =	1,		/* Sys V shared memory */
+	S_MSM =	2,		/* mmap */
+	S_XEN =	3,		/* xen shared memory */
+
+	SM_SERVER =		0,
+	SM_CLIENT =		1,
+
+	DATA_POLL =		100,
+	HANDSHAKE_POLL = 	100000000
+};
+
+struct chan
+{
+	u32 magic;
+	u32 write;
+	u32 read;
+	u32 overflow;
+};
+
+enum {
+	Chan_listen,
+	Chan_connected,
+	Chan_hungup
+};
+
+/* Two circular buffers: small one for input, large one for output. */
+struct chan_pipe
+{
+	u32 magic;
+	u32 buflen;
+	u32 state;
+	struct chan out;
+	struct chan in;
+	char buffers[0];
+};
+
+#define CHUNK_SIZE	(64<<20)
+#define CHAN_MAGIC	0xB0BABEEF
+#define CHAN_BUF_MAGIC	0xCAFEBABE
+
+/*
+ * UGLY HACK: static buffer just like in libOS so we can easily
+ *            address things.  Xen hackers free to fix this.
+ *
+ */
+
+#define BIG_UGLY_BUFFER_SZ 8*1024
+static char big_ugly_buffer[sizeof(struct chan_pipe)+(BIG_UGLY_BUFFER_SZ*2)];
+
+/*
+ * (expr) may be as much as (limit) "below" zero (in an unsigned sense).
+ * We add (limit) before taking the modulus so that we're not dealing with
+ * "negative" numbers.
+ */
+#define CIRCULAR(expr, limit) (((expr) + (limit)) % (limit))
+
+static inline int
+check_write_buffer(const struct chan *h, u32 bufsize)
+{
+	/* Buffer is "full" if the write index is one behind the read index. */
+	return (h->write != CIRCULAR((h->read - 1), bufsize));
+}
+
+static inline int
+check_read_buffer(const struct chan *h, u32 bufsize)
+{
+	/* Buffer is empty if the read and write indices are the same. */
+	return (h->read != h->write);
+}
+
+/* We can't fill last byte: would look like empty buffer. */
+static char *
+get_write_chunk(const struct chan *h, char *buf, u32 bufsize, u32 *len)
+{
+	/* We can't fill last byte: would look like empty buffer. */
+	u32 write_avail = CIRCULAR(((h->read - 1) - h->write), bufsize);
+	*len = ((h->write + write_avail) <= bufsize) ?
+		write_avail : (bufsize - h->write);
+	return buf + h->write;
+}
+
+static const char *
+get_read_chunk(const struct chan *h, const char *buf, u32 bufsize, u32 *len)
+{
+	u32 read_avail = CIRCULAR((h->write - h->read), bufsize);
+	*len = ((h->read + read_avail) <= bufsize) ?
+		read_avail : (bufsize - h->read);
+	return buf + h->read;
+}
+
+static void
+update_write_chunk(struct chan *h, u32 bufsize, u32 len)
+{
+	/* fprint(2, "> %x\n",len); DEBUG */
+	h->write = CIRCULAR((h->write + len), bufsize);
+	mb();	/* sync with other partition */
+}
+
+static void
+update_read_chunk(struct chan *h, u32 bufsize, u32 len)
+{
+	/* fprint(2, "< %x\n",len); DEBUG */
+	h->read = CIRCULAR((h->read + len), bufsize);
+	mb();  /* sync with other partition */
+}
+
+/**
+ * p9_shm_read- read from a shared memory buffer
+ * @trans: transport information
+ * @v: buffer to receive data into
+ * @len: size of receive buffer
+ *
+ */
+static int p9_shm_read(struct p9_trans *trans, void *dst, int len)
+{
+	int ret = 0;
+	struct chan_pipe *p = NULL;
+	struct chan *c;
+
+	if (trans && trans->status != Disconnected)
+		p = xchg(&trans->priv, NULL);
+
+	if (!p)
+		return -EREMOTEIO;
+
+	c = &p->in;
+
+	while (!check_read_buffer(c, p->buflen)) {
+		if ((p->magic == 0xDEADDEAD) || (p->state == Shm_Hungup)) {
+			trans->status = Disconnected;
+			return 0;
+		}
+		yield();
+	}
+
+	while (len > 0) {
+		u32 thislen;
+		const char *src;
+		src = get_read_chunk(c, p->buffers+p->buflen, p->buflen,
+								&thislen);
+		if (thislen == 0) {
+			if ((p->magic == 0xDEADDEAD) ||
+						(p->state == Shm_Hungup)) {
+				trans->status = Disconnected;
+				return 0;
+			}
+			yield();
+			continue;
+		}
+		if (thislen > len)
+			thislen = len;
+		memcpy(dst, src, thislen);
+		update_read_chunk(c, p->buflen, thislen);
+
+		dst += thislen;
+		len -= thislen;
+		ret += thislen;
+		break; /* obc */
+	}
+
+	/* Must have read data before updating head. */
+	return ret;
+}
+
+/**
+ * p9_shm_write - write to a shared memory buffer
+ * @trans: transport information
+ * @v: buffer to send data from
+ * @len: size of send buffer
+ *
+ */
+static int p9_shm_write(struct p9_trans *trans, void *src, int len)
+{
+	struct chan_pipe *p = NULL;
+	struct chan *c;
+	int ret = 1;
+
+	if (trans && trans->status != Disconnected)
+		p = xchg(&trans->priv, NULL);
+
+	if (!p)
+		return -EREMOTEIO;
+
+	c = &p->out;
+
+	while (!check_write_buffer(c, p->buflen)) {
+		yield();		/* TODO: Something more friendly */
+	}
+
+	while (len > 0) {
+		u32 thislen;
+		char *dst = get_write_chunk(c, p->buffers, p->buflen,
+								    &thislen);
+		if (thislen == 0) {
+			yield();
+			continue;
+		}
+
+		if (thislen > len)
+			thislen = len;
+		memcpy(dst, src, thislen);
+		update_write_chunk(c, p->buflen, thislen);
+		src += thislen;
+		len -= thislen;
+		ret += thislen;
+	}
+
+	return ret;
+}
+
+/**
+ * p9_shm_poll - figure out how much data is available
+ * @trans: transport information
+ * @pt: poll table
+ *
+ */
+static unsigned int
+p9_shm_poll(struct p9_trans *trans, struct poll_table_struct *pt)
+{
+	int ret = 0;
+	struct chan_pipe *p = NULL;
+
+	if (trans && trans->status == (int) Shm_Connected)
+		p = trans->priv;
+
+	if (!p)
+		return -EREMOTEIO;
+
+	if (check_read_buffer(&p->in, p->buflen))
+		ret = POLLIN;
+
+	if (check_write_buffer(&p->out, p->buflen))
+		ret |= POLLOUT;
+
+	return ret;
+}
+
+/**
+ * p9_shm_close - shutdown shared memory transport
+ * @trans: transport info
+ *
+ */
+static void p9_shm_close(struct p9_trans *trans)
+{
+	struct chan_pipe *chan;
+
+	if (!trans)
+		return;
+
+	chan = xchg(&trans->priv, NULL);
+	if (!chan)
+		return;
+
+	chan->state = Shm_Hungup;
+	trans->status = Disconnected;
+}
+
+
+struct p9_trans *p9_trans_create_shm(const char *devname, char *args)
+{
+	struct p9_trans *trans;
+	struct chan_pipe *chan;
+
+	trans = kmalloc(sizeof(struct p9_trans), GFP_KERNEL);
+	if (!trans)
+		return ERR_PTR(-ENOMEM);
+
+	trans->write = p9_shm_write;
+	trans->read = p9_shm_read;
+	trans->close = p9_shm_close;
+	trans->poll = p9_shm_poll;
+
+	chan = (struct chan_pipe *) big_ugly_buffer;
+	P9_DPRINTK(P9_DEBUG_TRANS, "channel magic: %8.8x ...\n", chan->magic);
+	while (chan->magic != CHAN_MAGIC)
+		yield();
+	P9_DPRINTK(P9_DEBUG_TRANS, "channel state: %8.8x ...\n", chan->state);
+	while (chan->state != Shm_Announced)
+		yield();
+	P9_DPRINTK(P9_DEBUG_TRANS, "Shm_Connecting ...\n");
+	chan->state = Shm_Connecting;
+	while (chan->state != Shm_Connected)
+		yield();
+	P9_DPRINTK(P9_DEBUG_TRANS, "Shm_Connected\n");
+
+	trans->priv = (void *) chan;
+	return trans;
+}
+
+static struct p9_trans_module p9_shm_trans = {
+	.name = "shm",
+	.maxsize = BIG_UGLY_BUFFER_SZ,
+	.def = 0,
+	.create = p9_trans_create_shm,
+};
+
+static int __init p9_trans_shm_init(void)
+{
+	v9fs_register_trans(&p9_shm_trans);
+
+	return 1;
+}
+
+static void __exit p9_trans_shm_exit(void) {
+	printk(KERN_ERR "Removal of 9p transports not implemented\n");
+	BUG();
+}
+
+module_init(p9_trans_shm_init);
+module_exit(p9_trans_shm_exit);
+
+MODULE_AUTHOR("Eric Van Hensbergen <ericvh@gmail.com>");
+MODULE_LICENSE("GPL");
-- 
1.5.0.2.gfbe3d-dirty

