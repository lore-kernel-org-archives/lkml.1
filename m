Return-Path: <linux-kernel-owner+w=401wt.eu-S1755966AbYEFLpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966AbYEFLpU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 07:45:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752181AbYEFLpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 07:45:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38941 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751984AbYEFLpH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 07:45:07 -0400
Date: Tue, 6 May 2008 13:44:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Matthew Wilcox <matthew@wil.cx>, LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: AIM7 40% regression with 2.6.26-rc1
Message-ID: <20080506114449.GC32591@elte.hu>
References: <1210052904.3453.30.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1210052904.3453.30.camel@ymzhang>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:

> Comparing with kernel 2.6.25, ﻿AIM7 (use tmpfs) has ﻿more than 40% with 
> 2.6.26-rc1 on my 8-core stoakley, 16-core tigerton, and Itanium 
> Montecito. Bisect located below patch.
> 
> 64ac24e738823161693bf791f87adc802cf529ff is first bad commit
> commit 64ac24e738823161693bf791f87adc802cf529ff
> Author: Matthew Wilcox <matthew@wil.cx>
> Date:   Fri Mar 7 21:55:58 2008 -0500
> 
>     Generic semaphore implementation
> 
> After I manually reverted the patch against 2.6.26-rc1 while fixing 
> lots of conflictions/errors, aim7 regression became less than 2%.

hm, which exact semaphore would that be due to?

My first blind guess would be the BKL - there's not much other semaphore 
use left in the core kernel otherwise that would affect AIM7 normally. 
The VFS still makes frequent use of the BKL and AIM7 is very VFS 
intense. Getting rid of that BKL use from the VFS might be useful to 
performance anyway.

Could you try to check that it's indeed the BKL?

Easiest way to check it would be to run AIM7 it on 
sched-devel.git/latest and do scheduler tracing via:

   http://people.redhat.com/mingo/sched-devel.git/readme-tracer.txt

by doing:

   echo stacktrace > /debug/tracing/iter_ctl

you could get exact backtraces of all scheduling points in the trace. If 
the BKL's down() shows up in those traces then it's definitely the BKL 
that causes this. The backtraces will also tell us exactly which BKL use 
is the most frequent one.

To keep tracing overhead low on SMP i'd also suggest to only trace a 
single CPU, via:

  echo 1 > /debug/tracing/tracing_cpumask

	Ingo
