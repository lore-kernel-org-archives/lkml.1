Return-Path: <linux-kernel-owner+w=401wt.eu-S1757198AbXGBNgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198AbXGBNgs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 09:36:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752880AbXGBNgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 09:36:41 -0400
Received: from mx12.go2.pl ([193.17.41.142]:57931 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751817AbXGBNgk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 09:36:40 -0400
Date: Mon, 2 Jul 2007 15:45:02 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] rename cancel_rearming_delayed_work() to cancel_delayed_work_sync()
Message-ID: <20070702134502.GF1639@ff.dom.local>
References: <20070701153629.GA105@tv-sign.ru> <20070702114541.GE1639@ff.dom.local> <20070702121447.GA261@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070702121447.GA261@tv-sign.ru>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 02, 2007 at 04:14:47PM +0400, Oleg Nesterov wrote:
> On 07/02, Jarek Poplawski wrote:
> >
> > On Sun, Jul 01, 2007 at 07:36:29PM +0400, Oleg Nesterov wrote:
> > > Imho, the current naming of cancel_xxx workqueue functions is very confusing.
> > > 
> > > 	cancel_delayed_work()
> > > 	cancel_rearming_delayed_work()
> > > 	cancel_rearming_delayed_workqueue()	// obsolete
> > > 
> > > 	cancel_work_sync()
> > > 
> > > This looks as if the first 2 functions differ in "type" of their argument which
> > > is not true any longer, nowadays the difference is the behaviour.
> > > 
> > > The semantics of cancel_rearming_delayed_work(dwork) was changed significantly,
> > > it doesn't require that dwork rearms itself, and cancels dwork synchronously.
> > > 
> > > Rename it to cancel_delayed_work_sync(). This matches cancel_delayed_work() and
> > > cancel_work_sync(). Re-create cancel_rearming_delayed_work() as a simple inline
> > > obsolete wrapper, like cancel_rearming_delayed_workqueue().
> > 
> > I like the idea of this change, but have some doubt: "_sync"
> > usually suggests the main difference from "" (or _nosync) is:
> > _sync waits for something, while _nosync doesn't wait and
> > instantly returns.
> 
> Yes, but we already have cancel_work_sync().

And it's OK because it actually can block. Some confusion
could appear (maybe to me only) if we would add cancel_work()
which would also ... block.

> 
> > Here it's a bit complicated: cancel_delayed_work() (so nosync),
> > actually can wait a little too (on del_timer_sync). And
> > cancel_rearming_delayed_work() is really more universal now,
> > but still the main difference is this should be used with works
> > that rearm (at least sometimes). If there is no rearming - no
> > reason for this function (of course not forbidden too)  - and
> > maybe it better helps to remember the difference?
> 
> There is a reason even if no rearming. We have a lot of
> 
> 	cancel_delayed_work();
> 	flush_workqueue();
> 
> This should be converted to use cancel_delayed_work_sync().
> 
> Note also that both cancel_work_sync() and cancel_rearming_delayed_work()
> can be used on any work (rearming or not) and both imply "flush".
> I think the "_rearming" part of the name is very confusing, and a "good"
> name should be consistent with cancel_work_sync() and cancel_delayed_work()
> which we already have.

I know, but I'm a little afraid of "overloading" the "_sync":
here it's kind of double sync (can block plus really finish
something). I wonder if this way is used elsewhere in linux.

But I see the more serious reason for it is: it's in your next
patches and we don't want to waste time. So, I'll try to check
this in the evening, and if nothing strange - I'll send acks
tomorrow (of course - not that I think they are needed...).

Thanks,
Jarek P.
