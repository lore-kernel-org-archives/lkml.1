Return-Path: <linux-kernel-owner+w=401wt.eu-S1765392AbXFST7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765392AbXFST7l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 15:59:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759314AbXFST7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 15:59:34 -0400
Received: from mail.screens.ru ([213.234.233.54]:48566 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753665AbXFST7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 15:59:33 -0400
Date: Tue, 19 Jun 2007 23:59:44 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Nicholas Miell <nmiell@comcast.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Fix signalfd interaction with thread-private signals
Message-ID: <20070619195944.GA105@tv-sign.ru>
References: <1182064500.2798.6.camel@entropy> <Pine.LNX.4.64.0706170951580.20841@alien.or.mcafeemobile.com> <1182108399.3794.4.camel@entropy> <Pine.LNX.4.64.0706171436260.20841@alien.or.mcafeemobile.com> <1182125303.3794.8.camel@entropy> <Pine.LNX.4.64.0706171715320.5316@alien.or.mcafeemobile.com> <1182127391.26853.207.camel@localhost.localdomain> <alpine.LFD.0.98.0706181011460.14121@woody.linux-foundation.org> <20070619091452.GA94@tv-sign.ru> <Pine.LNX.4.64.0706191242160.16740@alien.or.mcafeemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706191242160.16740@alien.or.mcafeemobile.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19, Davide Libenzi wrote:
>
> On Tue, 19 Jun 2007, Oleg Nesterov wrote:
> 
> > The commited "Fix signalfd interaction with thread-private signals"
> > (commit caec4e8dc85e0644ec24aeb36285e1ba02da58cc) doesn't implement
> > this.
> > 
> > We can do something like
> > 
> > 	int signalfd_dequeue_signal(struct task_struct *tsk, sigset_t *mask, siginfo_t *info)
> > 	{
> > 		if (tsk->tgid == current->tgid)
> > 			tsk = current;
> > 
> > 		return dequeue_signal(tsk, mask, info);
> > 	}
> > 
> > (still I can't understand why should we change signalfd).
> 
> Yes, of course. I was waiting for Ben's patch to go in, before fixing 
> signalfd. I did not know if Linus would have acked that.

OK, this means that signalfd becomes "thread group wide". In that case
I'd suggest to also change sys_signalfd(-1),

	-		ctx->tsk = current;
	+		ctx->tsk = current->group_leader;

Oleg.

