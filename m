Return-Path: <linux-kernel-owner+w=401wt.eu-S1757143AbYFNN6D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757143AbYFNN6D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 09:58:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754291AbYFNN5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 09:57:51 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:60146 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754246AbYFNN5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 09:57:50 -0400
Date: Sat, 14 Jun 2008 17:59:51 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jarek Poplawski <jarkao2@o2.pl>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] workqueues: implement flush_work()
Message-ID: <20080614135951.GA4502@tv-sign.ru>
References: <20080613142801.GA9165@tv-sign.ru> <20080614091339.GA2466@ami.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080614091339.GA2466@ami.dom.local>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14, Jarek Poplawski wrote:
>
> On Fri, Jun 13, 2008 at 06:28:01PM +0400, Oleg Nesterov wrote:
> > (on top of [PATCH] workqueues: insert_work: use "list_head *" instead of "int tail"
> >  http://marc.info/?l=linux-kernel&m=121328944230175)
> > 
> > Most of users of flush_workqueue() can be changed to use cancel_work_sync(),
> > but sometimes we really need to wait for the completion and cancelling is not
> > an option. schedule_on_each_cpu() is good example.
> > 
> > Add the new helper, flush_work(work), which waits for the completion of the
> > specific work_struct.
> 
> This all looks right and better than current flush_, but... the main
> problem is that probably in 90% cases cancel_ + self-running a work
> function (if cancelled) should be both more efficient and safer wrt
> locking (what you convince me to, BTW).

Yes, in most cases cancel_ is enough. And it is safer, note the limitations
of flush_work(). Basically, flush_work(work) should be used when this
work_struct can be queued only once.

> Another question is if schedule_on_each_cpu() is really such a good
> example here: it seems these "xxx && yyy" examples could be faster,
> but I've lost track of this earlier thread.

schedule_on_each_cpu() can't use cancel_ + ->func(), the code should
be executed on the remote CPU.

And note that flush_work() doesn't iterate over all CPUs, this is the
reason why it is limited, but this also means it is faster than
flush_work_sync() == flush_work() + wait_on_work().

> BTW, flush_work() probably needs a lockdep annotation similar to
> flush_workqueue().

Yes I know... but I'd prefer to send another patch, I'm a bit paranoid
when it comes to copy-and-pasting the code.

> Otherwise this all looks OK to me.

Thanks for review!

Oleg.

