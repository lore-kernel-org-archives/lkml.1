Return-Path: <linux-kernel-owner+w=401wt.eu-S1751372AbXB1DHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751372AbXB1DHW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 22:07:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751360AbXB1DHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 22:07:22 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:58414 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbXB1DHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 22:07:20 -0500
Date: Wed, 28 Feb 2007 08:37:26 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Pavel Machek <pavel@ucw.cz>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Problem with freezable workqueues
Message-ID: <20070228030726.GK29179@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <200702272251.28844.rjw@sisk.pl> <20070227232855.GA457@tv-sign.ru> <200702280057.36198.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702280057.36198.rjw@sisk.pl>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 28, 2007 at 12:57:35AM +0100, Rafael J. Wysocki wrote:
> > How about other kthread_stop()s ? For example, kernel/softirq.c:cpu_callback() ?
> 
> They all are PF_NOFREEZE, I suppose.  If we make all workqueues nonfreezable
> (as they were before), the problem won't appear.

We can just thaw the worker thread selectively before kthread_stopping
them. This will let us freeze all worker threads (which we want to for
hotplug anyway).

> > I think we need a general "cpu_down() after freeze" implementation, this is what
> > Gautham and Srivatsa are working on, right?
> 
> Yes, certainly.

Hmm ..good point. So can we assume that disable/enable_nonboot_cpus() are called
with processes frozen already?

Gautham, you need to take this into account in your patchset!

> > I'm afraid this is racy. We can't touch *cwq, it may be freed. Suppose
> > that another thread does destroy_workqueue(), and we thaw that thread
> > before cwq->thread.
> 
> Okay, in that case I'd suggest removing create_freezeable_workqueue() and
> make all workqueues nonfreezable once again for 2.6.21 (as far as I know, only
> the two XFS workqueues are affected).

See above suggestion of thawing worker thread before kthread_stopping
it.

-- 
Regards,
vatsa
