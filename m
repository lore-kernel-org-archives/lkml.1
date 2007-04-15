Return-Path: <linux-kernel-owner+w=401wt.eu-S1750893AbXDOEBM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750893AbXDOEBM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 00:01:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750894AbXDOEBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 00:01:12 -0400
Received: from holomorphy.com ([66.93.40.71]:45246 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888AbXDOEBM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 00:01:12 -0400
Date: Sat, 14 Apr 2007 21:01:26 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070415040126.GF8915@holomorphy.com>
References: <20070413202100.GA9957@elte.hu> <20070413222151.GD8915@holomorphy.com> <Pine.LNX.4.64.0704140008001.10930@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704140008001.10930@alien.or.mcafeemobile.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Apr 2007, William Lee Irwin III wrote:
>> A binomial heap would likely serve your purposes better than rbtrees.
[...]

On Sat, Apr 14, 2007 at 03:38:04PM -0700, Davide Libenzi wrote:
> Haven't looked at the scheduler code yet, but for a similar problem I use 
> a time ring. The ring has Ns (2 power is better) slots (where tasks are 
> queued - in my case they were som sort of timers), and it has a current 
> base index (Ib), a current base time (Tb) and a time granularity (Tg). It 
> also has a bitmap with bits telling you which slots contains queued tasks. 
> An item (task) that has to be scheduled at time T, will be queued in the slot:
> S = Ib + min((T - Tb) / Tg, Ns - 1);
> Items with T longer than Ns*Tg will be scheduled in the relative last slot 
> (chosing a proper Ns and Tg can minimize this).
> Queueing is O(1) and de-queueing is O(Ns). You can play with Ns and Tg to 
> suite to your needs.

I used a similar sort of queue in the virtual deadline scheduler I
wrote in 2003 or thereabouts. CFS uses queue priorities with too high
a precision to map directly to this (queue priorities are marked as
"key" in the cfs code and should not be confused with task priorities).
The elder virtual deadline scheduler used millisecond resolution and a
rather different calculation for its equivalent of ->key, which
explains how it coped with a limited priority space.

The two basic attacks on such large priority spaces are the near future
vs.  far future subdivisions and subdividing the priority space into
(most often regular) intervals. Subdividing the priority space into
intervals is the most obvious; you simply use some O(lg(n)) priority
queue as the bucket discipline in the "time ring," queue by the upper
bits of the queue priority in the time ring, and by the lower bits in
the O(lg(n)) bucket discipline. The near future vs. far future
subdivision is maintaining the first N tasks in a low-constant-overhead
structure like a sorted list and the remainder in some other sort of
queue structure intended to handle large numbers of elements gracefully.
The distribution of queue priorities strongly influences which of the
methods is most potent, though it should be clear the methods can be
used in combination.


-- wli
