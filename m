Return-Path: <linux-kernel-owner+w=401wt.eu-S1757571AbXI0QVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757571AbXI0QVk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 12:21:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755014AbXI0QVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 12:21:33 -0400
Received: from mga07.intel.com ([143.182.124.22]:15538 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753147AbXI0QVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 12:21:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,204,1188802800"; 
   d="scan'208";a="287913954"
Date: Thu, 27 Sep 2007 09:21:09 -0700
From: Mark Gross <mgross@linux.intel.com>
To: Paul Mundt <lethal@linux-sh.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] QoS params patch
Message-ID: <20070927162109.GG25718@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <20070926223712.GA22029@linux.intel.com> <20070926224026.GA23218@linux.intel.com> <20070927022440.GB25873@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070927022440.GB25873@linux-sh.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2007 at 11:24:40AM +0900, Paul Mundt wrote:
> On Wed, Sep 26, 2007 at 03:40:26PM -0700, Mark Gross wrote:
> > +	struct list_head list;
> > +	union {
> > +		s32 value;
> > +		s32 usec;
> > +		s32 kbps;
> > +		};
> > +	char *name;
> 
> Your } is in a strange place. It looks like it wants to join its friends
> closer to the left margin ;-)

fixed.

> 
> > +};
> > +
> > +#define QOS_RESERVED 0
> > +#define QOS_CPU_DMA_LATENCY 1
> > +#define QOS_NETWORK_LATENCY 2
> > +#define QOS_NETWORK_THROUGHPUT 3
> > +
> > +#define QOS_NUM_CLASSES 4
> > +#define QOS_DEFAULT_VALUE -1
> 
> an enum would be better for this, especially as people are likely to add
> new types, having to update QOS_NUM_CLASSES each time sucks.

I'm partial to the simplicity of not using an enum in this case.  We do
want it to be somewhat non-trivial to add qos classes.  

> 
> > +/* static helper functions */
> > +static s32 max_compare(s32 v1, s32 v2)
> > +{
> > +	if (v1 < v2)
> > +		return v2;
> > +	else
> > +		return v1;
> > +}
> > +
> > +static s32 min_compare(s32 v1, s32 v2)
> > +{
> > +	if (v1 < v2)
> > +		return v1;
> > +	else
> > +		return v2;
> > +}
> > +
> min()/max() instead?

done.

> 
> > +/* assumes qos_lock is held */
> > +static void update_target(int i)
> > +{
> 'target' might be a more meaningful variable name.

done.

> 
> > +	qos->qos_power_miscdev.fops = &qos_power_fops;
> > +
> > +	ret = misc_register(& qos->qos_power_miscdev);
> > +	if (ret < 0 )
> > +		printk(KERN_ERR "qos_power: misc_register returns %d.\n", ret);
> > +
> > +	return ret;
> > +}
> > +
> Just return misc_register(...); ?

ok.

> 
> > +	if( i < QOS_NUM_CLASSES) {
> > +		qos = &qos_array[i];
> > +		qos->name = kstrdup(name, GFP_KERNEL);
> > +		if(!qos->name)
> > +			goto cleanup;
> > +
> > +		qos->default_value = default_value;
> > +		qos->target_value = default_value;
> > +		qos->comparitor = comparitor;
> > +		srcu_init_notifier_head(&qos->notifiers);
> > +		INIT_LIST_HEAD(&qos->requirements.list);
> > +		if (register_new_qos_misc(qos) < 0 )
> > +			goto cleanup;
> > +	}
> > +	return;
> > +cleanup:
> > +	kfree(qos->name);
> > +}
> 
> This leaks. You'll have to scan down from i and clean up the kstrdup()
> per qos_array element. Presently this will only free the first one to fail
> registration.

Not seeing the leak here.  this is an if block not a for loop.
 
> 
> > +
> > +int qos_add_requirement(int i, char *name, s32 value)
> > +{
> > +	struct requirement_list * dep;
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(&qos_lock, flags);
> > +	dep = kzalloc(sizeof(struct requirement_list), GFP_KERNEL);
> 
> kmalloc() under a spinlock. GFP_KERNEL implies __GFP_WAIT, which can
> sleep. Slab debugging would have caught this, too.
> 

/me turns on slab debugging.

> > +	if (dep) {
> > +		if (value == QOS_DEFAULT_VALUE)
> > +			dep->value = qos_array[i].default_value;
> > +		else
> > +			dep->value = value;
> > +		dep->name = kstrdup(name, GFP_KERNEL);
> 
> And here also, still under the spinlock. You can probably rework the
> locking just to protect the list, if you really need it at all, it
> doesn't seem to matter anywhere else here.
>

Re-worked.  I didn't need the lock to be held as long as I had it.
Thanks for catching this!

> > +		if(!dep->name)
> > +			goto cleanup;
> > +
> > +		list_add(&dep->list, &qos_array[i].requirements.list);
> > +		update_target(i);
> > +		spin_unlock_irqrestore(&qos_lock, flags);
> > +
> > +		return 0;
> > +	}
> > +	spin_unlock_irqrestore(&qos_lock, flags);
> > +	
> > +cleanup:
> > +	if(dep)
> > +		kfree(dep);
> 
> no if() needed. 

fixed.

> 
> > +	return -ENOMEM;
> > +}
> > +EXPORT_SYMBOL_GPL(qos_add_requirement);
> 
> You also didn't spin_unlock_irqrestore() in the error path, so this bails
> out with the lock held and IRQs disabled.

fixed by the re-work.

--mgross
