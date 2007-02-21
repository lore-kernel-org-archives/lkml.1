Return-Path: <linux-kernel-owner+w=401wt.eu-S1423101AbXBUUfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423101AbXBUUfS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 15:35:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423102AbXBUUfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 15:35:18 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:36945 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1423101AbXBUUfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 15:35:16 -0500
Date: Wed, 21 Feb 2007 15:35:13 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Roland McGrath <roland@redhat.com>
cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Kwatch: kernel watchpoints using CPU debug registers
In-Reply-To: <20070209233150.B9542180055@magilla.sf.frob.com>
Message-ID: <Pine.LNX.4.44L0.0702211458250.3435-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Going back to something you mentioned earlier...

On Fri, 9 Feb 2007, Roland McGrath wrote:

> I don't think I really object to the ABI change of clearing %dr6 after an
> exception so that it does not accumulate multiple results.  But first I'll
> have to convince myself that we never actually do want to accumulate
> multiple results.  Hmm, I think we can, so maybe I do object.  If you set
> two watchpoints inside a user buffer and then do a system call that touches
> both those addresses (e.g. read), then you will go through do_debug (to
> send_sigtrap) twice before returning to user mode.  When the syscall is
> done, you'll have a pending SIGTRAP for the debugger to handle.  By looking
> at your %dr6 the debugger can see that both watchpoints hit.  (gdb does not
> handle this case, but it should.)  Am I wrong?

Yes, you are wrong -- although perhaps you shouldn't be.

The current version of do_debug() clears dr7 when a debug interrupt is 
fielded.  As a result, if a system call touches two watchpoint addresses 
in userspace only the first access will be noticed.

This is probably a bug in do_debug().  It would be better to disable each
individual userspace watchpoint as it is triggered (or even not to disable
it at all).  dr7 would be restored when the SIGTRAP is delivered.  (But
what if the user is blocking or ignoring SIGTRAP?)


Moving on...

I've worked out a plan for implementing combined user/kernel mode 
breakpoints and watchpoints (call them "debugpoints" as a catch-all 
term).  It should work transparently with ptrace and should accomodate 
whatever scheme utrace decides to adopt.  There won't need to be a 
separate kwatch facility on top of it; the new combined facility will 
handle debugpoints in both userspace and kernelspace.

The idea is that callers can register and unregister a struct debugpoint, 
which contains fields for the type, length, address, and priority as well 
as three callback pointers (for installed, uninstalled, and triggered).  
The debug core will keep these structures sorted by priority and will 
allocate the available debug registers based on the priorities of the 
userspace and kernelspace requests.  Each CPU will have its own array of 
pointers to these structures, indicating which debugpoints are currently 
enabled.

To work with ptrace, the new scheme will completely virtualize the debug
registers.  So for example, a ptrace call might request a debugpoint in
dr0, but it could end up that the physical register used is really dr2
instead.  The various bits in dr6 and dr7 will be mapped in such a way
that the entire procedure is transparent to the user.  Debugpoints 
registered in kernelspace or by utrace won't care, of course.

There are two things I am uncertain about: vm86 mode and kprobes.  I don't
know anything about how either of them works.  Judging from the current
code, nothing much should be needed -- debug traps in vm86 mode are
handled by calling handle_vm86_trap(), and kprobes puts itself at the
start of the notify_die() chain so it can handle single-step traps.  
Eventually it will be necessary to check with someone who really 
understands the issues.

Alan Stern

