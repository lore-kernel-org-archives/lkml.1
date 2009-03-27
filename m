Return-Path: <linux-kernel-owner+w=401wt.eu-S1759717AbZC0PNL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759717AbZC0PNL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 11:13:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758696AbZC0PMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 11:12:50 -0400
Received: from mga11.intel.com ([192.55.52.93]:33802 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759549AbZC0PMs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 11:12:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,432,1233561600"; 
   d="scan'208";a="442650716"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: Oleg Nesterov <oleg@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "eranian@googlemail.com" <eranian@googlemail.com>,
       "Villacis, Juan" <juan.villacis@intel.com>,
       "ak@linux.jf.intel.com" <ak@linux.jf.intel.com>
Date: Fri, 27 Mar 2009 15:12:35 +0000
Subject: RE: [patch 1/14] x86, ptrace: add arch_ptrace_report_exit
Thread-Topic: [patch 1/14] x86, ptrace: add arch_ptrace_report_exit
Thread-Index: Acmu543h/b61rAmpTa6EKCyeI/6HDQABf5nA
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77E9266B6B4@irsmsx504.ger.corp.intel.com>
References: <20090327094626.A11002@sedona.ch.intel.com>
 <20090327141937.GB14504@redhat.com>
In-Reply-To: <20090327141937.GB14504@redhat.com>
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
>Sent: Friday, March 27, 2009 3:20 PM
>To: Metzger, Markus T
>Cc: linux-kernel@vger.kernel.org; mingo@elte.hu; tglx@linutronix.de; hpa@zytor.com;
>markus.t.metzger@gmail.com; roland@redhat.com; eranian@googlemail.com; Villacis, Juan;
>ak@linux.jf.intel.com
>Subject: Re: [patch 1/14] x86, ptrace: add arch_ptrace_report_exit
>
>On 03/27, Markus Metzger wrote:
>>
>> --- git-tip.orig/include/linux/ptrace.h	2009-03-23 10:45:30.000000000 +0100
>> +++ git-tip/include/linux/ptrace.h	2009-03-23 11:31:21.000000000 +0100
>> @@ -335,6 +335,23 @@ static inline void user_enable_block_ste
>>  #define arch_ptrace_fork(child, clone_flags)	do { } while (0)
>>  #endif
>>
>> +#ifndef arch_ptrace_report_exit
>> +/**
>> + * arch_ptrace_report_exit - Do machine specific work for exiting ptraced tasks
>> + * @exit_code:	current->exit_code value
>> + *
>> + * This is called early from do_exit() with no locks held after we notified the
>> + * ptracer.
>> + */
>> +#define arch_ptrace_report_exit(exit_code)	do { } while (0)
>> +#endif
>> +
>> +static inline void ptrace_report_exit(long *exit_code)
>> +{
>> +	ptrace_event(PT_TRACE_EXIT, PTRACE_EVENT_EXIT, *exit_code);
>> +	arch_ptrace_report_exit(*exit_code);
>> +}
>> +
>>  extern int task_current_syscall(struct task_struct *target, long *callno,
>>  				unsigned long args[6], unsigned int maxargs,
>>  				unsigned long *sp, unsigned long *pc);
>> Index: git-tip/include/linux/tracehook.h
>> ===================================================================
>> --- git-tip.orig/include/linux/tracehook.h	2009-03-23 10:45:30.000000000 +0100
>> +++ git-tip/include/linux/tracehook.h	2009-03-23 11:31:21.000000000 +0100
>> @@ -211,7 +211,7 @@ static inline void tracehook_report_exec
>>   */
>>  static inline void tracehook_report_exit(long *exit_code)
>>  {
>> -	ptrace_event(PT_TRACE_EXIT, PTRACE_EVENT_EXIT, *exit_code);
>> +	ptrace_report_exit(exit_code);
>>  }
>
>This needs Rolan'd review.
>
>But I'd say this has nothing to do with tracehooks. And why do
>you pass *exit_code to arch_ptrace_report_exit() ?
>
>Just add arch_ptrace_report_exit(void) into do_exit() ?
>
>From the 3/14 patch:
>
>	#define arch_ptrace_report_exit(code) x86_ptrace_report_exit(code)
>
>	void x86_ptrace_report_exit(long exit_code)
>	{
>	       ptrace_bts_exit();
>	}
>
>This is a bit strange. Why do we need 2 functions, ptrace_bts_exit() and
>x86_ptrace_report_exit() which just calls the first one?

I did not want to take any shortcuts. I try to maintain the structure 
general_function()->ptrace_report()->arch_ptrace_report().

Recently, tracehook_report_whatever() calls were added which either do the
ptrace work directly or call a ptrace function. I try to use those calls, where possible.

It does not clutter the general code with x86 specific, or worse x86 branch trace
recording specific calls.


If people don't like these ptrace_whatever() and arch_ptrace_whatever() calls I add,
I can remove them and add my calls directly where I need them.

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

