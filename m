Return-Path: <linux-kernel-owner+w=401wt.eu-S1753223AbZHXSWH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223AbZHXSWH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 14:22:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753186AbZHXSWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 14:22:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55557 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753168AbZHXSWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 14:22:04 -0400
Date: Mon, 24 Aug 2009 20:21:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/15] x86: Fix cpu_coregroup_mask to return correct
	cpumask on multi-node processors
Message-ID: <20090824182154.GA9785@elte.hu>
References: <20090820131243.GO29327@alberich.amd.com> <20090820134604.GD29327@alberich.amd.com> <1251128176.7538.301.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251128176.7538.301.camel@twins>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, 2009-08-20 at 15:46 +0200, Andreas Herrmann wrote:
> > The correct mask that describes core-siblings of an processor
> > is topology_core_cpumask. See topology adapation patches, especially
> > http://marc.info/?l=linux-kernel&m=124964999608179
> 
> argh, violence, murder kill.. this is the worst possible hack and 
> you're extending it :/

I think most of the trouble here comes from having inconsistent 
names, a rather static structure for sched-domains setup and then we 
are confusing things back and forth.

Right now we have thread/sibling, core, CPU/socket and node, with 
many data structures around these hardcoded. Certain scheduler 
features only operate on the hardcoded fields.

Now Magny-Cours adds a socket internal node construct to the whole 
thing, names it randomly and basically breaks the semi-static 
representation.

We cannot just flip around our static names and hope it goes well 
and everything just drops into place. Everything just falls apart 
really instead.

Instead we should have an arch-defined tree and a CPU architecture 
dependent ASCII name associated with each level - but not hardcoded 
into the scheduler.

Plus we should have independent scheduler domains feature flags that 
can be turned on/off in various levels of that tree, depending on 
the cache and interconnect properties of the hardware - without 
having to worry about what the ASCII name says. Those features 
should be capable to work not just on the lowest level of the tree, 
but on higher levels too, regardless whether that level is called a 
'core', a 'socket' or an 'internal node' on the ASCII level really.

This is why i insisted on handling the Magny-Cours topology 
discovery and enumeration patches together with the scheduler 
patches. It can easily become a mess if extended.

	Ingo
