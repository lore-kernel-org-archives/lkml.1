Return-Path: <linux-kernel-owner+w=401wt.eu-S1753937AbYLPUzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937AbYLPUzs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 15:55:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753598AbYLPUzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 15:55:23 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40098 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752689AbYLPUzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 15:55:20 -0500
Date: Tue, 16 Dec 2008 12:54:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: mingo@elte.hu, viro@ftp.linux.org.uk, linux-kernel@vger.kernel.org,
       xen-devel@lists.xensource.com, alex.zeffertt@eu.citrix.com,
       Ian.Campbell@citrix.com
Subject: Re: [PATCH] xen: add xenfs to allow usermode <-> Xen interaction
Message-Id: <20081216125425.30524946.akpm@linux-foundation.org>
In-Reply-To: <49480F39.2010102@goop.org>
References: <49480F39.2010102@goop.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Dec 2008 12:27:37 -0800
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> [ Reviewers: This is in drivers/xen to keep it close to the code it is and will be using.  Would people
>   prefer to see it in fs/xenfs? -J ]

Well it would be nice to keep filesystems under ./fs, but `grep -rl
register_filesystem .' says we screwed that pooch.

> From: Alex Zeffertt <alex.zeffertt@eu.citrix.com>
> 
> The xenfs filesystem exports various interfaces to usermode.  Initially
> this exports a file to allow usermode to interact with xenbus/xenstore.
> 
> Traditionally this appeared in /proc/xen.  Rather than extending procfs,
> this patch adds a backward-compat mountpoint on /proc/xen, and provides
> a xenfs filesystem which can be mounted there.
> 
>
> ...
>
> --- /dev/null
> +++ b/drivers/xen/xenfs/super.c
> @@ -0,0 +1,65 @@
> +/*
> + *  xenfs.c - a filesystem for passing info between the a domain and
> + *  the hypervisor.
> + *
> + * 2008-10-07  Alex Zeffertt    Replaced /proc/xen/xenbus with xenfs filesystem
> + *                              and /proc/xen compatibility mount point.
> + *                              Turned xenfs into a loadable module.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/errno.h>
> +#include <linux/module.h>
> +#include <linux/fs.h>
> +
> +#include "xenfs.h"
> +
> +#include <asm/xen/hypervisor.h>
> +
> +#define XENFS_MAGIC	0xabba1974

Move to include/linux/magic.h, please.

> +MODULE_DESCRIPTION("Xen filesystem");
> +MODULE_LICENSE("GPL");

MODULE_AUTHOR()?

./MAINTAINERS?

> +static int xenfs_fill_super(struct super_block *sb, void *data, int silent)
> +{
> +	static struct tree_descr xenfs_files[] = {
> +		[2] = {"xenbus", &xenbus_file_ops, S_IRUSR|S_IWUSR},
> +		{""},
> +	};
> +
> +	return simple_fill_super(sb, XENFS_MAGIC, xenfs_files);
> +}
> +
>
> ...
>
> +struct xenbus_transaction_holder {
> +	struct list_head list;
> +	struct xenbus_transaction handle;
> +};
> +
> +struct read_buffer {
> +	struct list_head list;
> +	unsigned int cons;
> +	unsigned int len;
> +	char msg[];
> +};
>
> +struct xenbus_file_priv {
> +	/* In-progress transaction. */
> +	struct list_head transactions;
> +
> +	/* Active watches. */
> +	struct list_head watches;
> +
> +	/* Partial request. */
> +	unsigned int len;
> +	union {
> +		struct xsd_sockmsg msg;
> +		char buffer[PAGE_SIZE];
> +	} u;
> +
> +	/* Response queue. */
> +	struct list_head read_buffers;
> +	wait_queue_head_t read_waitq;
> +
> +	struct mutex reply_mutex;
> +};

It would be useful to document the locking for the list_head's (at least).

> +
> +static ssize_t xenbus_file_read(struct file *filp,
> +			       char __user *ubuf,
> +			       size_t len, loff_t *ppos)
> +{
> +	struct xenbus_file_priv *u = filp->private_data;
> +	struct read_buffer *rb;
> +	int i, ret;
> +
> +	mutex_lock(&u->reply_mutex);
> +	while (list_empty(&u->read_buffers)) {
> +		mutex_unlock(&u->reply_mutex);
> +		ret = wait_event_interruptible(u->read_waitq,
> +					       !list_empty(&u->read_buffers));
> +		if (ret)
> +			return ret;
> +		mutex_lock(&u->reply_mutex);
> +	}
> +
> +	rb = list_entry(u->read_buffers.next, struct read_buffer, list);
> +	for (i = 0; i < len;) {
> +		ret = put_user(rb->msg[rb->cons], ubuf + i);

So mmap_sem nests inside ->reply_mutex.  Has this all been carefully
tested with lockdep?

> +		if (ret) {
> +			mutex_unlock(&u->reply_mutex);
> +			return ret;
> +		}
> +		i++;
> +		rb->cons++;
> +		if (rb->cons == rb->len) {
> +			list_del(&rb->list);
> +			kfree(rb);
> +			if (list_empty(&u->read_buffers))
> +				break;
> +			rb = list_entry(u->read_buffers.next,
> +					struct read_buffer, list);
> +		}
> +	}

This code will misbehave if it ever receives a read_buffer with len==0.

> +	mutex_unlock(&u->reply_mutex);
> +
> +	return i;
> +}
> +
> +static int queue_reply(struct list_head *list, char *data, unsigned int len)
> +{
> +	struct read_buffer *rb;
> +
> +	if (len == 0)
> +		return 0;

That should fix it.

> +	rb = kmalloc(sizeof(*rb) + len, GFP_KERNEL);
> +	if (rb == NULL)
> +		return -ENOMEM;
> +
> +	rb->cons = 0;
> +	rb->len = len;
> +
> +	memcpy(rb->msg, data, len);
> +
> +	list_add_tail(&rb->list, list);

So the caller of this function must hold ->reply_mutex.

You thought that was secret but I found it out!

> +	return 0;
> +}
> +
> +/* Free all the read_buffer s on a list.
> + * Caller must have sole reference to list.
> + */
> +static void queue_cleanup(struct list_head  *list)
> +{
> +	struct read_buffer *rb;
> +
> +	while (!list_empty(list)) {
> +		rb = list_entry(list->next, struct read_buffer, list);
> +		list_del(list->next);
> +		kfree(rb);
> +	}
> +}
> +
> +struct watch_adapter {
> +	struct list_head list;

locking is?

> +	struct xenbus_watch watch;
> +	struct xenbus_file_priv *dev_data;
> +	char *token;
> +};
> +
>
> ...
>
> +static LIST_HEAD(watch_list);
> +
> +static ssize_t xenbus_file_write(struct file *filp,
> +				const char __user *ubuf,
> +				size_t len, loff_t *ppos)
> +{
> +	struct xenbus_file_priv *u = filp->private_data;
> +	struct xenbus_transaction_holder *trans = NULL;
> +	uint32_t msg_type;
> +	void *reply;
> +	char *path, *token;
> +	int err, rc = len;
> +	int ret;
> +	LIST_HEAD(staging_q);
> +
> +	if ((len + u->len) > sizeof(u->u.buffer)) {
> +		rc = -EINVAL;
> +		goto out;
> +	}

Now what's this doing?

One would expect a large write to get chunked up into smaller writes by
the kernel.

This code is poorly documented.

> +	if (copy_from_user(u->u.buffer + u->len, ubuf, len) != 0) {
> +		rc = -EFAULT;
> +		goto out;
> +	}
> +
> +	u->len += len;
> +	if ((u->len < sizeof(u->u.msg)) ||
> +	    (u->len < (sizeof(u->u.msg) + u->u.msg.len)))
> +		return rc;
> +
> +	msg_type = u->u.msg.type;
> +
> +	switch (msg_type) {
> +	case XS_TRANSACTION_START:
> +	case XS_TRANSACTION_END:
> +	case XS_DIRECTORY:
> +	case XS_READ:
> +	case XS_GET_PERMS:
> +	case XS_RELEASE:
> +	case XS_GET_DOMAIN_PATH:
> +	case XS_WRITE:
> +	case XS_MKDIR:
> +	case XS_RM:
> +	case XS_SET_PERMS:
> +		if (msg_type == XS_TRANSACTION_START) {
> +			trans = kmalloc(sizeof(*trans), GFP_KERNEL);
> +			if (!trans) {
> +				rc = -ENOMEM;
> +				goto out;
> +			}
> +		}
> +
> +		reply = xenbus_dev_request_and_reply(&u->u.msg);
> +		if (IS_ERR(reply)) {
> +			kfree(trans);
> +			rc = PTR_ERR(reply);
> +			goto out;
> +		}
> +
> +		if (msg_type == XS_TRANSACTION_START) {
> +			trans->handle.id = simple_strtoul(reply, NULL, 0);
> +			list_add(&trans->list, &u->transactions);
> +		} else if (msg_type == XS_TRANSACTION_END) {
> +			list_for_each_entry(trans, &u->transactions, list)
> +				if (trans->handle.id == u->u.msg.tx_id)
> +					break;
> +			BUG_ON(&trans->list == &u->transactions);
> +			list_del(&trans->list);
> +			kfree(trans);
> +		}
> +		mutex_lock(&u->reply_mutex);
> +		ret = queue_reply(&staging_q,
> +				  (char *)&u->u.msg, sizeof(u->u.msg));
> +		if (!ret)
> +			ret = queue_reply(&staging_q,
> +					  (char *)reply, u->u.msg.len);
> +		if (!ret) {
> +			list_splice_tail(&staging_q, &u->read_buffers);
> +			wake_up(&u->read_waitq);
> +		} else {
> +			queue_cleanup(&staging_q);
> +			rc = ret;
> +		}
> +		mutex_unlock(&u->reply_mutex);
> +		kfree(reply);
> +		break;
> +
> +	case XS_WATCH:
> +	case XS_UNWATCH: {
> +		struct watch_adapter *watch, *tmp_watch;
> +		static const char XS_RESP[] = "OK";
> +		struct xsd_sockmsg hdr;
> +
> +		path = u->u.buffer + sizeof(u->u.msg);
> +		token = memchr(path, 0, u->u.msg.len);
> +		if (token == NULL) {
> +			rc = -EILSEQ;
> +			goto out;
> +		}
> +		token++;
> +
> +		if (msg_type == XS_WATCH) {
> +			watch = kzalloc(sizeof(*watch), GFP_KERNEL);
> +			if (watch == NULL) {
> +				rc = -ENOMEM;
> +				goto out;
> +			}
> +			watch->watch.node =
> +				kmalloc(strlen(path)+1, GFP_KERNEL);
> +			if (watch->watch.node == NULL) {
> +				kfree(watch);
> +				rc = -ENOMEM;
> +				goto out;
> +			}
> +			strcpy((char *)watch->watch.node, path);
> +			watch->watch.callback = watch_fired;
> +			watch->token =
> +				kmalloc(strlen(token)+1, GFP_KERNEL);
> +			if (watch->token == NULL) {
> +				kfree(watch->watch.node);
> +				kfree(watch);
> +				rc = -ENOMEM;
> +				goto out;
> +			}
> +			strcpy(watch->token, token);
> +			watch->dev_data = u;
> +
> +			err = register_xenbus_watch(&watch->watch);
> +			if (err) {
> +				free_watch_adapter(watch);
> +				rc = err;
> +				goto out;
> +			}
> +
> +			list_add(&watch->list, &u->watches);
> +		} else {
> +			list_for_each_entry_safe(watch, tmp_watch,
> +						 &u->watches, list) {
> +				if (!strcmp(watch->token, token) &&
> +				    !strcmp(watch->watch.node, path)) {
> +					unregister_xenbus_watch(&watch->watch);
> +					list_del(&watch->list);
> +					free_watch_adapter(watch);
> +					break;
> +				}
> +			}
> +		}
> +
> +		hdr.type = msg_type;
> +		hdr.len = sizeof(XS_RESP);
> +		mutex_lock(&u->reply_mutex);
> +		ret = queue_reply(&staging_q, (char *)&hdr, sizeof(hdr));
> +		if (!ret)
> +			ret = queue_reply(&staging_q, (char *)XS_RESP, hdr.len);
> +		if (!ret) {
> +			list_splice_tail(&staging_q, &u->read_buffers);
> +			wake_up(&u->read_waitq);
> +		} else {
> +			queue_cleanup(&staging_q);
> +			rc = ret;
> +		}
> +		mutex_unlock(&u->reply_mutex);
> +		break;
> +	}
> +
> +	default:
> +		rc = -EINVAL;
> +		break;
> +	}
> +
> + out:
> +	u->len = 0;
> +	return rc;
> +}

This function implements a new kernel ABI.  How are reviewers to review
the design of this proposed ABI?

>
> ...
>
> +static unsigned int xenbus_file_poll(struct file *file, poll_table *wait)
> +{
> +	struct xenbus_file_priv *u = file->private_data;
> +
> +	poll_wait(file, &u->read_waitq, wait);
> +	if (!list_empty(&u->read_buffers))
> +		return POLLIN | POLLRDNORM;

I wonder if we needed the lock or some open-coded barrier to safely run
list_empty().

> +	return 0;
> +}
> +
>
> ...
>

