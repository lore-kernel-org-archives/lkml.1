Return-Path: <linux-kernel-owner+w=401wt.eu-S1759313AbYBATOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759313AbYBATOi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 14:14:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754922AbYBATOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 14:14:19 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:47056 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754643AbYBATOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 14:14:17 -0500
Message-Id: <20080201191414.961558000@sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 01 Feb 2008 11:14:14 -0800
From: travis@sgi.com
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Christoph Lameter <clameter@sgi.com>, Jack Steiner <steiner@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] percpu: Optimize percpu accesses
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patchset provides the following:

  * Generic: Percpu infrastructure to rebase the per cpu area to zero

    This provides for the capability of accessing the percpu variables
    using a local register instead of having to go through a table
    on node 0 to find this cpu specific offsets.  It also would allow
    atomic operations on percpu variables to reduce required locking.

  * Init: Move setup of nr_cpu_ids to as early as possible for usage
    by early boot functions.

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

Based on linux-2.6.git + x86.git

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Mike Travis <travis@sgi.com>
---
Notes:

(1 - had to disable CONFIG_SIS190 to build)
(2 - no modules)

Configs built and booted:

    x86_64-default
    x86_64-defconfig (2)
    x86_64-nonuma (2)
    x86_64-nosmp (2)
    x86_64-"Ingo Stress Test" (1,2)

Configs built with no errors:

    arm-default
    i386-allyesconfig (1)
    i386-allmodconfig (1)
    i386-defconfig
    i386-nosmp
    ppc-pmac32
    ppc-smp
    sparc64-default
    sparc64-smp
    x86_64-allmodconfig (1)
    x86_64-allyesconfig (1)
    x86_64-maxsmp (NR_CPUS=4k, MAXNODES=512)

Configs with errors prior to patch (preventing full build checkout):

    ia64-sn2: undefined reference to `mem_map' (more)
    ia64-default: (same error)
    ia64-nosmp: `per_cpu__kstat' truncated in .bss (more)
    s390-default: implicit declaration of '__raw_spin_is_contended'
    sparc-default: include/asm/pgtable.h: syntax '___f___swp_entry'

Memory Effects (using x86_64-maxsmp config):

    Note that 1/2MB has been moved from permanent data to
    the init data section, (which is removed after bootup),
    while the per cpu section is only increased by 128 bytes
    per cpu.  Also text size is reduced increasing cache
    performance.

    4k-cpus-before                  4k-cpus-after
       6588928 .data.cacheline_alig     -524288 -7%
	 48072 .data.percpu                +128 +0%
       4804576 .data.read_mostly         -32656 +0%
	854048 .init.data               +557056 +65%
	160382 .init.text                   +62 +0%
       1254214 .rodata                     +274 +0%
       3915552 .text                      -1632 +0%
	 11040 __param                     -272 -2%

       3915552 Text                       -1632 +0%
       1085440 InitData                 +557056 +51%
      11454056 OtherData                -557056 -4%
	 48072 PerCpu                      +128 +0%
      20459748 Total                      -1330 +0%

-- 
