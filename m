Return-Path: <linux-kernel-owner+w=401wt.eu-S965815AbXCLMg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965815AbXCLMg7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 08:36:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965809AbXCLMg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 08:36:59 -0400
Received: from mail.suse.de ([195.135.220.2]:34162 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965789AbXCLMg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 08:36:57 -0400
Date: Mon, 12 Mar 2007 13:36:47 +0100
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Roland McGrath <roland@redhat.com>, akpm@linux-foundation.org,
       mm-commits@vger.kernel.org, drepper@redhat.com, oleg@tv-sign.ru,
       sebastien.dugue@bull.net, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch] change futex_wait() to hrtimers
Message-ID: <20070312123647.GB20657@wotan.suse.de>
References: <20070312011259.3834A1801C4@magilla.sf.frob.com> <20070312091006.GF21024@elte.hu> <20070312091628.GE28546@wotan.suse.de> <20070312110204.GD2231@elte.hu> <20070312111331.GF28546@wotan.suse.de> <20070312111958.GA14573@elte.hu> <20070312112955.GH28546@wotan.suse.de> <20070312113829.GA18759@elte.hu> <20070312115201.GI28546@wotan.suse.de> <20070312122103.GA30778@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070312122103.GA30778@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2007 at 01:21:03PM +0100, Ingo Molnar wrote:
> 
> * Nick Piggin <npiggin@suse.de> wrote:
> 
> > > > > the issue is this: your fix reduces the effects of the bug but 
> > > > > it is still fundamentally incomplete because of the use of 
> > > > > timer_list. So
> > > > 
> > > > But using schedule_timeout is not a bug. Userspace timeouts are 
> > > > always defined to be "at least".
> > > 
> > > but what you are adding isnt a plain schedule_timeout(), it is a 
> > > restart block handling loop. And for those restart blocks that 
> > > relate to timeouts, we only use hrtimers. I am not making this up to 
> > > annoy you: take a look at all the current restart block handlers - 
> > > they are hrtimer based, for exactly this reason.
> > 
> > So why do you say it is fundamentally incomplete?
> 
> because i misread your last patch :-) I thought it still has a window 
> for inaccuracy, but you are right: it should be at most 1 jiffy 
> inaccurate, no matter how many times we restart.

OK, no problem.

> still ... the hrtimers patch has been submitted to lkml before yours, 
> and has been tested extensively, so why go the extra side-jump 
> prolonging the jiffies sleep method? The LTP failure has been there 
> since the inception of the futex code i suspect. Going this way also 
> enables the addressing of a more pressing need: the elimination of 
> glibc's forced use of relative futex timeouts.

I guess my arguments are that my patch fixes a bug, which gives it a
higher priority (being a userspace API bug, perhaps even 2.6.21); and
that it will want to be backported while the hrtimer patch will not, so
including the hrtimer patch first means 2 different patches to fix the
same bug.

I'm not trying to make life harder for the hrtimer patch. I will even
volunteer to forward port it on top of the restart fix, if that is an
issue.

