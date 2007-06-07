Return-Path: <linux-kernel-owner+w=401wt.eu-S936578AbXFGVbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936578AbXFGVbU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 17:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764044AbXFGVbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 17:31:10 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56888 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761191AbXFGVbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 17:31:06 -0400
Date: Thu, 7 Jun 2007 14:30:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Doug Thompson <norsk5@yahoo.com>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg KH <greg@kroah.com>
Subject: Re: [PATCH 6/36] drivers edac new edac_device class added
Message-Id: <20070607143021.de8154d7.akpm@linux-foundation.org>
In-Reply-To: <157758.83344.qm@web50107.mail.re2.yahoo.com>
References: <157758.83344.qm@web50107.mail.re2.yahoo.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Jun 2007 07:39:58 -0700 (PDT)
Doug Thompson <norsk5@yahoo.com> wrote:

> From:	Douglas Thompson <dougthompson@xmission.com>
> 
> This patch adds the new 'class' of object to be managed, named:
> 'edac_device'.
> 
> As a peer of the 'edac_mc' class of object, it provides a non-memory
> centric
> view of an ERROR DETECTING device in hardware. It provides a sysfs
> interface
> and an abstraction for varioius EDAC type devices.
> 
> Multiple 'instances' within the class are possible, with each
> 'instance'
> able to have multiple 'blocks', and each 'block' having 'attributes'.
> 
> At the 'block' level there are the 'ce_count' and 'ue_count' fields
> which the device driver can update and/or call edac_device_handle_XX()
> functions. At each higher level are additional 'total' count fields,
> which are a summation of counts below that level.
> 
> This 'edac_device' has been used to capture and present ECC errors 
> which are found in a a L1 and L2 system on a per CORE/CPU basis.
> 
> @@ -0,0 +1,669 @@
> +
> +/*
> + * edac_device.c
> + * (C) 2007 www.douglaskthompson.com
> + *
> + * This file may be distributed under the terms of the
> + * GNU General Public License.
> + *
> + * Written by Doug Thompson <norsk5@xmission.com>
> + *
> + * edac_device API implementation
> + * 19 Jan 2007
> + */
> +
> +#include <linux/module.h>
> +#include <linux/types.h>
> +#include <linux/smp.h>
> +#include <linux/init.h>
> +#include <linux/sysctl.h>
> +#include <linux/highmem.h>
> +#include <linux/timer.h>
> +#include <linux/slab.h>
> +#include <linux/spinlock.h>
> +#include <linux/list.h>
> +#include <linux/sysdev.h>
> +#include <linux/ctype.h>
> +#include <linux/workqueue.h>
> +#include <asm/uaccess.h>
> +#include <asm/page.h>
> +
> +#include "edac_core.h"
> +#include "edac_module.h"
> +
> +/* lock to memory controller's control array */
> +static DECLARE_MUTEX(device_ctls_mutex);

Semaphores should not be used unless we're using their counting property. 
We almost never do.  Please switch this to a mutex.

> +static struct list_head edac_device_list =
> LIST_HEAD_INIT(edac_device_list);
> +
> +
> +static inline void lock_device_list(void)
> +{
> +	down(&device_ctls_mutex);
> +}
> +
> +static inline void unlock_device_list(void)
> +{
> +	up(&device_ctls_mutex);
> +}

Preferred style is to avoid wrappers like this and to simply open-code the
mutex_lock/mutex_unlock at all sites.

