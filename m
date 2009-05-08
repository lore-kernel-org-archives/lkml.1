Return-Path: <linux-kernel-owner+w=401wt.eu-S1764003AbZEHVYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764003AbZEHVYM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 17:24:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756784AbZEHVXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 17:23:35 -0400
Received: from mail.windriver.com ([147.11.1.11]:44747 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755259AbZEHVXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 17:23:33 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, kdb@oss.sgi.com
Subject: [PATCH 0/13] RFC ONLY - kdb for kgdb
Date: Fri,  8 May 2009 16:23:07 -0500
Message-Id: <1241817800-9320-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.rc0.1.gf800
X-OriginalArrivalTime: 08 May 2009 21:23:23.0684 (UTC) FILETIME=[37E33640:01C9D023]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series is a request for comments on several levels.

1) Do people find kdb useful? (See * and **)
2) Would kdb folks be willing to use it if it was a front end to kgdb?
3) Does kdb have a future in the mainline kernel?
4) Is this a reasonable approach to have some level of
   unification to end up with a more robust kernel debugger?

* This is not meant to be a religious war

** This will never replace printk :-)

What follows is a series of patches to the development kernel which
enable kdb as a front end to kgdb for arm, mips, powerpc, and x86.
This is a very raw prototype, but enough of it it works such that
folks can try it out.

To get the most basic functionality, you only need the first 2 patches
in the series.  The remainder of the patches go on to incrementally
add back some of the functionality that was removed from kdb.  I made
an attempt to try to make the first part just the generic set of
changes required to get kdb working on 1 or more archs.

The kdb front end works a little differently than if you were to take
the original kdb patch set from:

ftp://oss.sgi.com/projects/kdb/download/v4.4/

In the kernel .config you should enable the following options:

CONFIG_KGDB=y
CONFIG_KGDB_SERIAL_CONSOLE=y
CONFIG_KGDB_LOW_LEVEL_TRAP=y
CONFIG_KGDB_KDB=y
CONFIG_KGDB_KDB_PRIMARY=y
CONFIG_KDB_KEYBOARD=y
CONFIG_KDB_USB=y

If you were using the serial port with kdb before, now you just use
the kgdboc mechanism with no differences at all.  IE use you kernel
command line with:

   console=ttyS0,115200 kgdboc=ttyS0 kgdbwait

That will get you access to kdb just after the console has been
registered.  If you want to use the keyboard, you could use:

   console=tty0 kgdboc=kdb kgdbwait

You can also use the keyboard and or serial console:

   console=ttyS0,115200 console=tty0 kgdboc=kdb,ttyS0


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

I have also found on some PS/2 keyboards you have press alt again
after resuming the system because the key up event got lost somewhere.

Once you are in kdb you can run help to see a limited list of
commands.

You can also still connect gdb or re-enter kdb without leaving the
exception state.  To get out of kgdb mode you can type "$3#33", or to
get into kgdb mode from kdb, you can type "kgdb".  Also from gdb you
can issue commands to the kdb front end, via gdb's montior command.
For instance you could issue "monitor lsmod".  Allowing the gdb
monitor extension was certainly another motivation behind the
prototype.

>From here it is a matter of deciding if it is worth continuing down
this route.

The evaulation of this project will definitely cause some further
cleanup and improvement to kgdb, regardless of if this effort is
carried forward.  Two of the patches in this series are patches likely
to get integrated into kgdb's code base and do not bear the "RFC ONLY"
indication.

Thanks,
Jason.

You can find the development branch for this here:

http://git.kernel.org/?p=linux/kernel/git/jwessel/linux-2.6-kgdb.git;a=shortlog;h=kdb_prototype

or grab a static version of the patches here:

http://kernel.org/pub/linux/kernel/people/jwessel/branches/kdb_prototype.tar.bz2

short log info follows:

