Return-Path: <linux-kernel-owner+w=401wt.eu-S1755020AbYKDSTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020AbYKDSTq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 13:19:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752771AbYKDSTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 13:19:38 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:2849 "EHLO
	VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758AbYKDSTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 13:19:37 -0500
X-BigFish: VPS-33(z21eWz9370P62a3L4015M936fO1315mzzzzz32i6bh65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 5,
X-WSS-ID: 0K9TMW1-01-9QR-01
Date: Tue, 4 Nov 2008 19:18:55 +0100
From: Robert Richter <robert.richter@amd.com>
To: Andi Kleen <andi@firstfloor.org>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, Eric Dumazet <dada1@cosmosbay.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: linux-2.6.28-rc2 regression : oprofile doesnt work anymore ?
Message-ID: <20081104181855.GK9785@erda.amd.com>
References: <4909F690.9090208@cosmosbay.com> <84144f020810310721x1d1eccbeica5d10608d7b2e57@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <84144f020810310721x1d1eccbeica5d10608d7b2e57@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 04 Nov 2008 18:19:19.0338 (UTC) FILETIME=[DA8600A0:01C93EA9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi,

your patchset breaks oprofile on Intel Core 2 cpus. I could bisect the
bug for c493756..5951290. Please take a look at this and send me a fix.

Thanks,

-Robert

Linux woglinde 2.6.27-oprofile-x86_64-standard-03189-g5951290 #5 SMP Tue Nov 4 18:16:41 CET 2008 x86_64 Intel(R) Core(TM)2 CPU 6300 @ 1.86GHz GenuineIntel GNU/Linux
IBS Fetch not supported - ignored
IBS OP not supported - ignored
Using default event: CPU_CLK_UNHALTED:100000:0:1:1
Daemon started.
Profiler running.
Oprofile started
Daemon running: pid 5845
Separate options: none
vmlinux file: none
Image filter: none
Call-graph depth: 0
number of samples #1: 11
Stopping profiling.
Killing daemon.
number of samples #2: 11

Linux woglinde 2.6.27-oprofile-x86_64-standard-03185-gc493756 #6 SMP Tue Nov 4 19:05:13 CET 2008 x86_64 Intel(R) Core(TM)2 CPU 6300 @ 1.86GHz GenuineIntel GNU/Linux
IBS Fetch not supported - ignored
IBS OP not supported - ignored
Using default event: CPU_CLK_UNHALTED:100000:0:1:1
Daemon started.
Profiler running.
Oprofile started
Daemon running: pid 5263
Separate options: none
vmlinux file: none
Image filter: none
Call-graph depth: 0
number of samples #1: 25
Stopping profiling.
Killing daemon.
number of samples #2: 64
Increasing sample number

commit 59512900baab03c5629f2ff5efad1d5d4e682ece
Author: Andi Kleen <ak@linux.intel.com>
Date:   Mon Sep 29 22:23:33 2008 +0200

    oprofile: discover counters for op ppro too
    
    Discover number of counters for all family 6 models even when not
    in arch perfmon mode.
    
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Robert Richter <robert.richter@amd.com>

 arch/x86/oprofile/op_model_ppro.c |    8 +++++---
 arch/x86/oprofile/op_x86_model.h  |    2 +-
 2 files changed, 6 insertions(+), 4 deletions(-)

commit b99170288421c79f0c2efa8b33e26e65f4bb7fb8
Author: Andi Kleen <ak@linux.intel.com>
Date:   Mon Aug 18 14:50:31 2008 +0200

    oprofile: Implement Intel architectural perfmon support
    
    Newer Intel CPUs (Core1+) have support for architectural
    events described in CPUID 0xA. See the IA32 SDM Vol3b.18 for details.
    
    The advantage of this is that it can be done without knowing about
    the specific CPU, because the CPU describes by itself what
    performance events are supported. This is only a fallback
    because only a limited set of 6 events are supported.
    This allows to do profiling on Nehalem and on Atom systems
    (later not tested)
    
    This patch implements support for that in oprofile's Intel
    Family 6 profiling module. It also has the advantage of supporting
    an arbitary number of events now as reported by the CPU.
    Also allow arbitary counter widths >32bit while we're at it.
    
    Requires a patched oprofile userland to support the new
    architecture.
    
    v2: update for latest oprofile tree
        remove force_arch_perfmon
    
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Robert Richter <robert.richter@amd.com>

 arch/x86/oprofile/nmi_int.c       |   23 ++++++--
 arch/x86/oprofile/op_model_ppro.c |  104 +++++++++++++++++++++++++++++--------
 arch/x86/oprofile/op_x86_model.h  |    3 +
 3 files changed, 102 insertions(+), 28 deletions(-)

commit f645f6406463a01869c50844befc76d528971690
Author: Andi Kleen <ak@linux.intel.com>
Date:   Wed Aug 20 17:22:02 2008 +0200

    oprofile: Don't report Nehalem as core_2
    
    This essentially reverts Linus' earlier 4b9f12a3779c548b68bc9af7d94030868ad3aa1b
    commit. Nehalem is not core_2, so it shouldn't be reported as such.
    However with the earlier arch perfmon patch it will fall back to
    arch perfmon mode now, so there is no need to fake it as core_2.
    The only drawback is that Linus will need to patch the arch perfmon
    support into his oprofile binary now, but I think he can do that.
    
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Robert Richter <robert.richter@amd.com>

 arch/x86/oprofile/nmi_int.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

commit 5d4488027d9cf3161c71566dfabb116bf69ab4d9
Author: Andi Kleen <ak@linux.intel.com>
Date:   Mon Aug 18 14:49:47 2008 +0200

    oprofile: drop const in num counters field
    
    allow to modify it at runtime
    
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Robert Richter <robert.richter@amd.com>

 arch/x86/oprofile/op_x86_model.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

