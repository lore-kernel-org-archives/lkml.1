Return-Path: <linux-kernel-owner+w=401wt.eu-S1756255AbZC3G4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255AbZC3G4M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 02:56:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752675AbZC3Gz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 02:55:56 -0400
Received: from mga09.intel.com ([134.134.136.24]:46370 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378AbZC3Gzz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 02:55:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,445,1233561600"; 
   d="scan'208";a="501841619"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: Oleg Nesterov <oleg@redhat.com>,
       Markus Metzger <markus.t.metzger@googlemail.com>
CC: Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "eranian@googlemail.com" <eranian@googlemail.com>,
       "Villacis, Juan" <juan.villacis@intel.com>,
       "ak@linux.jf.intel.com" <ak@linux.jf.intel.com>
Date: Mon, 30 Mar 2009 07:55:39 +0100
Subject: RE: [patch 3/14] x86, ptrace, bts: stop bts tracing early in	do_exit
Thread-Topic: [patch 3/14] x86, ptrace, bts: stop bts tracing early in
	do_exit
Thread-Index: Acmw1ujzZFc1BVyaTKqWJCfZTB3mKgAKkq0A
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77E9266B8A9@irsmsx504.ger.corp.intel.com>
References: <20090327095525.A11052@sedona.ch.intel.com>
 <20090327143435.GD14504@redhat.com>
 <928CFBE8E7CB0040959E56B4EA41A77E9266B6D4@irsmsx504.ger.corp.intel.com>
 <20090327172413.GC25762@redhat.com> <1238239912.6036.0.camel@raistlin>
 <20090330012204.GA2058@redhat.com>
In-Reply-To: <20090330012204.GA2058@redhat.com>
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
>Sent: Monday, March 30, 2009 3:22 AM
>To: Markus Metzger


>> ds_release_bts(struct bts_tracer *tracer)
>> {
>> 	struct task_struct *task =
>> 		tracer->ds.context->task;
>>
>> 	do {
>> 		set_task_state(task, TASK_UNINTERRUPTIBLE);
>
>Oh, this is not right,

Agreed.

I wonder if it is ever safe to change another task's state.
There's a lot of code that sets the task state seemingly
unprotected - but always for current.


>> Isn't this a general problem for ptrace?
>>
>> Ptrace uses a similar pattern in ptrace_check_attach().
>> It stops the traced task, but that task might wake up immediately after
>> that check. It might be scheduled in any time during a ptrace operation.
>
>Yes. ptrace() can assume the tracee is TASK_TRACED, or it is dying/dead.
>
>If you need to make sure it is still traced, you can re-check ->state
>under ->siglock. Until you drop this lock, the tracee (if still traced)
>can't escape from ptrace_stop/do_signal_stop, even if scheduled.

I can't hold the siglock for the entire ptrace operation, can I?

Instead, I put all bts stuff into a context struct and I use use-counts
to make sure the tracer is not released while it is used by a ptrace operation.

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

