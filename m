Return-Path: <linux-kernel-owner+w=401wt.eu-S936276AbXHOUtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936276AbXHOUtt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 16:49:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934954AbXHOUtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 16:49:23 -0400
Received: from tayrelbas04.tay.hp.com ([161.114.80.247]:41005 "EHLO
	tayrelbas04.tay.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934692AbXHOUtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 16:49:20 -0400
Subject: Re: Regression in 2.6.23-rc2-mm2, mounting cpusets causes a hang
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, bob.picco@hp.com,
       nacc@us.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, mel@skynet.ie,
       akpm@linux-foundation.org, Balbir Singh <balbir@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       ckrm-tech <ckrm-tech@lists.sourceforge.net>
In-Reply-To: <Pine.LNX.4.64.0708151333230.7628@schroedinger.engr.sgi.com>
References: <20070812152126.GA26239@linux.vnet.ibm.com>
	 <20070813201215.GA16908@vino.hallyn.com>
	 <1187103831.6281.24.camel@localhost>
	 <20070814180339.GA32553@vino.hallyn.com>
	 <1187115224.6281.40.camel@localhost>
	 <20070814192306.GB32553@vino.hallyn.com>
	 <20070814204951.GA2065@vino.hallyn.com>
	 <Pine.LNX.4.64.0708141427150.31693@schroedinger.engr.sgi.com>
	 <1187127685.6281.139.camel@localhost>
	 <Pine.LNX.4.64.0708141454110.32257@schroedinger.engr.sgi.com>
	 <1187185392.5422.13.camel@localhost>
	 <Pine.LNX.4.64.0708151333230.7628@schroedinger.engr.sgi.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Wed, 15 Aug 2007 16:48:13 -0400
Message-Id: <1187210893.5422.60.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-15 at 13:36 -0700, Christoph Lameter wrote:
> On Wed, 15 Aug 2007, Lee Schermerhorn wrote:
> 
> > > So its always true for node 0. The "bit" is set.
> > 
> > The issue is with the N_*_MEMORY masks.  They don't get initialized
> > properly because node_set_state() is a no-op if !NUMA.  So, where we
> > look for intersections with or where we AND with the N_*_MEMORY masks we
> > get the empty set.
> 
> That is intentional. Memory is always present if you are on !NUMA. You can 
> simply use a default nodemask where only node 0 is set. That is what the 
> fallback provides. Maybe it does not provide the right thing for cpusets?
> 
> > > We are trying to get cpusets to work with !NUMA?
> > 
> > Well, yes.  In Serge's case, he's trying to use cpusets with !NUMA.
> > He'll have to comment on the reasons for that.  Looking at all of the
> > #ifdefs and init/Kconfig, CPUSET does not depend on NUMA--only SMP and
> > CONTAINERS [altho' methinks CPUSET should select CONTAINERS rather than
> > depend on it...].  So, you can use cpusets to partition of cpus in
> > non-NUMA configs.
> 
> Looks like we need to fix cpuset nodemasks for the !NUMA case then?
> It cannot expect to find valid nodemasks if !NUMA.

Well, OK.  But Paul really hates #ifdefs in kernel/cpusets.c.  He's
asked me to remove them before, so I avoided them here.  Cpusets really
should use only nodes with memory--i.e., the N_HIGH_MEMORY state.  

> 
> > In the more general case, tho', I'm looking at all uses of the
> > node_online_map and for_each_online_node, for instances where they
> > should be replaced with one of the *_MEMORY masks.  IMO, generic code
> > that is compiled independent of any CONFIG option, like NUMA,  should
> > just work, independent of the config.  Currently, as Serge has shown,
> 
> AFAIK this works except for cpusets.

So far.  I'm replacing other usage of node_online_map with the
N_HIGH_MEMORY mask, as we discussed.  I should have that patch ready to
post tomorrow.

> 
> > this is not the case.  So, I think we should fix the *_MEMORY maps to be
> > correctly populated in both the NUMA and !NUMA cases.  A couple of
> > options:
> 
> There is no point in having a variable if you know the results because of 
> !NUMA. That is the way nodemask.h has always operated.

But, the mask--the N_HIGH_MEMORY array element, that is--is there for
both NUMA and !NUMA [== N_NORMAL_MEMORY for !CONFIG_HIGHMEM].  We just
don't initialize it for the !NUMA case, currently.  

> 
> > Thoughts?
> 
> Lets get either rid of the definitions for the nodemasks in the !NUMA 
> case or fix their contents to have the right constant value expected in 
> cpusets.

That's what the patch I posted today [option 2] does--statically
initializes the N_*_MEMORY and N_CPU masks to indicate that node 0
exists.  Serge and Dhaval have tested it on their platform and it solves
the cpuset mount problem.

Lee

