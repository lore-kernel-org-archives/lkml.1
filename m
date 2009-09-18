Return-Path: <linux-kernel-owner+w=401wt.eu-S1753494AbZIRDQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494AbZIRDQr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 23:16:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751518AbZIRDQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 23:16:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:62304 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392AbZIRDQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 23:16:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,407,1249282800"; 
   d="scan'208";a="449540022"
Subject: Re: aim7 scalability issue on 4 socket machine
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Andi Kleen <andi@firstfloor.org>,
       "lee.schermerhorn@hp.com" <lee.schermerhorn@hp.com>
In-Reply-To: <20090917195909.3a00ef83.akpm@linux-foundation.org>
References: <1253179879.2606.37.camel@ymzhang>
	 <1253180411.8497.1.camel@twins>
	 <Pine.LNX.4.64.0909171122180.25864@sister.anvils>
	 <1253239339.2606.40.camel@ymzhang>
	 <20090917195909.3a00ef83.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Date: Fri, 18 Sep 2009 11:17:57 +0800
Message-Id: <1253243877.2606.46.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-17 at 19:59 -0700, Andrew Morton wrote:
> On Fri, 18 Sep 2009 10:02:19 +0800 "Zhang, Yanmin" <yanmin_zhang@linux.intel.com> wrote:
> 
> > > > Did you see Lee's patch?:
> > > > 
> > > >  http://lkml.org/lkml/2009/9/9/290
> > > > 
> > > > Added Lee and Hugh to CC, retained the below patch for them.
> > > 
> > > Thanks a lot for the CC, Peter.
> > > See my reply to that mail for the slightly corrected version.
> > > 
> > > Yes, Yanmin and Lee appear to be fixing exactly the same issue.
> > > I haven't thought through Yanmin's version for correctness, but
> > > it lacks the vm_start check I added to Lee's, and I do prefer
> > > Lee's style - hey, nothing personal!
> > > 
> > > So, Yanmin, please retest with http://lkml.org/lkml/2009/9/13/25
> > > and let us know if that works as well for you - thanks.
> > I tested Lee's patch and it does fix the issue.
> 
> Do we think we should cook up something for -stable?
It's better to have a patch for -stable.

> 
> Either this is a regression or the workload is particularly obscure. 
This issue is not clear on dual socket Nehalem machine (2*4*2 cpu), but
is severe on large machine (4*8*2 cpu).

> 
> aim7 is sufficiently non-obscure to make me wonder what's happened here?
I copy previous content below:

﻿Aim7 consists of lots of subtests. One test is to fork lots of processes and
every process calls sbrk for 1000 times to grow/shrink the heap. All the vma of
the heap of all sub-processes point to the same anon_vma and use the same
anon_vma->lock. When sbrk is called, kernel calls do_brk => vma_merge =>vma_adjust
and lock anon_vma->lock to create spinlock contentions.

