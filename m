Return-Path: <linux-kernel-owner+w=401wt.eu-S1756812AbYF3OsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812AbYF3OsU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 10:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751669AbYF3OsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 10:48:09 -0400
Received: from sinclair.provo.novell.com ([137.65.248.137]:45152 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbYF3OsI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 10:48:08 -0400
Message-Id: <4868B841.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Mon, 30 Jun 2008 08:41:05 -0600
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: <rostedt@goodmis.org>, <peterz@infradead.org>, <npiggin@suse.de>,
       <linux-kernel@vger.kernel.org>, <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH 0/3] sched: newidle and RT wake-buddy fixes
References: <20080627202444.3829.21595.stgit@lsg.lsg.lab.novell.com>
 <20080630131511.GA7506@elte.hu>
In-Reply-To: <20080630131511.GA7506@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On Mon, Jun 30, 2008 at  9:15 AM, in message <20080630131511.GA7506@elte.hu>,
Ingo Molnar <mingo@elte.hu> wrote: 

> * Gregory Haskins <ghaskins@novell.com> wrote:
> 
>> Hi Ingo,
>>   The following patches apply to linux-tip/sched/devel and enhance the
>> performance of the kernel (specifically in PREEMPT_RT, though they do
>> not regress mainline performance as far as I can tell).  They offer
>> somewhere between 50-100% speedups in netperf performance, depending
>> on the test.
> 
> -tip testing found this boot hang:

Ok, I dug in a little bit here.  I haven't verified this out yet, but I think the problem is that
your config is PREEMPT_VOLUNTARY which NOPs the preempt_disable() in schedule() that
I rely on to allow the lock to be dropped.  (Doh!)

One way I can fix this is to fixup the newidle() code to only play the irq dropping tricks
ifdef CONFIG_PREEMPT == TRUE.  Does this sound reasonable, or is there a better way
to address this?

-Greg

> 
>  Linux version 2.6.26-rc8-tip (mingo@dione) (gcc version 4.2.3) #12917 
>  SMP Mon Jun 30 15:06:32 CEST 2008
>  [...]
>  CPU 1/1 -> Node 0
>  CPU: Physical Processor ID: 0
>  CPU: Processor Core ID: 1
>  CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
>  Brought up 2 CPUs
>  Total of 2 processors activated (8041.15 BogoMIPS).
>  [ hard hang ]
> 
> with this config:
> 
>   http://redhat.com/~mingo/misc/config-Mon_Jun_30_14_54_19_CEST_2008.bad
> 
> full bootlog:
> 
>   http://redhat.com/~mingo/misc/hang-Mon_Jun_30_14_54_19_CEST_2008.bad
> 
> it should continue with this bootup sequence:
> 
>   calling  net_ns_init+0x0/0x1a0
>   net_namespace: 376 bytes
>   initcall net_ns_init+0x0/0x1a0 returned 0 after 0 msecs
>   calling  init_smp_flush+0x0/0x60
> 
> i've bisected it down to:
> 
> --------------
> | commit cc8160c56843201891766660e3816d2e546c1b17
> | Author: Gregory Haskins <ghaskins@novell.com>
> | Date:   Fri Jun 27 14:29:50 2008 -0600
> |
> |     sched: enable interrupts and drop rq-lock during newidle balancing
> --------------
> 
> so i've reverted that change for now.
> 
> 	Ingo


