Return-Path: <linux-kernel-owner+w=401wt.eu-S1753269AbZJLFhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269AbZJLFhq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 01:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753144AbZJLFhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 01:37:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60101 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753025AbZJLFhl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 01:37:41 -0400
From: Amit Shah <amit.shah@redhat.com>
To: rusty@rustcorp.com.au
Cc: virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Amit Shah <amit.shah@redhat.com>
Subject: [PATCH v8 1/1] virtio_console: Add support for multiple ports for generic guest and host communication
Date: Mon, 12 Oct 2009 11:06:31 +0530
Message-Id: <1255325791-9086-2-git-send-email-amit.shah@redhat.com>
In-Reply-To: <1255325791-9086-1-git-send-email-amit.shah@redhat.com>
References: <1255325791-9086-1-git-send-email-amit.shah@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Expose multiple char devices ("ports") for simple communication
between the host userspace and guest.

Sample offline usages can be: poking around in a guest to find out
the file systems used, applications installed, etc. Online usages
can be sharing of clipboard data between the guest and the host,
sending information about logged-in users to the host, locking the
screen or session when a vnc session is closed, and so on.

This patch also enables spawning of multiple console ports that
can be attached to hvc consoles.

The interface presented to guest userspace is of a simple char
device, so it can be used like this:

    fd = open("/dev/vcon2", O_RDWR);
    ret = read(fd, buf, 100);
    ret = write(fd, string, strlen(string));

A name property, if set by the host, is exposed in

    /sys/class/virtio-console/vconNN/name

that can be used to create symlinks by udev scripts, example:

    /dev/vcon/org.libvirt.channel.0  -> /dev/vcon1

For requirements, use-cases and some history see

    http://www.linux-kvm.org/page/VMchannel_Requirements

Signed-off-by: Amit Shah <amit.shah@redhat.com>
Acked-by: Christian Borntraeger <borntraeger@de.ibm.com> (console)
---
 drivers/char/Kconfig           |    6 +
 drivers/char/virtio_console.c  | 1290 +++++++++++++++++++++++++++++++++++-----
 include/linux/virtio_console.h |   50 ++-
 3 files changed, 1210 insertions(+), 136 deletions(-)

diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 08a6f50..fc8a04e 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -679,6 +679,12 @@ config VIRTIO_CONSOLE
 	help
 	  Virtio console for use with lguest and other hypervisors.
 
+	  Also serves as a general-purpose serial device for data
+	  transfer between the guest and host. Character devices at
+	  /dev/vconNN will be created when corresponding ports are
+	  found. If specified by the host, a sysfs attribute called
+	  'name' will be populated with a name for the port which can
+	  be used by udev scripts to create a symlink to /dev/vconNN.
 
 config HVCS
 	tristate "IBM Hypervisor Virtual Console Server support"
diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index 0d328b5..0775d25 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -9,10 +9,8 @@
  * functions.
  :*/
 
-/*M:002 The console can be flooded: while the Guest is processing input the
- * Host can send more.  Buffering in the Host could alleviate this, but it is a
- * difficult problem in general. :*/
 /* Copyright (C) 2006, 2007 Rusty Russell, IBM Corporation
+ * Copyright (C) 2009, Amit Shah, Red Hat, Inc.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -28,115 +26,577 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
+
+#include <linux/cdev.h>
+#include <linux/device.h>
 #include <linux/err.h>
+#include <linux/fs.h>
 #include <linux/init.h>
+#include <linux/poll.h>
+#include <linux/sched.h>
+#include <linux/spinlock.h>
 #include <linux/virtio.h>
 #include <linux/virtio_ids.h>
 #include <linux/virtio_console.h>
+#include <linux/workqueue.h>
 #include "hvc_console.h"
 
-/*D:340 These represent our input and output console queues, and the virtio
- * operations for them. */
-static struct virtqueue *in_vq, *out_vq;
-static struct virtio_device *vdev;
+/* This struct stores data that's common to all the ports */
+struct virtio_console_struct {
+	/*
+	 * Workqueue handlers where we process deferred work after an
+	 * interrupt
+	 */
+	struct work_struct rx_work;
+	struct work_struct tx_work;
+	struct work_struct config_work;
 
-/* This is our input buffer, and how much data is left in it. */
-static unsigned int in_len;
-static char *in, *inbuf;
+	struct list_head port_head;
+	struct list_head unused_read_head;
+	struct list_head unused_write_head;
 
-/* The operations for our console. */
-static struct hv_ops virtio_cons;
+	/* To protect the list of unused write buffers and the out_vq */
+	spinlock_t write_list_lock;
+
+	struct virtio_device *vdev;
+	struct class *class;
+	/* The input and the output queues */
+	struct virtqueue *in_vq, *out_vq;
+
+	/* The current config space is stored here */
+	struct virtio_console_config config;
+};
+
+/* This struct holds individual buffers received for each port */
+struct virtio_console_port_buffer {
+	struct list_head next;
+
+	char *buf;
+
+	/* length of the buffer */
+	size_t len;
+	/* offset in the buf from which to consume data */
+	size_t offset;
+};
+
+/* This struct holds the per-port data */
+struct virtio_console_port {
+	/* Next port in the list, head is in the virtio_console_struct */
+	struct list_head next;
+
+	/* Pointer to the virtio_console device */
+	struct virtio_console_struct *vcon;
+
+	/* Buffer management */
+	struct list_head readbuf_head;
+
+	/*
+	 * To protect the readbuf_head list. Has to be a spinlock
+	 * because it can be called from interrupt context
+	 * (cons_get_char())
+	 */
+	spinlock_t readbuf_list_lock;
+
+	/* A waitqueue for poll() or blocking read operations */
+	wait_queue_head_t waitqueue;
+
+	/* Each port associates with a separate char device */
+	struct cdev cdev;
+	struct device *dev;
+
+	/* The hvc device, if this port is associated with a console */
+	struct hvc_struct *hvc;
+
+	/* The 'name' of the port that we expose via sysfs properties */
+	char *name;
+
+	/* The 'id' to identify the port with the Host */
+	u32 id;
+
+	/*
+	 * If this port is a console port, this number identifies the
+	 * number that we used to register with hvc in
+	 * hvc_instantiate() and hvc_alloc().
+	 */
+	u32 vtermno;
 
-/* The hvc device */
-static struct hvc_struct *hvc;
+	/*
+	 * The Host can set some limit to the number of outstanding
+	 * buffers we can have in the readbuf_head list before we
+	 * should ask the Host to stop any more data from coming
+	 * in. This is to not allow a rogue process on the Host to OOM
+	 * the entire guest.
+	 */
+	u32 buffer_limit;
 
-/*D:310 The put_chars() callback is pretty straightforward.
+	/*
+	 * The actual number of buffers we have pending in the
+	 * readbuf_head list
+	 */
+	u32 nr_buffers;
+
+	/* Is the host device open */
+	bool host_connected;
+
+	/* Does the Host not want to accept more data currently?  */
+	bool host_throttled;
+
+	/* Have we sent out a throttle request to the Host? */
+	bool guest_throttled;
+
+	/* Does the port want to cache data when disconnected? */
+	bool cache_buffers;
+};
+
+static struct virtio_console_struct virtconsole;
+
+/*
+ * This is used to keep track of the number of hvc consoles spawned.
+ * This number is given as first argument to hvc_alloc(). We could as
+ * well pass on the minor number of the char device but to correctly
+ * map an initial console spawned via hvc_instantiate to the console
+ * being hooked up via hvc_alloc, we need to pass the same vtermno.
  *
- * We turn the characters into a scatter-gather list, add it to the output
- * queue and then kick the Host.  Then we sit here waiting for it to finish:
- * inefficient in theory, but in practice implementations will do it
- * immediately (lguest's Launcher does). */
-static int put_chars(u32 vtermno, const char *buf, int count)
+ * With this int, we just assume the first console being initialised
+ * was the first one that got used as the initial console.
+ */
+static unsigned int hvc_vtermno;
+
+static struct virtio_console_port *get_port_from_vtermno(u32 vtermno)
 {
-	struct scatterlist sg[1];
-	unsigned int len;
+	struct virtio_console_port *port;
 
-	/* This is a convenient routine to initialize a single-elem sg list */
-	sg_init_one(sg, buf, count);
+	list_for_each_entry(port, &virtconsole.port_head, next) {
+		if (port->hvc && port->vtermno == vtermno)
+			return port;
+	}
+	return NULL;
+}
 
