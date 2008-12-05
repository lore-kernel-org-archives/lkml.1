Return-Path: <linux-kernel-owner+w=401wt.eu-S1751731AbYLEH6E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751731AbYLEH6E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 02:58:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756032AbYLEH5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 02:57:48 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55629
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755612AbYLEH5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 02:57:47 -0500
Date: Thu, 04 Dec 2008 23:57:47 -0800 (PST)
Message-Id: <20081204.235747.43111785.davem@davemloft.net>
To: mingo@elte.hu
Cc: paulus@samba.org, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, akpm@linux-foundation.org,
       eranian@googlemail.com, dada1@cosmosbay.com, robert.richter@amd.com,
       arjan@infradead.org, hpa@zytor.com, a.p.zijlstra@chello.nl,
       rostedt@goodmis.org
Subject: Re: [patch 0/3] [Announcement] Performance Counters for Linux
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081205070329.GA30874@elte.hu>
References: <18744.29747.728320.652642@cargo.ozlabs.ibm.com>
	<20081205063131.GB12785@elte.hu>
	<20081205070329.GA30874@elte.hu>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 5 Dec 2008 08:03:29 +0100

> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > This can be done in a very natural way with our abstraction, and the 
> > "hello.c" example happens to do exactly that:
> 
> multiple people pointed out that we have not posted hello.c :-/

Because it's completely not providing the facility.  This is not how
people want to use the performance counters at all.

And it doesn't even do what Paulus said is necessary, he said:

--------------------
> One thing that this sort of thing can't do is to get values from 
> multiple counters that correlate with each other.  For instance, we 
> would often want to count, say, L2 cache misses and instructions 
> completed at the same time, and be able to read both counters at very 
> close to the same time, so that we can measure average L2 cache misses 
> per instruction completed, which is useful.
--------------------

And if you read one counter then read the other as seperate operations,
you get extra events in there as a side effect of going back into
userspace between the two reads.

Nobody wants that, it's inaccurate and if you're looking for if one
event happens at all it's not only inaccurate it's useless if the
reads trigger that counter event.  Also, correlation has other
meanings.

What people want is blocking on overflow events, and a monitoring task
or thread doing all of the tricky control register management and task
inspection.

I mean look at some of the test cases and sample programs in the PAPI
and perfmon2 librarys, that stuff is extremely cool and this proposal
cannot do half of that stuff correctly.
