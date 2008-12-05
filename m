Return-Path: <linux-kernel-owner+w=401wt.eu-S1758053AbYLENZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053AbYLENZs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 08:25:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751543AbYLENZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 08:25:39 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52810 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502AbYLENZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 08:25:38 -0500
Date: Fri, 5 Dec 2008 14:25:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: paulus@samba.org, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, akpm@linux-foundation.org,
       eranian@googlemail.com, dada1@cosmosbay.com, robert.richter@amd.com,
       arjan@infradead.org, hpa@zytor.com, a.p.zijlstra@chello.nl,
       rostedt@goodmis.org
Subject: Re: [patch 0/3] [Announcement] Performance Counters for Linux
Message-ID: <20081205132512.GA18786@elte.hu>
References: <20081205063131.GB12785@elte.hu> <18744.56857.259756.129894@cargo.ozlabs.ibm.com> <20081205080813.GA2030@elte.hu> <20081205.001520.79526444.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081205.001520.79526444.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Miller <davem@davemloft.net> wrote:

> > > Isn't it two separate read() calls to read the two counters?  If 
> > > so, the only way the two values are actually going to correspond to 
> > > the same point in time is if the task being monitored is stopped.  
> > > In which case the monitoring task needs to use ptrace or something 
> > > similar in order to make sure that the monitored task is actually 
> > > stopped.
> > 
> > It doesnt matter in practice.
> 
> Yes it DOES!
> 
> If I want to know if a code block triggers event X or Y, and your read 
> call triggers one of those events, I can't figure out the answer to my 
> profiling problem.

( this misunderstanding of yours has been cleared up in a later mail: 
  reading a counter causes events in the monitoring context, not in the
  monitored context. )

> That is completely fundamental to all of this.  And this is why this 
> proposal is a non-workable solution.
> 
> 
> > Also, look at our code: we buffer notification events and do not have 
> > to stop the thread for recording the context information.
> 
> But that's what monitoring libraries want, they want to stop the task 
> and inspect it.
> 
> Look at the PAPI library.  If you can't implement what that thing 
> provides, all the real users of profiling information can't use this 
> stuff.

We have looked, and the PAPI library can be implemented on top of our 
system call as well - just like it was implemented on top of the perfctr 
driver and like it was implemented ontop of "perfmon-full".

PAPI is a relatively simple wrapper around OS level performance counter 
facilities. Both the high level counter abstraction 
(PAPI_start_counters() & friends) and the low level PAPI abstraction 
(PAPI event sets, PAPI_attach/detach) can be readily implemented via the 
use of our performance counter subsystem facilities. (In addition to all 
the facilities around PAPI event enumeration.)

PAPI has about 100 functions - if you think our design does not fit it 
for some fundamental reason then please point out exactly which 
functionality (which PAPI function call) cannot be done.

Perfmon needlessly complicated their design by exposing user-space to a 
'performance counter context' and other lowlevel details that should not 
and must not be handled at the ABI level. The PAPI interfaces do not 
force that design choice in any way. It's a plain unnecessary 
complication that permeates the whole perfmon code.

	Ingo