-	/* add_buf wants a token to identify this buffer: we hand it any
-	 * non-NULL pointer, since there's only ever one buffer. */
-	if (out_vq->vq_ops->add_buf(out_vq, sg, 1, 0, (void *)1) >= 0) {
-		/* Tell Host to go! */
-		out_vq->vq_ops->kick(out_vq);
-		/* Chill out until it's done with the buffer. */
-		while (!out_vq->vq_ops->get_buf(out_vq, &len))
-			cpu_relax();
+static struct virtio_console_port *get_port_from_devt(dev_t devt)
+{
+	struct virtio_console_port *port;
+
+	list_for_each_entry(port, &virtconsole.port_head, next) {
+		if (port->dev->devt == devt)
+			return port;
 	}
+	return NULL;
+}
+
+static struct virtio_console_port *get_port_from_id(u32 id)
+{
+	struct virtio_console_port *port;
 
-	/* We're expected to return the amount of data we wrote: all of it. */
-	return count;
+	list_for_each_entry(port, &virtconsole.port_head, next) {
+		if (port->id == id)
+			return port;
+	}
+	return NULL;
+}
+
+static int get_id_from_port(struct virtio_console_port *port)
+{
+	return port->id;
+}
+
+static bool is_console_port(struct virtio_console_port *port)
+{
+	if (port->hvc)
+		return true;
+	return false;
+}
+
+static inline bool use_multiport(struct virtio_console_struct *vcon)
+{
+	/*
+	 * This condition can be true when put_chars is called from
+	 * early_init
+	 */
+	if (!vcon->vdev)
+		return 0;
+	return vcon->vdev->features[0] & (1 << VIRTIO_CONSOLE_F_MULTIPORT);
 }
 
-/* Create a scatter-gather list representing our input buffer and put it in the
- * queue. */
-static void add_inbuf(void)
+static inline bool is_internal(u32 flags)
 {
+	return flags & VIRTIO_CONSOLE_ID_INTERNAL;
+}
+
+static ssize_t send_buf(struct virtio_console_port *port,
+			const char *in_buf, size_t in_count,
+			u32 flags, bool from_user)
+{
+	struct virtqueue *out_vq;
+	struct virtio_console_port_buffer *buf, *buf2;
 	struct scatterlist sg[1];
-	sg_init_one(sg, inbuf, PAGE_SIZE);
+	struct virtio_console_header header;
+	size_t in_offset, copy_size;
+	ssize_t ret;
+	unsigned int header_len;
 
-	/* We should always be able to add one buffer to an empty queue. */
-	if (in_vq->vq_ops->add_buf(in_vq, sg, 0, 1, inbuf) < 0)
-		BUG();
-	in_vq->vq_ops->kick(in_vq);
+	if (!in_count)
+		return 0;
+
+	out_vq = port->vcon->out_vq;
+	/*
+	 * We should not send internal messages to a host that won't
+	 * understand them
+	 */
+	if (!use_multiport(port->vcon) && is_internal(flags))
+		return 0;
+	header_len = 0;
+	if (use_multiport(port->vcon)) {
+		header.id = get_id_from_port(port);
+		header.flags = flags;
+		header.size = in_count;
+		header_len = sizeof(header);
+	}
+	in_offset = 0; /* offset in the user buffer */
+	while (in_count - in_offset) {
+		copy_size = min(in_count - in_offset + header_len, PAGE_SIZE);
+
+		spin_lock(&port->vcon->write_list_lock);
+		list_for_each_entry_safe(buf, buf2,
+					 &port->vcon->unused_write_head,
+					 next) {
+			list_del(&buf->next);
+			break;
+		}
+		spin_unlock(&port->vcon->write_list_lock);
+		if (!buf)
+			break;
+		if (header_len) {
+			memcpy(buf->buf, &header, header_len);
+			copy_size -= header_len;
+		}
+		if (from_user) {
+			ret = copy_from_user(buf->buf + header_len,
+					     in_buf + in_offset, copy_size);
+		} else {
+			/*
+			 * Since we're not sure when the host will actually
+			 * consume the data and tell us about it, we have
+			 * to copy the data here in case the caller
+			 * frees the in_buf
+			 */
+			memcpy(buf->buf + header_len,
+			       in_buf + in_offset, copy_size);
+			ret = 0; /* Emulate copy_from_user behaviour */
+		}
+		buf->len = header_len + copy_size - ret;
+		sg_init_one(sg, buf->buf, buf->len);
+
+		spin_lock(&port->vcon->write_list_lock);
+		ret = out_vq->vq_ops->add_buf(out_vq, sg, 1, 0, buf);
+		spin_unlock(&port->vcon->write_list_lock);
+		if (ret < 0) {
+			memset(buf->buf, 0, buf->len);
+			spin_lock(&virtconsole.write_list_lock);
+			list_add_tail(&buf->next,
+				      &port->vcon->unused_write_head);
+			spin_unlock(&port->vcon->write_list_lock);
+			break;
+		}
+		in_offset += buf->len - header_len;
+		/*
+		 * Only send size with the first buffer.  This way
+		 * userspace can find out a continuous stream of data
+		 * belonging to one write request and consume it
+		 * appropriately
+		 */
+		header.size = 0;
+
+		/* No space left in the vq anyway */
+		if (!ret)
+			break;
+	}
+	/* Tell Host to go! */
+	spin_lock(&port->vcon->write_list_lock);
+	out_vq->vq_ops->kick(out_vq);
+	spin_unlock(&port->vcon->write_list_lock);
+
+	/* We're expected to return the amount of data we wrote */
+	return in_offset;
 }
 
-/*D:350 get_chars() is the callback from the hvc_console infrastructure when
- * an interrupt is received.
- *
- * Most of the code deals with the fact that the hvc_console() infrastructure
- * only asks us for 16 bytes at a time.  We keep in_offset and in_used fields
- * for partially-filled buffers. */
-static int get_chars(u32 vtermno, char *buf, int count)
+/*
+ * Give out the data that's requested from the buffers that we have
+ * queued up per port
+ */
+static ssize_t fill_readbuf(struct virtio_console_port *port,
+			    char *out_buf, size_t out_count, bool to_user)
 {
-	/* If we don't have an input queue yet, we can't get input. */
-	BUG_ON(!in_vq);
+	struct virtio_console_port_buffer *buf, *buf2;
+	ssize_t out_offset, ret;
+
+	out_offset = 0;
+	/*
+	 * Not taking the port->readbuf_list_lock here relying on the
+	 * fact that buffers are taken out from the list only in this
+	 * function so buf2 should be available all the time.
+	 *
+	 * Also, copy_to_user() might sleep.
+	 */
+	list_for_each_entry_safe(buf, buf2, &port->readbuf_head, next) {
+		size_t copy_size;
+
+		copy_size = out_count;
+		if (copy_size > buf->len - buf->offset)
+			copy_size = buf->len - buf->offset;
+
+		if (to_user) {
+			ret = copy_to_user(out_buf + out_offset,
+					   buf->buf + buf->offset,
+					   copy_size);
+			/* FIXME: Deal with ret != 0 */
+		} else {
+			memcpy(out_buf + out_offset,
+			       buf->buf + buf->offset,
+			       copy_size);
+			ret = 0; /* Emulate copy_to_user behaviour */
+		}
+
+		/* Return the number of bytes actually copied */
+		ret = copy_size - ret;
+		buf->offset += ret;
+		out_offset += ret;
+		out_count -= ret;
+
+		if (buf->len - buf->offset == 0) {
+			spin_lock(&port->readbuf_list_lock);
+			list_del(&buf->next);
+			port->nr_buffers--;
+			spin_unlock(&port->readbuf_list_lock);
+			kfree(buf->buf);
+			kfree(buf);
+		}
+		if (!out_count)
+			break;
+	}
+	if (port->guest_throttled && port->nr_buffers < port->buffer_limit) {
+		struct virtio_console_control cpkt;
+
+		cpkt.event = VIRTIO_CONSOLE_THROTTLE_PORT;
+		cpkt.value = false;
+		send_buf(port, (char *)&cpkt, sizeof(cpkt),
+			 VIRTIO_CONSOLE_ID_INTERNAL, false);
+		port->guest_throttled = false;
+	}
+	return out_offset;
+}
+
+/* The condition that must be true for polling to end */
+static bool wait_is_over(struct virtio_console_port *port)
+{
+	return !list_empty(&port->readbuf_head) || !port->host_connected;
+}
 
-	/* No buffer?  Try to get one. */
-	if (!in_len) {
-		in = in_vq->vq_ops->get_buf(in_vq, &in_len);
-		if (!in)
+static ssize_t virtconsole_read(struct file *filp, char __user *ubuf,
+			       size_t count, loff_t *offp)
+{
+	struct virtio_console_port *port;
+	ssize_t ret;
+
+	port = filp->private_data;
+
+	if (list_empty(&port->readbuf_head)) {
+		/*
+		 * If nothing's connected on the host just return 0 in
+		 * case of list_empty; this tells the userspace app
+		 * that there's no connection
+		 */
+		if (!port->host_connected)
 			return 0;
+		if (filp->f_flags & O_NONBLOCK)
+			return -EAGAIN;
+
+		ret = wait_event_interruptible(port->waitqueue,
+					       wait_is_over(port));
+		if (ret < 0)
+			return ret;
 	}
+	/*
+	 * We could've received a disconnection message while we were
+	 * waiting for more data.
+	 *
+	 * This check is not clubbed in the if() statement above as we
+	 * might receive some data as well as the host could get
+	 * disconnected after we got woken up from our wait. So we
+	 * really want to give off whatever data we have and only then
+	 * check for host_connected
+	 */
+	if (list_empty(&port->readbuf_head) && !port->host_connected)
+		return 0;
 
-	/* You want more than we have to give?  Well, try wanting less! */
-	if (in_len < count)
-		count = in_len;
+	return fill_readbuf(port, ubuf, count, true);
+}
+
+static ssize_t virtconsole_write(struct file *filp, const char __user *ubuf,
+				 size_t count, loff_t *offp)
+{
+	struct virtio_console_port *port;
 
-	/* Copy across to their buffer and increment offset. */
-	memcpy(buf, in, count);
-	in += count;
-	in_len -= count;
+	port = filp->private_data;
 
-	/* Finished?  Re-register buffer so Host will use it again. */
-	if (in_len == 0)
-		add_inbuf();
+	if (port->host_throttled)
+		return -ENOSPC;
 
-	return count;
+	return send_buf(port, ubuf, count, 0, true);
 }
-/*:*/
 
-/*D:320 Console drivers are initialized very early so boot messages can go out,
- * so we do things slightly differently from the generic virtio initialization
- * of the net and block drivers.
+static unsigned int virtconsole_poll(struct file *filp, poll_table *wait)
+{
+	struct virtio_console_port *port;
+	unsigned int ret;
+
+	port = filp->private_data;
+	poll_wait(filp, &port->waitqueue, wait);
+
+	ret = 0;
+	if (!list_empty(&port->readbuf_head))
+		ret |= POLLIN | POLLRDNORM;
+	if (!port->host_connected)
+		ret |= POLLHUP;
+	if (!port->host_throttled)
+		ret |= POLLOUT;
+
+	return ret;
+}
+
+static int virtconsole_release(struct inode *inode, struct file *filp)
+{
+	struct virtio_console_port *port;
+	struct virtio_console_control cpkt;
+
+	port = filp->private_data;
+
+	/* Notify host of port being closed */
+	cpkt.event = VIRTIO_CONSOLE_PORT_OPEN;
+	cpkt.value = 0;
+	send_buf(filp->private_data, (char *)&cpkt, sizeof(cpkt),
+		 VIRTIO_CONSOLE_ID_INTERNAL, false);
+
+	/*
+	 * If the port doesn't want to cache buffers while closed,
+	 * flush the unread buffers queue
+	 */
+	if (!port->cache_buffers) {
+		struct virtio_console_port_buffer *buf, *buf2;
+
+		spin_lock(&port->readbuf_list_lock);
+		list_for_each_entry_safe(buf, buf2, &port->readbuf_head, next) {
+			list_del(&buf->next);
+			kfree(buf->buf);
+			kfree(buf);
+		}
+		spin_unlock(&port->readbuf_list_lock);
+	}
+	return 0;
+}
+
+static int virtconsole_open(struct inode *inode, struct file *filp)
+{
+	struct cdev *cdev = inode->i_cdev;
+	struct virtio_console_port *port;
+	struct virtio_console_control cpkt;
+
+	port = container_of(cdev, struct virtio_console_port, cdev);
+	filp->private_data = port;
+
+	/* Notify host of port being opened */
+	cpkt.event = VIRTIO_CONSOLE_PORT_OPEN;
+	cpkt.value = 1;
+	send_buf(filp->private_data, (char *)&cpkt, sizeof(cpkt),
+		 VIRTIO_CONSOLE_ID_INTERNAL, false);
+
+	return 0;
+}
+
+/*
+ * The file operations that we support: programs in the guest can open
+ * a console device, read from it, write to it, poll for data and
+ * close it. The devices are at /dev/vconNN
+ */
+static const struct file_operations virtconsole_fops = {
+	.owner = THIS_MODULE,
+	.open  = virtconsole_open,
+	.read  = virtconsole_read,
+	.write = virtconsole_write,
+	.poll  = virtconsole_poll,
+	.release = virtconsole_release,
+};
+
+
+static ssize_t show_port_name(struct device *dev,
+			      struct device_attribute *attr, char *buffer)
+{
+	struct virtio_console_port *port;
+
+	port = get_port_from_devt(dev->devt);
+	if (!port || !port->name)
+		return 0;
+
+	return sprintf(buffer, "%s\n", port->name);
+}
+
+static DEVICE_ATTR(name, S_IRUGO, show_port_name, NULL);
+
+static struct attribute *virtcon_sysfs_entries[] = {
+	&dev_attr_name.attr,
+	NULL
+};
+
+static struct attribute_group virtcon_attribute_group = {
+	.name = NULL,		/* put in device directory */
+	.attrs = virtcon_sysfs_entries,
+};
+
+
+/*D:310
+ * The cons_put_chars() callback is pretty straightforward.
  *
- * At this stage, the console is output-only.  It's too early to set up a
- * virtqueue, so we let the drivers do some boutique early-output thing. */
-int __init virtio_cons_early_init(int (*put_chars)(u32, const char *, int))
+ * We turn the characters into a scatter-gather list, add it to the output
+ * queue and then kick the Host.
+ *
+ * If the data to be outpu spans more than a page, it's split into
+ * page-sized buffers and then individual buffers are pushed to Host.
+ */
+static int cons_put_chars(u32 vtermno, const char *buf, int count)
 {
-	virtio_cons.put_chars = put_chars;
-	return hvc_instantiate(0, 0, &virtio_cons);
+	struct virtio_console_port *port;
+
+	port = get_port_from_vtermno(vtermno);
+	if (!port)
+		return 0;
+
+	return send_buf(port, buf, count, 0, false);
+}
+
+/*D:350
+ * cons_get_chars() is the callback from the hvc_console
+ * infrastructure when an interrupt is received.
+ *
+ * We call out to fill_readbuf that gets us the required data from the
+ * buffers that are queued up.
+ */
+static int cons_get_chars(u32 vtermno, char *buf, int count)
+{
+	struct virtio_console_port *port;
+
+	/* If we don't have an input queue yet, we can't get input. */
+	BUG_ON(!virtconsole.in_vq);
+
+	port = get_port_from_vtermno(vtermno);
+	if (!port)
+		return 0;
+
+	if (list_empty(&port->readbuf_head))
+		return 0;
+
+	return fill_readbuf(port, buf, count, false);
 }
+/*:*/
 
 /*
  * virtio console configuration. This supports:
@@ -153,98 +613,639 @@ static void virtcons_apply_config(struct virtio_device *dev)
 		dev->config->get(dev,
 				 offsetof(struct virtio_console_config, rows),
 				 &ws.ws_row, sizeof(u16));
-		hvc_resize(hvc, ws);
+		/*
+		 * We'll use this way of resizing only for legacy
+		 * support. For newer userspace (VIRTIO_CONSOLE_F_MULTPORT+),
+		 * use internal messages to indicate console size
+		 * changes so that it can be done per-port
+		 */
+		if (!use_multiport(&virtconsole))
+			hvc_resize(get_port_from_id(0)->hvc, ws);
 	}
 }
 
 /*
- * we support only one console, the hvc struct is a global var
  * We set the configuration at this point, since we now have a tty
  */