> +
> +#ifdef CONFIG_EDAC_DEBUG
> +static void edac_device_dump_device(struct edac_device_ctl_info
> *edac_dev)
> +{
> +	debugf3("\tedac_dev = %p dev_idx=%d \n", edac_dev,edac_dev->dev_idx);
> +	debugf4("\tedac_dev->edac_check = %p\n", edac_dev->edac_check);
> +	debugf3("\tdev = %p\n", edac_dev->dev);
> +	debugf3("\tmod_name:ctl_name = %s:%s\n",
> +		edac_dev->mod_name, edac_dev->ctl_name);
> +	debugf3("\tpvt_info = %p\n\n", edac_dev->pvt_info);
> +}
> +#endif  /* CONFIG_EDAC_DEBUG */
> +
> +/*
> + * The alloc() and free() functions for the 'edac_device' control info
> + * structure. A MC driver will allocate one of these for each
> edac_device
> + * it is going to control/register with the EDAC CORE.
> + */
> +struct edac_device_ctl_info *edac_device_alloc_ctl_info(
> +	unsigned sz_private,
> +	char *edac_device_name,
> +	unsigned nr_instances,
> +	char *edac_block_name,
> +	unsigned nr_blocks,
> +	unsigned offset_value,
> +	struct edac_attrib_spec *attrib_spec,
> +	unsigned nr_attribs)
> +{

spose so.  Many would code this as

struct edac_device_ctl_info *edac_device_alloc_ctl_info(unsigned sz_private,
	char *edac_device_name, unsigned nr_instances, char *edac_block_name,
	unsigned nr_blocks, unsigned offset_value,
	struct edac_attrib_spec *attrib_spec, unsigned nr_attribs)
{

but that's not a heck of a lot nicer.

What a lot of argumetns this function has.


> +	struct edac_device_ctl_info *dev_ctl;
> +	struct edac_device_instance *dev_inst, *inst;
> +	struct edac_device_block *dev_blk, *blk_p, *blk;
> +	struct edac_attrib *dev_attrib, *attrib_p, *attrib;
> +	unsigned total_size;
> +	unsigned count;
> +	unsigned instance, block, attr;
> +	void *pvt;
> +
> +	debugf1("%s() instances=%d blocks=%d\n",
> +		__func__,nr_instances,nr_blocks);
> +
> +	/* Figure out the offsets of the various items from the start of an
> +	 * ctl_info structure.  We want the alignment of each item
> +	 * to be at least as stringent as what the compiler would
> +	 * provide if we could simply hardcode everything into a single
> struct.
> +	 */
> +	dev_ctl = (struct edac_device_ctl_info *) 0;

Just use NULL here

> +	/* Calc the 'end' offset past the ctl_info structure */
> +	dev_inst = (struct edac_device_instance *)
> +			edac_align_ptr(&dev_ctl[1],sizeof(*dev_inst));

hrm, edac_align_pointer is weird.  I assume it's doing something which is
specific to the peculiarities of the EDAC space/implementation?

I'd suggest that edac_align_pointer() be changed to return void*, so you
can remove the tpecasts in the callers.

> +	/* Calc the 'end' offset past the instance array */
> +	dev_blk = (struct edac_device_block *)
> +			edac_align_ptr(&dev_inst[nr_instances],sizeof(*dev_blk));

here also.

> +	/* Calc the 'end' offset past the dev_blk array */
> +	count = nr_instances * nr_blocks;
> +	dev_attrib = (struct edac_attrib *)
> +			edac_align_ptr(&dev_blk[count],sizeof(*dev_attrib));

And here.

> +	/* Check for case of NO attributes specified */
> +	if (nr_attribs > 0)
> +		count *= nr_attribs;
> +
> +	/* Calc the 'end' offset past the attributes array */
> +	pvt = edac_align_ptr(&dev_attrib[count],sz_private);
> +	total_size = ((unsigned long) pvt) + sz_private;
> +
> +	/* Allocate the amount of memory for the set of control structures */
> +	if ((dev_ctl = kmalloc(total_size, GFP_KERNEL)) == NULL)
> +		return NULL;

Preferred kernel style is

	dev_ctl = kmalloc(total_size, GFP_KERNEL);
	if (dev_ctl == NULL)
		return NULL;

> +	/* Adjust pointers so they point within the memory we just allocated
> +	 * rather than an imaginary chunk of memory located at address 0.
> +	 */
> +	dev_inst = (struct edac_device_instance *)
> +			(((char *) dev_ctl) + ((unsigned long) dev_inst));

dev_inst is a pointer, and here we're adding a pointer to a pointer.  How
peculiar.  Can this be done better?

> +	dev_blk = (struct edac_device_block *)
> +			(((char *) dev_ctl) + ((unsigned long) dev_blk));

If you turn the (char *) into (void *) then you can delete the
(struct edac_device_block *).

> +	dev_attrib = (struct edac_attrib *)
> +			(((char *) dev_ctl) + ((unsigned long) dev_attrib));
> +	pvt = sz_private ?
> +			(((char *) dev_ctl) + ((unsigned long) pvt)) : NULL;

dittoes.

> +	memset(dev_ctl, 0, total_size);		/* clear all fields */

Use kzalloc above, remove this.

> +	dev_ctl->nr_instances = nr_instances;
> +	dev_ctl->instances = dev_inst;
> +	dev_ctl->pvt_info = pvt;
> +
> +	/* Name of this edac device, ensure null terminated */
> +	snprintf(dev_ctl->name,sizeof(dev_ctl->name),"%s", edac_device_name);

one-space-after-comma.

> +	dev_ctl->name[sizeof(dev_ctl->name)-1] = '\0';

I think snprintf() did that, but the manpage is a bit vague.  The kernel's
implementation always null-terminates, anyway.

> +	/* Initialize every Instance */
> +	for (instance = 0; instance < nr_instances; instance++) {
> +		inst = &dev_inst[instance];
> +		inst->ctl = dev_ctl;
> +		inst->nr_blocks = nr_blocks;
> +		blk_p = &dev_blk[instance * nr_blocks];
> +		inst->blocks = blk_p;
> +
> +		/* name of this instance */
> +		snprintf(inst->name, sizeof(inst->name),
> +			"%s%u", edac_device_name, instance);
> +		inst->name[sizeof(inst->name)-1] = '\0';

Ditto

> +		/* Initialize every block in each instance */
> +		for (		block = 0;
> +				block < nr_blocks;
> +				block++) {

		for (block = 0; block < nr_blocks; block++) {


> +			blk = &blk_p[block];
> +			blk->instance = inst;
> +			blk->nr_attribs = nr_attribs;
> +			attrib_p = &dev_attrib[block * nr_attribs];
> +			blk->attribs = attrib_p;
> +			snprintf(blk->name, sizeof(blk->name),
> +				"%s%d", edac_block_name,block+1);
> +			blk->name[sizeof(blk->name)-1] = '\0';

ditto

> +			debugf1("%s() instance=%d block=%d name=%s\n",
> +				__func__, instance,block,blk->name);
> +
> +			if (attrib_spec != NULL) {
> +				/* when there is an attrib_spec passed int then
> +				 * Initialize every attrib of each block
> +				 */
> +				for (attr = 0; attr < nr_attribs; attr++) {
> +					attrib = &attrib_p[attr];
> +					attrib->block = blk;
> +
> +					/* Link each attribute to the caller's
> +					 * spec entry, for name and type
> +				 	 */
> +					attrib->spec = &attrib_spec[attr];
> +				}
> +			}
> +		}
> +	}
> +
> +	/* Mark this instance as merely ALLOCATED */
> +	dev_ctl->op_state = OP_ALLOC;
> +
> +	return dev_ctl;
> +}
> +EXPORT_SYMBOL_GPL(edac_device_alloc_ctl_info);
> +
>
> ...
>
> +/*
> + * find_edac_device_by_dev
> + *	scans the edac_device list for a specific 'struct device *'
> + */
> +static struct edac_device_ctl_info *
> +find_edac_device_by_dev(struct device *dev)
> +{
> +	struct edac_device_ctl_info *edac_dev;
> +	struct list_head *item;
> +
> +	debugf3("%s()\n", __func__);
> +
> +	list_for_each(item, &edac_device_list) {
> +		edac_dev = list_entry(item, struct edac_device_ctl_info, link);
> +
> +		if (edac_dev->dev == dev)
> +			return edac_dev;
> +	}
> +
> +	return NULL;
> +}

What locks edac_device_list?  device_ctls_mutex, I guess.  The introductory
comment should describe this requirement.  Please check all callers.

> +/*
> + * add_edac_dev_to_global_list
> + *	Before calling this function, caller must
> + *	assign a unique value to edac_dev->dev_idx.
> + *	Return:
> + *		0 on success
> + *		1 on failure.
> + */

Describe locking prerequisites

> +static int add_edac_dev_to_global_list (struct edac_device_ctl_info
> *edac_dev)
> +{
> +	struct list_head *item, *insert_before;
> +	struct edac_device_ctl_info *rover;
> +
> +	insert_before = &edac_device_list;
> +
> +	/* Determine if already on the list */
> +	if (unlikely((rover = find_edac_device_by_dev(edac_dev->dev)) !=
> NULL))
> +		goto fail0;

	rover = find_edac_device_by_dev(edac_dev->dev);
	if (unlikely(rover != NULL))

> +	/* Insert in ascending order by 'dev_idx', so find position */
> +	list_for_each(item, &edac_device_list) {
> +		rover = list_entry(item, struct edac_device_ctl_info, link);
> +
> +		if (rover->dev_idx >= edac_dev->dev_idx) {
> +			if (unlikely(rover->dev_idx == edac_dev->dev_idx))
> +				goto fail1;
> +
> +			insert_before = item;
> +			break;
> +		}
> +	}
> +
> +	list_add_tail_rcu(&edac_dev->link, insert_before);
> +	return 0;
> +
> +fail0:
> +	edac_printk(KERN_WARNING, EDAC_MC,
> +		"%s (%s) %s %s already assigned %d\n",
> +		rover->dev->bus_id, dev_name(rover->dev),
> +		rover->mod_name, rover->ctl_name, rover->dev_idx);
> +	return 1;
> +
> +fail1:
> +	edac_printk(KERN_WARNING, EDAC_MC,
> +		"bug in low-level driver: attempt to assign\n"
> +		"    duplicate dev_idx %d in %s()\n", rover->dev_idx, __func__);
> +	return 1;
> +}
> +
> +/*
> + * complete_edac_device_list_del
> + */

Not a very useful comment ;)

> +static void complete_edac_device_list_del(struct rcu_head *head)
> +{
> +	struct edac_device_ctl_info *edac_dev;
> +
> +	edac_dev = container_of(head, struct edac_device_ctl_info, rcu);
> +	INIT_LIST_HEAD(&edac_dev->link);
> +	complete(&edac_dev->complete);
> +}
> +
> +/*
> + * del_edac_device_from_global_list
> + */
> +static void del_edac_device_from_global_list(
> +			struct edac_device_ctl_info *edac_device)
> +{
> +	list_del_rcu(&edac_device->link);
> +	init_completion(&edac_device->complete);
> +	call_rcu(&edac_device->rcu, complete_edac_device_list_del);
> +	wait_for_completion(&edac_device->complete);
> +}

This function also needs some description, please.  What it's doing, why it
does it, how it does it.

> +/**
> + * edac_device_find
> + *	Search for a edac_device_ctl_info structure whose index is 'idx'.
> + *
> + * If found, return a pointer to the structure.
> + * Else return NULL.
> + *
> + * Caller must hold device_ctls_mutex.
> + */
> +struct edac_device_ctl_info * edac_device_find(int idx)
> +{
> +	struct list_head *item;
> +	struct edac_device_ctl_info *edac_dev;
> +
> +	/* Iterate over list, looking for exact match of ID */
> +	list_for_each(item, &edac_device_list) {
> +		edac_dev = list_entry(item, struct edac_device_ctl_info, link);
> +
> +		if (edac_dev->dev_idx >= idx) {
> +			if (edac_dev->dev_idx == idx)
> +				return edac_dev;
> +
> +			/* not on list, so terminate early */
> +			break;
> +		}
> +	}
> +
> +	return NULL;
> +}
> +EXPORT_SYMBOL(edac_device_find);

This is EXPORT_SYMBOL() but everything else is EXPORT_SYMBOL_GPL()

> +
> +/*
> + * edac_workq_function
> + *	performs the operation scheduled by a workq request
> + */
> +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20))

