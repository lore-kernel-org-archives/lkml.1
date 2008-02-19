Return-Path: <linux-kernel-owner+w=401wt.eu-S1760535AbYBSUeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760535AbYBSUeA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 15:34:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761123AbYBSUdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 15:33:38 -0500
Received: from relay1.sgi.com ([192.48.171.29]:45086 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756128AbYBSUdg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 15:33:36 -0500
Message-Id: <20080219203335.866324000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 19 Feb 2008 12:33:35 -0800
From: Mike Travis <travis@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>
Cc: Christoph Lameter <clameter@sgi.com>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 0/2] x86: Optimize percpu accesses v3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patchset is the x86-specific part split from the generic part
of the zero-based patchset.

This patchset provides the following:

  * x86_64: Fold pda into per cpu area

    Declare the pda as a per cpu variable. This will move the pda
    area to an address accessible by the x86_64 per cpu macros.
    Subtraction of __per_cpu_start will make the offset based from
    the beginning of the per cpu area.  Since %gs is pointing to the
    pda, it will then also point to the per cpu variables and can be
    accessed thusly:

	%gs:[&per_cpu_xxxx - __per_cpu_start]

  * x86_64: Rebase per cpu variables to zero

    Take advantage of the zero-based per cpu area provided above.
    Then we can directly use the x86_32 percpu operations. x86_32
    offsets %fs by __per_cpu_start. x86_64 has %gs pointing directly
    to the pda and the per cpu area thereby allowing access to the
    pda with the x86_64 pda operations and access to the per cpu
    variables using x86_32 percpu operations.  After rebasing
    the access now becomes:

	%gs:[&per_cpu_xxxx]

    Introduces a new DEFINE_PER_CPU_FIRST to locate the percpu
    variable (pda in this case) at the beginning of the percpu
    .data section.

  * x86_64: Cleanup non-smp usage of cpu maps

    Cleanup references to the early cpu maps for the non-SMP configuration
    and remove some functions called for SMP configurations only.

Based on git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Mike Travis <travis@sgi.com>
---
v3: * split generic/x86-specific into two patches
v2: * rebased and retested using linux-2.6.git
    * fixed errors reported by checkpatch.pl

Configs built and booted:

    x86_64-default
    x86_64-defconfig
    x86_64-nonuma
    x86_64-nosmp
    x86_64-stress

Configs built with no errors:

    arm-default
    i386-allmodconfig
    i386-allyesconfig
    i386-defconfig
    i386-nosmp
    ia64-default
    ia64-nosmp
    ia64-sn2
    ppc-pmac32
    ppc-smp
    s390-default
    sparc-default
    sparc64-default
    sparc64-smp
    x86_64-allmodconfig
    x86_64-allyesconfig
    x86_64-maxsmp (NR_CPUS=4096, MAXNODES=512)

Memory Effects (using x86_64-maxsmp config):

    Note that 1/2MB has been moved from permanent data to
    the init data section, while the per cpu section is only
    increased by 128 bytes per cpu.  Also text size is reduced.

4k-before                         4k-after
   5540352 .data.cacheline_alig      -524288 -9%
     46848 .data.percpu                 +128 +0%
   4804560 .data.read_mostly          -32656 +0%
      5455 .exit.text                     -2 +0%
    857648 .init.data                +557056 +64%
    162411 .init.text                    +40 +0%
   1291576 .rodata                        +2 +0%
   3939813 .text                       -1792 +0%

   3939813 Text                        -1792 +0%
   1887731 Data                        +1792 +0%
   1089536 InitData                  +557056 +51%
  10404904 OtherData                 -557056 -5%
     46848 PerCpu                       +128 +0%
  19291548 Total                       -1512 +0%

-- 