-static int notifier_add_vio(struct hvc_struct *hp, int data)
+static int cons_notifier_add_vio(struct hvc_struct *hp, int data)
 {
 	hp->irq_requested = 1;
-	virtcons_apply_config(vdev);
+	virtcons_apply_config(virtconsole.vdev);
 
 	return 0;
 }
 
-static void notifier_del_vio(struct hvc_struct *hp, int data)
+static void cons_notifier_del_vio(struct hvc_struct *hp, int data)
 {
 	hp->irq_requested = 0;
 }
 
-static void hvc_handle_input(struct virtqueue *vq)
+/* The operations for our console. */
+static struct hv_ops virtio_cons = {
+	.get_chars = cons_get_chars,
+	.put_chars = cons_put_chars,
+	.notifier_add = cons_notifier_add_vio,
+	.notifier_del = cons_notifier_del_vio,
+	.notifier_hangup = cons_notifier_del_vio,
+};
+
+/*D:320
+ * Console drivers are initialized very early so boot messages can go out,
+ * so we do things slightly differently from the generic virtio initialization
+ * of the net and block drivers.
+ *
+ * At this stage, the console is output-only.  It's too early to set up a
+ * virtqueue, so we let the drivers do some boutique early-output thing.
+ */
+int __init virtio_cons_early_init(int (*put_chars)(u32, const char *, int))
 {
-	if (hvc_poll(hvc))
-		hvc_kick();
+	virtio_cons.put_chars = put_chars;
+	return hvc_instantiate(0, 0, &virtio_cons);
 }
 
