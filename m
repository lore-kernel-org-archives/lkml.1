Return-Path: <linux-kernel-owner+w=401wt.eu-S1759566AbYDWFmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759566AbYDWFmW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 01:42:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbYDWFmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 01:42:12 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35671
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751513AbYDWFmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 01:42:11 -0400
Date: Tue, 22 Apr 2008 22:42:12 -0700 (PDT)
Message-Id: <20080422.224212.32058127.davem@davemloft.net>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: Soft lockup regression from today's sched.git merge.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080422091456.GC9939@elte.hu>
References: <20080422.015931.70144614.davem@davemloft.net>
	<20080422091456.GC9939@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 22 Apr 2008 11:14:56 +0200

> thanks for reporting it. I havent seen this false positive happen in a 
> long time - but then again, PC CPUs are a lot less idle than a 128-CPU 
> Niagara2 :-/ I'm wondering what the best method would be to provoke a 
> CPU to stay idle that long - to make sure this bug is fixed.

I looked more closely at this.

There is no way the patch in question can work properly.

The algorithm is, essentialy "if time - prev_cpu_time is large enough,
call __sync_cpu_clock()" which if fine, except that nothing ever sets
prev_cpu_time.

The code is fatally flawed, once __sync_cpu_clock() calls start
happening, they will happen on every cpu_clock() call.

So like my bisect showed from the get-go, these cpu_clock() changes
have major problems, so it was quite a mind boggling stretch to stick
a touch_softlockup_watchdog() call somewhere to try and fix this
when the guilty change in question didn't touch that area at all.
:-(

Furthermore, this is an extremely expensive way to ensure monotonic
per-rq timestamps.  A global spinlock taken every 100000 ns on every
cpu?!?!  :-/

At least move any implication of "high speed" from the comments above
cpu_clock() if we're going to need something like this.  I have 128
cpus, that's 128 grabs of that spinlock every quantum.  My next system
I'm getting will have 256 cpus.  The expense of your solution
increases linearly with the number of cpus, which doesn't scale.

Anyways, I'll work on the group sched lockup bug next.  As if I have
nothing better to do during the merge window than fix sched tree
regressions :-(
