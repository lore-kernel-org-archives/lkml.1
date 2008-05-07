Return-Path: <linux-kernel-owner+w=401wt.eu-S1759955AbYEGCMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759955AbYEGCMd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 22:12:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752711AbYEGCMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 22:12:25 -0400
Received: from mga10.intel.com ([192.55.52.92]:20637 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752440AbYEGCMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 22:12:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,445,1204531200"; 
   d="scan'208";a="325262154"
Subject: Re: AIM7 40% regression with 2.6.26-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Matthew Wilcox <matthew@wil.cx>, LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080506114449.GC32591@elte.hu>
References: <1210052904.3453.30.camel@ymzhang>
	 <20080506114449.GC32591@elte.hu>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 07 May 2008 10:11:26 +0800
Message-Id: <1210126286.3453.37.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-05-06 at 13:44 +0200, Ingo Molnar wrote:
> * Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:
> 
> > Comparing with kernel 2.6.25, ﻿AIM7 (use tmpfs) has ﻿more than 40% with 
> > 2.6.26-rc1 on my 8-core stoakley, 16-core tigerton, and Itanium 
> > Montecito. Bisect located below patch.
> > 
> > 64ac24e738823161693bf791f87adc802cf529ff is first bad commit
> > commit 64ac24e738823161693bf791f87adc802cf529ff
> > Author: Matthew Wilcox <matthew@wil.cx>
> > Date:   Fri Mar 7 21:55:58 2008 -0500
> > 
> >     Generic semaphore implementation
> > 
> > After I manually reverted the patch against 2.6.26-rc1 while fixing 
> > lots of conflictions/errors, aim7 regression became less than 2%.
> 
> hm, which exact semaphore would that be due to?
> 
> My first blind guess would be the BKL - there's not much other semaphore 
> use left in the core kernel otherwise that would affect AIM7 normally. 
> The VFS still makes frequent use of the BKL and AIM7 is very VFS 
> intense. Getting rid of that BKL use from the VFS might be useful to 
> performance anyway.
> 
> Could you try to check that it's indeed the BKL?
> 
> Easiest way to check it would be to run AIM7 it on 
> sched-devel.git/latest and do scheduler tracing via:
> 
>    http://people.redhat.com/mingo/sched-devel.git/readme-tracer.txt
Thank you guys for the quick response. I ran into many regressions with 2.6.26-rc1, but
just reported 2 of them because I located the patches. My machine is locating the root cause
of 30% regression of sysbench+mysql(oltp readonly) now. Bisect is not so qucik because either
kernel hang with testing or compilation fails.

Another specjbb2005 on Montvale is also under investigation.

Let me figure out how to clone your tree quickly as the network speed is very slow.

One clear weird behavior of aim7 is cpu idle is 0% with 2.6.25, but is more than 50% with
2.6.26-rc1. I have a patch to collect schedule info.

> 
> by doing:
> 
>    echo stacktrace > /debug/tracing/iter_ctl
> 
> you could get exact backtraces of all scheduling points in the trace. If 
> the BKL's down() shows up in those traces then it's definitely the BKL 
> that causes this. The backtraces will also tell us exactly which BKL use 
> is the most frequent one.
> 
> To keep tracing overhead low on SMP i'd also suggest to only trace a 
> single CPU, via:
> 
>   echo 1 > /debug/tracing/tracing_cpumask
> 
> 	Ingo

