Return-Path: <linux-kernel-owner+w=401wt.eu-S1762079AbXHONn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762079AbXHONn5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 09:43:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756771AbXHONnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 09:43:45 -0400
Received: from tayrelbas01.tay.hp.com ([161.114.80.244]:43281 "EHLO
	tayrelbas01.tay.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757200AbXHONnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 09:43:43 -0400
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
In-Reply-To: <Pine.LNX.4.64.0708141454110.32257@schroedinger.engr.sgi.com>
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
Content-Type: text/plain
Organization: HP/OSLO
Date: Wed, 15 Aug 2007 09:43:11 -0400
Message-Id: <1187185392.5422.13.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-08-14 at 14:56 -0700, Christoph Lameter wrote:
> On Tue, 14 Aug 2007, Lee Schermerhorn wrote:
> 
> > > Ok then you did not have a NUMA system configured. So its okay for the 
> > > dummies to ignore the stuff. CONFIG_NODES_SHIFT is a constant and does not 
> > > change. The first bit is always set.
> > 
> > The first bit [node 0] is only set for the N_ONLINE [and N_POSSIBLE]
> > mask.  We could add the static init for the other masks, but since
> > non-numa platforms are going through the __build_all_zonelists, they
> > might as well set the MEMORY bits explicitly.  Or, maybe you'll
> > disagree ;-).
> 
> The bitmaps can be completely ignored if !NUMA.
> 
> In the non NUMA case we define
> 
> static inline int node_state(int node, enum node_states state)
> {
>         return node == 0;
> }
> 
> So its always true for node 0. The "bit" is set.

The issue is with the N_*_MEMORY masks.  They don't get initialized
properly because node_set_state() is a no-op if !NUMA.  So, where we
look for intersections with or where we AND with the N_*_MEMORY masks we
get the empty set.

> 
> We are trying to get cpusets to work with !NUMA?


Well, yes.  In Serge's case, he's trying to use cpusets with !NUMA.
He'll have to comment on the reasons for that.  Looking at all of the
#ifdefs and init/Kconfig, CPUSET does not depend on NUMA--only SMP and
CONTAINERS [altho' methinks CPUSET should select CONTAINERS rather than
depend on it...].  So, you can use cpusets to partition of cpus in
non-NUMA configs.

In the more general case, tho', I'm looking at all uses of the
node_online_map and for_each_online_node, for instances where they
should be replaced with one of the *_MEMORY masks.  IMO, generic code
that is compiled independent of any CONFIG option, like NUMA,  should
just work, independent of the config.  Currently, as Serge has shown,
this is not the case.  So, I think we should fix the *_MEMORY maps to be
correctly populated in both the NUMA and !NUMA cases.  A couple of
options:

1) just use node_set() when populating the masks,

2) initialize all masks to include at least cpu/node 0 in the !NUMA
case.

Serge chose #1 to fix his problem.  I followed his lead to fix the other
2 places where node_set_state() was being used to initialize the NORMAL
memory node mask and the CPU node mask.  This will add a few unnecessary
instructions to !NUMA configs, so we could change to #2.

Thoughts?

Lee

