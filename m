Return-Path: <linux-kernel-owner+w=401wt.eu-S1753041AbZGVSQD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041AbZGVSQD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 14:16:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752892AbZGVSQC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 14:16:02 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49826 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752747AbZGVSQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 14:16:00 -0400
Date: Wed, 22 Jul 2009 11:15:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-kernel@vger.kernel.org, Jeff Squyres <jsquyres@cisco.com>
Subject: Re: [PATCH/RFC] ummunot: Userspace support for MMU notifications
Message-Id: <20090722111538.58a126e3.akpm@linux-foundation.org>
In-Reply-To: <ada3a8oobis.fsf@cisco.com>
References: <ada3a8oobis.fsf@cisco.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jul 2009 10:47:23 -0700 Roland Dreier <rdreier@cisco.com> wrote:

> As discussed in <http://article.gmane.org/gmane.linux.drivers.openib/61925>
> and follow-up messages, libraries using RDMA would like to track
> precisely when application code changes memory mapping via free(),
> munmap(), etc.

It isn't "precisely" - the tracker has a delayed view of the trackee,
of course.  Only really solvable by blocking the trackee each time it
does something.

The time-skew makes the facility considerably weaker.  Obviously this
is OK for your application but it's a fairly important design point
which it would be interesting to hear about.

>  Current pure-userspace solutions using malloc hooks
> and other tricks are not robust, and the feeling among experts is that
> the issue is unfixable without kernel help.
> 
> We solve this not by implementing the full API proposed in the email
> linked above but rather with a simpler and more generic interface,
> which may be useful in other contexts.  Specifically, we implement a
> new character device driver, ummunot, that creates a /dev/ummunot
> node.  A userspace process can open this node read-only and use the fd
> as follows:
> 
>  1. ioctl() to register/unregister an address range to watch in the
>     kernel (cf struct ummunot_register_ioctl in <linux/ummunot.h>).
> 
>  2. read() to retrieve events generated when a mapping in a watched
>     address range is invalidated (cf struct ummunot_event in
>     <linux/ummunot.h>).  select()/poll()/epoll() and SIGIO are handled
>     for this IO.
> 
>  3. mmap() one page at offset 0 to map a kernel page that contains a
>     generation counter that is incremented each time an event is
>     generated.  This allows userspace to have a fast path that checks
>     that no events have occurred without a system call.

If you stand back and squint, each of 1, 2 and 3 are things which the
kernel already provides for the delivery of ftrace events to userspace.

Did you look at reusing all that stuff?

> Thanks to Jason Gunthorpe <jgunthorpe@obsidianresearch.com> for
> suggestions on the interface design.  Also thanks to Jeff Squyres
> <jsquyres@cisco.com> for prototyping support for this in Open MPI, which
> helped find several bugs during development.
> 
> Signed-off-by: Roland Dreier <rolandd@cisco.com>
> ---
> Andrew -- sending this to you since I don't really know who should merge
> this sort of thing.

That works.

> Solving the underlying issue here is a pretty big deal to the universe
> of people that work on MPI implementations (sort of middleware for
> high-performance computing).  I think everyone would be open to better
> ideas on how to handle this, although I'm pretty happy with how small
> and self-contained the ummunot implementation ended up being.
> 
>
> ...
>
> +enum {
> +	UMMUNOT_FLAG_DIRTY	= 1,
> +	UMMUNOT_FLAG_HINT	= 2,
> +};
> +
> +struct ummunot_reg {
> +	u64			user_cookie;
> +	unsigned long		start;
> +	unsigned long		end;
> +	unsigned long		hint_start;
> +	unsigned long		hint_end;
> +	unsigned long		flags;
> +	struct rb_node		node;
> +	struct list_head	list;
> +};

Bah.

I looked at the code, asked "wtf is that rbtree being used for", went
to the defining data structure and ...  nothing.

And without knowing what the data structures do, and the relationship
between them it's hard to follow the code.  But you need to follow the
code to be able to reverse-engineer the data structures.

