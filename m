Return-Path: <linux-kernel-owner+w=401wt.eu-S1754169AbYAWBSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169AbYAWBSS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 20:18:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751761AbYAWBSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 20:18:05 -0500
Received: from smtp-out.google.com ([216.239.33.17]:2789 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbYAWBSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 20:18:01 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=gvNtYivwrNZm7YsQOvIsiEW7i7V/IaT6lCRAFDZw7XuXjEz8NwAlI9hJ0k7d6LlkN
	vxoMqJXmoCM9yYCw0WcUQ==
Message-ID: <2846be6b0801221717j41984f93v920d271b948d39be@mail.gmail.com>
Date: Tue, 22 Jan 2008 17:17:48 -0800
From: "Naveen Gupta" <ngupta@google.com>
To: righiandr@users.sourceforge.net
Subject: Re: [PATCH] cgroup: limit block I/O bandwidth
Cc: "Jens Axboe" <jens.axboe@oracle.com>, "Paul Menage" <menage@google.com>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Pavel Emelyanov" <xemul@openvz.org>
In-Reply-To: <47967805.4060307@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2846be6b0801181439o55dcff09ted2b8f817e7ba682@mail.gmail.com>
	 <4791DC2C.9090405@users.sourceforge.net>
	 <4793507B.6040706@users.sourceforge.net>
	 <20080120143239.GS6258@kernel.dk>
	 <47936BC1.9060805@users.sourceforge.net>
	 <20080120160651.GU6258@kernel.dk>
	 <4793E047.1000602@users.sourceforge.net>
	 <2846be6b0801221102y2ad297e2u2f9df06e33b72162@mail.gmail.com>
	 <47967805.4060307@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/01/2008, Andrea Righi <righiandr@users.sourceforge.net> wrote:
> Naveen Gupta wrote:
> > See if using priority levels to have per level bandwidth limit can
> > solve the priority inversion problem you were seeing earlier. I have a
> > priority scheduling patch for anticipatory scheduler, if you want to
> > try it. It's much simpler than CFQ priority.  I still need to port it
> > to 2.6.24 though and send across for review.
> >
> > Though as already said, this would be for read side only.
> >
> > -Naveen
>
> Thanks Naveen, I can test you scheduler if you want, but the priority
> inversion problem (or better we should call it a "bandwidth limiting"
> that impacts in wrong tasks) occurs only with write operations and, as
> said by Jens, the I/O scheduler is not the right place to implement this
> kind of limiting, because at this level the processes have already
> performed the operations (dirty pages in memory) that raise the requests
> to the I/O scheduler (made by different processes asynchronously).

If the i/o submission is happening in bursts, and we limit the rate
during submission, we will have to stop the current task from
submitting any further i/o and hence change it's pattern. Also, then
we are limiting the submission rate and not the rate which is going on
the wire as scheduler may reorder.

One of the ways could be - to limit the rate when the i/o is sent out
from the scheduler and if we see that the number of allocated requests
are above a threshold we disallow request allocation in the offending
task. This way an application submitting bursts under the allowed
average rate will not stop frequently. Something like leaky bucket.

Now for dirtying of memory happening in a different context than the
submission path, you could still put a limit looking at the dirty
ratio and this limit is higher than the actual b/w rate you are
looking to achieve. In process making sure you always have something
to write and still  now blow your entire memory. Or you can get really
fancy and track who dirtied the i/o and start limiting it that way.



>
> A possible way to model the write limiting is to look at the dirty page
> ratio that is, in part, the principal reason for the requests to the I/O
> scheduler. But in this way we would limit also the re-write operations
> in memory and this is too much limiting.
>
> So, the cgroup dirty page throttling could be very interesting anyway,
> but it's not the same thing as limiting the real write I/O bandwidth.
>
> For now I've rewritten my patch as following, moving away the code from
> the I/O scheduler, it seems to work in my small tests (apart all the
> things said above), but I'd like to find a different way to have a more
> sophisticated I/O throttling approach (probably looking also directly at
> the read()/write() level)... just investigating for now...
>
> BTW I've seen that also OpenVZ has not a solution for this problem, yet.
> AFAIU OpenVZ I/O activity is accounted in virtual enviromnents (VE) by
> the user beancounters (http://wiki.openvz.org/IO_accounting), but
> there's not any policy that implements the block I/O limiting, except
> that it's possible to set different per-VE I/O priorities (mapped on CFQ
> priorities). But I've not understood if this just sets this I/O priority
> to all processes in the VE, or if it does something different. I still
> need to look at the code in details.
>
> -Andrea
>
> Signed-off-by: Andrea Righi <a.righi@cineca.it>
> ---
>
> diff -urpN linux-2.6.24-rc8/block/io-throttle.c linux-2.6.24-rc8-cgroup-io-throttling/block/io-throttle.c
> --- linux-2.6.24-rc8/block/io-throttle.c        1970-01-01 01:00:00.000000000 +0100
> +++ linux-2.6.24-rc8-cgroup-io-throttling/block/io-throttle.c   2008-01-22 23:06:09.000000000 +0100
> @@ -0,0 +1,222 @@
> +/*
> + * io-throttle.c
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public
> + * License as published by the Free Software Foundation; either
> + * version 2 of the License, or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public
> + * License along with this program; if not, write to the
> + * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
> + * Boston, MA 021110-1307, USA.
> + *
> + * Copyright (C) 2008 Andrea Righi <a.righi@cineca.it>
> + */
> +
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/cgroup.h>
> +#include <linux/slab.h>
> +#include <linux/gfp.h>
> +#include <linux/err.h>
> +#include <linux/sched.h>
> +#include <linux/fs.h>
> +#include <linux/jiffies.h>
> +#include <linux/spinlock.h>
> +#include <linux/io-throttle.h>
> +
> +struct iothrottle {
> +       struct cgroup_subsys_state css;
> +       spinlock_t lock;
> +       unsigned long iorate;
> +       unsigned long req;
> +       unsigned long last_request;
> +};
> +
> +static inline struct iothrottle *cgroup_to_iothrottle(struct cgroup *cont)
> +{
> +       return container_of(cgroup_subsys_state(cont, iothrottle_subsys_id),
> +                           struct iothrottle, css);
> +}
> +
> +static inline struct iothrottle *task_to_iothrottle(struct task_struct *task)
> +{
> +       return container_of(task_subsys_state(task, iothrottle_subsys_id),
> +                           struct iothrottle, css);
> +}
> +
> +/*
> + * Rules: you can only create a cgroup if:
> + *   1. you are capable(CAP_SYS_ADMIN)
> + *   2. the target cgroup is a descendant of your own cgroup
> + *
> + * Note: called from kernel/cgroup.c with cgroup_lock() held.
> + */
> +static struct cgroup_subsys_state *iothrottle_create(
> +                       struct cgroup_subsys *ss, struct cgroup *cont)
> +{
> +       struct iothrottle *iot;
> +
> +       if (!capable(CAP_SYS_ADMIN))
> +               return ERR_PTR(-EPERM);
> +
> +       if (!cgroup_is_descendant(cont))
> +               return ERR_PTR(-EPERM);
> +
> +       iot = kzalloc(sizeof(struct iothrottle), GFP_KERNEL);
> +       if (unlikely(!iot))
> +               return ERR_PTR(-ENOMEM);
> +
> +       spin_lock_init(&iot->lock);
> +       iot->last_request = jiffies;
> +
> +       return &iot->css;
> +}
> +
> +/*
> + * Note: called from kernel/cgroup.c with cgroup_lock() held.
> + */
> +static void iothrottle_destroy(struct cgroup_subsys *ss, struct cgroup *cont)
> +{
> +       kfree(cgroup_to_iothrottle(cont));
> +}
> +
> +static ssize_t iothrottle_read(struct cgroup *cont, struct cftype *cft,
> +                              struct file *file, char __user *buf,
> +                              size_t nbytes, loff_t *ppos)
> +{
> +       ssize_t count, ret;
> +       unsigned long delta, iorate, req, last_request;
> +       struct iothrottle *iot;
> +       char *page;
> +
> +       page = (char *)__get_free_page(GFP_TEMPORARY);
> +       if (!page)
> +               return -ENOMEM;
> +
> +       cgroup_lock();
> +       if (cgroup_is_removed(cont)) {
> +               cgroup_unlock();
> +               ret = -ENODEV;
> +               goto out;
> +       }
> +
> +       iot = cgroup_to_iothrottle(cont);
> +       spin_lock_irq(&iot->lock);
> +
> +       delta = (long)jiffies - (long)iot->last_request;
> +       iorate = iot->iorate;
> +       req = iot->req;
> +       last_request = iot->last_request;
> +
> +       spin_unlock_irq(&iot->lock);
> +       cgroup_unlock();
> +
> +       /* print additional debugging stuff */
> +       count = sprintf(page, "bandwidth-max: %lu KiB/sec\n"
> +                             "    requested: %lu bytes\n"
> +                             " last request: %lu jiffies\n"
> +                             "        delta: %lu jiffies\n",
> +                             iorate, req, last_request, delta);
> +
> +       ret = simple_read_from_buffer(buf, nbytes, ppos, page, count);
> +
> +out:
> +       free_page((unsigned long)page);
> +       return ret;
> +}
> +
> +static int iothrottle_write_uint(struct cgroup *cont, struct cftype *cft,
> +                                u64 val)
> +{
> +       struct iothrottle *iot;
> +       int ret = 0;
> +
> +       cgroup_lock();
> +       if (cgroup_is_removed(cont)) {
> +               ret = -ENODEV;
> +               goto out;
> +       }
> +
> +       iot = cgroup_to_iothrottle(cont);
> +
> +       spin_lock_irq(&iot->lock);
> +       iot->iorate = (unsigned long)val;
> +       iot->req = 0;
> +       iot->last_request = jiffies;
> +       spin_unlock_irq(&iot->lock);
> +
> +out:
> +       cgroup_unlock();
> +       return ret;
> +}
> +
> +static struct cftype files[] = {
> +       {
> +               .name = "bandwidth",
> +               .read = iothrottle_read,
> +               .write_uint = iothrottle_write_uint,
> +       },
> +};
> +
> +static int iothrottle_populate(struct cgroup_subsys *ss, struct cgroup *cont)
> +{
> +       return cgroup_add_files(cont, ss, files, ARRAY_SIZE(files));
> +}
> +
> +struct cgroup_subsys iothrottle_subsys = {
> +       .name = "blockio",
> +       .create = iothrottle_create,
> +       .destroy = iothrottle_destroy,
> +       .populate = iothrottle_populate,
> +       .subsys_id = iothrottle_subsys_id,
> +};
> +
> +void cgroup_io_account(size_t bytes)
> +{
> +       struct iothrottle *iot;
> +
> +       iot = task_to_iothrottle(current);
> +       if (!iot || !iot->iorate)
> +               return;
> +
> +       iot->req += bytes;
> +}
> +EXPORT_SYMBOL(cgroup_io_account);
> +
> +void io_throttle(void)
> +{
> +       struct iothrottle *iot;
> +       unsigned long delta, t;
> +       long sleep;
> +
> +       iot = task_to_iothrottle(current);
> +       if (!iot || !iot->iorate)
> +               return;
> +
> +       delta = (long)jiffies - (long)iot->last_request;
> +       if (!delta)
> +               return;
> +
> +       t = msecs_to_jiffies(iot->req / iot->iorate);
> +       if (!t)
> +               return;
> +
> +       sleep = t - delta;
> +       if (sleep > 0) {
> +               pr_debug("io-throttle: task %p (%s) must sleep %lu jiffies\n",
> +                        current, current->comm, sleep);
> +               schedule_timeout_uninterruptible(sleep);
> +               return;
> +       }
> +
> +       iot->req = 0;
> +       iot->last_request = jiffies;
> +}
> +EXPORT_SYMBOL(io_throttle);
> diff -urpN linux-2.6.24-rc8/block/ll_rw_blk.c linux-2.6.24-rc8-cgroup-io-throttling/block/ll_rw_blk.c
> --- linux-2.6.24-rc8/block/ll_rw_blk.c  2008-01-16 05:22:48.000000000 +0100
> +++ linux-2.6.24-rc8-cgroup-io-throttling/block/ll_rw_blk.c     2008-01-22 23:04:34.000000000 +0100
> @@ -31,6 +31,7 @@
>  #include <linux/blktrace_api.h>
>  #include <linux/fault-inject.h>
>  #include <linux/scatterlist.h>
> +#include <linux/io-throttle.h>
>
>  /*
>   * for max sense size
> @@ -3368,6 +3369,8 @@ void submit_bio(int rw, struct bio *bio)
>                         count_vm_events(PGPGOUT, count);
>                 } else {
>                         task_io_account_read(bio->bi_size);
> +                       cgroup_io_account(bio->bi_size);
> +                       io_throttle();
>                         count_vm_events(PGPGIN, count);
>                 }
>
> diff -urpN linux-2.6.24-rc8/block/Makefile linux-2.6.24-rc8-cgroup-io-throttling/block/Makefile
> --- linux-2.6.24-rc8/block/Makefile     2008-01-16 05:22:48.000000000 +0100
> +++ linux-2.6.24-rc8-cgroup-io-throttling/block/Makefile        2008-01-22 23:04:34.000000000 +0100
> @@ -12,3 +12,5 @@ obj-$(CONFIG_IOSCHED_CFQ)     += cfq-iosched
>
>  obj-$(CONFIG_BLK_DEV_IO_TRACE) += blktrace.o
>  obj-$(CONFIG_BLOCK_COMPAT)     += compat_ioctl.o
> +
> +obj-$(CONFIG_CGROUP_IO_THROTTLE)       += io-throttle.o
> diff -urpN linux-2.6.24-rc8/fs/buffer.c linux-2.6.24-rc8-cgroup-io-throttling/fs/buffer.c
> --- linux-2.6.24-rc8/fs/buffer.c        2008-01-16 05:22:48.000000000 +0100
> +++ linux-2.6.24-rc8-cgroup-io-throttling/fs/buffer.c   2008-01-22 23:04:34.000000000 +0100
> @@ -41,6 +41,7 @@
>  #include <linux/bitops.h>
>  #include <linux/mpage.h>
>  #include <linux/bit_spinlock.h>
> +#include <linux/io-throttle.h>
>
>  static int fsync_buffers_list(spinlock_t *lock, struct list_head *list);
>
> @@ -713,12 +714,14 @@ static int __set_page_dirty(struct page
>                         __inc_bdi_stat(mapping->backing_dev_info,
>                                         BDI_RECLAIMABLE);
>                         task_io_account_write(PAGE_CACHE_SIZE);
> +                       cgroup_io_account(PAGE_CACHE_SIZE);
>                 }
>                 radix_tree_tag_set(&mapping->page_tree,
>                                 page_index(page), PAGECACHE_TAG_DIRTY);
>         }
>         write_unlock_irq(&mapping->tree_lock);
>         __mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
> +       io_throttle();
>
>         return 1;
>  }
> diff -urpN linux-2.6.24-rc8/fs/direct-io.c linux-2.6.24-rc8-cgroup-io-throttling/fs/direct-io.c
> --- linux-2.6.24-rc8/fs/direct-io.c     2008-01-16 05:22:48.000000000 +0100
> +++ linux-2.6.24-rc8-cgroup-io-throttling/fs/direct-io.c        2008-01-22 23:04:34.000000000 +0100
> @@ -35,6 +35,7 @@
>  #include <linux/buffer_head.h>
>  #include <linux/rwsem.h>
>  #include <linux/uio.h>
> +#include <linux/io-throttle.h>
>  #include <asm/atomic.h>
>
>  /*
> @@ -667,6 +668,8 @@ submit_page_section(struct dio *dio, str
>                  * Read accounting is performed in submit_bio()
>                  */
>                 task_io_account_write(len);
> +               cgroup_io_account(len);
> +               io_throttle();
>         }
>
>         /*
> diff -urpN linux-2.6.24-rc8/include/linux/cgroup_subsys.h linux-2.6.24-rc8-cgroup-io-throttling/include/linux/cgroup_subsys.h
> --- linux-2.6.24-rc8/include/linux/cgroup_subsys.h      2008-01-16 05:22:48.000000000 +0100
> +++ linux-2.6.24-rc8-cgroup-io-throttling/include/linux/cgroup_subsys.h 2008-01-22 23:04:34.000000000 +0100
> @@ -37,3 +37,9 @@ SUBSYS(cpuacct)
>
>  /* */
>
> +#ifdef CONFIG_CGROUP_IO_THROTTLE
> +SUBSYS(iothrottle)
> +#endif
> +
> +/* */
> +
> diff -urpN linux-2.6.24-rc8/include/linux/io-throttle.h linux-2.6.24-rc8-cgroup-io-throttling/include/linux/io-throttle.h
> --- linux-2.6.24-rc8/include/linux/io-throttle.h        1970-01-01 01:00:00.000000000 +0100
> +++ linux-2.6.24-rc8-cgroup-io-throttling/include/linux/io-throttle.h   2008-01-22 23:04:34.000000000 +0100
> @@ -0,0 +1,12 @@
> +#ifndef IO_THROTTLE_H
> +#define IO_THROTTLE_H
> +
> +#ifdef CONFIG_CGROUP_IO_THROTTLE
> +extern void io_throttle(void);
> +extern void cgroup_io_account(size_t bytes);
> +#else
> +static inline void io_throttle(void) { }
> +static inline void cgroup_io_account(size_t bytes) { }
> +#endif /* CONFIG_CGROUP_IO_THROTTLE */
> +
> +#endif
> diff -urpN linux-2.6.24-rc8/init/Kconfig linux-2.6.24-rc8-cgroup-io-throttling/init/Kconfig
> --- linux-2.6.24-rc8/init/Kconfig       2008-01-16 05:22:48.000000000 +0100
> +++ linux-2.6.24-rc8-cgroup-io-throttling/init/Kconfig  2008-01-22 23:16:41.000000000 +0100
> @@ -313,6 +313,18 @@ config CGROUP_NS
>            for instance virtual servers and checkpoint/restart
>            jobs.
>
> +config CGROUP_IO_THROTTLE
> +       bool "Enable cgroup I/O throttling (EXPERIMENTAL)"
> +       depends on EXPERIMENTAL && CGROUPS
> +       help
> +         This allows to limit the maximum I/O bandwidth for specific
> +         cgroup(s). Actually this works correctly for read operations only.
> +         Write operations are modeled looking at dirty page ratio (write
> +         throttling in memory), since the writes to the real block device are
> +         processed asynchronously by different tasks.
> +
> +         Say N if unsure.
> +
>  config CPUSETS
>         bool "Cpuset support"
>         depends on SMP && CGROUPS
> diff -urpN linux-2.6.24-rc8/mm/page-writeback.c linux-2.6.24-rc8-cgroup-io-throttling/mm/page-writeback.c
> --- linux-2.6.24-rc8/mm/page-writeback.c        2008-01-16 05:22:48.000000000 +0100
> +++ linux-2.6.24-rc8-cgroup-io-throttling/mm/page-writeback.c   2008-01-22 23:04:34.000000000 +0100
> @@ -34,6 +34,7 @@
>  #include <linux/syscalls.h>
>  #include <linux/buffer_head.h>
>  #include <linux/pagevec.h>
> +#include <linux/io-throttle.h>
>
>  /*
>   * The maximum number of pages to writeout in a single bdflush/kupdate
> @@ -1014,6 +1015,7 @@ int __set_page_dirty_nobuffers(struct pa
>                                 __inc_bdi_stat(mapping->backing_dev_info,
>                                                 BDI_RECLAIMABLE);
>                                 task_io_account_write(PAGE_CACHE_SIZE);
> +                               cgroup_io_account(PAGE_CACHE_SIZE);
>                         }
>                         radix_tree_tag_set(&mapping->page_tree,
>                                 page_index(page), PAGECACHE_TAG_DIRTY);
> @@ -1023,6 +1025,7 @@ int __set_page_dirty_nobuffers(struct pa
>                         /* !PageAnon && !swapper_space */
>                         __mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
>                 }
> +               io_throttle();
>                 return 1;
>         }
>         return 0;
> diff -urpN linux-2.6.24-rc8/mm/readahead.c linux-2.6.24-rc8-cgroup-io-throttling/mm/readahead.c
> --- linux-2.6.24-rc8/mm/readahead.c     2008-01-16 05:22:48.000000000 +0100
> +++ linux-2.6.24-rc8-cgroup-io-throttling/mm/readahead.c        2008-01-22 23:04:34.000000000 +0100
> @@ -16,6 +16,7 @@
>  #include <linux/task_io_accounting_ops.h>
>  #include <linux/pagevec.h>
>  #include <linux/pagemap.h>
> +#include <linux/io-throttle.h>
>
>  void default_unplug_io_fn(struct backing_dev_info *bdi, struct page *page)
>  {
> @@ -76,6 +77,8 @@ int read_cache_pages(struct address_spac
>                         break;
>                 }
>                 task_io_account_read(PAGE_CACHE_SIZE);
> +               cgroup_io_account(PAGE_CACHE_SIZE);
> +               io_throttle();
>         }
>         return ret;
>  }
>
