Return-Path: <linux-kernel-owner+w=401wt.eu-S1755366AbXD0GJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366AbXD0GJP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 02:09:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755372AbXD0GJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 02:09:15 -0400
Received: from mx2.go2.pl ([193.17.41.42]:42277 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755367AbXD0GJO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 02:09:14 -0400
Date: Fri, 27 Apr 2007 08:15:06 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, David Miller <davem@davemloft.net>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cancel_delayed_work: use del_timer() instead of del_timer_sync()
Message-ID: <20070427061506.GC997@ff.dom.local>
References: <20070424215034.GA5985@tv-sign.ru> <20070425130246.GA4086@ff.dom.local> <20070425125214.GB94@tv-sign.ru> <20070426142921.GE3145@ff.dom.local> <20070426152953.GA1824@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070426152953.GA1824@tv-sign.ru>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2007 at 07:29:53PM +0400, Oleg Nesterov wrote:
> On 04/26, Jarek Poplawski wrote:
...
> > > This change should not make any visible difference for the callers,
> > > otherwise it is buggy.
> > 
> > IMHO, there is the same visible difference,
> > as between del_timer and del_timer_sync.
> 
> Jarek, please, could you be more explicite ? del_timer() and
> del_timer_sync() are different in many ways. What exactly will
> impact the user of cancel_delaye_work ?

OK, I changed my mind. Now, I think it's very probable
this should matter...

According to workqueue.h:
> /*
>  * Kill off a pending schedule_delayed_work().  Note that the work callback
>  * function may still be running on return from cancel_delayed_work().  Run
>  * flush_workqueue() or cancel_work_sync() to wait on it.
>  */
> static inline int cancel_delayed_work(struct delayed_work *work)

So, we can do something like this:

cancel_delayed_work(dwork);
flush_workqueue(wq);
kfree(some_obj_used_by_dwork_func);

And this is enough to work with not rearming work.

But no more after this patch...

So, I think, your proposal should be alternative version,
and current version should stay, so we have a choice.
Just like del_timer and del_timer_sync.

Jarek P.