remove this test, please.

> +static void edac_workq_function(struct work_struct *work_req)
> +{
> +	struct delayed_work *d_work = (struct delayed_work*) work_req;
> +	struct edac_device_ctl_info *edac_dev =
> +		to_edac_device_ctl_work(d_work);
> +#else
> +static void edac_workq_function(void *ptr)
> +{
> +	struct edac_device_ctl_info *edac_dev =
> +		(struct edac_device_ctl_info *) ptr;
> +#endif
> +
> +	//debugf0("%s() here and running\n", __func__);
> +	lock_device_list();
> +
> +	/* Only poll controllers that are running polled and have a check */
> +	if ((edac_dev->op_state == OP_RUNNING_POLL) &&
> +					(edac_dev->edac_check != NULL)) {
> +		edac_dev->edac_check(edac_dev);
> +	}
> +
> +	unlock_device_list();
> +
> +	/* Reschedule */
> +	queue_delayed_work(edac_workqueue,&edac_dev->work, edac_dev->delay);
> +}
> +
> +/*
> + * edac_workq_setup
> + *	initialize a workq item for this edac_device instance
> + *	passing in the new delay period in msec
> + */
> +void edac_workq_setup(struct edac_device_ctl_info *edac_dev, unsigned
> msec)
> +{
> +	debugf0("%s()\n", __func__);
> +
> +	edac_dev->poll_msec = msec;
> +	edac_device_calc_delay(edac_dev);	/* Calc delay jiffies */
> +
> +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20))

