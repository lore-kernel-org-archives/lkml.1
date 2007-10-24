Return-Path: <linux-kernel-owner+w=401wt.eu-S1757363AbXJXG6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363AbXJXG6R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 02:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756246AbXJXG6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 02:58:07 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:46717 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756211AbXJXG6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 02:58:06 -0400
Date: Wed, 24 Oct 2007 09:00:31 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>
Message-ID: <20071024070030.GR9748@enneenne.com>
References: <20071023180417.GM9748@enneenne.com> <20071023201750.GE7793@redhat.com> <20071023205459.GP9748@enneenne.com> <adasl414jzw.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adasl414jzw.fsf@cisco.com>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.16 (2007-06-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH] LinuxPPS - PPS support for Linux
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2007 at 02:08:19PM -0700, Roland Dreier wrote:
> A few comments:
> 
>  > +		dev_err(port->dev, "PPS support disabled due port \"%s\" is "
>  > +					"in polling mode\n",
> 
> I think "because" instead of "due" is closer to standard English.

Fixed.

>  > +		printk(KERN_ERR "pps: %s: too much PPS sources in the system\n",
>  > +					info->name);
> 
> Similarly should be "many" instead of "much".

Fixed.

>  > +	/* Get new ID for the new PPS source */
>  > +	if (idr_pre_get(&pps_idr, GFP_KERNEL) == 0) {
>  > +		err = -ENOMEM;
>  > +		goto kfree_pps;
>  > +	}
>  > +
>  > +	spin_lock_irq(&idr_lock);
>  > +	err = idr_get_new(&pps_idr, pps, &id);
>  > +	spin_unlock_irq(&idr_lock);
>  > +
>  > +	if (err < 0)
>  > +		goto kfree_pps;
> 
> You usually can handle idr_get_new() returning -EAGAIN by jumping back
> to the idr_pre_get(), to handle someone else coming in and stealing
> the memory you just preallocated.  In this case it may not matter
> since it's pretty unlikely that a lot of contexts are using the idr at
> the same time.  But anyway...

I don't understand what you mean. Can you please submit an example
code?

>  > +void pps_unregister_source(int source)
>  > ...
>  > +	wait_event(pps->usage_queue, atomic_read(&pps->usage) == 0);
>  > +
>  > +	pps_sysfs_remove_source_entry(pps);
>  > +	pps_unregister_cdev(pps);
>  > +	kfree(pps);
> 
> This reference counting looks dubious to me... later on in the code
> you have:
> 
>  > +static int pps_cdev_open(struct inode *inode, struct file *file)
>  > +{
>  > +	struct pps_device *pps = container_of(inode->i_cdev,
>  > +						struct pps_device, cdev);
>  > +
>  > +	/* Lock the PPS source against (possible) deregistration */
>  > +	atomic_inc(&pps->usage);
> 
> with no locking, so I see no reason why the atomic_inc() couldn't
> happen right after the wait_event() sees a count of 0 and lets the
> deregistration continue.  Which would lead to use-after-free.

Mmm... you are right... can you please suggest to me how can I easily
fix this problem?

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
