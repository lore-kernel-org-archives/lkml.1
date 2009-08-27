Return-Path: <linux-kernel-owner+w=401wt.eu-S1752652AbZH0NTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652AbZH0NTa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 09:19:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752388AbZH0NTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 09:19:30 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:50216 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664AbZH0NT3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 09:19:29 -0400
X-SpamScore: -1
X-BigFish: VPS-1(z34a4jz1432R98dN936eM10d1Ia594izz1202hzz3198u327alz32i6bh203h61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KP1EC9-01-2KC-02
X-M-MSG: 
Date: Thu, 27 Aug 2009 15:18:58 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/15] x86: Fix cpu_coregroup_mask to return correct
	cpumask on multi-node processors
Message-ID: <20090827131858.GD13576@alberich.amd.com>
References: <20090820131243.GO29327@alberich.amd.com> <20090820134604.GD29327@alberich.amd.com> <1251128176.7538.301.camel@twins> <20090824182154.GA9785@elte.hu> <20090825101353.GB15389@alberich.amd.com> <20090825103651.GA28287@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090825103651.GA28287@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 27 Aug 2009 13:18:58.0267 (UTC) FILETIME=[EF66CAB0:01CA2718]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 25, 2009 at 12:36:51PM +0200, Ingo Molnar wrote:
> 
> * Andreas Herrmann <andreas.herrmann3@amd.com> wrote:
> 
> > On Mon, Aug 24, 2009 at 08:21:54PM +0200, Ingo Molnar wrote:
> > > 
> > > * Peter Zijlstra <peterz@infradead.org> wrote:
> > > 
> > > > On Thu, 2009-08-20 at 15:46 +0200, Andreas Herrmann wrote:
> > > > > The correct mask that describes core-siblings of an processor
> > > > > is topology_core_cpumask. See topology adapation patches, especially
> > > > > http://marc.info/?l=linux-kernel&m=124964999608179
> > > > 
> > > > argh, violence, murder kill.. this is the worst possible hack and 
> > > > you're extending it :/
> > > 
> > > I think most of the trouble here comes from having inconsistent 
> > > names, a rather static structure for sched-domains setup and 
> > > then we are confusing things back and forth.
> > > 
> > > Right now we have thread/sibling, core, CPU/socket and node, 
> > > with many data structures around these hardcoded. Certain 
> > > scheduler features only operate on the hardcoded fields.
> > > 
> > > Now Magny-Cours adds a socket internal node construct to the 
> > > whole thing, names it randomly and basically breaks the 
> > > semi-static representation.
> > > 
> > > We cannot just flip around our static names and hope it goes 
> > > well and everything just drops into place. Everything just falls 
> > > apart really instead.
> > > 
> > > Instead we should have an arch-defined tree and a CPU 
> > > architecture dependent ASCII name associated with each level - 
> > > but not hardcoded into the scheduler.
> > 
> > I admit that it's strange to have the x86 specific SCHED_SMT/MC 
> > snippets in common code.
> > 
> > And the NUMA/SD_NODE stuff is not used by all architectures 
> > either.
> > 
> > Having an arch-defined tree seems the right thing to do.
> 
> yep, with generic helpers to reduce per arch bloat. 
> (named/structured in a neutral way)
> 
> > > Plus we should have independent scheduler domains feature flags 
> > > that can be turned on/off in various levels of that tree, 
> > > depending on the cache and interconnect properties of the 
> > > hardware - without having to worry about what the ASCII name 
> > > says. Those features should be capable to work not just on the 
> > > lowest level of the tree, but on higher levels too, regardless 
> > > whether that level is called a 'core', a 'socket' or an 
> > > 'internal node' on the ASCII level really.
> > > 
> > > This is why i insisted on handling the Magny-Cours topology 
> > > discovery and enumeration patches together with the scheduler 
> > > patches. It can easily become a mess if extended.
> > 
> > I don't buy this argument.
> > 
> > The main source of information when building sched-domains will be 
> > the CPU topology. That must be provided somehow independent of how 
> > scheduling domains are created. When the domains are built you 
> > just need to know which cpumask to use when the sched_groups and 
> > domain's span are determined.
> > 
> > Thus I think the topology detection is rather self-contained and 
> > can/should be provided independent of how the scheduler side is 
> > going to be implemented.
> 
> This is the sysfs bits?

So you "only" object to the sysfs topology additions, correct?

> What is this needed for exactly?

If you need to know which cores share the same northbridge or in
a general sense which cores are on the same die.
That directly leads to the question whether a more generic
nomenclature should be used: chip_siblings instead of
cpu_node_siblings (could cover all MCM processors).

When a user wants to pin tasks to dedicated CPUs he might need this
information.
Maybe even you like to count northbridge events with PCL and have to
know which CPUs share the same northbridge and where you have to bind
the tasks/threads that you wanna monitor?

> The scheduler is pretty much the most important thing to tune in a
> topology aware manner, besides memory allocations.

I can leave out the patches that introduce the interface. But I
really want to have a cpu_node_map for a CPU and the cpu_node_id in
cpuinfo_x86 plus the two fixes (for L3 cache and MCE).

Instead of using new sysfs topology attributes the user can also
gather the node information from the shared_cpu_map of the L3
cache. That's not as straightforward as keeping all topology
information in one place but I can live with that.


Regards,
Andreas

-- 
Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


