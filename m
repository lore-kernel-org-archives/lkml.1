Return-Path: <linux-kernel-owner+w=401wt.eu-S1751776AbZH1Kjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776AbZH1Kjs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 06:39:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751451AbZH1Kjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 06:39:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:50736 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbZH1Kjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 06:39:47 -0400
Subject: Re: [PATCH 15/15] x86: Fix cpu_coregroup_mask to return correct
 cpumask on multi-node processors
From: Peter Zijlstra <peterz@infradead.org>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <20090827152551.GE13576@alberich.amd.com>
References: <20090820131243.GO29327@alberich.amd.com>
	 <20090820134604.GD29327@alberich.amd.com> <1251128176.7538.301.camel@twins>
	 <20090825093101.GJ20811@alberich.amd.com>
	 <1251194143.7538.1128.camel@twins>
	 <20090827152551.GE13576@alberich.amd.com>
Content-Type: text/plain
Date: Fri, 28 Aug 2009 12:39:44 +0200
Message-Id: <1251455984.17617.5.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-27 at 17:25 +0200, Andreas Herrmann wrote:
> On Tue, Aug 25, 2009 at 11:55:43AM +0200, Peter Zijlstra wrote:
> > On Tue, 2009-08-25 at 11:31 +0200, Andreas Herrmann wrote:
> > > On Mon, Aug 24, 2009 at 05:36:16PM +0200, Peter Zijlstra wrote:
> > > > On Thu, 2009-08-20 at 15:46 +0200, Andreas Herrmann wrote:
> > > > > The correct mask that describes core-siblings of an processor
> > > > > is topology_core_cpumask. See topology adapation patches, especially
> > > > > http://marc.info/?l=linux-kernel&m=124964999608179
> > > > 
> > > > 
> > > > argh, violence, murder kill.. this is the worst possible hack and you're
> > > > extending it :/
> > > 
> > > So this is the third code area
> > > (besides sched_*_power_savings sysfs interface, and the __cpu_power fiddling)
> > > that is crap, mess, a hack.
> > > 
> > > Didn't know that I'd enter such a minefield when touching this code. ;-(
> > 
> > Yeah, you're lucky that way ;-) Its been creaking for a while, and I've
> > been making noises to the IBM people (who so far have been the main
> > source of power saving patches) to clean this up, but now you trod onto
> > all of it at once..
> > 
> > > What would be your perferred solution for the
> > > core_cpumask/llc_shared_map stuff?  Another domain level to get rid of
> > > this function?
> > 
> > Right, I'd like to see everything exposed as domain levels.
> > 
> > 
> > numa-cluster
> > numa
> > socket
> > in-socket-numa
> > multi-core
> > shared-cache
> > core
> > threads
> 
> Out of curiosity, when does cpu_core_mask differ from llc_shared_map
> on Intel? Only in case of MCM (e.g. Core2 Quad)?

Yes, I think both c2q and some dual-core opteron have multiple cache
domains per socket.

> If yes, the hackery of cpu_coregroup_mask() could be replace by
> the domain that I'd like to introduce for Magny-Cours:
> 
>   MC domain span would represent one die.
>   The new domain would span all dies in an MCM.
> 
> Bad idea?

No, I think all the mentioned chips have the multi-die thing in common,
the intel c2q has 2 dual-core dies, the opteron I have seems to be two
single cores and this magny thing has 2 many cores -- teh pun, sides
aching :-)

So the generalization to dies per socket seems sensible.



