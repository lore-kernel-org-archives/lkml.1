Return-Path: <linux-kernel-owner+w=401wt.eu-S1757905AbYHOJXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757905AbYHOJXj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 05:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753071AbYHOJXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 05:23:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56401 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752343AbYHOJXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 05:23:30 -0400
Date: Fri, 15 Aug 2008 11:22:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Roland McGrath <roland@redhat.com>, Ulrich Drepper <drepper@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>, srostedt@redhat.com
Subject: Re: [PATCH] ftrace: use only 5 byte nops for x86
Message-ID: <20080815092231.GB22209@elte.hu>
References: <alpine.DEB.1.10.0808141755030.2911@gandalf.stny.rr.com> <48A4C491.4050301@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48A4C491.4050301@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Steven Rostedt wrote:
>> Mathieu Desnoyers revealed a bug in the original code. The nop that is
>> used to relpace the mcount caller can be a two part nop. This runs the
>> risk where a process can be preempted after executing the first nop, but
>> before the second part of the nop.
>>
>> The ftrace code calls kstop_machine to keep multiple CPUs from executing
>> code that is being modified, but it does not protect against a task preempting
>> in the middle of a two part nop.
>>
>> If the above preemption happens and the tracer is enabled, after the
>> kstop_machine runs, all those nops will be calls to the trace function.
>> If the preempted process that was preempted between the two nops is executed
>> again, it will execute half of the call to the trace function, and this
>> might crash the system.
>>
>> This patch instead uses what both the latest Intel and AMD spec suggests.
>> That is the P6_NOP5 sequence of "0x0f 0x1f 0x44 0x00 0x00".
>> Note, some older CPUs and QEMU might fault on this nop, so this nop
>> is executed with fault handling first. If it detects a fault, it will then
>> use the code "0x66 0x66 0x66 0x66 0x90". If that faults,
>
> Seems very unlikely, but go mad ;)
>
>>  it will then
>> default to a simple "jmp 1f; .byte 0x00 0x00 0x00; 1:". The jmp is
>> not optimal but will do if the first two can not be executed.
>>
>> TODO: Examine the cpuid to determine the nop to use.
>>   
>
> Don't think that will help in general.  qemu claims its a Pentium II.

ok. I've applied Steve's patch as it's a good bugfix. The extra paranoia 
about faulting on 0x90 seems excessive but doesnt hurt ;-)

	Ingo
