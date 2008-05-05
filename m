Return-Path: <linux-kernel-owner+w=401wt.eu-S1755429AbYEEMGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429AbYEEMGb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 08:06:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751731AbYEEMGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 08:06:23 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:37526 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbYEEMGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 08:06:22 -0400
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] sched_clock_cpu()
From: Andi Kleen <andi@firstfloor.org>
References: <1209832169.6929.42.camel@lappy>
Date: Mon, 05 May 2008 14:06:20 +0200
In-Reply-To: <1209832169.6929.42.camel@lappy> (Peter Zijlstra's message of "Sat, 03 May 2008 18:29:28 +0200")
Message-ID: <87d4o1c5vn.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 05 May 2008 11:59:24.0736 (UTC) FILETIME=[76498400:01C8AEA7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <a.p.zijlstra@chello.nl> writes:

> Hi,
>
> This is my current proposal to replace the rq->clock stuff (and possibly
> cpu_clock()).
>
> it _DOESN'T_ boot ;-/ and I seem to have caught a flu that makes my
> whole body hurt like hell, so I'm not getting anything done.

Sorry Peter I think the whole concept is wrong. You're still
at the wrong level.

If you don't fix the underlying sched_clock the results will be always
GIGO (Garbage-In-Garbage-Out). And the best "filtering" will not help
with that if the incoming time is just wrong. And if you fix the
underlying sched_clocks you don't need all that filtering.

That is also why I don't like David's proposal of a Kconfig for this.
It's the wrong way too. Or rather that Kconfig should be always set.

Also I believe x86 sched_clock can be fixed that it will work
properly with some constraints: 
- monotonous per CPU only
If you think about it the concept of "jiffies only error" doesn't make sense because it means you can as well use jiffies if you really need inter CPU
stamps.

- not over deep sleep states on some CPUs. 
While modern x86 designs fixed that older ones still have that problem 
and it will be always there with us in the embedded world.

I believe both constraints are ok for scheduler purposes. You don't
need to measure idle tasks (and those are the only ones who
go into sleep states) and you can always do all calculations on
the run queue of a specific CPU only.

This means it is not suitable as a printk clock for once, but for
that jiffies is fine anyways.

The rewritten sched_clock I posted the URL to a few times fixes
some of the problems, not all (there was on non monotonity case
left with non p state invariant TSC, i believe it was fixable
though). I unfortunately cannot work on this, but maybe someone is 
interested in taking that code over.

[for old kernels]
ftp://ftp.firstfloor.org/pub/ak/x86_64/quilt-current/patches/sched-clock
ftp://ftp.firstfloor.org/pub/ak/x86_64/quilt-current/patches/sched-clock64

-Andi
