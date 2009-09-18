Return-Path: <linux-kernel-owner+w=401wt.eu-S1754046AbZIRCBL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbZIRCBL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 22:01:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751832AbZIRCBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 22:01:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:35827 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751825AbZIRCBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 22:01:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,406,1249282800"; 
   d="scan'208";a="449524548"
Subject: Re: aim7 scalability issue on 4 socket machine
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       "lee.schermerhorn@hp.com" <lee.schermerhorn@hp.com>
In-Reply-To: <Pine.LNX.4.64.0909171122180.25864@sister.anvils>
References: <1253179879.2606.37.camel@ymzhang>
	 <1253180411.8497.1.camel@twins>
	 <Pine.LNX.4.64.0909171122180.25864@sister.anvils>
Content-Type: text/plain
Date: Fri, 18 Sep 2009 10:02:19 +0800
Message-Id: <1253239339.2606.40.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-17 at 11:35 +0100, Hugh Dickins wrote:
> On Thu, 17 Sep 2009, Peter Zijlstra wrote:
> > On Thu, 2009-09-17 at 17:31 +0800, Zhang, Yanmin wrote:
> > > Aim7 result is bad on my new Nehalem machines (4*8*2 logical cpu). Perf counter
> > > shows spinlock consumes 70% cpu time on the machine. Lock_stat shows
> > > anon_vma->lock causes most of the spinlock contention. Function tracer shows
> > > below call chain creates the spinlock.
> > > 
> > > do_brk => vma_merge =>vma_adjust
> > > 
> > > Aim7 consists of lots of subtests. One test is to fork lots of processes and
> > > every process calls sbrk for 1000 times to grow/shrink the heap. All the vma of
> > > the heap of all sub-processes point to the same anon_vma and use the same
> > > anon_vma->lock. When sbrk is called, kernel calls do_brk => vma_merge =>vma_adjust
> > > and lock anon_vma->lock to create spinlock contentions.
> > > 
> > > There is a comment section in front of spin_lock(&anon_vma->lock. It says
> > > anon_vma lock can be optimized when just changing vma->vm_end. As a matter
> > > of fact, anon_vma->lock is used to protect anon_vma->list when an entry is
> > > deleted/inserted or the list is accessed. There is no such deletion/insertion
> > > if only vma->end is changed in function vma_adjust.
> > > 
> > > Below patch fixes it.
> > > 
> > > Test results with kernel 2.6.31-rc8. The improvement on the machine is about 150%.
> > 
> > Did you see Lee's patch?:
> > 
> >  http://lkml.org/lkml/2009/9/9/290
> > 
> > Added Lee and Hugh to CC, retained the below patch for them.
> 
> Thanks a lot for the CC, Peter.
> See my reply to that mail for the slightly corrected version.
> 
> Yes, Yanmin and Lee appear to be fixing exactly the same issue.
> I haven't thought through Yanmin's version for correctness, but
> it lacks the vm_start check I added to Lee's, and I do prefer
> Lee's style - hey, nothing personal!
> 
> So, Yanmin, please retest with http://lkml.org/lkml/2009/9/13/25
> and let us know if that works as well for you - thanks.
I tested Lee's patch and it does fix the issue.

Yanmin


