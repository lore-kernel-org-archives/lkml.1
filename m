Return-Path: <linux-kernel-owner+w=401wt.eu-S932764AbZKXUOD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932764AbZKXUOD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 15:14:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932718AbZKXUOB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 15:14:01 -0500
Received: from mail-ew0-f215.google.com ([209.85.219.215]:47133 "EHLO
	mail-ew0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932508AbZKXUOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 15:14:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UGFeU1JE4OxcLI4lyiJbuw1vw/y6QYksWt/ryHTqHESNzCYh3S/Lkpx/YDDJSujuey
         yI3UsCy1HCjoSbEs4nnX8zpiNzPIR0X1DvVxjILM1YUtDVTCKnArm1rBXxhcExIOHLsm
         7X3kR8beh00EXDs8ILo6k1sbfx79hckwlkZRc=
Date: Tue, 24 Nov 2009 21:14:00 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>,
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
Subject: Re: [PATCH -tip v5 03/10] kprobes: Introduce kprobes jump
	optimization
Message-ID: <20091124201357.GB5071@nowhere>
References: <20091123232115.22071.71558.stgit@dhcp-100-2-132.bos.redhat.com> <20091123232141.22071.53317.stgit@dhcp-100-2-132.bos.redhat.com> <20091124024417.GA6752@nowhere> <20091124033135.GE6752@nowhere> <4B0BFCF8.4060905@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B0BFCF8.4060905@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 10:34:16AM -0500, Masami Hiramatsu wrote:
> Frederic Weisbecker wrote:
> > I _might_ have understood.
> > You have set up the optimized flags, then you wait for
> > any old-style int 3 kprobes to complete and route
> > to detour buffer so that you can patch the jump
> > safely in the dead code? (and finish with first byte
> > by patching the int 3 itself)
> > 
> 
> Yeah, you might get almost correct answer.
> The reason why we have to wait scheduling on all processors
> is that this code may modify N instructions (not a single
> instruction). This means, there is a chance that 2nd to nth
> instructions are interrupted on other cpus when we start
> code modifying.


Aaah ok!

In this case, you probably just need the synchronize_sched()
thing. The delayed work looks unnecessary.

 
> Please imagine that 2nd instruction is interrupted and
> stop_machine() replaces the 2nd instruction with jump
> *address* while running interrupt handler. When the interrupt
> returns to original address, there is no valid instructions
> and it causes unexpected result.


Yeah.


> 
> To avoid this situation, we have to wait a scheduler quiescent
> state on all cpus, because it also ensure that all current
> interruption are done.


Ok.


> This also excuses why we don't need to wait when unoptimizing
> and why it has not supported preemptive kernel yet.


I see...so the non-preemptible kernel requirement looks
hard to workaround :-s


> In unoptimizing case, since there is just a single instruction
> (jump), there is no nth instruction which can be interrupted.
> Thus we can just use a stop_machine(). :-)


Ok.


> 
> On the preemptive kernel, waiting scheduling is not work as we
> see on non-preemptive kernel. Since processes can be preempted
> in interruption, we can't ensure that the current running
> interruption is done. (I assume that a pair of freeze_processes
> and thaw_processes may possibly ensure that, or maybe we can
> share some stack rewinding code with ksplice.)
> So it depends on !PREEMPT.



Right.
However using freeze_processes() and thaw_processes() would be
probably too costly and it's not a guarantee that every processes
go to the refrigerator() :-), because some tasks are not freezable,
like the kernel threads by default if I remember well, unless they
call set_freezable(). That's a pity, we would just have needed
to set __kprobe in refrigerator().


PS: hmm btw I remember about a patch that
tagged refrigerator() as __cold but it looks like it hasn't been
applied....

Thanks.

