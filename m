Return-Path: <linux-kernel-owner+w=401wt.eu-S1755351Ab0ANPAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351Ab0ANPAO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 10:00:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754797Ab0ANPAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 10:00:13 -0500
Received: from mail.windriver.com ([147.11.1.11]:47355 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383Ab0ANPAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 10:00:12 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, mingo@elte.hu
Subject: [PATCH 0/40] kgdb, kdb and atomic kernel modesetting series
Date: Thu, 14 Jan 2010 08:58:56 -0600
Message-Id: <1263481176-1897-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.1.9.g95405b
X-OriginalArrivalTime: 14 Jan 2010 14:59:43.0365 (UTC) FILETIME=[34648B50:01CA952A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is version 2 of the series posted in December.

Thank you very much to everyone who provided feedback on the original
patch set.

The new patch set is more stable, cleaned up based on feedback and now
includes documentation.

The following is a list of differences between since the last time the
kdb / kgdb series was posted:

* All the code is now in linux-next via kgdb-next
  * 6 different build breakages were repaired around different .config
    options not compiling
  * kms / kdb / kgdb was built tested as kernel modules
* The kdb core was split into 2 patches, 1 for the core, and one for all
  the files touched outside the kdb core
* kdb_seq_printf added to eliminate the duplicate meminfo commands in procfs
* kdb breakpoint code refactored to remove unused globals and struct members
* Fixed the possibility to loop infinitely in the kdb md command
* Cleaned up the kdb kernel/modules.c patch
* Removed the unused kdb report helper function in kernel/sched.c
* HW instruction and data access breakpoints implementation completed
* The kdb keyboard code no longer modifies include/linux/keyboard.h
* The kernel_probe_read and kernel_probe_write were cleaned up for blackfin
* The blackfin arch specific kgdb implementation was cleaned up and merged
* The debug core now turns off tracing while the kernel debugger is active
* New in the series is a command for kdb called ftdump, which allows
  dumping the ftrace buffer
* kdb will automatically set the correct number of rows on the display
  via the information from the vt_console when using kms
* There is preliminary documentation for kdb and kms
* The drm hacks patch is still a hack, but cleaned up and using macros

The acks were added for the blackfin, sparc and sh arch specific code by the
respective maintainers.


-- From v1 patch set --

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

http://git.kernel.org/?p=linux/kernel/git/jwessel/linux-2.6-kgdb.git;a=shortlog;h=kdb_prototype11

or grab a static version of the patches here:

http://kernel.org/pub/linux/kernel/people/jwessel/branches/kdb_prototype11.tar.bz2

---

Jason Wessel (38):
      softlockup: add sched_clock_tick() to avoid kernel warning on kgdb resume
      x86,hw_breakpoint,kgdb: kgdb to use hw_breakpoint API
      Move kernel/kgdb.c to kernel/debug/debug_core.c
      Separate the gdbstub from the debug core
      kgdb: eliminate kgdb_wait(), all cpus enter the same way
      kgdb,sparc: Add in kgdb_arch_set_pc for sparc
      kgdb,sh: update superh kgdb exception handling
      kgdb,blackfin: Add in kgdb_arch_set_pc for blackfin
      kdb: core for kgdb back end (1 of 2)
      kdb: core for kgdb back end (2 of 2)
      kgdb: core changes to support kdb
      kgdb,8250,pl011: Return immediately from console poll
      sh,sh-sci: Use NO_POLL_CHAR in the SCIF polled console code
      sparc,sunzilog: Add console polling support for sunzilog serial driver
      kgdb: gdb "monitor" -> kdb passthrough
      kgdboc,keyboard: Keyboard driver for kdb with kgdb
      kgdb,docs: Update the kgdb docs to include kdb
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
      kgdb,docs: Update the kgdb docs to include kms
      kgdbts,sh: Add in breakpoint pc offset for superh
      debug_core: Turn off tracing while in the debugger
      ftrace,kdb: Extend kdb to be able to dump the ftrace buffer

Jesse Barnes (2):
      kgdb: add ops arg to kgdb console active & restore hooks
      drm: add KGDB/KDB support Add support for KDB entry/exit.

 Documentation/DocBook/kgdb.tmpl       |  713 +++++++--
 Documentation/kernel-parameters.txt   |   18 +-
 MAINTAINERS                           |    6 +-
 arch/arm/include/asm/kgdb.h           |   11 +
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
 drivers/char/kdb_keyboard.c           |  204 +++
 drivers/char/kdb_keyboard.h           |  143 ++
 drivers/char/keyboard.c               |   30 +-
 drivers/gpu/drm/drm_fb_helper.c       |   93 +-
 drivers/gpu/drm/i915/intel_display.c  |  114 ++-
 drivers/input/input.c                 |   15 +
 drivers/misc/kgdbts.c                 |    6 +
 drivers/serial/8250.c                 |    4 +-
 drivers/serial/amba-pl011.c           |    6 +-
 drivers/serial/kgdboc.c               |  117 ++-
 drivers/serial/sh-sci.c               |    6 +-
 drivers/serial/sunzilog.c             |   50 +
 drivers/video/console/fbcon.c         |    7 +
 fs/proc/internal.h                    |    4 +-
 fs/proc/meminfo.c                     |   15 +-
 fs/proc/mmu.c                         |    8 +-
 include/asm-generic/kmap_types.h      |    3 +-
 include/drm/drm_crtc_helper.h         |    2 +
 include/drm/drm_fb_helper.h           |    4 +
 include/linux/input.h                 |   10 +
 include/linux/kdb.h                   |  118 ++
 include/linux/kgdb.h                  |   77 +-
 include/linux/sched.h                 |    4 +
 include/linux/serial_core.h           |    1 +
 include/linux/swap.h                  |    2 +
 init/main.c                           |    6 +
 kernel/Makefile                       |    2 +-
 kernel/debug/Makefile                 |    8 +
 kernel/debug/debug_core.c             |  985 ++++++++++++
 kernel/debug/debug_core.h             |   82 +
 kernel/debug/gdbstub.c                | 1022 ++++++++++++
 kernel/debug/kdb/.gitignore           |    1 +
 kernel/debug/kdb/Makefile             |   24 +
 kernel/debug/kdb/kdb_bp.c             |  567 +++++++
 kernel/debug/kdb/kdb_bt.c             |  217 +++
 kernel/debug/kdb/kdb_cmds             |   32 +
 kernel/debug/kdb/kdb_debugger.c       |  167 ++
 kernel/debug/kdb/kdb_io.c             |  825 ++++++++++
 kernel/debug/kdb/kdb_main.c           | 2857 +++++++++++++++++++++++++++++++++
 kernel/debug/kdb/kdb_private.h        |  399 +++++
 kernel/debug/kdb/kdb_support.c        | 1007 ++++++++++++
 kernel/debug/kms_hooks.c              |   62 +
 kernel/kallsyms.c                     |   21 +
 kernel/kgdb.c                         | 1760 --------------------
 kernel/module.c                       |    4 +
 kernel/panic.c                        |    7 +-
 kernel/printk.c                       |   25 +
 kernel/sched.c                        |    7 +-
 kernel/signal.c                       |   42 +
 kernel/softlockup.c                   |   16 +
 kernel/trace/Makefile                 |    3 +
 kernel/trace/trace.c                  |   48 +-
 kernel/trace/trace.h                  |   17 +
 kernel/trace/trace_kdb.c              |  116 ++
 lib/Kconfig.kgdb                      |   24 +-
 mm/swapfile.c                         |   10 +-
 78 files changed, 10412 insertions(+), 2117 deletions(-)
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
 create mode 100644 kernel/debug/kms_hooks.c
 delete mode 100644 kernel/kgdb.c
 create mode 100644 kernel/trace/trace_kdb.c
