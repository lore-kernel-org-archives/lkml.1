Return-Path: <linux-kernel-owner+w=401wt.eu-S1757665AbZC0Pge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757665AbZC0Pge (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 11:36:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753045AbZC0PgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 11:36:24 -0400
Received: from mga11.intel.com ([192.55.52.93]:17781 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbZC0PgX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 11:36:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,432,1233561600"; 
   d="scan'208";a="676539890"
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
Date: Fri, 27 Mar 2009 15:34:19 +0000
Subject: RE: [patch 3/14] x86, ptrace, bts: stop bts tracing early in	do_exit
Thread-Topic: [patch 3/14] x86, ptrace, bts: stop bts tracing early in
	do_exit
Thread-Index: Acmu6Z6oWgYbhpJ7SvKPuhzGVRVnQwABedNQ
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77E9266B6D4@irsmsx504.ger.corp.intel.com>
References: <20090327095525.A11052@sedona.ch.intel.com>
 <20090327143435.GD14504@redhat.com>
In-Reply-To: <20090327143435.GD14504@redhat.com>
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
>Sent: Friday, March 27, 2009 3:35 PM


>> +static void ptrace_bts_exit(void)
>> +{
>> +	if (unlikely(!list_empty(&current->ptraced)))
>> +		ptrace_bts_exit_tracer();
>> +
>> +	if (unlikely(current->bts))
>> +		ptrace_bts_exit_tracee();
>> +}
>
>Could you explain why do we need ptrace_bts_exit_tracee() ?
>
>If current is traced, the tracer should do ptrace_bts_release()
>eventually, no?

If current is traced and exits, it may be reaped by another thread that is not
the tracer (that's actually your example you made in an earlier thread to
describe the race between a normal detach and an exiting tracee).

The ptrace_unlink() call to detach the tracer is executed with irq's disabled.
I need irq's enabled (see the other discussion, to wait for the traced task).

Therefore, I have the tracee disable bts tracing itself when it exits.


>And if we really need to do ptrace_bts_exit_tracee(), then
>"if (unlikely(current->bts))" check is racy. The tracer
>can do PTRACE_BTS_CONFIG right after the check.

The ptrace system call to do this would require the tracee to be stopped.


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

