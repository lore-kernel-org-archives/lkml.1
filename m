Return-Path: <linux-kernel-owner+w=401wt.eu-S934718AbYDQRDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934718AbYDQRDX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 13:03:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932505AbYDQRDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 13:03:15 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:55606 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755747AbYDQRDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 13:03:14 -0400
Date: Thu, 17 Apr 2008 11:02:57 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Linus Torvalds <torvalds@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PULL REQUEST] Generic semaphores
Message-ID: <20080417170257.GB20637@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please pull my semaphore rewrite detailed below.  All the patches have
been posted to linux-kernel before, and various comments (and acks)
have been taken into account.  It has also survived about six weeks
in linux-next.  I have used Dave Howells' semaphore testing module on
it, and it has not succumbed to any problems.

I'd like to highlight the diffstat summary:
 117 files changed, 393 insertions(+), 7759 deletions(-)

The first two patches are simple header-file additions.  The third
patch contains the new semaphore implementation and removes all the
architecture-specific implementations.  The fourth and fifth patches add
new functionality, down_killable() and down_timeout().  The sixth patch
results from Dave Howells' analysis and makes the code easier to follow.
The seventh patch adds kernel-doc for all functions (thanks to Andrew
Morton and Randy Dunlap for their review) and the eighth removes a
now-obsolete Kconfig option that I missed earlier in the series.

The following changes since commit 4b119e21d0c66c22e8ca03df05d9de623d0eb50f:
  Linus Torvalds (1):
        Linux 2.6.25

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/willy/misc.git semaphore

