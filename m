Return-Path: <linux-kernel-owner+w=401wt.eu-S1751941AbZIQKfO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941AbZIQKfO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 06:35:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751483AbZIQKfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 06:35:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42513 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920AbZIQKfM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 06:35:12 -0400
Date: Thu, 17 Sep 2009 12:35:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: aim7 scalability issue on 4 socket machine
Message-ID: <20090917103502.GA18210@elte.hu>
References: <1253179879.2606.37.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253179879.2606.37.camel@ymzhang>
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


* Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:

> ???Aim7 result is bad on my new Nehalem machines (4*8*2 logical cpu). 
> Perf counter shows spinlock consumes 70% cpu time on the machine. 
> Lock_stat shows anon_vma->lock causes most of the spinlock contention. 
> Function tracer shows below call chain creates the spinlock.
> 
> do_brk => vma_merge =>vma_adjust
> 
> Aim7 consists of lots of subtests. One test is to fork lots of 
> processes and every process calls sbrk for 1000 times to grow/shrink 
> the heap. All the vma of the heap of all sub-processes point to the 
> same anon_vma and use the same anon_vma->lock. When sbrk is called, 
> kernel calls do_brk => vma_merge =>vma_adjust and lock anon_vma->lock 
> to create spinlock contentions.
> 
> There is a comment section in front of spin_lock(&anon_vma->lock. It 
> says anon_vma lock can be optimized when just changing vma->vm_end. As 
> a matter of fact, anon_vma->lock is used to protect anon_vma->list 
> when an entry is deleted/inserted or the list is accessed. There is no 
> such deletion/insertion if only vma->end is changed in function 
> vma_adjust.
> 
> Below patch fixes it.
> 
> Test results with kernel 2.6.31-rc8. The improvement on the machine is 
> about 150%.

Impressive speedup!

[ Also, the array of tools you used to debug this is impressive as well
  ;-) ]

	Ingo
