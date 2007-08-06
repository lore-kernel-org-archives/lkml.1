Return-Path: <linux-kernel-owner+w=401wt.eu-S933689AbXHFNcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933689AbXHFNcW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 09:32:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933314AbXHFN3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 09:29:37 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53702 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933332AbXHFN3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 09:29:35 -0400
Subject: Re: [PATCH] RT: Add priority-queuing and priority-inheritance to
	workqueue infrastructure
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Ingo Molnar <mingo@elte.hu>, Gregory Haskins <ghaskins@novell.com>,
       Daniel Walker <dwalker@mvista.com>, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070806131814.GC91@tv-sign.ru>
References: <20070801201802.GA225@tv-sign.ru>
	 <1186000468.2636.168.camel@imap.mvista.com>
	 <20070801205053.GA263@tv-sign.ru>
	 <1186002783.9513.228.camel@ghaskins-t60p.haskins.net>
	 <20070801213422.GA280@tv-sign.ru>
	 <1186005598.9513.261.camel@ghaskins-t60p.haskins.net>
	 <20070801222201.GA316@tv-sign.ru>
	 <1186012439.9513.321.camel@ghaskins-t60p.haskins.net>
	 <20070802195049.GA361@tv-sign.ru> <20070806114954.GC1903@elte.hu>
	 <20070806131814.GC91@tv-sign.ru>
Content-Type: text/plain
Date: Mon, 06 Aug 2007 15:29:23 +0200
Message-Id: <1186406963.7182.13.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-06 at 17:18 +0400, Oleg Nesterov wrote:

> Yes, I still disagree with the whole idea because I hope we can make
> something more simpler to solve the problem, but I must admit I don't
> quite understand what the problem is.
> 
> So, please consider a noise from my side as my attempt to help. And
> in fact, I am very curious about -rt tree, just I never had a time
> to study it :)


Well, the thing is, suppose we have 2 drivers both using keventd say a
NIC and some USB thingy.

Now the NIC is deemed important hand gets irq thread prio 90, and the
USB could not be cared less about and gets 10 (note that on -rt irq
handlers are threaded and run SCHED_FIFO).

So now you can get priority inversion in keventd. Say the USB thingy
schedules a work item which will be executed. Then during the execution
of this work the NIC will also schedule a work item. Now the NIC (fifo
90) will have to wait for the USB work (fifo 10) to complete.

The typical solution is priority inheritance, where the highest prio of
any waiter is propagated to the currently running work, so that it can
finish and get on with the more important work.


So these patches aimed to provide proper PI in the workqueue structure
to avoid this problem.

However as you rightly noted, this horribly breaks the barrier/flush
semantics.

I suspect most of the barrier/flush semantics could be replaced with
completions from specific work items. Doing this will be a lot of work
though.

I hope this rambling is not confusing you any further :-)

