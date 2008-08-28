Return-Path: <linux-kernel-owner+w=401wt.eu-S1756808AbYH1UIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808AbYH1UIU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 16:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754113AbYH1UIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 16:08:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45412 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753660AbYH1UIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 16:08:09 -0400
Date: Thu, 28 Aug 2008 13:07:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: fuse-devel@lists.sourceforge.net, miklos@szeredi.hu, greg@kroah.com,
       linux-kernel@vger.kernel.org, tj@kernel.org
Subject: Re: [PATCH 5/5] CUSE: implement CUSE - Character device in
 Userspace
Message-Id: <20080828130740.344f7213.akpm@linux-foundation.org>
In-Reply-To: <1219947544-666-6-git-send-email-tj@kernel.org>
References: <1219947544-666-1-git-send-email-tj@kernel.org>
	<1219947544-666-6-git-send-email-tj@kernel.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Aug 2008 03:19:04 +0900
Tejun Heo <tj@kernel.org> wrote:

> CUSE enables implementing character devices in userspace.  With recent
> additions of nonblock, lseek, ioctl and poll support, FUSE already has
> most of what's necessary to implement character devices.  All CUSE has
> to do is bonding all those components - FUSE, chardev and the driver
> model - nicely.
> 
> Due to the number of different objects involved and many ways an
> instance can fail, object lifetime rules are a tad bit complex.
> Please take a look at the comment on top of fs/fuse/cuse.c for
> details.
> 
> Other than that, it's mostly straight forward.  Client opens
> /dev/cuse, kernel starts conversation with CUSE_INIT.  The client
> tells CUSE which device it wants to create.  CUSE creates the device
> for the client and the rest works the same way as in a direct IO FUSE
> session.
> 
> Each CUSE device has a corresponding directory /sys/class/cuse/DEVNAME
> (which is symlink to /sys/devices/virtual/class/DEVNAME if
> SYSFS_DEPRECATED is turned off) which hosts "waiting" and "abort"
> among other things.  Those two files have the same meaning as the FUSE
> control files.
> 
> The only notable lacking feature compared to in-kernel implementation
> is mmap support.
> 
> ...
>
> +config CUSE
> +	tristate "Character device in Userpace support"
> +	depends on FUSE_FS

Will this work (usefully) if CONFIG_SYSFS=n?

>
> ...
>
> +#include <linux/fs.h>
> +#include <linux/file.h>
> +#include <linux/stat.h>
> +#include <linux/cdev.h>
> +#include <linux/device.h>
> +#include <linux/kdev_t.h>
> +#include <linux/kthread.h>
> +#include <linux/miscdevice.h>
> +#include <linux/cuse.h>
> +
> +#include "fuse_i.h"
> +
> +#define CUSE_SUPER_MAGIC	0x43555345

Put in include/linux/magic.h?

> +struct cuse_conn {
> +	struct fuse_conn	fc;
> +	struct cdev		cdev;
> +	struct vfsmount		*mnt;
> +	struct device		*dev;
> +	bool			cdev_added:1;
> +	bool			disconnected:1;	/* channel disconnected */

I didn't know you could do that with bools.

These two fields will share a word, and modifications of one are racy
wrt modifications of the other.  So some form of locking is needed, and
a comment describing that locking here would be beneficial.

> +	char			*uevent_envp[UEVENT_NUM_ENVP + 1];
> +	char			*uevent_env_buf;
> +};
> +
> +#define fc_to_cc(_fc)		container_of((_fc), struct cuse_conn, fc)
> +#define cdev_to_cc(_cdev)	container_of((_cdev), struct cuse_conn, cdev)
> +#define cuse_conn_get(cc)	({mntget((cc)->mnt); cc;})
> +#define cuse_conn_put(cc)	mntput((cc)->mnt)

I believe all the above could be implemented in C.

Making that change would fix the bug in cuse_conn_get(), which
references its arg twice.

