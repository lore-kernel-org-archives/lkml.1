Return-Path: <linux-kernel-owner+w=401wt.eu-S1756712AbZETHma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712AbZETHma (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 03:42:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756213AbZETHk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 03:40:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:42107 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755902AbZETHk6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 03:40:58 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, linux-kernel@vger.kernel.org, x86@kernel.org,
       ink@jurassic.park.msu.ru, rth@twiddle.net, linux@arm.linux.org.uk,
       hskinnemoen@atmel.com, cooloney@kernel.org, starvik@axis.com,
       jesper.nilsson@axis.com, dhowells@redhat.com,
       ysato@users.sourceforge.jp, tony.luck@intel.com, takata@linux-m32r.org,
       geert@linux-m68k.org, monstr@monstr.eu, ralf@linux-mips.org,
       kyle@mcmartin.ca, benh@kernel.crashing.org, paulus@samba.org,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, lethal@linux-sh.org,
       davem@davemloft.net, jdike@addtoit.com, chris@zankel.net,
       rusty@rustcorp.com.au
Subject: [PATCHSET core/percpu] percpu: convert most archs to dynamic percpu
Date: Wed, 20 May 2009 16:37:32 +0900
Message-Id: <1242805059-18338-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 20 May 2009 07:37:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Please do NOT pull before maintainers of alpha and s390 ack.  Upon
ack, please pull from the following git tree.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git tj-percpu

This patchset is combination of the last patch of
percpu-use-dynamic-percpu-allocator-as-default patchset[1] and patches
inspired by alpha conversion patch[2] posted by Ivan Kokshaysky.

  0001-percpu-use-dynamic-percpu-allocator-as-the-default.patch
  0002-linker-script-throw-away-.discard-section.patch
  0003-percpu-clean-up-percpu-variable-definitions.patch
  0004-percpu-enforce-global-uniqueness-and-disallow-in-fu.patch
  0005-alpha-kill-unnecessary-__used-attribute-in-PER_CPU_.patch
  0006-alpha-switch-to-dynamic-percpu-allocator.patch
  0007-s390-switch-to-dynamic-percpu-allocator.patch

0001 is mostly unchanged except for added Acked-by's.

0002-0003 prepare for percpu variable definition update - .discard is
thrown away on all archs when linking kernel and modules, static
percpu variables in functions are moved outside of the function and
all static percpu variables are given unique names.

0004 updates percpu variable definition such that all percpu variables
in the same link unit have unique names regardless of its scope
(static or global) and disallow in-function static definitions.  The
new definition uses dummy variables in .discard to enforce the
declaration/definition semantics and always defines percpu variables
as globals.  This allows archs to add 'weak' attribute if necessary.

0005-0006 converts alpha to use 'weak' attribute instead of inline
assembly to generate GOT based reference when referencing percpu
variables from modules, which in turn allows conversion to dynamic
percpu allocator.

0007 does the same for s390.

The new DECLARE/DEFINE macros implement the following behaviors.

a. DECLARE + static DEFINE -> compile error

b. multiple non-static DEFINEs with the same name -> compile error

c. multiple static/global DEFINEs with the same name -> compile error

d. in function static DEFINEs -> compile error

#a and #b are expected behaviors on DECLARE/DEFINE macros in general.
#c and #d are necessary to allow 'weak' attribute on certain archs.
Please note that the rules are applied consistently whether 'weak'
attribute is specified or not.  This eases catching mistakes and makes
things less confusing.

Test config boots and works fine on x86_64.  alpha and s390 are
compile tested and verified to generate necessary code for external
references but I don't have any way to actually verify them, so please
test them.  :-)

all-yes-config on x86_64 is building now.  Ergggh... I want more
memory.  Okay, completed successfully.

This patchset is on top of

the last #tj-percpu (e1b9aa3f47242e757c776a3771bb6613e675bf9c)
+ linus#master (279e677faa775ad16e75c32e1bf4a37f8158bc61)

and contains the following changes.

 Makefile                               |    2 
 arch/alpha/include/asm/percpu.h        |  101 ++-------------------------------
 arch/alpha/include/asm/tlbflush.h      |    1 
 arch/alpha/kernel/vmlinux.lds.S        |    1 
 arch/arm/kernel/vmlinux.lds.S          |    1 
 arch/avr32/kernel/vmlinux.lds.S        |    1 
 arch/blackfin/kernel/vmlinux.lds.S     |    1 
 arch/cris/include/asm/mmu_context.h    |    2 
 arch/cris/kernel/vmlinux.lds.S         |    1 
 arch/frv/kernel/vmlinux.lds.S          |    2 
 arch/h8300/kernel/vmlinux.lds.S        |    1 
 arch/ia64/Kconfig                      |    3 
 arch/ia64/kernel/vmlinux.lds.S         |    1 
 arch/m32r/kernel/vmlinux.lds.S         |    1 
 arch/m68k/kernel/vmlinux-std.lds       |    1 
 arch/m68k/kernel/vmlinux-sun3.lds      |    1 
 arch/m68knommu/kernel/vmlinux.lds.S    |    1 
 arch/microblaze/kernel/vmlinux.lds.S   |    2 
 arch/mips/kernel/vmlinux.lds.S         |    1 
 arch/mn10300/kernel/vmlinux.lds.S      |    1 
 arch/parisc/kernel/vmlinux.lds.S       |    1 
 arch/powerpc/Kconfig                   |    3 
 arch/powerpc/kernel/vmlinux.lds.S      |    1 
 arch/s390/include/asm/percpu.h         |   32 ++--------
 arch/s390/kernel/vmlinux.lds.S         |    1 
 arch/sh/kernel/vmlinux_32.lds.S        |    1 
 arch/sh/kernel/vmlinux_64.lds.S        |    1 
 arch/sparc/Kconfig                     |    3 
 arch/sparc/kernel/vmlinux.lds.S        |    1 
 arch/um/kernel/dyn.lds.S               |    2 
 arch/um/kernel/uml.lds.S               |    2 
 arch/x86/Kconfig                       |    3 
 arch/xtensa/kernel/vmlinux.lds.S       |    1 
 block/as-iosched.c                     |   10 +--
 block/cfq-iosched.c                    |   10 +--
 drivers/cpufreq/cpufreq_conservative.c |   12 +--
 drivers/cpufreq/cpufreq_ondemand.c     |   15 ++--
 drivers/xen/events.c                   |    9 +-
 include/linux/percpu-defs.h            |   34 ++++++++---
 include/linux/percpu.h                 |   12 ++-
 init/main.c                            |   24 -------
 kernel/module.c                        |    6 -
 mm/Makefile                            |    2 
 mm/allocpercpu.c                       |   28 +++++++++
 mm/page-writeback.c                    |    5 -
 mm/percpu.c                            |   40 ++++++++++++-
 net/ipv4/syncookies.c                  |    4 -
 net/ipv6/syncookies.c                  |    4 -
 scripts/module-common.lds              |    8 ++
 49 files changed, 206 insertions(+), 195 deletions(-)

Thanks.

--
tejun

[1] http://thread.gmane.org/gmane.linux.kernel/804631/focus=804627
[2] http://thread.gmane.org/gmane.linux.kernel/820849/focus=820926
