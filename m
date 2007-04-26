Return-Path: <linux-kernel-owner+w=401wt.eu-S1031041AbXDZOXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031041AbXDZOXc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 10:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031030AbXDZOXc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 10:23:32 -0400
Received: from mx12.go2.pl ([193.17.41.142]:33259 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1031041AbXDZOXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 10:23:31 -0400
Date: Thu, 26 Apr 2007 16:29:21 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, David Miller <davem@davemloft.net>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cancel_delayed_work: use del_timer() instead of del_timer_sync()
Message-ID: <20070426142921.GE3145@ff.dom.local>
References: <20070424215034.GA5985@tv-sign.ru> <20070425130246.GA4086@ff.dom.local> <20070425125214.GB94@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070425125214.GB94@tv-sign.ru>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2007 at 04:52:14PM +0400, Oleg Nesterov wrote:
> On 04/25, Jarek Poplawski wrote:
> >
> > On Wed, Apr 25, 2007 at 01:50:34AM +0400, Oleg Nesterov wrote:
> > > del_timer_sync() buys nothing for cancel_delayed_work(), but it is less
> > > efficient since it locks the timer unconditionally, and may wait for the
> > > completion of the delayed_work_timer_fn().
> > 
> > I'm not sure what is the main aim of this patch.
> 
> optimization
> 
> >                                                  It seems this
> > change cannot do any harm, but anyway it could change a few
> > things, e.g. with current version of cancel_rearming_delayed_work
> > some flush_workqueue could be done needlessly, before the work
> > is queued from timer.
> 
> I don't think so... Could you clarify?

With a code like:

if (!cancel_delayed_work(dwork))
	flush_workqueue(wq);
	
if cancel_ returns 0, and there is _queue_work in progress,
flush_ will be done once, after this work is queued.

After the patch, and the same situation flush_ also runs
one time, but maybe without the work in a queue.

So, if there is no more loops, there could be difference,
and even if very unprobable, something could stop working
after such change.

> 
> >                       It's not a big deal here, but if anybody
> > did something like this without loop - it could matter.
> > 
> > So, probably a lot of current code should be checked, before
> > applying and I doubt the gain is worth of this. Maybe, for
> > safety, make this with new name as an alternative and
> > deprecate the current version?
> 
> This change should not make any visible difference for the callers,
> otherwise it is buggy.

IMHO, there is the same visible difference,
as between del_timer and del_timer_sync.

Regards,
Jarek P.
