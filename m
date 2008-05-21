Return-Path: <linux-kernel-owner+w=401wt.eu-S933057AbYEUCSP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933057AbYEUCSP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 22:18:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757652AbYEUCR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 22:17:57 -0400
Received: from saeurebad.de ([85.214.36.134]:33131 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757340AbYEUCR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 22:17:56 -0400
X-Mailbox-Line: From hannes@saeurebad.de Wed May 21 03:46:34 2008
Message-Id: <20080521013735.559724194@saeurebad.de>
User-Agent: quilt/0.46-1
Date: Wed, 21 May 2008 03:37:35 +0200
From: Johannes Weiner <hannes@saeurebad.de>
To: linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC 0/3] bootmem rewrite
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a complete overhaul of the bootmem allocator while preserving
its original functionality, excluding bugs.

free_bootmem and reserve_bootmem become a bit stricter than they are
right now, callsites have to make sure that the PFN range is
contiguous but it might go across node boundaries.

alloc_bootmem satisfying the allocation goal is more likely as the
routines will try to allocate on the node holding the goal first
before falling back as opposed to the original behaviour that
satisfies the goal only if it is on the first node.

All in all, I think the code has become simpler and cleaner.  All
public interfaces have been documented, too.

The first patch moves the bootmem node descriptor definitions into
bootmem.c where they belong.

The second patch is the new allocator itself.

The third patch converts all users of ->node_boot_start to
->node_min_pfn as this is what they really use.  It then removes the
unused ->node_boot_start.

Compile and runtime tested on X86_32, therefor RFC only.

 arch/alpha/mm/numa.c             |    8 +-
 arch/arm/mm/discontig.c          |   34 +-
 arch/arm/plat-omap/fb.c          |    4 +-
 arch/avr32/mm/init.c             |    3 +-
 arch/ia64/mm/discontig.c         |   30 +-
 arch/m32r/mm/discontig.c         |    4 +-
 arch/m32r/mm/init.c              |    4 +-
 arch/m68k/mm/init.c              |    4 +-
 arch/mips/sgi-ip27/ip27-memory.c |    3 +-
 arch/mn10300/mm/init.c           |    6 +-
 arch/parisc/mm/init.c            |    3 +-
 arch/powerpc/mm/numa.c           |    3 +-
 arch/sh/mm/init.c                |    2 +-
 arch/sh/mm/numa.c                |    5 +-
 arch/sparc64/mm/init.c           |    3 +-
 arch/x86/mm/discontig_32.c       |    3 +-
 arch/x86/mm/numa_64.c            |    6 +-
 include/linux/bootmem.h          |  115 ++---
 mm/bootmem.c                     |  914 +++++++++++++++++++-------------------
 mm/page_alloc.c                  |    4 +-
 20 files changed, 560 insertions(+), 598 deletions(-)

