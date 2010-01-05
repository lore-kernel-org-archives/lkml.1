Return-Path: <linux-kernel-owner+w=401wt.eu-S1754701Ab0AEOOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701Ab0AEOOy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 09:14:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754611Ab0AEONj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 09:13:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42883 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754588Ab0AEONh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 09:13:37 -0500
From: Gleb Natapov <gleb@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       hpa@zytor.com, riel@redhat.com, cl@linux-foundation.org
Subject: [PATCH v3 00/12] KVM: Add host swap event notifications for PV guest
Date: Tue,  5 Jan 2010 16:12:42 +0200
Message-Id: <1262700774-1808-1-git-send-email-gleb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KVM virtualizes guest memory by means of shadow pages or HW assistance
like NPT/EPT. Not all memory used by a guest is mapped into the guest
address space or even present in a host memory at any given time.
When vcpu tries to access memory page that is not mapped into the guest
address space KVM is notified about it. KVM maps the page into the guest
address space and resumes vcpu execution. If the page is swapped out
from host memory vcpu execution is suspended till the page is not swapped
into the memory again. This is inefficient since vcpu can do other work
(run other task or serve interrupts) while page gets swapped in.

To overcome this inefficiency this patch series implements "asynchronous
page fault" for paravirtualized KVM guests. If a page that vcpu is
trying to access is swapped out KVM sends an async PF to the vcpu
and continues vcpu execution. Requested page is swapped in by another
thread in parallel.  When vcpu gets async PF it puts faulted task to
sleep until "wake up" interrupt is delivered. When the page is brought
to the host memory KVM sends "wake up" interrupt and the guest's task
resumes execution.

Changes:
 v1->v2
   Use MSR instead of hypercall.
   Move most of the code into arch independent place.
   halt inside a guest instead of doing "wait for page" hypercall if
    preemption is disabled.
 v2->v3
   Use MSR from range 0x4b564dxx.
   Add slot version tracking.
   Support migration by restarting all guest processes after migration.
   Drop patch that tract preemptability for non-preemptable kernels
    due to performance concerns. Send async PF to non-preemptable
    guests only when vcpu is executing userspace code.

Gleb Natapov (12):
  Move kvm_smp_prepare_boot_cpu() from kvmclock.c to kvm.c.
  Add PV MSR to enable asynchronous page faults delivery.
  Add async PF initialization to PV guest.
  Add "handle page fault" PV helper.
  Export __get_user_pages_fast.
  Add get_user_pages() variant that fails if major fault is required.
  Maintain memslot version number
  Inject asynchronous page fault into a guest if page is swapped out.
  Retry fault before vmentry
  Handle async PF in non preemptable context
  Let host know whether the guest can handle async PF in non-userspace
    context.
  Send async PF when guest is not in userspace too.

 arch/x86/include/asm/kvm_host.h       |   25 +++-
 arch/x86/include/asm/kvm_para.h       |   14 ++
 arch/x86/include/asm/paravirt.h       |   11 ++-
 arch/x86/include/asm/paravirt_types.h |    4 +
 arch/x86/kernel/kvm.c                 |  253 +++++++++++++++++++++++++++++++++
 arch/x86/kernel/kvmclock.c            |   13 +--
 arch/x86/kernel/paravirt.c            |    8 +
 arch/x86/kernel/paravirt_patch_32.c   |    8 +
 arch/x86/kernel/paravirt_patch_64.c   |    7 +
 arch/x86/kernel/smpboot.c             |    3 +
 arch/x86/kvm/Kconfig                  |    2 +
 arch/x86/kvm/mmu.c                    |   63 ++++++++-
 arch/x86/kvm/paging_tmpl.h            |   49 ++++++-
 arch/x86/kvm/x86.c                    |  121 +++++++++++++++-
 arch/x86/mm/fault.c                   |    3 +
 arch/x86/mm/gup.c                     |    2 +
 fs/ncpfs/mmap.c                       |    2 +
 include/linux/kvm.h                   |    1 +
 include/linux/kvm_host.h              |   29 ++++
 include/linux/kvm_para.h              |    2 +
 include/linux/mm.h                    |    5 +
 include/trace/events/kvm.h            |   60 ++++++++
 mm/filemap.c                          |    3 +
 mm/memory.c                           |   31 ++++-
 mm/shmem.c                            |    8 +-
 virt/kvm/Kconfig                      |    3 +
 virt/kvm/kvm_main.c                   |  245 +++++++++++++++++++++++++++++++-
 27 files changed, 941 insertions(+), 34 deletions(-)

