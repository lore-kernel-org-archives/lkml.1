Return-Path: <linux-kernel-owner+w=401wt.eu-S1753729AbZLWVUO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729AbZLWVUO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 16:20:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752534AbZLWVUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 16:20:13 -0500
Received: from mail.windriver.com ([147.11.1.11]:44980 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155AbZLWVUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 16:20:11 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, kdb@oss.sgi.com, mingo@elte.hu
Subject: [PATCH 0/37] kgdb, kdb and atomic kernel modesetting series
Date: Wed, 23 Dec 2009 15:19:13 -0600
Message-Id: <1261603190-5036-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
X-OriginalArrivalTime: 23 Dec 2009 21:19:52.0145 (UTC) FILETIME=[AA65AC10:01CA8415]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Back in May 2009 an initial kdb prototype was posted to lkml as an RFC
to see if there was sufficient interest to merge kdb and kgdb together.

There was enough interest to continue on with the project, and it is
now in a state where further work can occur to review, and hopefully
merge the code into a future kernel.

If this is the first time you have heard about kgdb or kdb, you might
consider taking a look at the presentation slides from LPC 2009.

http://kgdb.wiki.kernel.org/index.php/Main_Page#Linux_Plumbers_Conference_presentation_2009

The code included in this series does not include any of the USB code
referenced in the presentation.

Several changes have occurred since the original prototype was posted.
All of the architectures using the kgdb core today have had the
functions implemented to make use of the kdb shell.  This list
includes x86, arm, ppc, mips, sh, sparc, and blackfin.  The proposed
atomic kernel modesetting project now has an initial implementation
for the intel i915 driver, and it should be possible to add atomic
mode setting hooks for any other video driver which makes use of
builtin kernel mode setting.  All the dead code and functions that
were not previously implemented in the RFC have been removed or
implemented.

The directory of the kernel debugger changed as well.  All the kernel
debugger pieces, the debug core, gdbstub and kdb now live under
kernel/debug.

While the patch set may be slightly large, it is broken down into
logical, incremental functionality.  Only the first 12 patches are
needed to see kdb in action on a serial port which has a kgdboc driver
for example.

It is important to understand that this work was directly derived from
the original kdb, and the intent is to deprecate the out of tree kdb
and move all its functionality to this code base.  This version of kdb
is completely wired into the debug core and the kgdboc polled I/O
model using the same API used by the gdbstub (which people call kgdb).

The kdb front end in this patch series works a little differently than
if you were to take the original kdb patch set from:

ftp://oss.sgi.com/projects/kdb/download/v4.4/

In the kernel .config you should enable the following options:

CONFIG_KGDB=y
CONFIG_KGDB_SERIAL_CONSOLE=y
CONFIG_KGDB_LOW_LEVEL_TRAP=y
CONFIG_KGDB_KDB=y
CONFIG_KDB_KEYBOARD=y

To use kdb with a serial port you would use the kgdb/kgdboc way of
doing things.  You would used a kernel command line with:

   console=ttyS0,115200 kgdboc=ttyS0 kgdbwait

That will get you access to kdb just after the console has been
registered.  If you want to use the keyboard, you could use the
following (NOTE it is kbd and not kdb, kbd is short for keyboard):

   console=tty0 kgdboc=kbd kgdbwait

You can also use the keyboard and or serial console:

   console=ttyS0,115200 console=tty0 kgdboc=kbd,ttyS0


In terms of breaking into the debugger after the system is up, you
must use the sysrq-g sequence.  That means you could run:
   echo g > /proc/sysrq-trigger

Or you can use the SysRq key on your key board.  On a typical laptop
you might have to do the following:

press and hold ALT    -- You will be holding this the whole time
press and hold FN
press and release the key with the SysRq label
release FN
press and release g
release ALT

Once you are in kdb you can run help to see a limited list of
commands.

You can also still connect gdb or re-enter kdb without leaving the
exception state, if you are using a serial port.  To get out of kgdb
mode you can type "$3#33", or to get into kgdb mode from kdb, you can
type "kgdb".

>From gdb you can issue commands to the kdb front end, via gdb's
monitor command.  For instance you could issue "monitor lsmod".
Allowing the gdb monitor extension was certainly another motivation
behind the prototype.

Included among the kdb patches are some kgdb specific fixes for the
next kernel merge window, and if kdb were to not make the cut, these
patches will be split out of the series.  Anything too ugly for a
possible merge is also a candidate to get removed from the series.

Thanks,
Jason.

You can find the development branch for this here:

http://git.kernel.org/?p=linux/kernel/git/jwessel/linux-2.6-kgdb.git;a=shortlog;h=kdb_prototype10

or grab a static version of the patches here:

http://kernel.org/pub/linux/kernel/people/jwessel/branches/kdb_prototype10.tar.bz2

---
short log follow:

The following changes since commit f42ecb2808db5386f983d593a7c08d3ea3b94a27:
  Linus Torvalds (1):
        Merge branch 'drm-linus' of git://git.kernel.org/.../airlied/drm-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git kdb_prototype10

Jason Wessel (33):
      softlockup: add sched_clock_tick() to avoid kernel warning on kgdb resume
      x86,hw_breakpoint,kgdb: kgdb to use hw_breakpoint API
      Move kernel/kgdb.c to kernel/debug/debug_core.c
      Separate the gdbstub from the debug core
      kdb: core for kgdb back end
      kgdb: eliminate kgdb_wait(), all cpus enter the same way
      kgdb,sparc: Add in kgdb_arch_set_pc for sparc
      kgdb,sh: update superh kgdb exception handling
      kgdb,blackfin: Add in kgdb_arch_set_pc for blackfin
      kgdb: core changes to support kdb
      kgdb,8250,pl011: Return immediately from console poll
      sh,sh-sci: Use NO_POLL_CHAR in the SCIF polled console code
      sparc,sunzilog: Add console polling support for sunzilog serial driver
      kgdb: gdb "monitor" -> kdb passthrough
      kgdboc,keyboard: Keyboard driver for kdb with kgdb
      kgdb: remove post_primary_code references
      x86,kgdb: Add low level debug hook
      arm,kgdb: Add hook to catch an oops with debugger
      powerpc,kgdb: Introduce low level trap catching
      mips,kgdb: kdb low level trap catch and stack trace
      kgdb: Add the ability to schedule a breakpoint via a tasklet
      kgdboc,kdb: Allow kdb to work on a non open console port
      printk,kdb: capture printk() when in kdb shell
      keyboard, input: Add hook to input to allow low level event clear
      debug_core,kdb: Allow the debug core to process a recursive debug entry
      kdb,panic,debug_core: Allow the debug core to receive a panic before smp_send_stop()
      MAINTAINERS: update kgdb, kdb, and debug_core info
      kgdboc,debug_core: Add call backs to allow kernel mode switching
      kms,kdb: Force unblank a console device
      i915: when kgdb is active display compression should be off
      drm_fb_helper: Preserve capability to use atomic kms
      drm,i915 - atomic mutex hacks
      kgdbts,sh: Add in breakpoint pc offset for superh

Jesse Barnes (2):
      kgdb: add ops arg to kgdb console active & restore hooks
      drm: add KGDB/KDB support Add support for KDB entry/exit.

Randy Dunlap (1):
      kgdb: Fix kernel-doc format error in kgdb.h

Sonic Zhang (1):
      kgdb: Make mem access function weak in kgdb.c and kgdb.h

 MAINTAINERS                           |    6 +-
 arch/arm/include/asm/kgdb.h           |    2 +
 arch/arm/include/asm/kmap_types.h     |    1 +
 arch/arm/kernel/kgdb.c                |   13 +
 arch/arm/kernel/traps.c               |    5 +
 arch/blackfin/kernel/kgdb.c           |    5 +
 arch/mips/include/asm/kgdb.h          |    2 +
 arch/mips/kernel/kgdb.c               |   27 +-
 arch/mips/kernel/traps.c              |   14 +
 arch/powerpc/include/asm/kmap_types.h |    1 +
 arch/powerpc/kernel/kgdb.c            |   12 +-
 arch/powerpc/kernel/traps.c           |    7 +
 arch/sh/kernel/kgdb.c                 |   14 +-
 arch/sparc/kernel/kgdb_32.c           |    6 +
 arch/sparc/kernel/kgdb_64.c           |    6 +
 arch/x86/include/asm/kgdb.h           |    3 +
 arch/x86/kernel/hw_breakpoint.c       |    5 +-
 arch/x86/kernel/kgdb.c                |  247 ++-
 arch/x86/kernel/traps.c               |    6 +
 drivers/char/Makefile                 |    1 +
 drivers/char/kdb_keyboard.c           |  207 +++
 drivers/char/kdb_keyboard.h           |  143 ++
 drivers/char/keyboard.c               |   30 +-
 drivers/gpu/drm/drm_fb_helper.c       |  105 ++
 drivers/gpu/drm/i915/intel_display.c  |  118 ++
 drivers/input/input.c                 |   15 +
 drivers/misc/kgdbts.c                 |    6 +
 drivers/serial/8250.c                 |    4 +-
 drivers/serial/amba-pl011.c           |    6 +-
 drivers/serial/kgdboc.c               |  150 ++-
 drivers/serial/sh-sci.c               |    6 +-
 drivers/serial/sunzilog.c             |   52 +
 drivers/video/console/fbcon.c         |    8 +
 fs/proc/meminfo.c                     |  143 ++
 fs/proc/mmu.c                         |   16 +-
 include/asm-generic/kmap_types.h      |    3 +-
 include/drm/drm_crtc_helper.h         |    2 +
 include/drm/drm_fb_helper.h           |    4 +
 include/linux/hugetlb.h               |    4 +
 include/linux/input.h                 |   10 +
 include/linux/kdb.h                   |  119 ++
 include/linux/keyboard.h              |    2 +
 include/linux/kgdb.h                  |   79 +-
 include/linux/sched.h                 |    4 +
 include/linux/serial_core.h           |    1 +
 include/linux/swap.h                  |    2 +
 init/main.c                           |    6 +
 kernel/Makefile                       |    2 +-
 kernel/debug/Makefile                 |    7 +
 kernel/debug/debug_core.c             |  977 +++++++++++
 kernel/debug/debug_core.h             |   82 +
 kernel/debug/gdbstub.c                | 1022 ++++++++++++
 kernel/debug/kdb/.gitignore           |    1 +
 kernel/debug/kdb/Makefile             |   24 +
 kernel/debug/kdb/kdb_bp.c             |  671 ++++++++
 kernel/debug/kdb/kdb_bt.c             |  217 +++
 kernel/debug/kdb/kdb_cmds             |   32 +
 kernel/debug/kdb/kdb_debugger.c       |  168 ++
 kernel/debug/kdb/kdb_io.c             |  820 ++++++++++
 kernel/debug/kdb/kdb_main.c           | 2852 +++++++++++++++++++++++++++++++++
 kernel/debug/kdb/kdb_private.h        |  420 +++++
 kernel/debug/kdb/kdb_support.c        |  942 +++++++++++
 kernel/kallsyms.c                     |   21 +
 kernel/kgdb.c                         | 1760 --------------------
 kernel/module.c                       |   19 +-
 kernel/panic.c                        |    7 +-
 kernel/printk.c                       |   26 +-
 kernel/sched.c                        |   93 ++-
 kernel/signal.c                       |   42 +
 kernel/softlockup.c                   |   16 +
 lib/Kconfig.kgdb                      |   22 +
 mm/hugetlb.c                          |   19 +
 mm/swapfile.c                         |   10 +-
 73 files changed, 9992 insertions(+), 1908 deletions(-)
 create mode 100644 drivers/char/kdb_keyboard.c
 create mode 100644 drivers/char/kdb_keyboard.h
 create mode 100644 include/linux/kdb.h
 create mode 100644 kernel/debug/Makefile
 create mode 100644 kernel/debug/debug_core.c
 create mode 100644 kernel/debug/debug_core.h
 create mode 100644 kernel/debug/gdbstub.c
 create mode 100644 kernel/debug/kdb/.gitignore
 create mode 100644 kernel/debug/kdb/Makefile
 create mode 100644 kernel/debug/kdb/kdb_bp.c
 create mode 100644 kernel/debug/kdb/kdb_bt.c
 create mode 100644 kernel/debug/kdb/kdb_cmds
 create mode 100644 kernel/debug/kdb/kdb_debugger.c
 create mode 100644 kernel/debug/kdb/kdb_io.c
 create mode 100644 kernel/debug/kdb/kdb_main.c
 create mode 100644 kernel/debug/kdb/kdb_private.h
 create mode 100644 kernel/debug/kdb/kdb_support.c
 delete mode 100644 kernel/kgdb.c


PS:

* This is not meant to replace printk :-)
* Happy Holidays!
