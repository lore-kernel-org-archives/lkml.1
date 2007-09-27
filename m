Return-Path: <linux-kernel-owner+w=401wt.eu-S1753296AbXI0CZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296AbXI0CZS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 22:25:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751551AbXI0CZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 22:25:04 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:49747 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751493AbXI0CZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 22:25:00 -0400
Date: Thu, 27 Sep 2007 11:24:40 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Mark Gross <mgross@linux.intel.com>
Cc: linux-pm <linux-pm@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] QoS params patch
Message-ID: <20070927022440.GB25873@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Mark Gross <mgross@linux.intel.com>,
	linux-pm <linux-pm@lists.linux-foundation.org>,
	lkml <linux-kernel@vger.kernel.org>
References: <20070926223712.GA22029@linux.intel.com> <20070926224026.GA23218@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070926224026.GA23218@linux.intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2007 at 03:40:26PM -0700, Mark Gross wrote:
> +	struct list_head list;
> +	union {
> +		s32 value;
> +		s32 usec;
> +		s32 kbps;
> +		};
> +	char *name;

Your } is in a strange place. It looks like it wants to join its friends
closer to the left margin ;-)

> +};
> +
> +#define QOS_RESERVED 0
> +#define QOS_CPU_DMA_LATENCY 1
> +#define QOS_NETWORK_LATENCY 2
> +#define QOS_NETWORK_THROUGHPUT 3
> +
> +#define QOS_NUM_CLASSES 4
> +#define QOS_DEFAULT_VALUE -1

an enum would be better for this, especially as people are likely to add
new types, having to update QOS_NUM_CLASSES each time sucks.

> +/* static helper functions */
> +static s32 max_compare(s32 v1, s32 v2)
> +{
> +	if (v1 < v2)
> +		return v2;
> +	else
> +		return v1;
> +}
> +
> +static s32 min_compare(s32 v1, s32 v2)
> +{
> +	if (v1 < v2)
> +		return v1;
> +	else
> +		return v2;
> +}
> +
min()/max() instead?

> +/* assumes qos_lock is held */
> +static void update_target(int i)
> +{
'target' might be a more meaningful variable name.

> +	qos->qos_power_miscdev.fops = &qos_power_fops;
> +
> +	ret = misc_register(& qos->qos_power_miscdev);
> +	if (ret < 0 )
> +		printk(KERN_ERR "qos_power: misc_register returns %d.\n", ret);
> +
> +	return ret;
> +}
> +
Just return misc_register(...); ?

> +	if( i < QOS_NUM_CLASSES) {
> +		qos = &qos_array[i];
> +		qos->name = kstrdup(name, GFP_KERNEL);
> +		if(!qos->name)
> +			goto cleanup;
> +
> +		qos->default_value = default_value;
> +		qos->target_value = default_value;
> +		qos->comparitor = comparitor;
> +		srcu_init_notifier_head(&qos->notifiers);
> +		INIT_LIST_HEAD(&qos->requirements.list);
> +		if (register_new_qos_misc(qos) < 0 )
> +			goto cleanup;
> +	}
> +	return;
> +cleanup:
> +	kfree(qos->name);
> +}

This leaks. You'll have to scan down from i and clean up the kstrdup()
per qos_array element. Presently this will only free the first one to fail
registration.

> +
> +int qos_add_requirement(int i, char *name, s32 value)
> +{
> +	struct requirement_list * dep;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&qos_lock, flags);
> +	dep = kzalloc(sizeof(struct requirement_list), GFP_KERNEL);

kmalloc() under a spinlock. GFP_KERNEL implies __GFP_WAIT, which can
sleep. Slab debugging would have caught this, too.

> +	if (dep) {
> +		if (value == QOS_DEFAULT_VALUE)
> +			dep->value = qos_array[i].default_value;
> +		else
> +			dep->value = value;
> +		dep->name = kstrdup(name, GFP_KERNEL);

And here also, still under the spinlock. You can probably rework the
locking just to protect the list, if you really need it at all, it
doesn't seem to matter anywhere else here.

> +		if(!dep->name)
> +			goto cleanup;
> +
> +		list_add(&dep->list, &qos_array[i].requirements.list);
> +		update_target(i);
> +		spin_unlock_irqrestore(&qos_lock, flags);
> +
> +		return 0;
> +	}
> +	spin_unlock_irqrestore(&qos_lock, flags);
> +	
> +cleanup:
> +	if(dep)
> +		kfree(dep);

no if() needed. 

> +	return -ENOMEM;
> +}
> +EXPORT_SYMBOL_GPL(qos_add_requirement);

You also didn't spin_unlock_irqrestore() in the error path, so this bails
out with the lock held and IRQs disabled.
