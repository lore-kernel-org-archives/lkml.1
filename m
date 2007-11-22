Return-Path: <linux-kernel-owner+w=401wt.eu-S1754832AbXKVUHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832AbXKVUHX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 15:07:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753167AbXKVUHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 15:07:10 -0500
Received: from mga01.intel.com ([192.55.52.88]:41190 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752542AbXKVUHI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 15:07:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,453,1188802800"; 
   d="scan'208";a="398250388"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [patch][v2] x86, ptrace: support for branch trace store(BTS)
Date: Thu, 22 Nov 2007 20:06:51 -0000
Message-ID: <029E5BE7F699594398CA44E3DDF55444F97708@swsmsx413.ger.corp.intel.com>
In-Reply-To: <200711211240.12826.ak@suse.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch][v2] x86, ptrace: support for branch trace store(BTS)
thread-index: AcgsM8K1ueg9ikrUTLe+VCKVDFsq7wBCqwXA
References: <029E5BE7F699594398CA44E3DDF55444F3AEA7@swsmsx413.ger.corp.intel.com> <200711201345.39580.ak@suse.de> <029E5BE7F699594398CA44E3DDF55444F718D9@swsmsx413.ger.corp.intel.com> <200711211240.12826.ak@suse.de>
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: "Andi Kleen" <ak@suse.de>
Cc: <linux-kernel@vger.kernel.org>, <mingo@elte.hu>, <hpa@zytor.com>,
       <tglx@linutronix.de>, "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       <akpm@linux-foundation.org>
X-OriginalArrivalTime: 22 Nov 2007 20:06:51.0004 (UTC) FILETIME=[38431BC0:01C82D43]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>Your patch seems to be still word wrapped.

I hope this is better with the next version I'm going to
send out in a few minutes. Sorry about that.


>The noflags variant should be probably data driven too.

I rewrote the entire code to use an offset/size configuration
instead of declaring structs for the various architecture
variants.

>
>
>>  
>> +	case PTRACE_BTS_ALLOCATE_BUFFER:
>> +		ret = ptrace_bts_allocate_bts(child, data);
>> +		break;
>> +
>> +	case PTRACE_BTS_GET_BUFFER_SIZE:
>> +		ret = ptrace_bts_get_buffer_size(child);
>> +		break;
>> +
>> +	case PTRACE_BTS_GET_INDEX:
>> +		ret = ptrace_bts_get_index(child);
>> +		break;
>> +
>> +	case PTRACE_BTS_READ_RECORD:
>> +		ret = ptrace_bts_read_record
>> +			(child, data,
>> +			 (struct ptrace_bts_record __user *) addr);
>> +		break;
>> +
>> +	case PTRACE_BTS_CONFIG:
>> +		ptrace_bts_config(child, data);
>> +		ret = 0;
>> +		break;
>> +
>> +	case PTRACE_BTS_STATUS:
>> +		ret = ptrace_bts_status(child);
>> +		break;
>> +
>
>Regarding your interface (can you please write those manpages to get a
>full rationable)? 

They will be part of the next version. I keep the two patches separate,
I hope that does not confuse any scripts that try to extract patches 
from the email.


>I'm not sure it's a good idea to have a READ_RECORD -- better would 
>be likely a batched interface. Probably it would
>be cleaner to combine get_index and read_record into a higher
>level interface that works like normal read() -- gives you data 
>not read before for multiple records. 

I tried to keep the interface as simple and flexible as possible.
A user would typically want to read the trace from back to front until
he
read enough trace. But I could also think of a more random accesses
pattern.
If you know you're going to read the entire buffer, reading it from
front to back might be preferrable.

The memory interface uses peek and poke to read and write a single 
word, respectively. I think that the READ_RECORD command matches the
PEEK command pretty well.

I would expect a user to provide a stream view to higher levels if it
is beneficial for him. Such a view can be easily implemented with
the current interface.


>Also not sure why you have separate config and allocate_buffer steps.
>They could be easily combined, couldn't they? 

The buffer is typically allocated once per session, whereas a user
may want to turn on and off tracing several times during a session.


>> +/*
>> + * Maximal BTS size in number of records
>> + */
>> +#define PTRACE_BTS_MAX_BTS_SIZE 4000
>
>This should be likely some sort of sysctl. Or perhaps just use 
>user supplied
>buffers limited by the mlock ulimit (that would allow zero copy). Ok
>it means the high level read interface proposed above wouldn't work.
>Perhaps the high level interface is better, although zero copy would
>be more efficient. Not 100% sure what is better.

I would not expect many users to want to change that value.
I would make this go into the /usr/include/sys/ptrace.h header file, so
the
ptrace user is aware of the limit.
If it turns out that there is a need to make this more flexible, we can
always do it with a later patch.


>> +	rdmsrl(MSR_IA32_DEBUGCTLMSR, debugctl_msr);
>> +	debugctl_msr |= ptrace_bts_cfg.debugctrl_mask;
>> +	wrmsrl(MSR_IA32_DEBUGCTLMSR, debugctl_msr);
>
>I still think you should cache the DEBUGCTLMSR. If you worry
>about other people changing it provide a general accessor.

I cached the values. The MSR is read during initialization and the 
enabled and disabled variants are stored in the processor configuration.

grep did not find another use of MSR_IA32_DEBUGCTLMSR anywhere in the
kernel.


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
