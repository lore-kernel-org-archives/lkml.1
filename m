Return-Path: <linux-kernel-owner+w=401wt.eu-S1161035AbXEDRMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161035AbXEDRMV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 13:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031437AbXEDRMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 13:12:21 -0400
Received: from atlrel9.hp.com ([156.153.255.214]:50000 "EHLO atlrel9.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031435AbXEDRMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 13:12:18 -0400
Subject: Re: [PATCH] change global zonelist order v4 [0/2]
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
       Christoph Lameter <clameter@sgi.com>,
       Eric Whitney <eric.whitney@hp.com>
In-Reply-To: <20070503224730.3bc6f8a8.akpm@linux-foundation.org>
References: <20070427144530.ae42ee25.kamezawa.hiroyu@jp.fujitsu.com>
	 <20070503224730.3bc6f8a8.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: HP/OSLO
Date: Fri, 04 May 2007 13:12:08 -0400
Message-Id: <1178298729.5236.33.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-03 at 22:47 -0700, Andrew Morton wrote:
> On Fri, 27 Apr 2007 14:45:30 +0900 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > Hi, this is version 4. including Lee Schermerhon's good rework.
> > and automatic configuration at boot time.
> 
> hm, this adds rather a lot of code.  Have we established that it's worth
> it?

See below.  Something is needed here on some platforms.  The current
zonelist ordering results in some unfortunate behavior on some
platforms.


> 
> And it's complex - how do poor users know what to do with this new control?
> 
Kame's autoconfig seems to be doing the right thing for our platform.
Might not be the case for other platforms, or some workloads on them.  I
suppose the documentation in sysctl.txt could be expanded to describe
when you might want to select a non-default setting, should we decide to
provide that capability.

> 
> This:
> 
> + *	= "[dD]efault | "0"	- default, automatic configuration.
> + *	= "[nN]ode"|"1" 	- order by node locality,
> + *         			  then zone within node.
> + *	= "[zZ]one"|"2" - order by zone, then by locality within zone
> 
> seems a bit excessive.  I think just the 0/1/2 plus documentation would
> suffice?

I agree, but I was considering dropping the "0/1/2" in favor of the more
descriptive [IMO] values ;-).

> 
> 
> I haven't followed this discussion very closely I'm afraid.  If we came up
> with a good reason why Linux needs this feature then could someone please
> (re)describe it?

Kame originally described the need for it in:

	http://marc.info/?l=linux-mm&m=117747120307559&w=4

I chimed in with support as we have a similar need for our cell-based
ia64 platforms:

	http://marc.info/?l=linux-mm&m=117760331328012&w=4

I can easily consume all of DMA on our platforms [configured as 100%
"cell local memory" -- always leaves some "cache-line interleaved" at
phys addr zero => ZONE_DMA] by allocating, e.g., a shared memory segment
of size > 1 node's memory + size of ZONE_DMA.  This occurs because the
node containing zone DMA is always 2nd in a zone's ZONE_NORMAL zonelist
[after the zone itself, assuming it has memory].  Then, any driver that
requests memory from ZONE_DMA will be denied, resulting in IO errors,
death of hald [maybe that's a feature? ;-)], ...

I guess I would be happy with Kame's V3 patch that unconditionally
changes the order to be zone first--i.e., ZONE_NORMAL for all nodes
before ZONE_DMA*:

	http://marc.info/?l=linux-mm&m=117758484122663&w=4

However, this patch apparently crossed in the mail with Christoph's
observation that making the new order [zone order] the default w/o any
option wouldn't be appropriate for some configurations:

	http://marc.info/?l=linux-mm&m=117760245022005&w=4

Meanwhile, I was factoring out common code in Kame's V1/V2 patch and
adding the "excessive" user interface to the boot parameter/sysctl.
After some additional rework, Kame posted this a V4--the one you're
questioning.

If we decide to proceed with this, I have another "cleanup" patch that
eliminates some redundant "estimating of zone order" [autoconfig] and
reports what order was chosen in the "Build %d zonelists..." message.


Lee

