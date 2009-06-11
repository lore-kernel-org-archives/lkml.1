Return-Path: <linux-kernel-owner+w=401wt.eu-S1760422AbZFKVrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760422AbZFKVrm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 17:47:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755412AbZFKVr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 17:47:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:61095 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759353AbZFKVrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 17:47:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] new files form asm-generic
Date: Thu, 11 Jun 2009 21:46:31 +0000
User-Agent: KMail/1.11.2 (Linux/2.6.29; KDE/4.2.2; x86_64; ; )
Cc: Arnd Bergmann <arnd@arndb.de>,
       Remis Lima Baima <remis.developer@googlemail.com>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Michal Simek <monstr@monstr.eu>, Chen Liqin <liqin.chen@sunplusct.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906112146.32441.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18uXnwmhptOWh89NmJfoWKLw3XpbuFC0AK9y7i
 lIRRTVzcHEXWBJx3qhYy3oVlAOjMbTImoUPyaYzcn/fUGDcrqK
 pJw6vdvARX5x/w0UuALnw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is a series of patches that adds a mostly-complete set of generic
header files in the include/asm-generic hierarchy.

Please pull
git://git.kernel.org:/pub/scm/linux/kernel/git/arnd/asm-generic.git for-linus

None of these patches should impact currently executed code in
any way, but there are four goals here:

1 Give architecture maintainers a set of generic header files that they
  can work with to reduce code duplication. I currently have three series
  of patches doing this, one for each of x86, power and microblaze. The
  plan is to get those integrated through the arch maintainers in the
  2.6.32 merge window. The amount of code added here will be more than
  made up if two architectures drop their duplicate files later.

2 Allow the merging of the score architecture. Based on my feedback, this
  has migrated to using most of the header files from this series, so
  it has become a dependency. I'd like to get my code in as early as
  possible in this merge window to give them a chance to rebase on the
  mainline tree for merging.

3 Give the microblaze architecture the chance to fix their ABI. That
  code is still carrying some legacy warts in its user space ABI, and
  Michal Simek agreed to convert to the asm-generic versions of the
  exported headers once they get in, changing the microblaze ABI one
  last time.

4 Serve as an example to new architecture maintainers on how they should
  implement their files. In many cases, they can simply use the generic
  version, in others they can use them as a base for their own optimized
  versions.


The patches have been worked on by myself, with significant testing and
improvements from Remis. The logic to get there was roughly for each
file:

- if less than two thirds of the architectures implement it, don't
  touch it. (e.g. vdso.h)

- if all architectures are fundamentally different, don't touch it.
  (e.g. ptrace.h) There are fewer of these than I expected.

- if most architectures agree on a sane approach, use that one.
  (e.g. current.h)

- if an incomplete header file exists in asm-generic, rename that
  and provide a new file according to the other rules (e.g. page.h,
  mman.h).

- if there are common variants that are only slightly different,
  create a generalized variant that an architecture can choose its
  way by potentially overriding the defaults (e.g. ioctls.h, types.h),
  make the default option either the most sane or the most common one.

- if all architectures are different without a good reason, choose
  the sanest combination of contents so the future ones are all the
  same (e.g. unistd.h, stat.h)

- if an architecture only needs it to support a feature (e.g. SMP,
  PCI, MMU), add a file for the case where that feature is not present,
  (e.g. page.h, vga.h). Simple architectures can now fall back on this
  file, more sophisticated ones need their own code.

---

