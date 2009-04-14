Return-Path: <linux-kernel-owner+w=401wt.eu-S1751715AbZDNWdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751715AbZDNWdg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 18:33:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752666AbZDNWd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 18:33:27 -0400
Received: from gw.goop.org ([64.81.55.164]:39092 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752605AbZDNWd0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 18:33:26 -0400
Message-ID: <49E50F2F.5070507@goop.org>
Date: Tue, 14 Apr 2009 15:33:19 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Theodore Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, Christoph Hellwig <hch@lst.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@elastic.org>, Tom Zanussi <tzanussi@gmail.com>,
       Jiaying Zhang <jiayingz@google.com>, Michael Rubin <mrubin@google.com>,
       Martin Bligh <mbligh@google.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH 0/8] [GIT PULL] TRACE_EVENT for modules
References: <20090414172337.280621613@goodmis.org> <20090414210445.GM955@mit.edu> <49E504C1.9010401@goop.org> <alpine.DEB.2.00.0904141753500.31421@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0904141753500.31421@gandalf.stny.rr.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Tue, 14 Apr 2009, Jeremy Fitzhardinge wrote:
>
>   
>> Theodore Tso wrote:
>>     
>>> Any chance you could support something like this?
>>>
>>>   
>>>       
>> I think that's already there.  I'm defining
>> arch/x86/include/asm/paravirt-trace.h with:
>>
>> #ifndef _ASM_X86_PARAVIRT_TRACE_H
>> #define _ASM_X86_PARAVIRT_TRACE_H
>>
>> #include <linux/tracepoint.h>
>> #include <asm/paravirt_types.h>
>>
>> #undef TRACE_SYSTEM
>> #define TRACE_SYSTEM pvops
>>
>> #define TRACE_INCLUDE_FILE	paravirt-trace
>> #define TRACE_INCLUDE_PATH	asm
>> [...]
>>
>>
>> Which ends up including <asm/paravirt-trace.h>
>>     
>
> Not quite. It ends up looking like
>
> #include "asm/paravirt-trace.h"
>
> As long as there is no "asm" directory in the include/trace directory, I 
> think that is fine.

OK.

I'm having a bit of trouble with paravirt-trace.h when I actually 
include it in paravirt.h.  asm/paravirt.h is itself included in lots of 
places, and so its fairly easy to end up with cyclic include 
dependencies which are fairly painful.  In this case I'm seeing 
asm/paravirt.h -> linux/tracepoint.h -> linux/rcupate.h -> {lots of 
stuff}, which gives errors like:

  CC      arch/x86/kernel/asm-offsets.s
In file included from /home/jeremy/git/linux/include/linux/thread_info.h:55,
                 from /home/jeremy/git/linux/include/linux/preempt.h:9,
                 from /home/jeremy/git/linux/include/linux/spinlock.h:50,
                 from /home/jeremy/git/linux/include/linux/rcupdate.h:37,
                 from /home/jeremy/git/linux/include/linux/tracepoint.h:18,
                 from /home/jeremy/git/linux/arch/x86/include/asm/paravirt-trace.h:4,
                 from /home/jeremy/git/linux/arch/x86/include/asm/paravirt.h:18,
                 from /home/jeremy/git/linux/arch/x86/include/asm/irqflags.h:55,
                 from /home/jeremy/git/linux/include/linux/irqflags.h:57,
                 from /home/jeremy/git/linux/arch/x86/include/asm/system.h:11,
                 from /home/jeremy/git/linux/arch/x86/include/asm/processor.h:17,
                 from /home/jeremy/git/linux/include/linux/prefetch.h:14,
                 from /home/jeremy/git/linux/include/linux/list.h:6,
                 from /home/jeremy/git/linux/include/linux/module.h:9,
                 from /home/jeremy/git/linux/include/linux/crypto.h:21,
                 from /home/jeremy/git/linux/arch/x86/kernel/asm-offsets_64.c:7,
                 from /home/jeremy/git/linux/arch/x86/kernel/asm-offsets.c:4:
/home/jeremy/git/linux/arch/x86/include/asm/thread_info.h:34: error: expected specifier-qualifier-list before 'mm_segment_t'



I'm wondering if there's much downside in making the code __DO_TRACE() 
out of line so that we can make tracepoint.h have absolutely minimal 
include dependencies?

    J
