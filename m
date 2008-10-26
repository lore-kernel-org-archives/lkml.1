Return-Path: <linux-kernel-owner+w=401wt.eu-S1755336AbYJZTlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336AbYJZTlT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 15:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753236AbYJZTlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 15:41:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58716 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753011AbYJZTlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 15:41:06 -0400
Date: Sun, 26 Oct 2008 12:41:04 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.28-rc2
Message-ID: <alpine.LFD.2.00.0810261221350.3386@nehalem.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It's not been a week yet, but we had a few annoying brown-paper-bugs in 
-rc1 that made it hard for many people to test without applying patches. 
So rather than wait out the week, I'll just make an -rc2 early, with the 
fixes for the problems that kept people from testing it.

And hey, maybe we can even _continue_ the nice model of "just small fixes 
after -rc1". I know, it sounds insane, but it's a real pleasure to do an 
-rc2 with just a handful of fixes for real problems that real people see. 
What a concept!

Anyway, as a result, the shortlog and diffstats are both tiny, and easily 
appended. There's a few hwmon fixes and some pretty trivial ones, but the 
noticeable ones are:

 - the non-NCQ libata breakage thing that broke lots of peoples setups 

 - the workqueue init bug that caused various random problems if you had 
   a SMP machine and did not enable HOTPLUG_CPU. Symptoms included boot 
   hangs, or hung applications (eg sound from firefox) or lack of USB 
   activity (eg "no keyboard reaction")

 - some broken apps seemed to be unhappy that we checked the 'struct 
   timeval' timeout to select for sanity, since they initialized it with 
   insane multi-second microsecond fields. Oh, well.

 - ext3/ext4 had introduced a bug where the same directory entry might get 
   returned twice under some circumstances, which didn't faze most 
   programs, but caused problems for at least "rm -r" and "git clean"

There's other stuff in there too, but not much, and most of it is pretty 
trivial (eg odd config issues, or the explanation for why you should 
enable the regulatory option for wireless) or much harder to trigger (the 
eventpoll oops fix). Or small fixes to random drivers (hwmon and the r8169 
fix).

			Linus

---
Al Viro (2):
      fix allmodconfig breakage
      arm ide breakage

Alistair John Strachan (2):
      hwmon: (abituguru3) Cosmetic whitespace fixes
      hwmon: (abituguru3) enable DMI probing feature on AW9D-MAX

Arjan van de Ven (2):
      wireless: fix regression caused by regulatory config option
      select: deal with math overflow from borderline valid userland data

Davide Libenzi (1):
      epoll: avoid double-inserts in case of EFAULT

Francois Romieu (1):
      r8169: revert "read MAC address from EEPROM on init"

Geert Uytterhoeven (2):
      hwmon: (w83781d) Fix linking when built-in
      m68k: Disable Amiga serial console support if modular

Jean Delvare (4):
      hwmon-vid: Add support for AMD family 10h CPUs
      hwmon: (lm90) Fix handling of hysteresis value
      hwmon: (lm90) Add support for the LM99 16 degree offset
      hwmon: (adt7473) Fix voltage conversion routines

Jens Axboe (1):
      libata: fix bug with non-ncq devices

Linus Torvalds (2):
      Revert "Call init_workqueues before pre smp initcalls."
      Linux 2.6.28-rc2

Stephen Rothwell (1):
      cgroup: remove unused variable

Theodore Ts'o (2):
      ext3: Fix duplicate entries returned from getdents() system call
      ext4: Fix duplicate entries returned from getdents() system call

---
 Documentation/hwmon/lm90   |    2 +-
 Makefile                   |    2 +-
 drivers/ata/libata-scsi.c  |    6 ++-
 drivers/char/amiserial.c   |    6 ++-
 drivers/hwmon/abituguru3.c |   30 +++++++-------
 drivers/hwmon/adt7473.c    |   29 ++++----------
 drivers/hwmon/hwmon-vid.c  |    1 +
 drivers/hwmon/lm90.c       |   52 ++++++++++++++++++++++---
 drivers/hwmon/w83781d.c    |    4 +-
 drivers/ide/icside.c       |    4 +-
 drivers/ide/rapide.c       |    4 +-
 drivers/net/r8169.c        |   88 --------------------------------------------
 fs/compat.c                |    5 +-
 fs/eventpoll.c             |   11 ++++-
 fs/ext3/dir.c              |   20 ++++------
 fs/ext4/dir.c              |   20 ++++------
 fs/select.c                |    5 +-
 init/main.c                |    3 +-
 kernel/cgroup.c            |    2 +-
 kernel/stop_machine.c      |    2 +-
 net/wireless/Kconfig       |   11 ++---
 scripts/kconfig/confdata.c |    3 +-
 22 files changed, 127 insertions(+), 183 deletions(-)
