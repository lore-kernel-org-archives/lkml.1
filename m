Return-Path: <linux-kernel-owner+w=401wt.eu-S1752444AbXCNTXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444AbXCNTXN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 15:23:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752788AbXCNTXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 15:23:12 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:50401 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752444AbXCNTXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 15:23:12 -0400
Date: Wed, 14 Mar 2007 15:23:10 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Cornelia Huck <cornelia.huck@de.ibm.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Oliver Neukum <oneukum@suse.de>, Maneesh Soni <maneesh@in.ibm.com>,
       <gregkh@suse.de>, Richard Purdie <rpurdie@rpsys.net>,
       James Bottomley <James.Bottomley@SteelEye.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc suspend regression: sysfs deadlock
In-Reply-To: <20070314194337.5d439dab@gondolin.boeblingen.de.ibm.com>
Message-ID: <Pine.LNX.4.44L0.0703141516150.7723-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Mar 2007, Cornelia Huck wrote:

> On Wed, 14 Mar 2007 12:12:37 -0400 (EDT),
> Alan Stern <stern@rowland.harvard.edu> wrote:
> 
> > This seems more elegant (not yet tested).  Cornelia, does it look okay to 
> > you?
> 
> Works for me (grouping & ungrouping ctc) and looks sane. Some more
> comments below.

Thank you.

> > +struct other_task_struct {
> > +	struct kobject 		*kobj;
> > +	void			(*func)(void *);
> > +	void			*data;
> > +	struct work_struct	work;
> > +};
> > +
> > +static void other_task_work(struct work_struct *work)
> > +{
> > +	struct other_task_struct *ots = container_of(work,
> > +			struct other_task_struct, work);
> > +
> > +	(ots->func)(ots->data);
> > +	kobject_put(ots->kobj);
> > +	kfree(ots);
> > +}
> 
> The naming seems a bit unintuitive, but I don't have a good
> alternative idea. Perhaps sysfs_work_struct, sysfs_delayed_work()?

sysfs_work_struct is too generic; other parts of sysfs might also want to
use workqueues for different purposes.

I don't like calling it "delayed"-anything, because the operations aren't
necessarily delayed!  On an SMP system they might even execute before the
sysfs_access_in_other_task() call returns.  (Although the two examples we
have so far can't do that because of lock contention.)

The major feature added here is that the work takes place in a different 
task's context, not that it is delayed.  Hence the choice of names.

Alan Stern

