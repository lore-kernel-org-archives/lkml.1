Return-Path: <linux-kernel-owner+w=401wt.eu-S1752215AbYH2CKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215AbYH2CKt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 22:10:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750908AbYH2CKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 22:10:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:38782 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863AbYH2CKk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 22:10:40 -0400
Message-ID: <48B75A4C.60004@kernel.org>
Date: Fri, 29 Aug 2008 04:09:16 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: fuse-devel@lists.sourceforge.net, miklos@szeredi.hu, greg@kroah.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] CUSE: implement CUSE - Character device in Userspace
References: <1219947544-666-1-git-send-email-tj@kernel.org>	<1219947544-666-6-git-send-email-tj@kernel.org> <20080828130740.344f7213.akpm@linux-foundation.org>
In-Reply-To: <20080828130740.344f7213.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 29 Aug 2008 02:10:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Andrew.

Andrew Morton wrote:
>> +config CUSE
>> +	tristate "Character device in Userpace support"
>> +	depends on FUSE_FS
> 
> Will this work (usefully) if CONFIG_SYSFS=n?

Yeah, as much as other character devices are.  As long as uevent works,
most stuff should keep working.

>> +#include "fuse_i.h"
>> +
>> +#define CUSE_SUPER_MAGIC	0x43555345
> 
> Put in include/linux/magic.h?

Will do.

>> +struct cuse_conn {
>> +	struct fuse_conn	fc;
>> +	struct cdev		cdev;
>> +	struct vfsmount		*mnt;
>> +	struct device		*dev;
>> +	bool			cdev_added:1;
>> +	bool			disconnected:1;	/* channel disconnected */
> 
> I didn't know you could do that with bools.

Hmm... I thought it was like any other integral types, no?

> These two fields will share a word, and modifications of one are racy
> wrt modifications of the other.  So some form of locking is needed, and
> a comment describing that locking here would be beneficial.

Both are protected by cuse_disconnect_lock.  Will add comment.

>> +	char			*uevent_envp[UEVENT_NUM_ENVP + 1];
>> +	char			*uevent_env_buf;
>> +};
>> +
>> +#define fc_to_cc(_fc)		container_of((_fc), struct cuse_conn, fc)
>> +#define cdev_to_cc(_cdev)	container_of((_cdev), struct cuse_conn, cdev)
>> +#define cuse_conn_get(cc)	({mntget((cc)->mnt); cc;})
>> +#define cuse_conn_put(cc)	mntput((cc)->mnt)
> 
> I believe all the above could be implemented in C.
> 
> Making that change would fix the bug in cuse_conn_get(), which
> references its arg twice.

Will convert to functions.

