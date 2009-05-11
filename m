Return-Path: <linux-kernel-owner+w=401wt.eu-S1755371AbZEKI12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371AbZEKI12 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 04:27:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754367AbZEKI1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 04:27:17 -0400
Received: from mta-2.ms.rz.RWTH-Aachen.DE ([134.130.7.73]:52334 "EHLO
	mta-2.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752936AbZEKI1Q convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 04:27:16 -0400
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
X-IronPort-AV: E=Sophos;i="4.40,327,1238968800";   d="scan'208";a="5596693"
From: Stefan Lankes <lankes@lfbs.rwth-aachen.de>
To: linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/4]: affinity-on-next-touch
Date: Mon, 11 May 2009 10:27:18 +0200
Organization: Chair for Operating Systems, RWTH Aachen University
Message-id: <000c01c9d212$4c244720$e46cd560$@rwth-aachen.de>
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AcnSEkvdIkyzGZVNS2ubuWsjFIWUaA==
Content-language: de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I wrote a patch to support the adaptive data distribution strategy
"affinity-on-next-touch" for NUMA architectures. The patch is in an early
state and I am interested in your comments.

The basic idea of "affinity-on-next-touch" is this: Via some runtime
mechanism, a user-level process activates "affinity-on-next-touch" for a
certain region of its virtual memory space. Afterwards, each page in this
region will be migrated to that node which next tries to access it.
Noordergraaf and van der Pas [1] have proposed to extend the OpenMP standard
to support this strategy. Since version 9, the “affinity-on-next-touch”
mechanism is available in Solaris and can be triggered via the madvise
system call. Löf and Homgren [2] and Terboven et al. [3] have described
their encouraging experiences with this implementation.

Linux does not yet support "affinity-on-next-touch". Terboven et al. [3]
have presented a user-level implementation of this strategy for Linux. To
realize "affinity-on-next-touch" in user space, they protect a specific
memory area from read and write accesses and install a signal handler to
catch access violations. If a thread accesses a page in the protected memory
area, the signal handler migrates the page to the node which handled the
access violation. Afterwards, the signal handler clears the page protection
and the interrupted thread is resumed. 

Unfortunately, the overhead of this solution is very high. For instance, to
distribute 512 MByte via "affinity-on-next-touch" the user-level solution
needs 2518ms on our dual-socket, quad-core Opteron 2376 system with the
current kernel (2.6.30-rc4). I evaluated this overhead with the following
OpenMP code:

   madvise(array, sizeof(int) * SIZE, MADV_ACCESS_LWP);
   start = omp_get_wtime();
   #pragma omp parallel for
   for (j = 0; j < SIZE; j += pagesize/sizeof(int))
      array[j]++;
   end = omp_get_wtime();
   printf("time: %lf ms\n", (end - start) * 1000.0);

The benchmark uses 8 threads and each thread is bound to one core.

I divide my patch into the following 4 parts:

[Patch 1/4]: Extend the system call madvise with a new parameter
MADV_ACCESS_LWP (the same as used in Solaris). The specified memory area
then uses "affinity-on-next-touch".  In this case, madvise_access_lwp
protects the memory area from read and write access. To avoid unnecessary
list operations, the patch changes the permissions only in the page table
entries and does not update the list of VMAs. Beside this, the system call
madvise set also the new “untouched bit” of the "page" record.

[Patch 2/4]: The pte fault handler detects, via a new "untouched bit" inside
of the "page" record, that the page which the thread tried to access uses
“affinity-on-next-touch”. Afterwards, the kernel reads the original
permissions from vm_area_struct, restores them in the page tables and
migrates the page to the current node. To accelerate page migration, the
patch avoids unnecessary calls to migrate_prep().

[Patch 3/4]: If the "untouched" bit is set, mprotect isn’t permitted to
change the permission in the page table entry. By using of
"affinity-on-next-touch", the access permission will be set by the pte fault
handler.

[Patch 4/4]: This part of the patch adds some counters to detect migration
errors and publishes these counters via /proc/vmstat. Besides this, the
Kconfig file is extend with the parameter CONFIG_AFFINITY_ON_NEXT_TOUCH.

With this patch, the kernel reduces the overhead of page distribution via
"affinity-on-next-touch" from 2518ms to 366ms compared to the user-level
approach. Currently, I'm evaluating the performance of the patch with some
other benchmarks and test applications (stream benchmark, Jacobi solver, PDE
solver,...).

I am very interested in your comments!

Stefan

[1] Noordergraaf, L., van der Pas, R.: Performance Experiences on Suns
WildFire Prototype. In: Proceedings of the 1999 ACM/IEEE conference on
Supercomputing,Portland, Oregon, USA (November 1999)

[2] Löf, H., Holmgren, S.: affinity-on-next-touch: Increasing the
Performance of an Industrial PDE Solver on a cc-NUMA System. In: Proceedings
of the 19th Annual International Conference on Supercomputing, Cambridge,
Massachusetts, USA (June 2005) 387–392

[3]. Terboven, C., an Mey, D., Schmidl, D., Jin, H., Reichstein, T.: Data
and Thread Affinity in OpenMP Programs. In: Proceedings of the 2008 Workshop
on Memory Access on future Processors: A solved problem?, ACM International
Conference on Computing Frontiers, Ischia, Italy (May 2008) 377–384



