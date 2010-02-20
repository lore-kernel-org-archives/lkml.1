Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909Ab0BTAEP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 19:04:15 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:46309 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052Ab0BTAEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 19:04:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=dPQb+kUPuebX7C199u5kvFXGUju/kSCpG6MzS+XI/4IqcF4877UQy+odEGq5Mf8mtY
         HEsWCrBBYMkSHkkV56Lb+FQ9XMzurXaGYpZVd8T7/BKOQDIU4SPGahIT+cepgN4whdg3
         Ljhs1KU8tQ0NcW3Vlmynpq3EnIEWKXbrqg5Lk=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, Bjorn Wesen <bjornw@axis.com>,
       Tim Bird <tim.bird@am.sony.com>, Tim Abbott <tabbott@ksplice.com>,
       Anders Kaseorg <andersk@ksplice.com>, Waseem Daher <wdaher@ksplice.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Denys Vlasenko <vda.linux@googlemail.com>
Subject: [PATCH 00/24] Rename kernel's magic sections for compatibility with -ffunction-sections -fdata-sections
Date: Sat, 20 Feb 2010 01:03:33 +0100
Message-Id: <1266624237-22372-1-git-send-email-vda.linux@googlemail.com>
X-Mailer: git-send-email 1.6.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal, Sam, folks,

Here is a new version of the -ffunction-sections -fdata-sections patch
series based on current Linus tree.

The last time a patch series for -ffunction-sections -fdata-sections
support was proposed for merge, Linus was concerned that the patch series
touched too much rapidly-changing code.  So it was decided that we should
first clean up the kernel's linker scripts to use macros when referring to
these sections, and then have a set of relatively small patches actually
renaming the sections in the macros.  The linker script cleanup work is
now done (the last bits were merged in the v2.6.33 merge window) and so
this is the patch series to actually rename the sections.  After this
patch series is merged, there will be a small set of patches needed to
actually enable -ffunction-sections -fdata-sections.

Support for building the kernel with -ffunction-sections -fdata-sections
has two applications:

(1) It is the prerequisite needed for section garbage collection
    (ld --gc-sections), which can shrink the kernel image by up to 10% on
    embedded kernels.
(2) It is the primary prerequisite change needed for the Ksplice
    rebootless update system.

The bulk of these patches replace section names like
.data.page_aligned to .data..page_aligned.

The problem is that with -ffunction-sections -fdata-sections gcc
creates sections like .text.head and .data.nosave
whenever someone has innocuous code like this:
    static void head(...) {...}
or this:
    static int nosave = 1;
somewhere in the kernel. Currently, kernel linker scripts
are confused by such names and put these sections in wrong places.

With these patches, and without adding -ffunction-sections
-fdata-section resulting kernel and modules do not materially
change. I checked it by examining ld -Map.

I run-tested these patches on x86-64, alone and with -ffunction-sections
-fdata-sections added to KBUILD_CFLAGS. In both cases kernel was booting
and working.

When these patches are applied, further plan is to modify linker scripts
so that they work correctly with gcc-generated .text.foo sections,
and they don't mix up gcc-generated .text.foo sections with special
.text..foo sections. Same applies for .data, .rodata, .bss.


avr32 specific question: Haavard, please take a look at patch #16.
It renames .text.reset to .text..reset in linker script.
However, I don't see where .text.reset section is generated.
Is the patch correct?


Please review, and if patches look okay, apply them.

Denys Vlasenko (19):
  Rename .bss.stack to .bss..stack.
  Rename .data.gate to .data..gate.
  Rename .data.init_irqstack to .data..init_irqstack.
  Rename .data..patch.XXX to .data..patch.XXX.
  Rename .data[.percpu][.XXX] to .data[..percpu][..XXX].
  Rename .data.read_mostly to .data..read_mostly.
  Rename .data.vmpages and .data.vm0.XXX to .data..vmpages and
    .data..vm0.XXX.
  Rename .rodata.compressed to .rodata..compressed.
  Rename .text.ivt to .text..ivt.
  Rename .text.lock to .text..lock.
  Rename .text.page_aligned to .text..page_aligned.
  Rename .text.reset to .text..reset.
  Rename .text.startup to .text..startup.
  Rename .data.nosave to .data..nosave.
  Rename .data.init to .data..init.
  Rename .data.initvect to .data..initvect.
  Rename .data.lock_aligned to .data..lock_aligned.
  Rename special text sections in arch/frv from .text.XXX to
    .text..XXX.
  Rename .text.start to .text..start.

