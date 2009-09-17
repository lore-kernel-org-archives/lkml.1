Return-Path: <linux-kernel-owner+w=401wt.eu-S1757712AbZIQNmN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757712AbZIQNmN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 09:42:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754341AbZIQNmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 09:42:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40067 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752542AbZIQNmK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 09:42:10 -0400
Date: Thu, 17 Sep 2009 19:11:25 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Markus Armbruster <armbru@redhat.com>,
       Anthony Liguori <anthony@codemonkey.ws>, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, greg@kroah.com
Subject: Re: [PATCH] virtio_console: Add support for multiple ports for
	generic guest and host communication
Message-ID: <20090917134125.GA27511@amit-x200.redhat.com>
References: <1252678386-17404-2-git-send-email-amit.shah@redhat.com> <20090911170010.34c80f2d@linux.intel.com> <20090911163806.GB25535@amit-x200.redhat.com> <4AAA8838.1080106@codemonkey.ws> <20090911173307.GB27046@amit-x200.redhat.com> <4AAA8A56.3040707@codemonkey.ws> <20090916112332.6bf981a5@linux.intel.com> <4AB164A0.8000402@codemonkey.ws> <87tyz1en5f.fsf@pike.pond.sub.org> <20090917141531.4d2489d4@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090917141531.4d2489d4@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Thu) Sep 17 2009 [14:15:31], Alan Cox wrote:
> > Well, really fundamentally, this is just a reliable full-duplex byte
> > stream, with connect and hangup notification.  To me, that sounds more
> > like TCP with an address family almost, but not quite AF_UNIX, but that
> > case was thrown out of court long ago, so here we are.
> 
> Well the tty one has also been thrown out of court because its even dumber
> 
> To be honest it sounds more to me like either a pipe or a char device, or
> in most cases like sysfs.

It's a char device as of now and I've added a 'name' attribute to each
device that can be found in

/sys/class/virtio-console/vconNN/name

Gerd's suggested udev script can then create a symlink from, eg.,

/dev/vconNN -> /dev/virtio/console/org/qemu/clipboard

I've not ripped out the code that allocates the port numbers in
userspace and also the code where the ports can occur in any range
between 0..max_nr_ports. It will result in some simplification.

So here's the code, just an rfc.

Alan, I'm not sure how many ports at a time people would want to use so
allocating one major device for this seems OK?

		Amit

diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 6a06913..fe76627 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -678,7 +678,9 @@ config VIRTIO_CONSOLE
 	select HVC_DRIVER
 	help
 	  Virtio console for use with lguest and other hypervisors.
-
+	  Also serves as a general-purpose serial device for data transfer
+	  between the guest and host. Character devices at /dev/vconNN will
+	  be created when corresponding ports are found.
 
 config HVCS
 	tristate "IBM Hypervisor Virtual Console Server support"
diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index 0d328b5..009e1b0 100644
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
@@ -28,115 +26,456 @@
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
+	/* To protect the list of unused write buffers */
+	spinlock_t write_list_lock;
 
-/* The hvc device */
-static struct hvc_struct *hvc;
+	struct virtio_device *vdev;
+	struct class *class;
+	/* The input and the output queues */
+	struct virtqueue *in_vq, *out_vq;
 
