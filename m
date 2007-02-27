Return-Path: <linux-kernel-owner+w=401wt.eu-S1752536AbXB0ULk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536AbXB0ULk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 15:11:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752532AbXB0ULj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 15:11:39 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:20200 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535AbXB0ULj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 15:11:39 -0500
Subject: Re: [RFC] Fast assurate clock readable from user space and NMI
	handler
From: Daniel Walker <dwalker@mvista.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Ingo Molnar <mingo@elte.hu>, mbligh@google.com,
       linux-kernel@vger.kernel.org, johnstul@us.ibm.com,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20070227190442.GA11272@Krystal>
References: <1172525261.5517.69.camel@imap.mvista.com>
	 <20070226221423.GA2286@Krystal> <1172531521.5517.138.camel@imap.mvista.com>
	 <20070227035456.GA15444@Krystal>
	 <1172550161.5517.210.camel@imap.mvista.com> <20070227062913.GC1259@elte.hu>
	 <20070227073815.GA25894@Krystal>
	 <1172571535.5517.222.camel@imap.mvista.com> <20070227160206.GA2391@Krystal>
	 <1172597055.5517.233.camel@imap.mvista.com>
	 <20070227190442.GA11272@Krystal>
Content-Type: text/plain
Date: Tue, 27 Feb 2007 12:09:18 -0800
Message-Id: <1172606958.5517.257.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-27 at 14:04 -0500, Mathieu Desnoyers wrote:

> 1 - I do not plan to use the rcupdate.h API, because it is oriented
> towards allowing/freeing data structures after a quiescent state. I
> don't need that. I only want to have a 64 bits data structure valid for
> reading, with atomic update. Therefore, I keep an array of 2 64 bits
> structures. At all time, there is one used as "readable" value and the other
> as "writeable". The role is exchanged at each update. The word-sized
> counter is used to select the current read and write pointers through a
> mask, and is also used to detect bad reads (is a read is preempted, and
> then we have 2 updates, the reader could read a bad value without
> knowing it). By keeping a word-sized counter of the number of updates,
> we have 32 (or 64) bits (depending on the architecture) before the wrap
> around, which should not happen even in a far future.

Sounds like a special case RCU system .. If you wanted to add this time
stamping system to Linux, the only acceptable way to add it, IMO, would
be to replace or extend gettimeofday .. You would also need a
justification for the changes, which right now is likely only LTT .. 

> __get_nsec_offset : reads clock->cycle_last. Should be called with
> xtime_lock held. (ok so far, but see below)
> 
> change_clocksource
> clock->cycle_last = now; (non atomic 64 bits update. Not protected by
> any lock ?) -> this would race with __get_nsec_offset ?
> 
> update_wall_time
> Called from timer interrupt. Holds xtime_lock and has a priority higher
> than other interrupts. Other clock->cycle_last protected by
> write_seqlock_irqsave.

update_wall_time, change_clocksource, __get_nsec_offset all hold the
xtime_lock w/ interrupts disabled.

> get_monotonic_cycles (as you proposed, in -rt kernels) :
> reads clock->cycle_last. Not protected by any read seqlock and does not
> disable interrupts. Races with change_clocksource, update_wall_time and
> all other time update functions. For instance, is someone uses
> get_monotonic_cycles in process context and the timer interrupt fires
> update_wall_time right at the middle of the 2 32 bits read, the value
> will be wrong.

I guess that's true.. You also have to assume that the upper 32 bits
have actually changed, the TSC is the only 64-bit clock in linux right
now.. 

Daniel

