Return-Path: <linux-kernel-owner+w=401wt.eu-S1763293AbXF0VYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763293AbXF0VYx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 17:24:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759654AbXF0VYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 17:24:43 -0400
Received: from mail.lmcg.wisc.edu ([144.92.101.145]:44739 "EHLO
	mail.lmcg.wisc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309AbXF0VYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 17:24:42 -0400
Date: Wed, 27 Jun 2007 16:24:40 -0500
From: Daniel Forrest <forrest@lmcg.wisc.edu>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: flexible mmap layout and vdso mapping
Message-ID: <20070627162440.A12430@yoda.lmcg.wisc.edu>
Reply-To: Daniel Forrest <forrest@lmcg.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I am having a problem with memory allocation in a program when run
under Linux 2.6.18.

The program is statically linked and uses its own malloc library based
on brk().  Under previous versions of Linux it was able to allocate up
to ~3GB of memory before failing, now it fails at ~1GB.

The problem is that the vdso is mapped at 0x40000000 which limits the
heap to addresses less than 1GB.

I have tracked this down to the point that I see it is dependent on
the function arch_pick_mmap_layout(), in particular:

	if (!(2 & exec_shield) && (sysctl_legacy_va_layout ||
			(current->personality & ADDR_COMPAT_LAYOUT) ||
			current->signal->rlim[RLIMIT_STACK].rlim_cur == RLIM_INFINITY)) {
		mm->mmap_base = TASK_UNMAPPED_BASE;
		mm->get_unmapped_area = arch_get_unmapped_area;
		mm->unmap_area = arch_unmap_area;
	} else { ...


And the vdso is apparently mapped at "mm->mmap_base".


The program I have is a compiled binary and it is running through a
queueing system so modifying "/proc/sys/kernel/exec-shield" or
changing the stack limit are problematical.

Everything worked fine under Linux 2.6.9, except I notice in this case
that "cat /proc/sys/kernel/vdso" returns 0, whereas under 2.6.18 it
returns 1.


Are there any options on a per-program basis to disable vdso mapping?
Or any per-program options to change the location?  This queueing
system supports checkpointing and process migration, but that requires
that the binary not be changed so recompiling is not desirable.

-- 
Daniel K. Forrest	Laboratory for Molecular and
forrest@lmcg.wisc.edu	Computational Genomics
(608) 262 - 9479	University of Wisconsin, Madison