-/*D:370 Once we're further in boot, we get probed like any other virtio device.
- * At this stage we set up the output virtqueue.
+int init_port_console(struct virtio_console_port *port)
+{
+	int ret = 0;
+
+	/*
+	 * The Host's telling us this port is a console port. Hook it
+	 * up with an hvc console.
+	 *
+	 * To set up and manage our virtual console, we call
+	 * hvc_alloc().
+	 *
+	 * The first argument of hvc_alloc() is the virtual console
+	 * number.  The second argument is the parameter for the
+	 * notification mechanism (like irq number). We currently
+	 * leave this as zero, virtqueues have implicit notifications.
+	 *
+	 * The third argument is a "struct hv_ops" containing the
+	 * put_chars() get_chars(), notifier_add() and notifier_del()
+	 * pointers.  The final argument is the output buffer size: we
+	 * can do any size, so we put PAGE_SIZE here.
+	 */
+	port->hvc = hvc_alloc(hvc_vtermno, 0, &virtio_cons, PAGE_SIZE);
+	if (IS_ERR(port->hvc)) {
+		ret = PTR_ERR(port->hvc);
+		pr_err("%s: Could not alloc hvc for virtio console port, ret = %d\n",
+		       __func__, ret);
+		port->hvc = NULL;
+	} else {
+		port->vtermno = hvc_vtermno++;
+	}
+	return ret;
+}
+
+/* Any secret messages that the Host and Guest want to share */
+static void handle_control_message(struct virtio_console_port *port,
+				   struct virtio_console_port_buffer *buf)
+{
+	struct virtio_console_control *cpkt;
+	size_t name_size;
+
+	cpkt = (struct virtio_console_control *)(buf->buf + buf->offset);
+
+	switch (cpkt->event) {
+	case VIRTIO_CONSOLE_PORT_OPEN:
+		port->host_connected = cpkt->value;
+		break;
+	case VIRTIO_CONSOLE_PORT_NAME:
+		/*
+		 * Skip the size of the header and the cpkt to get the size
+		 * of the name that was sent
+		 */
+		name_size = buf->len - buf->offset - sizeof(*cpkt) + 1;
+
+		port->name = kmalloc(name_size, GFP_KERNEL);
+		if (!port->name) {
+			pr_err("%s: not enough space to store port name\n",
+			       __func__);
+			break;
+		}
+		strncpy(port->name, buf->buf + buf->offset + sizeof(*cpkt),
+			name_size - 1);
+		port->name[name_size - 1] = 0;
+		break;
+	case VIRTIO_CONSOLE_CONSOLE_PORT:
+		if (!cpkt->value)
+			break;
+		init_port_console(port);
+		/*
+		 * Could remove the port here in case init fails - but
+		 * have to notify the host first
+		 */
+		break;
+	case VIRTIO_CONSOLE_CACHE_BUFFERS:
+		if (!cpkt->value)
+			break;
+		port->cache_buffers = true;
+		break;
+	case VIRTIO_CONSOLE_THROTTLE_PORT:
+		/*
+		 * Hosts can govern some policy to disallow rogue
+		 * processes write indefinitely to ports leading to
+		 * OOM situations.  If we receive this message here,
+		 * it means the Host side of the port either reached
+		 * its max. limit to cache data or signal to us that
+		 * the host is ready to accept more data.
+		 */
+		port->host_throttled = cpkt->value;
+		break;
+	case VIRTIO_CONSOLE_BUFFER_LIMIT:
+		/*
+		 * We can ask the Host to stop sending data to us in
+		 * case some rogue process on the Host injects data to
+		 * OOM the entire guest (as unread buffers keep piling
+		 * up in the kernel space). The Host, via this
+		 * message, can tell us the number of Mbytes to
+		 * buffer.
+		 *
+		 * The calculation is easy: we use 4K-sized pages in
+		 * our readbuf_head list. So on each buffer added to
+		 * the list, increment count by 1 (and decrement by 1
+		 * when one gets removed). So we just store the
+		 * (number-in-MB * 1024) / 4 to calculate the number of
+		 * buffers we can have in the list.
+		 */
+		port->buffer_limit = (u32)cpkt->value * 1024 / 4;
+		break;
+	}
+}
+
+
+static struct virtio_console_port_buffer *get_buf(size_t buf_size)
+{
+	struct virtio_console_port_buffer *buf;
+
+	buf = kzalloc(sizeof(*buf), GFP_KERNEL);
+	if (!buf)
+		goto out;
+	buf->buf = kzalloc(buf_size, GFP_KERNEL);
+	if (!buf->buf) {
+		kfree(buf);
+		goto out;
+	}
+	buf->len = buf_size;
+out:
+	return buf;
+}
+
+static void fill_queue(struct virtqueue *vq, size_t buf_size,
+		       struct list_head *unused_head)
+{
+	struct scatterlist sg[1];
+	struct virtio_console_port_buffer *buf;
+	int ret;
+
+	do {
+		buf = get_buf(buf_size);
+		if (!buf)
+			break;
+		sg_init_one(sg, buf->buf, buf_size);
+
+		ret = vq->vq_ops->add_buf(vq, sg, 0, 1, buf);
+		if (ret < 0) {
+			kfree(buf->buf);
+			kfree(buf);
+			break;
+		}
+		/*
+		 * We have to keep track of the unused buffers so that
+		 * they can be freed when the module is being removed
+		 */
+		list_add_tail(&buf->next, unused_head);
+	} while (ret > 0);
+	vq->vq_ops->kick(vq);
+}
+
+static void fill_receive_queue(struct virtio_console_struct *vcon)
+{
+	fill_queue(vcon->in_vq, PAGE_SIZE, &vcon->unused_read_head);
+}
+
+/*
+ * This function is only called from the init routine so the spinlock
+ * for the unused_write_head list isn't taken
+ */
+static void alloc_write_bufs(struct virtio_console_struct *vcon)
+{
+	struct virtio_console_port_buffer *buf;
+	int i;
+
+	for (i = 0; i < 1024; i++) {
+		buf = get_buf(PAGE_SIZE);
+		if (!buf)
+			break;
+		list_add_tail(&buf->next, &vcon->unused_write_head);
+	}
+}
+
+/*
+ * The workhandler for any buffers that appear on our input queue.
+ * Pick the buffer; if it's some internal communication meant for the
+ * us, just process it. Otherwise queue it up for the read() or
+ * get_chars() routines to pick the data up later.
+ */
+static void virtio_console_rx_work_handler(struct work_struct *work)
+{
+	struct virtio_console_struct *vcon;
+	struct virtio_console_port *port;
+	struct virtio_console_port_buffer *buf;
+	struct virtio_console_header header;
+	struct virtqueue *vq;
+	unsigned int tmplen, header_len;
+
+	vcon = container_of(work, struct virtio_console_struct, rx_work);
+	header_len = use_multiport(vcon) ? sizeof(header) : 0;
+
+	port = NULL;
+	vq = vcon->in_vq;
+	while ((buf = vq->vq_ops->get_buf(vq, &tmplen))) {
+		/* The buffer is no longer unused */
+		list_del(&buf->next);
+
+		if (use_multiport(vcon)) {
+			memcpy(&header, buf->buf, header_len);
+			port = get_port_from_id(header.id);
+		} else {
+			port = get_port_from_id(0);
+		}
+		if (!port) {
+			/* No valid header at start of buffer. Drop it. */
+			pr_debug("%s: invalid index in buffer, %c %d\n",
+				 __func__, buf->buf[0], buf->buf[0]);
+			/*
+			 * OPT: This buffer can be added to the unused
+			 * list to avoid free / alloc
+			 */
+			kfree(buf->buf);
+			kfree(buf);
+			break;
+		}
+		buf->len = tmplen;
+		buf->offset = header_len;
+		if (use_multiport(vcon) && is_internal(header.flags)) {
+			handle_control_message(port, buf);
+			/*
+			 * OPT: This buffer can be added to the unused
+			 * list to avoid free/alloc
+			 */
+			kfree(buf->buf);
+			kfree(buf);
+		} else {
+			spin_lock(&port->readbuf_list_lock);
+			list_add_tail(&buf->next, &port->readbuf_head);
+			port->nr_buffers++;
+			spin_unlock(&port->readbuf_list_lock);
+			/*
+			 * We might have missed a connection
+			 * notification, e.g. before the queues were
+			 * initialised.
+			 */
+			port->host_connected = true;
+			/*
+			 * If we reached the throttle level, send out
+			 * a message to the host to ask it to stop
+			 * sending us any more data.
+			 */
+			if (port->nr_buffers == port->buffer_limit) {
+				struct virtio_console_control cpkt;
+
+				port->guest_throttled = true;
+				cpkt.event = VIRTIO_CONSOLE_THROTTLE_PORT;
+				cpkt.value = true;
+				send_buf(port, (char *)&cpkt, sizeof(cpkt),
+					 VIRTIO_CONSOLE_ID_INTERNAL, false);
+			}
+		}
+		wake_up_interruptible(&port->waitqueue);
+
+		if (is_console_port(port) && !list_empty(&port->readbuf_head))
+			if (hvc_poll(port->hvc))
+				hvc_kick();
+	}
+	/* Allocate buffers for all the ones that got used up */
+	fill_receive_queue(&virtconsole);
+}
+
+/*
+ * This is the workhandler for buffers that get received on the output
+ * virtqueue, which is an indication that Host consumed the data we
+ * sent it. Since all our buffers going out are of a fixed size we can
+ * just reuse them instead of freeing them and allocating new ones.
  *
- * To set up and manage our virtual console, we call hvc_alloc().  Since we
- * never remove the console device we never need this pointer again.
+ * Zero out the buffer so that we don't leak any information from
+ * other processes. There's a small optimisation here as well: the
+ * buffers are PAGE_SIZE-sized; but instead of zeroing the entire
+ * page, we just zero the length that was most recently used and we
+ * can be sure the rest of the page is already set to 0s.
  *
- * Finally we put our input buffer in the input queue, ready to receive. */
-static int __devinit virtcons_probe(struct virtio_device *dev)
+ * So once we zero them out we add them back to the unused buffers
+ * list
+ */
+static void virtio_console_tx_work_handler(struct work_struct *work)
 {
-	vq_callback_t *callbacks[] = { hvc_handle_input, NULL};
+	struct virtio_console_struct *vcon;
+	struct virtqueue *vq;
+	struct virtio_console_port_buffer *buf;
+	unsigned int tmplen;
+
+	vcon = container_of(work, struct virtio_console_struct, tx_work);
+
+	vq = vcon->out_vq;
+	spin_lock(&vcon->write_list_lock);
+	while ((buf = vq->vq_ops->get_buf(vq, &tmplen))) {
+		/* 0 the buffer to not leak data from other processes */
+		memset(buf->buf, 0, buf->len);
+		list_add_tail(&buf->next, &vcon->unused_write_head);
+	}
+	spin_unlock(&vcon->write_list_lock);
+}
+
+static void rx_intr(struct virtqueue *vq)
+{
+	schedule_work(&virtconsole.rx_work);
+}
+
+static void tx_intr(struct virtqueue *vq)
+{
+	schedule_work(&virtconsole.tx_work);
+}
+
+static void config_intr(struct virtio_device *vdev)
+{
+	if (use_multiport(&virtconsole)) {
+		/* Handle port hot-add */
+		schedule_work(&virtconsole.config_work);
+	}
+	/* Handle console size changes */
+	virtcons_apply_config(vdev);
+}
+
+static int virtconsole_add_port(u32 port_nr)
+{
+	struct virtio_console_port *port;
+	struct virtio_console_control cpkt;
+	dev_t devt;
+	int ret;
+
+	port = kzalloc(sizeof(*port), GFP_KERNEL);
+	if (!port)
+		return -ENOMEM;
+
+	port->vcon = &virtconsole;
+	port->id = port_nr;
+
+	cdev_init(&port->cdev, &virtconsole_fops);
+
+	ret = alloc_chrdev_region(&devt, 0, 1, "virtio-console");
+	if (ret < 0) {
+		pr_err("%s: error allocing chrdev region, ret = %d\n",
+		       __func__, ret);
+		goto free_port;
+	}
+	ret = cdev_add(&port->cdev, devt, 1);
+	if (ret < 0) {
+		pr_err("%s: error adding cdev, ret = %d\n", __func__, ret);
+		goto free_chrdev;
+	}
+	port->dev = device_create(port->vcon->class, NULL, devt, NULL,
+				  "vcon%u", port_nr);
+	if (IS_ERR(port->dev)) {
+		ret = PTR_ERR(port->dev);
+		pr_err("%s: error creating device, ret = %d\n", __func__, ret);
+		goto free_cdev;
+	}
+	ret = sysfs_create_group(&port->dev->kobj, &virtcon_attribute_group);
+	if (ret) {
+		pr_err("%s: error creating sysfs device attributes, ret = %d\n",
+		       __func__, ret);
+		goto free_cdev;
+	}
+
+	spin_lock_init(&port->readbuf_list_lock);
+	INIT_LIST_HEAD(&port->readbuf_head);
+	init_waitqueue_head(&port->waitqueue);
+
+	list_add_tail(&port->next, &port->vcon->port_head);
+
+	/*
+	 * Ask for the port's name from Host. The string that we
+	 * receive in 'name' can be of arbitrary length; so pass the
+	 * maximum available buffer size: PAGE_SIZE.
+	 */
+	cpkt.event = VIRTIO_CONSOLE_PORT_NAME;
+	send_buf(port, (char *)&cpkt, sizeof(cpkt),
+		 VIRTIO_CONSOLE_ID_INTERNAL, false);
+
+	/*
+	 * If we're not using multiport support, this has to be a console port
+	 */
+	if (!use_multiport(&virtconsole)) {
+		ret = init_port_console(port);
+		if (ret)
+			goto free_cdev;
+	}
+	return 0;
+free_cdev:
+	cdev_del(&port->cdev);
+free_chrdev:
+	unregister_chrdev_region(devt, 1);
+free_port:
+	kfree(port);
+	return ret;
+}
+
+
+/* The workhandler for config-space updates
+ *
+ * This is used when new ports are added
+ */
+static void virtio_console_config_work_handler(struct work_struct *work)
+{
+	struct virtio_console_struct *vcon;
+	struct virtio_console_config virtconconf;
+	struct virtio_device *vdev;
+	u32 i;
+	int ret;
+
+	vcon = container_of(work, struct virtio_console_struct, config_work);
+
+	vdev = vcon->vdev;
+	vdev->config->get(vdev,
+			  offsetof(struct virtio_console_config, nr_active_ports),
+			  &virtconconf.nr_active_ports,
+			  sizeof(virtconconf.nr_active_ports));
+
+	if (vcon->config.nr_active_ports == virtconconf.nr_active_ports) {
+		/*
+		 * Port 0 got hot-added. Since we already did all the other
+		 * initialisation for it, just ask the Host for the name
+		 * if set
+		 */
+		struct virtio_console_control cpkt;
+		struct virtio_console_port *port;
+
+		port = get_port_from_id(0);
+		cpkt.event = VIRTIO_CONSOLE_PORT_NAME;
+		send_buf(port, (char *)&cpkt, sizeof(cpkt),
+			 VIRTIO_CONSOLE_ID_INTERNAL, false);
+		return;
+	}
+
+	/* Hot-add ports */
+	for (i = virtconsole.config.nr_active_ports;
+	     i < virtconconf.nr_active_ports; i++) {
+		ret = virtconsole_add_port(virtconsole.config.nr_active_ports + i);
+		if (!ret)
+			virtconsole.config.nr_active_ports++;
+	}
+}
+
+/*D:370
+ * Once we're further in boot, we get probed like any other virtio device.
+ * At this stage we set up the output virtqueue.
+ *
+ * Finally we put our input buffer in the input queue, ready to receive.
+ */
+static int __devinit virtcons_probe(struct virtio_device *vdev)
+{
+	vq_callback_t *callbacks[] = { rx_intr, tx_intr };
 	const char *names[] = { "input", "output" };
 	struct virtqueue *vqs[2];
-	int err;
-
-	vdev = dev;
+	u32 i;
+	int ret;
+	bool multiport;
 
-	/* This is the scratch page we use to receive console input */
-	inbuf = kmalloc(PAGE_SIZE, GFP_KERNEL);
-	if (!inbuf) {
-		err = -ENOMEM;
-		goto fail;
+	if (virtconsole.vdev) {
+		pr_err("Multiple virtio-console devices not supported yet\n");
+		return -EEXIST;
 	}
+	virtconsole.vdev = vdev;
+
+	multiport = false;
+	if (virtio_has_feature(vdev, VIRTIO_CONSOLE_F_MULTIPORT)) {
+		multiport = true;
+		vdev->features[0] |= 1 << VIRTIO_CONSOLE_F_MULTIPORT;
+		vdev->config->finalize_features(vdev);
 
+		vdev->config->get(vdev, offsetof(struct virtio_console_config,
+						 nr_active_ports),
+				  &virtconsole.config.nr_active_ports,
+				  sizeof(virtconsole.config.nr_active_ports));
+	}
 	/* Find the queues. */
 	/* FIXME: This is why we want to wean off hvc: we do nothing
 	 * when input comes in. */
-	err = vdev->config->find_vqs(vdev, 2, vqs, callbacks, names);
-	if (err)
-		goto free;
+	ret = vdev->config->find_vqs(vdev, 2, vqs, callbacks, names);
+	if (ret)
+		goto fail;
 
-	in_vq = vqs[0];
-	out_vq = vqs[1];
+	virtconsole.in_vq = vqs[0];
+	virtconsole.out_vq = vqs[1];
+
+	/*
+	 * We had set the virtio_cons put_chars implementation to
+	 * put_chars for early_init. Now that we're done with the
+	 * early init phase, replace it with our cons_put_chars
+	 * implementation.
+	 */
+	virtio_cons.put_chars = cons_put_chars;
+
+	INIT_LIST_HEAD(&virtconsole.port_head);
+	INIT_LIST_HEAD(&virtconsole.unused_read_head);
+	INIT_LIST_HEAD(&virtconsole.unused_write_head);
+
+	INIT_WORK(&virtconsole.rx_work, &virtio_console_rx_work_handler);
+	INIT_WORK(&virtconsole.tx_work, &virtio_console_tx_work_handler);
+	INIT_WORK(&virtconsole.config_work, &virtio_console_config_work_handler);
+	spin_lock_init(&virtconsole.write_list_lock);
+
+	fill_receive_queue(&virtconsole);
+	alloc_write_bufs(&virtconsole);
+
+	virtconsole_add_port(0);
+	if (multiport)
+		for (i = 1; i < virtconsole.config.nr_active_ports; i++)
+			virtconsole_add_port(i);
 
-	/* Start using the new console output. */
-	virtio_cons.get_chars = get_chars;
-	virtio_cons.put_chars = put_chars;
-	virtio_cons.notifier_add = notifier_add_vio;
-	virtio_cons.notifier_del = notifier_del_vio;
-	virtio_cons.notifier_hangup = notifier_del_vio;
-
-	/* The first argument of hvc_alloc() is the virtual console number, so
-	 * we use zero.  The second argument is the parameter for the
-	 * notification mechanism (like irq number). We currently leave this
-	 * as zero, virtqueues have implicit notifications.
-	 *
-	 * The third argument is a "struct hv_ops" containing the put_chars()
-	 * get_chars(), notifier_add() and notifier_del() pointers.
-	 * The final argument is the output buffer size: we can do any size,
-	 * so we put PAGE_SIZE here. */
-	hvc = hvc_alloc(0, 0, &virtio_cons, PAGE_SIZE);
-	if (IS_ERR(hvc)) {
-		err = PTR_ERR(hvc);
-		goto free_vqs;
-	}
-
-	/* Register the input buffer the first time. */
-	add_inbuf();
 	return 0;
 
-free_vqs:
-	vdev->config->del_vqs(vdev);
-free:
-	kfree(inbuf);
 fail:
-	return err;
+	return ret;
+}
+
+/*
+ * Remove port-specific data.
+ * In case the port can't be removed, return non-zero. This could
+ * then be used in the port hot-unplug case.
+ */
+static int virtcons_remove_port_data(struct virtio_console_port *port)
+{
+	struct virtio_console_port_buffer *buf, *buf2;
+
+	if (is_console_port(port)) {
+		/* hvc_console is compiled in, at least on Fedora. */
+		/* hvc_remove(hvc); */
+		return 1;
+	}
+
+	sysfs_remove_group(&port->dev->kobj, &virtcon_attribute_group);
+	device_destroy(virtconsole.class, port->dev->devt);
+	unregister_chrdev_region(port->dev->devt, 1);
+	cdev_del(&port->cdev);
+
+	kfree(port->name);
+
+	/* Remove the buffers in which we have unconsumed data */
+	spin_lock(&port->readbuf_list_lock);
+	list_for_each_entry_safe(buf, buf2, &port->readbuf_head, next) {
+		list_del(&buf->next);
+		kfree(buf->buf);
+		kfree(buf);
+	}
+	spin_unlock(&port->readbuf_list_lock);
+	return 0;
+}
+
+static void virtcons_remove(struct virtio_device *vdev)
+{
+	struct virtio_console_port *port, *port2;
+	struct virtio_console_port_buffer *buf, *buf2;
+	char *tmpbuf;
+	int len;
+
+	class_destroy(virtconsole.class);
+
+	cancel_work_sync(&virtconsole.rx_work);
+	/*
+	 * Free up the buffers that we queued up for the Host to pass
+	 * us data
+	 */
+	while ((tmpbuf = virtconsole.in_vq->vq_ops->get_buf(virtconsole.in_vq,
+							    &len)))
+		kfree(tmpbuf);
+
+	vdev->config->del_vqs(vdev);
+	/*
+	 * Free up the buffers that were sent to us by Host but were
+	 * left unused
+	 */
+	list_for_each_entry_safe(buf, buf2, &virtconsole.unused_read_head, next) {
+		list_del(&buf->next);
+		kfree(buf->buf);
+		kfree(buf);
+	}
+	list_for_each_entry_safe(buf, buf2, &virtconsole.unused_write_head, next) {
+		list_del(&buf->next);
+		kfree(buf->buf);
+		kfree(buf);
+	}
+	list_for_each_entry_safe(port, port2, &virtconsole.port_head, next) {
+		list_del(&port->next);
+		virtcons_remove_port_data(port);
+		kfree(port);
+	}
 }
 
 static struct virtio_device_id id_table[] = {
@@ -254,6 +1255,7 @@ static struct virtio_device_id id_table[] = {
 
 static unsigned int features[] = {
 	VIRTIO_CONSOLE_F_SIZE,
+	VIRTIO_CONSOLE_F_MULTIPORT,
 };
 
 static struct virtio_driver virtio_console = {
@@ -263,14 +1265,34 @@ static struct virtio_driver virtio_console = {
 	.driver.owner =	THIS_MODULE,
 	.id_table =	id_table,
 	.probe =	virtcons_probe,
-	.config_changed = virtcons_apply_config,
+	.remove =	virtcons_remove,
+	.config_changed = config_intr,
 };
 
 static int __init init(void)
 {
-	return register_virtio_driver(&virtio_console);
+	int ret;
+
+	virtconsole.class = class_create(THIS_MODULE, "virtio-console");
+	if (IS_ERR(virtconsole.class)) {
+		pr_err("Error creating virtio-console class\n");
+		ret = PTR_ERR(virtconsole.class);
+		return ret;
+	}
+	ret = register_virtio_driver(&virtio_console);
+	if (ret) {
+		class_destroy(virtconsole.class);
+		return ret;
+	}
+	return 0;
+}
+
+static void __exit fini(void)
+{
+	unregister_virtio_driver(&virtio_console);
 }
 module_init(init);
+module_exit(fini);
 
 MODULE_DEVICE_TABLE(virtio, id_table);
 MODULE_DESCRIPTION("Virtio console driver");
diff --git a/include/linux/virtio_console.h b/include/linux/virtio_console.h
index b5f5198..9ef7f90 100644
--- a/include/linux/virtio_console.h
+++ b/include/linux/virtio_console.h
@@ -2,20 +2,66 @@
 #define _LINUX_VIRTIO_CONSOLE_H
 #include <linux/types.h>
 #include <linux/virtio_config.h>
-/* This header, excluding the #ifdef __KERNEL__ part, is BSD licensed so
- * anyone can use the definitions to implement compatible drivers/servers. */
+/*
+ * This header, excluding the #ifdef __KERNEL__ part, is BSD licensed so
+ * anyone can use the definitions to implement compatible drivers/servers.
+ *
+ * Copyright (C) Red Hat, Inc., 2009
+ */
 
 /* Feature bits */
 #define VIRTIO_CONSOLE_F_SIZE	0	/* Does host provide console size? */
+#define VIRTIO_CONSOLE_F_MULTIPORT 1	/* Does host provide multiple ports? */
+
+#define VIRTIO_CONSOLE_BAD_ID	(~(u32)0) /* Invalid port number */
 
 struct virtio_console_config {
 	/* colums of the screens */
 	__u16 cols;
 	/* rows of the screens */
 	__u16 rows;
+	/* number of ports in use */
+	__u32 nr_active_ports;
 } __attribute__((packed));
 
 
+/*
+ * An internal-only message that's passed between the Host and the
+ * Guest for a particular port.
+ */
+struct virtio_console_control {
+	__u16 event;
+	__u16 value;
+};
+
+/* Some events for internal messages (control packets) */
+#define VIRTIO_CONSOLE_PORT_OPEN	0
+#define VIRTIO_CONSOLE_PORT_NAME	1
+#define VIRTIO_CONSOLE_CONSOLE_PORT	2
+#define VIRTIO_CONSOLE_CACHE_BUFFERS	3
+#define VIRTIO_CONSOLE_THROTTLE_PORT	4
+#define VIRTIO_CONSOLE_BUFFER_LIMIT	5
+
+/*
+ * This struct is put in each buffer that gets passed to userspace and
+ * vice-versa
+ */
+struct virtio_console_header {
+	/* Port number */
+	u32 id;
+	/* Some message between host and guest */
+	u32 flags;
+	/*
+	 * Complete size of the write request - only sent with the
+	 * first buffer for each write request
+	 */
+	u32 size;
+} __attribute__((packed));
+
+/* Messages between host and guest ('flags' field in the header above) */
+#define VIRTIO_CONSOLE_ID_INTERNAL	(1 << 0)
+
+
 #ifdef __KERNEL__
 int __init virtio_cons_early_init(int (*put_chars)(u32, const char *, int));
 #endif /* __KERNEL__ */
-- 
1.6.2.5

