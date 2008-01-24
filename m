Return-Path: <linux-kernel-owner+w=401wt.eu-S1755588AbYAXTZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588AbYAXTZt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 14:25:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753421AbYAXTZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 14:25:39 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:38008 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476AbYAXTZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 14:25:38 -0500
Date: Thu, 24 Jan 2008 21:25:35 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Greg KH <greg@kroah.com>
cc: Wilco Beekhuizen <wilcobeekhuizen@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Missing usb_find_device symbol from usb.c
In-Reply-To: <20080124180313.GA16006@kroah.com>
Message-ID: <Pine.LNX.4.64.0801242122200.17171@sbz-30.cs.Helsinki.FI>
References: <6c4c86470801221118x530ee074qedb1da5eac1ca473@mail.gmail.com>
 <20080124013720.GA21978@kroah.com> <6c4c86470801240205u5361e090jc057270b03b5ebe7@mail.gmail.com>
 <84144f020801240319o1f51613fx6e823120f74a9cf9@mail.gmail.com>
 <20080124164418.GA8226@kroah.com> <84144f020801240906l7e018a95wfd4ad7736851dd63@mail.gmail.com>
 <20080124172049.GA9665@kroah.com> <84144f020801240942y1c75c82geddc250b7e7814ac@mail.gmail.com>
 <20080124180313.GA16006@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Thu, Jan 24, 2008 at 07:42:20PM +0200, Pekka Enberg wrote:
> > Yeah, that would work but why do we want to mount all devices under
> > the same mount point? If you move device discovery to ->probe() it's
> > simple to have per-device mount points by overriding ->get_sb() to
> > check for USB_DEVICE_MAJOR and look up the actual device, no?
> > Otherwise you have to deal with device plug/unplug at filesystem
> > level...
 
On Thu, 24 Jan 2008, Greg KH wrote:
> Yes, you could do that (per device mount), but it might be confusing for
> users to have to control things that way.

Well, that's how it works for all other music players (especially ones 
that support USB storage natively). But anyway, here's a skeleton driver 
for what I was proposing in case someone is interested.

			Pekka

---
 drivers/usb/misc/Kconfig  |    6 
 drivers/usb/misc/Makefile |    1 
 drivers/usb/misc/iriver.c |  312 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 319 insertions(+)

