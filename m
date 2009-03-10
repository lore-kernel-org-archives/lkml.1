Return-Path: <linux-kernel-owner+w=401wt.eu-S1753517AbZCJH4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517AbZCJH4j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 03:56:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752679AbZCJH4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 03:56:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:56853 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751730AbZCJH4K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 03:56:10 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com,
       Paul Mundt <lethal@linux-sh.org>, rmk@arm.linux.org.uk,
       starvik@axis.com, ralf@linux-mips.org, davem@davemloft.net,
       cooloney@kernel.org, kyle@mcmartin.ca, matthew@wil.cx,
       grundler@parisc-linux.org, takata@linux-m32r.org,
       benh@kernel.crashing.org, rth@twiddle.net, ink@jurassic.park.msu.ru,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com
Subject: [GIT RFC] percpu: use dynamic percpu allocator as the default percpu allocator
Date: Tue, 10 Mar 2009 16:53:46 +0900
Message-Id: <1236671631-9305-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 10 Mar 2009 07:54:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello, all.

This patchset converts all SMP-capable arches other than three
non-trivial ones - powerpc64, sparc64 and ia64 - to use dynamic percpu
allocator.  The affected archs are

 * sh
 * arm
 * cris
 * mips
 * sparc(32)
 * blackfin
 * avr32
 * parisc
 * m32r
 * powerpc(32)
 * alpha
 * s390

The x86 embedding first chunk allocator is generalized and used as the
default first chunk allocator.  This first chunk allocator makes the
dynamic percpu allocator behave mostly identically to the previous
generic percpu allocator.  Percpu memory is allocated using
alloc_bootmem_pages() and module static percpu variables are allocated
right after core percpu variables.

The only differences are 1. there can be more space between percpu
areas for each cpu to accomodate minimum allocation size and first
chunk dynamic reserve and 2. dynamic percpu variables use the same
address translation mechanism as static ones.

#1 shouldn't cause any trouble and #2 shouldn't too because the
offsets for dynamic percpu variables are carried in full pointer-width
variables, so as long as the calculations don't make wrong assumptions
(should be masked by RELOC_HIDE), it should be okay, but if your arch
has addressing limitations (alpha, s390), please take a second look.

I really wanted to test it on an architecture which is actually
affected by this change but my powerstation wouldn't boot 32bit
kernel, qemu-system-sparc doesn't like SMP kernels and I don't have
access to a sparc, alpha or SMP arm, so I could only tested it on
x86_32 with a patch to use the generic default allocator.  It works
fine there and compiles fine for sparc(32), powerpc(32), alpha and
arm.  If you have an access to one of the affected archs, please test
and report the result.  I'll send a test module as a reply to this
message.  If you can boot and load/unload the module, it should be
working fine.

This patchset is on top of the current x86/core/percpu[1] and contains
the following patches.

 0001-linker-script-define-__per_cpu_load-on-all-SMP-capa.patch
 0002-percpu-make-x86-addr-pcpu-ptr-conversion-macros.patch
 0003-percpu-more-flexibility-for-dyn_size-of-pcpu_setup.patch
 0004-percpu-generalize-embedding-first-chunk-setup-helpe.patch
 0005-percpu-use-dynamic-percpu-allocator-as-the-default.patch

0001-0004 preps.  0005 does the conversion.

This patchset is available in the following git tree.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git tj-percpu

Ingo, I think it would be best to delay pulling till at least some of
the archs have been confirmed.

Diffstat follows.

 arch/arm/kernel/vmlinux.lds.S     |    1 
 arch/ia64/Kconfig                 |    3 
 arch/ia64/kernel/vmlinux.lds.S    |   12 --
 arch/powerpc/Kconfig              |    3 
 arch/powerpc/kernel/vmlinux.lds.S |    9 --
 arch/sparc/Kconfig                |    3 
 arch/x86/Kconfig                  |    3 
 arch/x86/include/asm/percpu.h     |    8 -
 arch/x86/kernel/setup_percpu.c    |   63 ++------------
 include/linux/percpu.h            |   18 +++-
 init/main.c                       |   24 -----
 kernel/module.c                   |    6 -
 mm/Makefile                       |    2 
 mm/percpu.c                       |  170 ++++++++++++++++++++++++++++++++++----
 14 files changed, 195 insertions(+), 130 deletions(-)

Thanks.

--
tejun

[1] 3a450de1365d20afde406f0d9b2931a5e4a4fd6a
