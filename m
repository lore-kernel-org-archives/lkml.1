Return-Path: <linux-kernel-owner+w=401wt.eu-S1756921AbXLLMYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921AbXLLMYz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 07:24:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752110AbXLLMYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 07:24:46 -0500
Received: from mga03.intel.com ([143.182.124.21]:22331 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751666AbXLLMYp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 07:24:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,156,1196668800"; 
   d="scan'208";a="339372335"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: x86, ptrace: support for branch trace store(BTS)
Date: Wed, 12 Dec 2007 12:23:39 -0000
Message-ID: <029E5BE7F699594398CA44E3DDF554440115D6DC@swsmsx413.ger.corp.intel.com>
In-Reply-To: <20071212110330.GD1611@elte.hu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: x86, ptrace: support for branch trace store(BTS)
thread-index: Acg8rufbnFmMidkXQkaaA91vYvOGIQAAjkUQ
References: <20071210123809.A14251@sedona.ch.intel.com> <20071210202052.GA26002@elte.hu> <029E5BE7F699594398CA44E3DDF5544401130A1E@swsmsx413.ger.corp.intel.com> <20071211145301.GA19427@elte.hu> <029E5BE7F699594398CA44E3DDF554440115D3C5@swsmsx413.ger.corp.intel.com> <20071212110330.GD1611@elte.hu>
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: <ak@suse.de>, <hpa@zytor.com>, <linux-kernel@vger.kernel.org>,
       <tglx@linutronix.de>, <markus.t.metzger@gmail.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>, <roland@redhat.com>,
       <akpm@linux-foundation.org>, <mtk.manpages@gmail.com>,
       "Alan Stern" <stern@rowland.harvard.edu>
X-OriginalArrivalTime: 12 Dec 2007 12:23:41.0390 (UTC) FILETIME=[D49F86E0:01C83CB9]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Ingo Molnar [mailto:mingo@elte.hu] 
>Sent: Mittwoch, 12. Dezember 2007 12:04

>> Would it be safe to drop the artificial limit and let the 
>limit be the 
>> available memory?
>
>no, that would be a DoS :-/

How about:

for (;;) {
	int pid = fork();
	if (pid) 
		ptrace_allocate(pid, <small_buffer_size>);
}


I guess what we really want is a per-task kalloc() limit. That limit can
be quite big.

Should this rather be within kalloc() itself (with the data stored in
task_struct) or should this be local to ptrace_bts_alloc?

Is there already a per-task memory limit? We could deduct the kalloc()ed
memory from that.


>> the most useful behavior in that case. I'm not sure what you 
>mean with 
>> 'instrumentation'.
>
>the branch trace can be used to generate a very finegrained 
>profile/histogram of code execution - even of rarely executed 
>codepaths 
>which cannot be captured via timer/perf-counter based profiling.
>
>another potential use would be for call graph coverage testing. (which 
>currently requires compiler-inserted calls - would be much nicer if we 
>could do this via the hardware.)
>
>etc. Branch tracing isnt just for debugging i think - as long as the 
>framework is flexible enough.

Agreed.


>> The actual physical memory consumption will be worse (or at best 
>> equal) compared to kalloc()ed memory, since we need to pin 
>down entire 
>> pages, whereas kalloc() would allocate just the memory that is 
>> actually needed.
>
>i agree that mlock() has problems. A different model would be: 

I have my doubts regarding any form of two-buffer approach. 

Let's assume we find a way to get a reasonably big limit. 

Users who want to process that huge amount of data would be better off
using a file-based approach (well, if it cannot be held in physical
memory, they will spend most of their time swapping, anyway). Those
users would typically wait for the 'buffer full' event and drain the
buffer into a file - whether this is the real buffer or a bigger virtual
buffer.

The two-buffer approach would only benefit users who want to hold the
full profile in memory - or who want to stall the debuggee until they
processed or somehow compressed the data collected so far.
Those approaches would not scale for very big profiles.
The small profile cases would already be covered with a reasonably big
real buffer.

The two-buffer approach is moving out the limit of what can be profiled
in (virtual) memory.


Independent of how many buffers we have, we need to offer overflow
handling. This could be:
1. cyclic buffer
2. buffer full event

Robust users would either:
a. select 2 and ignore the overflow signal to collect an initial profile
b. select 1 to collect a profile tail
c. select 2 and drain the real or virtual buffer into a file to collect
the full profile
d. select 2 and bail out on overflow (robust but limited usefulness)

Debuggers would typically choose b. Path profilers would typically
choose c. Student projects would typically choose d.


I see benefit in providing a second overflow handling method. 
I only see benefit in a bigger second buffer if we cannot get the limit
to a reasonable size.

Am I missing something?


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
