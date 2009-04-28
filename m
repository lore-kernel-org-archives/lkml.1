Return-Path: <linux-kernel-owner+w=401wt.eu-S1756784AbZD1KXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784AbZD1KXP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 06:23:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932494AbZD1KWC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 06:22:02 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44404 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932489AbZD1KV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 06:21:59 -0400
Subject: Re: [PATCH -v2] x86: MCE: Re-implement MCE log ring buffer as
 per-CPU ring buffer
From: Peter Zijlstra <peterz@infradead.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1240910841.6842.1163.camel@yhuang-dev.sh.intel.com>
References: <1240910841.6842.1163.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 28 Apr 2009 12:21:43 +0200
Message-Id: <1240914103.7620.110.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-28 at 17:27 +0800, Huang Ying wrote:
> Re-implement MCE log ring buffer as per-CPU ring buffer for better
> scalability. Basic design is as follow:
> 
> - One ring buffer for each CPU
> 
>   + MCEs are added to corresponding local per-CPU buffer, instead of
>     one big global buffer. Contention/unfairness between CPUs is
>     eleminated.
> 
>   + MCE records are read out and removed from per-CPU buffers by mutex
>     protected global reader function. Because there are no many
>     readers in system to contend in most cases.
> 
> - Per-CPU ring buffer data structure
> 
>   + An array is used to hold MCE records. integer "head" indicates
>     next writing position and integer "tail" indicates next reading
>     position.
> 
>   + To distinguish buffer empty and full, head and tail wrap to 0 at
>     MCE_LOG_LIMIT instead of MCE_LOG_LEN. Then the real next writing
>     position is head % MCE_LOG_LEN, and real next reading position is
>     tail % MCE_LOG_LEN. If buffer is empty, head == tail, if buffer is
>     full, head % MCE_LOG_LEN == tail % MCE_LOG_LEN and head != tail.
> 
> - Lock-less for writer side
> 
>   + MCE log writer may come from NMI, so the writer side must be
>     lock-less. For per-CPU buffer of one CPU, writers may come from
>     process, IRQ or NMI context, so "head" is increased with
>     cmpxchg_local() to allocate buffer space.
> 
>   + Reader side is protected with a mutex to guarantee only one reader
>     is active in the whole system.
> 
> 
> Performance test show that the throughput of per-CPU mcelog buffer can
> reach 430k records/s compared with 5.3k records/s for original
> implementation on a 2-core 2.1GHz Core2 machine.

We're talking about Machine Check Exceptions here, right? Is there a
valid scenario where you care about performance? I always thought that
an MCE meant something seriously went wrong, log the event and reboot
the machine -- possibly start ordering replacement parts.

But now you're saying we want to be able to record more than 5.3k events
a second on this? Sounds daft to me.

Also, it sounds like something that might fit the ftrace ringbuffer
thingy.
