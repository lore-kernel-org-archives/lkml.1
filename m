Return-Path: <linux-kernel-owner+w=401wt.eu-S1754227AbZDYItX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227AbZDYItX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 04:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752063AbZDYItM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 04:49:12 -0400
Received: from mga14.intel.com ([143.182.124.37]:31921 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753432AbZDYItJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 04:49:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,245,1239001200"; 
   d="scan'208";a="135810184"
Date: Sat, 25 Apr 2009 16:48:04 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
       Badari Pulavarty <pbadari@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Vivek Kashyap <vivk@us.ibm.com>, Mel Gorman <mel@linux.vnet.ibm.com>,
       Robert MacFarlan <Robert_MacFarlan@us.ibm.com>,
       "Fu, Michael" <michael.fu@intel.com>
Subject: Re: Large Pages - Linux Foundation HPC
Message-ID: <20090425084804.GA517@localhost>
References: <1240331533.32731.2.camel@badari-desktop> <1240333025.32604.392.camel@nimitz> <20090421182555.GA8977@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090421182555.GA8977@balbir.in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 21, 2009 at 11:55:55PM +0530, Balbir Singh wrote:
> [Fix my email address to balbir@linux.vnet.ibm.com]
> 
> * Dave Hansen <dave@linux.vnet.ibm.com> [2009-04-21 09:57:05]:
> > On Tue, 2009-04-21 at 09:32 -0700, Badari Pulavarty wrote:
> > > Hi Dave,
> > > 
> > > On the Linux foundation HPC track summary, I saw:
> > > 
> > > -- Memory and interface to it - mapping memory into apps
> > >      - large pages important - current state not good enough
> > 
> > I'm not sure exactly what this means.  But, there was continuing concern
> > about large page interfaces.  hugetlbfs is fine, but it still requires
> > special tools, planning, and requires some modification of the app.  We
> > can modify it with linker tricks or with LD_PRELOAD, but those certainly
> > don't work everywhere.  I was told over and over again that hugetlbfs
> > isn't a sufficient interface for large pages, no matter how much
> > userspace we try to stick in front of it.
> > 
> > Some of their apps get a 6-7x speedup from large pages!
> > 
> > Fragmentation also isn't an issue for a big chunk of the users since
> > they reboot between each job.

Perhaps this policy?

In mlock(), populate huge pages if (1) the mlock range is large enough
to hold some huge pages; (2) there are more than enough free high
order pages.

Based on Dave's descriptions that HPC apps typically
- do mlock(), to pre-populate memory and pin them in memory
- run at fresh boot, with loads of high order pages available

Thanks,
Fengguang

> > > nodes going down due to memory exhaustion
> > 
> > Virtually all the apps in an HPC environment start up try to use all the
> > memory they can get their hands on.  With strict overcommit on, that
> > probably means brk() or mmap() until they fail.  They also usually
> > mlock() anything they're able to allocate.  Swapping is the devil to
> > them. :)
> > 
> > Basically, what all the apps do is a recipe for stressing the VM and
> > triggering the OOM killer.  Most of the users simply hack the kernel and
> > replace the OOM killer with one that fits their needs.  Some have an
> > attitude that "the user's app should never die" and others "the user
> > caused this, so kill their app".  Basically, there's no way to make
> > everyone happy since they have conflicting requirements.  But, this is
> > true of the kernel in general... nothing special here.
> 
> OOM killer has been a hot topic. Have you seen Dan Malek's patches at
> http://lkml.org/lkml/2009/4/13/276.
> 
> > 
> > The split LRU should help things.  It will at least make our memory
> > scanning more efficient and ensure we're making more efficient reclaim
> > progress.  I'm not sure that anyone there knew about the oom_adjust and
> > oom_score knobs in /proc.  They do now. :)
> 
> :-)
> 
> > 
> > One of my suggestions was to use the memory resource controller.  They
> > could give each app 95% (or whatever) of the system.  This should let
> > them keep their current "consume all memory" behavior, but stop them at
> > sane limits.
> > 
> 
> Soft limits should help as well, basically we are trying to allow
> unrestricted memory access until there is contention. The patches are
> still under development.
> 
> > That leads into another issue, which is the "wedding cake" software
> > stack.  There are a lot of software dependencies both in and out of the
> > kernel.  It is hard to change individual components, especially in the
> > lower levels.  This leads many of the users to use old (think 2.6.9)
> > kernels.  Nobody runs mainline, of course.
> > 
> > Then, there's Lustre.  Everybody uses it, it's definitely a big hunk of
> > the "wedding cake".  I haven't seen any LKML postings on it in years and
> > I really wonder how it interacts with the VM.  No idea.
> > 
> > There's a "Hyperion cluster" which is for testing new HPC software on a
> > decently sized cluster.  One suggestion of ours was to try and get
> > mainline tested on this every so often to look for regressions since
> > we're not able to glean feedback from 2.6.9 kernel users.  We'll see
> > where that goes. 
> > 
> > > checkpoint/restart
> > 
> > Many of the MPI implementations have mechanisms in userspace for
> > checkpointing of user jobs.  Most cluster administrators instruct their
> > users to use these mechanisms.  Some do.  Most don't.
> >
> 
> Good inputs and summary. Thanks! 
> 
> -- 
> 	Balbir
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