>> ...
>>
>> +static int cuse_fill_super(struct super_block *sb, void *data, int silent)
>> +{
>> +	struct cuse_conn *cc = NULL;
> 
> this initialisation wasn't needed.

The thing is when error handling paths are lumped up using "if (xxx)
destroy(xxx);", it's a good idea to always initialize variables which
will carry allocated resource.  For this iteration, it doesn't make any
difference but later if the order of initialization changes and/or a new
sequence is added before cc initialization, it's all to easy to forget
whether cc was initialized to NULL or not.  gcc will catch it most of
the time but there's no guarantee, so I think it's better to keep it
this way.

>> +static int cuse_parse_one(char **pp, char *end, char **keyp, char **valp)
>> +{
>> +	char *p = *pp;
>> +	char *key, *val;
>> +
>> +	while (p < end && *p == '\0')
>> +		p++;
>> +	if (p == end)
>> +		return 0;
> 
> OK, I have NFI whatsoever what this thing is doing and I am disinclined
> to reverse-engineer it.
> 
> If this is parsing something whcih operators/users provided then it
> should have been documented somewhere?
> 
> Whether it is or isn't doing that, this function really really really
> needs a comment telling readers (ie: me) what it does.  Or what it
> tries to do, anyway.

Yeah, reading an undocumented parsing function is really painful.  Sorry
about lack of comments there.  With too many components to update at
hands, I kinda ran out of steam in the last stages where I do the final
review pass through patches and add comments.

The input is packed strings - "key0=val0\0key1=val1\0" - and parse one
pulls one key/val pair out of it.

>> +static int cuse_init_worker(void *data)
> 
> This functions seems to be woefully misnamed.  The name implies that it
> initialises a worker.  But it's a kernel thread?

CUSE initialization worker, it is, meaning that it's a kernel thread
worker for session initialization.

> Could you please document your design somehow?  What does this kernel
> thread do?  Why does it exist?  etc.

Yeap, will do.

>> +	/* hotplug info is also used during device release, copy and parse */
> 
> hotplug?  What's all this?  Seems to have something to do with an
> as-yet-undescribed relationship with udev?

These will be feeded to uevent verbatim.  The only reason why it's
called hotplug_info instead of uevent_envp is because FUSE works on
other platforms and I didn't want to put too much Linuxism into naming.

> So...  basically this undocumented kernel thread will for undocumented
> reasons create the device node?
> 
> An obvious question which the reader of the code will ask is "why
> wasn't that done synchronously"?

It's briefly mentioned in comment below.  It's because the
initialization needs to talk with userland and the talk should happen
over a file which the following cuse_channel_open() creates.  So,
cuse_channel_open() can't really talk with the client without completing
open while creating the device needs more information from user.

>> +static int cuse_channel_open(struct inode *inode, struct file *file)
>> +{
>> +	struct cuse_conn *cc;
>> +	struct vfsmount *mnt;
>> +	struct fuse_req *init_req;
>> +	struct task_struct *worker;
>> +	int rc;
>> +
>> +	/* Set up cuse_conn.  cuse_conn will be created when filling
>> +	 * in superblock for the following kern_mount().
>> +	 */
>> +	mnt = kern_mount(&cuse_fs);
>> +	if (IS_ERR(mnt))
>> +		return PTR_ERR(mnt);
>> +
>> +	cc = fc_to_cc(get_fuse_conn_super(mnt->mnt_sb));
>> +	cc->mnt = mnt;
>> +
>> +	/* let's send fuse init request */
>> +	rc = -ENOMEM;
>> +	init_req = fuse_request_alloc();
>> +	if (!init_req)
>> +		goto err_cc_put;
>> +
>> +	cc->fc.connected = 1;
>> +	file->private_data = fuse_conn_get(&cc->fc);
>> +	fuse_send_init(&cc->fc, init_req);
>> +
>> +	/* Okay, FUSE part of initialization is complete.  The rest of
>> +	 * the initialization is a bit more involved and requires
>> +	 * conversing with userland.  Start a kthread.
>> +	 */
>> +	worker = kthread_run(cuse_init_worker, cuse_conn_get(cc),
>> +			     "cuse-init-pid%d", current->pid);
> 
> current->pid is non-unique in a containerised setup.  What are the
> implications of this?  It needs a comment, because the containerisation
> guys will end up coming here and scratching their heads over the same
> question.

Not much.  It's just the name of the worker.  The name differentiation
is mainly to help debugging a bit when something went wrong and doesn't
have to be unique.

>> +static struct file_operations cuse_channel_fops; /* initialized during init */
> 
> This reader is wondering what a "channel" is.  Understanding high-level
> concepts like this is important for understanding the implemetnation.

Yes, and from the comment at the top of the file.

 * channel	: file handle connected to the userland CUSE client
...
 * Note that 'channel' is what 'dev' is in FUSE.  As CUSE deals with
 * devices, it's called 'channel' to reduce confusion.
 *
 * channel determines when the character device dies.  When channel is
 * closed, everything should begin to destruct.  As cuse_conn and mnt
...

>> +ssize_t cuse_class_waiting_show(struct device *dev,
>> +				struct device_attribute *attr, char *buf)
>> +{
>> +	struct cuse_conn *cc = dev_get_drvdata(dev);
>> +
>> +	return sprintf(buf, "%d\n", atomic_read(&cc->fc.num_waiting));
>> +}
> 
> <looks in fuse_i.h>
> 
> "The number of requests waiting for completion".
> 
> Why did you choose to present this particular field?

"waiting" and "abort" are what fuse exports as controls in fuse control
fs (fs/fuse/control.c).  These are CUSE's counterparts.

>> +static int __init cuse_init(void)
>> +{
>> +	int rc;
>> +
>> +	/* inherit and extend fuse_dev_operations */
>> +	cuse_channel_fops		= fuse_dev_operations;
>> +	cuse_channel_fops.owner		= THIS_MODULE;
>> +	cuse_channel_fops.open		= cuse_channel_open;
>> +	cuse_channel_fops.release	= cuse_channel_release;
> 
> Can't these initialisations be performed at compile-time?

Only by listing every member.  I can't think of a good way to inherit
all and then override some in C initialization.  Hmmm.... then again,
maybe it's better to list every member.

Is it something you object strongly?

>> +#define CUSE_KERNEL_VERSION		0
>> +#define CUSE_KERNEL_MINOR_VERSION	1
> 
> Some description of the kernel<->userspace versioning design would be
> appropriate.  Is it bi-directional?

It's just like FUSE protocol version.   FUSE clients seem to distinguish
supported functionality with it.  So, it's more "I'm who" kind of thing
which doesn't have much meaning for the initial version.

> Nice-looking code, but I do not feel able to properly review it with
> its current level of description.

Sorry about that.  I'll add proper comments on the next round.

Thanks.

-- 
tejun
