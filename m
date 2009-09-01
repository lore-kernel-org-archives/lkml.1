Return-Path: <linux-kernel-owner+w=401wt.eu-S1753904AbZIALSZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904AbZIALSZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 07:18:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753888AbZIALSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 07:18:24 -0400
Received: from mga01.intel.com ([192.55.52.88]:38951 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753887AbZIALSX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 07:18:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,311,1249282800"; 
   d="scan'208";a="489367081"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Peter Zijlstra <peterz@infradead.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>
Date: Tue, 1 Sep 2009 12:17:43 +0100
Subject: [discuss] BTS overflow handling, was: [PATCH] perf_counter: Fix a
 race on perf_counter_ctx
Thread-Topic: [discuss] BTS overflow handling, was: [PATCH] perf_counter:
 Fix a race on perf_counter_ctx
Thread-Index: AcogDESxIZikYvgbR8+ZVlKWWtGSsQAAbMtAAe2TxCAAyoKesA==
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77EC465F989@irsmsx504.ger.corp.intel.com>
References: <20090808120315.GA14086@elte.hu>
 <928CFBE8E7CB0040959E56B4EA41A77EC1BFF464@irsmsx504.ger.corp.intel.com>
 <20090810134608.GA8295@elte.hu>
 <928CFBE8E7CB0040959E56B4EA41A77EC1BFF78D@irsmsx504.ger.corp.intel.com>
 <928CFBE8E7CB0040959E56B4EA41A77EC1CB7725@irsmsx504.ger.corp.intel.com>
 <1250600348.7583.280.camel@twins> <1250600385.7583.281.camel@twins>
 <928CFBE8E7CB0040959E56B4EA41A77EC1CB7775@irsmsx504.ger.corp.intel.com>
 <1250602664.7583.293.camel@twins>
 <928CFBE8E7CB0040959E56B4EA41A77EC1CB77C8@irsmsx504.ger.corp.intel.com>
 <20090818140022.GB13013@elte.hu>
 <928CFBE8E7CB0040959E56B4EA41A77EC1CB77FF@irsmsx504.ger.corp.intel.com>
 <928CFBE8E7CB0040959E56B4EA41A77EC465EFC5@irsmsx504.ger.corp.intel.com>
In-Reply-To: <928CFBE8E7CB0040959E56B4EA41A77EC465EFC5@irsmsx504.ger.corp.intel.com>
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

Ingo, Peter,

>>>> Currently, I'm not sure that this (i.e. that the interrupt
>>>> handling takes too long) is the underlying problem of the hangs
>>>> that I'm seeing.
>>>
>>>I havent seen a plausible theory yet about why an actual lockup
>>>would happen on your box.
>>
>>So you do not think that taking too long in the ISR could cause this?
>>
>>And is it working on your box?

My current theory is that the BTS buffer fills up so quickly when tracing
the kernel, that the kernel is busy handling overflows and reacting on
other interrupts that pile up while we're handling the BTS overflow.

When I trace user-mode branches, it works.

When I do not copy the trace during overflow handling, the kernel does not hang.

When I attach a jtag debugger to a hung system (perf top and perf record
-e branches -c 1), I find that one core is waiting for an smp call
response, while the other core is busy emptying the BTS buffer.

When I then disable branch tracing (the debugger prevents the kernel
from changing DEBUGCTL to enable tracing again), the system recovers.


I have a patch that switches buffers during overflow handling and leaves
the draining for later (which currently never happens) - the kernel does
not hang, in that case.

I do need 3 buffers of 2048 entries = 3x48 pages per cpu, though. One buffer
to switch in during overflow handling; another to switch in during sched_out
(assuming that we need to schedule out the traced task before we may start
the draining task). Even then, there's a chance that we will lose trace
when the draining task may not start immediately. I would even say that
this is quite likely.


What I do not have, yet, is the actual draining. Draining needs to start
after the counter has been disabled. But draining needs the perf_counter
to drain the trace into. The counter will thus be busy after it has been
disabled - ugly.

There already seems to be something in place regarding deferring work, i.e.
perf_counter_do_pending(). Would it be OK if I added the deferred BTS buffer
draining to that?

Looks like this would guarantee that the counter does not go away as long
as there is work pending. Is this correct?



In any case, this is getting late for the upcoming merge window.
Would you rather drop the BTS patch or disable kernel tracing?

thanks and regards,
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

