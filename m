Return-Path: <linux-kernel-owner+w=401wt.eu-S1753297AbZI1U42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297AbZI1U42 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 16:56:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752986AbZI1U41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 16:56:27 -0400
Received: from mtagate3.de.ibm.com ([195.212.17.163]:49039 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbZI1U41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 16:56:27 -0400
Date: Mon, 28 Sep 2009 22:56:23 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, John Stultz <johnstul@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: Linux 2.6.32-rc1
Message-ID: <20090928225623.2dc5d2b2@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <4AC10365.7090802@gmail.com>
References: <alpine.LFD.2.01.0909271511190.3349@localhost.localdomain>
	<4AC060AE.1090401@gmail.com>
	<alpine.LFD.2.01.0909280829100.3349@localhost.localdomain>
	<20090928191506.40b61793@mschwide.boeblingen.de.ibm.com>
	<4AC10365.7090802@gmail.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Sep 2009 20:41:41 +0200
Eric Dumazet <eric.dumazet@gmail.com> wrote:

> I did a bisection and found commit def0a9b2573e00ab0b486cb5382625203ab4c4a6
> was the origin of the problem on my x86_32 machine.
> 
> def0a9b2573e00ab0b486cb5382625203ab4c4a6 is first bad commit
> commit def0a9b2573e00ab0b486cb5382625203ab4c4a6
> Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date:   Fri Sep 18 20:14:01 2009 +0200
> 
>     sched_clock: Make it NMI safe
> 
>     Arjan complained about the suckyness of TSC on modern machines, and
>     asked if we could do something about that for PERF_SAMPLE_TIME.
> 
>     Make cpu_clock() NMI safe by removing the spinlock and using
>     cmpxchg. This also makes it smaller and more robust.
> 
>     Affects architectures that use HAVE_UNSTABLE_SCHED_CLOCK, i.e. IA64
>     and x86.
> 
>     Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>     LKML-Reference: <new-submission>
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>

Confirmed. The bisect run on my machine gave me the same bad commit.
The new logic in sched_clock_remove seems racy: the old code got the
locks for the sched_clock_data of the local and the remove cpu before
it changed any value. The new code tries to get to the same result with
a single cmpxchg. Bad things happen if two cpus try to update the clock
values crosswise, no?

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

