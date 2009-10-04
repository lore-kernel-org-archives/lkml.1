Return-Path: <linux-kernel-owner+w=401wt.eu-S1752521AbZJDIp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521AbZJDIp2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 04:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751201AbZJDIp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 04:45:28 -0400
Received: from www.tglx.de ([62.245.132.106]:47921 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785AbZJDIp1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 04:45:27 -0400
Date: Sun, 4 Oct 2009 10:44:32 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Darren Hart <dvhltc@us.ibm.com>
cc: Anirban Sinha <ASinha@zeugmasystems.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: futex question
In-Reply-To: <4AC68F13.8050601@us.ibm.com>
Message-ID: <alpine.LFD.2.00.0910041031330.2646@localhost.localdomain>
References: <DDFD17CC94A9BD49A82147DDF7D545C501FD7F97@exchange.ZeugmaSystems.local> <20091001092218.GH15345@elte.hu> <DDFD17CC94A9BD49A82147DDF7D545C501FD8409@exchange.ZeugmaSystems.local> <4AC68F13.8050601@us.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Oct 2009, Darren Hart wrote:
> Anirban Sinha wrote:
> > > Should we not just clear the pointer (and
> > > > it's compat version) within do_execve()?
> > 
> > 
> > In our private repository, applying the following patch resolved the
> > issues I mentioned. I no longer see messages like this:
> > 
> >  [futex] ("ifconfig")(pid=2509) exit_robust_list:unable to fetch robust
> > entry. uaddr=0x000000002abbc4f0
> > 
> > from my instrumented kernel within exit_robust_list(). My
> > instrumentation looked something like this:
> 
> > 
> > if (fetch_robust_entry(...)) {
> > printk(...);
> > return;
> > }
> > 
> > Just tossing the patch in the community in case someone is interested
> 
> 
> Thanks for sending the patch.  I'm looking into it now.  Couple questions:
> 
> 1) What caused you to instrument this path in the first place?  Were you
> seeing some unexpected behavior?
> 
> 2) I wonder why we would need to clear the robust list, but I don't see other
> things like pi_blocked_on, etc. in execve being cleared.  I'm looking into
> this now (perhaps we don't do the same cleanup, need to check).... have to get
> on the plane...

Hmm, just setting the robust list pointer to NULL fixes the problem at
hand, but I wonder whether we need to call exit_robust_list() as
well. 

Vs. pi_blocked_on: If that's != NULL then you are not executing that
code path because you hang in the scheduler waiting for the lock. 

The interesting question is whether we need to call
exit_pi_state_list() to fix up held locks.

Thanks,

	tglx

