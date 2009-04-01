Return-Path: <linux-kernel-owner+w=401wt.eu-S1761271AbZDAIMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761271AbZDAIMe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 04:12:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755368AbZDAIMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 04:12:15 -0400
Received: from mga11.intel.com ([192.55.52.93]:41512 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753373AbZDAIMN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 04:12:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,305,1235980800"; 
   d="scan'208";a="677748888"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: Oleg Nesterov <oleg@redhat.com>, "mingo@elte.hu" <mingo@elte.hu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "eranian@googlemail.com" <eranian@googlemail.com>,
       "Villacis, Juan" <juan.villacis@intel.com>,
       "ak@linux.jf.intel.com" <ak@linux.jf.intel.com>
Date: Wed, 1 Apr 2009 09:10:43 +0100
Subject: RE: [patch 1/21] x86, bts: fix race when bts tracer is removed
Thread-Topic: [patch 1/21] x86, bts: fix race when bts tracer is removed
Thread-Index: AcmyW6lev8d1y5X3QH6TxXUeb1BF9gAOovWw
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77E926D5095@irsmsx504.ger.corp.intel.com>
References: <20090331145051.A12111@sedona.ch.intel.com>
 <20090331234823.GB28228@redhat.com>
In-Reply-To: <20090331234823.GB28228@redhat.com>
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
>From: Oleg Nesterov [mailto:oleg@redhat.com]
>Sent: Wednesday, April 01, 2009 1:48 AM
>To: Metzger, Markus T
>Cc: linux-kernel@vger.kernel.org; mingo@elte.hu; tglx@linutronix.de; hpa@zytor.com;
>markus.t.metzger@gmail.com; roland@redhat.com; eranian@googlemail.com; Villacis, Juan;
>ak@linux.jf.intel.com
>Subject: Re: [patch 1/21] x86, bts: fix race when bts tracer is removed
>
>On 03/31, Markus Metzger wrote:
>>
>> Read the tracer once during a context switch.
>> ...
>> @@ -1044,36 +1051,39 @@ void ds_switch_to(struct task_struct *pr
>>  {
>>  	struct ds_context *prev_ctx = prev->thread.ds_ctx;
>>  	struct ds_context *next_ctx = next->thread.ds_ctx;
>> +	unsigned long debugctlmsr = next->thread.debugctlmsr;
>>
>>  	if (prev_ctx) {
>> +		struct bts_tracer *tracer = prev_ctx->bts_master;
>> +
>>  		update_debugctlmsr(0);
>>
>> -		if (prev_ctx->bts_master &&
>> -		    (prev_ctx->bts_master->trace.ds.flags & BTS_TIMESTAMPS)) {
>> +		if (tracer && (tracer->flags & BTS_TIMESTAMPS)) {
>
>In theory, we need barrier() after reading ->bts_master.
>
>(actually, I did see the bug reports when the compiler read the pointer
> twice with the code like above).

I guess the same is true for prev_ctx, next_ctx, and debugctlmsr, then.

Ingo,
would it be OK to resend this one patch with the barrier()s added?


>Off-topic, but afaics modulo bts_task_departs/bts_task_arrives we
>have the identical code for prev_ctx/next_ctx, perhaps it makes
>sense to make a helper which calls bts_write().

Agreed.

>To clarify, even _if_ I am right and _if_ you agree, we can do this
>later, I am not suggesting to change this patch right now.

Agreed, as well.


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