Ho hum.

What's the rbtree for?

What's a "hint"?

> +struct ummunot_file {
> +	struct mmu_notifier	mmu_notifier;
> +	struct mm_struct       *mm;
> +	struct rb_root		reg_tree;
> +	struct list_head	dirty_list;
> +	u64		       *counter;
> +	spinlock_t		lock;
> +	wait_queue_head_t	read_wait;
> +	struct fasync_struct   *async_queue;
> +	int			need_empty;
> +	int			used;
> +};

What's on dirty_list?

etc.

> +static struct ummunot_file *to_ummunot_file(struct mmu_notifier *mn)
> +{
> +	return container_of(mn, struct ummunot_file, mmu_notifier);
> +}
> +
> +static void ummunot_handle_not(struct mmu_notifier *mn,
> +			       unsigned long start, unsigned long end)

I really really want to do s/not/notify/g on this patch ;)

> +{
> +	struct ummunot_file *priv = to_ummunot_file(mn);
> +	struct rb_node *n;
> +	struct ummunot_reg *reg;
> +	unsigned long flags;
> +	int hit = 0;
> +
> +	spin_lock_irqsave(&priv->lock, flags);
> +
> +	for (n = rb_first(&priv->reg_tree); n; n = rb_next(n)) {
> +		reg = rb_entry(n, struct ummunot_reg, node);
> +
> +		if (reg->start >= end)
> +			break;
> +
> +		/*
> +		 * Ranges overlap if they're not disjoint; and they're
> +		 * disjoint if the end of one is before the start of
> +		 * the other one.
> +		 */
> +		if (!(reg->end <= start || end <= reg->start)) {
> +			hit = 1;
> +
> +			if (!test_and_set_bit(UMMUNOT_FLAG_DIRTY, &reg->flags))
> +				list_add_tail(&reg->list, &priv->dirty_list);
> +
> +			if (test_bit(UMMUNOT_FLAG_HINT, &reg->flags)) {
> +				clear_bit(UMMUNOT_FLAG_HINT, &reg->flags);
> +			} else {
> +				set_bit(UMMUNOT_FLAG_HINT, &reg->flags);
> +				reg->hint_start = start;
> +				reg->hint_end   = end;
> +			}
> +		}
> +	}
> +
> +	if (hit) {
> +		++(*priv->counter);
> +		flush_dcache_page(virt_to_page(priv->counter));
> +		wake_up_interruptible(&priv->read_wait);
> +		kill_fasync(&priv->async_queue, SIGIO, POLL_IN);
> +	}
> +
> +	spin_unlock_irqrestore(&priv->lock, flags);
> +}
> +
> +static void ummunot_inval_page(struct mmu_notifier *mn,

"invalidate"

> +			       struct mm_struct *mm,
> +			       unsigned long addr)
> +{
> +	ummunot_handle_not(mn, addr, addr + PAGE_SIZE);
> +}
> +
> +static void ummunot_inval_range_start(struct mmu_notifier *mn,
> +				      struct mm_struct *mm,
> +				      unsigned long start, unsigned long end)
> +{
> +	ummunot_handle_not(mn, start, end);
> +}
> +
> +static const struct mmu_notifier_ops ummunot_mmu_notifier_ops = {
> +	.invalidate_page	= ummunot_inval_page,
> +	.invalidate_range_start	= ummunot_inval_range_start,
> +};
> +
> +static int ummunot_open(struct inode *inode, struct file *filp)
> +{
> +	struct ummunot_file *priv;
> +	int ret;
> +
> +	if (filp->f_mode & FMODE_WRITE)
> +		return -EINVAL;

hm, how do you set the permissions on a miscdevice node?

> +	priv = kmalloc(sizeof *priv, GFP_KERNEL);
> +	if (!priv)
> +		return -ENOMEM;
> +
> +	priv->counter = (void *) get_zeroed_page(GFP_KERNEL);
> +	if (!priv->counter) {
> +		ret = -ENOMEM;
> +		goto err;
> +	}
> +
> +	priv->reg_tree = RB_ROOT;
> +	INIT_LIST_HEAD(&priv->dirty_list);
> +	spin_lock_init(&priv->lock);
> +	init_waitqueue_head(&priv->read_wait);
> +	priv->async_queue = NULL;
> +	priv->need_empty  = 0;
> +	priv->used	  = 0;
> +
> +	priv->mmu_notifier.ops = &ummunot_mmu_notifier_ops;
> +	/*
> +	 * Register notifier last, since notifications can occur as
> +	 * soon as we register....
> +	 */
> +	ret = mmu_notifier_register(&priv->mmu_notifier, current->mm);
> +	if (ret)
> +		goto err_page;
> +
> +	priv->mm = current->mm;
> +	atomic_inc(&priv->mm->mm_count);
> +
> +	filp->private_data = priv;
> +
> +	return 0;
> +
> +err_page:
> +	free_page((unsigned long) priv->counter);
> +
> +err:
> +	kfree(priv);
> +	return ret;
> +}
> +
>
> ...
>
> +static ssize_t ummunot_read(struct file *filp, char __user *buf,
> +			    size_t count, loff_t *pos)
> +{
> +	struct ummunot_file *priv = filp->private_data;
> +	struct ummunot_reg *reg;
> +	ssize_t ret;
> +	struct ummunot_event *events;
> +	int max;
> +	int n;
> +
> +	priv->used = 1;
> +
> +	events = (void *) get_zeroed_page(GFP_KERNEL);
> +	if (!events) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +
> +	spin_lock_irq(&priv->lock);
> +
> +	while (!ummunot_readable(priv)) {
> +		spin_unlock_irq(&priv->lock);
> +
> +		if (filp->f_flags & O_NONBLOCK) {
> +			ret = -EAGAIN;
> +			goto out;
> +		}
> +
> +		if (wait_event_interruptible(priv->read_wait,
> +					     ummunot_readable(priv))) {
> +			ret = -ERESTARTSYS;
> +			goto out;
> +		}
> +
> +		spin_lock_irq(&priv->lock);
> +	}
> +
> +	max = min(PAGE_SIZE, count) / sizeof *events;

It used to be the case that architectures disagreed over the type of
PAGE_SIZE - unsigned versus unsigned long, iirc.

If still true, this will warn.


> +	for (n = 0; n < max; ++n) {
> +		if (list_empty(&priv->dirty_list)) {
> +			events[n].type		      = UMMUNOT_EVENT_TYPE_LAST;
> +			events[n].user_cookie_counter = *priv->counter;
> +			++n;
> +			priv->need_empty = 0;
> +			break;
> +		}
> +
> +		reg = list_first_entry(&priv->dirty_list, struct ummunot_reg,
> +				       list);
> +
> +		events[n].type = UMMUNOT_EVENT_TYPE_INVAL;
> +		if (test_bit(UMMUNOT_FLAG_HINT, &reg->flags)) {
> +			events[n].flags		= UMMUNOT_EVENT_FLAG_HINT;
> +			events[n].hint_start	= max(reg->start, reg->hint_start);
> +			events[n].hint_end	= min(reg->end, reg->hint_end);
> +		} else {
> +			events[n].hint_start	= reg->start;
> +			events[n].hint_end	= reg->end;
> +		}
> +		events[n].user_cookie_counter = reg->user_cookie;
> +
> +		list_del(&reg->list);
> +		reg->flags = 0;
> +		priv->need_empty = 1;
> +	}
> +
> +	spin_unlock_irq(&priv->lock);
> +
> +	if (copy_to_user(buf, events, n * sizeof *events))
> +		ret = -EFAULT;
> +	else
> +		ret = n * sizeof *events;
> +
> +out:
> +	free_page((unsigned long) events);
> +	return ret;
> +}
> +
>
> ...
>

