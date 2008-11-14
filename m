Return-Path: <linux-kernel-owner+w=401wt.eu-S1752665AbYKNOlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665AbYKNOlu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 09:41:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751278AbYKNOlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 09:41:42 -0500
Received: from mga01.intel.com ([192.55.52.88]:59231 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222AbYKNOll convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 09:41:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,603,1220252400"; 
   d="scan'208";a="639185661"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: debugctl msr
Date: Fri, 14 Nov 2008 14:41:21 -0000
Message-ID: <029E5BE7F699594398CA44E3DDF5544402B595A3@swsmsx413.ger.corp.intel.com>
In-Reply-To: <7c86c4470811130650j4192c63n1fa9800a0cdfb93c@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: debugctl msr
Thread-Index: AclFnzHgaoSf18yQRjOvlLh9x+VacAAxasTQ
References: <7c86c4470810300753v7d377092qbcd266178d8e7338@mail.gmail.com> <7c86c4470811050505j678c6929if00cceda2af8cb17@mail.gmail.com> <7c86c4470811050711w3753232fk1030fb00259a7b8@mail.gmail.com> <029E5BE7F699594398CA44E3DDF5544402AB350E@swsmsx413.ger.corp.intel.com> <7c86c4470811060249g62666885nbaa559c1777217a0@mail.gmail.com> <1226236327.6104.4.camel@raistlin> <7c86c4470811111411k754887a8ic9b63163928157a6@mail.gmail.com> <491A812D.9010208@gmail.com> <7c86c4470811120210j2ea5ccdcv59a654aadc32ebd2@mail.gmail.com> <029E5BE7F699594398CA44E3DDF5544402B1F123@swsmsx413.ger.corp.intel.com> <7c86c4470811130650j4192c63n1fa9800a0cdfb93c@mail.gmail.com>
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: <eranian@gmail.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andi Kleen" <andi@firstfloor.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>,
       "Markus Metzger" <markus.t.metzger@googlemail.com>
X-OriginalArrivalTime: 14 Nov 2008 14:41:25.0909 (UTC) FILETIME=[12488C50:01C94667]
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: stephane eranian [mailto:eranian@googlemail.com] 
>Sent: Donnerstag, 13. November 2008 15:51
>To: Metzger, Markus T

>I looked at the ds.c source code some more. I think the problem when
>trying to use it with perfmon is because you are assuming that by the
>time you allocate the buffer you know the task it is going to 
>be attached to.
>With perfmon this assumption is always wrong. Perfmon decouples each
>step:
>    1- allocation of the memory for the buffer
>    2- initialization of the buffer
>    3- binding of the buffer to its target thread or CPU
>    4- saving/restoring of PMU/DS/PEBS registers
>
>The idea is that you can prepare your measurement/buffer and then
>attach to a task.
>Should you be following across fork/pthread_create, you could 
>prepare in advance
>a pool of ready-to-go perfmon sessions, all you'd have to do then is
>attach + start.
>
>In ds.c:ds_request_pebs(), you assume that if task == NULL, then this
>is a per-cpu session.
>If you could decouple that by passing a type parameter for instance
>and if you were to add
>a ds_attach_pebs() then I think I could use the interface.

Let's assume that there is a BTS user who is also following fork.
That user is also preparing a set of pre-allocated buffers and he would
want to call ds_attach_bts() to attach his buffers.

ds_attach_*() would need to merge the configurations of the BTS and the
PEBS user. We thus cannot pre-configure the DS configurations as such.

Let's further assume that there is a second PEBS user who wants to trace
every task and thus calls ds_request_pebs() somewhere in do_fork().

ds_attach_*() would need to make sure that PEBS/BTS is not already in
use.

In the end, I'm afraid we're reimplementing ds_request_*().


You may still pre-allocate PEBS buffers. When following fork, you would
call ds_request_pebs(), provide the pre-allocated buffer, and handle
possible errors.

regards,
markus.

>
>
>On Wed, Nov 12, 2008 at 11:59 AM, Metzger, Markus T
><markus.t.metzger@intel.com> wrote:
>>>-----Original Message-----
>>>From: stephane eranian [mailto:eranian@googlemail.com]
>>>Sent: Mittwoch, 12. November 2008 11:10
>>>To: Markus Metzger
>>
>>>>> For perfmon, PEBS can be used for both per-thread and 
>per-cpu. With
>>>>> perfmon, the allocation/initialization of the buffer is
>>>separated from its
>>>>> activation. In other words, allocation/initialization may
>>>be done before
>>>>> you
>>>>> actually have to write the DS_AREA MSR.
>>>Allocation/initialization may not
>>>>> necessary be done on the cpu you want to measure in per-cpu
>>>mode. The
>>>>> logic of DS is different, ds_request_pebs() allocates and
>>>immediately
>>>>> writes
>>>>> DS_AREA. I cannot use that.
>>>>
>>>> DS_AREA contains a pointer to the actual configuration struct.
>>>> The idea is that once I allocated the configuration struct,
>>>I can write
>>>> the pointer to it into DS_AREA. It won't be used unless I
>>>turn on a feature
>>>> that uses DS.
>>>> So, the flow is:
>>>> 1. allocate configuration struct
>>>> 2. write DS_AREA
>>>
>>>What if you are allocating the buffer for another task. For instance,
>>>a tool is attaching
>>>to a running process and wants to use PEBS. The tool allocates and
>>>initializes the
>>>PEBS buffer and then attaches it to the task to monitor (which is
>>>stopped). When the
>>>task is scheduled again, it picks up the PEBS buffer, and
>>>DS_AREA is written to.
>>
>> That tool should request DS for the task it intends to attach its
>> PEBS buffer to. Who knows, maybe PEBS is already in use for that task
>> by someone else. Or maybe there is a system wide BTS or PEBS session
>> and the per-task request would need to be rejected (until we can
>> support this scenario).
>>
>>
>>
>>>There is another reason why the DS_AREA is exposed. This is
>>>the only way for
>>>tools to see the current position in the PEBS buffer. They may
>>>want to poll on
>>>that position index. The PEBS buffer is not necessarily full. What if
>>>the session
>>>terminates with a partial buffer. There must be a way for the
>>>tool to figure out
>>>where the last sample is. By exposing DS read-only the index
>>>is always available
>>>and always guaranteed current. Without this, the kernel would have to
>>>extract the
>>>index (pebs_get_index) and store it somewhere so the user can
>>>see it. This copy
>>>could be tirggered by a PEBS buffer overflow or a stop of
>>>monitoring. Sampling
>>>buffers formats currently do not have a stop callback but this can be
>>>added easily.
>>
>> With the current interface, you would need to call 
>ds_get_pebs_index().
>>
>> The rfc patch I sent out some weeks ago in the scope of multiplexing
>> uses the approach you described - at least in-kernel.
>> Upon ds_request_pebs(), you would get a const struct 
>pebs_tracer* that
>> contains a const view of the DS configuration.
>>
>>
>> In any case, I think the DS configuration needs to be 
>allocated by ds.c
>> since we have two independent users that need to share a single
>> configuration.
>>
>> Would it help if we changed the DS interface as proposed in that rfc
>> patch (without all the multiplexing stuff)?
>>
>>
>> regards,
>> markus.
>> ---------------------------------------------------------------------
>> Intel GmbH
>> Dornacher Strasse 1
>> 85622 Feldkirchen/Muenchen Germany
>> Sitz der Gesellschaft: Feldkirchen bei Muenchen
>> Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
>> Registergericht: Muenchen HRB 47456 Ust.-IdNr.
>> VAT Registration No.: DE129385895
>> Citibank Frankfurt (BLZ 502 109 00) 600119052
>>
>> This e-mail and any attachments may contain confidential material for
>> the sole use of the intended recipient(s). Any review or distribution
>> by others is strictly prohibited. If you are not the intended
>> recipient, please contact the sender and delete all copies.
>>
>>
>
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