>
> ...
>
> +static int cuse_fill_super(struct super_block *sb, void *data, int silent)
> +{
> +	struct cuse_conn *cc = NULL;

this initialisation wasn't needed.

> +	struct dentry *root_dentry = NULL;
> +	struct inode *root = NULL;
> +	int rc;
> +
> +	sb->s_magic = CUSE_SUPER_MAGIC;
> +	sb->s_op = &fuse_super_operations;
> +	sb->s_maxbytes = MAX_LFS_FILESIZE;
> +
> +	cc = kzalloc(sizeof(*cc), GFP_KERNEL);
> +	if (!cc)
> +		goto err_nomem;
> +	rc = fuse_conn_init(&cc->fc, sb);
> +	if (rc)
> +		goto err;
> +
> +	/* cuse isn't accessible to mortal users, give it some latitude */
> +	cc->fc.flags = FUSE_ALLOW_OTHER;
> +	cc->fc.user_id = current->euid;
> +	cc->fc.group_id = current->egid;
> +	cc->fc.max_read = FUSE_MAX_PAGES_PER_REQ * PAGE_SIZE;
> +	cc->fc.release = cuse_fc_release;
> +
> +	/* transfer the initial cc refcnt to sb */
> +	sb->s_fs_info = &cc->fc;
> +	cc = NULL;
> +
> +	root = fuse_get_root_inode(sb, S_IFREG);
> +	if (!root)
> +		goto err_nomem;
> +
> +	root_dentry = d_alloc_root(root);
> +	if (!root_dentry)
> +		goto err_nomem;
> +
> +	sb->s_root = root_dentry;
> +
> +	return 0;
> +
> + err_nomem:
> +	rc = -ENOMEM;
> + err:
> +	if (root_dentry)
> +		dput(root_dentry);
> +	else if (root)
> +		iput(root);
> +	kfree(cc);
> +	return rc;
> +}
> +
>
> ...
>
> +static int cuse_parse_one(char **pp, char *end, char **keyp, char **valp)
> +{
> +	char *p = *pp;
> +	char *key, *val;
> +
> +	while (p < end && *p == '\0')
> +		p++;
> +	if (p == end)
> +		return 0;
> +
> +	if (end[-1] != '\0') {
> +		printk(KERN_ERR "CUSE: info not properly terminated\n");
> +		return -EINVAL;
> +	}
> +
> +	key = val = p;
> +	p += strlen(p);
> +
> +	if (valp) {
> +		strsep(&val, "=");
> +		if (!val)
> +			val = key + strlen(key);
> +		key = strstrip(key);
> +		val = strstrip(val);
> +	} else
> +		key = strstrip(key);
> +
> +	if (!strlen(key)) {
> +		printk(KERN_ERR "CUSE: zero length info key specified\n");
> +		return -EINVAL;
> +	}
> +
> +	*pp = p;
> +	*keyp = key;
> +	if (valp)
> +		*valp = val;
> +
> +	return 1;
> +}

OK, I have NFI whatsoever what this thing is doing and I am disinclined
to reverse-engineer it.

If this is parsing something whcih operators/users provided then it
should have been documented somewhere?

Whether it is or isn't doing that, this function really really really
needs a comment telling readers (ie: me) what it does.  Or what it
tries to do, anyway.

