Return-Path: <linux-kernel-owner+w=401wt.eu-S1753288AbYKYKZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288AbYKYKZ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 05:25:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752478AbYKYKZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 05:25:49 -0500
Received: from mga09.intel.com ([134.134.136.24]:17658 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752290AbYKYKZt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 05:25:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,663,1220252400"; 
   d="scan'208";a="364041121"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: Andi Kleen <andi@firstfloor.org>
CC: "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "mtk.manpages@gmail.com" <mtk.manpages@gmail.com>,
       "eranian@googlemail.com" <eranian@googlemail.com>,
       "Villacis, Juan" <juan.villacis@intel.com>
Date: Tue, 25 Nov 2008 10:25:14 +0000
Subject: RE: [patch 9/9] x86, bts, ftrace: a BTS ftrace plug-in prototype
Thread-Topic: [patch 9/9] x86, bts, ftrace: a BTS ftrace plug-in prototype
Thread-Index: AclO5mWQbbu4Yl4IRuiGJBnW2RCxhQAAJ1Iw
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77E08F3C320@irsmsx504.ger.corp.intel.com>
References: <20081125092415.A31432@sedona.ch.intel.com>
 <87hc5wcdwu.fsf@basil.nowhere.org>
In-Reply-To: <87hc5wcdwu.fsf@basil.nowhere.org>
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
>From: Andi Kleen [mailto:andi@firstfloor.org] 
>Sent: Dienstag, 25. November 2008 11:13
>To: Metzger, Markus T

>Markus Metzger <markus.t.metzger@intel.com> writes:
>
>Basic idea looks very useful. Thanks.
>
>> +static void bts_trace_cpuinit(struct cpuinfo_x86 *c)
>
>That should be somewhere generic I think. Doesn't ptrace have it too?

It does. All the BTS bits currently live in ptrace.c - that had been the only user, so far. I will move them into ds.c, but this will take a few patches.

Ingo said its important to have an early prototype. So I did the first version with very restricted functionality and some duplicate code.


regards,
markus.

>
>-Andi
>
>
>> +{
>> +	switch (c->x86) {
>> +	case 0x6:
>> +		switch (c->x86_model) {
>> +		case 0x0 ... 0xC:
>> +			break;
>> +		case 0xD:
>> +		case 0xE: /* Pentium M */
>> +			sizeof_field = sizeof(long);
>> +			debugctl_mask = (1<<6)|(1<<7);
>> +			break;
>> +		default:
>> +			sizeof_field = 8;
>> +			debugctl_mask = (1<<6)|(1<<7);
>> +			break;
>> +		}
>> +		break;
>> +	case 0xF:
>> +		switch (c->x86_model) {
>> +		case 0x0:
>> +		case 0x1:
>> +		case 0x2: /* Netburst */
>> +			sizeof_field = sizeof(long);
>> +			debugctl_mask = (1<<2)|(1<<3);
>> +			break;
>> +		default:
>> +			/* sorry, don't know about them */
>> +			break;
>> +		}
>> +		break;
>> +	default:
>> +		/* sorry, don't know about them */
>> +		break;
>> +	}
>> +}
>> +
>> +static inline void bts_enable(void)
>> +{
>> +	unsigned long debugctl;
>> +
>> +	rdmsrl(MSR_IA32_DEBUGCTLMSR, debugctl);
>> +	wrmsrl(MSR_IA32_DEBUGCTLMSR, debugctl | debugctl_mask);
>> +}
>> +
>> +static inline void bts_disable(void)
>> +{
>> +	unsigned long debugctl;
>> +
>> +	rdmsrl(MSR_IA32_DEBUGCTLMSR, debugctl);
>> +	wrmsrl(MSR_IA32_DEBUGCTLMSR, debugctl & ~debugctl_mask);
>> +}
>> +
>> +static void bts_trace_reset(struct trace_array *tr)
>> +{
>> +	int cpu;
>> +
>> +	tr->time_start = ftrace_now(tr->cpu);
>> +
>
>-- 
>ak@linux.intel.com
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

