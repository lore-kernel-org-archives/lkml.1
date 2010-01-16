Return-Path: <linux-kernel-owner+w=401wt.eu-S1751994Ab0APXsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994Ab0APXsl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jan 2010 18:48:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751293Ab0APXsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 18:48:40 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:47883 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab0APXsj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 18:48:39 -0500
Message-ID: <20100116184833.2s0zihwbggkgccsk@imap.linux.ibm.com>
Date: Sat, 16 Jan 2010 18:48:33 -0500
From: Jim Keniston <jkenisto@us.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       utrace-devel <utrace-devel@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH 1/7] User Space Breakpoint Assistance Layer (UBP)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) H3 (4.1.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Peter Zijlstra <peterz@infradead.org>:

> On Fri, 2010-01-15 at 16:58 -0800, Jim Keniston wrote:
>> But here are some things to keep in mind about the
>> various approaches:
>>
>> 1. Single-stepping inline is easiest: you need to know very little about
>> the instruction set you're probing.  But it's inadequate for
>> multithreaded apps.
>> 2. Single-stepping out of line solves the multithreading issue (as do #3
>> and #4), but requires more knowledge of the instruction set.  (In
>> particular, calls, jumps, and returns need special care; as do
>> rip-relative instructions in x86_64.)  I count 9 architectures that
>> support kprobes.  I think most of these do SSOL.
>> 3. "Boosted" probes (where an appended jump instruction removes the need
>> for the single-step trap on many instructions) require even more
>> knowledge of the instruction set, and like SSOL, require XOL slots.
>> Right now, as far as I know, x86 is the only architecture with boosted
>> kprobes.
>> 4. Emulation removes the need for the XOL area, but requires pretty much
>> total knowledge of the instruction set.  It's also a performance win for
>> architectures that can't do #3.  I see kvm implemented on 4
>> architectures (ia64, powerpc, s390, x86).  Coincidentally, those are the
>> architectures to which uprobes (old uprobes, with ubp and xol bundled
>> in) has already been ported (though Intel hasn't been maintaining their
>> ia64 port).
>
> Right, so I was thinking a combination of 4 and execute from kernel
> space would be feasible. I would think most regular instructions are
> runnable from kernel space given that we provide the proper pt_regs
> environment.
>
> Although I just realize we need to fully emulate the address computation
> step for all memory writes, otherwise a wild userspace pointer might end
> up writing in your kernel image.

Correct.

>
> Also, don't we already need full knowledge of the instruction set in
> order to decode the instruction stream and find instruction boundaries.

Not really.  For #3 (boosting), you need to know everything for #2,  
plus be able to compute the length of each instruction -- which we can  
now do for x86.  To emulate an instruction (#4), you need to replicate  
what it does, side-effects and all.  The x86 instruction set seems to  
be adding new floating-point instructions all the time, and I bet even  
Masami doesn't know what they all do, but so far, they all seem to  
adhere to the instruction-length rules encoded in Masami's instruction  
decoder.

As you may have noted before, I think FP would be a special problem  
for your approach.  I'm not sure how folks would react to the idea of  
executing FP instructions in kernel space.  But emulating them is also  
tough.  There's an IEEE FP emulation package somewhere in one of the  
Linux arch directories, but I'm not sure how precise it is, and  
dropping even 1 bit of precision is unacceptable for many  
applications, since such errors tend to grow in complex computations  
employing many FP instructions.

Jim

