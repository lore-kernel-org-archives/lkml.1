Return-Path: <linux-kernel-owner+w=401wt.eu-S1761646AbYD3Pac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761646AbYD3Pac (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 11:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757595AbYD3PaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 11:30:24 -0400
Received: from mga03.intel.com ([143.182.124.21]:57508 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757601AbYD3PaX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 11:30:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,729,1199692800"; 
   d="scan'208";a="240058529"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [patch] x86, ptrace: in-kernel BTS interface
Date: Wed, 30 Apr 2008 16:30:21 +0100
Message-ID: <029E5BE7F699594398CA44E3DDF5544401CE236A@swsmsx413.ger.corp.intel.com>
In-Reply-To: <20080430130305.GC20451@one.firstfloor.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch] x86, ptrace: in-kernel BTS interface
Thread-Index: AciqweATOwFHMzsCTMqW9/t4RUu5OAAEQUVg
References: <20080430135440.A359@sedona.ch.intel.com> <20080430130305.GC20451@one.firstfloor.org>
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: "Andi Kleen" <andi@firstfloor.org>
Cc: <andi-suse@firstfloor.org>, <hpa@zytor.com>,
       <linux-kernel@vger.kernel.org>, <mingo@elte.hu>, <tglx@linutronix.de>,
       <markus.t.metzger@gmail.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>, <roland@redhat.com>,
       <akpm@linux-foundation.org>, <mtk.manpages@gmail.com>,
       <eranian@googlemail.com>, "Villacis, Juan" <juan.villacis@intel.com>
X-OriginalArrivalTime: 30 Apr 2008 15:30:18.0613 (UTC) FILETIME=[18852A50:01C8AAD7]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Andi Kleen [mailto:andi@firstfloor.org] 
>Sent: Mittwoch, 30. April 2008 15:03
>To: Metzger, Markus T


Thanks for your feedback.



>I'm not quite sure on the kernel interface. How would a in kernel
>subsystem use it for tracing itself for example?

The task parameter would be current.

Apart from that, you would use it the same way it is used in
arch/x86/kernel/ptrace.c.

You would want to bts_configure() it to disable tracing before you start
reading your own BTS buffer.


>> Index: gits.x86/arch/x86/kernel/bts.c
>> ===================================================================
>> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
>> +++ gits.x86/arch/x86/kernel/bts.c	2008-04-30 11:30:18.%N +0200
>> @@ -0,0 +1,505 @@
>> +/*
>> + * Branch Trace Store (BTS) support
>> + *
>> + * This provides a low-level interface to the hardware's 
>Branch Trace Store
>> + * feature that is used for execution tracing.
>
>Perhaps say it is only supported on modern Intel CPUs.


I will add such a comment.


>> + *
>> + * It manages:
>> + * - per-thread and per-cpu BTS configuration
>> + * - buffer memory allocation and overflow handling
>> + *
>> + * It assumes:
>> + * - get_task_struct on all parameter tasks
>
>What is a parameter task?


I was referring to the 'task' parameter for the below functions.
I will try to find a better wording.


>> + * - current is allowed to trace parameter tasks
>> + *
>> + *
>> + * Copyright (C) 2008 Intel Corporation.
>> + * Markus Metzger <markus.t.metzger@intel.com>, 2008
>> + */
>> +
>> +#ifdef CONFIG_X86_BTS
>
>Ifdef around whole file should be in the Makefile instead.
>In fact it is already in there so it is obsolet


I'll remove it - for ds.c, as well.


>> +struct bts_configuration {
>> +	/* the size of a BTS record in bytes; at most 
>BTS_MAX_RECORD_SIZE */
>> +	unsigned char  sizeof_bts;
>> +	/* the size of a field in the BTS record in bytes */
>> +	unsigned char  sizeof_field;
>> +	/* a bitmask to enable/disable various parts of BTS in 
>DEBUGCTL MSR */
>> +	unsigned long debugctl_tr;
>> +	unsigned long debugctl_btint;
>> +	unsigned long debugctl_user_off;
>> +	unsigned long debugctl_kernel_off;
>> +	unsigned long debugctl_all;
>> +};
>> +static struct bts_configuration bts_cfg;
>
>Should have a comment describing the locking of the variable. 
>Is there is 
>no need for some reason that should be also documented.


The variable is write-once. It is written during boot time. It is not
locked.
I'll add a comment.


>> +}
>> +EXPORT_SYMBOL(bts_request);
>
>Why again is that all exported?


