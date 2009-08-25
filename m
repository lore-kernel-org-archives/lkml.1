Return-Path: <linux-kernel-owner+w=401wt.eu-S1754923AbZHYKg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923AbZHYKg4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 06:36:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754799AbZHYKg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 06:36:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36892 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751050AbZHYKgz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 06:36:55 -0400
Date: Tue, 25 Aug 2009 12:36:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/15] x86: Fix cpu_coregroup_mask to return correct
	cpumask on multi-node processors
Message-ID: <20090825103651.GA28287@elte.hu>
References: <20090820131243.GO29327@alberich.amd.com> <20090820134604.GD29327@alberich.amd.com> <1251128176.7538.301.camel@twins> <20090824182154.GA9785@elte.hu> <20090825101353.GB15389@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090825101353.GB15389@alberich.amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andreas Herrmann <andreas.herrmann3@amd.com> wrote:

> On Mon, Aug 24, 2009 at 08:21:54PM +0200, Ingo Molnar wrote:
> > 
> > * Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > On Thu, 2009-08-20 at 15:46 +0200, Andreas Herrmann wrote:
> > > > The correct mask that describes core-siblings of an processor
> > > > is topology_core_cpumask. See topology adapation patches, especially
> > > > http://marc.info/?l=linux-kernel&m=124964999608179
> > > 
> > > argh, violence, murder kill.. this is the worst possible hack and 
> > > you're extending it :/
> > 
> > I think most of the trouble here comes from having inconsistent 
> > names, a rather static structure for sched-domains setup and 
> > then we are confusing things back and forth.
> > 
> > Right now we have thread/sibling, core, CPU/socket and node, 
> > with many data structures around these hardcoded. Certain 
> > scheduler features only operate on the hardcoded fields.
> > 
> > Now Magny-Cours adds a socket internal node construct to the 
> > whole thing, names it randomly and basically breaks the 
> > semi-static representation.
> > 
> > We cannot just flip around our static names and hope it goes 
> > well and everything just drops into place. Everything just falls 
> > apart really instead.
> > 
> > Instead we should have an arch-defined tree and a CPU 
> > architecture dependent ASCII name associated with each level - 
> > but not hardcoded into the scheduler.
> 
> I admit that it's strange to have the x86 specific SCHED_SMT/MC 
> snippets in common code.
> 
> And the NUMA/SD_NODE stuff is not used by all architectures 
> either.
> 
> Having an arch-defined tree seems the right thing to do.

yep, with generic helpers to reduce per arch bloat. 
(named/structured in a neutral way)

> > Plus we should have independent scheduler domains feature flags 
> > that can be turned on/off in various levels of that tree, 
> > depending on the cache and interconnect properties of the 
> > hardware - without having to worry about what the ASCII name 
> > says. Those features should be capable to work not just on the 
> > lowest level of the tree, but on higher levels too, regardless 
> > whether that level is called a 'core', a 'socket' or an 
> > 'internal node' on the ASCII level really.
> > 
> > This is why i insisted on handling the Magny-Cours topology 
> > discovery and enumeration patches together with the scheduler 
> > patches. It can easily become a mess if extended.
> 
> I don't buy this argument.
> 
> The main source of information when building sched-domains will be 
> the CPU topology. That must be provided somehow independent of how 
> scheduling domains are created. When the domains are built you 
> just need to know which cpumask to use when the sched_groups and 
> domain's span are determined.
> 
> Thus I think the topology detection is rather self-contained and 
> can/should be provided independent of how the scheduler side is 
> going to be implemented.

This is the sysfs bits? What is this needed for exactly? The 
scheduler is pretty much the most important thing to tune in a 
topology aware manner, besides memory allocations.

	Ingo
