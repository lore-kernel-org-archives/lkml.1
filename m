Return-Path: <linux-kernel-owner+w=401wt.eu-S966847AbXEGUyP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966847AbXEGUyP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 16:54:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966588AbXEGUyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 16:54:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:6926 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966408AbXEGUyH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 16:54:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,502,1170662400"; 
   d="scan'208";a="240437744"
Subject: Re: [patch] CFS scheduler, -v8
From: "Li, Tong N" <tong.n.li@intel.com>
To: vatsa@in.ibm.com
CC: William Lee Irwin III <wli@holomorphy.com>,
       Damien Wyart <damien.wyart@free.fr>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
In-Reply-To: <20070507142257.GA633@in.ibm.com>
References: <46399B51.9040608@dunaweb.hu> <20070503130201.GA9000@elte.hu>
	 <20070503132932.GA4204@localhost.localdomain>
	 <20070503145318.GA17776@in.ibm.com> <20070503155347.GF19966@holomorphy.com>
	 <20070507142257.GA633@in.ibm.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 7 May 2007 13:54:04 -0700
Message-ID: <1178571244.3283.31.camel@tongli.jf.intel.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
X-OriginalArrivalTime: 07 May 2007 20:54:05.0904 (UTC) FILETIME=[D9CA4500:01C790E9]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-07 at 19:52 +0530, Srivatsa Vaddagiri wrote:
> On Thu, May 03, 2007 at 08:53:47AM -0700, William Lee Irwin III wrote:
> > On Thu, May 03, 2007 at 08:23:18PM +0530, Srivatsa Vaddagiri wrote:
> > > And what about group scheduling extensions? Do you have plans to work on
> > > it? I was begining to work on a prototype to do group scheduling based
> > > on CFS, basically on the lines of what you and Linus had outlined
> > > earlier:
> > > 	http://lkml.org/lkml/2007/4/18/271
> > > 	http://lkml.org/lkml/2007/4/18/244
> > 
> > Tong Li's Trio scheduler does a bit of this, though it doesn't seem to
> > have the mindshare cfs seems to have acquired.
> > 
> > The hyperlink seems to have broken, though:
> > 	http://www.cs.duke.edu/~tongli/linux/linux-2.6.19.2-trio.patch
> 
> The big question I have is, how well does DWRR fits into the "currently hot" 
> scheduling frameworks like CFS? For ex: if the goal is to do
> fair (group) scheduling of SCHED_NORMAL tasks, can CFS and DWRR co-exist?
> Both seem to be radically different algorithms and my initial impressions 
> of them co-existing is "No", but would be glad to be corrected if I am
> wrong. If they can't co-exist, then we need a different way of doing
> group scheduling on top of CFS, as that is gaining more popularity on
> account of better handling of interactivity.

Yeah, the intent of DWRR was to provide proportional fairness and rely
on the underlying scheduler to support interactivity. In a way, DWRR
ensures that each task receives its fair share, while the underlying
scheduler determines the right order to run the tasks. Since SD is
structurally similar to the stock scheduler, DWRR should co-exist with
it easily. Co-existing with CFS requires more work, but I think the
round-robin mechanism in DWRR could be applicable to CFS to facilitate
cross-processor fairness.

> Tong,
> 	I understand a center hallmark of DWRR is SMP fairness.
> Have you considered how bad/good the other alternative to achieve SMP fairness 
> which is in vogue today : pressure/weight based balancing (ex: smpnice and 
> CKRM CPU scheduler - ckrm.sourceforge.net/downloads/ckrm-ols03-slides.pdf)?
> 

The disadvantage of DWRR is its potential overhead and the advantage is
it can provide stronger fairness. If we have 2 processors and 3 tasks,
DWRR ensures that each task gets 66% of the total CPU time, while
smpnice would keep two tasks on the same processor and the third one on
another. I did an analysis and showed that the lag bound of DWRR is
constant if task weights are bounded by a constant. On the other hand,
the cost DWRR pays is that it requires more task migrations. I tested
with a set of benchmarks on an SMP and didn't see migrations were
causing much performance impact, but this is certainly a big issue for
NUMA.

  tong

PS. I'm now porting the code to the latest kernel and will post as soon
as I'm done.
