Return-Path: <linux-kernel-owner+w=401wt.eu-S1756015AbXIYOYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015AbXIYOYT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 10:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753347AbXIYOYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 10:24:05 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:35524 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753155AbXIYOYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 10:24:04 -0400
Date: Tue, 25 Sep 2007 10:24:03 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tejun Heo <htejun@gmail.com>
cc: Jonathan Corbet <corbet@lwn.net>, <ebiederm@xmission.com>,
       <cornelia.huck@de.ibm.com>, <greg@kroah.com>, <kay.sievers@vrfy.org>,
       <linux-kernel@vger.kernel.org>, <rusty@rustcorp.com.au>
Subject: Re: [PATCH 1/4] module: implement module_inhibit_unload()
In-Reply-To: <46F845B2.7030002@gmail.com>
Message-ID: <Pine.LNX.4.44L0.0709251019510.3909-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Sep 2007, Tejun Heo wrote:

> Jonathan Corbet wrote:
> > Hi, Tejun,
> > 
> > I was just looking over these changes...
> > 
> >> +	/* Don't proceed till inhibition is lifted. */
> >> +	add_wait_queue(&module_unload_wait, &wait);
> >> +	set_current_state(TASK_UNINTERRUPTIBLE);
> >> +	if (atomic_read(&module_unload_inhibit_cnt))
> >> +		schedule();
> >> +	__set_current_state(TASK_RUNNING);
> >> +	remove_wait_queue(&module_unload_wait, &wait);
> >> +
> >> +	mutex_lock(&module_mutex);
> > 
> > Maybe I'm missing something, but this looks racy to me.  There's no
> > check after schedule() to see if module_unload_inhibit_cnt is really
> > zero, and nothing to keep somebody else from slipping in and raising it
> > again afterward.
> 
> The unloading can proceed once module_unload_inhibit_cnt reaches zero.
> An unloading thread only has to care about inhibition put in effect
> before unloading has started, so there's no need to check again.

You haven't fully answered Jon's question.  Suppose
module_unload_inhibit_cnt is nonzero, so the task adds itself to the
module_unload_wait queue, changes to TASK_UNINTERRUPTIBLE, and calls
schedule.  There's nothing to prevent somebody else from waking the
task back up before the original inhibition has been lifted.

Alan Stern

