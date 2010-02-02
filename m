Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994Ab0BBGst (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 01:48:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58019 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754512Ab0BBGsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 01:48:47 -0500
Message-ID: <4B67CA94.7000501@redhat.com>
Date: Tue, 02 Feb 2010 01:47:48 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Kyle Moffett <kyle@moffetthome.net>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>, Tom Tromey <tromey@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, linux-next@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, utrace-devel@redhat.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: linux-next: add utrace tree
References: <alpine.LFD.2.00.1001232051510.3574@localhost.localdomain> <m33a1tnbd9.fsf@fleche.redhat.com> <alpine.LFD.2.00.1001251332370.3574@localhost.localdomain> <m3636oh2rt.fsf@fleche.redhat.com> <alpine.LFD.2.00.1001261535510.17519@localhost.localdomain> <1264575134.4283.1983.camel@laptop> <20100127085442.GA28422@elte.hu> <1264643539.5068.62.camel@localhost.localdomain> <20100128085502.GA7713@elte.hu> <20100129045546.GA16920@in.ibm.com> <20100129074241.GG14636@elte.hu>
In-Reply-To: <20100129074241.GG14636@elte.hu>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> * Ananth N Mavinakayanahalli <ananth@in.ibm.com> wrote:
> 
>> On Thu, Jan 28, 2010 at 09:55:02AM +0100, Ingo Molnar wrote:
>>
>> ...
>>
>>> Lets compare the two cases via a drawing. Your current uprobes submission 
>>> does:
>>>
>>>  [kernel]      do probe thing     single-step trap
>>>                ^            |     ^              |
>>>                |            v     |              v
>>>  [user]     INT3            XOL-ins              next ins-stream
>>>
>>>  ( add the need for serialization to make sure the whole single-step thing 
>>>    does not get out of sync with reality. )
>>>
>>> And emulator approach would do:
>>>
>>>  [kernel]      emul-demux-fastpath, do probe thing
>>>                ^                                 |
>>>                |                                 v
>>>  [user]     INT3                                 next ins-stream
>>>
>>> far simpler conceptually, and faster as well, because it's one kernel entry.
>>
>> Ingo,
>>
>> Yes, conceptually, emulation is simpler. In fact, it may even be the
>> right thing to do from a housekeeping POV if gdb were enabled to use
>> breakpoint assistance in the kernel. However... emulation is not
>> easy. Just quoting Peter Anvin:
>>
>>> On the more general rule of interpretation: I'm really concerned about
>>> having a bunch of partially-capable x86 interpreters all over the
>>> kernel.  x86 is *hard* to emulate, and it will only get harder as the
>>> architecture evolves.
>>>
>>>       -hpa
> 
> This is obviously true for a full emulator. Except for the fact that:
> 
>> Yes, I know you suggested we start with a small subset.
> 
> and for the fact that we already have emulators in the kernel.
> 
> Plus we _already_ need to decode instructions for safe kprobing and have the 
> code for that upstream. So it's not like we can avoid decoding the 
> instructions. (and emulating certain instruction patterns is really just a 
> natural next step of a good decoder.)
> 
>> We already have an implementation of instruction emulation in kernel for x86 
>> and powerpc, but its too KVM centric. If there is a generic emulation layer, 
>> we would use it.
> 
> So this approach, beyond being simpler, more robust and faster than the 
> current XOL code, would also trigger (much needed) cleanups in other parts of 
> the kernel and would share code with other kernel subsystems.

Hm, ok. Indeed, we have some x86 emulator-like codes in kernel(see,
arch/x86/mm/pf_in.*). I think it is basically good thing to re-implement
much-better emulator for all. But I think it'll be a long step, because
when I had tried to reuse kvm emulator for decoder, I felt that was too
specialized for kvm, vcpu, guest virtual memory access, and so on.

If we could make an emulator/evaluater/decoder which can provide
functions for those consumers, I'm not so sure it is fast enough,
because I don't think XOL code is so slower than emulating... based on my
experience of kprobe benchmarks, it will need ~500 cycles.
If the emulator can be faster than that, I agreed.

(BTW, apart from uprobes need, I think those codes should be refined
with some well-maintainable instruction maps, like x86-opcode-map.txt :))


> Dont you see the obvious advantages of that?

Hmm, my another concern is if we have to make emulators for each arch,
an XOL implementation could be much simpler than total code of that.


So, summarize my thought, in short term (and only for uprobe), XOL
is better way to go. It can be reused on other archs, generic, and
not-so-slow (and we can boost some opcodes). However, it'll not
transparent from user space(users can see which instruction is probed),
will reduce user space, and might have security issue(?).

In long term, generic x86 emulator is also another way. If we
can make it enough generic, we don't need XOL code. However, it is
hard and takes a time to make it so generic, and can be slower than
XOL on some complex instructions (and also, how many instructions
should be supported is enough for that?). Indeed, I must admit that
implementing an emulator should be exciting for kernel hackers :)

Anyway, if you think we can't avoid generalizing x86 emulators
(even without uprobes), maybe, it a good way to go.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