Stephane asked for those exports - for the DS symbols, at least - in
order to use it with perfmon2.


>> +		if (kbuf)
>> +			bts_translate_record(kbuf++, raw);
>> +
>> +		if (ubuf) {
>> +			bts_translate_record(&bts, raw);
>> +
>> +			if (copy_to_user(ubuf++, &bts, sizeof(bts)))
>
>copy_to_user is a macro and using expressions with side effects in
>macro arguments is usually a bad idea.


I'll replace it.

>> +static const struct bts_configuration bts_cfg_netburst = {
>> +	.sizeof_bts    = sizeof(long) * 3,
>> +	.sizeof_field  = sizeof(long),
>> +	.debugctl_tr         = (1<<2)|(1<<3),
>> +	.debugctl_btint      = (1<<4),
>> +	.debugctl_user_off   = (1<<6),
>> +	.debugctl_kernel_off = (1<<5)
>
>Define symbols for the magic numbers?


Hmmm, the symbols would have the same name as the respective
bts_configuration field (except for _tr, which actually is TR | BTS).


>
>> +		switch (c->x86_model) {
>> +		case 0xD:
>> +		case 0xE: /* Pentium M */
>> +			bts_init(&bts_cfg_pentium_m);
>> +			break;
>> +		case 0xF: /* Core2 */
>> +		case 0x1C: /* Atom */
>> +			bts_init(&bts_cfg_core2);
>> +			break;
>> +		default:
>> +			/* sorry, don't know about them */
>
>There should be a printk probably once at kernel boot time.


Ok.

Is there some special format that I should use?


>> +			break;
>> +		}
>> +		break;
>> +	case 0xF:
>> +		switch (c->x86_model) {
>> +		case 0x0:
>> +		case 0x1:
>> +		case 0x2: /* Netburst */
>> +			bts_init(&bts_cfg_netburst);
>
>Are you sure that's complete? 

I'm sure that's not complete.

That's all the hardware I have direct access to.
Supporting more hardware is a small thing, but it adds to the testing
obligation.
I'd rather add more hardware after the feature is working OK.


>> +#ifdef __KERNEL__
>> +struct bts_struct {
>> +	u64 qualifier;
>> +	union {
>> +		/* BTS_BRANCH */
>> +		struct {
>> +			u64 from;
>> +			u64 to;
>> +		} lbr;
>> +		/* BTS_TASK_ARRIVES or
>> +		   BTS_TASK_DEPARTS */
>> +		u64 jiffies;
>> +	} variant;
>> +};
>> +#else /* !__KERNEL__ */
>> +struct bts_struct {
>> +	__u64 qualifier;
>
>You could always use the __ typed variant even for the kernel.


Good.


>> + * Request branch tracing for the parameter task or for the 
>current cpu.
>> + *
>> + * Due to alignement constraints, the actual buffer may be slightly
>> + * smaller than the requested or provided buffer.
>> + *
>> + * Returns 0 on success; -Eerrno otherwise
>> + *
>> + * task:  the task to request recording for;
>> + *        NULL for per-cpu recording on the current cpu
>> + * base:  the base pointer for the (non-pageable) buffer;
>> + *        NULL if buffer allocation requested
>> + * size:  the size of the requested or provided buffer
>> + * ovfl:  pointer to a function to be called on buffer overflow;
>> + *        NULL if cyclic buffer requested
>
>If you write these comments in kerneldoc format (see 
>Documentation/kernel-doc-nano-HOWTO.txt)
>it might end up automatically in the extracted documentation.


I'll do that - and for ds.c, as well.


>> + * Not all processors support all variants.
>> + * If a variant is not supported, the respective flag is ignored.
>
>Is that really a good way to handle such an error? How does the 
>user program find out?

It's not a serious error condition; it's more a QoI thing. You might get
more trace than you asked for.

I'll add a function to return a bit-mask of supported features for this
architecture and fail with an error if a requested feature is not
supported.


>>  }
>>  
>>  #ifdef CONFIG_X86_PTRACE_BTS
>
>Hmm I suspect since that is not mainline you'll need to just ask
>for the previous patches to be dropped, not remove the code 
>explicitely.

I tried to git-revert an old version of the patch to replace it with an
updated version. 
I had also split the patch into three smaller pieces for the three
different layers.
But there's so much on top of it that I ended up with conflicts. The
easiy thing for me would be to just send out another patch on top of it.
For this one, I expect it won't be applied, so I simply resend a
corrected version some time next week.


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

