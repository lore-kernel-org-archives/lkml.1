Return-Path: <linux-kernel-owner+w=401wt.eu-S1755327AbYKKFqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327AbYKKFqj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 00:46:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753046AbYKKFqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 00:46:31 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:51506 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbYKKFqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 00:46:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=Uth6IJzZJsX4H8zol9Z5OEUZlRV9eMxrVvDg0tZcY5OiYUCSPVCt2KLQoFv6FoQhYZ
         IZ5K5sJlPIyeRYDKotqa5bjeLHxNlXMeSNTIDo4+dnCCy2HcUQt6XkoAv0+W4FoqXXa6
         oSLwxEZjT2FumXUjRnMhM+Hx8klx9QK3F0rP0=
Message-ID: <49191C31.1050402@gmail.com>
Date: Tue, 11 Nov 2008 06:46:25 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [RFC v3][PATCH 0/2] Make ftrace able to trace function return
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds the ability for ftrace to trace the function even on call time and on
return time. So we can now measure the time of execution of the most part of the functions
inside the kernel with ftrace.

The first patch bring the low level tools to add the support of return tracing on X86-32. It is
totally separated from the traditional implementation of ftrace and doesn't support
dynamic ftrace at this time.

The second patch adds a tracer based on the ring-buffer which measure the time of execution of the functions inside the kernel.

---

Most of the changes in this V3 have been suggested by Steven Rostedt.
The low-level function handling uses now the thread info and use a stack-style
storage of addresses. So it can follow the call stack. This implementation uses
a maximum depth of 20 calls per thread.
This is much more scalable than the old trampoline based implementation because
each thread has its own stack of return addresses. There should be lesser overruns
(cases when the tracer have to drop one trace because there is no more slot to store
the return address).
NMIs are still not supported but you can now trace even if the watchdog is enabled (functions
called in NMI context will not be traced).

There are other changes that are described below.
---

Changelog[V3]:

_CONFIG_FTRACE_RETURN depends now on CONFIG_FUNCTION_TRACER.
_ftrace_return_stub disappears to use now ftrace_stub
_Use a simplified version of the nmi context detection by ftrace
 to not trace in nmi context.
_Warn and disable tracing if fault or if the return address is not in kernel text.
_Get rid of the trampoline to use the thread_info of a task to store return addresses.
 A task get its stack of return addresses initialized in two cases:
    _ The init task begins with an empty stack of return adresses
    _ When a process forks, its child obtains an empty stack of return addresses because it will begin
      its execution in userspace and doesn't need the memorized return adresses of its parent.
_ The return_to_handler execute in two states: a first part in assembly that save appropriate registers
  (return values) and jump to the original return adresse. The second part retrieve the return address,
  send the trace and return the address.
_Use CFLAGS_REMOVE for some files when CONFIG_FTRACE_RETURN is set to let function tracer still able
 to trace its functions. V2 used notrace.
_Correct a bug during trace insertion where "disabled" wasn't well verified.
_Move case statement of the printing for return traces on trace.c to call the function provided by the
 return tracer. So other tracers can now use it.

Project of future improvements:

_ Set a more fine grained locking when touching the return addresses trace stack.
  The actual lock uses a global spinlock for all the stack of each thread.
  It would be better to set one spinlock per thread or even use a lockless solution
  based on atomic operations to manipulate the index on the stack.

_ Passing arguments to prepare_ftrace_return by register instead of using the stack. (faster)

_ Let the ftrace API to assign more than one return handler.

_ Implement return tracing on X86-64 and ARM.

Changelog[V2]:

_ Fix deadlock caused by NMI (disable tracing if watchdog is active)
_ Fix return value when it is 64 bits wide.
_ First really working version


Stats for the V3:
---
 arch/x86/Kconfig                      |    1 +
 arch/x86/include/asm/ftrace.h         |   26 +++++
 arch/x86/include/asm/thread_info.h    |   24 +++++
 arch/x86/kernel/Makefile              |    6 +
 arch/x86/kernel/entry_32.S            |   33 ++++++
 arch/x86/kernel/ftrace.c              |  181 +++++++++++++++++++++++++++++++--
 include/linux/ftrace.h                |   20 ++++
 include/linux/ftrace_irq.h            |    2 +-
 include/linux/sched.h                 |   11 ++
 kernel/Makefile                       |    4 +
 kernel/trace/Kconfig                  |   14 +++
 kernel/trace/Makefile                 |    1 +
 kernel/trace/ftrace.c                 |   16 +++
 kernel/trace/trace.c                  |   65 ++++++++++--
 kernel/trace/trace.h                  |   35 +++++++
 kernel/trace/trace_functions_return.c |   82 +++++++++++++++
 16 files changed, 505 insertions(+), 16 deletions(-)
