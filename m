Return-Path: <linux-kernel-owner+w=401wt.eu-S1755884AbXKGGDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884AbXKGGDu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 01:03:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751110AbXKGGDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 01:03:42 -0500
Received: from ozlabs.org ([203.10.76.45]:45064 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745AbXKGGDl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 01:03:41 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Anthony Liguori <aliguori@us.ibm.com>
Subject: [PATCH] virtio config_ops refactoring
Date: Wed, 7 Nov 2007 17:04:09 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Dor Laor <dor.laor@qumranet.com>, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, lguest <lguest@ozlabs.org>
References: <4730A8F3.6020008@us.ibm.com> <200711070957.44165.rusty__13109.5125260346$1194390035$gmane$org@rustcorp.com.au> <4730F351.5060006@us.ibm.com>
In-Reply-To: <4730F351.5060006@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711071704.09752.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

After discussion with Anthony, the virtio config has been simplified.  We
lose some minor features (the virtio_net address must now be 6 bytes) but
it turns out to be a wash in terms of complexity, while simplifying PCI.

This can be found in the new virtio git tree, in the "patches/1" branch
(new branches will be created as I rebase to keep up with Linus).

	git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-virtio.git

I've also posted below, for easy commentry.
Cheers,
Rusty.

===
Previously we used a type/len pair within the config space, but this
seems overkill.  We now simply use an agreed offset within the config
space and assume everyone knows the size of any entry it is interested
in (the config space can now only be extended at the end).

The main driver-visible change is that we indicate what fields are
present with an explicit feature bit.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/Documentation/lguest/lguest.c b/Documentation/lguest/lguest.c
index f266839..e5e5890 100644
--- a/Documentation/lguest/lguest.c
+++ b/Documentation/lguest/lguest.c
@@ -34,6 +34,7 @@
 #include <zlib.h>
 #include <assert.h>
 #include <sched.h>
+#include <limits.h>
 #include "linux/lguest_launcher.h"
 #include "linux/virtio_config.h"
 #include "linux/virtio_net.h"
@@ -96,13 +97,11 @@ struct device_list
 	/* The descriptor page for the devices. */
 	u8 *descpage;
 
-	/* The tail of the last descriptor. */
-	unsigned int desc_used;
-
 	/* A single linked list of devices. */
 	struct device *dev;
-	/* ... And an end pointer so we can easily append new devices */
-	struct device **lastdev;
+	/* And a pointer to the last device for easy append and also for
+	 * configuration appending. */
+	struct device *lastdev;
 };
 
 /* The list of Guest devices, based on command line arguments. */
@@ -980,54 +979,44 @@ static void handle_input(int fd)
  *
  * All devices need a descriptor so the Guest knows it exists, and a "struct
  * device" so the Launcher can keep track of it.  We have common helper
