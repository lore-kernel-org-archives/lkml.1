Return-Path: <linux-kernel-owner+w=401wt.eu-S1754625AbZINDlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625AbZINDlf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 23:41:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754248AbZINDld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 23:41:33 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:52400 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849AbZINDlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 23:41:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LM+kpyGi2NrIjqOf9lmC09DSfHRp76a9sJuwnmM04RHK4OHiI2ZP2GBGk/h0ujsCqW
         dHgyFXOJjPNP19wQ05JarYRDMu/L6MW6h9SkHUh/2UJjaY+QnGCCg++VqUQR01EvdlEH
         VqeUFUj0pat7qC7GrAixfsJYp06dYymYE1ek0=
Date: Mon, 14 Sep 2009 05:41:32 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Prasad <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Jiri Slaby <jirislaby@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Avi Kivity <avi@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH 3/5] hw-breakpoints: Rewrite the hw-breakpoints layer
	on top of perf counters
Message-ID: <20090914034131.GF14306@nowhere>
References: <1252571367-25876-1-git-send-email-fweisbec@gmail.com> <1252571367-25876-4-git-send-email-fweisbec@gmail.com> <4AAACAA4.2030707@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AAACAA4.2030707@web.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 12, 2009 at 12:09:40AM +0200, Jan Kiszka wrote:
> Frederic Weisbecker wrote:
> > This patch rebase the implementation of the breakpoints API on top of
> > perf counters instances.
> > 
> > The core breakpoint API has changed a bit:
> > 
> > - register_kernel_hw_breakpoint() now takes a cpu as a parameter. For
> >   now it doesn't support all cpu wide breakpoints but this may be
> >   implemented soon.
> > 
> > - unregister_kernel_hw_breakpoint() and unregister_user_hw_breakpoint()
> >   have been unified in a single unregister_hw_breakpoint()
> > 
> > Each breakpoints now match a perf counter which now handles the
> > register scheduling, thread/cpu attachment, etc..
> > 
> > The new layering is now made as follows:
> > 
> >        ptrace       kgdb      ftrace   perf syscall
> >           \          |          /         /
> >            \         |         /         /
> 
> kgdb doesn't fit here as it requires nmi-safe services.
> 
> I don't think you want to make the whole stack nmi-safe but rather
> provide a separate interface that allows kgdb to announce to the kernel
> when it uses some slot. Those slots should simply be excluded from
> hardware updates. That's roughly the logic we use in KVM for guest
> debugging: when the host starts to use debug registers for that purpose,
> the guest's setting will not effect the real hardware anymore.



I don't quite understand what must be NMI-safe here. Is it when
we request a breakpoint or when we hit one?


 
> Still on my wishlist for KVM is a cheap & easy way to obtain the current
> register content or to refresh it in hardware. It's not yet clear to me
> where to hook this in the given design. It looks like this information
> can be scattered over the current thread and some perf counters.


With this design approach, the debug registers are not anymore stored
in the thread structure. They are not stored anymore actually.

Especially because the breakpoint are not anymore assigned to a
specific address register. This one is decided when the counter
is enabled. And the counter is often toggled on/off, depending
if we start/end profiling the desired context. It can be a single task,
in which case the counter is enabled while the task is sched in, and
disabled when it is sched out.
And between two sched atoms, the register used for a breakpoint
can be different.

The arch informations about the breakpoints (len/type/addr) are stored
in the counter structure, and the address/control registers contents
are now dynamically computed.

For your needs, basically the control must be done from perfcounters.
When you switch from host to guest, the counter must be sched out.
And in the reverse direction, it must be sched in.
Then perf will take care of that by itself.

