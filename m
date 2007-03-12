Return-Path: <linux-kernel-owner+w=401wt.eu-S965549AbXCLLNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965549AbXCLLNf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 07:13:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965589AbXCLLNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 07:13:34 -0400
Received: from mail.suse.de ([195.135.220.2]:57300 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965587AbXCLLNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 07:13:33 -0400
Date: Mon, 12 Mar 2007 12:13:31 +0100
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Roland McGrath <roland@redhat.com>, akpm@linux-foundation.org,
       mm-commits@vger.kernel.org, drepper@redhat.com, oleg@tv-sign.ru,
       sebastien.dugue@bull.net, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch] change futex_wait() to hrtimers
Message-ID: <20070312111331.GF28546@wotan.suse.de>
References: <200703110814.l2B8EaI1007615@shell0.pdx.osdl.net> <20070312011259.3834A1801C4@magilla.sf.frob.com> <20070312091006.GF21024@elte.hu> <20070312091628.GE28546@wotan.suse.de> <20070312110204.GD2231@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070312110204.GD2231@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2007 at 12:02:04PM +0100, Ingo Molnar wrote:
> 
> * Nick Piggin <npiggin@suse.de> wrote:
> 
> > > i dont think we should try to do this. We should not and cannot do 
> > > anything about all of the artifacts that comes with the use of 
> > > relative timeouts and schedule_timeout().
> > > 
> > > basically, using jiffies here (which schedule_timeout() does) is 
> > > /fundamentally/ imprecise. If you get many interrupts, rounding 
> > > errors sum up - and there's nothing we can do about it!
> > 
> > Well I did convert futex_wait to an absolute timeout based version in 
> > the subsequent incremental patch. I think that is OK?
> 
> it still has the rounding artifacts: using timer_list there is no way to 
> do a precise long sleep based on many small sleeps.

OK but that is nothing to do with my patch, but the original futex_wait
implementation.

> even if this means more work for you (i'm sorry about that!) i'm quite 
> sure we should take Sebastien's hrtimers based implementation of 
> futex_wait(), and use the nanosleep method to restart it. There's no 
> point in further tweaking the imprecise approach: whenever some timeout 
> needs to be restarted, it's a candidate for hrtimers.

Absolute timeout is needed, sure. But once that is done, hrtimers does
not fix a bug, does it?

> 
> until then, glibc already handles timeouts and restarts it manually.

It isn't timeout handling that is buggy, but EINTR behaviour. And
glibc does not handle that here.

