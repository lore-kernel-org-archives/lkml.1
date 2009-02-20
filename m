Return-Path: <linux-kernel-owner+w=401wt.eu-S1758754AbZBTBPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758754AbZBTBPd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 20:15:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754396AbZBTBPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 20:15:23 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:49995 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbZBTBPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 20:15:22 -0500
Message-Id: <20090220011316.379904625@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 19 Feb 2009 20:13:16 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] changes for tip, and a nasty x86 page table bug 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

The list of changes are to keep the kernel text read only when
CONFIG_DEBUG_RODATA is set, even when the DYNAMIC_FTRACE is configured.
What it does now is to change the kernel text to writable before
modifying the mcount call points, and changes it back to read only
when it is finished.

In doing this change, I stumbled upon a nasty bug in the page handling
of the x86 code, where we can fall into a state where the PTE
has the RW bit set, but the PMD does not. This will cause an
infinite loop of faults. The reason is that the fault handler
detects "spurious faults" when it hits a page fault but the permissions
show it as correct. This test only checks the PTE pages and not the
PMD level. Thus it will return just to fault again.

The first two patches deals with this bug directly, the rest are
ftrace related. I'm thinking ftrace may be the only user to cause
this bug, but if it is not, then we might want to consider those
changes for 29. Otherwise, the changes to hit the bug are for 30
and you can wait on fixing this bug until then.

Please pull the latest tip/tracing/ftrace tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/ftrace


Steven Rostedt (6):
      x86: check PMD in spurious_fault handler
      x86: keep pmd rw bit set when creating 4K level pages
      ftrace: allow archs to preform pre and post process for code modification
      ftrace, x86: make kernel text writable only for conversions
      ftrace: immediately stop code modification if failure is detected
      ftrace: break out modify loop immediately on detection of error

----
 arch/x86/include/asm/ftrace.h |   10 ++++++++++
 arch/x86/kernel/ftrace.c      |   24 ++++++++++++++++++++++++
 arch/x86/mm/fault.c           |   13 ++++++++++++-
 arch/x86/mm/init_32.c         |   27 ++++++++++++++++++++++++---
 arch/x86/mm/init_64.c         |   29 ++++++++++++++++++++++++-----
 arch/x86/mm/pageattr.c        |    4 +++-
 include/linux/ftrace.h        |    3 +++
 kernel/trace/ftrace.c         |   34 +++++++++++++++++++++++++++++++++-
 8 files changed, 133 insertions(+), 11 deletions(-)
-- 
