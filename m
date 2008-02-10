Return-Path: <linux-kernel-owner+w=401wt.eu-S1757174AbYBJHNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757174AbYBJHNf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 02:13:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754225AbYBJHN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 02:13:27 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39668 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754295AbYBJHNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 02:13:25 -0500
Date: Sun, 10 Feb 2008 08:13:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@zip.com.au>, Thomas Gleixner <tglx@linutronix.de>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [0/6] kgdb light
Message-ID: <20080210071304.GA3788@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


this is the "kgdb light" tree that has been also posted at:

   http://lkml.org/lkml/2008/2/9/236

it is available at:

   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-kgdb.git

See the shortlog below.

various iterations of this have also been included in x86.git for the 
past 3 months.

This is a slimmed-down and cleaned up version of KGDB that i've created 
out of the original patches that we submitted two weeks ago. I went over 
the kgdb patches with Thomas and we cut out everything that we did not 
like, and cleaned up the result.

KGDB is still just as functional as it was before (i tested it on 32-bit 
and 64-bit x86) - and any desired extra capability or complexity should 
be added as a delta improvement, not in this initial merge.

The difference between the original kgdb submission and this submission 
is best visible in the diffstat:

 before:     41 files changed, 4007 insertions(+), 33 deletions(-)
 after:      22 files changed, 3448 insertions(+),  2 deletions(-)

what got removed:

 - removed _all_ critical path impact, even if KGDB is enabled and
   active. The only notifier list it is registered in is the die
   notifiers, but even there it has the minimum priority of -INT_MAX, to
   be called as the last one of the die notifiers. I removed the 'early
   trap hook', the trap handler tweaks, everything. KGDB's only impact
   now are the arch details it implements in arch/x86/kernel/kgdb.c,
   nothing else.

 - removed all the lowlevel serial drivers. KGDB should not be in the 
   business of writing special-purpose Linux drivers. In fact i found a 
   testsystem where the KGDB 8250 driver would not work - it's simply 
   reimplementing the wheel that drivers/serial already implements, and 
   poorly so. Any "early debugging" functionality should be done via 
   extending the early-console concept, not via special-purpose KGDB 
   drivers.

 - I have added a redesigned and cleaned up version of the "KGDB over 
   polled consoles" approach (KGDBOC) - i believe this should be the 
   only IO transport for KGDB: it is an extension of the "console" 
   concept - nothing more, nothing less. Netconsole fits this concept 
   quite nicely as well. The moment a console driver is extended with 
   polling functionality, KGDB will be usable through that IO transport, 
   without having to know about hardware details.

 - I have removed the longjump code. That code was ugly beyond belief, 
   it tried to fix up KGDB's own faults and needed to hook into all the 
   fault handlers. It is totally, utterly wrong to do it like that. The 
   code now uses pure probe_kernel_address() accesses.

 - removed the module symbol hacks - those need a clean solution.

 - removed the GTOD/clocksource hacks. If a user uses kdgb for extended
   periods of time then GTOD clocksources can get out of sync and we
   might fall back to other clocksources. That is the _right_ thing to 
   do for the kernel, hacking it around to avoid kernel messages was
   wrong.

 - i have removed the softlockup hacks as well.

 - removed the toplevel Makefile changes - if any change is needed in 
   that area (i'm not convinced thre is), then those changes need to go
   through Sam & the kbuild folks.

 - removed the might_sleep scheduler hack as well, and the thread_return
   hack.

 - [ and did lots of other cleanups and rewrites as well. ]

as a result, this kgdb series has _obviously_ zero impact on the kernel, 
because it just does not touch any dangerous codepath. From this point 
on KGDB can evolve in small, well-controlled baby steps, as all other 
kernel code as well.

and the resulting kgdb is still very functional: it can still break into 
a kernel (via SysRq-G), can catch crashes, can single-step, etc. It's 
already a quite usable first step.

I have tested this tree on x86 32-bit and 64-bit. Other architectures 
are not expected to be impacted.

	Ingo

------------------>
Ingo Molnar (3):
      pids: add pid_max prototype
      uaccess: add probe_kernel_write()
      x86: kgdb support

Jan Kiszka (1):
      consoles: polling support, kgdboc

Jason Wessel (2):
      kgdb: core
      kgdb: document parameters

 Documentation/kernel-parameters.txt |    5 +
 arch/x86/Kconfig                    |    4 +
 arch/x86/kernel/Makefile            |    1 +
 arch/x86/kernel/kgdb.c              |  550 ++++++++++
 drivers/char/tty_io.c               |   47 +
 drivers/serial/8250.c               |   62 ++
 drivers/serial/Kconfig              |    3 +
 drivers/serial/Makefile             |    1 +
 drivers/serial/kgdboc.c             |  164 +++
 drivers/serial/serial_core.c        |   67 ++-
 include/asm-generic/kgdb.h          |   93 ++
 include/asm-x86/kgdb.h              |   87 ++
 include/linux/kgdb.h                |  264 +++++
 include/linux/pid.h                 |    2 +
 include/linux/serial_core.h         |    4 +
 include/linux/tty_driver.h          |   12 +
 include/linux/uaccess.h             |   22 +
 kernel/Makefile                     |    1 +
 kernel/kgdb.c                       | 2020 +++++++++++++++++++++++++++++++++++
 kernel/sysctl.c                     |    2 +-
 lib/Kconfig.debug                   |    2 +
 lib/Kconfig.kgdb                    |   37 +
 22 files changed, 3448 insertions(+), 2 deletions(-)
 create mode 100644 arch/x86/kernel/kgdb.c
 create mode 100644 drivers/serial/kgdboc.c
 create mode 100644 include/asm-generic/kgdb.h
 create mode 100644 include/asm-x86/kgdb.h
 create mode 100644 include/linux/kgdb.h
 create mode 100644 kernel/kgdb.c
 create mode 100644 lib/Kconfig.kgdb