Index: linux-2.6/drivers/usb/misc/iriver.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/drivers/usb/misc/iriver.c	2008-01-24 21:15:07.000000000 +0200
@@ -0,0 +1,312 @@
+#include <linux/kref.h>
+#include <linux/module.h>
+#include <linux/mount.h>
+#include <linux/namei.h>
+#include <linux/usb.h>
+
+#define USB_IRIVER_MINOR_BASE	128	/* FIXME: ask for one */
+
+#define IRIVER_VENDOR_ID	0x4102
+
+static struct usb_device_id iriver_table[] = {
+	{ USB_DEVICE(IRIVER_VENDOR_ID, 0x1001) },
+	{ USB_DEVICE(IRIVER_VENDOR_ID, 0x1003) },
+	{ USB_DEVICE(IRIVER_VENDOR_ID, 0x1005) },
+	{ USB_DEVICE(IRIVER_VENDOR_ID, 0x1007) },
+	{ USB_DEVICE(IRIVER_VENDOR_ID, 0x1008) },
+	{ USB_DEVICE(IRIVER_VENDOR_ID, 0x1010) },
+	{ }
+};
+MODULE_DEVICE_TABLE(usb, iriver_table);
+
+struct iriver_device {
+	struct usb_device	*udev;
+	struct usb_interface	*interface;
+	unsigned char		*bulk_in_buffer;
+	size_t			bulk_in_size;
+	__u8			bulk_in_endpoint_addr;
+	__u8			bulk_out_endpoint_addr;
+	struct mutex		mutex;
+	struct kref		kref;
+};
+#define to_iriver_dev(d) container_of(d, struct iriver_device, kref)
+
+static struct usb_class_driver iriver_class = {
+	.name =		"iriver%d",
+	.minor_base =	USB_IRIVER_MINOR_BASE,
+};
+
+static void iriver_delete(struct kref *kref)
+{
+	struct iriver_device *dev = to_iriver_dev(kref);
+
+	usb_put_dev(dev->udev);
+	kfree(dev);
+}
+
+static void iriver_disconnect(struct usb_interface *interface)
+{
+	struct iriver_device *dev;
+
+	dev = usb_get_intfdata(interface);
+	usb_set_intfdata(interface, NULL);
+
+	usb_deregister_dev(interface, &iriver_class);
+	kref_put(&dev->kref, iriver_delete);
+}
+
+static int iriver_probe(struct usb_interface *interface,
+			const struct usb_device_id *id)
+{
+	struct usb_host_interface *iface_desc;
+	struct iriver_device *dev;
+	int i, err;
+
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (!dev)
+		return -ENOMEM;
+	kref_init(&dev->kref);
+	mutex_init(&dev->mutex);
+
+	dev->udev = usb_get_dev(interface_to_usbdev(interface));
+	dev->interface = interface;
+
+	iface_desc = interface->cur_altsetting;
+	for (i = 0; i < iface_desc->desc.bNumEndpoints; ++i) {
+		struct usb_endpoint_descriptor *endpoint;
+
+		endpoint = &iface_desc->endpoint[i].desc;
+
+		if (!dev->bulk_in_endpoint_addr &&
+		    usb_endpoint_is_bulk_in(endpoint)) {
+			size_t buffer_size;
+
+			buffer_size = le16_to_cpu(endpoint->wMaxPacketSize);
+			dev->bulk_in_size = buffer_size;
+			dev->bulk_in_endpoint_addr = endpoint->bEndpointAddress;
+			dev->bulk_in_buffer = kmalloc(buffer_size, GFP_KERNEL);
+			if (!dev->bulk_in_buffer) {
+				err = -ENOMEM;
+				goto failed;
+			}
+		}
+
+		if (!dev->bulk_out_endpoint_addr &&
+		    usb_endpoint_is_bulk_out(endpoint))
+			dev->bulk_out_endpoint_addr = endpoint->bEndpointAddress;
+	}
+	if (!dev->bulk_in_endpoint_addr || !dev->bulk_out_endpoint_addr) {
+		err = -EINVAL;
+		goto failed;
+	}
+	usb_set_intfdata(interface, dev);
+
+	err = usb_register_dev(interface, &iriver_class);
+	if (err) {
+		usb_set_intfdata(interface, NULL);
+		goto failed;
+	}
+	return 0;
+failed:
+	if (dev)
+		kref_put(&dev->kref, iriver_delete);
+	return err;
+}
+
+static struct usb_driver iriver_driver = {
+	.name		= "iriver",
+	.probe		= iriver_probe,
+	.disconnect	= iriver_disconnect,
+	.id_table	= iriver_table,
+};
+
+#define IRIVERFS_MAGIC 0xdeadbeef
+#define IRIVERFS_BLOCK_SIZE 512
+#define IRIVERFS_BLOCK_BITS 9
+
+static int iriver_set_super(struct super_block *sb, void *data)
+{
+	sb->s_fs_info = data;
+	return set_anon_super(sb, data);
+}
+
+static struct iriver_device *iriver_sb_info(struct super_block *sb)
+{
+	return sb->s_fs_info;
+}
+
+static void iriver_kill_sb(struct super_block *sb)
+{
+	generic_shutdown_super(sb);
+}
+
+static int iriverfs_readdir(struct file *file, void *dirent, filldir_t filldir)
+{
+	struct dentry *dentry = file->f_dentry;
+	struct super_block *sb = dentry->d_sb;
+	struct iriver_device *dev;
+
+	dev = iriver_sb_info(sb);
+	mutex_lock(&dev->mutex);
+	/*
+	 *	TODO: Fill in the blank.
+	 */
+	mutex_unlock(&dev->mutex);
+	return dcache_readdir(file, dirent, filldir);
+}
+
+static struct file_operations iriverfs_dir_ops = {
+	.open		= dcache_dir_open,
+	.release	= dcache_dir_close,
+	.read		= generic_read_dir,
+	.readdir	= iriverfs_readdir,
+};
+
+static struct dentry *iriverfs_lookup(struct inode *dir,
+				      struct dentry *dentry,
+				      struct nameidata *nd)
+{
+	return NULL;
+}
+
+static struct inode_operations iriverfs_dir_inode_ops = {
+	.lookup		= iriverfs_lookup,
+};
+
+static struct inode *iriver_get_inode(struct super_block *sb, int mode)
+{
+	struct inode *inode = new_inode(sb);
+	if (inode) {
+		switch (mode & S_IFMT) {
+		case S_IFDIR:
+			inode->i_op = &iriverfs_dir_inode_ops;
+			inode->i_fop = &iriverfs_dir_ops;
+			break;
+		default:
+			BUG();
+		}
+	}
+	return inode;
+}
+
+static const struct super_operations iriverfs_ops = {
+	.drop_inode	= generic_delete_inode,
+};
+
+static int iriver_fill_super(struct super_block *sb, void *data, int silent)
+{
+	struct dentry *root;
+	struct inode *inode;
+	int err;
+
+	sb->s_maxbytes = MAX_LFS_FILESIZE;
+	sb->s_blocksize = IRIVERFS_BLOCK_SIZE;
+	sb->s_blocksize_bits = IRIVERFS_BLOCK_BITS;
+	sb->s_magic = IRIVERFS_MAGIC;
+	sb->s_op = &iriverfs_ops;
+
+	inode = iriver_get_inode(sb, S_IFDIR | 0755);
+	if (!inode)
+		return -ENOMEM;
+
+	root = d_alloc_root(inode);
+	if (!root) {
+		iput(inode);
+		err = -ENOMEM;
+	}
+	sb->s_root = root;
+
+	return 0;
+}
+
+static int iriver_get_sb(struct file_system_type *fs_type, int flags,
+			 const char *dev_name, void *data,
+			 struct vfsmount *mnt)
+{
+	struct usb_interface *interface;
+	struct iriver_device *dev;
+	struct super_block *sb;
+	struct nameidata nd;
+	unsigned minor;
+	int err;
+
+	if (!dev_name)
+		return -EINVAL;
+
+	err = path_lookup(dev_name, LOOKUP_FOLLOW, &nd);
+	if (err)
+		return err;
+
+	if (nd.mnt->mnt_flags & MNT_NODEV) {
+		err = -EACCES;
+		goto error;
+	}
+	if (imajor(nd.dentry->d_inode) != USB_DEVICE_MAJOR) {
+		err = -EINVAL;
+		goto error;
+	}
+	minor = iminor(nd.dentry->d_inode);
+	path_release(&nd);
+	interface = usb_find_interface(&iriver_driver, minor);
+	if (!interface) {
+		err = -ENODEV;
+		goto error;
+	}
+	dev = usb_get_intfdata(interface);
+	sb = sget(fs_type, NULL, iriver_set_super, dev);
+	if (IS_ERR(sb)) {
+		err = PTR_ERR(sb);
+		goto error;
+	}
+	if (sb->s_root) {
+		err = -EBUSY;
+		goto error;
+	}
+	sb->s_flags = flags;
+	err = iriver_fill_super(sb, data, flags & MS_SILENT ? 1 : 0);
+	if (err) {
+		up_write(&sb->s_umount);
+		deactivate_super(sb);
+		goto error;
+	}
+	sb->s_flags |= MS_ACTIVE;
+	return simple_set_mnt(mnt, sb);
+error:
+	path_release(&nd);
+	return err;
+}
+
+static struct file_system_type iriverfs_fs_type = {
+	.owner		= THIS_MODULE,
+	.name		= "iriverfs",
+	.get_sb		= iriver_get_sb,
+	.kill_sb	= iriver_kill_sb,
+	.fs_flags	= FS_REQUIRES_DEV,
+};
+
+static int __init iriver_init(void)
+{
+	int err;
+
+	err = usb_register(&iriver_driver);
+	if (err)
+		return err;
+
+	err = register_filesystem(&iriverfs_fs_type);
+	if (err) {
+		usb_deregister(&iriver_driver);
+		return err;
+	}
+	return 0;
+}
+
+static void __exit iriver_exit(void)
+{
+	unregister_filesystem(&iriverfs_fs_type);
+	usb_deregister(&iriver_driver);
+}
+
+module_init(iriver_init);
+module_exit(iriver_exit);
+
+MODULE_LICENSE("GPL");
Index: linux-2.6/drivers/usb/misc/Kconfig
===================================================================
--- linux-2.6.orig/drivers/usb/misc/Kconfig	2008-01-24 21:15:14.000000000 +0200
+++ linux-2.6/drivers/usb/misc/Kconfig	2008-01-24 21:16:22.000000000 +0200
@@ -269,3 +269,9 @@
 	  See <http://www.linux-usb.org/usbtest/> for more information,
 	  including sample test device firmware and "how to use it".
 
+config USB_IRIVER
+	tristate "iRiver iFP portable music player driver (DEVELOPMENT)"
+	depends on USB && EXPERIMENTAL
+	help
+	  This is a driver for the iRiver iFP portable music player.
+
Index: linux-2.6/drivers/usb/misc/Makefile
===================================================================
--- linux-2.6.orig/drivers/usb/misc/Makefile	2008-01-24 21:16:33.000000000 +0200
+++ linux-2.6/drivers/usb/misc/Makefile	2008-01-24 21:16:46.000000000 +0200
@@ -26,6 +26,7 @@
 obj-$(CONFIG_USB_TEST)		+= usbtest.o
 obj-$(CONFIG_USB_TRANCEVIBRATOR)	+= trancevibrator.o
 obj-$(CONFIG_USB_USS720)	+= uss720.o
+obj-$(CONFIG_IRIVER)		+= iriver.o
 
 obj-$(CONFIG_USB_SISUSBVGA)	+= sisusbvga/
 
