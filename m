Return-Path: <linux-kernel-owner+w=401wt.eu-S1764616AbZDHMT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764616AbZDHMT0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 08:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933863AbZDHMS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 08:18:58 -0400
Received: from leb.cs.unibo.it ([130.136.1.102]:37932 "EHLO leb.cs.unibo.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933837AbZDHMS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 08:18:56 -0400
Date: Wed, 8 Apr 2009 14:18:51 +0200
From: Renzo Davoli <renzo@cs.unibo.it>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jeff Dike <jdike@addtoit.com>,
       user-mode-linux-devel@lists.sourceforge.net, mtk.manpages@gmail.com,
       Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH 0/2] ptrace_vm: ptrace for syscall emulation virtual
	machines
Message-ID: <20090408121851.GE24173@cs.unibo.it>
References: <20090204080236.GA17452@cs.unibo.it> <20090310214436.GC5213@cs.unibo.it> <20090316074520.GC3360@hack> <20090324234753.GH22695@cs.unibo.it> <20090329163228.GE7671@hack> <20090404101708.GG4203@cs.unibo.it> <20090407173646.GL12226@hack>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090407173646.GL12226@hack>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > #endif
> > #ifdef PTRACE_SINGLEBLOCK
> >   case PTRACE_SINGLEBLOCK:
> > #endif
> > #ifdef PTRACE_SYSEMU
> >   case PTRACE_SYSEMU:
> >   case PTRACE_SYSEMU_SINGLESTEP:
> > #endif
> >   case PTRACE_SYSCALL:
> >   case PTRACE_CONT:
> >     return ptrace_resume(child, request, 0, data);
> >+/* statements added for PTRACE_VM management */
> >+#ifdef PTRACE_VM
> >+  case PTRACE_VM:
> >+#ifdef PTRACE_VM_SINGLESTEP
> >+  case PTRACE_VM_SINGLESTEP:
> >+#endif
> >+#ifdef PTRACE_VM_SINGLEBLOCK
> >+  case PTRACE_VM_SINGLEBLOCK:
> >+#endif
> >+    return ptrace_resume(child, PTRACE_VM_TAGS_MAPPING(request), addr, data);
> >+#endif
> >....
> >  
> 
> Hmmm, I see your points. Thanks for your analysis.
> 
The "resume tags" SYSCALL, SINGLESTEP/SINGLEBLOCK, CONT give to ptrace
the command to resume and indicate when ptrace must stop next time.
The VM_SKIPCALL, VM_SKIPEXIT tags refer to the current system call.
The two sets are independent, orthogonal.

I may want to skip this system call and stop either at the next system call
or at the next block, instruction or never.
As usual, everything is possible with or without some tags, the difference
in in this case in terms of clearness of the interface.

If we'd provide only a PTRACE_VM call (namely a PTRACE_VM_SYSCALL)
to resume up to the next syscall it was not possible to use it 
to implement a virtualized "ptrace".
The virtual ptrace call may need to stop the process after an instruction
or a block as it was requested to do so.
In this case the VM monitor should use PTRACE_SINGLE* without the
VM_SKIP* optimization (maybe faking the execution of a getpid
to skip a system call, like in the old times of User mode Linux).
For a similar reason PTRACE_SYSEMY_SINGLESTEP was added in the kernel.

WHy we should make life harder to VM monitor designer?

We could also have a unique PTRACE_VM tag and encode both
SYSCALL/SINGLESTEP/SINGLEBLOCK/BLOCK
and
SKIPCALL/SKIPEXIT
in different bits inside the addr field.

Again, this is a trick to use just one tag.
It is a matter of values.
Efficiency is the meaning of this patch, so it is a conditio
sine qua non.
Apart from efficiency, what do we want most?
Clearness of interface design?
Back compatibility for very improbable cases?

I bet on the former, usually it is an insurance for the future.

	renzo