And this one.

> +	INIT_DELAYED_WORK(&edac_dev->work,edac_workq_function);
> +#else
> +	INIT_WORK(&edac_dev->work,edac_workq_function,edac_dev);
> +#endif
> +	queue_delayed_work(edac_workqueue,&edac_dev->work, edac_dev->delay);
> +}
> +
> +/*
> + * edac_workq_teardown
> + *	stop the workq processing on this edac_dev
> + */
> +void edac_workq_teardown(struct edac_device_ctl_info *edac_dev)
> +{
> +	int status;
> +
> +	status = cancel_delayed_work(&edac_dev->work);
> +	if (status == 0) {
> +		/* workq instance might be running, wait for it */
> +		flush_workqueue(edac_workqueue);
> +	}
> +}
> +
> +/*
> + * edac_device_reset_delay_period
> + */
> +
> +void edac_device_reset_delay_period(
> +		struct edac_device_ctl_info *edac_dev,
> +		unsigned long value)
> +{
> +	lock_device_list();
> +
> +	/* cancel the current workq request */
> +	edac_workq_teardown(edac_dev);
> +
> +	/* restart the workq request, with new delay value */
> +	edac_workq_setup(edac_dev, value);
> +
> +	unlock_device_list();
> +}

This code can deadlock.  It calls edac_workq_teardown->flush_workqueue
while holding device_ctls_mutex.  But the workqueue callback also takes
device_ctls_mutex.  If that flush_workqueue() finds that it has to wait for
the callback function to complete, it will wait forever.

> +/*
> + * edac_op_state_toString(edac_dev)
> + */
> +static char *edac_op_state_toString(struct edac_device_ctl_info
> *edac_dev)

edac_op_state_to_string, please.

> +{
> +	int opstate = edac_dev->op_state;
> +
> +	if (opstate == OP_RUNNING_POLL)
> +		return "POLLED";
> +	else if (opstate == OP_RUNNING_INTERRUPT)
> +		return "INTERRUPT";
> +	else if (opstate == OP_RUNNING_POLL_INTR)
> +		return "POLL-INTR";
> +	else if (opstate == OP_ALLOC)
> +		return "ALLOC";
> +	else if (opstate == OP_OFFLINE)
> +		return "OFFLINE";
> +
> +	return "UNKNOWN";
> +}
> +
>
> ...
>
> +/**
> + * edac_device_del_device:
> + *	Remove sysfs entries for specified edac_device structure and
> + *	then remove edac_device structure from global list
> + *
> + * @pdev:
> + *	Pointer to 'struct device' representing edac_device
> + *	structure to remove.
> + *
> + * Return:
> + *	Pointer to removed edac_device structure,
> + *	OR NULL if device not found.
> + */
> +struct edac_device_ctl_info * edac_device_del_device(struct device
> *dev)

s/* /*/

> +{
> +	struct edac_device_ctl_info *edac_dev;
> +
> +	debugf0("MC: %s()\n", __func__);
> +
> +	lock_device_list();
> +
> +	if ((edac_dev = find_edac_device_by_dev(dev)) == NULL) {

coding style

> +		unlock_device_list();
> +		return NULL;
> +	}
> +
> +	/* mark this instance as OFFLINE */
> +	edac_dev->op_state = OP_OFFLINE;
> +
> +	/* clear workq processing on this instance */
> +	edac_workq_teardown(edac_dev);
> +
> +	/* Tear down the sysfs entries for this instance */
> +	edac_device_remove_sysfs(edac_dev);
> +
> +	/* deregister from global list */
> +	del_edac_device_from_global_list(edac_dev);
> +
> +	unlock_device_list();
> +
> +	edac_printk(KERN_INFO, EDAC_MC,
> +		"Removed device %d for %s %s: DEV %s\n",
> +		edac_dev->dev_idx,
> +		edac_dev->mod_name,
> +		edac_dev->ctl_name,
> +		dev_name(edac_dev->dev));
> +
> +	return edac_dev;
> +}
> +EXPORT_SYMBOL_GPL(edac_device_del_device);
>
> ...
>
>  
> +extern char * edac_align_ptr(void *ptr, unsigned size);

s/* /*/