> +struct cuse_devinfo {
> +	const char		*name;
> +};
> +
> +static int cuse_parse_devinfo(char *p, size_t len, struct cuse_devinfo *devinfo)
> +{
> +	char *end = p + len;
> +	char *key, *val;
> +	int rc;
> +
> +	while (true) {
> +		rc = cuse_parse_one(&p, end, &key, &val);
> +		if (rc < 0)
> +			return rc;
> +		if (!rc)
> +			break;
> +		if (strcmp(key, "DEVNAME") == 0)
> +			devinfo->name = val;
> +		else
> +			printk(KERN_WARNING "CUSE: unknown device info \"%s\"\n",
> +			       key);
> +	}
> +
> +	if (!devinfo->name || !strlen(devinfo->name)) {
> +		printk(KERN_ERR "CUSE: DEVNAME unspecified\n");
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
>
> ...
>
> +static int cuse_init_worker(void *data)

This functions seems to be woefully misnamed.  The name implies that it
initialises a worker.  But it's a kernel thread?

Could you please document your design somehow?  What does this kernel
thread do?  Why does it exist?  etc.

> +{
> +	struct cuse_conn *cc = data;
> +	struct cuse_init_in iin = { };
> +	struct cuse_init_out iout = { };
> +	struct cuse_devinfo devinfo = { };
> +	struct fuse_req *req;
> +	struct page *page = NULL;
> +	struct device *dev;
> +	bool disconnected;
> +	dev_t devt;
> +	int rc;
> +
> +	BUILD_BUG_ON(CUSE_INIT_INFO_MAX > PAGE_SIZE);
> +
> +	/* identify ourself and query what the CUSE client wants */
> +	req = fuse_get_req(&cc->fc);
> +	if (IS_ERR(req)) {
> +		rc = PTR_ERR(req);
> +		goto out;
> +	}
> +
> +	rc = -ENOMEM;
> +	page = alloc_pages(GFP_KERNEL | __GFP_ZERO, 1);
> +	if (!page)
> +		goto out;
> +
> +	req->pages[0] = nth_page(page, 0);
> +	req->pages[1] = nth_page(page, 1);
> +	req->num_pages = 2;
> +
> +	req->in.h.opcode = CUSE_INIT;
> +	req->in.h.nodeid = get_node_id(cc->mnt->mnt_sb->s_root->d_inode);
> +	req->in.numargs = 1;
> +	req->in.args[0].size = sizeof(iin);
> +	req->in.args[0].value = &iin;
> +
> +	iin.ver_major = CUSE_KERNEL_VERSION;
> +	iin.ver_minor = CUSE_KERNEL_MINOR_VERSION;
> +
> +	req->out.numargs = 2;
> +	req->out.args[0].size = sizeof(iout);
> +	req->out.args[0].value = &iout;
> +	req->out.args[1].size = 2 * CUSE_INIT_INFO_MAX;
> +	req->out.argpages = 1;
> +	req->out.argvar = 1;
> +
> +	fuse_request_send(&cc->fc, req);
> +	rc = req->out.h.error;
> +	if (rc)
> +		goto out;
> +
> +	rc = -EOVERFLOW;
> +	if (iout.dev_info_len > CUSE_INIT_INFO_MAX ||
> +	    iout.hotplug_info_len > CUSE_INIT_INFO_MAX)
> +		goto out;
> +
> +	rc = cuse_parse_devinfo(page_address(page), iout.dev_info_len,
> +				&devinfo);
> +	if (rc)
> +		goto out;
> +
> +	/* hotplug info is also used during device release, copy and parse */

hotplug?  What's all this?  Seems to have something to do with an
as-yet-undescribed relationship with udev?

> +	rc = -ENOMEM;
> +	cc->uevent_env_buf = kmalloc(iout.hotplug_info_len, GFP_KERNEL);
> +	if (!cc->uevent_env_buf)
> +		goto out;
> +
> +	memcpy(cc->uevent_env_buf, page_address(page) + iout.dev_info_len,
> +	       iout.hotplug_info_len);
> +
> +	rc = cuse_parse_hotplug_envp(cc->uevent_env_buf, iout.hotplug_info_len,
> +				     cc->uevent_envp, UEVENT_NUM_ENVP);
> +	if (rc)
> +		goto out;
> +
> +	devt = MKDEV(iout.dev_major, iout.dev_minor);
> +	if (!MAJOR(devt))
> +		rc = alloc_chrdev_region(&devt, MINOR(devt), 1, devinfo.name);
> +	else
> +		rc = register_chrdev_region(devt, 1, devinfo.name);
> +	if (rc) {
> +		printk(KERN_ERR "CUSE: failed to register chrdev region\n");
> +		goto out;
> +	}
> +
> +	/* We now have MAJ, MIN and name.  Let's create the device */
> +	rc = -ENOMEM;
> +	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
> +	if (!dev)
> +		goto out_unregister_chrdev_region;
> +	device_initialize(dev);
> +	dev->class = cuse_class;
> +	dev->devt = devt;
> +	dev->release = cuse_gendev_release;
> +	dev_set_drvdata(dev, cc);
> +	dev_set_name(dev, "%s", devinfo.name);
> +
> +	rc = device_add(dev);
> +	if (rc)
> +		goto out_put_device;
> +
> +	/* register cdev */
> +	cdev_init(&cc->cdev, &cuse_frontend_fops);
> +	cc->cdev.owner = THIS_MODULE;
> +	cc->cdev.release = cuse_cdev_release;
> +	kobject_set_name(&cc->cdev.kobj, "%s", devinfo.name);
> +
> +	rc = cdev_add(&cc->cdev, devt, 1);
> +	if (rc)
> +		goto out_put_device;
> +	cuse_conn_get(cc);	/* will be released on cdev final put */
> +
> +	/* transfer dev and cdev ownership to channel */
> +	spin_lock(&cuse_disconnect_lock);
> +	disconnected = cc->disconnected;
> +	if (!disconnected) {
> +		cc->dev = dev;
> +		cc->cdev_added = true;
> +	}
> +	spin_unlock(&cuse_disconnect_lock);
> +
> +	if (disconnected)
> +		goto out_cdev_del;
> +
> +	rc = 0;
> +	goto out;
> +
> + out_cdev_del:
> +	cdev_del(&cc->cdev);
> + out_put_device:
> +	put_device(dev);
> + out_unregister_chrdev_region:
> +	unregister_chrdev_region(devt, 1);
> + out:
> +	if (!IS_ERR(req))
> +		fuse_put_request(&cc->fc, req);
> +	if (page)
> +		__free_pages(page, 1);
> +
> +	if (rc)
> +		fuse_abort_conn(&cc->fc);
> +
> +	cuse_conn_put(cc);
> +	return rc;
> +}

So...  basically this undocumented kernel thread will for undocumented
reasons create the device node?

An obvious question which the reader of the code will ask is "why
wasn't that done synchronously"?

> +static int cuse_channel_open(struct inode *inode, struct file *file)
> +{
> +	struct cuse_conn *cc;
> +	struct vfsmount *mnt;
> +	struct fuse_req *init_req;
> +	struct task_struct *worker;
> +	int rc;
> +
> +	/* Set up cuse_conn.  cuse_conn will be created when filling
> +	 * in superblock for the following kern_mount().
> +	 */
> +	mnt = kern_mount(&cuse_fs);
> +	if (IS_ERR(mnt))
> +		return PTR_ERR(mnt);
> +
> +	cc = fc_to_cc(get_fuse_conn_super(mnt->mnt_sb));
> +	cc->mnt = mnt;
> +
> +	/* let's send fuse init request */
> +	rc = -ENOMEM;
> +	init_req = fuse_request_alloc();
> +	if (!init_req)
> +		goto err_cc_put;
> +
> +	cc->fc.connected = 1;
> +	file->private_data = fuse_conn_get(&cc->fc);
> +	fuse_send_init(&cc->fc, init_req);
> +
> +	/* Okay, FUSE part of initialization is complete.  The rest of
> +	 * the initialization is a bit more involved and requires
> +	 * conversing with userland.  Start a kthread.
> +	 */
> +	worker = kthread_run(cuse_init_worker, cuse_conn_get(cc),
> +			     "cuse-init-pid%d", current->pid);

current->pid is non-unique in a containerised setup.  What are the
implications of this?  It needs a comment, because the containerisation
guys will end up coming here and scratching their heads over the same
question.

> +	if (IS_ERR(worker)) {
> +		fput(file);
> +		rc = PTR_ERR(worker);
> +		goto err_cc_put;
> +	}
> +
> +	return 0;
> +
> + err_cc_put:
> +	cuse_conn_put(cc);
> +	return rc;
> +}
> +
> +static int cuse_channel_release(struct inode *inode, struct file *file)
> +{
> +	struct cuse_conn *cc = fc_to_cc(file->private_data);
> +	int rc;
> +
> +	spin_lock(&cuse_disconnect_lock);
> +	cc->disconnected = true;
> +	spin_unlock(&cuse_disconnect_lock);
> +
> +	rc = fuse_dev_release(inode, file);
> +	if (rc)
> +		return rc;
> +
> +	if (cc->dev)
> +		device_unregister(cc->dev);
> +	if (cc->cdev_added) {
> +		unregister_chrdev_region(cc->cdev.dev, 1);
> +		cdev_del(&cc->cdev);
> +	}
> +	cuse_conn_put(cc);
> +
> +	return 0;
> +}
> +
> +static struct file_operations cuse_channel_fops; /* initialized during init */

This reader is wondering what a "channel" is.  Understanding high-level
concepts like this is important for understanding the implemetnation.

> +
> +static int cuse_class_dev_uevent(struct device *dev,
> +				 struct kobj_uevent_env *env)
> +{
> +	struct cuse_conn *cc = dev_get_drvdata(dev);
> +	int i, rc;
> +
> +	for (i = 0; cc->uevent_envp[i]; i++) {
> +		rc = add_uevent_var(env, "%s", cc->uevent_envp[i]);
> +		if (rc)
> +			return rc;
> +	}
> +	return 0;
> +}
> +
> +ssize_t cuse_class_waiting_show(struct device *dev,
> +				struct device_attribute *attr, char *buf)
> +{
> +	struct cuse_conn *cc = dev_get_drvdata(dev);
> +
> +	return sprintf(buf, "%d\n", atomic_read(&cc->fc.num_waiting));
> +}

<looks in fuse_i.h>

"The number of requests waiting for completion".

Why did you choose to present this particular field?

> +ssize_t cuse_class_abort_store(struct device *dev,
> +			       struct device_attribute *attr,
> +			       const char *buf, size_t count)
> +{
> +	struct cuse_conn *cc = dev_get_drvdata(dev);
> +
> +	fuse_abort_conn(&cc->fc);
> +	return count;
> +}
>
> ...
>
> +static int __init cuse_init(void)
> +{
> +	int rc;
> +
> +	/* inherit and extend fuse_dev_operations */
> +	cuse_channel_fops		= fuse_dev_operations;
> +	cuse_channel_fops.owner		= THIS_MODULE;
> +	cuse_channel_fops.open		= cuse_channel_open;
> +	cuse_channel_fops.release	= cuse_channel_release;

Can't these initialisations be performed at compile-time?

> +	cuse_class = class_create(THIS_MODULE, "cuse");
> +	if (IS_ERR(cuse_class))
> +		return PTR_ERR(cuse_class);
> +	cuse_class->dev_uevent = cuse_class_dev_uevent;
> +	cuse_class->dev_attrs = cuse_class_dev_attrs;
> +
> +	rc = misc_register(&cuse_miscdev);
> +	if (rc)
> +		goto destroy_class;
> +	rc = register_filesystem(&cuse_fs);
> +	if (rc)
> +		goto misc_deregister;
> +	return 0;
> +
> + misc_deregister:
> +	misc_deregister(&cuse_miscdev);
> + destroy_class:
> +	class_destroy(cuse_class);
> +	return rc;
> +}
> +
> +static void __exit cuse_exit(void)
> +{
> +	unregister_filesystem(&cuse_fs);
> +	misc_deregister(&cuse_miscdev);
> +	class_destroy(cuse_class);
> +}
> +
> +module_init(cuse_init);
> +module_exit(cuse_exit);
> +
> +MODULE_AUTHOR("Tejun Heo <tj@kernel.org>");
> +MODULE_DESCRIPTION("Character device in Userspace");
> +MODULE_LICENSE("GPL");
> diff --git a/include/linux/cuse.h b/include/linux/cuse.h
> new file mode 100644
> index 0000000..e875723
> --- /dev/null
> +++ b/include/linux/cuse.h
> @@ -0,0 +1,40 @@
> +/*
> + * CUSE: Character device in Userspace
> + * Copyright (C) 2008       SUSE Linux Products GmbH
> + * Copyright (C) 2008       Tejun Heo <teheo@suse.de>
> + *
> + * This file is released under the GPL.
> + */
> +
> +#ifndef _CUSE_H_
> +#define _CUSE_H_
> +
> +#include <linux/major.h>
> +#include <linux/miscdevice.h>
> +#include <linux/fuse.h>
> +
> +#define CUSE_KERNEL_VERSION		0
> +#define CUSE_KERNEL_MINOR_VERSION	1

Some description of the kernel<->userspace versioning design would be
appropriate.  Is it bi-directional?

> +#define CUSE_KERNEL_MAJOR		MISC_MAJOR
> +#define CUSE_KERNEL_MINOR		MISC_DYNAMIC_MINOR
> +
> +#define CUSE_INIT_INFO_MAX		4096
> +
> +enum cuse_opcode {
> +	CUSE_INIT	= CUSE_BASE,
> +};
> +
> +struct cuse_init_in {
> +	__u32	ver_major;
> +	__u32	ver_minor;
> +};
> +
> +struct cuse_init_out {
> +	__u32	dev_major;		/* chardev major */
> +	__u32	dev_minor;		/* chardev minor */
> +	__u32	dev_info_len;		/* device info */
> +	__u32	hotplug_info_len;	/* uevent envs */
> +};
> +
> +#endif /*_CUSE_H_*/
> diff --git a/include/linux/fuse.h b/include/linux/fuse.h
> index b772b4a..e55c2f2 100644
> --- a/include/linux/fuse.h
> +++ b/include/linux/fuse.h
> @@ -212,6 +212,8 @@ enum fuse_opcode {
>  	FUSE_LSEEK         = 39,
>  	FUSE_IOCTL         = 40,
>  	FUSE_POLL          = 41,
> +
> +	CUSE_BASE          = 4096,
>  };
>  
>  enum fuse_notify_code {

Nice-looking code, but I do not feel able to properly review it with
its current level of description.
