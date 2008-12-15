Return-Path: <linux-kernel-owner+w=401wt.eu-S1756142AbYLORjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142AbYLORjx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 12:39:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755257AbYLORjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 12:39:45 -0500
Received: from smtpauth00.csee.onr.siteprotect.com ([64.26.60.144]:41957 "EHLO
	smtpauth00.csee.onr.siteprotect.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755245AbYLORjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 12:39:44 -0500
Date: Mon, 15 Dec 2008 12:44:22 -0500 (EST)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Ven <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       perfctr-devel@lists.sourceforge.net
Subject: Re: [patch] Performance Counters for Linux, v4
In-Reply-To: <20081214212829.GA9435@elte.hu>
Message-ID: <Pine.LNX.4.64.0812151243130.2773@pianoman.cluster.toy>
References: <20081214212829.GA9435@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

I see a large (2300 instruction) fixed overhead when measuring
retired instruction count using the "timec" command
compared to the "pfmon" tool that comes with perfmon3
(the pfmon tool has essentially no overhead when
doing aggragate counts).

Is this an inherent weakness with the new proposed performance
counter infrastructure?

I wanted to compare perfmon3 against Ingo's proposed
performance counter infrastructure.  This is on
a Core2 Q6600 (the only machine I have that supports
Ingo's codebase).

For perfmon3 comparison, it's the same machine running
2.6.27.4 patched with the appropriate full (not stripped-down)
perfmon3 patchset available from perfmon2.sf.net.

All code for these tests can be had from:
   http://www.csl.cornell.edu/~vince/projects/perf_counter/

#
# 100 instruction test
#

Testing with a 100 instruction assembly program:

# perfmon3

tasse:~/assembly_tests% pfmon -e INSTRUCTIONS_RETIRED ./100_insns
100 INSTRUCTIONS_RETIRED

# Ingo

tasse:~/assembly_tests% ./timec -e 1 ./100_insns

  Performance counter stats for './100_insns':

               0.762  task clock ticks     (millisecs)

 	      2446  instructions         (events)

As we can see, timec overcounts by a lot!  Is it 24x, or
a fixed value?


#
# 8 billion instruction comparison
#

# perfmon3


tasse:~/assembly_tests% time pfmon -e INSTRUCTIONS_RETIRED ./8B_insns
8000000440 INSTRUCTIONS_RETIRED
1.77s user 0.00s system 100% cpu 1.771 total

Note that on almost all x86 chips that any hardware interrupt that
occurs adds an extra retired instruction to the total count
(some AMD engineers told me this is probably due to some artifact
  due to long pipelines and how the microcode changes user/kernel
  flag).

So you see that in 1.77s we acccumulate 1.77s*250Hz timer interrupts
which is 442.5 which is roughly the extra instructions we see.

(for more info on sources of non-determinism in instruction counting
  with performance counters see the paper here:
    http://www.csl.cornell.edu/~vince/papers/iiswc08 )


# ingo

tasse:~/assembly_tests% ./timec -e 1 ./8B_insns

  Performance counter stats for './8B_insns':

            1743.446  task clock ticks     (millisecs)

 	   8000002799  instructions         (events)


So it turns out the overhead isn't 24x, but is actually
a fixed 2300 or so.

Still, that's overhead perfmon does not have.

Will this be fixed, or is it an inherent limitation of
the new proposal?

Vince
