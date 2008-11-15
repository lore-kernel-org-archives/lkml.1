Return-Path: <linux-kernel-owner+w=401wt.eu-S1756158AbYKOVse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158AbYKOVse (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 16:48:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752198AbYKOVsC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 16:48:02 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:44916 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbYKOVsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 16:48:00 -0500
Message-Id: <20081115214705.363808961@goodmis.org>
User-Agent: quilt/0.46-1
Date: Sat, 15 Nov 2008 16:47:05 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>, Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 0/5] ftrace updates for tip, and ground work for other architectures
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Patch 2 is a change in dynamic ftrace interface between the generic
code and the arch dependent code.  The original code did not allow
for the flexibility to handle some architecture limitations. I ran
into this when trying to port to PPC32 and realized that the
modules used trampolines to make the jumps to mcount.

I have successfully ported PPC64 and PPC32 and will send those patches
out later. But this patch series sets up the ground work for other
architectures to port dynamic ftrace.

The main changes to the code is:

 1) I removed the ftarce_modify_code and replaced it with two functions:
 	ftrace_make_nop() and ftrace_make_call. The former converts
	the code into a nop. The later converts a nop into a call.

 2) instead of passing just the address and expected and replace in
 	I pass in the dynamic ftrace record itself. This allows
	the architecture code save data per record if needed.
	To do this, there is now a dyn_arch_ftrace structure
	in the dyn_ftrace record.

 3) On intialization, ftrace_make_nop gets passed in the module that
 	created it or NULL if it is core kernel code. This allows
	the archicecture code do special things for modules, and
	also use the module sturcture to store data for later use
	with the conversions.

The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: tip/devel


Steven Rostedt (5):
      ftrace: replace raw_local_irq_save with local_irq_save
      ftrace: pass module struct to arch dynamic ftrace functions
      ftrace: allow NULL pointers in mcount_loc
      ftrace: fix dyn ftrace filter
      ftrace: make filtered functions effective on setting

----
 arch/x86/include/asm/ftrace.h |    8 ++
 arch/x86/kernel/ftrace.c      |   29 +++++++-
 include/linux/ftrace.h        |   53 +++++++++++----
 kernel/module.c               |    2 +-
 kernel/trace/ftrace.c         |  147 ++++++++++++++++++-----------------------
 kernel/trace/trace.c          |    4 +-
 kernel/trace/trace_selftest.c |    4 +-
 7 files changed, 145 insertions(+), 102 deletions(-)