> +/*
> + * The following are the structures to provide for a generice

s/generice/generic/

> + * or abstract 'edac_device'. This set of structures and the
> + * code that implements the APIs for the same, provide for
> + * registering EDAC type devices which are NOT standard memory.
> + *
> + * CPU caches (L1 and L2)
> + * DMA engines
> + * Core CPU swithces
> + * Fabric switch units
> + * PCIe interface controllers
> + * other EDAC/ECC type devices that can be monitored for
> + * errors, etc.
> + *
> + * It allows for a 2 level set of hiearchry. For example:
> + *
> + * cache could be composed of L1, L2 and L3 levels of cache.
> + * Each CPU core would have its own L1 cache, while sharing
> + * L2 and maybe L3 caches.
> + *
> + * View them arranged, via the sysfs presentation:
> + * /sys/devices/system/edac/..
> + *
> + *	mc/		<existing memory device directory>
> + *	cpu/cpu0/..	<L1 and L2 block directory>
> + *		/L1-cache/ce_count
> + *			 /ue_count
> + *		/L2-cache/ce_count
> + *			 /ue_count
> + *	cpu/cpu1/..	<L1 and L2 block directory>
> + *		/L1-cache/ce_count
> + *			 /ue_count
> + *		/L2-cache/ce_count
> + *			 /ue_count
> + *	...
> + *
> + *	the L1 and L2 directories would be "edac_device_block's"
> + */
> +
> +struct edac_device_counter {
> +	u32	ue_count;
> +	u32	ce_count;
> +};
> +
> +#define INC_COUNTER(cnt)	(cnt++)

remove this macro, open-code it.

> +/*
> + * An array of these is passed to the alloc() function
> + * to specify attributes of the edac_block
> + */
> +struct edac_attrib_spec {
> +	char  name[EDAC_DEVICE_NAME_LEN + 1];
> +
> +	int type;
> +#define	EDAC_ATTR_INT		0x01
> +#define EDAC_ATTR_CHAR		0x02
> +};
> +
> +
> +/* Attribute control structure
> + * In this structure is a pointer to the driver's edac_attrib_spec
> + * The life of this pointer is inclusive in the life of the driver's
> + * life cycle.
> + */
> +struct edac_attrib {
> +	struct edac_device_block *block;	/* Up Pointer */
> +
> +	struct edac_attrib_spec *spec;		/* ptr to module spec entry */
> +
> +	union {					/* actual value */
> +		int edac_attrib_int_value;
> +		char edac_attrib_char_value[EDAC_ATTRIB_VALUE_LEN + 1];
> +	} edac_attrib_value;
> +};

The code is much better commented that the usual offerings.  Thanks ;)

> +/* device block control structure */
> +struct edac_device_block {
> +	struct edac_device_instance *instance;	/* Up Pointer */
> +	char  name[EDAC_DEVICE_NAME_LEN + 1];
> +
> +	struct edac_device_counter counters;	/* basic UE and CE counters */
> +
> +	int nr_attribs;				/* how many attributes */
> +	struct edac_attrib *attribs;		/* this block's attributes */
> +
> +	/* edac sysfs device control */
> +	struct kobject kobj;
> +	struct completion kobj_complete;
> +};

hm, the combination of kobects and completions causes alarm bells to
jangle.  Various code at various times has attempted to implement "wait
until the object goes away" synchronisation, and it has usually (always?)
been wrong.

So.  What's going on here?

> +/* device instance control structure */
> +struct edac_device_instance {
> +	struct edac_device_ctl_info *ctl;	/* Up pointer */
> +	char name[EDAC_DEVICE_NAME_LEN + 4];
> +
> +	struct edac_device_counter counters;	/* instance counters */
> +
> +	u32 nr_blocks;				/* how many blocks */
> +	struct edac_device_block *blocks;	/* block array */
> +
> +	/* edac sysfs device control */
> +	struct kobject kobj;
> +	struct completion kobj_complete;
> +};

Ditto.

> +
> +/*
> + * Abstract edac_device control info structure
> + *
> + */
> +struct edac_device_ctl_info {
> +	/* for global list of edac_device_ctl_info structs */
> +	struct list_head link;
> +
> +	int dev_idx;
> +
> +	/* Per instance controls for this edac_device */
> +	int log_ue;		/* boolean for logging UEs */
> +	int log_ce;		/* boolean for logging CEs */
> +	int panic_on_ue;	/* boolean for panic'ing on an UE */
> +	unsigned poll_msec;	/* number of milliseconds to poll interval */
> +	unsigned long delay;	/* number of jiffies for poll_msec */
> +
> +	struct sysdev_class *edac_class;	/* pointer to class */
> +
> +	/* the internal state of this controller instance */
> +	int op_state;
> +#define	OP_ALLOC		0x100
> +#define OP_RUNNING_POLL		0x201
> +#define OP_RUNNING_INTERRUPT	0x202
> +#define OP_RUNNING_POLL_INTR	0x203
> +#define OP_OFFLINE		0x300
> +
> +	/* work struct for this instance */
> +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20))

remove, please.

> +	struct delayed_work work;
> +#else
> +	struct work_struct work;
> +#endif
> +
> +	/* pointer to edac polling checking routine:
> +	 *	If NOT NULL: points to polling check routine
> +	 *	If NULL: Then assumes INTERRUPT operation, where
> +	 *		MC driver will receive events
> +	 */
> +	void (*edac_check) (struct edac_device_ctl_info * edac_dev);
> +
> +	struct device *dev;	/* pointer to device structure */
> +
> +	const char *mod_name;	/* module name */
> +	const char *ctl_name;	/* edac controller  name */
> +
> +	void *pvt_info;		/* pointer to 'private driver' info */
> +
> +	unsigned long start_time;/* edac_device load start time (jiffies)*/
> +
> +	/* these are for safe removal of mc devices from global list while
> +	 * NMI handlers may be traversing list
> +	 */
> +	struct rcu_head rcu;
> +	struct completion complete;
> +
> +	/* sysfs top name under 'edac' directory
> +	 * and instance name:
> +	 *	cpu/cpu0/...
> +	 *	cpu/cpu1/...
> +	 *	cpu/cpu2/...
> +	 *	...
> +	 */
> +	char name[EDAC_DEVICE_NAME_LEN + 1];
> +
> +	/* Number of instances supported on this control structure
> +	 * and the array of those instances
> +	 */
> +	u32 nr_instances;
> +	struct edac_device_instance *instances;
> +
> +	/* Event counters for the this whole EDAC Device */
> +	struct edac_device_counter counters;
> +
> +	/* edac sysfs device control for the 'name'
> +	 * device this structure controls
> +	 */
> +	struct kobject kobj;
> +	struct completion kobj_complete;
> +};