Tim Abbott (5):
  Rename .data.cacheline_aligned to .data..cacheline_aligned.
  Rename .data.init_task to .data..init_task.
  powerpc: remove unused __page_aligned definition.
  Rename .data.page_aligned to .data..page_aligned.
  Rename .bss.page_aligned to .bss..page_aligned.

 Documentation/mutex-design.txt           |    4 +-
 arch/avr32/kernel/vmlinux.lds.S          |    2 +-
 arch/frv/kernel/break.S                  |    4 +-
 arch/frv/kernel/entry.S                  |    2 +-
 arch/frv/kernel/head.S                   |    2 +-
 arch/frv/kernel/vmlinux.lds.S            |   10 ++++----
 arch/frv/mm/tlb-miss.S                   |    2 +-
 arch/h8300/boot/compressed/head.S        |    2 +-
 arch/h8300/boot/compressed/vmlinux.lds   |    2 +-
 arch/ia64/include/asm/asmmacro.h         |   12 ++++----
 arch/ia64/include/asm/cache.h            |    2 +-
 arch/ia64/include/asm/percpu.h           |    2 +-
 arch/ia64/kernel/Makefile.gate           |    2 +-
 arch/ia64/kernel/gate-data.S             |    2 +-
 arch/ia64/kernel/gate.S                  |    8 +++---
 arch/ia64/kernel/gate.lds.S              |   10 ++++----
 arch/ia64/kernel/init_task.c             |    2 +-
 arch/ia64/kernel/ivt.S                   |    2 +-
 arch/ia64/kernel/minstate.h              |    4 +-
 arch/ia64/kernel/paravirtentry.S         |    2 +-
 arch/ia64/kernel/vmlinux.lds.S           |   28 +++++++++++-----------
 arch/ia64/kvm/vmm_ivt.S                  |    2 +-
 arch/ia64/xen/gate-data.S                |    2 +-
 arch/ia64/xen/xensetup.S                 |    2 +-
 arch/m68knommu/kernel/vmlinux.lds.S      |    4 +-
 arch/m68knommu/platform/68360/head-ram.S |    2 +-
 arch/m68knommu/platform/68360/head-rom.S |    2 +-
 arch/mips/lasat/image/head.S             |    2 +-
 arch/mips/lasat/image/romscript.normal   |    2 +-
 arch/parisc/include/asm/cache.h          |    2 +-
 arch/parisc/include/asm/system.h         |    2 +-
 arch/parisc/kernel/head.S                |    2 +-
 arch/parisc/kernel/init_task.c           |    6 ++--
 arch/parisc/kernel/vmlinux.lds.S         |   12 ++++----
 arch/powerpc/include/asm/cache.h         |    2 +-
 arch/powerpc/include/asm/page_64.h       |    8 ------
 arch/powerpc/kernel/vmlinux.lds.S        |   10 +++----
 arch/s390/include/asm/cache.h            |    2 +-
 arch/s390/kernel/swsusp_asm64.S          |    2 +-
 arch/sh/boot/compressed/vmlinux.scr      |    2 +-
 arch/sh/include/asm/cache.h              |    2 +-
 arch/sparc/boot/btfixupprep.c            |    2 +-
 arch/sparc/include/asm/cache.h           |    2 +-
 arch/um/kernel/dyn.lds.S                 |    2 +-
 arch/um/kernel/init_task.c               |    2 +-
 arch/um/kernel/uml.lds.S                 |    2 +-
 arch/x86/boot/compressed/mkpiggy.c       |    2 +-
 arch/x86/boot/compressed/vmlinux.lds.S   |    4 +-
 arch/x86/include/asm/cache.h             |    2 +-
 arch/x86/kernel/acpi/wakeup_32.S         |    2 +-
 arch/x86/kernel/init_task.c              |    2 +-
 arch/x86/kernel/setup_percpu.c           |    2 +-
 arch/x86/kernel/vmlinux.lds.S            |    4 +-
 include/asm-generic/percpu.h             |   10 ++++----
 include/asm-generic/vmlinux.lds.h        |   38 +++++++++++++++---------------
 include/linux/cache.h                    |    2 +-
 include/linux/init.h                     |    2 +-
 include/linux/init_task.h                |    2 +-
 include/linux/linkage.h                  |    8 +++---
 include/linux/percpu-defs.h              |    4 +-
 include/linux/spinlock.h                 |    2 +-
 kernel/module.c                          |    2 +-
 62 files changed, 132 insertions(+), 142 deletions(-)

