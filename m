Return-Path: <linux-kernel-owner+w=401wt.eu-S1754477AbXJWVIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477AbXJWVIq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 17:08:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752913AbXJWVIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 17:08:30 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:34241 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781AbXJWVI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 17:08:29 -0400
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] LinuxPPS - PPS support for Linux
X-Message-Flag: Warning: May contain useful information
References: <20071023180417.GM9748@enneenne.com>
	<20071023201750.GE7793@redhat.com>
	<20071023205459.GP9748@enneenne.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 23 Oct 2007 14:08:19 -0700
In-Reply-To: <20071023205459.GP9748@enneenne.com> (Rodolfo Giometti's message of "Tue, 23 Oct 2007 22:55:00 +0200")
Message-ID: <adasl414jzw.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 23 Oct 2007 21:08:19.0541 (UTC) FILETIME=[D668B050:01C815B8]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A few comments:

 > +		dev_err(port->dev, "PPS support disabled due port \"%s\" is "
 > +					"in polling mode\n",

I think "because" instead of "due" is closer to standard English.

 > +		printk(KERN_ERR "pps: %s: too much PPS sources in the system\n",
 > +					info->name);

Similarly should be "many" instead of "much".

 > +	/* Get new ID for the new PPS source */
 > +	if (idr_pre_get(&pps_idr, GFP_KERNEL) == 0) {
 > +		err = -ENOMEM;
 > +		goto kfree_pps;
 > +	}
 > +
 > +	spin_lock_irq(&idr_lock);
 > +	err = idr_get_new(&pps_idr, pps, &id);
 > +	spin_unlock_irq(&idr_lock);
 > +
 > +	if (err < 0)
 > +		goto kfree_pps;

You usually can handle idr_get_new() returning -EAGAIN by jumping back
to the idr_pre_get(), to handle someone else coming in and stealing
the memory you just preallocated.  In this case it may not matter
since it's pretty unlikely that a lot of contexts are using the idr at
the same time.  But anyway...

 > +void pps_unregister_source(int source)
 > ...
 > +	wait_event(pps->usage_queue, atomic_read(&pps->usage) == 0);
 > +
 > +	pps_sysfs_remove_source_entry(pps);
 > +	pps_unregister_cdev(pps);
 > +	kfree(pps);

This reference counting looks dubious to me... later on in the code
you have:

 > +static int pps_cdev_open(struct inode *inode, struct file *file)
 > +{
 > +	struct pps_device *pps = container_of(inode->i_cdev,
 > +						struct pps_device, cdev);
 > +
 > +	/* Lock the PPS source against (possible) deregistration */
 > +	atomic_inc(&pps->usage);

with no locking, so I see no reason why the atomic_inc() couldn't
happen right after the wait_event() sees a count of 0 and lets the
deregistration continue.  Which would lead to use-after-free.

 - R.
