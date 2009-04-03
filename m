Return-Path: <linux-kernel-owner+w=401wt.eu-S1759446AbZDCGXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759446AbZDCGXr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 02:23:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753730AbZDCGXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 02:23:37 -0400
Received: from mga11.intel.com ([192.55.52.93]:62012 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751590AbZDCGXh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 02:23:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,318,1235980800"; 
   d="scan'208";a="678411580"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: Ingo Molnar <mingo@elte.hu>
CC: "tglx@linutronix.de" <tglx@linutronix.de>, "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "eranian@googlemail.com" <eranian@googlemail.com>,
       "oleg@redhat.com" <oleg@redhat.com>,
       "Villacis, Juan" <juan.villacis@intel.com>,
       "ak@linux.jf.intel.com" <ak@linux.jf.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 3 Apr 2009 07:19:56 +0100
Subject: RE: [patch 01/18] x86, bts: fix race when bts tracer is removed
Thread-Topic: [patch 01/18] x86, bts: fix race when bts tracer is removed
Thread-Index: AcmzwzWaOsx60ovwSfmp6ywNDZWSaQAYHckg
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77E9271804B@irsmsx504.ger.corp.intel.com>
References: <20090402145455.597376000@intel.com>
 <20090402145702.669790000@intel.com> <20090402184514.GC843@elte.hu>
In-Reply-To: <20090402184514.GC843@elte.hu>
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
>Sent: Thursday, April 02, 2009 8:45 PM
>To: Metzger, Markus T
>Cc: tglx@linutronix.de; hpa@zytor.com; markus.t.metzger@gmail.com; roland@redhat.com;
>eranian@googlemail.com; oleg@redhat.com; Villacis, Juan; ak@linux.jf.intel.com; linux-
>kernel@vger.kernel.org
>Subject: Re: [patch 01/18] x86, bts: fix race when bts tracer is removed
>
>
>* markus.t.metzger@intel.com <markus.t.metzger@intel.com> wrote:
>
>> +static inline void ds_take_timestamp(struct ds_context *context,
>> +				     enum bts_qualifier qualifier,
>> +				     struct task_struct *task)
>> +{
>> +	struct bts_tracer *tracer = context->bts_master;
>> +	barrier();
>
>why the barrier()?

See http://lkml.org/lkml/2009/3/31/544

Oleg: "In theory, we need barrier() after reading ->bts_master.

(actually, I did see the bug reports when the compiler read the pointer
 twice with the code like above)."


>> +
>> +	if (tracer && (tracer->flags & BTS_TIMESTAMPS)) {
>> +		struct bts_struct ts = {
>> +			.qualifier = qualifier,
>> +			.variant.timestamp.jiffies = jiffies_64,
>> +			.variant.timestamp.pid = task->pid
>> +		};
>> +		bts_write(tracer, &ts);
>> +	}
>
>Why do we have .variant.timestamp.pid ? A PID is not a timestamp. It
>might be .event.jiffies and .event.pid perhaps.

OK.


>Also, the whole function could be cleaned up by:
>
> 1) returning early if !tracer || !(tracer->flags & BTS_TIMESTAMPS).
>
> 2) Doing a cleaner initialization - something like:
>
>struct bts_struct ts = {
>	.qualifier		= qualifier,
>	.variant.event.jiffies	= jiffies_64,
>	.variant.event.pid	= task->pid
>};
>
>Also, raw use of jiffies_64 is buggy and racy. Why does this use
>jiffies to begin with - why not some finer grained time?

What would be a good time to use?

thanks,
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

