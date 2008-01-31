Return-Path: <linux-kernel-owner+w=401wt.eu-S934757AbYAaRqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934757AbYAaRqX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 12:46:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762904AbYAaRqB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 12:46:01 -0500
Received: from mga02.intel.com ([134.134.136.20]:64271 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760071AbYAaRp6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 12:45:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,286,1199692800"; 
   d="scan'208";a="256025038"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: ptrace API extensions for BTS
Date: Thu, 31 Jan 2008 17:45:45 -0000
Message-ID: <029E5BE7F699594398CA44E3DDF55444014C8491@swsmsx413.ger.corp.intel.com>
In-Reply-To: <7c86c4470801310315w4d73c948tc0e0995c33a61260@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: ptrace API extensions for BTS
thread-index: Achj+qOJVS24kxNzRzioxrlVfYRWZgAKzDUA
References: <029E5BE7F699594398CA44E3DDF55444010F8D7C@swsmsx413.ger.corp.intel.com> <20080130072557.EC73C26F9A7@magilla.localdomain> <029E5BE7F699594398CA44E3DDF55444014A55DD@swsmsx413.ger.corp.intel.com> <7c86c4470801300301n426f3ab4n94419db3a5553936@mail.gmail.com> <029E5BE7F699594398CA44E3DDF55444014A581D@swsmsx413.ger.corp.intel.com> <7c86c4470801310315w4d73c948tc0e0995c33a61260@mail.gmail.com>
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: "stephane eranian" <eranian@googlemail.com>
Cc: "Roland McGrath" <roland@redhat.com>, "Ingo Molnar" <mingo@elte.hu>,
       <linux-kernel@vger.kernel.org>, <markus.t.metzger@gmail.com>
X-OriginalArrivalTime: 31 Jan 2008 17:45:50.0820 (UTC) FILETIME=[1E83FA40:01C86431]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: stephane eranian [mailto:eranian@googlemail.com] 
>Sent: Donnerstag, 31. Januar 2008 12:16

>I looked at your code. My understanding is that it abstracts the BTS
>so that higher
>level code does not have to know the intricacies of the implementation
>especially
>given that the changed the DS_AREA structure a lot between P4 
>and Core 2.

correct.

>I noticed that your code does not support 64-bit Netburst 
>DS_AREA configuration.
>I have used that myself and it works. Also Penryn support is missing
>(Fam 6 model 23).

correct. I started with the hardware underneath my desk. I plan to
support more hardware once the feature is perceived as being useful.


>The code does not actually touch the HW resource. This needs to be
>added somehow.
>It must be part of a register allocator outside of ds.c. We could
>extend the simple
>allocator currently used for the PMU registers in perfctr-watchdog.c.
>In fact, that one
>would have to be generalized.
>
>Perfmon does read/write the DS_AREA pointer and content. PEBS 
>is supported in
>per-thread and system-wide mode. This means that we 
>save/restore DS_AREA pointer
>on ctxsw. Perfmon does not touch the BTS specific fields, just 
>the PEBS relevant
>fields. PEBS does generate interrupts and they are routed via 
>the PMU interrupt.

I added ds_area to the thread_struct; someone added debugctl before.

On context-switch, the DS_AREA MSR is written if and only if the next
thread has a different ds_area entry than the prev thread and either one
has the corresponding TIF flag set.


>Internally perfmon2 needs to access the internals of the ds_area to
>fiddle with the
>pebs_index/pebs_intr_thres. Some of that code is in the 
>perfmon core and not in
>the model specific (P4 vs. Core) kernel module. On Core2, I 
>think I could get
>rid of this dependency but not on P4. I could use your code to 
>abstract the DS
>area and give me access to the pebs fields in a more generic 
>way. that assumes
>you would add PEBS support to ds.c.

That's what I was thinking as well.

It could also do the buffer memory management. I currently do the rlimit
check in ptrace.c and the allocation in ds.c. We should probably move
the rlimit check to ds.c, as well.

Currently, it also knows how to read and write a single BTS entry. And
it even understands the BTS format including artificial records. 

I would leave at least the knowledge how to read and write a BTS and
PEBS record inside ds.c. This way, we get all the overflow handling on
write in one place. I would definitely move the interpretation of
artificial records to its users.

It was very convenient for me to put the entire hardware abstraction
into ds.c. And it does make sense for BTS, since the general format is
identical for all processors.
This would not work for your zero-copy approach, though. And it makes
less sense for PEBS due to the different formats.
I need to think some more about this.


So far, ds.c would:
- do resource allocation of BTS and PEBS buffers per task (or
system-wide)
- do memory allocation for those buffers including rlimit checks
  - currently, I use non-pageable memory only
    there were ideas to use a pageable shadow buffer
    this would go here
- provide a PMI interrupt handler
  - users would register a callback for overflow notification
  - wrap-around, if NULL callback
- allow read and write of BTS and PEBS records
- give (read-only) access to BTS and PEBS pointers

What do you think?


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

