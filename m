Return-Path: <linux-kernel-owner+w=401wt.eu-S1762949AbYF3NVI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762949AbYF3NVI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 09:21:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932184AbYF3NP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 09:15:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55505 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932173AbYF3NP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 09:15:27 -0400
Date: Mon, 30 Jun 2008 15:15:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Gregory Haskins <ghaskins@novell.com>
Cc: peterz@infradead.org, npiggin@suse.de, rostedt@goodmis.org,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: [PATCH 0/3] sched: newidle and RT wake-buddy fixes
Message-ID: <20080630131511.GA7506@elte.hu>
References: <20080627202444.3829.21595.stgit@lsg.lsg.lab.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080627202444.3829.21595.stgit@lsg.lsg.lab.novell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Gregory Haskins <ghaskins@novell.com> wrote:

> Hi Ingo,
>   The following patches apply to linux-tip/sched/devel and enhance the
> performance of the kernel (specifically in PREEMPT_RT, though they do
> not regress mainline performance as far as I can tell).  They offer
> somewhere between 50-100% speedups in netperf performance, depending
> on the test.

-tip testing found this boot hang:

 Linux version 2.6.26-rc8-tip (mingo@dione) (gcc version 4.2.3) #12917 
 SMP Mon Jun 30 15:06:32 CEST 2008
 [...]
 CPU 1/1 -> Node 0
 CPU: Physical Processor ID: 0
 CPU: Processor Core ID: 1
 CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
 Brought up 2 CPUs
 Total of 2 processors activated (8041.15 BogoMIPS).
 [ hard hang ]

with this config:

  http://redhat.com/~mingo/misc/config-Mon_Jun_30_14_54_19_CEST_2008.bad

full bootlog:

  http://redhat.com/~mingo/misc/hang-Mon_Jun_30_14_54_19_CEST_2008.bad

it should continue with this bootup sequence:

  calling  net_ns_init+0x0/0x1a0
  net_namespace: 376 bytes
  initcall net_ns_init+0x0/0x1a0 returned 0 after 0 msecs
  calling  init_smp_flush+0x0/0x60

i've bisected it down to:

--------------
| commit cc8160c56843201891766660e3816d2e546c1b17
| Author: Gregory Haskins <ghaskins@novell.com>
| Date:   Fri Jun 27 14:29:50 2008 -0600
|
|     sched: enable interrupts and drop rq-lock during newidle balancing
--------------

so i've reverted that change for now.

	Ingo
