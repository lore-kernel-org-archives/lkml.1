Return-Path: <linux-kernel-owner+w=401wt.eu-S1757944AbYAGUBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757944AbYAGUBR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 15:01:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754615AbYAGUBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 15:01:06 -0500
Received: from ns2.suse.de ([195.135.220.15]:37959 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754325AbYAGUBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 15:01:04 -0500
To: mingo@elte.hu, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [5/20] x86: Introduce nsec_barrier() II
From: Andi Kleen <andi@firstfloor.org>
References: <20080103149.088038000@suse.de>
	<20080103005000.65D0C14D40@wotan.suse.de>
	<20080103104754.GD29194@elte.hu> <200801031355.44694.ak@suse.de>
Date: Mon, 07 Jan 2008 21:01:03 +0100
In-Reply-To: <200801031355.44694.ak@suse.de> (Andi Kleen's message of "Thu\, 3 Jan 2008 13\:55\:44 +0100")
Message-ID: <p7363y5s8w0.fsf_-_@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <ak@suse.de> writes:

> On Thursday 03 January 2008 11:47:54 Ingo Molnar wrote:
>> 
>> * Andi Kleen <ak@suse.de> wrote:
>> 
>> > nsec_barrier() is a new barrier primitive that stops RDTSC speculation 
>> > to avoid races with timer interrupts on other CPUs.
>> > 
>> > Add it to all architectures. Except for x86 it is a nop right now. I 
>> > only tested x86, but it's a very simple change.
>> > 
>> > On x86 it expands either to LFENCE (for Intel CPUs) or MFENCE (for AMD 
>> > CPUs) which stops RDTSC on all currently known microarchitectures that 
>> > implement SSE. On CPUs without SSE there is generally no RDTSC 
>> > speculation.
>> 
>> i've picked up your rdtsc patches into x86.git but have simplified it: 
>> there's no nsec_barrier() anymore - rdtsc() is always synchronous. 
>> MFENCE/LFENCE is fast enough. Open-coding such barriers almost always 
>> leads to needless trouble. Please check the next x86.git tree.
>
> That's most likely wrong unless you added two barriers -- the barriers
> are strictly need to be before and after RDTSC.

I checked your patch now -- 743abf4d987911af1ffce4c96f06cba6ffaa7e88
and 428f309ba5244fa25b44fcdf1d79aa94c8745cfd in gitx86 and you did it
indeed wrong.

The problem is that you inserted the barrier only after the RDTSC, but
the instruction can be speculated both forward and backward and both
can cause inconsistencies if it leaves the critical section.

The minimal fix would be to change native_read_tsc to

        rdtsc_barrier();
        asm volatile("rdtsc" : EAX_EDX_RET(val, low, high));
        rdtsc_barrier();

(e.g. add the missing barrier) 

Better would be still to keep the explicit nsec barriers as in
the original patch for several reasons:
- There are situations where RDTSC without barrier is ok and it might
be useful there.
- It is better to give the CPU some room to run uops in parallel;
especially in very performance critical like gtod(). A wider
barriered area is faster.
- I actually expect that other architectures with aggressive OOO 
implementations (like POWER4/5) should make use of 
nsec_barrier() too. I don't think it's really an x86 specific concept.
- Explicit barriers can be useful when measuring performance, although
admittedly there a x86 specific barrier is usually ok. However forcing
the barrier inside RDTSC is not.

If you insist to keep the incorrect patch please drop my name from it.

-Andi
