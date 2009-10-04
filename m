Return-Path: <linux-kernel-owner+w=401wt.eu-S1751926AbZJDFVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926AbZJDFVV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 01:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751548AbZJDFVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 01:21:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11458 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882AbZJDFVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 01:21:19 -0400
Message-ID: <4AC830F0.2010003@redhat.com>
Date: Sun, 04 Oct 2009 01:21:52 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [PATCH tracing/kprobes v2 1/5] tracing/kprobes: Rename special
 variables syntax
References: <20091002214834.30906.86502.stgit@dhcp-100-2-132.bos.redhat.com> <20091002214842.30906.49220.stgit@dhcp-100-2-132.bos.redhat.com> <20091003015444.GE4828@nowhere>
In-Reply-To: <20091003015444.GE4828@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Frederic Weisbecker wrote:
> On Fri, Oct 02, 2009 at 05:48:42PM -0400, Masami Hiramatsu wrote:
>> Add $ prefix to the special variables(e.g. sa, rv) of kprobe-tracer.
>> This resolves consistency issue between kprobe_events and perf-kprobe.
>>
>> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
>> Cc: Frederic Weisbecker <fweisbec@gmail.com>
>> Cc: Ingo Molnar <mingo@elte.hu>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
>> Cc: Steven Rostedt <rostedt@goodmis.org>
>> Cc: Mike Galbraith <efault@gmx.de>
>> Cc: Paul Mackerras <paulus@samba.org>
>> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
>> Cc: Christoph Hellwig <hch@infradead.org>
>> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
>> Cc: Jim Keniston <jkenisto@us.ibm.com>
>> Cc: Frank Ch. Eigler <fche@redhat.com>
>> ---
>>
>>  Documentation/trace/kprobetrace.txt |   10 +++---
>>  kernel/trace/trace_kprobe.c         |   60 ++++++++++++++++++++++-------------
>>  2 files changed, 42 insertions(+), 28 deletions(-)
>>
>> diff --git a/Documentation/trace/kprobetrace.txt b/Documentation/trace/kprobetrace.txt
>> index 9b8f7c6..40caef0 100644
>> --- a/Documentation/trace/kprobetrace.txt
>> +++ b/Documentation/trace/kprobetrace.txt
>> @@ -36,13 +36,13 @@ Synopsis of kprobe_events
>>  
>>   FETCHARGS	: Arguments. Each probe can have up to 128 args.
>>    %REG	: Fetch register REG
>> -  sN	: Fetch Nth entry of stack (N >= 0)
>> -  sa	: Fetch stack address.
>>    @ADDR	: Fetch memory at ADDR (ADDR should be in kernel)
>>    @SYM[+|-offs]	: Fetch memory at SYM +|- offs (SYM should be a data symbol)
>> -  aN	: Fetch function argument. (N >= 0)(*)
>> -  rv	: Fetch return value.(**)
>> -  ra	: Fetch return address.(**)
>> +  $sN	: Fetch Nth entry of stack (N >= 0)
>> +  $sa	: Fetch stack address.
>> +  $aN	: Fetch function argument. (N >= 0)(*)
>> +  $rv	: Fetch return value.(**)
>> +  $ra	: Fetch return address.(**)
> 
> 
> 
> I feel uncomfortable with that, because of bash scripts that
> may use it and always need to escape it with antislashes or
> use single quotes for it to not be replaced by a random variable
> value. If one uses double quotes without antislashes to protect
> the command line, the result is unpredictable, depending of
> the current set of variables...
> 
> May be we can use # instead of $ ? That's a kind of pity because
> $ suggested a variable whereas # suggests a constant, we are then
> losing this self-explainable characteristic for kprobes
> "specific variable fetchs". But that will work without ambiguity.

Hmm, # is widely used for comment, including some kernel pseudo
file interfaces, kprobe_events too. Comments are useful if a
probe list is restored from a file.

For accessing local variables, kprobe-tracer needs to support *at least*
below variables:
- Registers
- Stack address (if a register points stack address, this isn't needed)

Below special vars are complementary aliases.
- Function arguments
- Return value
- Return address

and I'd like perf-probe to have a transparent syntax with kprobe-tracer.

This means, if we can remove special vars except registers, or rename it
non-conflictable name with registers, we just need to separate name spaces
of
- Regsiters
- Local variables

Here, local variables will support fields of data structs, and it will
use '->' expression. Since '>' means redirection in bash, local variables
need to be *escaped* in this case. Thus, I think we can use '$' prefix
for it. (I'm OK, because this is similar syntax to systemtap:-).

So, if you don't like %regs, $svars and locals, we can use regs and $locals :-)

Thank you,


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