ditto.

> +/* To get from the instance's wq to the beginning of the ctl structure
> */
> +#define to_edac_device_ctl_work(w) \
> +		container_of(w,struct edac_device_ctl_info,work)
> +
> +/* Function to calc the number of delay jiffies from poll_msec */
> +static inline void edac_device_calc_delay(
> +				struct edac_device_ctl_info *edac_dev)
> +{
> +	/* convert from msec to jiffies */
> +	edac_dev->delay = edac_dev->poll_msec * HZ / 1000;
> +}

Use msecs_to_jiffies()

> ===================================================================
> --- /dev/null
> +++ linux-2.6.22-rc1/drivers/edac/edac_device_sysfs.c
> @@ -0,0 +1,837 @@
> +/*
> + * file for managing the edac_device class of devices for EDAC
> + *
> + * (C) 2007 SoftwareBitMaker(http://www.softwarebitmaker.com)
> + * This file may be distributed under the terms of the
> + * GNU General Public License.
> + *
> + * Written Doug Thompson <norsk5@xmission.com>
> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/sysdev.h>
> +#include <linux/ctype.h>
> +
> +#include "edac_core.h"
> +#include "edac_module.h"
> +
> +
> +#define EDAC_DEVICE_SYMLINK	"device"
> +
> +#define to_edacdev(k) container_of(k, struct edac_device_ctl_info,
> kobj)
> +#define to_edacdev_attr(a) container_of(a, struct edacdev_attribute,
> attr)
> +
> +#ifdef DKT

What's DKT?

Oh, it's you ;)

> +	if (edacdev_attr->store)
> +		return edacdev_attr->store(edac_dev, buffer, count);
> +
> +	return -EIO;
> +}
> +
> +static struct sysfs_ops edac_dev_ops = {
> +	.show = edacdev_show,
> +	.store = edacdev_store
> +};
> +
> +#define EDACDEV_ATTR(_name,_mode,_show,_store)			\
> +static struct edacdev_attribute edac_dev_attr_##_name = {			\
> +	.attr = {.name = __stringify(_name), .mode = _mode },	\
> +	.show   = _show,					\
> +	.store  = _store,					\
> +};
> +
> +/* default Control file */
> +EDACDEV_ATTR(reset_counters,S_IWUSR,NULL,edac_dev_reset_counters_store);
> +
> +/* default Attribute files */
> +EDACDEV_ATTR(mc_name,S_IRUGO,edac_dev_ctl_name_show,NULL);
> +EDACDEV_ATTR(seconds_since_reset,S_IRUGO,edac_dev_seconds_show,NULL);
> +EDACDEV_ATTR(ue_count,S_IRUGO,edac_dev_ue_count_show,NULL);
> +EDACDEV_ATTR(ce_count,S_IRUGO,edac_dev_ce_count_show,NULL);
> +
> +
> +static struct edacdev_attribute *edacdev_attr[] = {
> +	&edacdev_attr_reset_counters,
> +	&edacdev_attr_mc_name,
> +	&edacdev_attr_seconds_since_reset,
> +	&edacdev_attr_ue_count,
> +	&edacdev_attr_ce_count,
> +	NULL
> +};

Can we use attribute_group here?

> +/*
> + * Release of a Edac Device controlling instance
> + */
> +static void edac_dev_instance_release(struct kobject *kobj)
> +{
> +	struct edac_device_ctl_info *edac_dev;
> +
> +	edac_dev = to_edacdev(kobj);
> +	debugf0("%s() idx=%d\n", __func__, edac_dev->dev_idx);
> +	complete(&edac_dev->kobj_complete);
> +}
> +
> +static struct kobj_type ktype_device = {
> +	.release = edac_dev_instance_release,
> +	.sysfs_ops = &edacdev_ops,
> +	.default_attrs = (struct attribute **) edacdev_attr,
> +};

yeah, we need to have a look at this.  Having other code wait upon the
->release() callback is problematic, and ->release callbacks are supposed
to free objects, but this one doesn't.

Please cc Greg KH <greg@kroah.com> on the description, because he's the man
and this stuff makes my head spin.

> +#endif
> +
> +/************************** edac_device sysfs code and data
> **************/
> +
> +/*
> + * Set of edac_device_ctl_info attribute store/show functions
> + */
> +
> +/* 'log_ue' */
> +static ssize_t edac_device_ctl_log_ue_show(
> +		struct edac_device_ctl_info *ctl_info, char *data)
> +{
> +        return sprintf(data,"%u\n", ctl_info->log_ue);
> +}
> +
> +static ssize_t edac_device_ctl_log_ue_store(
> +		struct edac_device_ctl_info *ctl_info,
> +			const char *data,size_t count)
> +{
> +	/* if parameter is zero, turn off flag, if non-zero turn on flag */
> +	ctl_info->log_ue = (simple_strtoul(data,NULL,0) != 0);
> +
> +        return count;
> +}

whitepace broke

