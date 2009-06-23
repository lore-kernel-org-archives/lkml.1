Return-Path: <linux-kernel-owner+w=401wt.eu-S1758939AbZFWNS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758939AbZFWNS7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 09:18:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753954AbZFWNSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 09:18:49 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:42890 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753066AbZFWNSr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 09:18:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=ibIAWqZnGHaZAmI3od1d/1OqmCeNj9qeih4idClBqeOWn5/kcjvEQRPkRXs7Yj4j5l
         Hf4vqf6X1Jmj1IsyPEq161XnQOfLOOWsN5RrFOENEG0snUMf9S4C5h8Fab/EQJGQR2Qr
         1SQjL0uETF/n21a5QcZ1raD9bzXvGBwlUN2f8=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <20090622115734.GN24366@elte.hu>
References: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com>
	 <20090622115734.GN24366@elte.hu>
Date: Tue, 23 Jun 2009 15:18:48 +0200
Message-ID: <7c86c4470906230618o8d73f6ak3668a1f2ae2b4f40@mail.gmail.com>
Subject: Re: II.2 - Event knowledge missing
From: stephane eranian <eranian@googlemail.com>
To: Ingo Molnar <mingo@elte.hu>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 22, 2009 at 1:57 PM, Ingo Molnar<mingo@elte.hu> wrote:
>> 2/ Event knowledge missing
>>
>> There are constraints on events in Intel processors. Different
>> constraints do exist on AMD64 processors, especially with
>> uncore-releated events.
>
> You raise the issue of uncore events in IV.1, but let us reply here
> primarily.
>
> Un-core counters and events seem to be somewhat un-interesting to
> us. (Patches from those who find them interesting are welcome of
> course!)
>
That is you opinion but not mine. I believe uncore is useful though
it is harder to manage than core PMU. I know that because I have
implemented the support for Nehalem. But going back to our discussion
from December, if it's there it's because it provides some value-add,
why would the hardware designers have bothered otherwise?

It is true that if you've only read the uncore description in Volume 3b, it
is not clear what this can actually do. Therefore, I recommend you take
a look at section B.2.5 of the Intel optimization manual:

               http://www.intel.com/Assets/PDF/manual/248966.pdf

It shows a bunch of interesting metrics one can collect using uncore.
Metrics which you cannot get any other way. Some people do care
about those, otherwise they would not be explained.

>
> The main problem with uncore events is that they are per physical
> package, and hence tying a piece of physical metric exposed via them
> to a particular workload is hard - unless full-system analysis is
> performed. 'Task driven' metrics seem far more useful to performance
> analysis (and those are the preferred analysis method of most
> user-space developers), as they allow particularized sampling and
> allow the tight connection between workload and metric.
>
That is the nature of the beast. There is not much you can do about
this. But this is still useful especially if you have a symmetrical
workload like many scientific applications have.

Note that uncore also exist on AMD64, though, not as clearly separated.
Some events collect at the package level, yet they are using core PMU
counters. And those come with restrictions as well see Section 3.12,
description of PERFCTL, in the BKDG for Family 10h.

> If, despite our expecations, uncore events prove to be useful,
> popular and required elements of performance analysis, they can be
> supported in perfcounters via various levels:
>
>  - a special raw ID range on x86, only to per CPU counters. The
>   low-level implementation reserves the uncore PMCs, so overlapping
>   allocation (and interaction between the cores via the MSRs) is
>   not possible.
>
I agree this is for CPU counters only, not per-thread. It could be any
core in the package. In fact, multiple per CPU "sessions" could
co-exist in the same package. But there is one difficulty with allowing
this, though. The uncore does not interrupt directly. You need to
designate which core(s) it will interrupt via a bitmask. It could interrupt
ALL CPUs in the package at once (which is another interesting usage
model of uncore). So I believe the choice is between 1 CPU and
all CPUs.

Uncore events have no constraints, except for the single fixed counter
event (UNC_CLK_UNHALTED). Thus, you could still use your
event model and overcommit the uncore and multiplex groups on it.
You could reject events in a group once you reach 8 (max number of
counters). I don't see the difference there. The only issue is with managing
the interrupt.



>  - generic enumeration with full tooling support, time-sharing and
>   the whole set of features. The low-level backend would time-share
>   the resource between interested CPUs.
>
> There is no limitation in the perfcounters design that somehow makes
> uncore events harder to support. The uncore counters _themselves_
> are limited to begin with - so rich features cannot be offered on
> top of them.
>
I would say they are limited. This is what you can do from where they
are sourced from.


>
>> The current code-base does not have any constrained event support,
>> therefore bogus counts may be returned depending on the event
>> measured.
>
> Then we'll need to grow some when we run into them :-)

FYI, here is the list of constrained events for Intel Core.
Counter [0] means generic counter0, [1] means generic counter1.
If you do not put these events in the right counter, they do
not count what they are supposed to, and do so silently.

Name     : FP_COMP_OPS_EXE
Code     : 0x10
Counters : [ 0 ]
Desc     : Floating point computational micro-ops executed
PEBS     : No

Name     : FP_ASSIST
Code     : 0x11
Counters : [ 1 ]
Desc     : Floating point assists
PEBS     : No

Name     : MUL
Code     : 0x12
Counters : [ 1 ]
Desc     : Multiply operations executed
PEBS     : No

Name     : DIV
Code     : 0x13
Counters : [ 1 ]
Desc     : Divide operations executed
PEBS     : No

Name     : CYCLES_DIV_BUSY
Code     : 0x14
Counters : [ 0 ]
Desc     : Cycles the divider is busy
PEBS     : No

Name     : IDLE_DURING_DIV
Code     : 0x18
Counters : [ 0 ]
Desc     : Cycles the divider is busy and all other execution units are idle
PEBS     : No

Name     : DELAYED_BYPASS
Code     : 0x19
Counters : [ 1 ]
Desc     : Delayed bypass
Umask-00 : 0x00 : [FP] : Delayed bypass to FP operation
Umask-01 : 0x01 : [SIMD] : Delayed bypass to SIMD operation
Umask-02 : 0x02 : [LOAD] : Delayed bypass to load operation
PEBS     : No

Name     : MEM_LOAD_RETIRED
Code     : 0xcb
Counters : [ 0 ]
Desc     : Retired loads that miss the L1 data cache
Umask-00 : 0x01 : [L1D_MISS] : Retired loads that miss the L1 data
cache (precise event)
Umask-01 : 0x02 : [L1D_LINE_MISS] : L1 data cache line missed by
retired loads (precise event)
Umask-02 : 0x04 : [L2_MISS] : Retired loads that miss the L2 cache
(precise event)
Umask-03 : 0x08 : [L2_LINE_MISS] : L2 cache line missed by retired
loads (precise event)
Umask-04 : 0x10 : [DTLB_MISS] : Retired loads that miss the DTLB (precise event)
PEBS     : [L1D_MISS] [L1D_LINE_MISS] [L2_MISS] [L2_LINE_MISS] [DTLB_MISS]
