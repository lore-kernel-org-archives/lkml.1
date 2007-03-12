Return-Path: <linux-kernel-owner+w=401wt.eu-S965537AbXCLL36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965537AbXCLL36 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 07:29:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965689AbXCLL36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 07:29:58 -0400
Received: from cantor.suse.de ([195.135.220.2]:58510 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965537AbXCLL34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 07:29:56 -0400
Date: Mon, 12 Mar 2007 12:29:55 +0100
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Roland McGrath <roland@redhat.com>, akpm@linux-foundation.org,
       mm-commits@vger.kernel.org, drepper@redhat.com, oleg@tv-sign.ru,
       sebastien.dugue@bull.net, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch] change futex_wait() to hrtimers
Message-ID: <20070312112955.GH28546@wotan.suse.de>
References: <200703110814.l2B8EaI1007615@shell0.pdx.osdl.net> <20070312011259.3834A1801C4@magilla.sf.frob.com> <20070312091006.GF21024@elte.hu> <20070312091628.GE28546@wotan.suse.de> <20070312110204.GD2231@elte.hu> <20070312111331.GF28546@wotan.suse.de> <20070312111958.GA14573@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070312111958.GA14573@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2007 at 12:19:58PM +0100, Ingo Molnar wrote:
> 
> * Nick Piggin <npiggin@suse.de> wrote:
> 
> > > even if this means more work for you (i'm sorry about that!) i'm 
> > > quite sure we should take Sebastien's hrtimers based implementation 
> > > of futex_wait(), and use the nanosleep method to restart it. There's 
> > > no point in further tweaking the imprecise approach: whenever some 
> > > timeout needs to be restarted, it's a candidate for hrtimers.
> > 
> > Absolute timeout is needed, sure. But once that is done, hrtimers does 
> > not fix a bug, does it?
> 
> the issue is this: your fix reduces the effects of the bug but it is 
> still fundamentally incomplete because of the use of timer_list. So 

But using schedule_timeout is not a bug. Userspace timeouts are always
defined to be "at least".

> instead of trying to fix the bug the wrong way, please try to fix it the 
> right way, ontop of an already existing and tested patch, ok? That also 
> enables the other neat stuff Thomas talked about.

Well that's nice, but I have a bugfix here which probably needs to
get backported to stable kernels and distro kernels.

It should be just as easy to rebase the hrtimer patch on top of my
fix. Considering that you've had it for a year, I don't think it 
needs to be added right before my fix.

> > > until then, glibc already handles timeouts and restarts it manually.
> > 
> > It isn't timeout handling that is buggy, but EINTR behaviour. And 
> > glibc does not handle that here.
> 
> hm. I'm wondering how this wasnt noticed sooner - this futex_wait 
> behavior has been there for like forever.

People ignore LTP test failures, and programs probably try to avoid
exercising the nuances of the unix signal API, I guess.
