Return-Path: <linux-kernel-owner+w=401wt.eu-S1757997AbYC1D1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997AbYC1D1Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 23:27:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752331AbYC1D1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 23:27:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36909 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751800AbYC1D1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 23:27:16 -0400
Date: Thu, 27 Mar 2008 20:25:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org, davej@redhat.com,
       sam@ravnborg.org, greg@kroah.com, randy.dunlap@oracle.com
Subject: Re: [PATCH 1/7] LinuxPPS core support.
Message-Id: <20080327202531.a924e5d9.akpm@linux-foundation.org>
In-Reply-To: <20080325144400.GG8959@enneenne.com>
References: <12048053463198-git-send-email-giometti@linux.it>
	<12048053473401-git-send-email-giometti@linux.it>
	<20080320130356.69ab65fe.akpm@linux-foundation.org>
	<20080325144400.GG8959@enneenne.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Mar 2008 15:44:00 +0100 Rodolfo Giometti <giometti@enneenne.com> wrote:

> > > +void pps_unregister_source(int source)
> > > +{
> > > +	struct pps_device *pps;
> > > +
> > > +	spin_lock_irq(&idr_lock);
> > > +	pps = idr_find(&pps_idr, source);
> > > +
> > > +	if (!pps) {
> > > +		spin_unlock_irq(&idr_lock);
> > > +		return;
> > > +	}
> > > +
> > > +	/* This should be done first in order to deny IRQ handlers
> > > +	 * to access PPS structs
> > > +	 */
> > > +
> > > +	idr_remove(&pps_idr, pps->id);
> > > +	spin_unlock_irq(&idr_lock);
> > > +
> > > +	wait_event(pps->usage_queue, atomic_read(&pps->usage) == 0);
> > > +
> > > +	pps_sysfs_remove_source_entry(pps);
> > > +	pps_unregister_cdev(pps);
> > > +	kfree(pps);
> > > +}
> > > +EXPORT_SYMBOL(pps_unregister_source);
> > 
> > The wait_event() stuff really shouldn't be here: it should be integral to
> > the refcounting:
> > 
> > void pps_dev_put(struct pps_device *pps)
> > {
> > 	spin_lock_irq(&pps_lock);
> > 	if (atomic_dec_and_test(&pps->usage))
> > 		idr_remove(&pps_idr, pps->id);
> > 	else
> > 		pps = NULL;
> > 	spin_unlock_irq(&pps_lock);
> > 	if (pps) {
> > 		/*
> > 		 * Might need to do the below via schedule_work() if
> > 		 * pps_dev_put() is to be callable from atomic context
> > 		 */
> > 		pps_sysfs_remove_source_entry(pps);
> > 		pps_unregister_cdev(pps);
> > 		kfree(pps);
> > 	}
> > }
> 
> I don't understand where I should use this function... :'(

This is boilerplate standard linux kernel reference counting.

> > 
> > As it stands, there might be deadlocks such as when a process which itself
> > holds a ref on the pps_device (with an open fd?) calls
> > pps_unregister_source.
> 
> I can add a wait_event_interruptible in order to allow userland to
> continue by receiving a signal. It could be acceptable?

There should be no need to "wait" for anything.  When the final reference
to an object is released, that object is cleaned up.  Just like we do for
inodes, dentries, pages, files, and 100 other kernel objects.

The need to wait for something else to go away is a big red flag with
"busted refcounting" written on it.

> > Also, we need to take care that all processes which were waiting in
> > pps_unregister_source() get to finish their cleanup before we permit rmmod
> > to proceed.  Is that handled somewhere?
> 
> I don't understand the problem... this code as been added in order to
> avoid the case where a pps_event() is called while a process executes
> the pps_unregister_source(). If more processes try to execute this
> code the first which enters will execute idr_remove() which prevents
> another process to reach the wait_event()... is that wrong? =:-o

I was asking you!

We should get the reference counting and object lifetimes sorted out first. 
There should be no "wait for <object> to be released" code.  Once that is
in place, things like rmmod will also sort themselves out: it just won't be
possible to remove the module while there are live references to objects.


