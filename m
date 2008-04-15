Return-Path: <linux-kernel-owner+w=401wt.eu-S1763113AbYDOUk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763113AbYDOUk7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 16:40:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752767AbYDOUkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 16:40:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48665 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752058AbYDOUku (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 16:40:50 -0400
Date: Tue, 15 Apr 2008 22:40:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <clameter@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Yinghai.Lu@sun.com, apw@shadowen.org,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [bug] SLUB + mm/slab.c boot crash in -rc9
Message-ID: <20080415204025.GA29784@elte.hu>
References: <84144f020804110211w4ae41414od24cf2de72453e13@mail.gmail.com> <20080415062534.GA9172@elte.hu> <alpine.LFD.1.00.0804150838161.2879@woody.linux-foundation.org> <20080415161532.GA15088@elte.hu> <alpine.LFD.1.00.0804151010500.2879@woody.linux-foundation.org> <Pine.LNX.4.64.0804151232080.1785@schroedinger.engr.sgi.com> <20080415195430.GA23015@elte.hu> <Pine.LNX.4.64.0804151255390.1785@schroedinger.engr.sgi.com> <20080415201734.GA25628@elte.hu> <4805115D.5030703@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4805115D.5030703@cs.helsinki.fi>
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


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> Ingo Molnar wrote:
>> my current guess would have been some bootmem regression/interaction that 
>> messes up the buddy bitmaps - but i just reverted to the v2.6.24 version 
>> of bootmem.c and that crashes too ...
>
> I know this is bit of hand-waving but have you noticed how all the 
> interesting sparsemem changes that one would expect to have caused the 
> breakage happened _before_ v2.6.24? So sorry for asking this again but 
> are we 110% sure the problem does not trigger with any of the 
> v2.6.24-rcN kernels?

quite. Here are all the successfull bootups from my (failed) bisection 
attempt:

 0773769191d943358a8392fa86abd756d004c4b6
 21af0297c7e56024a5ccc4d8ad2a590f9ec371ba
 26b8256e2bb930a8e4d4d10aa74950d8921376b8
 2a10e7c41254941cac87be1eccdcb6379ce097f5
 3aa88cdf6bcc9e510c0707581131b821a7d3b7cb
 49914084e797530d9baaf51df9eda77babc98fa8
 53a6e2342d73d509318836e320f70cd286acd69c
 5be3bda8987b12a87863c89b74b136fdb1f072db
 6d5f718a497375f853d90247f5f6963368e89803
 7272dcd31d56580dee7693c21e369fd167e137fe
 77de2c590ec72828156d85fa13a96db87301cc68
 82cfbb008572b1a953091ef78f767aa3ca213092
 b75f53dba8a4a61fda1ff7e0fb0fe3b0d80e0c64
 c087567d3ffb2c7c61e091982e6ca45478394f1a
 d4b37ff73540ab90bee57b882a10b21e2f97939f
 fde1b3fa947c2512e3715962ebb1d3a6a9b9bb7d

or, via git-describe:

v2.6.24-3908-g0773769
v2.6.24-2392-g21af029
v2.6.24-3868-g26b8256
v2.6.24-4463-g2a10e7c
v2.6.24-4457-g3aa88cd
v2.6.24
v2.6.24-3522-g53a6e23
v2.6.24-3131-g5be3bda
v2.6.24-4461-g6d5f718
v2.6.24-3891-g7272dcd
v2.6.24-3902-g77de2c5
v2.6.24-3613-g82cfbb0
v2.6.24-4449-gb75f53d
v2.6.24-3911-gc087567
v2.6.24-3913-gd4b37ff
v2.6.24-4464-gfde1b3f

i.e. vanilla v2.6.24 and a whole bunch of commits after it were booting 
just fine. (the problem might have been masked up to a certain point in 
theory, but given how resilient it is to offset changes in my testing i 
find that not very probable [but not impossible] )

	Ingo
