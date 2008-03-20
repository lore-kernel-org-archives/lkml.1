Return-Path: <linux-kernel-owner+w=401wt.eu-S1757441AbYCTUGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441AbYCTUGA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 16:06:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755826AbYCTUFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 16:05:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52900 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755569AbYCTUFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 16:05:36 -0400
Date: Thu, 20 Mar 2008 13:03:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rodolfo Giometti <giometti@linux.it>
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org, davej@redhat.com,
       sam@ravnborg.org, greg@kroah.com, randy.dunlap@oracle.com,
       giometti@linux.it
Subject: Re: [PATCH 1/7] LinuxPPS core support.
Message-Id: <20080320130356.69ab65fe.akpm@linux-foundation.org>
In-Reply-To: <12048053473401-git-send-email-giometti@linux.it>
References: <12048053463198-git-send-email-giometti@linux.it>
	<12048053473401-git-send-email-giometti@linux.it>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  6 Mar 2008 13:09:00 +0100
Rodolfo Giometti <giometti@linux.it> wrote:

> +pps_core-y			:= pps.o kapi.o sysfs.o

Does it compile OK with CONFIG_SYSFS=n?

> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/sched.h>
> +#include <linux/time.h>
> +#include <linux/spinlock.h>
> +#include <linux/idr.h>
> +#include <linux/fs.h>
> +#include <linux/pps.h>
> +
> +/*
> + * Global variables
> + */
> +
> +DEFINE_SPINLOCK(idr_lock);

This name is insufficiently specific.  Not only does it risk linkage
errors, it makes it ahrd for poeple to work out where the symbol came from.

I renamed it to pps_idr_lock.

> +DEFINE_IDR(pps_idr);
>
> ...
>
> +void pps_unregister_source(int source)
> +{
> +	struct pps_device *pps;
> +
> +	spin_lock_irq(&idr_lock);
> +	pps = idr_find(&pps_idr, source);
> +
> +	if (!pps) {
> +		spin_unlock_irq(&idr_lock);
> +		return;
> +	}
> +
> +	/* This should be done first in order to deny IRQ handlers
> +	 * to access PPS structs
> +	 */
> +
> +	idr_remove(&pps_idr, pps->id);
> +	spin_unlock_irq(&idr_lock);
> +
> +	wait_event(pps->usage_queue, atomic_read(&pps->usage) == 0);
> +
> +	pps_sysfs_remove_source_entry(pps);
> +	pps_unregister_cdev(pps);
> +	kfree(pps);
> +}
> +EXPORT_SYMBOL(pps_unregister_source);

The wait_event() stuff really shouldn't be here: it should be integral to
the refcounting:

void pps_dev_put(struct pps_device *pps)
{
	spin_lock_irq(&pps_lock);
	if (atomic_dec_and_test(&pps->usage))
		idr_remove(&pps_idr, pps->id);
	else
		pps = NULL;
	spin_unlock_irq(&pps_lock);
	if (pps) {
		/*
		 * Might need to do the below via schedule_work() if
		 * pps_dev_put() is to be callable from atomic context
		 */
		pps_sysfs_remove_source_entry(pps);
		pps_unregister_cdev(pps);
		kfree(pps);
	}
}

As it stands, there might be deadlocks such as when a process which itself
holds a ref on the pps_device (with an open fd?) calls
pps_unregister_source.

Also, we need to take care that all processes which were waiting in
pps_unregister_source() get to finish their cleanup before we permit rmmod
to proceed.  Is that handled somewhere?

> +void pps_event(int source, int event, void *data)

Please document the API in the kernel source.  I realise there's a teeny
bit of documentation in pps.txt, but people don't think to look there and
it tends to go out of date.

It doesn't have to be fancy formal kerneldoc - it's better to add *good*
comments which tell people what they need to know.  For some reason people
seem to add useless obvious stuff when they do their comments in kerneldoc
form.

