Return-Path: <linux-kernel-owner+w=401wt.eu-S1759242AbXLMMzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759242AbXLMMzU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 07:55:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752704AbXLMMzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 07:55:07 -0500
Received: from mga01.intel.com ([192.55.52.88]:15464 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137AbXLMMzF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 07:55:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,162,1196668800"; 
   d="scan'208";a="436344676"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: x86, ptrace: support for branch trace store(BTS)
Date: Thu, 13 Dec 2007 12:51:58 -0000
Message-ID: <029E5BE7F699594398CA44E3DDF5544401186D54@swsmsx413.ger.corp.intel.com>
In-Reply-To: <20071213102939.GS8977@elte.hu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: x86, ptrace: support for branch trace store(BTS)
thread-index: Acg9dPGkct1dMq/ZSaa9KXz/AKiqeQABx32g
References: <20071210123809.A14251@sedona.ch.intel.com> <20071210202052.GA26002@elte.hu> <029E5BE7F699594398CA44E3DDF5544401130A1E@swsmsx413.ger.corp.intel.com> <20071211145301.GA19427@elte.hu> <029E5BE7F699594398CA44E3DDF554440115D3C5@swsmsx413.ger.corp.intel.com> <20071212110330.GD1611@elte.hu> <029E5BE7F699594398CA44E3DDF554440115D6DC@swsmsx413.ger.corp.intel.com> <20071213102939.GS8977@elte.hu>
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: <ak@suse.de>, <hpa@zytor.com>, <linux-kernel@vger.kernel.org>,
       <tglx@linutronix.de>, <markus.t.metzger@gmail.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>, <roland@redhat.com>,
       <akpm@linux-foundation.org>, <mtk.manpages@gmail.com>,
       "Alan Stern" <stern@rowland.harvard.edu>
X-OriginalArrivalTime: 13 Dec 2007 12:51:59.0518 (UTC) FILETIME=[F3330BE0:01C83D86]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Ingo Molnar [mailto:mingo@elte.hu] 
>Sent: Donnerstag, 13. Dezember 2007 11:30

>> Users who want to process that huge amount of data would be 
>better off 
>> using a file-based approach (well, if it cannot be held in physical 
>> memory, they will spend most of their time swapping, anyway). Those 
>> users would typically wait for the 'buffer full' event and drain the 
>> buffer into a file - whether this is the real buffer or a bigger 
>> virtual buffer.
>> 
>> The two-buffer approach would only benefit users who want to 
>hold the 
>> full profile in memory - or who want to stall the debuggee 
>until they 
>> processed or somehow compressed the data collected so far. Those 
>> approaches would not scale for very big profiles. The small profile 
>> cases would already be covered with a reasonably big real buffer.
>
>well, the two-buffer approach would just be a general API with no 
>limitations. It would make the internal buffer mostly a pure 
>performance 
>detail.

Agreed.


Somewhat.

A user-provided second buffer would need to be up-to-date when we switch
to the user's task.
We would either need to drain the real buffer when switching from the
traced task;
or we would need to drain the real buffers of all traced tasks when
switching to the tracing task.
Both would require a get_user_pages() during context switching.

Alternatively, we could schedule a kernel task to drain the real buffer
when switching from a traced task.
The tracing task would then need to wait for all those kernel tasks. I'm
not sure how that affects scheduling fairness. And it's getting quite
complicated.


A kernel-provided second buffer could be entirely hidden behind the
ptrace (or, rather, ds) interface. It would not even have to be drained
before switching to the tracing task, since ds would just look into the
real buffer and then move on to the second buffer - transparent to the
user. Its size could be deducted from the user's memory limit and it
could be in pageable memory.

We would not be able to give precise overflow signals, that way (the
not-yet-drained real buffer might actually cause an overflow of the
second buffer, when drained). By allowing the user to query for the
number of BTS records to drain, we would not need to. A user drain would
drain both bufers.

The second buffer would be a pure performance/convenience detail of ds,
just like you suggested.


The ptrace API would allow the user to:
- define (and query) the overflow mechanism 
  (wrap-around or event)
- define (and query) the size of the buffer within certain limits
  (we could either give an error or cut off)
- define (and query) events to be monitored
  (last branch trace, scheduling timestamps)
- get a single BTS record
- query the number of BTS records
  (to find out how big your drain buffer needs to be; it may be bigger
than you requested)
- drain all BTS records (copy, then clear)
- clear all BTS records

Draining would require the user to allocate a buffer to hold the data,
which might not be feasible when he is near his memory limit. He could
fall back to looping over the single-entry get. It is questionable, how
useful the drain ptrace command would actually be; we might want to
replace it with a get range command.


Are you OK with this?


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

