Return-Path: <linux-kernel-owner+w=401wt.eu-S1765466AbXGaVIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765466AbXGaVIX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 17:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763647AbXGaVIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 17:08:07 -0400
Received: from mail.screens.ru ([213.234.233.54]:34550 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753892AbXGaVIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 17:08:05 -0400
Date: Wed, 1 Aug 2007 01:08:17 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH] Use ERESTARTNOHAND if poll() is interrupted by a signal
Message-ID: <20070731210817.GA97@tv-sign.ru>
References: <200707291705.l6TH554a003344@colorfullife.mysite.adiungo.com> <20070730163538.67b256da.akpm@linux-foundation.org> <46AF9C2D.70808@colorfullife.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46AF9C2D.70808@colorfullife.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31, Manfred Spraul wrote:
>
> Mainline has the same problem: poll() returns to user space if it's 
> interrupted by SIGSTOP/SIGCONT.
> >I guess the consequences of the thing-which-this-fixes aren't huge, s I ca
> >queue this up for 2.6.24, after Oleg's
> >do_poll-return-eintr-when-signalled.patch?
> >
> >  
> Yes, please queue it: most/all linux versions show this behavior. 
> Additionally, poll() is usually called in a loop and a spurious wakeup 
> has no consequences.

... and so the current behaviour is more or less correct, even if not
optimal.

But this patch in fact adds a bug. We don't even need the "special"
signals like SIGSTOP/SIGCONT or freezer to hit this bug.

Suppose that sys_poll() was interrupted by a "normal" signal which
has a handler. It is quite possible that another thread can steal
this signal before us. Now, ERESTARTNOHAND means we restart sys_poll()
with the same (old) timeout, this means that sys_poll() does _not_
return when timeout expired (if no fds ready), and this is bug.

Also, the false signal_wake_up() is possible, and again, the spurious
-EINTR is better than restart with the same timeout.

What we need is ERESTART_RESTARTBLOCK, and restart_block.arg2 should
have the new timeout value, which takes the time we already slept
into account.

Oleg.

