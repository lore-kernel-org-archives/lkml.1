Return-Path: <linux-kernel-owner+w=401wt.eu-S1754533AbYHNXu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533AbYHNXu1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 19:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751818AbYHNXuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 19:50:17 -0400
Received: from gw.goop.org ([64.81.55.164]:60967 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751817AbYHNXuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 19:50:14 -0400
Message-ID: <48A4C491.4050301@goop.org>
Date: Thu, 14 Aug 2008 16:49:37 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
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
References: <alpine.DEB.1.10.0808141755030.2911@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.1.10.0808141755030.2911@gandalf.stny.rr.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> Mathieu Desnoyers revealed a bug in the original code. The nop that is
> used to relpace the mcount caller can be a two part nop. This runs the
> risk where a process can be preempted after executing the first nop, but
> before the second part of the nop.
>
> The ftrace code calls kstop_machine to keep multiple CPUs from executing
> code that is being modified, but it does not protect against a task preempting
> in the middle of a two part nop.
>
> If the above preemption happens and the tracer is enabled, after the
> kstop_machine runs, all those nops will be calls to the trace function.
> If the preempted process that was preempted between the two nops is executed
> again, it will execute half of the call to the trace function, and this
> might crash the system.
>
> This patch instead uses what both the latest Intel and AMD spec suggests.
> That is the P6_NOP5 sequence of "0x0f 0x1f 0x44 0x00 0x00".
> Note, some older CPUs and QEMU might fault on this nop, so this nop
> is executed with fault handling first. If it detects a fault, it will then
> use the code "0x66 0x66 0x66 0x66 0x90". If that faults,

Seems very unlikely, but go mad ;)

>  it will then
> default to a simple "jmp 1f; .byte 0x00 0x00 0x00; 1:". The jmp is
> not optimal but will do if the first two can not be executed.
>
> TODO: Examine the cpuid to determine the nop to use.
>   

Don't think that will help in general.  qemu claims its a Pentium II.

    J
