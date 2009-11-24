Return-Path: <linux-kernel-owner+w=401wt.eu-S1758105AbZKXPcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758105AbZKXPcd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 10:32:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758090AbZKXPcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 10:32:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758085AbZKXPcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 10:32:32 -0500
Message-ID: <4B0BFCF8.4060905@redhat.com>
Date: Tue, 24 Nov 2009 10:34:16 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Anders Kaseorg <andersk@ksplice.com>, Tim Abbott <tabbott@ksplice.com>,
       Andi Kleen <andi@firstfloor.org>, Jason Baron <jbaron@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH -tip v5 03/10] kprobes: Introduce kprobes jump	optimization
References: <20091123232115.22071.71558.stgit@dhcp-100-2-132.bos.redhat.com> <20091123232141.22071.53317.stgit@dhcp-100-2-132.bos.redhat.com> <20091124024417.GA6752@nowhere> <20091124033135.GE6752@nowhere>
In-Reply-To: <20091124033135.GE6752@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Tue, Nov 24, 2009 at 03:44:19AM +0100, Frederic Weisbecker wrote:
>> On Mon, Nov 23, 2009 at 06:21:41PM -0500, Masami Hiramatsu wrote:
>>> +static void kprobe_optimizer(struct work_struct *work);
>>> +static DECLARE_DELAYED_WORK(optimizing_work, kprobe_optimizer);
>>> +#define OPTIMIZE_DELAY 5
>>> +
>>> +/* Kprobe jump optimizer */
>>> +static __kprobes void kprobe_optimizer(struct work_struct *work)
>>> +{
>>> +	struct optimized_kprobe *op, *tmp;
>>> +
>>> +	/* Lock modules while optimizing kprobes */
>>> +	mutex_lock(&module_mutex);
>>> +	mutex_lock(&kprobe_mutex);
>>> +	if (kprobes_all_disarmed)
>>> +		goto end;
>>> +
>>> +	/* Wait quiesence period for ensuring all interrupts are done */
>>> +	synchronize_sched();
>>
>>
>>
>> It's not clear to me why you are doing that.
>> Is this waiting for pending int 3 kprobes handlers
>> to complete? If so, why, and what does that prevent?
> 
> 
> I _might_ have understood.
> You have set up the optimized flags, then you wait for
> any old-style int 3 kprobes to complete and route
> to detour buffer so that you can patch the jump
> safely in the dead code? (and finish with first byte
> by patching the int 3 itself)
> 

Yeah, you might get almost correct answer.
The reason why we have to wait scheduling on all processors
is that this code may modify N instructions (not a single
instruction). This means, there is a chance that 2nd to nth
instructions are interrupted on other cpus when we start
code modifying.

Please imagine that 2nd instruction is interrupted and
stop_machine() replaces the 2nd instruction with jump
*address* while running interrupt handler. When the interrupt
returns to original address, there is no valid instructions
and it causes unexpected result.

To avoid this situation, we have to wait a scheduler quiescent
state on all cpus, because it also ensure that all current
interruption are done.

This also excuses why we don't need to wait when unoptimizing
and why it has not supported preemptive kernel yet.

In unoptimizing case, since there is just a single instruction
(jump), there is no nth instruction which can be interrupted.
Thus we can just use a stop_machine(). :-)

On the preemptive kernel, waiting scheduling is not work as we
see on non-preemptive kernel. Since processes can be preempted
in interruption, we can't ensure that the current running
interruption is done. (I assume that a pair of freeze_processes
and thaw_processes may possibly ensure that, or maybe we can
share some stack rewinding code with ksplice.)
So it depends on !PREEMPT.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

