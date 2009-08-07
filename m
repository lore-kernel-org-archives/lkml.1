Return-Path: <linux-kernel-owner+w=401wt.eu-S1757704AbZHGMOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757704AbZHGMOt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 08:14:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757617AbZHGMOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 08:14:48 -0400
Received: from mga11.intel.com ([192.55.52.93]:22065 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757201AbZHGMOr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 08:14:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,341,1246863600"; 
   d="scan'208";a="481617240"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 7 Aug 2009 13:14:32 +0100
Subject: RE: [patch] x86, perf_counter, bts: add bts to perf_counter
Thread-Topic: [patch] x86, perf_counter, bts: add bts to perf_counter
Thread-Index: AcoXUl7mta8lSBIWTRS8KzHNDCUjdQAAacug
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77EC1BFF09C@irsmsx504.ger.corp.intel.com>
References: <20090804111412.GA20942@elte.hu>
 <20090804113555.GA28198@elte.hu>
 <928CFBE8E7CB0040959E56B4EA41A77EC1BFEEE3@irsmsx504.ger.corp.intel.com>
 <1249633282.32113.613.camel@twins>
 <928CFBE8E7CB0040959E56B4EA41A77EC1BFEFEB@irsmsx504.ger.corp.intel.com>
 <20090807103127.GA23139@elte.hu> <20090807103610.GA23728@elte.hu>
 <928CFBE8E7CB0040959E56B4EA41A77EC1BFF02D@irsmsx504.ger.corp.intel.com>
 <928CFBE8E7CB0040959E56B4EA41A77EC1BFF048@irsmsx504.ger.corp.intel.com>
 <20090807112634.GC30014@elte.hu> <20090807112931.GA31401@elte.hu>
In-Reply-To: <20090807112931.GA31401@elte.hu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Ingo Molnar [mailto:mingo@elte.hu]
>Sent: Friday, August 07, 2009 1:30 PM
>To: Metzger, Markus T
>Cc: Peter Zijlstra; tglx@linutronix.de; hpa@zytor.com; markus.t.metzger@gmail.com; linux-
>kernel@vger.kernel.org
>Subject: Re: [patch] x86, perf_counter, bts: add bts to perf_counter
>
>
>* Ingo Molnar <mingo@elte.hu> wrote:
>
>> btw., the number of samples seems to be varying too widely:
>>
>> titan:~> for ((i=0;i<10;i++)); do perf record -f -e branches:u -c 1 true 2>/dev/null; perf report |
>head -1; done
>> # Samples: 28784
>> # Samples: 24063
>> # Samples: 22788
>> # Samples: 30449
>> # Samples: 15335
>> # Samples: 30557
>> # Samples: 24010
>> # Samples: 23866
>> # Samples: 24877
>> # Samples: 24330
>>
>> compared to the branch-stat itself:
>>
>> titan:~> perf stat -v --repeat 10 -e branches:u true
>> [ perf stat: executing run #1 ... ]
>> [ perf stat: executing run #2 ... ]
>> [ perf stat: executing run #3 ... ]
>> [ perf stat: executing run #4 ... ]
>> [ perf stat: executing run #5 ... ]
>> [ perf stat: executing run #6 ... ]
>> [ perf stat: executing run #7 ... ]
>> [ perf stat: executing run #8 ... ]
>> [ perf stat: executing run #9 ... ]
>> [ perf stat: executing run #10 ... ]
>>
>>  Performance counter stats for 'true' (10 runs):
>>
>>           23851  branches                   ( +-   0.000% )
>>
>>     0.000639653  seconds time elapsed   ( +-   2.474% )
>>
>> do we lose records in the recording?
>
>i doubt it's lost records. Even with SCHED_FIFO sampling and with a
>huge, 512 MB mmap ring-buffer we get a BTS sample count variation in
>the +- 10% range:
>
>titan:/home/mingo> for ((i=0;i<10;i++)); do perf record -r 1 -m
>131072 -f -e branches:u -c 1 true 2>/dev/null; perf report | head
>-1; done
># Samples: 24860
># Samples: 24177
># Samples: 26165
># Samples: 25682
># Samples: 29175
># Samples: 23136
># Samples: 27102
># Samples: 29888
># Samples: 25524
># Samples: 24266
>
>(and these are all just user-mode executions)


Hmmm, we do get a single branch record for the transition from kernel to user mode.
We should therefore expect some deviation, but 10% sounds too much to me.

Perf record traces itself and then exec's the application you want to trace.
So, you would get a mix of perf trace and actual application trace. That could explain
a 10% deviation.

Perf stat, on the other hand, seems to go through some effort to only trace the
actual application.

What do you think?

In my tests, I'm looking for deterministic trace, e.g. on-the-spot branches for
for(;;) {} loops or a branch to 0 for a null function pointer call. I pretty much
ignored the 'noise' around that.


regards,
markus.

---------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen Germany
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 Ust.-IdNr.
VAT Registration No.: DE129385895
Citibank Frankfurt (BLZ 502 109 00) 600119052

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

