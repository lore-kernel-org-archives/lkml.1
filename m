Return-Path: <linux-kernel-owner+w=401wt.eu-S932181AbYDVUms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932181AbYDVUms (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 16:42:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755304AbYDVUmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 16:42:22 -0400
Received: from relay1.sgi.com ([192.48.171.29]:37996 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754881AbYDVUmV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 16:42:21 -0400
Message-Id: <20080422204219.994283000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 22 Apr 2008 13:42:19 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] x86: cleanup early per cpu variables/accesses v4-folded
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  * Increase the limit of NR_CPUS to 4096 and introduce a boolean
    called "MAXSMP" which when set (e.g. "allyesconfig"), will set
    NR_CPUS = 4096 and NODES_SHIFT = 9 (512).  Changed max setting
    for NODES_SHIFT from 15 to 9 to accurately reflect the real limit.

  * Introduce a new PER_CPU macro called "EARLY_PER_CPU".  This is
    used by some per_cpu variables that are initialized and accessed
    before there are per_cpu areas allocated.

  * Add a flag "arch_provides_topology_pointers" that indicates pointers
    to topology cpumask_t maps are available.  Otherwise, use the function
    returning the cpumask_t value.  This is useful if cpumask_t set size
    is very large to avoid copying data on to/off of the stack.

  * Consolidate node_to_cpumask operations and remove the 256k
    byte node_to_cpumask_map.  This is done by allocating the
    node_to_cpumask_map array after the number of possible
    nodes (nr_node_ids) is known.

  * Restore the nodenumber field in the x86_64 pda.  This field is slightly
    different than the x86_cpu_to_node_map mainly because it's a static
    indication of which node the cpu is on while the cpu to node map is a
    dyanamic mapping that may get reset if the cpu goes offline.  This also
    simplifies the numa_node_id() macro.

  * Replace usages of MAX_NUMNODES with nr_node_ids in kernel/sched.c,
    where appropriate.  This saves some allocated space as well as many
    wasted cycles going through node entries that are non-existent.

For inclusion into sched-devel/latest tree.

Based on:
	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
    +   sched-devel/latest  .../mingo/linux-2.6-sched-devel.git


Signed-off-by: Mike Travis <travis@sgi.com>
---
v4-folded:
    Folded in Kconfig changes to increase NR_CPU limit to 4096 and add new
    config option MAXSMP.

v3-folded:
    Folded in follow on "fix" patches to consolidate changes into one place.
    Includes change to drivers/base/topology.c to fix s390 build error.
    Includes change to fix preemption warning when numa_node_id is used.
    checkpatch.pl errors/warnings checked and fixed where possible.

v2: remerged PATCH 2/2 with latest x86.git/latest and sched-devel/latest,
    rebuilt and retested 4k-akpm2, 4k-defconfig, nonuma, & nosmp configs.

-- 
