Return-Path: <linux-kernel-owner+w=401wt.eu-S1755289AbXJYIgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289AbXJYIgy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 04:36:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752876AbXJYIgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 04:36:45 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:57690 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315AbXJYIgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 04:36:44 -0400
Date: Thu, 25 Oct 2007 10:39:16 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>
Message-ID: <20071025083916.GT9748@enneenne.com>
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

Since pps_unregister_source() is defined as:

void pps_unregister_source(int source)
{
        struct pps_device *pps;

        spin_lock_irq(&idr_lock);
        pps = idr_find(&pps_idr, source);

        if (!pps) {
                spin_unlock_irq(&idr_lock);
                return;
        }

        /* This should be done first in order to deny IRQ handlers
         * to access PPS structs
         */

        idr_remove(&pps_idr, pps->id);
        spin_unlock_irq(&idr_lock);

        wait_event(pps->usage_queue, atomic_read(&pps->usage) == 0);

        pps_sysfs_remove_source_entry(pps);
        pps_unregister_cdev(pps);
        kfree(pps);
}

changing pps_cdev_open() as follow should resolve this problem:

static int pps_cdev_open(struct inode *inode, struct file *file)
{
        struct pps_device *pps = container_of(inode->i_cdev,
                                                struct pps_device, cdev);
        int found;

        spin_lock_irq(&idr_lock);
        found = idr_find(&pps_idr, pps->id) != NULL;

        /* Lock the PPS source against (possible) deregistration */
        if (found)
                atomic_inc(&pps->usage);

        spin_unlock_irq(&idr_lock);

        if (!found)
                return -ENODEV;

        file->private_data = pps;

        return 0;
}

Is that right?

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
