Return-Path: <linux-kernel-owner+w=401wt.eu-S1756654AbYAVTDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654AbYAVTDQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 14:03:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752389AbYAVTDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 14:03:00 -0500
Received: from smtp-out.google.com ([216.239.33.17]:36084 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbYAVTC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 14:02:59 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=fGWW81vcZudjL2dGvvF4AUanFotcgtZPXMJbgwRJnFpwx4R1l+1bZW/ITQHoKVsKY
	K83SN0r+r+hSGSmDp9XGw==
Message-ID: <2846be6b0801221102y2ad297e2u2f9df06e33b72162@mail.gmail.com>
Date: Tue, 22 Jan 2008 11:02:44 -0800
From: "Naveen Gupta" <ngupta@google.com>
To: righiandr@users.sourceforge.net
Subject: Re: [PATCH] cgroup: limit block I/O bandwidth
Cc: "Jens Axboe" <jens.axboe@oracle.com>, "Paul Menage" <menage@google.com>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Pavel Emelyanov" <xemul@openvz.org>
In-Reply-To: <4793E047.1000602@users.sourceforge.net>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/01/2008, Andrea Righi <righiandr@users.sourceforge.net> wrote:
> Jens Axboe wrote:
> > On Sun, Jan 20 2008, Andrea Righi wrote:
> >> Jens Axboe wrote:
> >>> Your approach is totally flawed, imho. For instance, you don't want a
> >>> process to be able to dirty memory at foo mb/sec but only actually
> >>> write them out at bar mb/sec.
> >> Right. Actually my problem here is that the processes that write out
> >> blocks are different respect to the processes that write bytes in
> >> memory, and I would be able to add limits on those processes that are
> >> dirtying memory.
> >
> > That's another reason why you cannot do this on a per-process or group
> > basis, because you have no way of mapping back from the io queue path
> > which process originally dirtied this memory.
> >
> >>> The noop-iosched changes are also very buggy. The queue back pointer
> >>> breaks reference counting and the task pointer storage assumes the task
> >>> will also always be around. That's of course not the case.
> >> Yes, this really need a lot of fixes. I simply posted the patch to know
> >> if such approach (in general) could have sense or not.
> >
> > It doesn't need fixes, it needs to be redesigned :-). No amount of
> > fixing will make the patch you posted correct, since the approach is
> > simply not feasible.
> >
> >>> IOW, you are doing this at the wrong level.
> >>>
> >>> What problem are you trying to solve?
> >> Limiting block I/O bandwidth for tasks that belong to a generic cgroup,
> >> in order to provide a sort of a QoS on block I/O.
> >>
> >> Anyway, I'm quite new in the wonderful land of the I/O scheduling, so
> >> any help is appreciated.
> >
> > For starters, you want to throttle when queuing IO, not dispatching it.
> > If you need to modify IO schedulers, then you are already at the wrong
> > level. That doesn't solve the write problem, but reads can be done.
> >
> > If you want to solve for both read/write(2), then move the code to that
> > level. That wont work for eg mmap, though...
> >
> > And as Balbir notes, the openvz group have been looking at some of these
> > problems as well. As has lots of other people btw, you probably want to
> > search around a bit and acquaint yourself with some of that work.
> >
>
> OK, now I understand, the main problem is that pages can be written to
> the block device when information about the real process that touched
> those pages in memory isn't available anymore. So, the I/O scheduler is
> not the right place to do such limitations. Another approach would be to
> just limit the I/O requests/sec for read operations and the dirty
> memory/sec for write operations (see below). But this is ugly and not
> efficient at all, since it just limits the writes in memory and not in
> the actual block devices.
>
> AFAIK openvz supports the per-VE I/O priority (via CFQ), that is great, but
> this isn't the same as bandwidth limiting. Anyway I'll look closely at the
> openvz work to see how they addressed the problem.

See if using priority levels to have per level bandwidth limit can
solve the priority inversion problem you were seeing earlier. I have a
priority scheduling patch for anticipatory scheduler, if you want to
try it. It's much simpler than CFQ priority.  I still need to port it
to 2.6.24 though and send across for review.

Though as already said, this would be for read side only.

-Naveen

>
> Thanks,
> -Andrea
>
> Signed-off-by: Andrea Righi <a.righi@cineca.it>
> ---
>
> diff -urpN linux-2.6.24-rc8/block/io-throttle.c linux-2.6.24-rc8-cgroup-io-throttling/block/io-throttle.c
> --- linux-2.6.24-rc8/block/io-throttle.c        1970-01-01 01:00:00.000000000 +0100
> +++ linux-2.6.24-rc8-cgroup-io-throttling/block/io-throttle.c   2008-01-21 00:40:25.000000000 +0100
> @@ -0,0 +1,221 @@
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
> +       }
> +
> +       iot->req = 0;
> +       iot->last_request = jiffies;
> +}
> +EXPORT_SYMBOL(io_throttle);
> diff -urpN linux-2.6.24-rc8/block/ll_rw_blk.c linux-2.6.24-rc8-cgroup-io-throttling/block/ll_rw_blk.c
> --- linux-2.6.24-rc8/block/ll_rw_blk.c  2008-01-16 05:22:48.000000000 +0100
> +++ linux-2.6.24-rc8-cgroup-io-throttling/block/ll_rw_blk.c     2008-01-21 00:40:09.000000000 +0100
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
> +++ linux-2.6.24-rc8-cgroup-io-throttling/block/Makefile        2008-01-21 00:40:09.000000000 +0100
> @@ -12,3 +12,5 @@ obj-$(CONFIG_IOSCHED_CFQ)     += cfq-iosched
>
>  obj-$(CONFIG_BLK_DEV_IO_TRACE) += blktrace.o
>  obj-$(CONFIG_BLOCK_COMPAT)     += compat_ioctl.o
> +
> +obj-$(CONFIG_CGROUP_IO_THROTTLE)       += io-throttle.o
> diff -urpN linux-2.6.24-rc8/fs/buffer.c linux-2.6.24-rc8-cgroup-io-throttling/fs/buffer.c
> --- linux-2.6.24-rc8/fs/buffer.c        2008-01-16 05:22:48.000000000 +0100
> +++ linux-2.6.24-rc8-cgroup-io-throttling/fs/buffer.c   2008-01-21 00:40:09.000000000 +0100
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
> +++ linux-2.6.24-rc8-cgroup-io-throttling/fs/direct-io.c        2008-01-21 00:40:09.000000000 +0100
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
> +++ linux-2.6.24-rc8-cgroup-io-throttling/include/linux/cgroup_subsys.h 2008-01-21 00:40:09.000000000 +0100
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
> +++ linux-2.6.24-rc8-cgroup-io-throttling/include/linux/io-throttle.h   2008-01-21 00:40:09.000000000 +0100
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
> +++ linux-2.6.24-rc8-cgroup-io-throttling/init/Kconfig  2008-01-21 00:40:09.000000000 +0100
> @@ -313,6 +313,16 @@ config CGROUP_NS
>            for instance virtual servers and checkpoint/restart
>            jobs.
>
> +config CGROUP_IO_THROTTLE
> +        bool "Enable cgroup I/O throttling (EXPERIMENTAL)"
> +        depends on EXPERIMENTAL && CGROUPS
> +       select TASK_IO_ACCOUNTING
> +        help
> +         This allows to limit the maximum I/O bandwidth for specific
> +         cgroup(s).
> +
> +          Say N if unsure.
> +
>  config CPUSETS
>         bool "Cpuset support"
>         depends on SMP && CGROUPS
> diff -urpN linux-2.6.24-rc8/mm/page-writeback.c linux-2.6.24-rc8-cgroup-io-throttling/mm/page-writeback.c
> --- linux-2.6.24-rc8/mm/page-writeback.c        2008-01-16 05:22:48.000000000 +0100
> +++ linux-2.6.24-rc8-cgroup-io-throttling/mm/page-writeback.c   2008-01-21 00:40:09.000000000 +0100
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
> +++ linux-2.6.24-rc8-cgroup-io-throttling/mm/readahead.c        2008-01-21 00:40:09.000000000 +0100
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
