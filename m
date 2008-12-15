Return-Path: <linux-kernel-owner+w=401wt.eu-S1757225AbYLOVCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757225AbYLOVCm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 16:02:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755356AbYLOVCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 16:02:34 -0500
Received: from smtpauth00.csee.onr.siteprotect.com ([64.26.60.144]:44873 "EHLO
	smtpauth00.csee.onr.siteprotect.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754621AbYLOVCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 16:02:33 -0500
Date: Mon, 15 Dec 2008 16:07:13 -0500 (EST)
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
In-Reply-To: <Pine.LNX.4.64.0812151243130.2773@pianoman.cluster.toy>
Message-ID: <Pine.LNX.4.64.0812151606280.3197@pianoman.cluster.toy>
References: <20081214212829.GA9435@elte.hu> <Pine.LNX.4.64.0812151243130.2773@pianoman.cluster.toy>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

I'm trying a more complicated benchmark and getting even stranger
results.

This is still on the Q6600 machine

The benchmark does a loop, reading some memory.  It should have
roughly:
    12295 instructions
     4096 memory loads
     4096 branches

perfmon3 is close on all of these stats, and this is consistent
across runs with a small variation (+/- 3 or so).

The timec program returns 0 (!) for all of the stats except
retired instruction count!  And with certain combinations
of counters I get 0 for all counts.  No error messages 
are printed.

Is this expected behavior?

The test program can be had from:
    http://www.csl.cornell.edu/~vince/projects/perf_counter/


Details below:

#
# Perfmon results
#

# First, trying to read all 5 events at once fails, only 4 counters 
# avail

tasse:~/assembly_tests% pfmon -e INSTRUCTIONS_RETIRED,BRANCH_INSTRUCTIONS_RETIRED,L1D_ALL_CACHE_REF,MEM_LOAD_RETIRED:L1D_MISS ./read_test
cannot configure events: set0 events incompatible or too many events

# Cache results are close to expected, L1D looks a little high

tasse:~/assembly_tests% pfmon -e INSTRUCTIONS_RETIRED,L1D_ALL_CACHE_REF,MEM_LOAD_RETIRED:L1D_MISS ./read_test
12299 INSTRUCTIONS_RETIRED
  4164 L1D_ALL_CACHE_REF
     4 MEM_LOAD_RETIRED:L1D_MISS

# Branch results.  Close to what they should be, though a bit higher
#  than expected.

tasse:~/assembly_tests% pfmon -e INSTRUCTIONS_RETIRED,BRANCH_INSTRUCTIONS_RETIRED,MISPREDICTED_BRANCH_RETIRED ./read_test
12299 INSTRUCTIONS_RETIRED
  4102 BRANCH_INSTRUCTIONS_RETIRED
     1 MISPREDICTED_BRANCH_RETIRED


#
# performance counter v4
#

# Including all stats gives no errors, but gives no results
# either


tasse:~/assembly_tests% ./timec -e 0 -e 1 -e 2 -e 3 -e 4 -e 5 ./read_test

  Performance counter stats for './read_test':

              0.716  task clock ticks     (millisecs)

              85049  cycles               (events)
                  0  instructions         (events)
                  0  cache references     (events)
                  0  cache misses         (events)
                  0  branches             (events)
                  0  branch misses        (events)



#
# If I include the cycles count, I consistently get 0 
#   for all counts???

tasse:~/assembly_tests% ./timec -e 0 -e 1 -e 2 -e 3  ./read_test

  Performance counter stats for './read_test':

              0.520  task clock ticks     (millisecs)

              73833  cycles               (events)
                  0  instructions         (events)
                  0  cache references     (events)
                  0  cache misses         (events)

#
# If I drop the cycles count, I get an instruction count
#   with a value 2300 too high (see previous e-mail)
# And really low cache values.

tasse:~/assembly_tests% ./timec -e 1 -e 2 -e 3  ./read_test

  Performance counter stats for './read_test':

              0.723  task clock ticks     (millisecs)

              14644  instructions         (events)
                  8  cache references     (events)
                  0  cache misses         (events)


#
# And the branch stats don't work either
#

tasse:~/assembly_tests% ./timec -e 1 -e 4 -e 5 ./read_test

  Performance counter stats for './read_test':

              0.711  task clock ticks     (millisecs)

              14643  instructions         (events)
                  0  branches             (events)
                  0  branch misses        (events)

