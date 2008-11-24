Return-Path: <linux-kernel-owner+w=401wt.eu-S1759223AbYLDAzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759223AbYLDAzv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 19:55:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757006AbYLDAxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 19:53:34 -0500
Received: from mx1.redhat.com ([66.187.233.31]:37241 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758090AbYLDAxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 19:53:32 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       rnalumasu@gmail.com
Subject: Re: + do_wait-wakeup-optimization.patch added to -mm tree
In-Reply-To: Oleg Nesterov's message of  Sunday, 23 November 2008 22:39:29 +0100 <20081123213929.GA9097@redhat.com>
References: <200811212015.mALKFMs4019558@imap1.linux-foundation.org>
	<20081123213929.GA9097@redhat.com>
X-Shopping-List: (1) Rhythmic compulsion departures
   (2) Logical battalions
   (3) Consistent missing intrusions
   (4) Injudicious sugar
Message-Id: <20081204005203.C795EFC3AB@magilla.sf.frob.com>
Date: Sun, 23 Nov 2008 23:26:01 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Let's suppose the ptracer finds the EXIT_ZOMBIE tracee and notifies its
> ->real_parent which sleeps in do_wait(). In that case the usage of
> eligible_child(task == ptracer) above is bogus, and checking for
> group_leader is not rifgt too.

I had overlooked that do_notify_parent() call.

> > +static int do_wait_wake_function(wait_queue_t *curr, unsigned mode, int sync,
> > +				 void *key)
> > +{
> > +	struct task_struct *task = current;
> 
> I think we can fix (and simplify) this code if we change __wake_up_parent(),
> it should call __wake_up(key => p), so we can do
> 
> 	struct task_struct *task = key;

I had not looked into the bowels of various __wake_up variants, just
assumed it would stay as it is and use wake_up_interruptible_sync.

That would certainly be cleaner.  Then do_wait_wake_function would not need
the second of its special cases, only the one double-check for the
thread_group_leader && task_detached case.

I don't see an exposed __wake_up* variant that both passes a "key" pointer
through and does "sync".  For __wake_up_parent, "sync" is quite desireable.

> > +	if (!needs_wakeup(task, w))
> > +		return 0;
> > +
> > +	return default_wake_function(curr, mode, sync, key);
> 
> perhaps autoremove_wake_function() makes more sense.

Why?  The do_wait loop will have to go through again and still might just
sleep again.  The explicit remove at the end of do_wait seems fine to me.


Thanks,
Roland
