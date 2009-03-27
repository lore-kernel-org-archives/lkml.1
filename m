Return-Path: <linux-kernel-owner+w=401wt.eu-S1757045AbZC0SDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757045AbZC0SDW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 14:03:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753116AbZC0SCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 14:02:47 -0400
Received: from gw.goop.org ([64.81.55.164]:58127 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751418AbZC0SCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 14:02:46 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: the arch/x86 maintainers <x86@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] Allow preemption during lazy mmu updates
Date: Fri, 27 Mar 2009 11:02:35 -0700
Message-Id: <1238176963-21093-1-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

We discussed this series a while ago.  The specific problem
was the need to disable preemption in apply_to_pte_range when using
lazy mmu updates around the callback function.  When used on usermode
addresses there was no problem because it needs to take the pte
lock anyway, but there's no requirement for taking a pte lock when
updating kernel ptes, so it ended up adding a new no-preempt region.

The gist of the series is that if we get preempted while doing an mmu
update, we flush all the pending updates and switch to the next task.
We record that the task was doing a lazy mmu update in its task flags,
and resume lazy updates when we switch back.

All the context-switch time activity happens in the existing
context-switch pvops calls, so there's no cost to non-pvops systems,
or to pvops backends which don't use lazy mmu updates.

I don't think there were any objections to this series, but Ingo would
like to see an Acked by from someone since it gets into the mm side
of things.

(The first patch in the series adds the required preempt disable/enable
and then the rest of the series removes them again.  I think the first
patch is already in mm-.)

Thanks,
	J

 arch/x86/include/asm/paravirt.h    |   22 +++++++-------
 arch/x86/include/asm/pgtable.h     |    2 +
 arch/x86/include/asm/thread_info.h |    2 +
 arch/x86/kernel/kvm.c              |    2 -
 arch/x86/kernel/paravirt.c         |   56 +++++++++++++++++--------------------
 arch/x86/kernel/process_32.c       |    2 -
 arch/x86/kernel/process_64.c       |    2 -
 arch/x86/kernel/vmi_32.c           |   20 ++++++++-----
 arch/x86/lguest/boot.c             |   16 +++++++---
 arch/x86/mm/fault.c                |    6 +--
 arch/x86/mm/highmem_32.c           |    2 -
 arch/x86/mm/iomap_32.c             |    2 -
 arch/x86/mm/pageattr.c             |   14 ---------
 arch/x86/xen/enlighten.c           |   10 ++----
 arch/x86/xen/mmu.c                 |   20 +++++--------
 arch/x86/xen/xen-ops.h             |    1 
 include/asm-frv/pgtable.h          |    4 +-
 include/asm-generic/pgtable.h      |   21 +++++++------
 kernel/sched.c                     |    2 -
 19 files changed, 96 insertions(+), 110 deletions(-)

