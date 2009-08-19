Return-Path: <linux-kernel-owner+w=401wt.eu-S1751252AbZHSAqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751252AbZHSAqe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 20:46:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750943AbZHSAqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 20:46:33 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:4579 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbZHSAqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 20:46:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JXSsrl1KVkQFbZt8qH7bEBYRfsuZ9UmBgzpeclvy9G7aOjmp/H7NTWUu/xKR26kva5
         8OT5KMhiJoYDEDZLq8CDBM5qRYhGTuF6cwxL7op/1ib+tUSTCwBhopWrfsE8QHnGqdVb
         jJY+wMmvQwe0CWWZ2sKVKdcw8pa+rkUhIQUGY=
Date: Wed, 19 Aug 2009 02:46:29 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
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
       =?utf-8?B?UHJ6ZW15c8WCYXdQYXdlxYJjenlr?= <przemyslaw@pawelczyk.it>,
       Roland McGrath <roland@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [PATCH -tip v14 03/12] kprobes: checks probe address is
	instruction boudary on x86
Message-ID: <20090819004627.GH5231@nowhere>
References: <20090813203403.31965.20973.stgit@localhost.localdomain> <20090813203428.31965.21939.stgit@localhost.localdomain> <20090818230340.GF5231@nowhere> <4A8B3693.9000301@redhat.com> <20090818234341.GG5231@nowhere> <4A8B4515.3090508@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A8B4515.3090508@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 18, 2009 at 08:19:33PM -0400, Masami Hiramatsu wrote:
> Frederic Weisbecker wrote:
> > On Tue, Aug 18, 2009 at 07:17:39PM -0400, Masami Hiramatsu wrote:
> >> Frederic Weisbecker wrote:
> >>>> +	while (addr < paddr) {
> >>>> +		kernel_insn_init(&insn, (void *)addr);
> >>>> +		insn_get_opcode(&insn);
> >>>> +
> >>>> +		/* Check if the instruction has been modified. */
> >>>> +		if (insn.opcode.bytes[0] == BREAKPOINT_INSTRUCTION) {
> >>>> +			ret = recover_probed_instruction(buf, addr);
> >>>
> >>>
> >>>
> >>> I'm confused about the reason of this recovering. Is it to remove
> >>> kprobes behind the current setting one in the current function?
> >>
> >> No, it recovers just an instruction which is probed by a kprobe,
> >> because we need to know the first byte of this instruction for
> >> decoding it.
> 
> Ah, sorry, it was not accurate. the function recovers an instruction
> on the buffer(buf), not on the real kernel text. :)



Ah ok. I'll just add a small comment about that then, and apply
it.


 
> >>
> >> Perhaps we'd better to have more generic interface (text_peek?)
> >> for it because another subsystem (e.g. kgdb) may want to insert int3...
> >>
> >> Thank you,
> > 
> > 
> > Aah, I see now, it's to keep a sane check of the instructions
> > boundaries without int 3 artifacts in the middle.
> > 
> > But in that case, you should re-arm the breakpoint after your
> > check, right?
> > 
> > Or may be you could do the check without repatching?
> 
> Yes, it doesn't modify kernel text, just recover an original
> instruction from kernel text and backup byte on a buffer.


Ok.


> > May be by doing a copy of insn.opcode.bytes and replacing bytes[0]
> > with what a random kprobe has stolen?
> 
> Hm, no, this function is protected from other kprobes by kprobe_mutex.
> 
> Thank you,



Right, thanks!



> -- 
> Masami Hiramatsu
> 
> Software Engineer
> Hitachi Computer Products (America), Inc.
> Software Solutions Division
> 
> e-mail: mhiramat@redhat.com
> 

