Return-Path: <linux-kernel-owner+w=401wt.eu-S1760757AbZFKIbG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760757AbZFKIbG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 04:31:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761175AbZFKIai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 04:30:38 -0400
Received: from mga14.intel.com ([143.182.124.37]:23347 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761039AbZFKIae convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 04:30:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,201,1243839600"; 
   d="scan'208";a="153066776"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
       "oleg@redhat.com" <oleg@redhat.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Date: Thu, 11 Jun 2009 09:30:08 +0100
Subject: RE: [tip:tracing/core] Revert "x86, bts: reenable ptrace branch
 trace support"
Thread-Topic: [tip:tracing/core] Revert "x86, bts: reenable ptrace branch
 trace support"
Thread-Index: Acnqa+iTJVdj3N4AShSheST24T84KAAAMTeg
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77EBBC654C0@irsmsx504.ger.corp.intel.com>
References: <tip-511b01bdf64ad8a38414096eab283c7784aebfc4@git.kernel.org>
	 <928CFBE8E7CB0040959E56B4EA41A77EBBC6544B@irsmsx504.ger.corp.intel.com>
	 <1244702183.6691.8.camel@laptop>
	 <928CFBE8E7CB0040959E56B4EA41A77EBBC6546E@irsmsx504.ger.corp.intel.com>
 <1244707735.6691.16.camel@laptop>
In-Reply-To: <1244707735.6691.16.camel@laptop>
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
>From: Peter Zijlstra [mailto:peterz@infradead.org]
>Sent: Thursday, June 11, 2009 10:09 AM
>To: Metzger, Markus T
>Cc: linux-kernel@vger.kernel.org; mingo@redhat.com; hpa@zytor.com; oleg@redhat.com;
>tglx@linutronix.de; mingo@elte.hu; linux-tip-commits@vger.kernel.org
>Subject: RE: [tip:tracing/core] Revert "x86, bts: reenable ptrace branch trace support"
>
>On Thu, 2009-06-11 at 08:17 +0100, Metzger, Markus T wrote:
>> >That would indeed keep the proposed ABI workable, what I'm still not
>> >liking is that this buffer is in-kernel, but I guess that might be
>> >something for other people to have an opinion on.
>>
>> The alternative would be to give a user-allocated buffer to the tracing h/w.
>>
>> We would need to take precautions to prevent the user from messing around
>> with that buffer while the h/w is writing to it. Other code uses the kernel-
>> allocated buffer plus copy_to_user() approach, as well.
>>
>> Further, it would require the user to interpret the various tracing formats,
>> whereas the existing interface provides an architecture-independent format.
>>
>>
>> Does anybody have concerns on using an in-kernel buffer and providing a
>> copy_to_user() interface?
>
>Ah, if you mmap() you can do without copy_to_user().

The user would still need to call the kernel to interpret the trace data,
which would then require copy_to_user() for the interpreted data.


>Either way, you have to make sure the buffer is mlocked() anyway, since
>you're wanting to fill it from interrupt context.
>
>The advantage (imo) from letting the user set it up is that you don't
>need those separate allocation routines.

I would still need to mlock() the buffer. Those separate allocation routines
do the accounting work of mlock() on an already non-pageable buffer.

If you don't like those separate allocation routines, we could extract the
accounting part from mlock() into separate functions and I could use those.
These changes would again be in-kernel without impacting the API.


>But yes, it would expose the data to the user, but one could keep it
>opaque data, without requiring the user to be able to interpret it.

See above, the user would then need to call the kernel to interpret the data.
We would achieve exactly the same thing in a more complicated way:
- there's a buffer which the user cannot use directly
- the buffer must be locked and must not go away
- the user needs to call the kernel to read trace records from the buffer

If we let the user setup the buffer, all we gain is some additional overhead.
The user needs to request pages from the kernel. Malloc needs to administrate
this memory. The user then gives the memory back to the kernel, which locks it
and gives it to the h/w.


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

