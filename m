Return-Path: <linux-kernel-owner+w=401wt.eu-S1752791AbXCOKZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791AbXCOKZr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 06:25:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752804AbXCOKZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 06:25:47 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:42197 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791AbXCOKZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 06:25:46 -0400
Date: Thu, 15 Mar 2007 11:27:25 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Oliver Neukum <oneukum@suse.de>, Maneesh Soni <maneesh@in.ibm.com>,
       <gregkh@suse.de>, Richard Purdie <rpurdie@rpsys.net>,
       James Bottomley <James.Bottomley@SteelEye.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc suspend regression: sysfs deadlock
Message-ID: <20070315112725.7eadb7b7@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <Pine.LNX.4.44L0.0703141516150.7723-100000@iolanthe.rowland.org>
References: <20070314194337.5d439dab@gondolin.boeblingen.de.ibm.com>
	<Pine.LNX.4.44L0.0703141516150.7723-100000@iolanthe.rowland.org>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.8.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Mar 2007 15:23:10 -0400 (EDT),
Alan Stern <stern@rowland.harvard.edu> wrote:

> > > +struct other_task_struct {
> > > +	struct kobject 		*kobj;
> > > +	void			(*func)(void *);
> > > +	void			*data;
> > > +	struct work_struct	work;
> > > +};
> > > +
> > > +static void other_task_work(struct work_struct *work)
> > > +{
> > > +	struct other_task_struct *ots = container_of(work,
> > > +			struct other_task_struct, work);
> > > +
> > > +	(ots->func)(ots->data);
> > > +	kobject_put(ots->kobj);
> > > +	kfree(ots);
> > > +}
> > 
> > The naming seems a bit unintuitive, but I don't have a good
> > alternative idea. Perhaps sysfs_work_struct, sysfs_delayed_work()?
> 
> sysfs_work_struct is too generic; other parts of sysfs might also want to
> use workqueues for different purposes.

> I don't like calling it "delayed"-anything, because the operations aren't
> necessarily delayed!  On an SMP system they might even execute before the
> sysfs_access_in_other_task() call returns.  (Although the two examples we
> have so far can't do that because of lock contention.)

Sure. But then you shouldn't refer to "delay" in the comments for the
functions as well :)

> The major feature added here is that the work takes place in a different 
> task's context, not that it is delayed.  Hence the choice of names.

Hm. Perhaps device_schedule_access()?
