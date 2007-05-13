Return-Path: <linux-kernel-owner+w=401wt.eu-S1760877AbXEMUvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760877AbXEMUvT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 16:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760548AbXEMUux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 16:50:53 -0400
Received: from mail.screens.ru ([213.234.233.54]:58041 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760486AbXEMUuw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 16:50:52 -0400
Date: Mon, 14 May 2007 00:50:57 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Alex Dubov <oakad@yahoo.com>, Pierre Ossman <drzeus@drzeus.cx>
Subject: Re: 2.6.22-rc1: Broken suspend on SMP with tifm
Message-ID: <20070513205057.GA3171@tv-sign.ru>
References: <200705132132.08546.rjw@sisk.pl> <20070513200845.GA3078@tv-sign.ru> <20070513203039.GA3143@tv-sign.ru> <200705132250.26277.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705132250.26277.rjw@sisk.pl>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13, Rafael J. Wysocki wrote:
>
> On Sunday, 13 May 2007 22:30, Oleg Nesterov wrote:
> > > 
> > > > --- linux-2.6.22-rc1.orig/kernel/workqueue.c
> > > > +++ linux-2.6.22-rc1/kernel/workqueue.c
> > > > @@ -799,9 +799,7 @@ static int __devinit workqueue_cpu_callb
> > > >  	struct cpu_workqueue_struct *cwq;
> > > >  	struct workqueue_struct *wq;
> > > >  
> > > > -	action &= ~CPU_TASKS_FROZEN;
> > > > -
> > > > -	switch (action) {
> > > > +	switch (action & ~CPU_TASKS_FROZEN) {
> > > 
> > > Confused. How can we see, say CPU_UP_PREPARE_FROZEN, if we cleared
> > > CPU_TASKS_FROZEN bit?
> > 
> > So, unless I missed something stupid, this patch is not 100% right.
> 
> Well, it isn't, but for a different reason (see [*] below).

Yes, I missed something stupid :)

> > I think the better fix (at least for now) is
> > 
> > 	- #define create_freezeable_workqueue(name) __create_workqueue((name), 0, 1)
> > 	+ #define create_freezeable_workqueue(name) __create_workqueue((name), 1, 1)
> > 
> > Alex, do you really need a multithreaded wq?
> > 
> > Rafael, what do you think?
> 
> That would be misleading if the driver needs the threads to be frozen.

Hm? The thread will be frozen, the "patch" above changes "singlethread", not
"freezeable".

> [*] Getting back to the patch, it seems to me that we should do something like
> take_over_work() before thawing the frozen thread, because there may be a queue
> to process and the device is suspended at that point.

Yes, exactly because the driver wants this wq to be frozen.

So, could you take a second look at the "patch" above ?

Oleg.

