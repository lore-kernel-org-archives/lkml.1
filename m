Return-Path: <linux-kernel-owner+w=401wt.eu-S1754536AbZCYJH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536AbZCYJH4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 05:07:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752457AbZCYJHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 05:07:47 -0400
Received: from mga11.intel.com ([192.55.52.93]:48801 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188AbZCYJHp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 05:07:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,418,1233561600"; 
   d="scan'208";a="441855838"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: Ingo Molnar <mingo@elte.hu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "eranian@googlemail.com" <eranian@googlemail.com>,
       "oleg@redhat.com" <oleg@redhat.com>,
       "Villacis, Juan" <juan.villacis@intel.com>,
       "ak@linux.jf.intel.com" <ak@linux.jf.intel.com>
Date: Wed, 25 Mar 2009 09:07:41 +0000
Subject: RE: [patch] x86, bts: use atomic memory allocation
Thread-Topic: [patch] x86, bts: use atomic memory allocation
Thread-Index: AcmppmVqrENm4U91Tu60ejkxQ5efXgDf/R9A
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77E92607ED7@irsmsx504.ger.corp.intel.com>
References: <20090318192700.A6038@sedona.ch.intel.com>
 <20090319161141.GA12144@elte.hu>
 <928CFBE8E7CB0040959E56B4EA41A77E923FFCA4@irsmsx504.ger.corp.intel.com>
 <20090320185559.GA6224@elte.hu>
In-Reply-To: <20090320185559.GA6224@elte.hu>
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
>Sent: Friday, March 20, 2009 7:56 PM
>To: Metzger, Markus T


>> >> Ds_request_bts() needs to allocate memory. It uses GFP_KERNEL.
>> >>
>> >> Hw-branch-tracer calls ds_request_bts() within on_each_cpu().
>> >>
>> >> Use atomic memory allocation to allow it to be used in that context.
>> >
>> >the hw-branch-tracer still crashes during bootup. Have you tried the
>> >config i sent to you, and have you tried to reproduce it? I've
>> >attached another config that crashes.
>>
>> The first config boots OK.
>
>> The second config boots OK with the additional changes to keep the
>> GFP_KERNEL and move the ds_request_bts() calls out of the
>> on_each_cpu() in the hw-branch-tracer.
>>
>> I don't know yet what exactly causes the crash and if there is a
>> simpler fix.
>
>hm, this was an AMD box - so perhaps they dont have a compatible DS
>implementation?

If no trace hardware is detected, the hw-branch tracer returns -EOPNOTSUPP.
I doubt that there is an incompatible DS implementation.


I found a bug that leads to a kernel crash.

If the tracing task exits, it disables bts tracing for all its children and then
frees the trace buffer. If the children are currently executing, the buffer
may be freed while the hardware is still tracing. This might cause the hardware to
overwrite memory.

I would need to wait until the traced task is rescheduled, trigger a rescheduling,
or actively disable tracing on the traced task's cpu.

Unfortunately, most of the ptrace exit code is executed with irq's disabled and
tasklist_lock write-held.
I am currently trying to find a way to do this at a time when irq's are enabled.

This affects the ptrace bts extension for .29 and tip/tracing/hw-branch-tracing.
The hw-branch-tracer is not affected.


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

