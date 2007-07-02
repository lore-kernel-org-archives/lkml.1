Return-Path: <linux-kernel-owner+w=401wt.eu-S1758511AbXGBMOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758511AbXGBMOp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 08:14:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753447AbXGBMOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 08:14:36 -0400
Received: from mail.screens.ru ([213.234.233.54]:59539 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752880AbXGBMOf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 08:14:35 -0400
Date: Mon, 2 Jul 2007 16:14:47 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] rename cancel_rearming_delayed_work() to cancel_delayed_work_sync()
Message-ID: <20070702121447.GA261@tv-sign.ru>
References: <20070701153629.GA105@tv-sign.ru> <20070702114541.GE1639@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070702114541.GE1639@ff.dom.local>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02, Jarek Poplawski wrote:
>
> On Sun, Jul 01, 2007 at 07:36:29PM +0400, Oleg Nesterov wrote:
> > Imho, the current naming of cancel_xxx workqueue functions is very confusing.
> > 
> > 	cancel_delayed_work()
> > 	cancel_rearming_delayed_work()
> > 	cancel_rearming_delayed_workqueue()	// obsolete
> > 
> > 	cancel_work_sync()
> > 
> > This looks as if the first 2 functions differ in "type" of their argument which
> > is not true any longer, nowadays the difference is the behaviour.
> > 
> > The semantics of cancel_rearming_delayed_work(dwork) was changed significantly,
> > it doesn't require that dwork rearms itself, and cancels dwork synchronously.
> > 
> > Rename it to cancel_delayed_work_sync(). This matches cancel_delayed_work() and
> > cancel_work_sync(). Re-create cancel_rearming_delayed_work() as a simple inline
> > obsolete wrapper, like cancel_rearming_delayed_workqueue().
> 
> I like the idea of this change, but have some doubt: "_sync"
> usually suggests the main difference from "" (or _nosync) is:
> _sync waits for something, while _nosync doesn't wait and
> instantly returns.

Yes, but we already have cancel_work_sync().

> Here it's a bit complicated: cancel_delayed_work() (so nosync),
> actually can wait a little too (on del_timer_sync). And
> cancel_rearming_delayed_work() is really more universal now,
> but still the main difference is this should be used with works
> that rearm (at least sometimes). If there is no rearming - no
> reason for this function (of course not forbidden too)  - and
> maybe it better helps to remember the difference?

There is a reason even if no rearming. We have a lot of

	cancel_delayed_work();
	flush_workqueue();

This should be converted to use cancel_delayed_work_sync().

Note also that both cancel_work_sync() and cancel_rearming_delayed_work()
can be used on any work (rearming or not) and both imply "flush".
I think the "_rearming" part of the name is very confusing, and a "good"
name should be consistent with cancel_work_sync() and cancel_delayed_work()
which we already have.

Oleg.

