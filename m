Return-Path: <linux-kernel-owner+w=401wt.eu-S1752316AbXDWUDI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316AbXDWUDI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 16:03:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751727AbXDWUCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 16:02:35 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34424 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751707AbXDWUCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 16:02:34 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC][PATCH -mm 3/3] freezer: Fix problem with kthread_stop
Date: Mon, 23 Apr 2007 21:50:30 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       ego@in.ibm.com, Oleg Nesterov <oleg@tv-sign.ru>,
       linux-kernel@vger.kernel.org, vatsa@in.ibm.com, paulmck@us.ibm.com
References: <20070419120131.GB13435@in.ibm.com> <200704222141.00680.rjw@sisk.pl> <20070423104024.GB5635@elf.ucw.cz>
In-Reply-To: <20070423104024.GB5635@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704232150.31310.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday, 23 April 2007 12:40, Pavel Machek wrote:
> Hi!
> 
> > Fix the problem with kthread_stop() that causes the freezer to fail if a
> > freezable thread is attempting to stop a frozen one and that may cause the
> > freezer to fail if the thread being stopped is freezable and
> > try_to_freeze_tasks() is running concurrently with kthread_stop().
> 
> Parse error.

OK, will fix.

> > Index: linux-2.6.21-rc6-mm1/kernel/kthread.c
> > ===================================================================
> > --- linux-2.6.21-rc6-mm1.orig/kernel/kthread.c	2007-04-09 15:23:48.000000000 +0200
> > +++ linux-2.6.21-rc6-mm1/kernel/kthread.c	2007-04-22 19:05:29.000000000 +0200
> > @@ -232,6 +233,14 @@ int kthread_stop(struct task_struct *k)
> >  
> >  	/* Now set kthread_should_stop() to true, and wake it up. */
> >  	kthread_stop_info.k = k;
> > +	if (!freezer_should_exempt(current)) {
> > +		/* We are freezable, so we must make sure that the thread being
> > +		 * stopped is not frozen and will not be frozen until it dies
> > +		 */
> > +		freezer_exempt(k);
> > +		if (frozen(k))
> > +			clear_frozen_flag(k);
> > +	}
> >  	wake_up_process(k);
> >  	put_task_struct(k);
> >  
> 
> Do we need to take some locks to access other process' flags? Or do
> frozen_exempt() etc take enough locks, already?

After the previous patch we only use set_bit(), clear_bit() and test_bit() to
access freezer_falgs, so no special locking is needed to protect them.

Greetings,
Rafael
