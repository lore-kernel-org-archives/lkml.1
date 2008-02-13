Return-Path: <linux-kernel-owner+w=401wt.eu-S1765983AbYBMRNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765983AbYBMRNV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 12:13:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757408AbYBMRNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 12:13:06 -0500
Received: from numenor.qualcomm.com ([129.46.51.58]:38637 "EHLO
	numenor.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754345AbYBMRNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 12:13:04 -0500
Message-ID: <47B324D7.2090003@qualcomm.com>
Date: Wed, 13 Feb 2008 09:11:51 -0800
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       mingo@elte.hu, pj@sgi.com, a.p.zijlstra@chello.nl, gregkh@suse.de,
       rusty@rustcorp.com.au
Subject: Re: [git pull for -mm] CPU isolation extensions (updated2)
References: <47B11C45.6060408@qualcomm.com> <200802131511.28643.nickpiggin@yahoo.com.au> <47B288E4.2080403@qualcomm.com> <200802131722.51117.nickpiggin@yahoo.com.au>
In-Reply-To: <200802131722.51117.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Nick Piggin wrote:
> On Wednesday 13 February 2008 17:06, Max Krasnyansky wrote:
>> Nick Piggin wrote:
> 
>>> But don't let me dissuade you from making these good improvements
>>> to Linux as well :) Just that it isn't really going to be hard-rt
>>> in general.
>> Actually that's the cool thing about CPU isolation. Get rid of all latency
>> sources from the CPU(s) and you get youself as hard-RT as it gets.
> 
> Hmm, maybe. Removing all sources of latency from the CPU kind of
> implies that you have to audit the whole kernel for source of
> latency.
That's exactly where cpu isolation comes in. It makes sure that an isolated 
CPU is excluded from: 
1. HW interrupts. This means no softirq, etc.
2. Things like workqueues, stop machine, etc. This typically means no timers, etc.
3. Scheduler load balancing (we had support for that for awhile now).

All that's left on that CPU is the scheduler tick and IPIs. And those are just fine.
At that point it's up to the app to use or not to use kernel services.
In other words no auditing is required. It's the RT preempt that needs to audit in
order to be general purpose RT.
 
>> I mean I _already_ have multi-core hard-RT systems that show ~1.2 usec
>> worst case and ~200nsec average latency. I do not even need Adeos/Xenomai
>> or Preemp-RT just a few very small patches. And it can be used for non RT
>> stuff too.
> 
> OK, but you then are very restricted in what you can do, and easily
> can break it especially if you run any userspace on that CPU. If
> you just run a kernel module that, after setup, doesn't use any
> other kernel resources except interrupt handling, then you might be
> OK (depending on whether even interrupt handling can run into
> contended locks)...
> 
> If you started doing very much more, then you can easily run into
> trouble.
Yes I'm definitely not selling it as general purpose. And no, it's not just kernel code 
it's a pure user-space code. Carefully designed user-space code that is.
The model is pretty simple. Lets say you have a dual cpu/core box. The app can be 
partitioned like this:
- CPU0 handles HW irqs, runs general services, etc and soft-RT threads
- CPU1 runs hard-RT threads or a special engine. For the description of the engine
see http://marc.info/?l=linux-kernel&m=120232425515556&w=2 

hard-RT threads do not need any system call besides pthread_ mutex and signals (those
are perfectly fine).
They can use direct HW access (if needed). ie Memory mapping something and acessing
it without the syscalls (see libe1000.sf.net for example).
Communication between hard-RT and soft-RT thread is lock-less (single reader/single writer
queues, etc).
It may sound fairly limited but you'd be surprised how much you can do. It's relatively
easy to design the app that way once you get a hang of it :). I'm working with our legal 
folks on releasing user-space framework and afore mentioned engine with a bunch of examples.

Max
