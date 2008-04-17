Return-Path: <linux-kernel-owner+w=401wt.eu-S933571AbYDQKvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933571AbYDQKvX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 06:51:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760321AbYDQKvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 06:51:15 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49418 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760248AbYDQKvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 06:51:14 -0400
Message-ID: <48072B9D.2000900@firstfloor.org>
Date: Thu, 17 Apr 2008 12:51:09 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Alexander van Heukelum <heukelum@fastmail.fm>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [v2.6.26] what's brewing in x86.git for v2.6.26
References: <20080416202338.GA6007@elte.hu> <878wzdikwk.fsf@basil.nowhere.org> <1208426793.10305.1248377703@webmail.messagingengine.com>
In-Reply-To: <1208426793.10305.1248377703@webmail.messagingengine.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> The input for the first 'benchmark' was indeed completely unrealistic.
> They did show a very convincing speedup, though. This program was
> really written to verify the implementation and was later converted
> to a benchmark. Many benchmarks are unrealistic. I also wrote a
> benchmark for find_first_bit and find_next_bit:
>         http://heukelum.fastmail.fm/find_first_bit

I think a realistic benchmark would be by running a real kernel
and profiling the input values of the bitmap functions and then
testing these cases.

I actually started that when I complained last time by writing
a systemtap script for this that generates a histogram, but for some
reason systemtap couldn't tap all bitmap functions in my kernel and
missed some completely and I ran out of time tracking that down.

My gut feeling is the only interesting cases are cpumask/nodemask sized
(which can be one word, two words but now upto 8 words on a NR_CPU=4096
x86 kernel) and then 4k sized ext3/reiser/etc. block bitmaps.

> My conclusion would be: the speed of the generic bitmap implementation
> is either better than or at least comparable to the current private
> implementations in i386/x86_64. 

Ok.

The generic version is out-of-line,
> while the private implementation of i386 was inlined: this causes a
> regression for very small bitmaps. However, if the bitmap size is
> a constant and fits a long integer, the updated generic code should
> inline an optimized version, like x86_64 currently does it.

Yes it should probably. cpumask walks are relatively common.

I remember profiling mysql some time ago which did bad overscheduling
due to dumb locking. Funny was that the mask walking in the scheduler
actually stood out. No, i don't claim extreme overscheduling is an
interesting case to optimize for, but then there are more realistic
workloads which also do a lot of context switching.

BTW if you do generic work on this: one reason the generated code for
for_each_cpu etc. is so ugly is that the code has checks for
find_next_bit returning >= max size. If you can generize the
code enough to make sure no arch does that anymore these checks
could be eliminated.

-Andi