Arnd Bergmann (16):
  asm-generic: rename termios.h, signal.h and mman.h
  asm-generic: introduce asm/bitsperlong.h
  asm-generic: add generic sysv ipc headers
  asm-generic: add generic ABI headers
  asm-generic: add a generic unistd.h
  asm-generic: rename atomic.h to atomic-long.h
  asm-generic: rename page.h and uaccess.h
  asm-generic: make get_rtc_time overridable
  asm-generic: make pci.h usable directly
  asm-generic: make bitops.h usable
  asm-generic: add generic versions of common headers
  asm-generic: add legacy I/O header files
  asm-generic: add generic atomic.h and io.h
  asm-generic: add generic NOMMU versions of some headers
  asm-generic: add a generic uaccess.h
  add generic lib/checksum.c

 include/asm-generic/Kbuild                         |   22 +
 include/asm-generic/Kbuild.asm                     |    1 +
 include/asm-generic/{atomic.h => atomic-long.h}    |    6 +-
 include/asm-generic/atomic.h                       |  423 ++++------
 include/asm-generic/auxvec.h                       |    8 +
 include/asm-generic/bitops.h                       |   24 +-
 include/asm-generic/bitops/atomic.h                |    1 +
 include/asm-generic/bitsperlong.h                  |   32 +
 include/asm-generic/bugs.h                         |   10 +
 include/asm-generic/cache.h                        |   12 +
 include/asm-generic/cacheflush.h                   |   30 +
 include/asm-generic/checksum.h                     |   79 ++
 include/asm-generic/current.h                      |    9 +
 include/asm-generic/delay.h                        |    9 +
 include/asm-generic/dma.h                          |   15 +
 include/asm-generic/fb.h                           |   12 +
 include/asm-generic/{page.h => getorder.h}         |    8 +-
 include/asm-generic/hardirq.h                      |   34 +
 include/asm-generic/hw_irq.h                       |    9 +
 include/asm-generic/int-l64.h                      |    2 +
 include/asm-generic/int-ll64.h                     |    2 +
 include/asm-generic/io.h                           |  300 +++++++
 include/asm-generic/ioctls.h                       |  110 +++
 include/asm-generic/ipcbuf.h                       |   34 +
 include/asm-generic/irq.h                          |   18 +
 include/asm-generic/irqflags.h                     |   72 ++
 include/asm-generic/kmap_types.h                   |   32 +
 include/asm-generic/linkage.h                      |    8 +
 include/asm-generic/{mman.h => mman-common.h}      |    6 +-
 include/asm-generic/mman.h                         |   59 +-
 include/asm-generic/mmu.h                          |   15 +
 include/asm-generic/mmu_context.h                  |   45 +
 include/asm-generic/module.h                       |   22 +
 include/asm-generic/msgbuf.h                       |   47 ++
 include/asm-generic/mutex.h                        |    9 +
 include/asm-generic/page.h                         |  123 +++-
 include/asm-generic/param.h                        |   24 +
 include/asm-generic/parport.h                      |   23 +
 include/asm-generic/pci.h                          |    8 +
 include/asm-generic/pgalloc.h                      |   12 +
 include/asm-generic/posix_types.h                  |  165 ++++
 include/asm-generic/rtc.h                          |    2 +-
 include/asm-generic/scatterlist.h                  |   43 +
 include/asm-generic/segment.h                      |    9 +
 include/asm-generic/sembuf.h                       |   38 +
 include/asm-generic/serial.h                       |   13 +
 include/asm-generic/setup.h                        |    6 +
 include/asm-generic/shmbuf.h                       |   59 ++
 include/asm-generic/shmparam.h                     |    6 +
 include/asm-generic/{signal.h => signal-defs.h}    |    6 +-
 include/asm-generic/signal.h                       |  159 +++-
 include/asm-generic/socket.h                       |   63 ++
 include/asm-generic/sockios.h                      |   13 +
 include/asm-generic/spinlock.h                     |   11 +
 include/asm-generic/stat.h                         |   72 ++
 include/asm-generic/string.h                       |   10 +
 include/asm-generic/swab.h                         |   18 +
 include/asm-generic/syscalls.h                     |   60 ++
 include/asm-generic/system.h                       |  161 ++++
 include/asm-generic/termbits.h                     |  198 +++++
 include/asm-generic/termios-base.h                 |   77 ++
 include/asm-generic/termios.h                      |  105 +++-
 include/asm-generic/timex.h                        |   22 +
 include/asm-generic/tlbflush.h                     |   18 +
 include/asm-generic/types.h                        |   42 +
 .../asm-generic/{uaccess.h => uaccess-unaligned.h} |    6 +-
 include/asm-generic/uaccess.h                      |  351 ++++++++-
 include/asm-generic/ucontext.h                     |   12 +
 include/asm-generic/unaligned.h                    |   30 +
 include/asm-generic/unistd.h                       |  854 ++++++++++++++++++++
 include/asm-generic/user.h                         |    8 +
 include/asm-generic/vga.h                          |   24 +
 lib/Makefile                                       |    2 +
 lib/checksum.c                                     |  193 +++++
 scripts/checksyscalls.sh                           |   92 ++-
 arch/alpha/include/asm/atomic.h                    |    2 +-
 arch/alpha/include/asm/bitsperlong.h               |    8 +
 arch/alpha/include/asm/page.h                      |    2 +-
 arch/alpha/include/asm/signal.h                    |    2 +-
 arch/alpha/include/asm/types.h                     |    3 -
 arch/arm/include/asm/atomic.h                      |    2 +-
 arch/arm/include/asm/bitsperlong.h                 |    1 +
 arch/arm/include/asm/mman.h                        |    2 +-
 arch/arm/include/asm/page.h                        |    2 +-
 arch/arm/include/asm/signal.h                      |    2 +-
 arch/avr32/include/asm/atomic.h                    |    2 +-
 arch/avr32/include/asm/bitsperlong.h               |    1 +
 arch/avr32/include/asm/mman.h                      |    2 +-
 arch/avr32/include/asm/signal.h                    |    2 +-
 arch/avr32/include/asm/termios.h                   |    2 +-
 arch/blackfin/include/asm/atomic.h                 |    2 +-
 arch/blackfin/include/asm/bitsperlong.h            |    1 +
 arch/blackfin/include/asm/page.h                   |    2 +-
 arch/blackfin/include/asm/signal.h                 |    2 +-
 arch/cris/include/asm/atomic.h                     |    2 +-
 arch/cris/include/asm/bitsperlong.h                |    1 +
 arch/cris/include/asm/mman.h                       |    2 +-
 arch/cris/include/asm/page.h                       |    2 +-
 arch/cris/include/asm/signal.h                     |    2 +-
 arch/frv/include/asm/atomic.h                      |    2 +-
 arch/frv/include/asm/bitsperlong.h                 |    1 +
 arch/frv/include/asm/mman.h                        |    2 +-
 arch/frv/include/asm/page.h                        |    2 +-
 arch/frv/include/asm/pci.h                         |   13 +-
 arch/frv/include/asm/termios.h                     |    2 +-
 arch/h8300/include/asm/atomic.h                    |    2 +-
 arch/h8300/include/asm/bitsperlong.h               |    1 +
 arch/h8300/include/asm/mman.h                      |    2 +-
 arch/h8300/include/asm/page.h                      |    2 +-
 arch/h8300/include/asm/signal.h                    |    2 +-
 arch/ia64/include/asm/atomic.h                     |    2 +-
 arch/ia64/include/asm/bitsperlong.h                |    8 +
 arch/ia64/include/asm/mman.h                       |    2 +-
 arch/ia64/include/asm/signal.h                     |    2 +-
 arch/ia64/include/asm/types.h                      |    7 -
 arch/m32r/include/asm/atomic.h                     |    2 +-
 arch/m32r/include/asm/bitsperlong.h                |    1 +
 arch/m32r/include/asm/mman.h                       |    2 +-
 arch/m32r/include/asm/page.h                       |    2 +-
 arch/m32r/include/asm/pci.h                        |    2 -
 arch/m32r/include/asm/signal.h                     |    2 +-
 arch/m68k/include/asm/atomic_mm.h                  |    2 +-
 arch/m68k/include/asm/atomic_no.h                  |    2 +-
 arch/m68k/include/asm/bitsperlong.h                |    1 +
 arch/m68k/include/asm/mman.h                       |    2 +-
 arch/m68k/include/asm/page_mm.h                    |    2 +-
 arch/m68k/include/asm/page_no.h                    |    2 +-
 arch/m68k/include/asm/signal.h                     |    2 +-
 arch/microblaze/include/asm/atomic.h               |    2 +-
 arch/microblaze/include/asm/bitsperlong.h          |    1 +
 arch/microblaze/include/asm/page.h                 |    2 +-
 arch/microblaze/include/asm/signal.h               |    2 +-
 arch/microblaze/include/asm/termios.h              |    2 +-
 arch/mips/include/asm/atomic.h                     |    2 +-
 arch/mips/include/asm/bitsperlong.h                |    8 +
 arch/mips/include/asm/page.h                       |    2 +-
 arch/mips/include/asm/signal.h                     |    2 +-
 arch/mips/include/asm/types.h                      |    3 -
 arch/mn10300/include/asm/atomic.h                  |    2 +-
 arch/mn10300/include/asm/bitsperlong.h             |    1 +
 arch/mn10300/include/asm/mman.h                    |    2 +-
 arch/mn10300/include/asm/signal.h                  |    2 +-
 arch/parisc/include/asm/atomic.h                   |    2 +-
 arch/parisc/include/asm/bitsperlong.h              |   20 +
 arch/parisc/include/asm/page.h                     |    2 +-
 arch/parisc/include/asm/types.h                    |    8 -
 arch/parisc/include/asm/uaccess.h                  |    2 +-
 arch/powerpc/include/asm/atomic.h                  |    2 +-
 arch/powerpc/include/asm/bitsperlong.h             |   12 +
 arch/powerpc/include/asm/mman.h                    |    2 +-
 arch/powerpc/include/asm/page_32.h                 |    2 +-
 arch/powerpc/include/asm/page_64.h                 |    2 +-
 arch/powerpc/include/asm/signal.h                  |    2 +-
 arch/powerpc/include/asm/termios.h                 |    2 +-
 arch/powerpc/include/asm/types.h                   |    9 -
 arch/s390/include/asm/atomic.h                     |    2 +-
 arch/s390/include/asm/bitsperlong.h                |   13 +
 arch/s390/include/asm/mman.h                       |    2 +-
 arch/s390/include/asm/page.h                       |    2 +-
 arch/s390/include/asm/signal.h                     |    2 +-
 arch/s390/include/asm/termios.h                    |    2 +-
 arch/s390/include/asm/types.h                      |    6 -
 arch/sh/include/asm/atomic.h                       |    2 +-
 arch/sh/include/asm/bitsperlong.h                  |    1 +
 arch/sh/include/asm/mman.h                         |    2 +-
 arch/sh/include/asm/page.h                         |    2 +-
 arch/sh/include/asm/signal.h                       |    2 +-
 arch/sparc/include/asm/atomic_32.h                 |    2 +-
 arch/sparc/include/asm/atomic_64.h                 |    2 +-
 arch/sparc/include/asm/bitsperlong.h               |   13 +
 arch/sparc/include/asm/mman.h                      |    2 +-
 arch/sparc/include/asm/page_32.h                   |    2 +-
 arch/sparc/include/asm/page_64.h                   |    2 +-
 arch/sparc/include/asm/signal.h                    |    2 +-
 arch/sparc/include/asm/types.h                     |    4 -
 arch/sparc/include/asm/uaccess_64.h                |    2 +-
 arch/um/include/asm/page.h                         |    2 +-
 arch/x86/include/asm/atomic_32.h                   |    2 +-
 arch/x86/include/asm/atomic_64.h                   |    2 +-
 arch/x86/include/asm/bitsperlong.h                 |   13 +
 arch/x86/include/asm/mman.h                        |    2 +-
 arch/x86/include/asm/page.h                        |    2 +-
 arch/x86/include/asm/signal.h                      |    2 +-
 arch/x86/include/asm/types.h                       |    6 -
 arch/xtensa/include/asm/atomic.h                   |    2 +-
 arch/xtensa/include/asm/bitsperlong.h              |    1 +
 arch/xtensa/include/asm/page.h                     |    2 +-
 187 files changed, 4438 insertions(+), 557 deletions(-)
 create mode 100644 arch/alpha/include/asm/bitsperlong.h
 create mode 100644 arch/arm/include/asm/bitsperlong.h
 create mode 100644 arch/avr32/include/asm/bitsperlong.h
 create mode 100644 arch/blackfin/include/asm/bitsperlong.h
 create mode 100644 arch/cris/include/asm/bitsperlong.h
 create mode 100644 arch/frv/include/asm/bitsperlong.h
 create mode 100644 arch/h8300/include/asm/bitsperlong.h
 create mode 100644 arch/ia64/include/asm/bitsperlong.h
 create mode 100644 arch/m32r/include/asm/bitsperlong.h
 create mode 100644 arch/m68k/include/asm/bitsperlong.h
 create mode 100644 arch/microblaze/include/asm/bitsperlong.h
 create mode 100644 arch/mips/include/asm/bitsperlong.h
 create mode 100644 arch/mn10300/include/asm/bitsperlong.h
 create mode 100644 arch/parisc/include/asm/bitsperlong.h
 create mode 100644 arch/powerpc/include/asm/bitsperlong.h
 create mode 100644 arch/s390/include/asm/bitsperlong.h
 create mode 100644 arch/sh/include/asm/bitsperlong.h
 create mode 100644 arch/sparc/include/asm/bitsperlong.h
 create mode 100644 arch/x86/include/asm/bitsperlong.h
 create mode 100644 arch/xtensa/include/asm/bitsperlong.h
 rename include/asm-generic/{atomic.h => atomic-long.h} (97%)
 rewrite include/asm-generic/atomic.h (98%)
 create mode 100644 include/asm-generic/auxvec.h
 create mode 100644 include/asm-generic/bitsperlong.h
 create mode 100644 include/asm-generic/bugs.h
 create mode 100644 include/asm-generic/cache.h
 create mode 100644 include/asm-generic/cacheflush.h
 create mode 100644 include/asm-generic/checksum.h
 create mode 100644 include/asm-generic/current.h
 create mode 100644 include/asm-generic/delay.h
 create mode 100644 include/asm-generic/dma.h
 create mode 100644 include/asm-generic/fb.h
 rename include/asm-generic/{page.h => getorder.h} (59%)
 create mode 100644 include/asm-generic/hardirq.h
 create mode 100644 include/asm-generic/hw_irq.h
 create mode 100644 include/asm-generic/io.h
 create mode 100644 include/asm-generic/ioctls.h
 create mode 100644 include/asm-generic/ipcbuf.h
 create mode 100644 include/asm-generic/irq.h
 create mode 100644 include/asm-generic/irqflags.h
 create mode 100644 include/asm-generic/kmap_types.h
 create mode 100644 include/asm-generic/linkage.h
 rename include/asm-generic/{mman.h => mman-common.h} (93%)
 rewrite include/asm-generic/mman.h (99%)
 create mode 100644 include/asm-generic/mmu.h
 create mode 100644 include/asm-generic/mmu_context.h
 create mode 100644 include/asm-generic/module.h
 create mode 100644 include/asm-generic/msgbuf.h
 create mode 100644 include/asm-generic/mutex.h
 rewrite include/asm-generic/page.h (93%)
 create mode 100644 include/asm-generic/param.h
 create mode 100644 include/asm-generic/parport.h
 create mode 100644 include/asm-generic/pgalloc.h
 create mode 100644 include/asm-generic/posix_types.h
 create mode 100644 include/asm-generic/scatterlist.h
 create mode 100644 include/asm-generic/segment.h
 create mode 100644 include/asm-generic/sembuf.h
 create mode 100644 include/asm-generic/serial.h
 create mode 100644 include/asm-generic/setup.h
 create mode 100644 include/asm-generic/shmbuf.h
 create mode 100644 include/asm-generic/shmparam.h
 rename include/asm-generic/{signal.h => signal-defs.h} (85%)
 rewrite include/asm-generic/signal.h (86%)
 create mode 100644 include/asm-generic/socket.h
 create mode 100644 include/asm-generic/sockios.h
 create mode 100644 include/asm-generic/spinlock.h
 create mode 100644 include/asm-generic/stat.h
 create mode 100644 include/asm-generic/string.h
 create mode 100644 include/asm-generic/swab.h
 create mode 100644 include/asm-generic/syscalls.h
 create mode 100644 include/asm-generic/system.h
 create mode 100644 include/asm-generic/termbits.h
 create mode 100644 include/asm-generic/termios-base.h
 create mode 100644 include/asm-generic/timex.h
 create mode 100644 include/asm-generic/tlbflush.h
 create mode 100644 include/asm-generic/types.h
 rename include/asm-generic/{uaccess.h => uaccess-unaligned.h} (82%)
 rewrite include/asm-generic/uaccess.h (96%)
 create mode 100644 include/asm-generic/ucontext.h
 create mode 100644 include/asm-generic/unaligned.h
 create mode 100644 include/asm-generic/unistd.h
 create mode 100644 include/asm-generic/user.h
 create mode 100644 include/asm-generic/vga.h
 create mode 100644 lib/checksum.c

