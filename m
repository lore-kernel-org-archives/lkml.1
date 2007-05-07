Return-Path: <linux-kernel-owner+w=401wt.eu-S933045AbXEGL2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933045AbXEGL2t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 07:28:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933120AbXEGL2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 07:28:48 -0400
Received: from mail.screens.ru ([213.234.233.54]:43102 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933045AbXEGL2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 07:28:48 -0400
Date: Mon, 7 May 2007 14:34:20 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Chinner <dgc@sgi.com>,
       David Howells <dhowells@redhat.com>, Gautham Shenoy <ego@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] make-cancel_rearming_delayed_work-reliable-fix
Message-ID: <20070507103420.GA74@tv-sign.ru>
References: <20070503204226.GA212@tv-sign.ru> <20070503181513.0b0aa4fb.akpm@linux-foundation.org> <20070505213213.GA1013@tv-sign.ru> <20070507103107.GD1754@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070507103107.GD1754@ff.dom.local>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07, Jarek Poplawski wrote:
>
> There is a lot of new things in the final version of this
> patch. I guess, there was no such problem in the previous
> version.

No, this is basically the same patch + re-check-cwq-after-lock,
the latter is mostly needed to prevent racing with CPU-hotplug.

> I can also see you have new doubts about usefulness, which
> I cannot understand:
> - even if there are some slowdowns, where does it matter?
> - the "old" method uses only one method of cancelling, i.e.
> del_timer, not trying to stop requeuing or to remove from
> the queue; it seems to be effective only with long delayed
> timers, and its real problems are probably mostly invisible.

The slowdown is small, changelog mentions it just to be "fair".

I am not happy with the complication this patch adds, mostly
I hate this smb_wmb() in insert_work(). I have an idea how to
remove it later, but this needs another patch not related to
workqueue.c.

> BTW, I'm still not convinced all additions are needed:
> the "old" cancel_rearming_  doesn't care about checking
> or waiting on anything after del_timer positive.

It would be very strange to do wait_on_work() only in case
when del_timer() failed. This way we still need to do
cancel_work_sync() after cancel_rearming_delayed_work(),
but only when del_timer() failed, ugly. Note also that
wait_on_work() does not sleep if work->func() is not running.

Also, consider this callback:

	void work_handler(struct work_struct *w)
	{
		struct delayed_work dw = container_of(...);

		queue_delayed_work(dw, delay);

		// <------------- cancel_rearming_delayed_work()

		cancel_delayed_work(dw);
		queue_delayed_work(dw, another_delay);
	}

Yes, this is strange and ugly. But correct! The current version
(before this patch) can't cancel this delayed_work. The new
implementation works correctly. So I think it is far better to
do wait_on_work() unconditionally.

> PS: I'll try to check this all in the evening and will
> write tomorrow, if found something interesting.

Yes, please!

Oleg.

