Return-Path: <linux-kernel-owner+w=401wt.eu-S1762682AbXKORju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762682AbXKORju (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 12:39:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757493AbXKORjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 12:39:41 -0500
Received: from mga03.intel.com ([143.182.124.21]:40355 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757069AbXKORjk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 12:39:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,421,1188802800"; 
   d="scan'208";a="319292188"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [patch] x86, ptrace: support for branch trace store(BTS)
Date: Thu, 15 Nov 2007 17:38:35 -0000
Message-ID: <029E5BE7F699594398CA44E3DDF55444F006C3@swsmsx413.ger.corp.intel.com>
In-Reply-To: <200711132120.53458.ak@suse.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch] x86, ptrace: support for branch trace store(BTS)
thread-index: AcgmMskjF1oGWCS5RdmaJJ+BvOcfgABeLfQg
References: <20071113195954.GA2428@linux-os.sc.intel.com> <200711132120.53458.ak@suse.de>
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: "Andi Kleen" <ak@suse.de>, "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: <linux-kernel@vger.kernel.org>, <mingo@elte.hu>, <hpa@zytor.com>,
       <tglx@linutronix.de>, <akpm@linux-foundation.org>
X-OriginalArrivalTime: 15 Nov 2007 17:38:37.0039 (UTC) FILETIME=[5A277FF0:01C827AE]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for your comments. 

>-----Original Message-----
>From: Andi Kleen [mailto:ak@suse.de] 
>Sent: Dienstag, 13. November 2007 21:21
>To: Siddha, Suresh B
>Cc: linux-kernel@vger.kernel.org; mingo@elte.hu; 
>hpa@zytor.com; tglx@linutronix.de; Metzger, Markus T; 
>akpm@linux-foundation.org
>Subject: Re: [patch] x86, ptrace: support for branch trace store(BTS)
>
>On Tuesday 13 November 2007 20:59:54 Siddha, Suresh B wrote:
>> Support for Intel's last branch recording to ptrace. This 
>gives debuggers
>> access to this hardware feature and allows them to show an 
>execution trace
>> of the debugged application.
>
>Cool. Finally someone gets around to supporting this properly.
>
>Ok mostly properly, the patch needs some improvements.
>
>But can you please add a mode for tracing kernel code too? I guess
>this means a way to forbid it to user space or allocate the register.
>That would be probably needed by kernel debuggers too anyways, so
>might be better to add it from the begging.

That's a good point. The framework could be used for this. 
We would have to add a kernel API and disable user trace support.
The kernel would probably want to collect trace per cpu, not
per task.

That would be a separate feature that would best go into a different
patch.


>I'm sure some people will suggest now that should be all only
>supported with utrace. My suggestion is to ignore them.
>
>Also there was some discussion recently that complex kernel
>interfaces like this need manpages on proposal so that proper review
>of the interfaces is possible. I would suggest to write manpages
>(or manpages patches) and point to them on the next submission.

Do you mean a patch to the "man ptrace" man page
that would elaborate on the comments I put into 
include/asm-x86/ptrace-abi.h?

This would only be used for discussion in this mailing list, wouldn't
it?


>> Index: linux-2.6/arch/x86/kernel/process_32.c
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/kernel/process_32.c	
>2007-11-07 09:08:32.%N +0100
>> +++ linux-2.6/arch/x86/kernel/process_32.c	2007-11-07 
>09:09:36.%N +0100
>> @@ -735,6 +735,18 @@
>>  		__switch_to_xtra(prev_p, next_p, tss);
>>  
>>  	/*
>> +	 * Last branch recording recofiguration of trace hardware and
>> +	 * disentangling of trace data per task.
>> +	 */
>> +	if (unlikely(task_thread_info(prev_p)->flags & _TIF_BTS_TRACE ||
>> +		     task_thread_info(prev_p)->flags & 
>_TIF_BTS_TRACE_TS))
>> +		ptrace_bts_task_departs(prev_p);
>> +
>> +	if (unlikely(task_thread_info(next_p)->flags & _TIF_BTS_TRACE ||
>> +		     task_thread_info(next_p)->flags & 
>_TIF_BTS_TRACE_TS))
>> +		ptrace_bts_task_arrives(next_p);
>> +
>
>Congratulations. You managed to pick exactly the wrong place.  
>Why do you think __switch_to_xtra was invented?  The bits should be in 
>CTXSW_PREV/NEXT and then the checks moved there. Then it would be zero
>cost for the nobody using it case.

I moved the code to __switch_to_xtra and set the
TIF_WORK_CTXSW_PREV/NEXT bits. 
It looks better, now, thanks.


>> +#ifdef __i386__
>> +static int ptrace_bts_disable_netburst(void)
>> +{
>> +	unsigned long long debugctl_msr = 0;
>> +	rdmsrl(MSR_IA32_DEBUGCTLMSR, debugctl_msr);
>> +	debugctl_msr &=
>> +		~((1 << 2) | /* TR */
>> +		  (1 << 3));  /* BTS */
>> +	wrmsrl(MSR_IA32_DEBUGCTLMSR, debugctl_msr);
>> +
>> +	return 0;
>> +}
>> +
>> +static int ptrace_bts_disable_pentium_m(void)
>> +{
>> +	unsigned long long debugctl_msr = 0;
>> +	rdmsrl(MSR_IA32_DEBUGCTLMSR, debugctl_msr);
>
>etc. Surely it would be faster to cache the value of the MSR in RAM?
>Might matter for the context switch.

If I cached the MSR value and only wrote it in the enable/disable
routines, 
I might implicitly undo somebody else's changes to other bits in that
MSR.

Also, this code is not performance critical as it is executed only
when switching to/from tasks that are being debugged.


>> +	if (size_in_records > 4000)
>> +		return -EINVAL;
>
>Nasty undocumented undefined magic numbers.

I replaced it with a macro PTRACE_BTS_MAX_BTS_SIZE that is #defined 
at the beginning of that source file.


>> +
>> +	if (!ptrace_bts_ops.allocate_bts)
>> +		return -EOPNOTSUPP;
>> +	return (*ptrace_bts_ops.allocate_bts)(child, size_in_records);
>> +}
>> +
>> +#ifdef __i386__
>
>etc. The code duplication for i386 is indeed quite ugly. Would
>be good to find some better way to do this. A lot of it seems
>to be just different sizeof(), surely that could be passed around too
>or gotten from the ops structure? 

The underlying problem is that the address size in the DS and the BTS 
depend on the processor mode as well as on the processor architecture. 
Netburst, for example, uses 32bit pointers in 32bit mode and 64bit 
pointers in 64bit mode.
Core2, on the other hand, uses 64bit pointers in both modes.
While the processor mode is known statically, the processor architecture

is not.

I chose to model this using completely separate data structures and
operations for each architecture variant to simplify adding support for 
new architectures.

For some of the operations, I could instead store a handful of
parameters 
in an architecture specific struct and use a common operation. For
example, 
I could store the size of the DS and BTS buffers, or the enable/disable 
bit-masks.

This would result in some kind of hybrid that I think is slightly harder

to understand and extend, but does not have a real benefit except for a 
marginal code size reduction.

How strongly do you think this needs to be changed?


I added the #ifdef __i386__ in order to get rid of some ugly type-cast 
warnings for cases that do not actually occur in practice. 

For __i386__ I need to cast 32bit pointers into 64bit pointers and vice 
versa for architectures that use 64bit DS and BTS pointers in 32bit
mode.
For __x86_64__ I never need to do that casting, so I chose to
conditionally 
compile that code.


>Also it's unclear why you got different MSR access functions for 32bit 
>and 64bit.

Actually, I got different MSR access functions for different processors,

because I need to touch different bits in that MSR. They just happen to 
collide with the 32bit/64bit distinction.


>> +static int ptrace_bts_init_intel(void)
>
>This should be probably in the standard CPU initialization code,
>possibly using synthesized feature bits too.

I will move the call to ptrace_bts_init_intel() into the intel setup
code
and leave the function itself in ptrace_bts.c. This will obsolete the 
PTRACE_BTS_INIT command.


>Also do you have user space to use this?

The main target for this feature are application debuggers. We are
currently 
talking to gdb developers (internally) to have gdb make use of it.


thanks and regards,
markus.

>
>-Andi
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