- * routines to allocate them.
- *
- * This routine allocates a new "struct lguest_device_desc" from descriptor
- * table just above the Guest's normal memory.  It returns a pointer to that
- * descriptor. */
-static struct lguest_device_desc *new_dev_desc(u16 type)
-{
-	struct lguest_device_desc *d;
-
-	/* We only have one page for all the descriptors. */
-	if (devices.desc_used + sizeof(*d) > getpagesize())
-		errx(1, "Too many devices");
-
-	/* We don't need to set config_len or status: page is 0 already. */
-	d = (void *)devices.descpage + devices.desc_used;
-	d->type = type;
-	devices.desc_used += sizeof(*d);
+ * routines to allocate and manage them. */
 
-	return d;
+/* The layout of the device page is a "struct lguest_device_desc" followed by a
+ * number of virtqueue descriptors, then two sets of feature bits, then an
+ * array of configuration bytes.  This routine returns the configuration
+ * pointer. */
+static void *device_config(const struct device *dev)
+{
+	return (void *)(dev->desc + 1)
+		+ dev->desc->num_vq * sizeof(struct lguest_vqconfig)
+		+ dev->desc->feature_len * 2;
 }
 
-/* Each device descriptor is followed by some configuration information.
- * Each configuration field looks like: u8 type, u8 len, [... len bytes...].
- *
- * This routine adds a new field to an existing device's descriptor.  It only
- * works for the last device, but that's OK because that's how we use it. */
-static void add_desc_field(struct device *dev, u8 type, u8 len, const void *c)
+/* This routine allocates a new "struct lguest_device_desc" from descriptor
+ * table page just above the Guest's normal memory.  It returns a pointer to
+ * that descriptor. */
+static struct lguest_device_desc *new_dev_desc(u16 type)
 {
-	/* This is the last descriptor, right? */
-	assert(devices.descpage + devices.desc_used
-	       == (u8 *)(dev->desc + 1) + dev->desc->config_len);
+	struct lguest_device_desc d = { .type = type }; 
+	void *p;
 
-	/* We only have one page of device descriptions. */
-	if (devices.desc_used + 2 + len > getpagesize())
-		errx(1, "Too many devices");
+	/* Figure out where the next device config is, based on the last one. */
+	if (devices.lastdev)
+		p = device_config(devices.lastdev)
+			+ devices.lastdev->desc->config_len;
+	else
+		p = devices.descpage;
 
-	/* Copy in the new config header: type then length. */
-	devices.descpage[devices.desc_used++] = type;
-	devices.descpage[devices.desc_used++] = len;
-	memcpy(devices.descpage + devices.desc_used, c, len);
-	devices.desc_used += len;
+	/* We only have one page for all the descriptors. */
+	if (p + sizeof(d) > (void *)devices.descpage + getpagesize())
+		errx(1, "Too many devices");
 
-	/* Update the device descriptor length: two byte head then data. */
-	dev->desc->config_len += 2 + len;
+	/* p might not be aligned, so we memcpy in. */
+	return memcpy(p, &d, sizeof(d));
 }
 
-/* This routine adds a virtqueue to a device.  We specify how many descriptors
- * the virtqueue is to have. */
+/* Each device descriptor is followed by the description of its virtqueues.  We
+ * specify how many descriptors the virtqueue is to have. */
 static void add_virtqueue(struct device *dev, unsigned int num_descs,
 			  void (*handle_output)(int fd, struct virtqueue *me))
 {
@@ -1047,9 +1036,15 @@ static void add_virtqueue(struct device *dev, unsigned int num_descs,
 	/* Initialize the vring. */
 	vring_init(&vq->vring, num_descs, p);
 
-	/* Add the configuration information to this device's descriptor. */
-	add_desc_field(dev, VIRTIO_CONFIG_F_VIRTQUEUE,
-		       sizeof(vq->config), &vq->config);
+	/* Append virtqueue to this device's descriptor.  We use
+	 * device_config() to get the end of the device's current virtqueues;
+	 * we check that we haven't added any config or feature information
+	 * yet, otherwise we'd be overwriting them. */
+	assert(dev->desc->config_len == 0 && dev->desc->feature_len == 0);
+	memcpy(device_config(dev), &vq->config, sizeof(vq->config));
+	dev->desc->num_vq++;
+
+	verbose("Virtqueue page %#lx\n", to_guest_phys(p));
 
 	/* Add to tail of list, so dev->vq is first vq, dev->vq->next is
 	 * second.  */
@@ -1068,6 +1063,43 @@ static void add_virtqueue(struct device *dev, unsigned int num_descs,
 		vq->vring.used->flags = VRING_USED_F_NO_NOTIFY;
 }
 
+/* The virtqueue descriptors are followed by feature bytes. */
+static void add_feature(struct device *dev, unsigned bit)
+{
+	u8 *features;
+
+	/* We can't extend the feature bits once we've added config bytes */
+	if (dev->desc->feature_len <= bit / CHAR_BIT) {
+		assert(dev->desc->config_len == 0);
+		dev->desc->feature_len = (bit / CHAR_BIT) + 1;
+	}
+
+	features = (u8 *)(dev->desc + 1)
+		+ dev->desc->num_vq * sizeof(struct lguest_vqconfig);
+
+	features[bit / CHAR_BIT] |= (1 << (bit % CHAR_BIT));
+}
+
+/* This routine adds a new configuration field to an existing device's
+ * descriptor.  It only works for the last device, but that's OK because that's
+ * how we use it. */
+static void add_desc_field(struct device *dev, unsigned off, unsigned len,
+			   const void *c)
+{
+	u8 *config = device_config(dev);
+
+	/* Extend the length of the device's config space if needed. */
+	if (off + len > dev->desc->config_len)
+		dev->desc->config_len = off + len;
+
+	/* Check we haven't overflowed our single page. */
+	if (config + dev->desc->config_len > devices.descpage + getpagesize())
+		errx(1, "Too many devices");
+
+	/* Copy in the config information. */
+	memcpy(config + off, c, len);
+}
+
 /* This routine does all the creation and setup of a new device, including
  * calling new_dev_desc() to allocate the descriptor and device memory. */
 static struct device *new_device(const char *name, u16 type, int fd,
@@ -1075,14 +1107,6 @@ static struct device *new_device(const char *name, u16 type, int fd,
 {
 	struct device *dev = malloc(sizeof(*dev));
 
-	/* Append to device list.  Prepending to a single-linked list is
-	 * easier, but the user expects the devices to be arranged on the bus
-	 * in command-line order.  The first network device on the command line
-	 * is eth0, the first block device /dev/vda, etc. */
-	*devices.lastdev = dev;
-	dev->next = NULL;
-	devices.lastdev = &dev->next;
-
 	/* Now we populate the fields one at a time. */
 	dev->fd = fd;
 	/* If we have an input handler for this file descriptor, then we add it
@@ -1092,6 +1116,17 @@ static struct device *new_device(const char *name, u16 type, int fd,
 	dev->desc = new_dev_desc(type);
 	dev->handle_input = handle_input;
 	dev->name = name;
+
+	/* Append to device list.  Prepending to a single-linked list is
+	 * easier, but the user expects the devices to be arranged on the bus
+	 * in command-line order.  The first network device on the command line
+	 * is eth0, the first block device /dev/vda, etc. */
+	if (devices.lastdev)
+		devices.lastdev->next = dev;
+	else
+		devices.dev = dev;
+	devices.lastdev = dev;
+
 	return dev;
 }
 
@@ -1258,9 +1293,10 @@ static void setup_tun_net(const char *arg)
 	configure_device(ipfd, ifr.ifr_name, ip, hwaddr);
 
 	/* Tell Guest what MAC address to use. */
+	add_feature(dev, VIRTIO_NET_F_MAC);
 	add_desc_field(dev, VIRTIO_CONFIG_NET_MAC_F, sizeof(hwaddr), hwaddr);
 
-	/* We don't seed the socket any more; setup is done. */
+	/* We don't need the socket any more; setup is done. */
 	close(ipfd);
 
 	verbose("device %u: tun net %u.%u.%u.%u\n",
@@ -1467,6 +1503,11 @@ static void setup_block_file(const char *filename)
 	vblk->fd = open_or_die(filename, O_RDWR|O_LARGEFILE);
 	vblk->len = lseek64(vblk->fd, 0, SEEK_END);
 
+	/* We're going to specify the maximum number of segments, and we
+	 * support barriers. */
+	add_feature(dev, VIRTIO_BLK_F_SEG_MAX);
+	add_feature(dev, VIRTIO_BLK_F_BARRIER);
+
 	/* Tell Guest how many sectors this device has. */
 	cap = cpu_to_le64(vblk->len / 512);
 	add_desc_field(dev, VIRTIO_CONFIG_BLK_F_CAPACITY, sizeof(cap), &cap);
@@ -1570,12 +1623,12 @@ int main(int argc, char *argv[])
 	/* First we initialize the device list.  Since console and network
 	 * device receive input from a file descriptor, we keep an fdset
 	 * (infds) and the maximum fd number (max_infd) with the head of the
-	 * list.  We also keep a pointer to the last device, for easy appending
-	 * to the list.  Finally, we keep the next interrupt number to hand out
-	 * (1: remember that 0 is used by the timer). */
+	 * list.  We also keep a pointer to the last device.  Finally, we keep
+	 * the next interrupt number to hand out (1: remember that 0 is used by
+	 * the timer). */
 	FD_ZERO(&devices.infds);
 	devices.max_infd = -1;
-	devices.lastdev = &devices.dev;
+	devices.lastdev = NULL;
 	devices.next_irq = 1;
 
 	/* We need to know how much memory so we can set up the device
diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 3cf7129..35f0322 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -162,8 +162,6 @@ static int virtblk_probe(struct virtio_device *vdev)
 {
 	struct virtio_blk *vblk;
 	int err, major;
-	void *token;
-	unsigned int len;
 	u64 cap;
 	u32 v;
 
@@ -178,7 +176,7 @@ static int virtblk_probe(struct virtio_device *vdev)
 	vblk->vdev = vdev;
 
 	/* We expect one virtqueue, for output. */
-	vblk->vq = vdev->config->find_vq(vdev, blk_done);
+	vblk->vq = vdev->config->find_vq(vdev, 0, blk_done);
 	if (IS_ERR(vblk->vq)) {
 		err = PTR_ERR(vblk->vq);
 		goto out_free_vblk;
@@ -216,16 +214,12 @@ static int virtblk_probe(struct virtio_device *vdev)
 	vblk->disk->fops = &virtblk_fops;
 
 	/* If barriers are supported, tell block layer that queue is ordered */
-	token = vdev->config->find(vdev, VIRTIO_CONFIG_BLK_F, &len);
-	if (virtio_use_bit(vdev, token, len, VIRTIO_BLK_F_BARRIER))
+	if (vdev->config->feature(vdev, VIRTIO_BLK_F_BARRIER))
 		blk_queue_ordered(vblk->disk->queue, QUEUE_ORDERED_TAG, NULL);
 
-	err = virtio_config_val(vdev, VIRTIO_CONFIG_BLK_F_CAPACITY, &cap);
-	if (err) {
-		dev_err(&vdev->dev, "Bad/missing capacity in config\n");
-		goto out_put_disk;
-	}
+	/* Host must always specify the capacity. */
+	__virtio_config_val(vdev, VIRTIO_CONFIG_BLK_F_CAPACITY, &cap);
 
 	/* If capacity is too big, truncate with warning. */
 	if ((sector_t)cap != cap) {
 		dev_warn(&vdev->dev, "Capacity %llu too large: truncating\n",
@@ -234,21 +229,17 @@ static int virtblk_probe(struct virtio_device *vdev)
 	}
 	set_capacity(vblk->disk, cap);
 
-	err = virtio_config_val(vdev, VIRTIO_CONFIG_BLK_F_SIZE_MAX, &v);
+	/* Host can optionally specify maximum segment size and number of
+	 * segments. */
+	err = virtio_config_val(vdev, VIRTIO_BLK_F_SIZE_MAX,
+				VIRTIO_CONFIG_BLK_F_SIZE_MAX, &v);
 	if (!err)
 		blk_queue_max_segment_size(vblk->disk->queue, v);
-	else if (err != -ENOENT) {
-		dev_err(&vdev->dev, "Bad SIZE_MAX in config\n");
-		goto out_put_disk;
-	}
 
-	err = virtio_config_val(vdev, VIRTIO_CONFIG_BLK_F_SEG_MAX, &v);
+	err = virtio_config_val(vdev, VIRTIO_BLK_F_SEG_MAX,
+				VIRTIO_CONFIG_BLK_F_SEG_MAX, &v);
 	if (!err)
 		blk_queue_max_hw_segments(vblk->disk->queue, v);
-	else if (err != -ENOENT) {
-		dev_err(&vdev->dev, "Bad SEG_MAX in config\n");
-		goto out_put_disk;
-	}
 
 	add_disk(vblk->disk);
 	return 0;
diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index e34da5c..dc17fe3 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -158,13 +158,13 @@ static int __devinit virtcons_probe(struct virtio_device *dev)
 	/* Find the input queue. */
 	/* FIXME: This is why we want to wean off hvc: we do nothing
 	 * when input comes in. */
-	in_vq = vdev->config->find_vq(vdev, NULL);
+	in_vq = vdev->config->find_vq(vdev, 0, NULL);
 	if (IS_ERR(in_vq)) {
 		err = PTR_ERR(in_vq);
 		goto free;
 	}
 
-	out_vq = vdev->config->find_vq(vdev, NULL);
+	out_vq = vdev->config->find_vq(vdev, 1, NULL);
 	if (IS_ERR(out_vq)) {
 		err = PTR_ERR(out_vq);
 		goto free_in_vq;
diff --git a/drivers/lguest/lguest_device.c b/drivers/lguest/lguest_device.c
index 8904f72..25c607a 100644
--- a/drivers/lguest/lguest_device.c
+++ b/drivers/lguest/lguest_device.c
@@ -52,57 +52,84 @@ struct lguest_device {
 /*D:130
  * Device configurations
  *
- * The configuration information for a device consists of a series of fields.
- * We don't really care what they are: the Launcher set them up, and the driver
- * will look at them during setup.
+ * The configuration information for a device consists of one or more
+ * virtqueues, a feature bitmaks, and some configuration bytes.  The
+ * configuration bytes don't really matter to us: the Launcher set them up, and
+ * the driver will look at them during setup.
  *
- * For us these fields come immediately after that device's descriptor in the
- * lguest_devices page.
- *
- * Each field starts with a "type" byte, a "length" byte, then that number of
- * bytes of configuration information.  The device descriptor tells us the
- * total configuration length so we know when we've reached the last field. */
+ * A convenient routine to return the device's virtqueue config array:
+ * immediately after the descriptor. */
+static struct lguest_vqconfig *lg_vq(const struct lguest_device_desc *desc)
+{
+	return (void *)(desc + 1);
+}
 
-/* type + length bytes */
-#define FHDR_LEN 2
+/* The features come immediately after the virtqueues. */
+static u8 *lg_features(const struct lguest_device_desc *desc)
+{
+	return (void *)(lg_vq(desc) + desc->num_vq);
+}
 
-/* This finds the first field of a given type for a device's configuration. */
-static void *lg_find(struct virtio_device *vdev, u8 type, unsigned int *len)
+/* The config space comes after the two feature bitmasks. */
+static u8 *lg_config(const struct lguest_device_desc *desc)
 {
-	struct lguest_device_desc *desc = to_lgdev(vdev)->desc;
-	int i;
-
-	for (i = 0; i < desc->config_len; i += FHDR_LEN + desc->config[i+1]) {
-		if (desc->config[i] == type) {
-			/* Mark it used, so Host can know we looked at it, and
-			 * also so we won't find the same one twice. */
-			desc->config[i] |= 0x80;
-			/* Remember, the second byte is the length. */
-			*len = desc->config[i+1];
-			/* We return a pointer to the field header. */
-			return desc->config + i;
-		}
-	}
+	return lg_features(desc) + desc->feature_len * 2;
+}
 
-	/* Not found: return NULL for failure. */
-	return NULL;
+/* The total size of the config page used by this device (incl. desc) */
+static unsigned desc_size(const struct lguest_device_desc *desc)
+{
+	return sizeof(*desc)
+		+ desc->num_vq * sizeof(struct lguest_vqconfig)
+		+ desc->feature_len * 2
+		+ desc->config_len;
+}
+
+/* This tests (and acknowleges) a feature bit. */
+static bool lg_feature(struct virtio_device *vdev, unsigned fbit)
+{
+	struct lguest_device_desc *desc = to_lgdev(vdev)->desc;
+	u8 *features;
+
+	/* Obviously if they ask for a feature off the end of our feature
+	 * bitmap, it's not set. */
+	if (fbit / 8 > desc->feature_len)
+		return false;
+
+	/* The feature bitmap comes after the virtqueues. */
+	features = lg_features(desc);
+	if (!(features[fbit / 8] & (1 << (fbit % 8))))
+		return false;
+
+	/* We set the matching bit in the other half of the bitmap to tell the
+	 * Host we want to use this feature.  We don't use this yet, but we
+	 * could in future. */
+	features[desc->feature_len + fbit / 8] |= (1 << (fbit % 8));
+	return true;
 }
 
 /* Once they've found a field, getting a copy of it is easy. */
-static void lg_get(struct virtio_device *vdev, void *token,
+static void lg_get(struct virtio_device *vdev, unsigned int offset,
 		   void *buf, unsigned len)
 {
-	/* Check they didn't ask for more than the length of the field! */
-	BUG_ON(len > ((u8 *)token)[1]);
-	memcpy(buf, token + FHDR_LEN, len);
+	struct lguest_device_desc *desc = to_lgdev(vdev)->desc;
+
+	/* Check they didn't ask for more than the length of the config! */
+	BUG_ON(offset + len > desc->config_len);
+	printk("Getting config len %u from page offset %u\n",
+	       len, lg_config(desc) + offset - (u8 *)lguest_devices);
+	memcpy(buf, lg_config(desc) + offset, len);
 }
 
 /* Setting the contents is also trivial. */
-static void lg_set(struct virtio_device *vdev, void *token,
+static void lg_set(struct virtio_device *vdev, unsigned int offset,
 		   const void *buf, unsigned len)
 {
-	BUG_ON(len > ((u8 *)token)[1]);
-	memcpy(token + FHDR_LEN, buf, len);
+	struct lguest_device_desc *desc = to_lgdev(vdev)->desc;
+
+	/* Check they didn't ask for more than the length of the config! */
+	BUG_ON(offset + len > desc->config_len);
+	memcpy(lg_config(desc) + offset, buf, len);
 }
 
 /* The operations to get and set the status word just access the status field
@@ -165,39 +192,29 @@ static void lg_notify(struct virtqueue *vq)
  *
  * So we provide devices with a "find virtqueue and set it up" function. */
 static struct virtqueue *lg_find_vq(struct virtio_device *vdev,
+				    unsigned index,
 				    bool (*callback)(struct virtqueue *vq))
 {
+	struct lguest_device *ldev = to_lgdev(vdev);
 	struct lguest_vq_info *lvq;
 	struct virtqueue *vq;
-	unsigned int len;
-	void *token;
 	int err;
 
-	/* Look for a field of the correct type to mark a virtqueue.  Note that
-	 * if this succeeds, then the type will be changed so it won't be found
-	 * again, and future lg_find_vq() calls will find the next
-	 * virtqueue (if any). */
-	token = vdev->config->find(vdev, VIRTIO_CONFIG_F_VIRTQUEUE, &len);
-	if (!token)
+	/* We must have this many virtqueues. */
+	if (index >= ldev->desc->num_vq)
 		return ERR_PTR(-ENOENT);
 
 	lvq = kmalloc(sizeof(*lvq), GFP_KERNEL);
 	if (!lvq)
 		return ERR_PTR(-ENOMEM);
 
-	/* Note: we could use a configuration space inside here, just like we
-	 * do for the device.  This would allow expansion in future, because
-	 * our configuration system is designed to be expansible.  But this is
-	 * way easier. */
-	if (len != sizeof(lvq->config)) {
-		dev_err(&vdev->dev, "Unexpected virtio config len %u\n", len);
-		err = -EIO;
-		goto free_lvq;
-	}
-	/* Make a copy of the "struct lguest_vqconfig" field.  We need a copy
-	 * because the config space might not be aligned correctly. */
-	vdev->config->get(vdev, token, &lvq->config, sizeof(lvq->config));
+	/* Make a copy of the "struct lguest_vqconfig" entry, which sits after
+	 * the descriptor.  We need a copy because the config space might not
+	 * be aligned correctly. */
+	memcpy(&lvq->config, lg_vq(ldev->desc)+index, sizeof(lvq->config));
 
+	printk("Mapping virtqueue %i addr %lx\n", index,
+	       (unsigned long)lvq->config.pfn << PAGE_SHIFT);
 	/* Figure out how many pages the ring will take, and map that memory */
 	lvq->pages = lguest_map((unsigned long)lvq->config.pfn << PAGE_SHIFT,
 				DIV_ROUND_UP(vring_size(lvq->config.num),
@@ -256,7 +273,7 @@ static void lg_del_vq(struct virtqueue *vq)
 
 /* The ops structure which hooks everything together. */
 static struct virtio_config_ops lguest_config_ops = {
-	.find = lg_find,
+	.feature = lg_feature,
 	.get = lg_get,
 	.set = lg_set,
 	.get_status = lg_get_status,
@@ -326,13 +343,14 @@ static void scan_devices(void)
 	struct lguest_device_desc *d;
 
 	/* We start at the page beginning, and skip over each entry. */
-	for (i = 0; i < PAGE_SIZE; i += sizeof(*d) + d->config_len) {
+	for (i = 0; i < PAGE_SIZE; i += desc_size(d)) {
 		d = lguest_devices + i;
 
 		/* Once we hit a zero, stop. */
 		if (d->type == 0)
 			break;
 
+		printk("Device at %i has size %u\n", i, desc_size(d));
 		add_lguest_device(d);
 	}
 }
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index a75be57..734cddc 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -320,10 +320,8 @@ static int virtnet_close(struct net_device *dev)
 static int virtnet_probe(struct virtio_device *vdev)
 {
 	int err;
-	unsigned int len;
 	struct net_device *dev;
 	struct virtnet_info *vi;
-	void *token;
 
 	/* Allocate ourselves a network device with room for our info */
 	dev = alloc_etherdev(sizeof(struct virtnet_info));
@@ -339,25 +337,23 @@ static int virtnet_probe(struct virtio_device *vdev)
 	SET_NETDEV_DEV(dev, &vdev->dev);
 
 	/* Do we support "hardware" checksums? */
-	token = vdev->config->find(vdev, VIRTIO_CONFIG_NET_F, &len);
-	if (virtio_use_bit(vdev, token, len, VIRTIO_NET_F_NO_CSUM)) {
+	if (vdev->config->feature(vdev, VIRTIO_NET_F_NO_CSUM)) {
 		/* This opens up the world of extra features. */
 		dev->features |= NETIF_F_HW_CSUM|NETIF_F_SG|NETIF_F_FRAGLIST;
-		if (virtio_use_bit(vdev, token, len, VIRTIO_NET_F_TSO4))
+		if (vdev->config->feature(vdev, VIRTIO_NET_F_TSO4))
 			dev->features |= NETIF_F_TSO;
-		if (virtio_use_bit(vdev, token, len, VIRTIO_NET_F_UFO))
+		if (vdev->config->feature(vdev, VIRTIO_NET_F_UFO))
 			dev->features |= NETIF_F_UFO;
-		if (virtio_use_bit(vdev, token, len, VIRTIO_NET_F_TSO4_ECN))
+		if (vdev->config->feature(vdev, VIRTIO_NET_F_TSO4_ECN))
 			dev->features |= NETIF_F_TSO_ECN;
-		if (virtio_use_bit(vdev, token, len, VIRTIO_NET_F_TSO6))
+		if (vdev->config->feature(vdev, VIRTIO_NET_F_TSO6))
 			dev->features |= NETIF_F_TSO6;
 	}
 
 	/* Configuration may specify what MAC to use.  Otherwise random. */
-	token = vdev->config->find(vdev, VIRTIO_CONFIG_NET_MAC_F, &len);
-	if (token) {
-		dev->addr_len = len;
-		vdev->config->get(vdev, token, dev->dev_addr, len);
+	if (vdev->config->feature(vdev, VIRTIO_NET_F_MAC)) {
+		vdev->config->get(vdev, VIRTIO_CONFIG_NET_MAC_F, dev->dev_addr,
+				  dev->addr_len);
 	} else
 		random_ether_addr(dev->dev_addr);
 
@@ -368,13 +364,13 @@ static int virtnet_probe(struct virtio_device *vdev)
 	vi->vdev = vdev;
 
 	/* We expect two virtqueues, receive then send. */
-	vi->rvq = vdev->config->find_vq(vdev, skb_recv_done);
+	vi->rvq = vdev->config->find_vq(vdev, 0, skb_recv_done);
 	if (IS_ERR(vi->rvq)) {
 		err = PTR_ERR(vi->rvq);
 		goto free;
 	}
 
-	vi->svq = vdev->config->find_vq(vdev, skb_xmit_done);
+	vi->svq = vdev->config->find_vq(vdev, 1, skb_xmit_done);
 	if (IS_ERR(vi->svq)) {
 		err = PTR_ERR(vi->svq);
 		goto free_recv;
diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index 15d7787..f76c66c 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -135,51 +135,6 @@ void unregister_virtio_device(struct virtio_device *dev)
 }
 EXPORT_SYMBOL_GPL(unregister_virtio_device);
 
-int __virtio_config_val(struct virtio_device *vdev,
-			u8 type, void *val, size_t size)
-{
-	void *token;
-	unsigned int len;
-
-	token = vdev->config->find(vdev, type, &len);
-	if (!token)
-		return -ENOENT;
-
-	if (len != size)
-		return -EIO;
-
-	vdev->config->get(vdev, token, val, size);
-	return 0;
-}
-EXPORT_SYMBOL_GPL(__virtio_config_val);
-
-int virtio_use_bit(struct virtio_device *vdev,
-		   void *token, unsigned int len, unsigned int bitnum)
-{
-	unsigned long bits[16];
-
-	/* This makes it convenient to pass-through find() results. */
-	if (!token)
-		return 0;
-
-	/* bit not in range of this bitfield? */
-	if (bitnum * 8 >= len / 2)
-		return 0;
-
-	/* Giant feature bitfields are silly. */
-	BUG_ON(len > sizeof(bits));
-	vdev->config->get(vdev, token, bits, len);
-
-	if (!test_bit(bitnum, bits))
-		return 0;
-
-	/* Set acknowledge bit, and write it back. */
-	set_bit(bitnum + len * 8 / 2, bits);
-	vdev->config->set(vdev, token, bits, len);
-	return 1;
-}
-EXPORT_SYMBOL_GPL(virtio_use_bit);
-
 static int virtio_init(void)
 {
 	if (bus_register(&virtio_bus) != 0)
diff --git a/include/linux/lguest_launcher.h b/include/linux/lguest_launcher.h
index 697104d..589be3e 100644
--- a/include/linux/lguest_launcher.h
+++ b/include/linux/lguest_launcher.h
@@ -23,7 +23,12 @@
 struct lguest_device_desc {
 	/* The device type: console, network, disk etc.  Type 0 terminates. */
 	__u8 type;
-	/* The number of bytes of the config array. */
+	/* The number of virtqueues (first in config array) */
+	__u8 num_vq;
+	/* The number of bytes of feature bits.  Multiply by 2: one for host
+	 * features and one for guest acknowledgements. */
+	__u8 feature_len;
+	/* The number of bytes of the config array after virtqueues. */
 	__u8 config_len;
 	/* A status byte, written by the Guest. */
 	__u8 status;
@@ -31,7 +36,7 @@ struct lguest_device_desc {
 };
 
 /*D:135 This is how we expect the device configuration field for a virtqueue
- * (type VIRTIO_CONFIG_F_VIRTQUEUE) to be laid out: */
+ * to be laid out in config space. */
 struct lguest_vqconfig {
 	/* The number of entries in the virtio_ring */
 	__u16 num;
diff --git a/include/linux/virtio_blk.h b/include/linux/virtio_blk.h
index 7bd2bce..a960f23 100644
--- a/include/linux/virtio_blk.h
+++ b/include/linux/virtio_blk.h
@@ -6,15 +6,16 @@
 #define VIRTIO_ID_BLOCK	2
 
 /* Feature bits */
-#define VIRTIO_CONFIG_BLK_F	0x40
-#define VIRTIO_BLK_F_BARRIER	1	/* Does host support barriers? */
-
-/* The capacity (in 512-byte sectors). */
-#define VIRTIO_CONFIG_BLK_F_CAPACITY	0x41
-/* The maximum segment size. */
-#define VIRTIO_CONFIG_BLK_F_SIZE_MAX	0x42
-/* The maximum number of segments. */
-#define VIRTIO_CONFIG_BLK_F_SEG_MAX	0x43
+#define VIRTIO_BLK_F_BARRIER	0	/* Does host support barriers? */
+#define VIRTIO_BLK_F_SIZE_MAX	1	/* Indicates maximum segment size */
+#define VIRTIO_BLK_F_SEG_MAX	2	/* Indicates maximum # of segments */
+
+/* The capacity (in 512-byte sectors).  8 bytes. */
+#define VIRTIO_CONFIG_BLK_F_CAPACITY	0
+/* The maximum segment size. 4 bytes. */
+#define VIRTIO_CONFIG_BLK_F_SIZE_MAX	0x08
+/* The maximum number of segments.  4 bytes. */
+#define VIRTIO_CONFIG_BLK_F_SEG_MAX	0x0A
 
 /* These two define direction. */
 #define VIRTIO_BLK_T_IN		0
diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index bcc0188..70bb260 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -5,7 +5,7 @@
  * store and access that space differently. */
 #include <linux/types.h>
 
-/* Status byte for guest to report progress, and synchronize config. */
+/* Status byte for guest to report progress, and synchronize features. */
 /* We have seen device and processed generic fields (VIRTIO_CONFIG_F_VIRTIO) */
 #define VIRTIO_CONFIG_S_ACKNOWLEDGE	1
 /* We have found a driver for the device. */
@@ -15,34 +15,27 @@
 /* We've given up on this device. */
 #define VIRTIO_CONFIG_S_FAILED		0x80
 
-/* Feature byte (actually 7 bits availabe): */
-/* Requirements/features of the virtio implementation. */
-#define VIRTIO_CONFIG_F_VIRTIO 1
-/* Requirements/features of the virtqueue (may have more than one). */
-#define VIRTIO_CONFIG_F_VIRTQUEUE 2
-
 #ifdef __KERNEL__
 struct virtio_device;
 
 /**
  * virtio_config_ops - operations for configuring a virtio device
- * @find: search for the next configuration field of the given type.
+ * @feature: search for a feature in this config
  *	vdev: the virtio_device
- *	type: the feature type
- *	len: the (returned) length of the field if found.
- *	Returns a token if found, or NULL.  Never returnes the same field twice
- *	(ie. it's used up).
- * @get: read the value of a configuration field after find().
+ *	bit: the feature bit
+ *	Returns true if the feature is supported.  Acknowledges the feature
+ *	so the host can see it.
+ * @get: read the value of a configuration field
  *	vdev: the virtio_device
- *	token: the token returned from find().
+ *	offset: the offset of the configuration field
  *	buf: the buffer to write the field value into.
- *	len: the length of the buffer (given by find()).
+ *	len: the length of the buffer
  *	Note that contents are conventionally little-endian.
- * @set: write the value of a configuration field after find().
+ * @set: write the value of a configuration field
  *	vdev: the virtio_device
- *	token: the token returned from find().
+ *	offset: the offset of the configuration field
  *	buf: the buffer to read the field value from.
- *	len: the length of the buffer (given by find()).
+ *	len: the length of the buffer
  *	Note that contents are conventionally little-endian.
  * @get_status: read the status byte
  *	vdev: the virtio_device
@@ -50,62 +43,63 @@ struct virtio_device;
  * @set_status: write the status byte
  *	vdev: the virtio_device
  *	status: the new status byte
- * @find_vq: find the first VIRTIO_CONFIG_F_VIRTQUEUE and create a virtqueue.
+ * @find_vq: find a virtqueue and instantiate it.
  *	vdev: the virtio_device
+ *	index: the 0-based virtqueue number in case there's more than one.
  *	callback: the virqtueue callback
- *	Returns the new virtqueue or ERR_PTR().
+ *	Returns the new virtqueue or ERR_PTR() (eg. -ENOENT).
  * @del_vq: free a virtqueue found by find_vq().
  */
 struct virtio_config_ops
 {
-	void *(*find)(struct virtio_device *vdev, u8 type, unsigned *len);
-	void (*get)(struct virtio_device *vdev, void *token,
+	bool (*feature)(struct virtio_device *vdev, unsigned bit);
+	void (*get)(struct virtio_device *vdev, unsigned offset,
 		    void *buf, unsigned len);
-	void (*set)(struct virtio_device *vdev, void *token,
+	void (*set)(struct virtio_device *vdev, unsigned offset,
 		    const void *buf, unsigned len);
 	u8 (*get_status)(struct virtio_device *vdev);
 	void (*set_status)(struct virtio_device *vdev, u8 status);
 	struct virtqueue *(*find_vq)(struct virtio_device *vdev,
+				     unsigned index,
 				     bool (*callback)(struct virtqueue *));
 	void (*del_vq)(struct virtqueue *vq);
 };
 
 /**
- * virtio_config_val - get a single virtio config and mark it used.
- * @config: the virtio config space
- * @type: the type to search for.
+ * virtio_config_val - look for a feature and get a single virtio config.
+ * @vdev: the virtio device
+ * @fbit: the feature bit
+ * @offset: the type to search for.
  * @val: a pointer to the value to fill in.
  *
- * Once used, the config type is marked with VIRTIO_CONFIG_F_USED so it can't
- * be found again.  This version does endian conversion. */
-#define virtio_config_val(vdev, type, v) ({				\
-	int _err = __virtio_config_val((vdev),(type),(v),sizeof(*(v))); \
-									\
-	BUILD_BUG_ON(sizeof(*(v)) != 1 && sizeof(*(v)) != 2		\
-		     && sizeof(*(v)) != 4 && sizeof(*(v)) != 8);	\
-	if (!_err) {							\
-		switch (sizeof(*(v))) {					\
-		case 2: le16_to_cpus((__u16 *) v); break;		\
-		case 4: le32_to_cpus((__u32 *) v); break;		\
-		case 8: le64_to_cpus((__u64 *) v); break;		\
-		}							\
-	}								\
+ * The return value is -ENOENT if the feature doesn't exist.  Otherwise
+ * the value is endian-corrected and returned in v. */
+#define virtio_config_val(vdev, fbit, offset, v) ({			\
+	int _err;							\
+	if ((vdev)->config->feature((vdev), (fbit))) {			\
+		__virtio_config_val((vdev), (offset), (v));		\
+		_err = 0;						\
+	} else								\
+		_err = -ENOENT;						\
 	_err;								\
 })
 
-int __virtio_config_val(struct virtio_device *dev,
-			u8 type, void *val, size_t size);
-
 /**
- * virtio_use_bit - helper to use a feature bit in a bitfield value.
- * @dev: the virtio device
- * @token: the token as returned from vdev->config->find().
- * @len: the length of the field.
- * @bitnum: the bit to test.
+ * __virtio_config_val - get a single virtio config without feature check.
+ * @vdev: the virtio device
+ * @offset: the type to search for.
+ * @val: a pointer to the value to fill in.
  *
- * If handed a NULL token, it returns false, otherwise returns bit status.
- * If it's one, it sets the mirroring acknowledgement bit. */
-int virtio_use_bit(struct virtio_device *vdev,
-		   void *token, unsigned int len, unsigned int bitnum);
+ * The value is endian-corrected and returned in v. */
+#define __virtio_config_val(vdev, offset, v) do {			\
+	BUILD_BUG_ON(sizeof(*(v)) != 1 && sizeof(*(v)) != 2		\
+		     && sizeof(*(v)) != 4 && sizeof(*(v)) != 8);	\
+	(vdev)->config->get((vdev), (offset), (v), sizeof(*(v)));	\
+	switch (sizeof(*(v))) {						\
+	case 2: le16_to_cpus((__u16 *) v); break;			\
+	case 4: le32_to_cpus((__u32 *) v); break;			\
+	case 8: le64_to_cpus((__u64 *) v); break;			\
+	}								\
+} while(0)
 #endif /* __KERNEL__ */
 #endif /* _LINUX_VIRTIO_CONFIG_H */
diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
index ae469ae..8bf1602 100644
--- a/include/linux/virtio_net.h
+++ b/include/linux/virtio_net.h
@@ -5,16 +5,16 @@
 /* The ID for virtio_net */
 #define VIRTIO_ID_NET	1
 
-/* The bitmap of config for virtio net */
-#define VIRTIO_CONFIG_NET_F	0x40
+/* The feature bitmap for virtio net */
 #define VIRTIO_NET_F_NO_CSUM	0
 #define VIRTIO_NET_F_TSO4	1
 #define VIRTIO_NET_F_UFO	2
 #define VIRTIO_NET_F_TSO4_ECN	3
 #define VIRTIO_NET_F_TSO6	4
+#define VIRTIO_NET_F_MAC	5
 
-/* The config defining mac address. */
-#define VIRTIO_CONFIG_NET_MAC_F	0x41
+/* The config defining mac address (6 bytes) */
+#define VIRTIO_CONFIG_NET_MAC_F	0
 
 /* This is the first element of the scatter-gather list.  If you don't
  * specify GSO or CSUM features, you can simply ignore the header. */
