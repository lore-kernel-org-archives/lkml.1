Return-Path: <linux-kernel-owner+w=401wt.eu-S1754257AbYKGIgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257AbYKGIgk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 03:36:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753998AbYKGIgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 03:36:13 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57350 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753974AbYKGIgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 03:36:12 -0500
Date: Fri, 7 Nov 2008 09:35:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frank Mayhar <fmayhar@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Doug Chapman <doug.chapman@hp.com>, roland@redhat.com,
       adobriyan@gmail.com, akpm@linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: regression introduced by - timers: fix itimer/many thread hang
Message-ID: <20081107083555.GE4435@elte.hu>
References: <1224694989.8431.23.camel@oberon> <1225132746.14792.13.camel@bobble.smo.corp.google.com> <1225219114.24204.37.camel@oberon> <1225936715.27507.44.camel@bobble.smo.corp.google.com> <1225969420.7803.4366.camel@twins> <Pine.LNX.4.64.0811060900450.3595@quilx.com> <1225984098.7803.4642.camel@twins> <1226015568.2186.20.camel@bobble.smo.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226015568.2186.20.camel@bobble.smo.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frank Mayhar <fmayhar@google.com> wrote:

> On Thu, 2008-11-06 at 16:08 +0100, Peter Zijlstra wrote: 
> > On Thu, 2008-11-06 at 09:03 -0600, Christoph Lameter wrote:
> > > On Thu, 6 Nov 2008, Peter Zijlstra wrote:
> > > 
> > > > Also, you just introduced per-cpu allocations for each thread-group,
> > > > while Christoph is reworking the per-cpu allocator, with one unfortunate
> > > > side-effect - its going to have a limited size pool. Therefore this will
> > > > limit the number of thread-groups we can have.
> > > 
> > > Patches exist that implement a dynamically growable percpu pool (using
> > > virtual mappings though). If the cost of the additional complexity /
> > > overhead is justifiable then we can make the percpu pool dynamically
> > > extendable.
> > 
> > Right, but I don't think the patch under consideration will fly anyway,
> > doing a for_each_possible_cpu() loop on every tick on all cpus isn't
> > really healthy, even for moderate sized machines.
> 
> I personally think that you're overstating this.  First, the current 
> implementation walks all threads for each tick, which is simply not 
> scalable and results in soft lockups with large numbers of threads. 
> This patch fixes a real bug.  Second, this only happens "on every 
> tick" for processes that have more than one thread _and_ that use 
> posix interval timers.  Roland and I went to some effort to keep 
> loops like the on you're referring to out of the common paths.
> 
> In any event, while this particular implementation may not be 
> optimal, at least it's _right_.  Whatever happened to "make it 
> right, then make it fast?"

Well, you pushed the lockup to another place: previously we locked up 
with enough threads added, now we'll lock up with enough CPUs added.

So ... please get rid of the for-each-cpu loop for good? (Also, the 
task-exit race needs to be fixed first i guess, before we worry about 
loops.)

	Ingo
