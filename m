Return-Path: <linux-kernel-owner+w=401wt.eu-S1754300AbXEGKY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300AbXEGKY5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 06:24:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754307AbXEGKY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 06:24:57 -0400
Received: from mx2.go2.pl ([193.17.41.42]:42985 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754300AbXEGKY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 06:24:56 -0400
Date: Mon, 7 May 2007 12:31:08 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Chinner <dgc@sgi.com>,
       David Howells <dhowells@redhat.com>, Gautham Shenoy <ego@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] make-cancel_rearming_delayed_work-reliable-fix
Message-ID: <20070507103107.GD1754@ff.dom.local>
References: <20070503204226.GA212@tv-sign.ru> <20070503181513.0b0aa4fb.akpm@linux-foundation.org> <20070505213213.GA1013@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070505213213.GA1013@tv-sign.ru>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 06, 2007 at 01:32:13AM +0400, Oleg Nesterov wrote:
> on top of
> 	make-cancel_rearming_delayed_work-reliable-spelling.patch
> 
> Add cpu-relax() into spinloops, and a comments update.
> 
> Small note. The new implementation has another downside. Suppose that rearming
> work->func() gets a preemtion after setting WORK_STRUCT_PENDING but before
> add_timer/__queue_work. In that case cancel_rearming_delayed_work() will burn
> CPU in a busy-wait loop. Fortunately this can happen only with CONFIG_PREEMPT
> and we spin with preemption enabled.
> 
> We can avoid this,
> 
> 	void cancel_rearming_delayed_work(struct delayed_work *dwork)
> 	{
> 		int retry;
> 
> 		do {
> 			retry = !del_timer(&dwork->timer) &&
> 				!try_to_grab_pending(&dwork->work);
> 			wait_on_work(&dwork->work);
> 		} while (retry);
> 
> 		work_clear_pending(&dwork->work);
> 	}
> 
> but I don't think this is worth fixing.

I think so.

There is a lot of new things in the final version of this
patch. I guess, there was no such problem in the previous
version.

I can also see you have new doubts about usefulness, which
I cannot understand:
- even if there are some slowdowns, where does it matter?
- the "old" method uses only one method of cancelling, i.e.
del_timer, not trying to stop requeuing or to remove from
the queue; it seems to be effective only with long delayed
timers, and its real problems are probably mostly invisible.

BTW, I'm still not convinced all additions are needed:
the "old" cancel_rearming_  doesn't care about checking
or waiting on anything after del_timer positive.

Regards,
Jarek P.

PS: I'll try to check this all in the evening and will
write tomorrow, if found something interesting.