> +/* 'log_ce' */
> +static ssize_t edac_device_ctl_log_ce_show(
> +		struct edac_device_ctl_info *ctl_info,char *data)
> +{
> +        return sprintf(data,"%u\n", ctl_info->log_ce);
> +}
> +
> +static ssize_t edac_device_ctl_log_ce_store(
> +		struct edac_device_ctl_info *ctl_info,
> +			const char *data,size_t count)
> +{
> +	/* if parameter is zero, turn off flag, if non-zero turn on flag */
> +	ctl_info->log_ce = (simple_strtoul(data,NULL,0) != 0);
> +
> +        return count;
> +}

whitespace broke

> +
> +/* 'panic_on_ue' */
> +static ssize_t edac_device_ctl_panic_on_ue_show(
> +		struct edac_device_ctl_info *ctl_info, char *data)
> +{
> +        return sprintf(data,"%u\n", ctl_info->panic_on_ue);
> +}
> +
> +static ssize_t edac_device_ctl_panic_on_ue_store(
> +		struct edac_device_ctl_info *ctl_info,
> +			const char *data,size_t count)
> +{
> +	/* if parameter is zero, turn off flag, if non-zero turn on flag */
> +	ctl_info->panic_on_ue = (simple_strtoul(data,NULL,0) != 0);
> +
> +	return count;
> +}
> +
> +/* 'poll_msec' show and store functions*/
> +static ssize_t edac_device_ctl_poll_msec_show(
> +		struct edac_device_ctl_info *ctl_info, char *data)
> +{
> +        return sprintf(data,"%u\n", ctl_info->poll_msec);
> +}
> +
> +static ssize_t edac_device_ctl_poll_msec_store(
> +		struct edac_device_ctl_info *ctl_info,
> +		const char *data,size_t count)
> +{
> +	unsigned long value;
> +
> +	/* get the value and enforce that it is non-zero, must be at least
> +	 * one millisecond for the delay period, between scans
> +	 * Then cancel last outstanding delay for the work request
> +	 * and set a new one.
> +	 */
> +	value = simple_strtoul(data,NULL,0);
> +	edac_device_reset_delay_period(ctl_info,value);
> +
> +        return count;
> +}

whitespace broke

> +
> +/* edac_device_ctl_info specific attribute structure */
> +struct ctl_info_attribute {
> +        struct attribute attr;
> +        ssize_t (*show)(struct edac_device_ctl_info *,char *);
> +        ssize_t (*store)(struct edac_device_ctl_info *,const char
> *,size_t);
> +};
> +
>
>...
>
> +/* Base Attributes of the EDAC_DEVICE ECC object */
> +static struct ctl_info_attribute *device_ctrl_attr[] = {
> +	&attr_ctl_info_panic_on_ue,
> +	&attr_ctl_info_log_ue,
> +	&attr_ctl_info_log_ce,
> +	&attr_ctl_info_poll_msec,
> +	NULL,
> +};

attribute_group?

> +/* Main DEVICE kobject release() function */
> +static void edac_device_ctrl_master_release(struct kobject *kobj)
> +{
> +	struct edac_device_ctl_info *edac_dev;
> +
> +	edac_dev = to_edacdev(kobj);
> +
> +	debugf1("%s()\n", __func__);
> +	complete(&edac_dev->kobj_complete);
> +}
> +
> +static struct kobj_type ktype_device_ctrl = {
> +	.release = edac_device_ctrl_master_release,
> +	.sysfs_ops = &device_ctl_info_ops,
> +	.default_attrs = (struct attribute **) device_ctrl_attr,
> +};

dittos wrt ->release() usage

> +
> +/*
> + * edac_device_unregister_main_kobj:
> + *	the '..../edac/<name>' kobject
> + */
> +static void edac_device_unregister_main_kobj(
> +			struct edac_device_ctl_info *edac_dev)
> +{
> +	debugf0("%s()\n", __func__);
> +	debugf1("%s() name of kobject is: %s\n",
> +		__func__, kobject_name(&edac_dev->kobj));
> +
> +	init_completion(&edac_dev->kobj_complete);
> +
> +	/*
> +	 * Unregister the edac device's kobject and
> +	 * wait for reference count to reach 0.
> +	 */
> +	kobject_unregister(&edac_dev->kobj);
> +	wait_for_completion(&edac_dev->kobj_complete);
> +}

Yes, there are, I think, situations where this can cause hangs.  Greg will
know more.  iirc they're obscure things like the process which is running
edac_device_unregister_main_kobj() itself has an fd open against the
relevant sysfs file.

The solution will be to just remove the wait, get the refcounting right.

> +
> +/*************** edac_dev -> instance information ***********/
> +
> +/*
> + * Set of low-level instance attribute show functions
> + */
> +static ssize_t instance_ue_count_show(
> +		struct edac_device_instance *instance, char *data)
> +{
> +        return sprintf(data,"%u\n", instance->counters.ue_count);
> +}
> +
> +static ssize_t instance_ce_count_show(
> +		struct edac_device_instance *instance, char *data)
> +{
> +        return sprintf(data,"%u\n", instance->counters.ce_count);
> +}
>
> ...
>
> +/* list of edac_dev 'instance' attributes */
> +static struct instance_attribute *device_instance_attr[] = {
> +	&attr_instance_ce_count,
> +	&attr_instance_ue_count,
> +	NULL,
> +};

attribute_group?