-/*D:310 The put_chars() callback is pretty straightforward.
- *
- * We turn the characters into a scatter-gather list, add it to the output
- * queue and then kick the Host.  Then we sit here waiting for it to finish:
- * inefficient in theory, but in practice implementations will do it
- * immediately (lguest's Launcher does). */
-static int put_chars(u32 vtermno, const char *buf, int count)
+	/* The current config space is stored here */
+	struct virtio_console_config *config;
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
+	/* Buffer management */
+	struct list_head readbuf_head;
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
+	/* Is the host device open */
+	bool host_connected;
+};
+
+static struct virtio_console_struct virtconsole;
+
+static int major = 60; /* from the experimental range */
+
+static struct virtio_console_port *get_port_from_id(u32 id)
 {
-	struct scatterlist sg[1];
-	unsigned int len;
-
-	/* This is a convenient routine to initialize a single-elem sg list */
-	sg_init_one(sg, buf, count);
-
-	/* add_buf wants a token to identify this buffer: we hand it any
-	 * non-NULL pointer, since there's only ever one buffer. */
-	if (out_vq->vq_ops->add_buf(out_vq, sg, 1, 0, (void *)1) >= 0) {
-		/* Tell Host to go! */
-		out_vq->vq_ops->kick(out_vq);
-		/* Chill out until it's done with the buffer. */
-		while (!out_vq->vq_ops->get_buf(out_vq, &len))
-			cpu_relax();
+	struct virtio_console_port *port;
+
+	list_for_each_entry(port, &virtconsole.port_head, next) {
+		if (MINOR(port->dev->devt) == id)
+			return port;
 	}
+	return NULL;
+}
 
-	/* We're expected to return the amount of data we wrote: all of it. */
-	return count;
+static int get_id_from_port(struct virtio_console_port *port)
+{
+	return MINOR(port->dev->devt);
 }
 
-/* Create a scatter-gather list representing our input buffer and put it in the
- * queue. */
-static void add_inbuf(void)
+static bool is_console_port(struct virtio_console_port *port)
 {
-	struct scatterlist sg[1];
-	sg_init_one(sg, inbuf, PAGE_SIZE);
+	u32 port_nr = get_id_from_port(port);
 
-	/* We should always be able to add one buffer to an empty queue. */
-	if (in_vq->vq_ops->add_buf(in_vq, sg, 0, 1, inbuf) < 0)
-		BUG();
-	in_vq->vq_ops->kick(in_vq);
+	if (port_nr == VIRTIO_CONSOLE_CONSOLE_PORT ||
+	    port_nr == VIRTIO_CONSOLE_CONSOLE2_PORT)
+		return true;
+	return false;
 }
 
-/*D:350 get_chars() is the callback from the hvc_console infrastructure when
- * an interrupt is received.
- *
- * Most of the code deals with the fact that the hvc_console() infrastructure
- * only asks us for 16 bytes at a time.  We keep in_offset and in_used fields
- * for partially-filled buffers. */
-static int get_chars(u32 vtermno, char *buf, int count)
+static inline bool use_multiport(void)
 {
-	/* If we don't have an input queue yet, we can't get input. */
-	BUG_ON(!in_vq);
+	/*
+	 * This condition can be true when put_chars is called from
+	 * early_init
+	 */
+	if (!virtconsole.vdev)
+		return 0;
+	return virtconsole.vdev->features[0] & (1 << VIRTIO_CONSOLE_F_MULTIPORT);
+}
+
+static inline bool is_internal(u32 flags)
+{
+	return flags & VIRTIO_CONSOLE_ID_INTERNAL;
+}
+
+/*
+ * Give out the data that's requested from the buffers that we have
+ * queued up per port
+ */
+static ssize_t fill_readbuf(struct virtio_console_port *port,
+			    char *out_buf, size_t out_count, bool to_user)
+{
+	struct virtio_console_port_buffer *buf, *buf2;
+	ssize_t out_offset, ret;
+
+	out_offset = 0;
+	list_for_each_entry_safe(buf, buf2, &port->readbuf_head, next) {
+		size_t copy_size;
 
-	/* No buffer?  Try to get one. */
-	if (!in_len) {
-		in = in_vq->vq_ops->get_buf(in_vq, &in_len);
-		if (!in)
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
+			list_del(&buf->next);
+			kfree(buf->buf);
+			kfree(buf);
+		}
+		if (!out_count)
+			break;
+	}
+	return out_offset;
+}
+
+/* The condition that must be true for polling to end */
+static bool wait_is_over(struct virtio_console_port *port)
+{
+	return !list_empty(&port->readbuf_head) || !port->host_connected;
+}
+
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
 
-	/* Copy across to their buffer and increment offset. */
-	memcpy(buf, in, count);
-	in += count;
-	in_len -= count;
+static ssize_t send_buf(struct virtio_console_port *port,
+			const char *in_buf, size_t in_count,
+			u32 flags, bool from_user)
+{
+	struct virtqueue *out_vq;
+	struct virtio_console_port_buffer *buf, *buf2;
+	struct scatterlist sg[1];
+	struct virtio_console_header header;
+	size_t in_offset, copy_size;
+	ssize_t ret;
+	unsigned int header_len;
 
-	/* Finished?  Re-register buffer so Host will use it again. */
-	if (in_len == 0)
-		add_inbuf();
+	if (!in_count)
+		return 0;
 
-	return count;
+	out_vq = virtconsole.out_vq;
+	/*
+	 * We should not send internal messages to a host that won't
+	 * understand them
+	 */
+	if (!use_multiport() && is_internal(flags))
+		return 0;
+	header_len = 0;
+	if (use_multiport()) {
+		header.id = get_id_from_port(port);
+		header.flags = flags;
+		header.size = in_count;
+		header_len = sizeof(header);
+	}
+	in_offset = 0; /* offset in the user buffer */
+	while (in_count - in_offset) {
+		copy_size = min(in_count - in_offset + header_len, PAGE_SIZE);
+
+		spin_lock(&virtconsole.write_list_lock);
+		list_for_each_entry_safe(buf, buf2,
+					 &virtconsole.unused_write_head,
+					 next) {
+			list_del(&buf->next);
+			break;
+		}
+		spin_unlock(&virtconsole.write_list_lock);
+		if (!buf)
+			break;
+		if (header_len) {
+			memcpy(buf->buf, &header, header_len);
+			copy_size -= header_len;
+		}
+		if (from_user)
+			ret = copy_from_user(buf->buf + header_len,
+					     in_buf + in_offset, copy_size);
+		else {
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
+		ret = out_vq->vq_ops->add_buf(out_vq, sg, 1, 0, buf);
+		if (ret < 0) {
+			memset(buf->buf, 0, buf->len);
+			spin_lock(&virtconsole.write_list_lock);
+			list_add_tail(&buf->next,
+				      &virtconsole.unused_write_head);
+			spin_unlock(&virtconsole.write_list_lock);
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
+	out_vq->vq_ops->kick(out_vq);
+
+	/* We're expected to return the amount of data we wrote */
+	return in_offset;
 }
-/*:*/
 
-/*D:320 Console drivers are initialized very early so boot messages can go out,
- * so we do things slightly differently from the generic virtio initialization
- * of the net and block drivers.
+static ssize_t virtconsole_write(struct file *filp, const char __user *ubuf,
+				 size_t count, loff_t *offp)
+{
+	struct virtio_console_port *port;
+
+	port = filp->private_data;
+
+	return send_buf(port, ubuf, count, 0, true);
+}
+
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
+
+	return ret;
+}
+
+static int virtconsole_release(struct inode *inode, struct file *filp)
+{
+	struct virtio_console_control cpkt;
+
+	/* Notify host of port being closed */
+	cpkt.event = VIRTIO_CONSOLE_PORT_OPEN;
+	cpkt.value = 0;
+	send_buf(filp->private_data, (char *)&cpkt, sizeof(cpkt),
+		 VIRTIO_CONSOLE_ID_INTERNAL, false);
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
+	port = get_port_from_id(MINOR(dev->devt));
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
+	port = get_port_from_id(vtermno);
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
+	port = get_port_from_id(vtermno);
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
@@ -153,98 +492,628 @@ static void virtcons_apply_config(struct virtio_device *dev)
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
+		hvc_resize(get_port_from_id(VIRTIO_CONSOLE_CONSOLE_PORT)->hvc, ws);
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
+{
+	virtio_cons.put_chars = put_chars;
+	return hvc_instantiate(0, 0, &virtio_cons);
+}
+
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
+		/* We have to keep track of the unused buffers
+		 * so that they can be freed when the module
+		 * is being removed
+		 */
+		list_add_tail(&buf->next, unused_head);
+	} while (ret > 0);
+	vq->vq_ops->kick(vq);
+}
+
+static void fill_receive_queue(void)
+{
+	fill_queue(virtconsole.in_vq, PAGE_SIZE, &virtconsole.unused_read_head);
+}
+
+/*
+ * This function is only called from the init routine so the spinlock
+ * for the unused_write_head list isn't taken
+ */
+static void alloc_write_bufs(void)
+{
+	struct virtio_console_port_buffer *buf;
+	int i;
+
+	for (i = 0; i < 1024; i++) {
+		buf = get_buf(PAGE_SIZE);
+		if (!buf)
+			break;
+		list_add_tail(&buf->next, &virtconsole.unused_write_head);
+	}
+}
+
+/*
+ * The workhandle for any buffers that appear on our input queue.
+ * Pick the buffer; if it's some communication meant for the Guest,
+ * just process it. Otherwise queue it up for the read() or
+ * get_chars() routines to pick the data up later.
+ */
+static void virtio_console_rx_work_handler(struct work_struct *work)
 {
-	if (hvc_poll(hvc))
+	struct virtio_console_port *port;
+	struct virtio_console_port_buffer *buf;
+	struct virtio_console_header header;
+	struct virtqueue *vq;
+	unsigned int tmplen, header_len;
+
+	header_len = use_multiport() ? sizeof(header) : 0;
+
+	port = NULL;
+	vq = virtconsole.in_vq;
+	while ((buf = vq->vq_ops->get_buf(vq, &tmplen))) {
+		/* The buffer is no longer unused */
+		list_del(&buf->next);
+
+		if (use_multiport()) {
+			memcpy(&header, buf->buf, header_len);
+			port = get_port_from_id(header.id);
+		} else
+			port = get_port_from_id(VIRTIO_CONSOLE_CONSOLE_PORT);
+		if (!port) {
+			 /* No valid header at start of buffer. Drop it. */
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
+		if (use_multiport() && is_internal(header.flags)) {
+			handle_control_message(port, buf);
+			/*
+			 * OPT: This buffer can be added to the unused
+			 * list to avoid free/alloc
+			 */
+			kfree(buf->buf);
+			kfree(buf);
+		} else {
+			list_add_tail(&buf->next, &port->readbuf_head);
+			/*
+			 * We might have missed a connection
+			 * notification, e.g. before the queues were
+			 * initialised.
+			 */
+			port->host_connected = true;
+		}
+		wake_up_interruptible(&port->waitqueue);
+	}
+	if (port && is_console_port(port) && hvc_poll(port->hvc))
 		hvc_kick();
+
+	/* Allocate buffers for all the ones that got used up */
+	fill_receive_queue();
 }
 
-/*D:370 Once we're further in boot, we get probed like any other virtio device.
- * At this stage we set up the output virtqueue.
+/*
+ * This is the workhandler for buffers that get received on the output
+ * virtqueue, which is an indication that Host consumed the data we
+ * sent it. Since all our buffers going out are of a fixed size we can
+ * just reuse them instead of freeing them and allocating new ones.
+ *
+ * Zero out the buffer so that we don't leak any information from
+ * other processes. There's a small optimisation here as well: the
+ * buffers are PAGE_SIZE-sized; but instead of zeroing the entire
+ * page, we just zero the length that was most recently used and we
+ * can be sure the rest of the page is already set to 0s.
+ *
+ * So once we zero them out we add them back to the unused buffers
+ * list
+ */
+
+static void virtio_console_tx_work_handler(struct work_struct *work)
+{
+	struct virtqueue *vq;
+	struct virtio_console_port_buffer *buf;
+	unsigned int tmplen;
+
+	vq = virtconsole.out_vq;
+	while ((buf = vq->vq_ops->get_buf(vq, &tmplen))) {
+		/* 0 the buffer to not leak data from other processes */
+		memset(buf->buf, 0, buf->len);
+		spin_lock(&virtconsole.write_list_lock);
+		list_add_tail(&buf->next, &virtconsole.unused_write_head);
+		spin_unlock(&virtconsole.write_list_lock);
+	}
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
+	/* Handle port hot-add */
+	schedule_work(&virtconsole.config_work);
+
+	/* Handle console size changes */
+	virtcons_apply_config(vdev);
+}
+
+/*
+ * Compare the current config and the new config that we just got and
+ * find out where a particular port was added.
+ */
+static u32 virtconsole_get_hot_add_port(struct virtio_console_config *config)
+{
+	u32 i;
+	u32 port_nr;
+
+	for (i = 0; i < virtconsole.config->max_nr_ports / 32; i++) {
+		port_nr = ffs(config->ports_map[i] ^ virtconsole.config->ports_map[i]);
+		if (port_nr)
+			break;
+	}
+	if (unlikely(!port_nr))
+		return VIRTIO_CONSOLE_BAD_ID;
+
+	/* We used ffs above */
+	port_nr--;
+
+	/* FIXME: Do this only when add_port is successful */
+	virtconsole.config->ports_map[i] |= 1U << port_nr;
+
+	port_nr += i * 32;
+	return port_nr;
+}
+
+/*
+ * Cycle throught the list of active ports and return the next port
+ * that has to be activated.
+ */
+static u32 virtconsole_find_next_port(u32 *map, int *map_i)
+{
+	u32 port_nr;
+
+	while (1) {
+		port_nr = ffs(*map);
+		if (port_nr)
+			break;
+
+		if (unlikely(*map_i >= virtconsole.config->max_nr_ports / 32))
+			return VIRTIO_CONSOLE_BAD_ID;
+		++*map_i;
+		*map = virtconsole.config->ports_map[*map_i];
+	}
+	/* We used ffs above */
+	port_nr--;
+
+	/* FIXME: Do this only when add_port is successful / reset bit
+	 * in config space if add_port was unsuccessful
+	 */
+	*map &= ~(1U << port_nr);
+
+	port_nr += *map_i * 32;
+	return port_nr;
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
+	devt = MKDEV(major, port_nr);
+	cdev_init(&port->cdev, &virtconsole_fops);
+
+	ret = register_chrdev_region(devt, 1, "virtio-console");
+	if (ret < 0) {
+		pr_err("%s: error registering chrdev region, ret = %d\n",
+		       __func__, ret);
+		goto free_port;
+	}
+	ret = cdev_add(&port->cdev, devt, 1);
+	if (ret < 0) {
+		pr_err("%s: error adding cdev, ret = %d\n", __func__, ret);
+		goto free_chrdev;
+	}
+	port->dev = device_create(virtconsole.class, NULL, devt, NULL,
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
+	INIT_LIST_HEAD(&port->readbuf_head);
+	init_waitqueue_head(&port->waitqueue);
+
+	list_add_tail(&port->next, &virtconsole.port_head);
+
+	/*
+	 * Ask for the port's name from Host. The string that we
+	 * receive in 'name' can be of arbitrary length; so pass the
+	 * maximum available buffer size: PAGE_SIZE.
+	 */
+	cpkt.event = VIRTIO_CONSOLE_PORT_NAME;
+	send_buf(port, (char *)&cpkt, PAGE_SIZE,
+		 VIRTIO_CONSOLE_ID_INTERNAL, false);
+
+	if (is_console_port(port)) {
+		/*
+		 * To set up and manage our virtual console, we call
+		 * hvc_alloc().
+		 *
+		 * The first argument of hvc_alloc() is the virtual
+		 * console number, so we use zero.  The second
+		 * argument is the parameter for the notification
+		 * mechanism (like irq number). We currently leave
+		 * this as zero, virtqueues have implicit
+		 * notifications.
+		 *
+		 * The third argument is a "struct hv_ops" containing
+		 * the put_chars() get_chars(), notifier_add() and
+		 * notifier_del() pointers.  The final argument is the
+		 * output buffer size: we can do any size, so we put
+		 * PAGE_SIZE here.
+		 */
+		port->hvc = hvc_alloc(port_nr, 0, &virtio_cons, PAGE_SIZE);
+		if (IS_ERR(port->hvc)) {
+			ret = PTR_ERR(port->hvc);
+			goto free_cdev;
+		}
+	}
+	pr_info("virtio-console port found at id %u\n", port_nr);
+
+	return 0;
+free_cdev:
+	cdev_del(&port->cdev);
+free_chrdev:
+	unregister_chrdev(major, "virtio-console");
+free_port:
+	kfree(port);
+	return ret;
+}
+
+/* max_ports is always a multiple of 32; enforced in the Host */
+static u32 get_ports_map_size(u32 max_ports)
+{
+	return sizeof(u32) * (max_ports / 32);
+}
+
+/* The workhandler for config-space updates
  *
- * To set up and manage our virtual console, we call hvc_alloc().  Since we
- * never remove the console device we never need this pointer again.
+ * This is used when new ports are added
+ */
+static void virtio_console_config_work_handler(struct work_struct *work)
+{
+	struct virtio_console_config *virtconconf;
+	struct virtio_device *vdev = virtconsole.vdev;
+	u32 i, port_nr;
+	int ret;
+
+	virtconconf = kzalloc(sizeof(*virtconconf) +
+			      get_ports_map_size(virtconsole.config->max_nr_ports),
+			      GFP_KERNEL);
+	vdev->config->get(vdev,
+			  offsetof(struct virtio_console_config, nr_active_ports),
+			  &virtconconf->nr_active_ports,
+			  sizeof(virtconconf->nr_active_ports));
+	vdev->config->get(vdev,
+			  offsetof(struct virtio_console_config, ports_map),
+			  virtconconf->ports_map,
+			  get_ports_map_size(virtconsole.config->max_nr_ports));
+
+	/* Hot-add ports */
+	for (i = virtconsole.config->nr_active_ports;
+	     i < virtconconf->nr_active_ports; i++) {
+		port_nr = virtconsole_get_hot_add_port(virtconconf);
+		if (port_nr == VIRTIO_CONSOLE_BAD_ID)
+			continue;
+		ret = virtconsole_add_port(port_nr);
+		if (!ret)
+			virtconsole.config->nr_active_ports++;
+	}
+	kfree(virtconconf);
+}
+
+/*D:370
+ * Once we're further in boot, we get probed like any other virtio device.
+ * At this stage we set up the output virtqueue.
  *
- * Finally we put our input buffer in the input queue, ready to receive. */
-static int __devinit virtcons_probe(struct virtio_device *dev)
+ * Finally we put our input buffer in the input queue, ready to receive.
+ */
+static int __devinit virtcons_probe(struct virtio_device *vdev)
 {
-	vq_callback_t *callbacks[] = { hvc_handle_input, NULL};
+	vq_callback_t *callbacks[] = { rx_intr, tx_intr };
 	const char *names[] = { "input", "output" };
 	struct virtqueue *vqs[2];
-	int err;
+	u32 i, map;
+	int ret, map_i;
+	u32 max_nr_ports;
+	bool multiport;
 
-	vdev = dev;
+	virtconsole.vdev = vdev;
 
-	/* This is the scratch page we use to receive console input */
-	inbuf = kmalloc(PAGE_SIZE, GFP_KERNEL);
-	if (!inbuf) {
-		err = -ENOMEM;
-		goto fail;
-	}
+	multiport = false;
+	if (virtio_has_feature(vdev, VIRTIO_CONSOLE_F_MULTIPORT)) {
+		multiport = true;
+		vdev->features[0] |= 1 << VIRTIO_CONSOLE_F_MULTIPORT;
+		vdev->config->finalize_features(vdev);
+
+		vdev->config->get(vdev,
+				  offsetof(struct virtio_console_config,
+					   max_nr_ports),
+				  &max_nr_ports,
+				  sizeof(max_nr_ports));
+		/*
+		 * We have a variable-sized config space that's dependent
+		 * on the maximum number of ports a guest can have.
+		 * So we first get the max number of ports we can have
+		 * and then allocate the config space
+		 */
+		virtconsole.config = kzalloc(sizeof(struct virtio_console_config)
+					     + get_ports_map_size(max_nr_ports),
+					     GFP_KERNEL);
+		if (!virtconsole.config)
+			return -ENOMEM;
 
+		virtconsole.config->max_nr_ports = max_nr_ports;
+
+		vdev->config->get(vdev, offsetof(struct virtio_console_config,
+						 nr_active_ports),
+				  &virtconsole.config->nr_active_ports,
+				  sizeof(virtconsole.config->nr_active_ports));
+		vdev->config->get(vdev,
+				  offsetof(struct virtio_console_config,
+					   ports_map),
+				  virtconsole.config->ports_map,
+				  get_ports_map_size(max_nr_ports));
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
+	INIT_LIST_HEAD(&virtconsole.port_head);
+	INIT_LIST_HEAD(&virtconsole.unused_read_head);
+	INIT_LIST_HEAD(&virtconsole.unused_write_head);
+
+	INIT_WORK(&virtconsole.rx_work, &virtio_console_rx_work_handler);
+	INIT_WORK(&virtconsole.tx_work, &virtio_console_tx_work_handler);
+	INIT_WORK(&virtconsole.config_work, &virtio_console_config_work_handler);
+	spin_lock_init(&virtconsole.write_list_lock);
+
+	fill_receive_queue();
+	alloc_write_bufs();
+
+	if (multiport) {
+		map_i = 0;
+		map = virtconsole.config->ports_map[map_i];
+		for (i = 0; i < virtconsole.config->nr_active_ports; i++) {
+			u32 port_nr;
+
+			port_nr = virtconsole_find_next_port(&map, &map_i);
+			if (unlikely(port_nr == VIRTIO_CONSOLE_BAD_ID))
+				continue;
+			virtconsole_add_port(port_nr);
+		}
+	} else
+		virtconsole_add_port(VIRTIO_CONSOLE_CONSOLE_PORT);
+
+	return 0;
+
+fail:
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
 	}
+	sysfs_remove_group(&port->dev->kobj, &virtcon_attribute_group);
+	device_destroy(virtconsole.class, port->dev->devt);
+	unregister_chrdev_region(port->dev->devt, 1);
+	cdev_del(&port->cdev);
+
+	kfree(port->name);
 
-	/* Register the input buffer the first time. */
-	add_inbuf();
+	/* Remove the buffers in which we have unconsumed data */
+	list_for_each_entry_safe(buf, buf2, &port->readbuf_head, next) {
+		list_del(&buf->next);
+		kfree(buf->buf);
+		kfree(buf);
+	}
 	return 0;
+}
+
+static void virtcons_remove(struct virtio_device *vdev)
+{
+	struct virtio_console_port *port, *port2;
+	struct virtio_console_port_buffer *buf, *buf2;
+	char *tmpbuf;
+	int len;
+
+	unregister_chrdev(major, "virtio-console");
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
 
-free_vqs:
 	vdev->config->del_vqs(vdev);
-free:
-	kfree(inbuf);
-fail:
-	return err;
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
+	kfree(virtconsole.config);
 }
 
 static struct virtio_device_id id_table[] = {
@@ -254,6 +1123,7 @@ static struct virtio_device_id id_table[] = {
 
 static unsigned int features[] = {
 	VIRTIO_CONSOLE_F_SIZE,
+	VIRTIO_CONSOLE_F_MULTIPORT,
 };
 
 static struct virtio_driver virtio_console = {
@@ -263,14 +1133,34 @@ static struct virtio_driver virtio_console = {
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
index b5f5198..d0221bd 100644
--- a/include/linux/virtio_console.h
+++ b/include/linux/virtio_console.h
@@ -2,20 +2,77 @@
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
+
+/* Port at which the virtio console is spawned */
+#define VIRTIO_CONSOLE_CONSOLE_PORT	0
+#define VIRTIO_CONSOLE_CONSOLE2_PORT	1
 
 struct virtio_console_config {
 	/* colums of the screens */
 	__u16 cols;
 	/* rows of the screens */
 	__u16 rows;
+	/*
+	 * max. number of ports supported for each PCI device. Always
+	 * a multiple of 32
+	 */
+	__u32 max_nr_ports;
+	/* number of ports in use */
+	__u32 nr_active_ports;
+	/*
+	 * locations of the ports in use; variable-size array: should
+	 * be the last in this struct.
+	 */
+	__u32 ports_map[0 /* max_nr_ports / 32 */];
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
+
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
