Return-Path: <linux-kernel-owner+w=401wt.eu-S1754880AbZHTQOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880AbZHTQOg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 12:14:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754815AbZHTQOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 12:14:36 -0400
Received: from www.tglx.de ([62.245.132.106]:49018 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754715AbZHTQOf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 12:14:35 -0400
Date: Thu, 20 Aug 2009 18:14:07 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       john stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [circular locking bug] Re: [patch 00/15] clocksource / timekeeping
 rework V4 (resend V3 + bug fix)
In-Reply-To: <20090820123547.1ef5a5e0@skybase>
Message-ID: <alpine.LFD.2.00.0908201809190.3361@localhost.localdomain>
References: <1250300765.8269.29.camel@localhost.localdomain> <alpine.LFD.2.00.0908151057500.1283@localhost.localdomain> <20090815095221.GA15831@elte.hu> <alpine.LFD.2.00.0908151207000.1283@localhost.localdomain> <20090817094042.03fe5d38@skybase>
 <alpine.LFD.2.00.0908171038420.2782@localhost.localdomain> <20090817092807.GA10460@elte.hu> <20090818170942.3ab80c91@skybase> <20090819202554.GA19482@elte.hu> <20090820112820.47d833c1@skybase> <20090820095821.GA29093@elte.hu>
 <20090820123547.1ef5a5e0@skybase>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Aug 2009, Martin Schwidefsky wrote:
> On Thu, 20 Aug 2009 11:58:21 +0200
> > There should be a time management kernel thread instead 
> > (or workqueue), which does a proper state machine of all 
> > these properties - without having to call this stuff from 
> > within a timer handler.
> 
> We could use that time managment kernel thread for the watchdog
> downgrade as well. Dunno if it is worth to create another kernel thread
> that just sits there doing nothing for 99.9% of the time.
> 
> As for the fix: my brains starts to hurt looking at the pit clocksource
> code. Why does it set CLOCK_EVT_FEAT_ONESHOT but then unregisters the
> clocksource when the mode is set to CLOCK_EVT_MODE_ONESHOT?? That does
> not make any sense to me. I would have expected that the pit does not
> set CLOCK_EVT_MODE_ONESHOT. The timekeeping code wouldn't try use the
> clock for one-shot if the bit is not set. And to unregister the clock
> only because the mode is set to shutdown or unused doesn't seem to be
> necessary either. My fix would be to remove the CLOCK_EVT_MODE_ONESHOT
> bit from the features mask and to remove the clocksource_unregister
> from the set_mode callback.

No. On UP machines we can run in oneshot mode with the PIT. 

The disable PIT clocksource hack was done in commit
1a0c009ac53de4a7664a1239936f0bc258133156. Yes, in hindsight we should
have done 3f68535adad8dd89499505a65fb25d0e02d118cc in the first place.

So now the simple and correct fix is to remove the unregister call.

Thanks,

	tglx