Jason Wessel (13):
      RFC ONLY - kdb: core for kgdb backend
      RFC ONLY - kgdb: core changes to support kdb
      RFC ONLY - kgdb,8250,pl011: Return immediately from console poll
      RFC ONLY - kgdb: gdb "monitor" -> kdb passthrough
      RFC ONLY - kgdboc,keyboard: Keyboard driver for kdb with kgdb
      kgdb: remove post_primary_code references
      RFC ONLY - x86,kgdb: Add low level debug hook
      RFC ONLY - arm,kgdb: Add hook to catch an oops with debugger
      RFC ONLY - powerpc,kgdb: Introduce low level trap catching
      RFC ONLY - mips,kgdb: kdb low level trap catch and stack trace
      kgdb: Add the ability to schedule a breakpoint via a tasklet
      RFC ONLY - kgdb,kdb: use async breakpoint for sysrq for usb
      RFC ONLY - usb,keyboard: uchi, echi, and ochi polling keyboard urbs

 Makefile                              |    1 +
 arch/arm/include/asm/kgdb.h           |    2 +
 arch/arm/include/asm/kmap_types.h     |    1 +
 arch/arm/kernel/kgdb.c                |   13 +
 arch/arm/kernel/traps.c               |    5 +
 arch/mips/include/asm/kgdb.h          |    2 +
 arch/mips/include/asm/kmap_types.h    |    3 +-
 arch/mips/kernel/kgdb.c               |   27 +-
 arch/mips/kernel/traps.c              |   14 +
 arch/powerpc/include/asm/kmap_types.h |    1 +
 arch/powerpc/kernel/kgdb.c            |   12 +-
 arch/powerpc/kernel/traps.c           |    7 +
 arch/x86/include/asm/kgdb.h           |    3 +
 arch/x86/include/asm/kmap_types.h     |    3 +-
 arch/x86/kernel/kgdb.c                |   56 +-
 arch/x86/kernel/traps.c               |    6 +
 drivers/char/Makefile                 |    1 +
 drivers/char/kdb_keyboard.c           |  407 ++++
 drivers/char/kdb_keyboard.h           |  143 ++
 drivers/hid/usbhid/hid-core.c         |   26 +
 drivers/hid/usbhid/usbkbd.c           |   13 +
 drivers/serial/8250.c                 |    4 +-
 drivers/serial/amba-pl011.c           |    6 +-
 drivers/serial/kgdboc.c               |   80 +-
 drivers/usb/core/hcd.c                |   14 +
 drivers/usb/core/hcd.h                |    4 +
 drivers/usb/host/ehci-hcd.c           |   42 +
 drivers/usb/host/ehci-pci.c           |    6 +
 drivers/usb/host/ehci-q.c             |  225 ++
 drivers/usb/host/ohci-hcd.c           |   66 +
 drivers/usb/host/ohci-pci.c           |    6 +-
 drivers/usb/host/ohci-q.c             |   63 +
 drivers/usb/host/uhci-hcd.c           |   36 +
 drivers/usb/host/uhci-q.c             |   51 +
 fs/proc/meminfo.c                     |  145 ++
 fs/proc/mmu.c                         |   16 +-
 include/linux/kdb.h                   |  172 ++
 include/linux/kdbprivate.h            |  611 ++++++
 include/linux/keyboard.h              |    2 +
 include/linux/kgdb.h                  |   25 +-
 include/linux/serial_core.h           |    1 +
 init/main.c                           |   26 +
 kdb/.gitignore                        |    1 +
 kdb/Makefile                          |   48 +
 kdb/kdb_bp.c                          |  863 ++++++++
 kdb/kdb_bt.c                          |  209 ++
 kdb/kdb_cmds                          |   32 +
 kdb/kdb_io.c                          |  895 ++++++++
 kdb/kdbmain.c                         | 3669 +++++++++++++++++++++++++++++++++
 kdb/kdbsupport.c                      | 1120 ++++++++++
 kernel/kallsyms.c                     |   22 +
 kernel/kgdb.c                         |  321 +++-
 kernel/module.c                       |   19 +-
 kernel/panic.c                        |    6 +
 kernel/printk.c                       |   14 +
 kernel/sched.c                        |   93 +-
 kernel/signal.c                       |   49 +
 lib/Kconfig.kgdb                      |   37 +
 mm/hugetlb.c                          |   22 +
 mm/swapfile.c                         |   22 +
 60 files changed, 9697 insertions(+), 92 deletions(-)
 create mode 100644 drivers/char/kdb_keyboard.c
 create mode 100644 drivers/char/kdb_keyboard.h
 create mode 100644 include/linux/kdb.h
 create mode 100644 include/linux/kdbprivate.h
 create mode 100644 kdb/.gitignore
 create mode 100644 kdb/Makefile
 create mode 100644 kdb/kdb_bp.c
 create mode 100644 kdb/kdb_bt.c
 create mode 100644 kdb/kdb_cmds
 create mode 100644 kdb/kdb_io.c
 create mode 100644 kdb/kdbmain.c
 create mode 100644 kdb/kdbsupport.c