> +{
> +	struct pps_device *pps;
> +	struct timespec __ts;
> +	struct pps_ktime ts;
> +	unsigned long flags;
> +
> +	/* First of all we get the time stamp... */
> +	getnstimeofday(&__ts);
> +
> +	/* ... and translate it to PPS time data struct */
> +	ts.sec = __ts.tv_sec;
> +	ts.nsec = __ts.tv_nsec;
> +
> +	if ((event & (PPS_CAPTUREASSERT | PPS_CAPTURECLEAR)) == 0) {
> +		printk(KERN_ERR "pps: unknown event (%x) for source %d\n",
> +			event, source);
> +		return;
> +	}
> +
> +	spin_lock_irqsave(&idr_lock, flags);
> +	pps = idr_find(&pps_idr, source);
> +
> +	/* If we find a valid PPS source we lock it before leaving
> +	 * the lock!
> +	 */
> +	if (pps)
> +		atomic_inc(&pps->usage);
> +	spin_unlock_irqrestore(&idr_lock, flags);

The above pattern is repeated rather a lot and could perhaps be extracted
into a nice pps_dev_get() helper.

> +	if (!pps)
> +		return;
> +
> +	pr_debug("PPS event on source %d at %llu.%06u\n",
> +			pps->id, ts.sec, ts.nsec);
> +
> +	spin_lock_irqsave(&pps->lock, flags);
> +
> +	/* Must call the echo function? */
> +	if ((pps->params.mode & (PPS_ECHOASSERT | PPS_ECHOCLEAR)))
> +		pps->info.echo(source, event, data);
> +
> +	/* Check the event */
> +	pps->current_mode = pps->params.mode;
> +	if (event & PPS_CAPTUREASSERT) {
> +		/* We have to add an offset? */
> +		if (pps->params.mode & PPS_OFFSETASSERT)
> +			pps_add_offset(&ts, &pps->params.assert_off_tu);
> +
> +		/* Save the time stamp */
> +		pps->assert_tu = ts;
> +		pps->assert_sequence++;
> +		pr_debug("capture assert seq #%u for source %d\n",
> +			pps->assert_sequence, source);
> +	}
> +	if (event & PPS_CAPTURECLEAR) {
> +		/* We have to add an offset? */
> +		if (pps->params.mode & PPS_OFFSETCLEAR)
> +			pps_add_offset(&ts, &pps->params.clear_off_tu);
> +
> +		/* Save the time stamp */
> +		pps->clear_tu = ts;
> +		pps->clear_sequence++;
> +		pr_debug("capture clear seq #%u for source %d\n",
> +			pps->clear_sequence, source);
> +	}
> +
> +	pps->go = ~0;
> +	wake_up_interruptible(&pps->queue);
> +
> +	kill_fasync(&pps->async_queue, SIGIO, POLL_IN);
> +
> +	spin_unlock_irqrestore(&pps->lock, flags);
> +
> +	/* Now we can release the PPS source for (possible) deregistration */
> +	spin_lock_irqsave(&idr_lock, flags);
> +	atomic_dec(&pps->usage);
> +	wake_up_all(&pps->usage_queue);
> +	spin_unlock_irqrestore(&idr_lock, flags);
> +}
> +EXPORT_SYMBOL(pps_event);
>
> ...
>
> +static int pps_cdev_open(struct inode *inode, struct file *file)
> +{
> +	struct pps_device *pps = container_of(inode->i_cdev,
> +						struct pps_device, cdev);
> +	int found;
> +
> +	spin_lock_irq(&idr_lock);
> +	found = idr_find(&pps_idr, pps->id) != NULL;
> +
> +	/* Lock the PPS source against (possible) deregistration */
> +	if (found)
> +		atomic_inc(&pps->usage);
> +
> +	spin_unlock_irq(&idr_lock);

That looks a bit odd.  How can the pps_device not be registered in the IDR
tree at this stage?


> +	if (!found)
> +		return -ENODEV;
> +
> +	file->private_data = pps;
> +
> +	return 0;
> +}
>
> ...
>
> +/* Kernel consumers */
> +#define PPS_KC_HARDPPS		0	/* hardpps() (or equivalent) */
> +#define PPS_KC_HARDPPS_PLL	1	/* hardpps() constrained to
> +					   use a phase-locked loop */
> +#define PPS_KC_HARDPPS_FLL	2	/* hardpps() constrained to
> +					   use a frequency-locked loop */
> +/*
> + * Here begins the implementation-specific part!
> + */
> +
> +struct pps_fdata {
> +	struct pps_kinfo info;
> +	struct pps_ktime timeout;
> +};
> +
> +#include <linux/ioctl.h>
> +
> +#define PPS_CHECK		_IO('P', 0)
> +#define PPS_GETPARAMS		_IOR('P', 1, struct pps_kparams *)
> +#define PPS_SETPARAMS		_IOW('P', 2, struct pps_kparams *)
> +#define PPS_GETCAP		_IOR('P', 3, int *)
> +#define PPS_FETCH		_IOWR('P', 4, struct pps_fdata *)
> +
> +#ifdef __KERNEL__
> +
> +#include <linux/cdev.h>
> +#include <linux/device.h>
> +
> +#define PPS_VERSION		"5.0.0"
> +#define PPS_MAX_SOURCES		16		/* should be enough... */

It's nice to avoid sprinkling #includes throughout the file, please. 
People expect to be able to see what's being included in the first
screenful of the file.

> +/*
> + * Global defines
> + */
> +
> +/* The specific PPS source info */
> +struct pps_source_info {
> +	char name[PPS_MAX_NAME_LEN];		/* simbolic name */
> +	char path[PPS_MAX_NAME_LEN];		/* path of connected device */
> +	int mode;				/* PPS's allowed mode */
> +
> +	void (*echo)(int source, int event, void *data); /* PPS echo function */
> +
> +	struct module *owner;
> +	struct device *dev;
> +};
> +

