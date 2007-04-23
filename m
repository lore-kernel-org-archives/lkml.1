Return-Path: <linux-kernel-owner+w=401wt.eu-S1752145AbXDWUDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145AbXDWUDt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 16:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752016AbXDWUDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 16:03:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34427 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751696AbXDWUCf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 16:02:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [RFC][PATCH -mm 3/3] freezer: Fix problem with kthread_stop
Date: Mon, 23 Apr 2007 22:05:15 +0200
User-Agent: KMail/1.9.5
Cc: Gautham R Shenoy <ego@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, vatsa@in.ibm.com, paulmck@us.ibm.com,
       pavel@ucw.cz
References: <20070419120131.GB13435@in.ibm.com> <20070423123558.GC25144@in.ibm.com> <20070423190340.GA283@tv-sign.ru>
In-Reply-To: <20070423190340.GA283@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704232205.16208.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 23 April 2007 21:03, Oleg Nesterov wrote:
> On 04/23, Gautham R Shenoy wrote:
> >
> > On Sun, Apr 22, 2007 at 09:40:59PM +0200, Rafael J. Wysocki wrote:
> > >  /*
> > > @@ -232,6 +233,14 @@ int kthread_stop(struct task_struct *k)
> > > 
> > >  	/* Now set kthread_should_stop() to true, and wake it up. */
> > >  	kthread_stop_info.k = k;
> > > +	if (!freezer_should_exempt(current)) {
> > > +		/* We are freezable, so we must make sure that the thread being
> > > +		 * stopped is not frozen and will not be frozen until it dies
> > > +		 */
> > > +		freezer_exempt(k);
> > > +		if (frozen(k))
> > > +			clear_frozen_flag(k);
> > > +	}
> > 
> > I'm trying hard to convince myself that this will work. May be I am
> > missing something here, but I find a potential race window (very small though) 
> > when k is entering the refrigerator.
> > 
> > [... snip ... ]
> > 
> > IMO, we need the to take the task_lock for k here. Something like
> > 
> > > +	if (!freezer_should_exempt(current)) {
> > 		task_lock(k);
> > > +		/* We are freezable, so we must make sure that the thread being
> > > +		 * stopped is not frozen and will not be frozen until it dies
> > > +		 */
> > > +		freezer_exempt(k);
> > > +		if (frozen(k))
> > > +			clear_frozen_flag(k);
> > 		task_unlock(k);
> > > +	}
> 
> Well, probably I missed something, but why can't we do
> 
> 	if (!freezer_should_exempt(current)) {
> 		freezer_exempt(k);
> 		thaw_process(k);
> 	}
> ?
> 
> thaw_process(k) is properly serialized with refrigerator(), and it checks
> frozen(k). We can make an extra wake_up, but this should not matter.

Yes, I think you're right.

> Rafael, please check the recent changes in kthread.c, kthread_stop() was
> reworked, we don't have kthread_stop_info any longer.

OK, I will, thanks.

Greetings,
Rafael