> +/*
> + * edac_device_create_block
> + */
> +static int edac_device_create_block(
> +		struct edac_device_ctl_info *edac_dev,
> +		struct edac_device_instance *instance,
> +		int idx)
> +{
> +	int err;
> +	struct edac_device_block *block;
> +
> +	block = &instance->blocks[idx];
> +
> +	debugf1("%s() Instance '%s' block[%d] '%s'\n",
> +		__func__,instance->name, idx, block->name);
> +
> +	/* init this block's kobject */
> +	memset(&block->kobj, 0, sizeof (struct kobject));
> +	block->kobj.parent = &instance->kobj;
> +	block->kobj.ktype = &ktype_block_ctrl;
> +
> +	err = kobject_set_name(&block->kobj,"%s",block->name);
> +	if (err)
> +		return err;
> +
> +	err = kobject_register(&block->kobj);
> +	if (err) {
> +		debugf1("%s()Failed to register instance '%s'\n",
> +			__func__,block->name);
> +		return err;
> +	}
> +
> +	return 0;
> +}

Lots of sysfs/kobject work here.  We should ask Greg to review it rather
than relying upon the overstressed peanut gallery.

> +/*
> + * edac_device_remove_instance
> + *	remove an edac_device instance
> + */
> +static void edac_device_delete_instance(
> +		struct edac_device_ctl_info *edac_dev, int idx)
> +{
> +	int i;
> +	struct edac_device_instance *instance;
> +
> +	instance = &edac_dev->instances[idx];
> +
> +	/* unregister all blocks in this instance */
> +	for (i = 0; i < instance->nr_blocks; i++) {
> +		edac_device_delete_block(edac_dev,instance,i);
> +	}
> +
> +	/* unregister this instance's kobject */
> +	init_completion(&instance->kobj_complete);
> +	kobject_unregister(&instance->kobj);
> +	wait_for_completion(&instance->kobj_complete);
> +}

again, troublesome

> +/*
> + * edac_device_create_instances
> + *	create the first level of 'instances' for this device
> + *	(ie  'cache' might have 'cache0', 'cache1', 'cache2', etc
> + */
> +static int edac_device_create_instances(struct edac_device_ctl_info
> *edac_dev)
> +{
> +	int i, j;
> +	int err;
> +
> +	debugf0("%s()\n", __func__);
> +
> +	/* iterate over creation of the instances */
> +	for (i = 0; i < edac_dev->nr_instances; i++ ) {
> +		err = edac_device_create_instance(edac_dev,i);
> +		if (err) {
> +			/* unwind previous instances on error */
> +			for (j = 0; j < i; j++) {
> +				edac_device_delete_instance(edac_dev,j);
> +			}

Unneeded braces

> +			return err;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * edac_device_delete_instances(edac_dev);
> + *	unregister all the kobjects of the instances
> + */
> +static void edac_device_delete_instances(struct edac_device_ctl_info
> *edac_dev)
> +{
> +	int i;
> +
> +	/* iterate over creation of the instances */
> +	for (i = 0; i < edac_dev->nr_instances; i++ ) {
> +		edac_device_delete_instance(edac_dev,i);
> +	}

ditto

> +}
> +
> +/******************* edac_dev sysfs ctor/dtor  code *************/
> +
> +/*
> + * edac_device_create_sysfs() Constructor
> + *
> + * Create a new edac_device kobject instance,
> + *
> + * Return:
> + *	0	Success
> + *	!0	Failure
> + */
> +int edac_device_create_sysfs(struct edac_device_ctl_info *edac_dev)
> +{
> +	int err;
> +	struct kobject *edac_kobj=&edac_dev->kobj;
> +
> +	/* register this instance's main kobj with the edac class kobj */
> +	err = edac_device_register_main_kobj(edac_dev);
> +	if (err)
> +		return err;
> +
> +	debugf0("%s() idx=%d\n", __func__, edac_dev->dev_idx);
> +
> +	/* create a symlink from the edac device
> +	 * to the platform 'device' being used for this
> +	 */
> +	err = sysfs_create_link(edac_kobj,
> +				&edac_dev->dev->kobj,
> +				EDAC_DEVICE_SYMLINK);
> +	if (err) {
> +		debugf0("%s() sysfs_create_link() returned err= %d\n",
> +			__func__, err);
> +		return err;
> +	}
> +
> +	debugf0("%s() calling create-instances, idx=%d\n",
> +		__func__, edac_dev->dev_idx);
> +
> +	/* Create the first level instance directories */
> +	err = edac_device_create_instances(edac_dev);
> +	if (err) {
> +		goto error0;
> +	}

ditto

> +	return 0;
> +
> +	/* Error unwind stack */
> +
> +error0:
> +	edac_device_unregister_main_kobj(edac_dev);
> +
> +	return err;
> +}
> +
>  
> ...
>
> +
> +/*
> + * sysfs object: /sys/devices/system/edac
> + *	need to export to other files in this modules
> + */
> +static struct sysdev_class edac_class = {
> +	set_kset_name("edac"),
> +};
> +static int edac_class_valid = 0;

Unneeded initialsiation

> +
> +/*
> + * edac_get_edac_class()
> + *
> + *	return pointer to the edac class of 'edac'
> + */
> +struct sysdev_class *edac_get_edac_class(void)
> +{
> +	struct sysdev_class *classptr=NULL;

s/=/ = /

> +
> +	if (edac_class_valid)
> +		classptr = &edac_class;
> +
> +	return classptr;
> +}
> +
> +/*
> + * edac_register_sysfs_edac_name()
> + *
> + *	register the 'edac' into /sys/devices/system
> + *
> + * return:
> + *	0  success
> + *	!0 error
> + */
> +static int edac_register_sysfs_edac_name(void)
> +{
> +	int err;
> +
> +	/* create the /sys/devices/system/edac directory */
> +	err = sysdev_class_register(&edac_class);
> +
> +	if (err) {
> +		debugf1("%s() error=%d\n", __func__, err);
> +		return err;
> +	}
> +
> +	edac_class_valid = 1;
> +	return 0;
> +}
> +

