Return-Path: <linux-kernel-owner+w=401wt.eu-S933746AbXJPSyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933746AbXJPSyj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 14:54:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934003AbXJPSyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 14:54:19 -0400
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:43338 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765956AbXJPSyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 14:54:16 -0400
X-IronPort-AV: E=Sophos;i="4.21,284,1188802800"; 
   d="scan'208";a="536055865"
To: linux-kernel@vger.kernel.org
Subject: file operations: release can race with read/write?
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 16 Oct 2007 11:53:50 -0700
Message-ID: <adave96ki0x.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 16 Oct 2007 18:53:51.0450 (UTC) FILETIME=[E48F73A0:01C81025]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have a question about the synchronization of file_operations: is it
intended that the .release method can be called while a .read or
.write method is still running?

The reason I ask is that I've seen a crash in practice that appears to
be caused by this race, and I'm wondering whether the correct fix is
to add synchronization to the driver's .release method (this is a
character device), or whether the core kernel is supposed to provide
this synchronization.

I've written a quick test case that seems to show this happen in
practice, and from the code in fs/open.c and fs/read_write.c it looks
possible as well: sys_read() and sys_write() just do fget_light(),
which will not increment the file's reference count on the fast path,
so a racing sys_close() from another thread could do the final fput()
that ends up calling the file's .release method before the read or
write has finished.

I think the actual file data structure is OK, because it is freed with
RCU, so it won't be freed too soon.  But a .release method may free
other driver-internal state that is still in use because of this.

It seems that we wouldn't want to give up the fget_light()
optimization in read/write, so probably the right place to handle this
is in the driver.  But on the other hand, this is kind of a subtle
booby trap that has been laid.  So I would appreciate guidance from
smarter people.

Thanks,
  Roland


BTW, here's the test case -- it seems pretty conclusive to me, but
maybe I'm all wet and misunderstanding things.  There's a kernel
module that just prints "Write raced with close?" if it sees the race,
and a userspace driver that just spawns two threads, one that does
open/close in a loop and one that does write in a loop.  Running this
on my machine, I see several race messages get printed.

--- kernel module ---

#include <linux/module.h>
#include <linux/init.h>
#include <linux/errno.h>
#include <linux/miscdevice.h>
#include <linux/fs.h>
#include <linux/delay.h>

MODULE_LICENSE("GPL");

static unsigned long flag;

static int cw_open(struct inode *inode, struct file *filp)
{
	return 0;
}

static int cw_close(struct inode *inode, struct file *filp)
{
	clear_bit(1, &flag);

	msleep(1);

	if (test_and_set_bit(1, &flag))
		printk(KERN_ERR "Write raced with close?\n");

	return 0;
}

static ssize_t cw_write(struct file *filp, const char __user *buf,
			size_t len, loff_t *pos)
{
	set_bit(1, &flag);

	return 0;
}

static const struct file_operations cw_fops = {
	.owner	 = THIS_MODULE,
	.open	 = cw_open,
	.release = cw_close,
	.write	 = cw_write,
};

static struct miscdevice cw_misc = {
	.minor	= MISC_DYNAMIC_MINOR,
	.name	= "cw",
	.fops	= &cw_fops,
};

static int __init cw_init(void)
{
	return misc_register(&cw_misc);
}

static void __exit cw_cleanup(void)
{
	misc_deregister(&cw_misc);
}

module_init(cw_init);
module_exit(cw_cleanup);

--- userspace code ---

#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <pthread.h>

static int dfd = -1;

static void *write_loop(void *p)
{
	char buf[1];

	while (1)
		write(dfd, buf, 1);

	return NULL;
}

int main(int argc, char *argv[])
{
	pthread_t thr;

	if (pthread_create(&thr, NULL, write_loop, NULL))
		return 1;

	while (1) {
		dfd = open("/dev/cw", O_RDWR);
		close(dfd);
	}

	return 0;
}
