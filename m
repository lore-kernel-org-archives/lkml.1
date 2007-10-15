Return-Path: <linux-kernel-owner+w=401wt.eu-S1763037AbXJOVwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763037AbXJOVwU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 17:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757748AbXJOVtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 17:49:51 -0400
Received: from zrnetservice.com ([209.133.52.163]:33163 "EHLO
	wifi.zrnetservice.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758220AbXJOVtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 17:49:49 -0400
Message-Id: <20071015204840.074767068@goop.org>
User-Agent: quilt/0.46-1
Date: Mon, 15 Oct 2007 13:48:40 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Keir Fraser <keir@xensource.com>,
       Stable Kernel <stable@kernel.org>
Subject: [PATCH 00/12] xen/paravirt_ops patches for 2.6.24
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here's a set of patches to update paravirt_ops and Xen for 2.6.24

A quick overview of the patchset:

paravirt_ops:
	Remove the monolithic paravirt_ops structure, and replace it with
	smaller structures of related functions.  Also, clean up the handling
	of lazy mode to make it easier to implement.

x86/mm/init.c: remove a chunk of dead code

Xen:
	- remove duplicate includes
	- yield if the target vcpu of an IPI is not currently running
	- add post-batch callbacks for multicalls [*]
	- deal with unpinning pagetables when another vcpu still [*]
	  has a cr3 reference
	- deal with split ptelocks by pinning each pte page
	  separately under lock
	- determine the kernel/hypervisor address split dynamically
	- use the right arg structure for register_vcpu_info [*]
	- add extra debugging output for failed multicalls

XFS:
	- eagerly unmap vmapped areas to avoid confict with Xen

[*] bugfix needed for 2.6.23.  I've also cc:d them to stable@kernel.org

Diffstat:
 arch/x86/kernel/alternative.c         |    4 
 arch/x86/kernel/asm-offsets_32.c      |   14 
 arch/x86/kernel/entry_32.S            |    2 
 arch/x86/kernel/paravirt_32.c         |  234 ++++++++-----
 arch/x86/kernel/vmi_32.c              |  211 ++++++------
 arch/x86/mm/init_32.c                 |   22 -
 arch/x86/xen/enlighten.c              |  295 +++++++++-------
 arch/x86/xen/mmu.c                    |  149 ++++++--
 arch/x86/xen/multicalls.c             |   52 ++
 arch/x86/xen/multicalls.h             |    5 
 arch/x86/xen/smp.c                    |   14 
 arch/x86/xen/time.c                   |    6 
 arch/x86/xen/xen-ops.h                |   10 
 drivers/char/hvc_lguest.c             |    2 
 drivers/lguest/core.c                 |    6 
 drivers/lguest/lguest.c               |  154 ++++----
 drivers/lguest/lguest_bus.c           |    2 
 fs/xfs/linux-2.6/xfs_buf.c            |   13 
 include/asm-x86/paravirt.h            |  507 ++++++++++++++++-------------
 include/asm-x86/pgtable-3level-defs.h |    2 
 include/xen/interface/vcpu.h          |    5 
 mm/Kconfig                            |    1 
 22 files changed, 1027 insertions(+), 683 deletions(-)

Thanks,
	J

