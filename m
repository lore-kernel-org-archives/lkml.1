Return-Path: <linux-kernel-owner+w=401wt.eu-S1031080AbXHMNHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031080AbXHMNHf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 09:07:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969364AbXHMI0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 04:26:32 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:45662 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S969113AbXHMI01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 04:26:27 -0400
Date: Mon, 13 Aug 2007 12:26:15 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Michael Kerrisk <mtk-manpages@gmx.net>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [PATCH 3/4] signalfd: fix interaction with posix-timers
Message-ID: <20070813082615.GA90@tv-sign.ru>
References: <20070812170530.GA4302@tv-sign.ru> <20070812230350.A6F874D057D@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070812230350.A6F874D057D@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12, Roland McGrath wrote:
>
> This only affects signalfd and so the core change seems ok vs status quo.
> 
> I think it would be better overall not to have anyone like signalfd calling
> dequeue_signal in its current form at all.  (The function is too much an
> internal piece of the core signals code.  The SIGNAL_STOP_DEQUEUED code
> applying for signalfd calls is probably another problem, for example.)

I agree, the "tsk != current" case is not nice. We can forbid fetching
signals from another thread group and remove it, this is very easy.
Until then, we can't avoid it without the code duplication.

But SIGNAL_STOP_DEQUEUED code should be OK, afaics. We only need it to
make sure do_signal_stop() can't miss SIGNAL_STOP_CONTINUED/GROUP_EXIT.

Can't we remove SIGNAL_STOP_DEQUEUED, btw?

	dequeue_signal:

		if (sig_kernel_stop(sig))
			->flags &= ~SIGNAL_STOP_CONTINUED;

	do_signal_stop:

		if (flags & (SIGNAL_STOP_CONTINUED | SIGNAL_GROUP_EXIT))
			return 0;

Possible?

Oleg.

