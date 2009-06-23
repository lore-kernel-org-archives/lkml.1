Return-Path: <linux-kernel-owner+w=401wt.eu-S1759265AbZFWNPH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759265AbZFWNPH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 09:15:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754232AbZFWNOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 09:14:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49210 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753386AbZFWNOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 09:14:52 -0400
Date: Tue, 23 Jun 2009 15:14:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Brice Goglin <Brice.Goglin@inria.fr>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, paulus@samba.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [perf] howto switch from pfmon
Message-ID: <20090623131450.GA31519@elte.hu>
References: <4A3FEF75.2020804@inria.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A3FEF75.2020804@inria.fr>
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

* Brice Goglin <Brice.Goglin@inria.fr> wrote:

> Hello,
>
> I am trying to play with perfcounters in current git (actually in
> latest mmotm). I'd like to reproduce what I previously did with
> pfmon, but I couldn't so far.
>
> Something like
>     pfmon --follow-exec 'foobar' -e
> CPU_TO_DRAM_REQUESTS_TO_TARGET_NODE:LOCAL_TO_0,CPU_TO_DRAM_REQUESTS_TO_TARGET_NODE:LOCAL_TO_1
> -- <shell script>
> gives the number of memory accesses to dram node #0 and #1 for all
> processes whose name matches 'foobar'.
>
> So there are several questions here:
> 1) is it possible to specify counter names like the above or do we have
> to use raw counter numbers? I tried raw numbers from [1] without
> success. How am I supposed to find and specify these raw numbers?
> 2) how do we specify "subevents"?
> 3) is there anything similar to --follow-exec, or --follow-pthreads for
> getting separated outputs for each thread?
>
> I guess there are still a lot of things on the TODOlist but I'd 
> like to understand a bit more where things are going. Sorry I 
> didn't read all the archives about this, there are way too many of 
> them recently :)

Yeah, there's indeed still a lot on the TODO list :-)

CPU_TO_DRAM_REQUESTS_TO_TARGET_NODE is a Barcelona hardware event, 
so if you know that it maps to raw ID 0x100000e0 then you can always 
extend the events that 'perf' knows about via raw events:

 $ perf stat -e cycles -e instructions -e r1000ffe0 ./hackbench 10
 Time: 0.186

 Performance counter stats for './hackbench 10':

     4381248335  cycles
     1964394846  instructions         #      0.448 IPC
            838  raw 0x1000ffe0

    0.215382037  seconds time elapsed.

That 'r1000ffe0' is the raw event. You can also do a profile with
such events:

  perf record -f -e r1000ffe0 ./hackbench 10

and look at it via 'perf report'.

Figuring out raw codes is certainly avoidable, we could probably
integrate all the oprofile (and PAPI) event names into perf too,
from the /usr/share/oprofile/ event lists perhaps - for easier
migration for those who got used to those event names. It also gives
a wider set of events - which is useful if you got used to any
specific name.

The Barcelona events are listed in listed in section 3.14 of "BIOS
and Kernel Developer's Guide for AMD Familiy 10h Processors", that's
where all the projects take these symbols from. If you want to
contribute then creating such tables for 'perf', for model-specific
events would certainly be useful.

[ Note, there's no need to specify any --follow-* flags as that is
  implicit in 'perf'. (and you'll probably also notice that perf
  stat is a lot faster at following fast-forking or
  context-switching workloads than is pfmon, because it's not ptrace
  based.) ]

And please let us know if you see any weirdness/difficulty while
using 'perf' or if you just notice some quirky thing in the tool.

Thanks,

	Ingo
