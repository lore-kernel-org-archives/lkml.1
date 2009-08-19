Return-Path: <linux-kernel-owner+w=401wt.eu-S1752027AbZHSAS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027AbZHSAS4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 20:18:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751455AbZHSASz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 20:18:55 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39148 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287AbZHSASy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 20:18:54 -0400
Message-ID: <4A8B4515.3090508@redhat.com>
Date: Tue, 18 Aug 2009 20:19:33 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       DLE <dle-develop@lists.sourceforge.net>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Avi Kivity <avi@redhat.com>, Andi Kleen <ak@linux.intel.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jason Baron <jbaron@redhat.com>, Jim Keniston <jkenisto@us.ibm.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       =?UTF-8?B?UHJ6ZW15c8WCYXdQYXdlxYJjenlr?= <przemyslaw@pawelczyk.it>,
       Roland McGrath <roland@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [PATCH -tip v14 03/12] kprobes: checks probe address is	instruction
 boudary on x86
References: <20090813203403.31965.20973.stgit@localhost.localdomain> <20090813203428.31965.21939.stgit@localhost.localdomain> <20090818230340.GF5231@nowhere> <4A8B3693.9000301@redhat.com> <20090818234341.GG5231@nowhere>
In-Reply-To: <20090818234341.GG5231@nowhere>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Tue, Aug 18, 2009 at 07:17:39PM -0400, Masami Hiramatsu wrote:
>> Frederic Weisbecker wrote:
>>>> +	while (addr < paddr) {
>>>> +		kernel_insn_init(&insn, (void *)addr);
>>>> +		insn_get_opcode(&insn);
>>>> +
>>>> +		/* Check if the instruction has been modified. */
>>>> +		if (insn.opcode.bytes[0] == BREAKPOINT_INSTRUCTION) {
>>>> +			ret = recover_probed_instruction(buf, addr);
>>>
>>>
>>>
>>> I'm confused about the reason of this recovering. Is it to remove
>>> kprobes behind the current setting one in the current function?
>>
>> No, it recovers just an instruction which is probed by a kprobe,
>> because we need to know the first byte of this instruction for
>> decoding it.

Ah, sorry, it was not accurate. the function recovers an instruction
on the buffer(buf), not on the real kernel text. :)

>>
>> Perhaps we'd better to have more generic interface (text_peek?)
>> for it because another subsystem (e.g. kgdb) may want to insert int3...
>>
>> Thank you,
> 
> 
> Aah, I see now, it's to keep a sane check of the instructions
> boundaries without int 3 artifacts in the middle.
> 
> But in that case, you should re-arm the breakpoint after your
> check, right?
> 
> Or may be you could do the check without repatching?

Yes, it doesn't modify kernel text, just recover an original
instruction from kernel text and backup byte on a buffer.

> May be by doing a copy of insn.opcode.bytes and replacing bytes[0]
> with what a random kprobe has stolen?

Hm, no, this function is protected from other kprobes by kprobe_mutex.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

