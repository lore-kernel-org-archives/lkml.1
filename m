Return-Path: <linux-kernel-owner+w=401wt.eu-S1756075AbYGQH02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075AbYGQH02 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 03:26:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751867AbYGQH0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 03:26:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41190 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780AbYGQH0T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 03:26:19 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 00/23] tracehook
X-Shopping-List: (1) Esoteric reservations
   (2) Romantic bees
   (3) Intransigent ghost-melt yarns
   (4) Orgiastic digressions
Message-Id: <20080717072541.F390E15411D@magilla.localdomain>
Date: Thu, 17 Jul 2008 00:25:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series introduces the "tracehook" interface layer of inlines
in <linux/tracehook.h>.  There are more details in the log entry for
patch 01/23 and in the header file comments inside that patch.
Most of these changes move code around with little or no change,
and they should not break anything or change any behavior.

This sets a new standard for uniform arch support to enable clean
arch-independent implementations of new debugging and tracing stuff,
denoted by CONFIG_HAVE_ARCH_TRACEHOOK.  Patch 20/23 adds that symbol to
arch/Kconfig, with comments listing everything an arch has to do before
setting "select HAVE_ARCH_TRACEHOOK".  These are elaborted a bit at:
	http://sourceware.org/systemtap/wiki/utrace/arch/HowTo
The new inlines that arch code must define or call have detailed
kerneldoc comments in the generic header files that say what is required.

No arch is obligated to do any work, and no arch's build should be
broken by these changes.  There are several steps that each arch should
take so it can set HAVE_ARCH_TRACEHOOK.  Most of these are simple.
Providing this support will let new things people add for doing
debugging and tracing of user-level threads "just work" for your arch
in the future.  For an arch that does not provide HAVE_ARCH_TRACEHOOK,
some new options for such features will not be available for config.

I have done some arch work and will submit this to the arch maintainers
after the generic tracehook series settles in.  For now, that work is
available in my GIT repositories, and in patch and mbox-of-patches form
at http://people.redhat.com/roland/utrace/2.6-current/

This paves the way for my "utrace" work, to be submitted later.  But it
is not innately tied to that.  I hope that the tracehook series can go
in soon regardless of what eventually does or doesn't go on top of it.
For anyone implementing any kind of new tracing/debugging plan, or just
understanding all the context of the existing ptrace implementation,
having tracehook.h makes things much easier to find and understand.

This series must be applied after the "ptrace & wait cleanup" series,
but only because of patch conflicts.  They can be reviewed separately.

This series of patches is also available in GIT at the URL below, and in a
mail folder of patch messages (use git-am or formail -s patch -p1) at:
	http://people.redhat.com/roland/utrace/2.6-current/tracehook.mbox

The following changes since commit 666f164f4fbfa78bd00fb4b74788b42a39842c64:
  Roland McGrath (1):
        fix dangling zombie when new parent ignores children

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/frob/linux-2.6-utrace.git tracehook

Roland McGrath (23):
      tracehook: add linux/tracehook.h
      tracehook: exec
      tracehook: unexport ptrace_notify
      tracehook: exit
      tracehook: clone
      tracehook: vfork-done
      tracehook: release_task
      tracehook: tracehook_tracer_task
      tracehook: tracehook_expect_breakpoints
      tracehook: tracehook_signal_handler
      tracehook: tracehook_consider_ignored_signal
      tracehook: tracehook_consider_fatal_signal
      tracehook: syscall
      tracehook: get_signal_to_deliver
      tracehook: job control
      tracehook: death
      tracehook: force signal_pending()
      tracehook: TIF_NOTIFY_RESUME
      tracehook: asm/syscall.h
      tracehook: CONFIG_HAVE_ARCH_TRACEHOOK
      tracehook: wait_task_inactive
      task_current_syscall
      /proc/PID/syscall

 arch/Kconfig                  |   18 ++
 arch/ia64/kernel/perfmon.c    |    4 +-
 arch/x86/ia32/ia32_aout.c     |    6 -
 fs/binfmt_aout.c              |    6 -
 fs/binfmt_elf.c               |    6 -
 fs/binfmt_elf_fdpic.c         |    7 -
 fs/binfmt_flat.c              |    3 -
 fs/binfmt_som.c               |    2 -
 fs/exec.c                     |   12 +-
 fs/proc/array.c               |    9 +-
 fs/proc/base.c                |   39 +++-
 include/asm-generic/syscall.h |  141 ++++++++++
 include/linux/ptrace.h        |   72 +++++
 include/linux/sched.h         |   10 +-
 include/linux/tracehook.h     |  575 +++++++++++++++++++++++++++++++++++++++++
 kernel/exit.c                 |   53 ++---
 kernel/fork.c                 |   74 ++----
 kernel/kthread.c              |    2 +-
 kernel/ptrace.c               |    2 +-
 kernel/sched.c                |   29 ++-
 kernel/signal.c               |   99 +++++---
 lib/Makefile                  |    2 +
 lib/syscall.c                 |   75 ++++++
 mm/nommu.c                    |    4 +-
 security/selinux/hooks.c      |   22 +--
 25 files changed, 1084 insertions(+), 188 deletions(-)
 create mode 100644 include/asm-generic/syscall.h
 create mode 100644 include/linux/tracehook.h
 create mode 100644 lib/syscall.c


Thanks,
Roland
