Return-Path: <linux-kernel-owner+w=401wt.eu-S1752101AbZFVLxL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101AbZFVLxL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 07:53:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751142AbZFVLw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 07:52:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51464 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000AbZFVLw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 07:52:57 -0400
Date: Mon, 22 Jun 2009 13:52:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: eranian@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Subject: Re: I.5 - Mmaped count
Message-ID: <20090622115239.GF24366@elte.hu>
References: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 5/ Mmaped count
>
> It is possible to read counts directly from user space for
> self-monitoring threads. This leverages a HW capability present on
> some processors. On X86, this is possible via RDPMC.
>
> The full 64-bit count is constructed by combining the hardware
> value extracted with an assembly instruction and a base value made
> available thru the mmap. There is an atomic generation count
> available to deal with the race condition.
>
> I believe there is a problem with this approach given that the PMU
> is shared and that events can be multiplexed. That means that even
> though you are self-monitoring, events get replaced on the PMU.
> The assembly instruction is unaware of that, it reads a register
> not an event.
>
> On x86, assume event A is hosted in counter 0, thus you need
> RDPMC(0) to extract the count. But then, the event is replaced by
> another one which reuses counter 0. At the user level, you will
> still use RDPMC(0) but it will read the HW value from a different
> event and combine it with a base count from another one.
>
> To avoid this, you need to pin the event so it stays in the PMU at
> all times. Now, here is something unclear to me. Pinning does not
> mean stay in the SAME register, it means the event stays on the
> PMU but it can possibly change register. To prevent that, I
> believe you need to also set exclusive so that no other group can
> be scheduled, and thus possibly use the same counter.
>
> Looks like this is the only way you can make this actually work.
> Not setting pinned+exclusive, is another pitfall in which many
> people will fall into.

   do {
     seq = pc->lock;

     barrier()
     if (pc->index) {
       count = pmc_read(pc->index - 1);
       count += pc->offset;
     } else
       goto regular_read;

     barrier();
   } while (pc->lock != seq);

We don't see the hole you are referring to. The sequence lock
ensures you get a consistent view.
