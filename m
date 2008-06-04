Return-Path: <linux-kernel-owner+w=401wt.eu-S1762806AbYFDTxB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762806AbYFDTxB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 15:53:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762571AbYFDTwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 15:52:51 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:48192 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762486AbYFDTwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 15:52:49 -0400
Date: Wed, 4 Jun 2008 13:52:33 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] schedule: fix TASK_WAKEKILL vs SIGKILL race
Message-ID: <20080604195232.GJ3549@parisc-linux.org>
References: <20080604170905.GA10273@tv-sign.ru> <20080604173318.GH3549@parisc-linux.org> <20080604180101.GA10295@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080604180101.GA10295@tv-sign.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2008 at 10:01:01PM +0400, Oleg Nesterov wrote:
> > In my opinion, not checking for TASK_STOPPED or TASK_TRACED previously was
> > an oversight.  This should be fixed.
> 
> Perhaps, and the changelog has a special note. But imho we need another patch
> for that, this is a user-visible change.

It is?

> > >  	if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {
> > > -		if (unlikely((prev->state & TASK_INTERRUPTIBLE) &&
> > > -				signal_pending(prev))) {
> > > +		if (unlikely(signal_pending_state(prev->state, prev)))
> > >  			prev->state = TASK_RUNNING;
> > > -		} else {
> > > +		else
> > >  			deactivate_task(rq, prev, 1);
> > > -		}
> > 
> > Getting rid of the extra braces is against CodingStyle:
> > 
> 
> With this patch the code is
> 
> 		if (unlikely(signal_pending_state(prev->state, prev)))
> 			prev->state = TASK_RUNNING;
> 		else
> 			deactivate_task(rq, prev, 1);

Didn't notice that.  Still, adjusting brace style is a bad idea.  Just
leave it the way it is.

> > This patch is going to add quite a few cycles to schedule().  Has anyone
> > done any benchmarks with a schedule-heavy workload?
> 
> No, I didn't. This patch is bugfix.

But there are other ways to fix the bug if this patch proves to be too
heavy-weight.

> However, I think the new helper can have other users. Not that I have a strong
> opinion.

I don't think so ...

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
