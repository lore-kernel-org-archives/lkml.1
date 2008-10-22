Return-Path: <linux-kernel-owner+w=401wt.eu-S1757141AbYJVQUD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757141AbYJVQUD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 12:20:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753719AbYJVQTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 12:19:50 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:62372 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751215AbYJVQTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 12:19:48 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtoEAIjs/khMQWQ+/2dsb2JhbACBcsRpg08
Date: Wed, 22 Oct 2008 12:19:44 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Luck, Tony" <tony.luck@intel.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "ltt-dev@lists.casi.polymtl.ca" <ltt-dev@lists.casi.polymtl.ca>,
       Michael Davidson <md@google.com>
Subject: Re: [RFC patch 15/15] LTTng timestamp x86
Message-ID: <20081022161944.GB12650@Krystal>
References: <57C9024A16AD2D4C97DC78E552063EA3532D455F@orsmsx505.amr.corp.intel.com> <20081017172515.GA9639@goodmis.org> <57C9024A16AD2D4C97DC78E552063EA3533458AC@orsmsx505.amr.corp.intel.com> <20081017184215.GB9874@Krystal> <57C9024A16AD2D4C97DC78E552063EA35334594F@orsmsx505.amr.corp.intel.com> <20081017202313.GA13597@Krystal> <57C9024A16AD2D4C97DC78E552063EA353345B9B@orsmsx505.amr.corp.intel.com> <20081018170118.GA22243@Krystal> <alpine.LFD.2.00.0810181011310.3438@nehalem.linux-foundation.org> <20081018175005.GA2211@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20081018175005.GA2211@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:07:23 up 139 days, 20:47,  9 users,  load average: 0.56, 0.95,
	1.09
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > And if you make all these linear interpolations be per-CPU (so you 
> > have per-CPU offsets and frequencies) you never _ever_ need to touch 
> > any shared data at all, and you know you can scale basically 
> > perfectly.
> > 
> > Your linear interpolations may not be _perfect_, but you'll be able to 
> > get them pretty damn near. In fact, even if the TSC's aren't 
> > synchronized at all, if they are at least _individually_ stable (just 
> > running at slightly different frequencies because they are in 
> > different clock domains, and/or at different start points), you can 
> > basically perfect the precision over time.
> 
> there's been code submitted by Michael Davidson recently that looked 
> interesting, which turns the TSC into such an entity:
> 
>     http://lkml.org/lkml/2008/9/25/451
> 
> The periodic synchronization uses the hpet, but it thus allows lockless 
> and globally correct readouts of the TSC .
> 
> And that would match the long term goal as well: the hw should do this 
> all automatically. So perhaps we should have a trace_clock() after all, 
> independent of sched_clock(), and derived straight from RDTSC.
> 
> The approach as propoed has a couple of practical problems, but if we 
> could be one RDTSC+multiplication away from a pretty good timestamp that 
> would be rather useful, very fast and very robust ...
> 
> 	Ingo

Looking at this code, I wonder :

- How it would support virtualization.
- How it would scale to 512 nodes, if we consider that every idle node
  is doing an HPET readl each time it exits from safe_halt() (this can
  end up taking most of the HPET timer bandwidth). So in the case where
  we have 256 idle nodes taking all the HPET timer bandwidth and a 256
  nodes doing useful work, the time these HPET reads can take on the
  useful nodes when they try to resync with the HPET could be long (they
  may need to sample it periodically or at CPU frequency change, or they
  may simply go idle once in a while). We might end up having difficulty
  getting a CPU out of idle due to the time it takes simply to get hold
  of the HPET.

Given the bad scalability numbers I've recently posted for the HPET, I
doubt this a workable solution to the scalability issue.

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