Matthew Wilcox (8):
      Fix quota.h includes
      Add semaphore.h to kernel_lock.c
      Generic semaphore implementation
      Introduce down_killable()
      Add down_timeout and change ACPI to use it
      Simplify semaphore implementation
      Improve semaphore documentation
      Remove DEBUG_SEMAPHORE from Kconfig

 arch/alpha/kernel/Makefile               |    2 +-
 arch/alpha/kernel/alpha_ksyms.c          |    9 -
 arch/alpha/kernel/semaphore.c            |  224 -------------------------
 arch/arm/kernel/Makefile                 |    2 +-
 arch/arm/kernel/semaphore.c              |  221 -------------------------
 arch/avr32/kernel/Makefile               |    2 +-
 arch/avr32/kernel/semaphore.c            |  148 -----------------
 arch/blackfin/Kconfig                    |    4 -
 arch/blackfin/kernel/bfin_ksyms.c        |    5 -
 arch/cris/kernel/Makefile                |    3 +-
 arch/cris/kernel/crisksyms.c             |    7 -
 arch/cris/kernel/semaphore.c             |  129 ---------------
 arch/frv/kernel/Makefile                 |    2 +-
 arch/frv/kernel/frv_ksyms.c              |    1 -
 arch/frv/kernel/semaphore.c              |  155 -----------------
 arch/h8300/kernel/Makefile               |    2 +-
 arch/h8300/kernel/h8300_ksyms.c          |    1 -
 arch/h8300/kernel/semaphore.c            |  132 ---------------
 arch/ia64/kernel/Makefile                |    2 +-
 arch/ia64/kernel/ia64_ksyms.c            |    6 -
 arch/ia64/kernel/semaphore.c             |  165 -------------------
 arch/m32r/kernel/Makefile                |    2 +-
 arch/m32r/kernel/m32r_ksyms.c            |    5 -
 arch/m32r/kernel/semaphore.c             |  185 ---------------------
 arch/m68k/kernel/Makefile                |    2 +-
 arch/m68k/kernel/m68k_ksyms.c            |    6 -
 arch/m68k/kernel/semaphore.c             |  132 ---------------
 arch/m68k/lib/Makefile                   |    2 +-
 arch/m68k/lib/semaphore.S                |   53 ------
 arch/m68knommu/kernel/Makefile           |    2 +-
 arch/m68knommu/kernel/m68k_ksyms.c       |    6 -
 arch/m68knommu/kernel/semaphore.c        |  133 ---------------
 arch/m68knommu/lib/Makefile              |    2 +-
 arch/m68knommu/lib/semaphore.S           |   66 --------
 arch/mips/kernel/Makefile                |    2 +-
 arch/mips/kernel/semaphore.c             |  168 -------------------
 arch/mn10300/kernel/Makefile             |    2 +-
 arch/mn10300/kernel/semaphore.c          |  149 -----------------
 arch/parisc/kernel/Makefile              |    2 +-
 arch/parisc/kernel/parisc_ksyms.c        |    5 -
 arch/parisc/kernel/semaphore.c           |  102 ------------
 arch/powerpc/kernel/Makefile             |    2 +-
 arch/powerpc/kernel/ppc_ksyms.c          |    1 -
 arch/powerpc/kernel/semaphore.c          |  135 ---------------
 arch/ppc/kernel/semaphore.c              |  131 ---------------
 arch/s390/kernel/Makefile                |    2 +-
 arch/s390/kernel/s390_ksyms.c            |    7 -
 arch/s390/kernel/semaphore.c             |  108 ------------
 arch/sh/kernel/Makefile_32               |    2 +-
 arch/sh/kernel/Makefile_64               |    2 +-
 arch/sh/kernel/semaphore.c               |  139 ----------------
 arch/sh/kernel/sh_ksyms_32.c             |    7 -
 arch/sh/kernel/sh_ksyms_64.c             |    4 -
 arch/sparc/kernel/Makefile               |    2 +-
 arch/sparc/kernel/semaphore.c            |  155 -----------------
 arch/sparc/kernel/sparc_ksyms.c          |    5 -
 arch/sparc64/kernel/Makefile             |    2 +-
 arch/sparc64/kernel/semaphore.c          |  254 ----------------------------
 arch/sparc64/kernel/sparc64_ksyms.c      |    6 -
 arch/um/Kconfig.i386                     |    4 -
 arch/um/Kconfig.x86_64                   |    4 -
 arch/um/sys-i386/ksyms.c                 |   12 --
 arch/um/sys-ppc/Makefile                 |    8 +-
 arch/um/sys-x86_64/ksyms.c               |   13 +--
 arch/v850/kernel/Makefile                |    2 +-
 arch/v850/kernel/semaphore.c             |  166 -------------------
 arch/v850/kernel/v850_ksyms.c            |    7 -
 arch/x86/Kconfig                         |    3 -
 arch/x86/kernel/i386_ksyms_32.c          |    5 -
 arch/x86/kernel/x8664_ksyms_64.c         |    6 -
 arch/x86/lib/semaphore_32.S              |   83 ----------
 arch/x86/lib/thunk_64.S                  |    5 -
 arch/xtensa/kernel/Makefile              |    2 +-
 arch/xtensa/kernel/semaphore.c           |  226 -------------------------
 arch/xtensa/kernel/xtensa_ksyms.c        |    9 -
 drivers/acpi/osl.c                       |   89 +++--------
 include/asm-alpha/semaphore.h            |  150 +-----------------
 include/asm-arm/semaphore-helper.h       |   84 ----------
 include/asm-arm/semaphore.h              |   99 +-----------
 include/asm-avr32/semaphore.h            |  109 +------------
 include/asm-blackfin/semaphore-helper.h  |   82 ---------
 include/asm-blackfin/semaphore.h         |  106 +------------
 include/asm-cris/semaphore-helper.h      |   78 ---------
 include/asm-cris/semaphore.h             |  134 +---------------
 include/asm-frv/semaphore.h              |  156 +-----------------
 include/asm-h8300/semaphore-helper.h     |   85 ----------
 include/asm-h8300/semaphore.h            |  191 +---------------------
 include/asm-ia64/semaphore.h             |  100 +-----------
 include/asm-m32r/semaphore.h             |  145 +----------------
 include/asm-m68k/semaphore-helper.h      |  142 ----------------
 include/asm-m68k/semaphore.h             |  164 +------------------
 include/asm-m68knommu/semaphore-helper.h |   82 ---------
 include/asm-m68knommu/semaphore.h        |  154 +-----------------
 include/asm-mips/semaphore.h             |  109 +------------
 include/asm-mn10300/semaphore.h          |  170 +-------------------
 include/asm-parisc/semaphore-helper.h    |   89 ----------
 include/asm-parisc/semaphore.h           |  146 +----------------
 include/asm-powerpc/semaphore.h          |   95 +-----------
 include/asm-s390/semaphore.h             |  108 +------------
 include/asm-sh/semaphore-helper.h        |   89 ----------
 include/asm-sh/semaphore.h               |  116 +-------------
 include/asm-sparc/semaphore.h            |  193 +----------------------
 include/asm-sparc64/semaphore.h          |   54 +------
 include/asm-um/semaphore.h               |    7 +-
 include/asm-v850/semaphore.h             |   85 +----------
 include/asm-x86/semaphore.h              |    6 +-
 include/asm-x86/semaphore_32.h           |  175 --------------------
 include/asm-x86/semaphore_64.h           |  180 --------------------
 include/asm-xtensa/semaphore.h           |  100 +-----------
 include/linux/quota.h                    |    8 +-
 include/linux/semaphore.h                |   51 ++++++
 kernel/Makefile                          |    2 +-
 kernel/semaphore.c                       |  264 ++++++++++++++++++++++++++++++
 lib/Kconfig.debug                        |   10 -
 lib/Makefile                             |    1 -
 lib/kernel_lock.c                        |    1 +
 lib/semaphore-sleepers.c                 |  176 --------------------
 117 files changed, 393 insertions(+), 7759 deletions(-)
 delete mode 100644 arch/alpha/kernel/semaphore.c
 delete mode 100644 arch/arm/kernel/semaphore.c
 delete mode 100644 arch/avr32/kernel/semaphore.c
 delete mode 100644 arch/cris/kernel/semaphore.c
 delete mode 100644 arch/frv/kernel/semaphore.c
 delete mode 100644 arch/h8300/kernel/semaphore.c
 delete mode 100644 arch/ia64/kernel/semaphore.c
 delete mode 100644 arch/m32r/kernel/semaphore.c
 delete mode 100644 arch/m68k/kernel/semaphore.c
 delete mode 100644 arch/m68k/lib/semaphore.S
 delete mode 100644 arch/m68knommu/kernel/semaphore.c
 delete mode 100644 arch/m68knommu/lib/semaphore.S
 delete mode 100644 arch/mips/kernel/semaphore.c
 delete mode 100644 arch/mn10300/kernel/semaphore.c
 delete mode 100644 arch/parisc/kernel/semaphore.c
 delete mode 100644 arch/powerpc/kernel/semaphore.c
 delete mode 100644 arch/ppc/kernel/semaphore.c
 delete mode 100644 arch/s390/kernel/semaphore.c
 delete mode 100644 arch/sh/kernel/semaphore.c
 delete mode 100644 arch/sparc/kernel/semaphore.c
 delete mode 100644 arch/sparc64/kernel/semaphore.c
 delete mode 100644 arch/v850/kernel/semaphore.c
 delete mode 100644 arch/xtensa/kernel/semaphore.c
 delete mode 100644 include/asm-arm/semaphore-helper.h
 delete mode 100644 include/asm-blackfin/semaphore-helper.h
 delete mode 100644 include/asm-cris/semaphore-helper.h
 delete mode 100644 include/asm-h8300/semaphore-helper.h
 delete mode 100644 include/asm-m68k/semaphore-helper.h
 delete mode 100644 include/asm-m68knommu/semaphore-helper.h
 delete mode 100644 include/asm-parisc/semaphore-helper.h
 delete mode 100644 include/asm-sh/semaphore-helper.h
 delete mode 100644 include/asm-x86/semaphore_32.h
 delete mode 100644 include/asm-x86/semaphore_64.h
 create mode 100644 include/linux/semaphore.h
 create mode 100644 kernel/semaphore.c
 delete mode 100644 lib/semaphore-sleepers.c

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
