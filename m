Return-Path: <linux-kernel-owner+w=401wt.eu-S2993020AbXDTRIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993020AbXDTRIp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 13:08:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993021AbXDTRIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 13:08:45 -0400
Received: from mail.screens.ru ([213.234.233.54]:43209 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993020AbXDTRIo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 13:08:44 -0400
Date: Fri, 20 Apr 2007 21:08:36 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: Fw: [PATCH -mm] workqueue: debug possible endless loop in cancel_rearming_delayed_work
Message-ID: <20070420170836.GB470@tv-sign.ru>
References: <20070419002548.72689f0e.akpm@linux-foundation.org> <20070419102122.GA93@tv-sign.ru> <20070420092201.GC1695@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070420092201.GC1695@ff.dom.local>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20, Jarek Poplawski wrote:
>
> On Thu, Apr 19, 2007 at 02:21:22PM +0400, Oleg Nesterov wrote:
> ...
> > Yes. It would be better to use cancel_work_sync() instead of flush_workqueue()
> > to make this less possible (because cancel_work_sync() doesn't need to wait for
> > the whole ->worklist), but we can't.
> > 
> > > Maybe this patch could check, if I'm not dreaming...
> > 
> > Also: cancel_rearming_delayed_work() will hang if it (or cancel_delayed_work())
> > was already called.
> > 
> > I had some ideas how to make this interface reliable, but I can't see how to do
> > this without uglification of the current code.
> 
> For some time I thought about using a flag (isn't there
> one available after NOAUTOREL?), e.g. WORK_STRUCT_CANCEL,
> as a sign:
> 
> - for a workqueue code: that the work shouldn't be queued,
> nor executed, if possiblei, at first possible check.

Well, yes and no, afaics. (note also that NOAUTOREL has already gone).

First, this flag should be cleared after return from cancel_rearming_delayed_work().
Also, we should add a lot of nasty checks to workqueue.c

I _think_ we can re-use WORK_STRUCT_PENDING to improve this interface.
Note that if we set WORK_STRUCT_PENDING, the work can't be queued, and
dwork->timer can't be started. The only problem is that it is not so
trivial to avoid races.

I'll try to do something on Sunday.

> - for a work function: to stop execution as soon as possible,
> even without completing the usual job, at first possible check.

I doubt we need this "in general". It is easy to add some flag to the
work_struct's container and check it in work->func() when needed.

Oleg.

