Return-Path: <linux-kernel-owner+w=401wt.eu-S1760363AbYEHJNc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760363AbYEHJNc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 05:13:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755429AbYEHJNY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 05:13:24 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:3342 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755365AbYEHJNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 05:13:23 -0400
X-SourceIP: 80.56.237.116
Subject: Re: sysbench+mysql(oltp, readonly) 30% regression with 2.6.26-rc1
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1210237267.3453.143.camel@ymzhang>
References: <1210136148.3453.59.camel@ymzhang>
	 <1210177575.6525.4.camel@lappy.programming.kicks-ass.net>
	 <1210228531.3453.124.camel@ymzhang>
	 <1210233617.4895.6.camel@marge.simson.net>
	 <1210237267.3453.143.camel@ymzhang>
Content-Type: text/plain; charset=utf-8
Date: Thu, 08 May 2008 11:13:18 +0200
Message-Id: <1210237998.13978.189.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-08 at 17:01 +0800, Zhang, Yanmin wrote:
> On Thu, 2008-05-08 at 10:00 +0200, Mike Galbraith wrote:
> > On Thu, 2008-05-08 at 14:35 +0800, Zhang, Yanmin wrote: 
> > > On Wed, 2008-05-07 at 18:26 +0200, Peter Zijlstra wrote: 
> > > > On Wed, 2008-05-07 at 12:55 +0800, Zhang, Yanmin wrote:
> > > > > ﻿Comparing with kernel 2.6.25, sysbench+mysql(oltp, readonly) has many
> > > > > regression with 2.6.26-rc1.
> > > > > 
> > > > > 1) 8-core stoakley: 28%;
> > > > > 2) 16-core tigerton: 20%;
> > > > > 3) Itanium Montvale: 50%.
> > > > > 
> > > > > Bisect located below patch.
> > > > > 
> > > > > 8f1bc385cfbab474db6c27b5af1e439614f3025c is first bad commit
> > > > > commit 8f1bc385cfbab474db6c27b5af1e439614f3025c
> > > > > Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > > > Date:   Sat Apr 19 19:45:00 2008 +0200
> > > > > 
> > > > >     sched: fair: weight calculations
> > > > >     
> > > > >     In order to level the hierarchy, we need to calculate load based on the
> > > > >     root view. That is, each task's load is in the same unit.
> > > > > 
> > > > > 
> > > > > 
> > > > > After I manually reverted the patch against 2.6.26-rc1 while fixing a couple of
> > > > > conflictions/errors, sysbench oltp regression became less than 3% on 8-core
> > > > > stoakley.
> > > > 
> > > > Does this patch help?
> > > With the patch, oltp testing result is about 50% worse than the one of pure
> > > 2.6.26-rc1.
> > 
> > Hm.  I was doing some sysbench+postgress(oltp, ro) testing on my little
> > Q6600 box this morning, and saw a different picture.
> How many cpu are in the Q6600?

That's an Intel Quad core (Kentsfield).

> > In attached pdf, .bkl refers to Linus' BKL patch, .weight is the weight
> > fix, both are applied to git.today.  The script I used is also attached.
> With my 8-core stoakley (using mysql):
> 1) 2.6.25:
> Number of threads: 6
>     read/write requests:                 8025024 (66874.53 per sec.)
> Number of threads: 8
>     read/write requests:                 9132816 (76106.14 per sec.)
> Number of threads: 10
>     read/write requests:                 9244998 (77040.75 per sec.)
> Number of threads: 12
>     read/write requests:                 8994174 (74950.36 per sec.)
> Number of threads: 14
>     read/write requests:                 9051322 (75426.54 per sec.)
> Number of threads: 16
>     read/write requests:                 9015412 (75126.93 per sec.)
> 
> 2) 2.6.26-rc1:
> Number of threads: 6
>     read/write requests:                 5754056 (47949.87 per sec.)
> Number of threads: 8
>     read/write requests:                 6528480 (54403.29 per sec.)
> Number of threads: 10
>     read/write requests:                 6444690 (53705.16 per sec.)
> Number of threads: 12
>     read/write requests:                 6544258 (54534.23 per sec.)
> Number of threads: 14
>     read/write requests:                 6796650 (56637.65 per sec.)
> Number of threads: 16
>     read/write requests:                 6718110 (55983.18 per sec.)
> 
> 3) 2.6.26-rc1+weight
> ﻿Number of threads: 16
> 	read/write requests:                 3219076 (26824.22 per sec.)
> 
> I'm not sure if more cpu could introduce more contention in this test.

those numbers make me sad :-(

